import {Router, Request, Response} from 'express';
import { UserService } from '../services/userService';
import jwt from 'jsonwebtoken';
import { UserRole } from '../entities/user';

const router = Router();
const getErrorMessage = (error: unknown): string => {
    if (error instanceof Error) return error.message;
    return String(error);
};

// ─── Middleware ───────────────────────────────────────────
const authMiddleware = (req: Request, res: Response, next: Function) => {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) return res.status(401).json({ message: 'No token provided' });
    try {
        const decoded = jwt.verify(token, process.env.JWT_ACCESS_SECRET!) as { userId: string, role: string };
        req['user'] = decoded;
        next();
    } catch {
        return res.status(401).json({ message: 'Invalid token' });
    }
};

const adminMiddleware = (req: Request, res: Response, next: Function) => {
    const user = req['user'] as { userId: string, role: string };
    if (user?.role !== UserRole.ADMIN) {
        return res.status(403).json({ message: 'Admin access required' });
    }
    next();
};

// ─── Existing routes (unchanged) ─────────────────────────
router.get('/', async (req: Request, res: Response) => {
    try {
        const users = await UserService.getAllUsers();
        return res.status(200).json(users);
    } catch (error) {
        return res.status(500).json({
        message: 'Failed to fetch users',
        error: getErrorMessage(error)
    });
    }
});

router.post('/' , async (req: Request, res: Response) => {
    try {
        const {id} = req.body;
        const user = await UserService.getUserById(id);
        return res.status(200).json(user);
    } catch (error) {
        return res.status(500).json({
        message: 'Failed to fetch user',
        error: getErrorMessage(error)
    });
    }
});

router.post('/signup', async (req: Request, res: Response) => {
    try {
        const {name, email, password} = req.body;
        const user = await UserService.createUser(name, email, password);
        return res.status(201).json(user);
    } catch (error) {
        return res.status(500).json({
        message: 'Failed to create user',
        error: getErrorMessage(error)
    });
    }
});

router.post('/login', async (req: Request, res: Response) => {
    try {
        const { email, password } = req.body;
        const { accessToken, refreshToken } = await UserService.login(email, password);
        return res.status(200).json({ accessToken, refreshToken });
    } catch (error) {
        return res.status(401).json({
            message: 'Invalid credentials',
            error: getErrorMessage(error)
        });
    }
});

router.get('/:userId/trainers', async (req: Request, res: Response) => {
    try {
        const userId = parseInt(req.params.userId);
        const selectedTrainers = await UserService.getSelectedTrainersForUser(userId);
        return res.status(200).json(selectedTrainers);
    } catch (error) {
        return res.status(500).json({
            message: 'Failed to fetch selected trainers',
            error: getErrorMessage(error)
        });
    }
});

router.get('/user/:access', async (req: Request, res: Response) => {
    try {
        const access = req.params.access as string;
        const decodedToken = jwt.verify(access, process.env.JWT_ACCESS_SECRET!) as { userId: string }
        const userId = decodedToken.userId;
        const user = await UserService.getUserById(userId);
        if (!user) return res.status(404).json({ message: 'User not found' });
        return res.status(200).json(user);
    } catch (error) {
        return res.status(500).json({
            message: 'Failed to fetch user',
            error: getErrorMessage(error)
        });
    }
});

router.post('/refresh', async (req: Request, res: Response) => {
    try {
        const refreshToken = req.headers.authorization?.split(' ')[1];
        if (!refreshToken) return res.status(401).json({ message: 'Refresh token not provided' });
        const decodedToken = jwt.verify(refreshToken, process.env.JWT_REFRESH_SECRET!) as { userId?: string };
        const userId = decodedToken.userId;
        if (!userId) return res.status(401).json({ message: 'User ID not found in token' });
        const user = await UserService.getUserById(userId);
        if (!user) return res.status(404).json({ message: 'User not found' });
        const accessToken = jwt.sign({ userId: user.id, role: user.role }, process.env.JWT_ACCESS_SECRET!, { expiresIn: process.env.JWT_ACCESS_TTL });
        return res.status(200).json({ accessToken });
    } catch (error) {
        return res.status(500).json({
            message: 'Failed to refresh access token',
            error: getErrorMessage(error)
        });
    }
});

// ─── Admin routes ─────────────────────────────────────────
router.delete('/admin/users/:id', authMiddleware, adminMiddleware, async (req: Request, res: Response) => {
    try {
        await UserService.deleteUser(parseInt(req.params.id));
        return res.status(200).json({ message: 'User deleted successfully' });
    } catch (error) {
        return res.status(500).json({
            message: 'Failed to delete user',
            error: getErrorMessage(error)
        });
    }
});

// GET /users/me
router.get('/me', authMiddleware, async (req: Request, res: Response) => {
    try {
        const userId = (req['user'] as { userId: string }).userId;
        const data = await UserService.getMyProfile(userId);
        return res.status(200).json(data);
    } catch (error) {
        return res.status(500).json({ message: 'Failed to fetch profile', error: getErrorMessage(error) });
    }
});
// ─── profile routes ─────────────────────────────────────────
export default router;
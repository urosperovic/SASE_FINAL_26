import express, {Router, Request, Response} from 'express';
import { TrainerService } from '../services/trainerService';
import jwt from 'jsonwebtoken';
import { UserService } from '../services/userService';
import { UserRole } from '../entities/user';

const router = Router();
const JWT_ACCESS_SECRET = process.env.JWT_ACCESS_SECRET
const JWT_REFRESH_SECRET = process.env.JWT_REFRESH_SECRET
const JWT_ACCESS_TTL = process.env.JWT_ACCESS_TTL
const JWT_REFRESH_TTL = process.env.JWT_REFRESH_TTL

if (!JWT_ACCESS_SECRET || !JWT_REFRESH_SECRET) {
    throw new Error('JWT secrets are not defined')
}
const getErrorMessage = (error: unknown): string => {
    if (error instanceof Error) return error.message;
    return String(error);
};

router.get('/', async (req: Request, res: Response) => {
    try {
        const users = await TrainerService.getAllTrainers();
        return res.status(200).json(users);
    } catch (error) {
        return res.status(500).json({
        message: 'Failed to fetch trainers',
        error: getErrorMessage(error)
    });
    }
});
router.post('/' , async (req: Request, res: Response) => {
    try {
        const {id} = req.body;
        const user = await TrainerService.getTrainerById(id);
        return res.status(200).json(user);
    } catch (error) {
        return res.status(500).json({
        message: 'Failed to fetch users',
        error: getErrorMessage(error)
    });
    }
});

//get timeslot by id passed in body
router.post('/timeslot', async (req: Request, res: Response) => {
    try {
        const {id} = req.body;
        const timeSlot = await TrainerService.getTimeSlotById(id);
        return res.status(200).json(timeSlot);
    } catch (error) {
        return res.status(500).json({
        message: 'Failed to get timeslot by id passed in body',
        error: getErrorMessage(error)
    });
    }
});


router.post('/signup', async (req: Request, res: Response) => {
    try {
        const { name, email, password, speciality, timeSlots } = req.body; // Added timeSlots
        const user = await TrainerService.createTrainer(name, email, password, speciality, timeSlots); // Pass timeSlots to createTrainer
        return res.status(201).json(user);
    } catch (error) {
        return res.status(500).json({
        message: 'Failed to create user',
        error: getErrorMessage(error)
    });
    }
});


//as a user pick trainer
router.post('/pick', async (req: Request, res: Response) => {
    try {
        const {trainerId,timeSlotId, userId} = req.body;
        if(!trainerId || !timeSlotId || !userId) throw new Error('TrainerId and UserId and Timeslot are required');
        
        //fetch trainer and user
        const user = await UserService.getUserById(userId);
        if(!user) throw new Error('User not found');

        const assign = await TrainerService.pickTrainer(trainerId,timeSlotId, user);
        return res.status(201).json(assign);
    } catch (error) {
        return res.status(500).json({
        message: 'Failed to assign user',
        error: getErrorMessage(error)
    });
    }
});

router.post('/unpick', async (req: Request, res: Response) => {
    try {
        const { trainerId, userId } = req.body;
        if (!trainerId || !userId) throw new Error('TrainerId and UserId are required');
        
        // Fetch user
        const user = await UserService.getUserById(userId);
        if (!user) throw new Error('User not found');

        // Unselect trainer
        await TrainerService.unpickTrainer(trainerId, user);
        
        return res.status(200).json({ message: 'Trainer unselected successfully' });
    } catch (error) {
        return res.status(500).json({
        message: 'Failed to unselect trainer',
        error: getErrorMessage(error)
    });
    }
});
// ─── Admin routes ─────────────────────────────────────────
const authMiddleware = (req: Request, res: Response, next: Function) => {
    const token = req.headers.authorization?.split(' ')[1];
    console.log('AUTH HEADER:', req.headers.authorization); // ← add this
    console.log('TOKEN:', token);     
    if (!token) return res.status(401).json({ message: 'No token provided' });
    try {
        const decoded = jwt.verify(token, JWT_ACCESS_SECRET) as { userId: string, role: string };
        console.log('Decoded token:', decoded);
        req['user'] = decoded;
        next();
    } catch(err) {
        console.log('JWT ERROR:', err); // ← add this
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

router.put('/admin/:id', authMiddleware, adminMiddleware, async (req: Request, res: Response) => {
    try {
        const { name, email, speciality, bio, timeSlots } = req.body;
        const trainer = await TrainerService.updateTrainer(parseInt(req.params.id), name, email, speciality, bio, timeSlots);
        return res.status(200).json(trainer);
    } catch (error) {
        return res.status(500).json({
        message: 'Failed to update trainer',
        error: getErrorMessage(error)
    });
    }
});

router.delete('/admin/:id', authMiddleware, adminMiddleware, async (req: Request, res: Response) => {
    try {
        await TrainerService.deleteTrainer(parseInt(req.params.id));
        return res.status(200).json({ message: 'Trainer deleted successfully' });
    } catch (error) {
        const message = error instanceof Error
            ? error.message
            : String(error);

        return res.status(500).json({
            message: 'Failed to delete trainer',
            error: message
        });
    }
});

export default router;
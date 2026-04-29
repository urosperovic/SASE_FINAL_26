import { Router, Request, Response } from 'express';
import passport from 'passport';
import jwt from 'jsonwebtoken';
import { User } from '../entities/user';

const router = Router();
const JWT_ACCESS_SECRET = process.env.JWT_ACCESS_SECRET
const JWT_REFRESH_SECRET = process.env.JWT_REFRESH_SECRET
const JWT_ACCESS_TTL = process.env.JWT_ACCESS_TTL
const JWT_REFRESH_TTL = process.env.JWT_REFRESH_TTL

if (!JWT_ACCESS_SECRET || !JWT_REFRESH_SECRET) {
    throw new Error('JWT secrets are not defined')
}
// Step 1 — redirect to Google
router.get('/google', passport.authenticate('google', {
    scope: ['profile', 'email'],
    session: false
}));

// Step 2 — Google redirects back here
router.get('/google/callback',
    passport.authenticate('google', { session: false, failureRedirect: 'https://localhost:5173/login' }),
    (req: Request, res: Response) => {
        const user = req.user as User;

        const accessToken = jwt.sign(
            { userId: user.id, role: user.role },
            JWT_ACCESS_SECRET,
            { expiresIn: JWT_ACCESS_TTL }
        );
        const refreshToken = jwt.sign(
            { userId: user.id, role: user.role },
            JWT_REFRESH_SECRET,
            { expiresIn: JWT_REFRESH_TTL }
        );

        // Redirect to frontend with tokens in query params
        res.redirect(`https://localhost:5173/auth/callback?accessToken=${accessToken}&refreshToken=${refreshToken}`);
    }
);

export default router;
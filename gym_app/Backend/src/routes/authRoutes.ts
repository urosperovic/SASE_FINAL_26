import { Router, Request, Response } from 'express';
import passport from 'passport';
import jwt from 'jsonwebtoken';
import { User } from '../entities/user';

const router = Router();

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
            process.env.JWT_ACCESS_SECRET,
            { expiresIn: process.env.JWT_ACCESS_TTL }
        );
        const refreshToken = jwt.sign(
            { userId: user.id, role: user.role },
            process.env.JWT_REFRESH_SECRET,
            { expiresIn: process.env.JWT_REFRESH_TTL }
        );

        // Redirect to frontend with tokens in query params
        res.redirect(`https://localhost:5173/auth/callback?accessToken=${accessToken}&refreshToken=${refreshToken}`);
    }
);

export default router;
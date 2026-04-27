import passport from 'passport';
import { Strategy as GoogleStrategy } from 'passport-google-oauth20';
import { createConnection, getRepository } from 'typeorm'; // ← add getRepository
import express from "express";
import dotenv from "dotenv";
import morgan from "morgan";
import cors from "cors";
import { User, UserRole } from './entities/user'; // ← add UserRole
import { Trainer } from './entities/trainer';
import userRoutes from './routes/userRoutes';
import trainerRoutes from './routes/trainerRoutes';
import authRoutes from './routes/authRoutes'; // ← add authRoutes
import { User_Trainer } from './entities/user_trainer';
import { TimeSlot } from './entities/time_slot';
import https from "https";
import fs from "fs";
import exerciseRoutes from './routes/exerciseRoutes';

dotenv.config();

passport.use(new GoogleStrategy({
    clientID: process.env.GOOGLE_CLIENT_ID,
    clientSecret: process.env.GOOGLE_CLIENT_SECRET,
    callbackURL: 'https://localhost:3000/api/auth/google/callback'
}, async (accessToken, refreshToken, profile, done) => {
    try {
        const userRepository = getRepository(User);
        let user = await userRepository.findOne({ where: { email: profile.emails[0].value } });

        if (!user) {
            // Auto-register if first time
            user = new User();
            user.name = profile.displayName;
            user.email = profile.emails[0].value;
            user.password = ''; // no password for Google users
            user.role = UserRole.USER;
            await userRepository.save(user);
        }

        return done(null, user);
    } catch (err) {
        return done(err, null);
    }
}));

createConnection({
    type: 'mysql',
    host: process.env.DB_HOST,
    port: Number.parseInt(process.env.DB_PORT || '3306'),
    username: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    entities: [User, Trainer, User_Trainer, TimeSlot],
    synchronize: true, // ← add this
    

}).then(connection => {
    console.log('Connected to database successfully!');

    const app = express();
    app.use(express.json());
    app.use(cors());
    app.use(morgan("dev"));
    app.use(passport.initialize());


    const port = process.env.PORT || 3000;

    // Load SSL certificates
    const sslOptions = {
        key : fs.readFileSync('./localhost+1-key.pem'),
        cert : fs.readFileSync('./localhost+1.pem'),
    };

    app.use('/api/users', userRoutes);
    app.use('/api/trainer', trainerRoutes);
    app.use('/api/exercises', exerciseRoutes);
    app.use('/api/auth', authRoutes);

    https.createServer(sslOptions, app).listen(port, () => {
        console.log(`HTTPS Server is running on port ${port}`);
    });

}).catch(error => {
    console.error('Error connecting to database:', error);
});
import { createConnection } from 'typeorm';
import express from "express";
import dotenv from "dotenv";
import morgan from "morgan";
import cors from "cors";
import { User } from './entities/user';
import { Trainer } from './entities/trainer';
import userRoutes from './routes/userRoutes';
import trainerRoutes from './routes/trainerRoutes';
import { User_Trainer } from './entities/user_trainer';
import { TimeSlot } from './entities/time_slot';
import https from "https";
import fs from "fs";

dotenv.config();

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

    const port = process.env.PORT || 3000;

    // Load SSL certificates
    const sslOptions = {
        key : fs.readFileSync('./localhost+1-key.pem'),
        cert : fs.readFileSync('./localhost+1.pem'),
    };

    app.use('/api/users', userRoutes);
    app.use('/api/trainer', trainerRoutes);

    https.createServer(sslOptions, app).listen(port, () => {
        console.log(`HTTPS Server is running on port ${port}`);
    });

}).catch(error => {
    console.error('Error connecting to database:', error);
});
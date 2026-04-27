import { Router, Request, Response } from 'express';
import axios from 'axios';

const router = Router();

router.get('/', async (req: Request, res: Response) => {
    try {
        console.log('RAPIDAPI_KEY:', process.env.RAPIDAPI_KEY)
        const { search, bodyPart, limit = 20, offset = 0 } = req.query;

        let url = `https://exercisedb.p.rapidapi.com/exercises?limit=${limit}&offset=${offset}`;

        if (bodyPart) {
            url = `https://exercisedb.p.rapidapi.com/exercises/bodyPart/${bodyPart}?limit=${limit}&offset=${offset}`;
        }
        if (search) {
            url = `https://exercisedb.p.rapidapi.com/exercises/name/${search}?limit=${limit}&offset=${offset}`;
        }

        const response = await axios.get(url, {
            headers: {
                'x-rapidapi-host': 'exercisedb.p.rapidapi.com',
                'x-rapidapi-key': process.env.RAPIDAPI_KEY
            }
        });

        return res.status(200).json(response.data);
    } catch (error) {
        console.error('FULL EXERCISE ERROR:', error);
        res.status(500).json({ message: 'Failed to fetch exercises', error: error.message });
    }
});

router.get('/bodyparts', async (req: Request, res: Response) => {
    try {
        const response = await axios.get('https://exercisedb.p.rapidapi.com/exercises/bodyPartList', {
            headers: {
                'x-rapidapi-host': 'exercisedb.p.rapidapi.com',
                'x-rapidapi-key': process.env.RAPIDAPI_KEY
            }
        });
        return res.status(200).json(response.data);
    } catch (error) {
        res.status(500).json({ message: 'Failed to fetch body parts', error: error.message });
    }
});

export default router;
import axios from 'axios';

const client = axios.create({
    baseURL: 'https://localhost:3000/api/exercises',
    headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
    }
});

export class ExerciseService {
    static async getExercises(search?: string, bodyPart?: string, limit = 20, offset = 0) {
        const params: any = { limit, offset };
        if (search) params.search = search;
        if (bodyPart) params.bodyPart = bodyPart;
        return client.get('/', { params });
    }

    static async getBodyParts() {
        return client.get('/bodyparts');
    }
}
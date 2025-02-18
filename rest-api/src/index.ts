import express from 'express';
import dotenv from 'dotenv';
import { Pool } from 'pg';
import routes from './routes';

// Load environment variables from .env file
dotenv.config();

// Create the Express application and init the port
const app = express();
const port = process.env.PORT ?? 3000;

// Middleware to parse JSON bodies
app.use(express.json());

// Routes
app.use('/users', routes);

// Connect to the PostgreSQL database
const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
});

// Start the server
app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});

export { pool };
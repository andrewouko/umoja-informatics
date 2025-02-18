-- Create the users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(50) NOT NULL
);

-- Insert initial data into the users table
INSERT INTO users (name, email, role) VALUES
('Kamau', 'kamau@example.com', 'author'),
('Omondi', 'omondi@example.com', 'user'),
('Maina', 'maina@example.com', 'author'),
('David', 'david@example.com', 'user');
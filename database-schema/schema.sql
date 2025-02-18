-- Enum for user roles
CREATE TYPE IF NOT EXISTS user_role AS ENUM ('author', 'user');

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role user_role NOT NULL
);

-- Articles table
CREATE TABLE IF NOT EXISTS articles (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    author_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Comments table
CREATE TABLE IF NOT EXISTS comments (
    id SERIAL PRIMARY KEY,
    article_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    comment_text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Insert data into the users table
INSERT INTO users (name, email, role) VALUES
('Kamau', 'kamau@example.com', 'author'),
('Omondi', 'omondi@example.com', 'user'),
('Maina', 'maina@example.com', 'author'),
('David', 'david@example.com', 'user');
ON CONFLICT (email) DO NOTHING;

-- Insert data into the articles table
INSERT INTO articles (title, content, author_id) VALUES
('First Article', 'This is the content of the first article.', 1),
('Second Article', 'This is the content of the second article.', 3),
('Third Article', 'This is the content of the third article.', 1),
('Fourth Article', 'This is the content of the fourth article.', 3),
('Fifth Article', 'This is the content of the fifth article.', 1),
('Sixth Article', 'This is the content of the sixth article.', 3),
('Seventh Article', 'This is the content of the seventh article.', 1),
('Eighth Article', 'This is the content of the eighth article.', 3),
('Ninth Article', 'This is the content of the ninth article.', 1),
('Tenth Article', 'This is the content of the tenth article.', 3);

-- Insert data into the comments table
INSERT INTO comments (article_id, user_id, comment_text) VALUES
(1, 2, 'This is a comment on the first article by Omondi.'),
(1, 4, 'This is another comment on the first article by David.'),
(1, 1, 'This is a comment on the first article by Kamau.'),
(1, 3, 'This is a comment on the first article by Maina.'),
(2, 2, 'This is a comment on the second article by Omondi.'),
(2, 4, 'This is another comment on the second article by David.'),
(2, 1, 'This is a comment on the second article by Kamau.'),
(2, 3, 'This is a comment on the second article by Maina.'),
(3, 2, 'This is a comment on the third article by Omondi.'),
(3, 4, 'This is another comment on the third article by David.'),
(3, 1, 'This is a comment on the third article by Kamau.'),
(3, 3, 'This is a comment on the third article by Maina.'),
(4, 2, 'This is a comment on the fourth article by Omondi.'),
(4, 4, 'This is another comment on the fourth article by David.'),
(4, 1, 'This is a comment on the fourth article by Kamau.'),
(4, 3, 'This is a comment on the fourth article by Maina.'),
(5, 2, 'This is a comment on the fifth article by Omondi.'),
(5, 4, 'This is another comment on the fifth article by David.'),
(5, 1, 'This is a comment on the fifth article by Kamau.'),
(5, 3, 'This is a comment on the fifth article by Maina.'),
(6, 2, 'This is a comment on the sixth article by Omondi.'),
(6, 4, 'This is another comment on the sixth article by David.'),
(6, 1, 'This is a comment on the sixth article by Kamau.'),
(6, 3, 'This is a comment on the sixth article by Maina.'),
(7, 2, 'This is a comment on the seventh article by Omondi.'),
(7, 4, 'This is another comment on the seventh article by David.'),
(7, 1, 'This is a comment on the seventh article by Kamau.'),
(7, 3, 'This is a comment on the seventh article by Maina.'),
(8, 2, 'This is a comment on the eighth article by Omondi.'),
(8, 4, 'This is another comment on the eighth article by David.'),
(8, 1, 'This is a comment on the eighth article by Kamau.'),
(8, 3, 'This is a comment on the eighth article by Maina.'),
(9, 2, 'This is a comment on the ninth article by Omondi.'),
(9, 4, 'This is another comment on the ninth article by David.'),
(9, 1, 'This is a comment on the ninth article by Kamau.'),
(9, 3, 'This is a comment on the ninth article by Maina.'),
(10, 2, 'This is a comment on the tenth article by Omondi.'),
(10, 4, 'This is another comment on the tenth article by David.'),
(10, 1, 'This is a comment on the tenth article by Kamau.'),
(10, 3, 'This is a comment on the tenth article by Maina.');
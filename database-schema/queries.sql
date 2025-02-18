-- All articles with their authors
SELECT 
    articles.id AS article_id,
    articles.title,
    articles.content,
    users.name AS author_name,
    users.email AS author_email,
    articles.created_at,
    articles.updated_at
FROM 
    articles
JOIN 
    users ON articles.author_id = users.id;

-- Count number of comments on each article
SELECT 
    articles.id AS article_id,
    articles.title,
    COUNT(comments.id) AS number_of_comments 
FROM 
    articles 
LEFT JOIN
    comments ON articles.id = comments.article_id 
GROUP BY 
    articles.id 
ORDER BY 
    number_of_comments DESC;

-- Fetch the latest 5 articles
SELECT 
    articles.id AS article_id,
    articles.title,
    articles.content,
    users.name AS author_name,
    users.email AS author_email,
    articles.created_at,
    articles.updated_at 
FROM 
    articles 
JOIN 
    users ON articles.author_id = users.id 
ORDER BY 
    articles.created_at DESC 
LIMIT 5;
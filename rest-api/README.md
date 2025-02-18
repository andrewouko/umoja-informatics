# Simple Express REST API

## Overview

This project is a REST API built using ExpressJs and Postgres.

## Features

- CRUD operations for a users table

## Technologies Used

- Express.js
- Postgres
- Docker

## Configuration

Create a `.env` file in the root directory. Use the `.env.example` as a guide.

## Docker compose

1. Build

    ```bash
    docker-compose build --no-cache
    ```

2. Navigate to the project directory:

    ```bash
    docker-compose up
    ```

## Sample API Responses

### `GET /users` - Get all users

```json
{
    "status": 200,
    "count": 4,
    "data": [
        {
            "id": 1,
            "name": "Kamau",
            "email": "kamau@example.com",
            "role": "author"
        },
        {
            "id": 2,
            "name": "Omondi",
            "email": "omondi@example.com",
            "role": "user"
        },
        {
            "id": 3,
            "name": "Maina",
            "email": "maina@example.com",
            "role": "author"
        },
        {
            "id": 4,
            "name": "David",
            "email": "david@example.com",
            "role": "user"
        }
    ]
}
```

### `GET /users/:id` - Get a user by ID

```json
{
    "status": 200,
    "data": {
        "id": 1,
        "name": "Kamau",
        "email": "kamau@example.com",
        "role": "author"
    }
}
```

### `POST /users/:id` - Create a new user

```json
{
    "id": 5,
    "name": "Andrew",
    "email": "test@example.com",
    "role": "author"
}
```

### `PUT /users/:id` - Update a user by ID

```json
{
    "id": 5,
    "name": "Andrew",
    "email": "test@example.com",
    "role": "author"
}
```

### `DELETE /api/users/:id` - Delete a user by ID

```json
{
    "message": "User deleted successfully"
}
```

### Error Response Format

```json
{
    "error": "The role should be one of the following: author, user."
}
```

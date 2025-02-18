import { NextFunction, Request, Response } from "express";
import { pool } from "./index";
import { handleError } from "./utils";
import { Role, User } from "./types";

const queryUsers = async (params: {
  id?: string;
  filter?: Partial<User>;
}): Promise<User[]> => {
  const { id, filter } = params;
  // If both an ID and params are provided, throw an error
  if (id && filter) throw new Error("You can't provide both an ID and params");

  // Prepare the query
  let query = "SELECT * FROM users";
  const values: unknown[] = [];

  // If an ID is provided, return the user with that ID
  if (id) {
    query += " WHERE id = $1";
    values.push(id);
  }

  // If params are provided, filter the users based on the params
  if (filter) {
    if (Object.keys(filter).length > 0) {
      const keys = Object.keys(filter);
      query += " WHERE ";
      query += keys
        .map((key, index) => {
          values.push(filter[key as keyof User]);
          return `${key} = $${index + 1}`;
        })
        .join(" AND ");
    }
  }

  const result = await pool.query<User>(query, values);
  return result.rows;
};

const validateRole = (role: string | undefined): string | undefined => {
  if (role && !Object.values(Role).includes(role as Role)) {
    return `The role should be one of the following: ${Object.values(Role).join(
      ", "
    )}.`;
  }
  return undefined;
};

const validateUserPayload = (payload: Partial<User>): string | undefined => {
  const { name, email, role } = payload;
  const requiredFields = { name, email, role };
  const missingFields = Object.keys(requiredFields).filter(
    (key) => !requiredFields[key as keyof typeof requiredFields]
  );

  if (missingFields.length > 0) {
    return `The request payload is missing the following fields: ${missingFields.join(
      ", "
    )}.`;
  }

  return validateRole(role);
};

export const getUsers = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const users = await queryUsers({});
    res.status(200).json({
      status: 200,
      count: users.length,
      data: users,
    });
  } catch (error) {
    return handleError(error as Error, req, res);
  }
};

export const getUser = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const users = await queryUsers({
      id: req.params.id,
    });
    if(users.length === 0) {
        return res.status(404).json({ error: "User not found" });
    }
    res.status(200).json({
      status: 200,
      data: users[0],
    });
  } catch (error) {
    return handleError(error as Error, req, res);
  }
};

export const createUser = async (req: Request, res: Response) => {
  const requestBody = req.body as User;
  const { name, email, role } = requestBody;

  if (!req.body) {
    return res.status(400).json({ error: "Request payload is missing" });
  }
  const validationError = validateUserPayload(requestBody);
  if (validationError) {
    return res.status(400).json({ error: validationError });
  }

  try {
    const existingUsers = await queryUsers({
      filter: { email },
    });
    if (existingUsers.length > 0) {
      return res
        .status(409)
        .json({ error: "A user with this email already exists." });
    }
    const result = await pool.query(
      "INSERT INTO users (name, email, role) VALUES ($1, $2, $3) RETURNING *",
      [name, email, role]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    return handleError(error as Error, req, res);
  }
};

export const updateUser = async (req: Request, res: Response) => {
  const { id } = req.params;
  if (!id) {
    return res.status(400).json({ error: "The id request param is missing." });
  }

  const requestBody = req.body as Partial<User>;
  if (!requestBody) {
    return res.status(400).json({ error: "Request payload is missing" });
  }
  const { name, email, role } = requestBody;

  const validationError = validateRole(role);
  if (validationError) {
    return res.status(400).json({ error: validationError });
  }

  try {
    const existingUsers = await queryUsers({
      filter: { email },
    });
    if (existingUsers.length > 0) {
      return res
        .status(409)
        .json({ error: "A user with this email already exists." });
    }
    // Dynamically construct the update query based on the provided fields
    const fields = [];
    const values = [];
    let index = 1;

    if (name) {
      fields.push(`name = $${index++}`);
      values.push(name);
    }
    if (email) {
      fields.push(`email = $${index++}`);
      values.push(email);
    }
    if (role) {
      fields.push(`role = $${index++}`);
      values.push(role);
    }

    if (fields.length === 0) {
      return res.status(400).json({ error: "No fields to update" });
    }

    values.push(id);
    const query = `UPDATE users SET ${fields.join(", ")} WHERE id = $${
      values.length
    } RETURNING *`;

    const result = await pool.query(query, values);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: "User not found" });
    }
    res.status(200).json(result.rows[0]);
  } catch (error) {
    return handleError(error as Error, req, res);
  }
};

export const deleteUser = async (req: Request, res: Response) => {
  const { id } = req.params;
  if (!id) {
    return res.status(400).json({ error: "The id request param is missing." });
  }

  try {
    const result = await pool.query(
      "DELETE FROM users WHERE id = $1 RETURNING *",
      [id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: "User not found" });
    }
    res.status(200).json({ message: "User deleted successfully" });
  } catch (error) {
    return handleError(error as Error, req, res);
  }
};

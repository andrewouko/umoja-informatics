import { Request, Response } from "express";

export class AppError extends Error {
  statusCode: number;

  constructor(message: string, statusCode: number) {
    super(message);
    this.statusCode = statusCode;
    Error.captureStackTrace(this, this.constructor);
  }
}

export const handleError = (
  err: Error | AppError,
  req: Request,
  res: Response
) => {
  // Default status code for unhandled errors
  const statusCode = err instanceof AppError ? err.statusCode : 500;

  // Default error message
  const message =
    err instanceof AppError ? err.message : "Internal Server Error";

  // Log the error
  console.error(
    JSON.stringify(
      {
        errorMessage: err.message,
        errorStack: err.stack,
        requestHeaders: req.headers,
        requestBody: req.body,
        requestParams: req.params,
      },
      null,
      2
    )
  );

  // Send the error response
  return res.status(statusCode).json({ error: message });
};

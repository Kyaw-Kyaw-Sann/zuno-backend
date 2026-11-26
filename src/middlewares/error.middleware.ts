import type { ErrorRequestHandler } from "express";
import { AppError } from "../utils/app.error.js";

const clientErrors: Partial<
  Record<number, { code: string; message: string }>
> = {
  400: {
    code: "BAD_REQUEST",
    message: "Could not read the request body.",
  },
  413: {
    code: "PAYLOAD_TOO_LARGE",
    message: "Request body is too large.",
  },
  415: {
    code: "UNSUPPORTED_MEDIA_TYPE",
    message: "Unsupported request body encoding.",
  },
};

export const errorHandler: ErrorRequestHandler = (
  error: unknown,
  req,
  res,
  next,
) => {
  if (res.headersSent) {
    next(error);
    return;
  }

  // Application errors
  if (error instanceof AppError) {
    res.status(error.statusCode).json({
      success: false,
      error: {
        code: error.code,
        message: error.message,
      },
    });
    return;
  }

  // Known client errors
  const status =
    typeof error === "object" &&
    error !== null &&
    "status" in error &&
    typeof error.status === "number"
      ? error.status
      : 500;

  const clientError = clientErrors[status];

  if (clientError) {
    res.status(status).json({
      success: false,
      error: clientError,
    });
    return;
  }

  // Unexpected server errors
  console.error("Unhandled request error", {
    method: req.method,
    name: error instanceof Error ? error.name : "UnknownError",
  });

  res.status(500).json({
    success: false,
    error: {
      code: "INTERNAL_SERVER_ERROR",
      message: "An unexpected error occurred.",
    },
  });
};
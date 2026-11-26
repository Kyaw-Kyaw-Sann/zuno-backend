import express from "express";
import { errorHandler } from "./middlewares/error.middleware.js";

export const app = express();

app.use(express.json());

app.get('/api/health', (_req, res) => {
    res.status(200).json({
        message: "Server is health..."
    })
})

// Add API routers above this fallback.
app.use((_req, res) => {
  res.status(404).json({
    success: false,
    error: {
      code: "NOT_FOUND",
      message: "Route not found.",
    },
  });
});

app.use(errorHandler);
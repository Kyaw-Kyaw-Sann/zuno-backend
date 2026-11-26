import express from "express";
import request from "supertest";
import { describe, it } from "vitest";
import { app } from "../src/app.js";
import { errorHandler } from "../src/middlewares/error.middleware.js";
import { AppError } from "../src/utils/app.error.js";

describe("Express foundation", () => {
  it("responds to the health check", async () => {
    await request(app).get("/api/health").expect(200);
  });

  it("returns JSON for an unknown route", async () => {
    await request(app).get("/api/v1/unknown").expect(404, {
      success: false,
      error: { code: "NOT_FOUND", message: "Route not found." },
    });
  });

  it("returns 400 for malformed JSON", async () => {
    await request(app)
      .post("/api/v1/unknown")
      .type("json")
      .send("{")
      .expect(400, {
        success: false,
        error: { code: "BAD_REQUEST", message: "Could not read the request body." },
      });
  });

  it("returns the public message from an AppError", async () => {
    const testApp = express();
    testApp.get("/", async () => {
      throw new AppError("Email already exists.", 409, "EMAIL_ALREADY_EXISTS");
    });
    testApp.use(errorHandler);

    await request(testApp).get("/").expect(409, {
      success: false,
      error: { code: "EMAIL_ALREADY_EXISTS", message: "Email already exists." },
    });
  });

  it("returns a generic message for an unexpected error", async () => {
    const testApp = express();
    testApp.get("/", async () => {
      throw new Error("Internal test message");
    });
    testApp.use(errorHandler);

    await request(testApp).get("/").expect(500, {
      success: false,
      error: {
        code: "INTERNAL_SERVER_ERROR",
        message: "An unexpected error occurred.",
      },
    });
  });
});
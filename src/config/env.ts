import "dotenv/config";
import { z } from "zod";

const envSchema = z.object({
  PORT: z
    .string()
    .regex(/^\d+$/)
    .transform(Number)
    .pipe(z.number().int().min(1).max(65535))
    .default(3000),
  DATABASE_URL: z.string().min(1),
});

const result = envSchema.safeParse(process.env);

if (!result.success) {
  throw new Error("Invalid environment configuration. Check PORT and DATABASE_URL.");
}

export const env = result.data;
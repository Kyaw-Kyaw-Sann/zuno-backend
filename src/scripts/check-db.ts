import { prisma } from "../lib/prisma.js";

try {
  const planCount = await prisma.plan.count();
  console.log(`Database connected. Plans: ${planCount}`);
} finally {
  await prisma.$disconnect();
}
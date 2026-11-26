import { prisma } from "../src/lib/prisma.js";

async function main() {
  await prisma.plan.upsert({
    where: { code: "FREE" },
    update: {},
    create: {
      code: "FREE",
      name: "Free",
      maxProjects: 3,
      maxMembers: 5,
      maxTasks: 100,
    },
  });

  await prisma.plan.upsert({
    where: { code: "PRO" },
    update: {},
    create: {
      code: "PRO",
      name: "Pro",
      maxProjects: 20,
      maxMembers: 25,
      maxTasks: 1000,
    },
  });

    const templates = [
    {
      code: "BLANK",
      name: "Blank Project",
      description: "A simple workflow for any project",
      configuration: {
        statuses: ["To Do", "In Progress", "Done"],
      },
    },
    {
      code: "SOFTWARE_DEVELOPMENT",
      name: "Software Development",
      description: "Standard development workflow",
      configuration: {
        statuses: ["To Do", "In Progress", "In Review", "Done"],
      },
    },
    {
      code: "BUG_TRACKING",
      name: "Bug Tracking",
      description: "A workflow for tracking bugs",
      configuration: {
        statuses: ["Open", "In Progress", "Resolved", "Closed"],
      },
    },
  ] as const;

  for (const template of templates) {
    await prisma.projectTemplate.upsert({
      where: { code: template.code },
      update: {},
      create: {
        ...template,
        configuration: {
          statuses: [...template.configuration.statuses],
        },
      },
    });
  }

  console.log("Plans and project templates are ready.");
}

try {
  await main();
} catch {
 console.error("Database seed failed.");
  process.exitCode = 1;
} finally {
  await prisma.$disconnect();
}
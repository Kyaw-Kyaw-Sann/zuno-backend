# Zuno Backend

Zuno is a workspace-based project management app for software development teams. This repository contains its Express and TypeScript API. The React frontend lives in a separate repository.

**This project is still in development.** The backend currently includes a health check, startup configuration, and JSON error handling. Workspace, project, and task features are planned.

## Run locally

Use Node.js 22.15 or later in the 22.x line and npm. The current API can run without a database.

```sh
npm ci
npm run dev
```

Open `http://localhost:3000/api/health` and expect HTTP `200`. To use a different port, create a local `.env` from `.env.example` and set `PORT`.

## Check and build

```sh
npm run typecheck
npm test
npm run build
```

Run `npm start` to serve the compiled API after building.

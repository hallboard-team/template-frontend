## Overview

This template bootstraps an Angular workspace that already contains `dashboard` and `landing` applications plus reusable `tool` and `ui` libraries. It is wired for fast local development with PNPM, Angular CLI 21, and a ready-to-use Dev Container powered by Hallboard's `ghcr.io/hallboard-team/node-angular` image.

## Project layout

- `client/` – Angular workspace root. Run all CLI commands from here.
- `client/projects/dashboard` – SPA dashboard application.
- `client/projects/landing` – SSR-ready landing application.
- `client/projects/ui` and `client/projects/tool` – shareable component/util libraries.

## Prerequisites

- [PNPM](https://pnpm.io/) 10.x (`corepack enable` is recommended).
- Node.js 20+ locally **or** Docker with the `ghcr.io/hallboard-team/node-angular` image.

Install dependencies once:

```bash
cd client
pnpm install
```

## Local development (without Docker)

- Serve Dashboard SPA: `pnpm ng serve dashboard` → http://localhost:4200
- Serve Landing SPA: `pnpm ng serve landing` → http://localhost:4201
- Run unit tests (Vitest): `pnpm ng test`
- Build for production: `pnpm ng build <project-name>`
- Run Landing SSR server after building: `pnpm run serve:ssr:landing`

## Dev Container / Docker usage

Two devcontainer definitions live in `.devcontainer/`:

- `frontend-dashboard` – opens VS Code against the dashboard project on port 4200.
- `frontend-landing` – opens VS Code against the landing project on port 4201.

Both reuse the shared compose files in `.devcontainer/docker/`.

### Image format

The container image uses the new tag pattern:

```
docker pull ghcr.io/hallboard-team/node-angular:24-21
```

In `docker-compose.*.yml` this is parameterised as:

```yaml
image: ghcr.io/hallboard-team/node-angular:${NODE_VERSION:-24}-${ANGULAR_VERSION:-21}
```

Set `NODE_VERSION` or `ANGULAR_VERSION` environment variables (e.g. in `.env`) if you need different versions.

### Running the compose file manually

```bash
cd .devcontainer/docker
docker compose -f docker-compose.dashboard.yml up -d
```

The repo is mounted into `/workspaces/app`, so you can run Angular CLI commands inside the container from `/workspaces/app/client`.

## Customising the template

- Add or rename projects via `pnpm ng g application`.
- Extend shared libraries in `projects/ui` or `projects/tool` for components/utilities reused between apps.
- Update `.vscode` or `.devcontainer` settings to match your preferred tooling.

Happy building!

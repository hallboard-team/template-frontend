# Project Notes (Humans + Agents)

Use this file to capture repo-specific conventions for both humans and coding agents.

## Devcontainer Compose
- The devcontainer compose files live in `.devcontainer/docker/`.
- Keep `docker-compose.dashboard.yml` and `docker-compose.landing.yml` in sync for shared settings.
- Preserve the Codex cache mount (`${HOME}/.cache/codex:/root/.codex:Z`) and `CODEX_HOME=/root/.codex` so login state persists.

## Frontend Versions
- The Node/Angular image tags are driven by `NODE_VERSION` and `ANGULAR_VERSION` environment variables.
- If you bump versions, update both compose files consistently.

## Ports
- Dashboard defaults to `4200` (`PORT_DASHBOARD`).
- Landing defaults to `4201` host → `4200` container (`PORT_LANDING`).

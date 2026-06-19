# apps/resume/Dockerfile

FROM node:20-alpine AS builder

# Enable pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /app

# Copy the entire monorepo (required for pnpm workspaces)
COPY . .

# Move into the Next.js app
WORKDIR /app/apps/resume

# pnpm must run in CI mode inside Docker
ENV CI=true
RUN pnpm install -r --frozen-lockfile

# Build the Next.js standalone output
RUN pnpm build


# --- Production image ---
FROM node:20-alpine AS production

WORKDIR /app

# Copy standalone server
COPY --from=builder /app/apps/resume/.next/standalone ./

# Copy static assets
COPY --from=builder /app/apps/resume/.next/static ./apps/resume/.next/static

# Copy public folder
COPY --from=builder /app/apps/resume/public ./apps/resume/public

EXPOSE 3000

CMD ["node", "server.js"]

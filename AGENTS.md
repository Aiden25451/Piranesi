# Piranesi Monorepo

## Overview

A pnpm workspace monorepo containing a serverless landing page and a Next.js resume site, deployed on AWS via Terraform.

---

## Root Structure

```
Piranesi/
├── .github/workflows/deploy.yml    # CI/CD: push to main -> build landing -> terraform apply
├── apps/
│   ├── landing/                     # Hono.js serverless app (AWS Lambda)
│   └── resume/                      # Next.js resume site
├── infra/                           # Terraform (AWS: API Gateway + Lambda)
├── package.json                     # Root scripts: dev, build, deploy (all target 'landing')
├── pnpm-workspace.yaml              # Workspace: apps/*, packages/*
└── README.md
```

**Root scripts** (all operate on `landing`):
- `pnpm dev` — run landing dev server
- `pnpm build` — bundle landing with esbuild
- `pnpm deploy` — build -> zip -> upload to AWS Lambda

---

## Apps

### `apps/landing/` — Serverless Landing Page

| Aspect          | Detail                                     |
|-----------------|--------------------------------------------|
| **Framework**   | Hono v4 (lightweight web framework)        |
| **Runtime**     | Node.js 20 (ESM) on AWS Lambda             |
| **Build**       | esbuild v0.21.4                            |
| **Dev server**  | tsx watch + @hono/node-server on :3000     |
| **Auth**        | Auth0 SPA JS v2.18 (client-side OIDC)      |
| **Lambda**      | Exported via `hono/aws-lambda` adapter     |

**Files:**
```
apps/landing/
├── src/
│   ├── index.ts         # Hono app: error handler, GET / -> serveStatic(public/landing/index.html), handler export
│   └── dev.ts           # Local dev server on port 3000
├── public/landing/
│   └── index.html       # Auth0-protected SPA (login/signup/profile views)
├── package.json
└── tsconfig.json        # ESNext target, Bundler resolution, hono/jsx
```

**Routes:** `GET /` — serves the static landing page (only route).

---

### `apps/resume/` — Next.js Resume Site

| Aspect          | Detail                                     |
|-----------------|--------------------------------------------|
| **Framework**   | Next.js 16.2.9 (App Router)                |
| **UI**          | React 19.2.4                               |
| **Styling**     | Tailwind CSS v4 + PostCSS                  |
| **Fonts**       | Geist / Geist Mono (next/font/google)      |
| **Linting**     | ESLint v9 + eslint-config-next             |

**Files:**
```
apps/resume/
├── app/
│   ├── layout.tsx       # Root layout (Geist fonts, dark mode support)
│   ├── page.tsx         # Home page ("Welcome to my resume site")
│   └── globals.css      # Tailwind v4 import, light/dark CSS variables
├── public/              # SVG icons + favicon
├── next.config.ts       # Default (no custom options)
├── postcss.config.mjs   # @tailwindcss/postcss
└── eslint.config.mjs    # Flat config with core-web-vitals + typescript
```

> **Note:** Currently a `create-next-app` scaffold with placeholder content.

---

## Infrastructure (`infra/`)

Terraform (>= 1.6.0, AWS provider ~> 5.0) provisioning:

1. **S3 backend** — state stored in `piranesi-terraform-state` (us-east-1)
2. **IAM** — role `piranesi-lambda-exec` with `AWSLambdaBasicExecutionRole`
3. **Lambda** — `PiranesiLambda` (Node.js 20.x, 128MB, 3s timeout, handler: `index.handler`)
4. **API Gateway v2 (HTTP)** — `PiranesiGateway` with `$default` route -> Lambda proxy, auto-deploy

**Deployment flow:** CI pushes `lambda.zip` into `infra/`, then `terraform apply`.

---

## CI/CD (GitHub Actions)

- **Trigger:** push to `main`
- **Auth:** OIDC to AWS IAM role `PiranesiLambdaDeployRole`
- **Steps:** checkout -> AWS creds -> terraform setup -> pnpm install -> build + zip landing -> terraform init & apply

---

## Tech Stack Summary

| Layer           | Technology                              |
|-----------------|-----------------------------------------|
| **Monorepo**    | pnpm v10.17.1                           |
| **App 1**       | Hono v4, esbuild, Auth0, AWS Lambda     |
| **App 2**       | Next.js 16, React 19, Tailwind CSS v4   |
| **Infra**       | Terraform 1.7+, AWS (API GW v2, Lambda) |
| **CI/CD**       | GitHub Actions + OIDC                   |

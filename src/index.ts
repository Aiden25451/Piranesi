import { Hono } from "hono";
import { handle } from "hono/aws-lambda";
import { serveStatic } from "hono/serve-static";
import fs from "node:fs/promises";

const app = new Hono();

app.onError((err, c) => {
  console.error(`[SERVER ERROR] ${c.req.method} ${c.req.url}`);
  console.error(err.stack || err.message);

  return c.json(
    {
      success: false,
      message: err.message || "Internal Server Error",
    },
    500,
  );
});

app.get(
  "/",
  serveStatic({
    path: "./public/landing/index.html",
    getContent: async (path) => {
      return await fs.readFile(path);
    },
  }),
);

export const handler = handle(app);

export default app;

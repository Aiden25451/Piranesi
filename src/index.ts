import { Hono } from "hono";
import { handle } from "hono/aws-lambda";
import { promises as fs } from "fs";

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

app.get("/", async (c) => {
  const htmlContent = await fs.readFile("./src/landing/index.html", "utf-8");

  return c.html(htmlContent);
});

export const handler = handle(app);

export default app;

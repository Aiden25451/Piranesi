import { Hono } from "hono";
import { handle } from "hono/aws-lambda";

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

app.get("/", (c) => {
  return c.text("Hello Hono!");
});

export const handler = handle(app);

export default app;

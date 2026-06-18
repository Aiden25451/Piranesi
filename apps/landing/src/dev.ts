import { serve } from "@hono/node-server";
import app from "./index";

const port = 3000;

console.log(`Local dev server running at http://localhost:${port}`);

serve({
  fetch: app.fetch,
  port: port,
});

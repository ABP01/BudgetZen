import { neon } from "@neondatabase/serverless";
import "dotenv/config";

// Parse and clean DATABASE_URL
let databaseUrl = process.env.DATABASE_URL;
if (!databaseUrl) {
  throw new Error("DATABASE_URL is not set");
}
if (databaseUrl.startsWith("psql")) {
  const firstSpaceIndex = databaseUrl.indexOf(" ");
  databaseUrl = databaseUrl.substring(firstSpaceIndex + 1).trim();
  databaseUrl = databaseUrl.replace(/^['"]+|['"]+$/g, "");
}

export const sql = neon(databaseUrl);
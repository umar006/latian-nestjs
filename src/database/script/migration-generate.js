#!/usr/bin/env node

const yargs = require("yargs");
const { execSync } = require("child_process");

// Parse the command-line arguments
const {
  _: [name],
} = yargs.argv;

// Construct the migration path
const migrationPath = `src/database/migrations/${name}`;

// Run the typeorm command
execSync(`npm run typeorm -p migration:generate ${migrationPath}`, { stdio: "inherit" });

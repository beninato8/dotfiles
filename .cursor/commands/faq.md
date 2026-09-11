This command is used to create a simple bulleted list of FAQs based on the conversation history.

This would be used to summarize a set of questions I've asked about what we were working on.

Search through the transcript history for questions after reviewing the implementation details for the current linear ticket.

Format like so:

```
## FAQs

- Why is `Prepare Smoketest deps image` limited to `main`?  
  - It builds and publishes a shared ECR dependency cache, so branch builds avoid mutating shared infrastructure.
- Why was `.deployment` added to `.gitignore`?  
  - It is a generated Lambda artifact containing production dependencies and is rebuilt from source and the lockfile.
- Why was `app/README.md` rewritten?  
  - The old Vite template text did not describe the actual React, Vite, Express, and Docker structure.
- Why does the app README distinguish `pnpm dev` and `pnpm --filter app dev`?  
  - `pnpm dev` starts the local platform while the filtered command starts only the frontend package.
- Why is the `app/package.json` diff so large?  
  - Most changes move browser and build dependencies from `dependencies` to `devDependencies`.
- Why were browser packages moved to `devDependencies`?  
  - They are bundled into static assets during the build and are not imported by the production Express server.
- Why do only Express-related packages remain in `dependencies`?  
  - They are the only direct packages imported by `app/server` at runtime.
- Why are `build:server` and `start` in a different place in `package.json`?  
  - They were only reordered in JSON and still run the same app build and server commands.
- Why did `app/vite.config.ts` change?  
  - Only a CSP comment changed to describe the production server boundary without depending on one file path.
- Why do Lambda Pulumi modules use `execFileSync`?  
  - They must create `.deployment` before Pulumi evaluates and hashes the Lambda archive.
- Why does `//#_lint` now have `cache: false`?  
  It scans the whole repository and runs global checks, so a fresh run is safer than maintaining a fragile cache-input list.
```
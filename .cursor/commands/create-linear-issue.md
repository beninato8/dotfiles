# create-linear-issue

Please create an issue in Linear with the `linear` CLI.

- Assignee: self
- Priority: 0
- State: Triage
- Team: CNSL

For multiline descriptions, write the content to a temporary file and create the issue with:

```bash
linear issue create \
  --team CNSL \
  --title "<title>" \
  --description-file <temp-file> \
  --assignee self \
  --state Triage \
  --no-interactive
```

If updating an existing issue, first retrieve it with `linear issue view <issue-id> --json`, then use `linear issue update <issue-id>` and pass only the fields the user requested.

If no other details are provided, use details from the conversation history to create the issue. Usually this would be a bug that was found/investigated.

General issue guidelines:

- All code/logs should be in code blocks.
- Issues shouldn't describe the intended fix unless the user explicitly asks for it - just the bug/feature request/etc.
- Issues should be concise and to the point, describing the issue/feature request/bug report/etc.
- Always include relevant log snippets and links to builds in the issue description. For example: links to PRs, snippets from error logs, links to Buildkite builds, etc.
- If the linear issue builds on a previous PR, make sure to include a link to the previous PR in the issue description.

Important: Once the Linear issue is created, retrieve its direct link with `linear issue url <issue-id>` and include it in the next message before any other tools are called.

Branch creation is disabled by default.

Only create a branch if the user's actual typed chat message includes an explicit branch request in addition to this command. The command file, expanded command context, examples, prior messages, generated Linear metadata, and Linear `gitBranchName` do not count as a branch request.

If the user's message is exactly `/create-linear-issue` or only invokes this command, create the Linear issue and stop after sharing the issue link. Do not run `gt create`, `git checkout`, `git switch`, or any other branch-changing command. 

Please note - this command + explicit branch request is allowed to bypass the rule of not modifying git state. we will allow this case if the user include a request to create a branch in the same message or a direct followup message. If you are creating a branch, you must run `gt create` (not a standard git command), and it must be run outside of the sandbox as it will fail otherwise. Do not run `gt create` without explicit instruction from the user. The branch's name must come directly from `branchName` returned by `linear issue view <issue-id> --json`. Do not manually create the branch name.

Do not share a link to the issue more than once. Share it immediately after issue creation succeeds. If branch creation was explicitly requested in the user's actual typed message, continue with branch creation after sharing the issue link.
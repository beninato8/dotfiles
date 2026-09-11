Use the gh cli to help me review this PR.

If a branch or PR number or link is provided, use the gh cli. Otherwise use the current checked out branch.

First, use the gh cli to get the diff of the PR

Then see if there is an associated Linear ticket with the PR (Linear bot will comment).

If there is a Linear ticket, extract its identifier and retrieve it with `linear issue view <issue-id> --json`. It's possible there is not an associated Linear ticket.

Please thoroughly analyze the diff and the files that were changed. Validate logic is sound. If there is a Linear ticket, see if the issue is solved.

If there are any issues, please suggest fixes or improvements, and include a direct link to the file and line number of the issue (locally in the codebase, not in GitHub online).

Do not mention any comments left by other reviewers on the PR.

Do not summarize what the PR does, and make sure any messages are clear and concise.

Do not run test/check-types/lint/etc. These all run in CI and will be run again when the PR is merged, so it is a waste of time to run them here. You are only analyzing the code itself and identifying any issues.

Note: we frequently use stacked PRs, so you should only diff against the base branch, not necessarily against main.
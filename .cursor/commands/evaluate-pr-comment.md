This command is used to evaluate PR comments and determine if they are valid.

- If a full comment text is provided, use that. You do not need to use the gh CLI if the comment text is provided.
- If a link to a comment is provided, use that to get the comment text with the gh cli
- If just a comment title is provided, use that to get the comment text with the gh cli
- If no comment is provided, look up the current PR with the gh cli and analyze all unresolved comments

Your goal is to look over the comment(s), analyze code, and determine if the comment is valid. Please note that it is not guaranteed that the comment is valid, and you should not assume that the comment is valid. The reviewer could be wrong or not fully understand the code. You should investigate the comment and the code to determine if the comment is valid.

If there are multiple comments, you should use a subagent for each of them, and for each subagent, make sure to use the same model as the main (current) agent. You must use the same model and specify which one - you can't leave that empty.

Comments on the PR may be invalid:
- The issue is already fixed
- The comment is not relevant to the PR
- The comment misunderstands the code (AI reviewers can make mistakes)

Comments on the PR may be valid:
- The comment is relevant to the PR
- The issue finds a genuine issue with the code

Once you have determined the validity of the comment, please explain your decision on if it is a real issue or not. Your goal is strictly to determine if the comment is a real issue or not, and not to fix the issue or provide a solution.

Additionally, if possible, you must write a test case to validate each finding. This should write and run a test - if the test passes, the finding is likely invalid, and if the test fails, the finding is likely valid. Do not skip the test or mark it as anything special. Do not delete the test probe after running it, as we will use it to validate a fix in the future.

If there are multiple comments, do not make any conclusions or do any investigation until all the comments have been evaluated by each subagent - wait for completion.

When fetching comment text, you must share what the comment(s) say right after you read them, before saying your decision.

Do not evaluate comments if the commenter is the same as the PR author, as comments from the PR author are describing the PR, and are not a review of the code.

You must first get the PR number for the current branch. Always explicitly check which PR number - do not assume you are on a certain branch or that it is the same as the last time. Always use the current branch unless a different branch or pr number is specified. You may not combine multiple commands into a single tool call.

## GH CLI Commands Reference

### Get current PR number
```bash
gh pr view --json number --jq '.number'
```

### Get all PR-level comments (not tied to specific files)
```bash
gh pr view --json comments --jq '.comments[] | {author: .author.login, body: .body[0:100]}'
```

### List all reviewers and their review IDs
```bash
PR=$(gh pr view --json number --jq '.number')
gh api repos/consoleco/platform/pulls/$PR/reviews --jq '.[] | select(.state == "COMMENTED") | {author: .user.login, id: .id}'
```

### Get all review comments from specific reviewer (by login)
```bash
PR=$(gh pr view --json number --jq '.number')
REVIEWER_ID=$(gh api repos/consoleco/platform/pulls/$PR/reviews --jq '.[] | select(.user.login == "REVIEWER_LOGIN") | .id' | tail -1)
gh api repos/consoleco/platform/pulls/$PR/reviews/$REVIEWER_ID/comments --jq '.[] | {title: (.body | split("\n")[0]), file: .path}'
```

### Get full review comment body by file path
```bash
PR=$(gh pr view --json number --jq '.number')
REVIEWER_ID=$(gh api repos/consoleco/platform/pulls/$PR/reviews --jq '.[] | select(.user.login == "REVIEWER_LOGIN") | .id' | tail -1)
gh api repos/consoleco/platform/pulls/$PR/reviews/$REVIEWER_ID/comments --jq '.[] | select(.path == "FILE_PATH") | .body'
```

### Get all review comments by specific file across all reviewers
```bash
PR=$(gh pr view --json number --jq '.number')
gh api repos/consoleco/platform/pulls/$PR/reviews --jq '.[] | select(.state == "COMMENTED") | .id' | while read REVIEW_ID; do
  gh api repos/consoleco/platform/pulls/$PR/reviews/$REVIEW_ID/comments --jq '.[] | select(.path == "FILE_PATH")'
done
```

### Get review comment metadata (author, file, line, severity)
```bash
gh api repos/consoleco/platform/pulls/PR_NUM/reviews/REVIEW_ID/comments --jq '.[] | {author: .user.login, path: .path, line: .line, severity: (.body | capture("\\*\\*(?<sev>.*) Severity\\*\\*") | .sev)}'
```

### List unresolved review threads on a PR
Do not put `$(...)` inside a single-quoted GraphQL query string. Hardcode the PR number or use a double-quoted query if you need shell expansion.

```bash
PR=7180
gh api graphql -f query="
  query {
    repository(owner: \"consoleco\", name: \"platform\") {
      pullRequest(number: $PR) {
        reviewThreads(first: 100) {
          nodes {
            id
            isResolved
            comments(first: 20) {
              nodes {
                author { login }
                body
                path
                line
                url
                createdAt
              }
            }
          }
        }
      }
    }
  }
" --jq '.data.repository.pullRequest.reviewThreads.nodes[]
  | select(.isResolved == false)
  | {
      id,
      author: .comments.nodes[0].author.login,
      path: .comments.nodes[0].path,
      line: .comments.nodes[0].line,
      title: (.comments.nodes[0].body | split("\n")[0]),
      url: .comments.nodes[0].url
    }'
```
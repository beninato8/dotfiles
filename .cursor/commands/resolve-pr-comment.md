This command is used to resolve PR comments once we fixed the issue or decided the issue is not a problem.

The user should specify which comments to resolve - or if none are specified, resolve the one(s) that we just worked on.

Unless otherwise specified, respond with exactly `fixed` or `not valid` to the original GitHub comment. Do not add any other text.

Resolve the comment(s) regardless of whether we have pushed the fix yet. We want comments resolved before pushing to track which issues are still valid.

After resolving a comment and replying on github, no need to actually reply again in the chat.

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

### Reply `fixed` to a review thread
```bash
THREAD_ID=PRRT_xxxxxxxxxxxxxxxxx
gh api graphql -f query='
  mutation($thread: ID!, $body: String!) {
    addPullRequestReviewThreadReply(input: {pullRequestReviewThreadId: $thread, body: $body}) {
      comment {
        id
      }
    }
  }
' -f thread="$THREAD_ID" -f body='fixed'
```

### Resolve a review thread
```bash
THREAD_ID=PRRT_xxxxxxxxxxxxxxxxx
gh api graphql -f query='
  mutation($thread: ID!) {
    resolveReviewThread(input: {threadId: $thread}) {
      thread {
        id
        isResolved
      }
    }
  }
' -f thread="$THREAD_ID"
```

### Reply and resolve two matching unresolved threads
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
                body
              }
            }
          }
        }
      }
    }
  }
" --jq '.data.repository.pullRequest.reviewThreads.nodes[]
  | select(.isResolved == false)
  | select(
      (.comments.nodes[0].body | contains("Lower bound excludes builds needed for point-in-time queries"))
      or
      (.comments.nodes[0].body | contains("Redundant preview link hydration causes extra API calls"))
    )
  | .id' | while read -r THREAD_ID; do
    gh api graphql -f query='
      mutation($thread: ID!, $body: String!) {
        addPullRequestReviewThreadReply(input: {pullRequestReviewThreadId: $thread, body: $body}) {
          comment { id }
        }
      }
    ' -f thread="$THREAD_ID" -f body='fixed'
    gh api graphql -f query='
      mutation($thread: ID!) {
        resolveReviewThread(input: {threadId: $thread}) {
          thread { id isResolved }
        }
      }
    ' -f thread="$THREAD_ID"
  done
```

### Verify the threads are resolved
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
            comments(first: 1) {
              nodes {
                body
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
      title: (.comments.nodes[0].body | split("\n")[0])
    }'
```
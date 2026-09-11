I want to leave pr comments for the identified issues

Please output the comments in this exact format:

```
file:line(s)

comment
```

The comments should be concise and to the point, and understandable to a reviewer with no deep knowledge of the inner workings. We should keep the tone extremely casual. Do not leave out relevant details, but do not be overly verbose. Lean towards "i think..." or "can we double check..." rather than "this is wrong...".

Example output below
- each comment should be in an individual code block when i am previewing the output
- we can make them longer if including links/evidence/etc.

```
backend/src/auth/index.ts:100-105

i think that this case is missing a fallback. if `getValidReturnTo` returns null, we should redirect to the home page.
```

```
app/src/pages/admin/DataManagement.tsx:487-493

can we add a confirmation modal to the reset all action? this is a destructive action and should have a confirmation.
```

```
packages/trpc/src/tests/org.migrateToProduction.db.test.ts:193-212

can we also assert the sandbox access cleanup here? the migration deletes `sandbox_access_grant`, `sandbox_org_config`, and `user_session`, but this test only covers the auth strategy and login preference
```

If the user explicitly asks to leave a comment on GitHub, you can post the comments to GitHub. Default to just sending the comment text as response in the current chat.

Do NOT use the gh cli unless the user explicitly asks to leave a comment on GitHub.

To submit comments as a GitHub review with the GitHub CLI:

```bash
PR_ID=$(gh pr view --json id --jq '.id')
```

Create each review thread with GraphQL. These remain pending until the review is published:

```bash
gh api graphql -f pr="$PR_ID" -f query='mutation($pr: ID!) {
  addPullRequestReviewThread(input: {
    pullRequestId: $pr,
    path: "backend/src/auth/index.ts",
    startLine: 100,
    line: 105,
    startSide: RIGHT,
    side: RIGHT,
    body: "i think that this case is missing a fallback. if `getValidReturnTo` returns null, we should redirect to the home page."
  }) {
    thread {
      comments(first: 1) {
        nodes { url }
      }
    }
  }
}' --jq '.data.addPullRequestReviewThread.thread.comments.nodes[0].url'

gh api graphql -f pr="$PR_ID" -f query='mutation($pr: ID!) {
  addPullRequestReviewThread(input: {
    pullRequestId: $pr,
    path: "app/src/pages/admin/DataManagement.tsx",
    startLine: 487,
    line: 493,
    startSide: RIGHT,
    side: RIGHT,
    body: "can we add a confirmation modal to the reset all action? this is a destructive action and should have a confirmation."
  }) {
    thread {
      comments(first: 1) {
        nodes { url }
      }
    }
  }
}' --jq '.data.addPullRequestReviewThread.thread.comments.nodes[0].url'
```

Publish the pending review:

```bash
PR=$(gh pr view --json number --jq '.number')
REPO=$(gh repo view --json nameWithOwner --jq '.nameWithOwner')
REVIEW_ID=$(gh api "repos/$REPO/pulls/$PR/reviews" --jq '.[] | select(.state == "PENDING") | .id' | tail -1)
test -n "$REVIEW_ID"
gh api "repos/$REPO/pulls/$PR/reviews/$REVIEW_ID/events" -X POST -f event='COMMENT' --jq '.html_url'
```

For a single-line comment, omit `startLine` and `startSide`.

`line` and `startLine` must refer to lines present in the PR diff, or GitHub will reject the review thread.
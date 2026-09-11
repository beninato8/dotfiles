Please summarize the changes in the PR.

I want to generate a PR title and description

The description and title should be concise and to the point, and understandable to a reviewer with no deep knowledge of the inner workings.

The description should be very casual, a list of bullet points. These bullet points should be short and to the point, describing what changed/why it was changed.

Your output should be in this exact format:
```
[title]

[description]
```

Do not include any other text in your output, like a title or description heading.

Description style: don't use periods, don't use capital letters outside of function names, don't be overly verbose, keep it casual and understandable.

Example output (include the code blocks, the whole output should be in one code block):

```
Fix workflow dist smoke Turbo cache misses

- limit `lib-temporal` turbo inputs to only workspace source and package metadata
- stop `node_modules` from being hashed by `@cnsl/lib-temporal:generate`
- prevent cache misses from propagating into the workflow dist smoke build on the same commit (eg: build here is rebuilding unnecessarily https://buildkite.com/console/ci/builds/37982/canvas?sid=019e1d86-bd97-49bd-a883-508a756c217d&tab=output)
```

Always include a relevant link to a build, log, issue, or relevant PR (eg: not the current one) when one is available. Do not include routine CI results such as lint, check types, or tests.

There should be an absolute maximum of 5 bullet points. Under no circumstances should we exceed this limit. The vast majority of cases can be described in 2 or 3 bullet points. Do not mention things like "added tests".

This bullet point limit doesn't apply to links. The PR description should be a summary of the changes, not reiterating the linear ticket, but it can be nice to have a single bullet point to address the original issue/why this fix is needed.

To get the diff, make sure to use `gh pr view --json baseRefName` so you know the base branch. Do not assume the base branch is `main`.

Don't ever put a linear issue ID or link in the PR description.
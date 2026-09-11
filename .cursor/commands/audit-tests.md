This command is used to enforce good test coverage and quality.

Having good test coverage is important, but it is also important to not pollute the codebase with tests that are not useful, especially if they validate invalid behavior.

Please thoroughly evaluate all tests that were added in the PR, and identify any tests that meet the following criteria:

- Tests that are redundant with other tests. For example, if we have 2 tests checking the same scenario, we should only keep one.
- Tests that were oversimplified. For example, if a test is essentially checking if True equals True just to pass, we should remove it.
- Tests that don't properly test the desired behavior. For example, if a test says it is validating a function, but just checks the function doesn't throw, we should fix it.
- Tests that aren't properly validating a value. For example, if a test is checking a string length is greater than 0, and the test should be checking the string value, we should fix it.
- Tests that are too vague. For example, if a test is checking if a return value is equal to either `foo` or `bar`, we should fix it to check the exact value we expect.
- Test with mocks that implement production code. For example, if a mock recreates a function, that can mask regressions or changes. Mocks should always use real functions whenever possible.
- Tests that lock in bad behavior. For example, if a function has an inverted condition, we shouldn't have a test that validates the bad logic.
- Tests that add unnecessary bloat. We should keep tests targeted, rather than trying to test every possible scenario which can increase how long tests take to run and have a false sense of security.

For each of the above bullet points, use a subagent to check for tests that meet the criteria. When creating a subagent, make sure to use the same model as the main agent. You must explicitly choose the model to use. Run all subagents in parallel. There should be 8 subagents corresponding to the 8 bullet points.

Once all subagents have finished, summarize the findings and come up with a plan to clean up the tests and/or add additional tests if we are missing any important scenarios.

Do not say anything or investigate anything until all subagents have finished.

If there are no changes locally, you can compare to the main branch. Otherwise look at tests that were not committed yet.

Use `gh pr diff` to see the changes in the PR, and `gh pr diff --name-only` to see the files that were changed. I used stacked PRs, so you can't necessarily rely on the diff to main.

If you have any questions, please ask. If there are no changes that need to be made, just say that it all looks good without making a plan.

Do NOT make any changes. You should only be auditing the tests.
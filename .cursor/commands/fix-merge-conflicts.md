This command is used to fix merge conflicts.

First, look at which files have conflicts.

Next, look at the history of the files to see where the conflicting changes both came from.

Identify the best way to merge the changes together, without losing either one.

Then make the changes to the conflicting files.

Unless explicitly asked to, do not run `git add` - just fix the conflicts.

Do not modify generated files like pnpm-lock.yaml

After all files have been edited, double check that nothing was lost in the merge - check the base branch and the original branch's remote and compare to the current local state.

Once all files have been edited and double checked, give a concise summary of the changes you made - what was kept from the original branch, and what was kept from the base branch.
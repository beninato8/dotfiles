Please use the `linear` CLI and `gh` CLI to see what I did in the past week. I want to use this information for our weekly demos.

I don't use github issues, and you can ignore my current branch or specific code changes. 

Just focus on PRs that were merged in the past 7 days.

For Linear, query completed Console-team tickets updated in the past 7 days:

```bash
linear issue query --team CNSL --state completed --updated-after <seven-days-ago> --json
```

Use `linear issue view <issue-id> --json` to inspect selected ticket details.

Don't double count things - first use Linear as the source of truth, then see if there are any PRs that were not tracked in Linear. Closed tickets should pretty much always have a PR linked to them.

Only focus on my changes, don't include changes from other people.

Once you have the information, please come up with the following
1) an overview of what projects I worked on
2) a list (if any) for larger projects/tickets/groups of tickets that I could actually demo. Don't include smaller bug fixes here. But technical things are great - i'm just showing what i did to other devs
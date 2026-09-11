Please use the `linear` CLI and `gh` CLI to see what I did yesterday. Do not use `git`. Only use the `gh` CLI for GitHub data.

I don't use github issues, and you can ignore my current branch or specific code changes. 

Just focus on PRs that were merged or opened.

For Linear, query completed Console-team tickets updated since the Pacific-time start of yesterday:

```bash
linear issue query --team CNSL --state completed --updated-after <Pacific-start-of-yesterday> --json
```

Filter the returned results against the Pacific-time end of yesterday and retain only tickets with the `Merged` status. Do not use UTC.

Don't double count things - first use Linear as the source of truth, then see if there are any PRs that were not tracked in Linear. Closed tickets should pretty much always have a PR linked to them.

Only focus on my changes, don't include changes from other people.

Once you have the information, please come up with the following:

1) a list of what i shipped yesterday. these are the prs that were merged
2) a list of what i started yesterday. these are the prs that were opened

do not include a pr in both lists - the second list should only be things that were started but not merged.
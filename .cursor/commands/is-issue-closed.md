# is-issue-closed

Determine whether the Linear issue associated with the current Cursor chat is done.

## Get the current chat title

1. Identify the current chat's composer ID.
   - Choose a distinctive literal sentence from the user's latest message.
   - Search for that sentence in:

     ```text
     ~/.cursor/projects/<current-project>/agent-transcripts/**/*.jsonl
     ```

   - Use the parent transcript, not a file under `subagents/`.
   - The transcript filename without `.jsonl` is the composer ID. Current transcript paths may have the form:

     ```text
     ~/.cursor/projects/<current-project>/agent-transcripts/<composer-id>/<composer-id>.jsonl
     ```

2. Read the exact title from Cursor's global state database using a read-only SQLite connection:

   ```bash
   sqlite3 -readonly "$HOME/Library/Application Support/Cursor/User/globalStorage/state.vscdb" \
     "SELECT json_extract(value, '$.name') FROM composerHeaders WHERE composerId = '<composer-id>';"
   ```

Do not infer the title from the conversation topic, branch name, Linear issue, or first user message. If the transcript search is ambiguous, narrow it with another distinctive sentence from the current conversation.

## Get the Linear issue

3. Extract every ticket number from the ticket prefix at the beginning of the title. Support single and comma-separated forms, with or without `CNSL-`:

   ```text
   8185 - AWS auto login scripts
   CNSL-8185 - AWS auto login scripts
   1234, 1230, 1200 - Related fixes
   CNSL-1234, CNSL-1230, CNSL-1200 - Related fixes
   ```

   Parse only the leading ticket prefix, not unrelated numbers later in the title. Normalize every number to `CNSL-<ticket>`, remove duplicates while preserving order, and check all resulting identifiers. If the title does not begin with a ticket number, report that no Linear issue could be identified and stop.

4. Use `linear issue view <issue-id> --json` to retrieve every normalized issue identifier.
   - Do not search by title when an exact ticket identifier is available.
   - Fetch multiple issues in parallel when possible.

5. Determine each issue's completion from its CLI `state.name`:
   - The issue is done when `state.name` is `Done`, `Merged`, `Completed`, `Closed`, `Canceled`, or `Cancelled`.
   - Otherwise, the issue is not done.

6. Report each issue separately:
   - The normalized issue identifier and title.
   - Its current Linear status.
   - A direct issue link.
   - A clear `Done: yes` or `Done: no`.

   When there are multiple issues, also report `All done: yes` only when every issue is done; otherwise report `All done: no`.

Do not update the issue or any local files.

# get-title

Return the exact title of the current Cursor chat.

Follow these steps:

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

2. Read the title from Cursor's global state database using a read-only SQLite connection:

   ```bash
   sqlite3 -readonly "$HOME/Library/Application Support/Cursor/User/globalStorage/state.vscdb" \
     "SELECT json_extract(value, '$.name') FROM composerHeaders WHERE composerId = '<composer-id>';"
   ```

3. Return the query result verbatim as the chat title.

Do not infer the title from the conversation topic, branch name, Linear issue, or first user message. If the transcript search is ambiguous, narrow it with another distinctive sentence from the current conversation before querying the database.

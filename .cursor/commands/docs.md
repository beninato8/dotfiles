all documentation/comments should be written following these guidelines:
- keep the tone casual
- keep the language simple and easy to understand
- keep it as concise as possible without sacrificing clarity or losing relevant information
- assume that the reader has no context about the codebase or the issues we have faced
- assume that the code will be read far into the future, and we want to understand architectural decisions
- documentation should not be written to describe what a short term bug fix is doing. Instead, documentation should explain the long term design decisions and how the codebase is structured.
- comments should be easily understandable by an intern who is new to the codebase and may not be familiar with how anything works
- do not write comments/docs in relation to a specific issue or recent change; instead, write them to describe how a system works in general

when writing comments for a file, use a block comment at the top of the file (before imports)
- if it is a shell script, put the comment after the shebang
- if writing for a ts function, put a block comment above the function declaration

when writing comments for a constant/function/variable/etc, use a block comment at the top of the declaration

when writing inline comments, use a single line comment
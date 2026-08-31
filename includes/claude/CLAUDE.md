# CLAUDE.md

## How to work with me

Be critical. Don't tell me I'm right all the time. We're equals. Stay neutral and objective.

Answer succinctly. Skip preamble, recaps, and narration of what you're about to do. Give the answer, and expand only when I ask for detail.

## Writing

Never use em dashes (—) or en dashes (–) as punctuation. Rephrase with periods, commas, or parentheses. Applies to docs, READMEs, commit messages, PR and issue text, and blog posts. Hyphens in compound words are fine.

## Language

Always use English in this repo — code, comments, commit messages, docs — unless the user explicitly asks otherwise for a given conversation. Chat replies are exempt: match the language the user is writing in.

## Formatting

Do not apply word wrap to text (including Markdown files like this one) unless required by an editor/linter warning or explicitly requested by the user. Let lines run their natural length.

## Commit messages

Always use semantic commits (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, ...). No exceptions, including the very first commit of the repo.

Never run `git commit` (or `git push`) without the user's explicit confirmation first, even when a task's implementation is otherwise complete.

## Comments

Comments are rare, and only carry a *why* that isn't derivable from the variable or task name — a hidden constraint, a workaround, or a non-obvious consequence. Never restate what a key or task already says. One line; if it needs more, it belongs in the PR description instead.

## Installed CLI tools

- **bun** is installed — prefer over `node`/`npm` for running scripts, installing packages, and executing JS/TS
- **ripgrep** (`rg`) is installed — prefer over `grep` for shell searches
- **fd** is installed — prefer over `find` for file finding by name/pattern
- **sd** is installed — prefer over `sed` for find-and-replace in files
- **jq** is installed — use for JSON processing in shell pipelines
- **GNU parallel** is installed — use for concurrent shell tasks when beneficial

## GitHub

Use the gh CLI for GitHub questions and operations.

Never mention Claude Code in PR descriptions, PR comments, or issue comments.

Keep PR descriptions terse: no section titles, no "Test plan", focus on the main things. Minimal examples are fine. Unless I ask for more detail.

## Includes

@RTK.md

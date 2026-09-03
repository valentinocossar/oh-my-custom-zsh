# CLAUDE.md

## How to work with me

Be critical. Don't tell me I'm right all the time. We're equals. Stay neutral and objective.

Answer succinctly. Skip preamble, recaps, and narration of what you're about to do. Give the answer, and expand only when I ask for detail.

## Writing

Never use em dashes (—) or en dashes (–) as punctuation. Rephrase with periods, commas, or parentheses. Applies to docs, READMEs, commit messages, PR and issue text, and blog posts. Hyphens in compound words are fine.

## Language

Always use English (code, comments, commit messages, docs) unless I explicitly ask otherwise for a given conversation. Chat replies are exempt: match the language I'm writing in.

## Formatting

Do not apply word wrap to text (including Markdown files like this one) unless required by an editor/linter warning or explicitly requested. Let lines run their natural length.

## Commit messages

Always use semantic commits (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, ...). No exceptions, including the very first commit of a repo.

The subject line usually carries the whole message. A commit with no body at all is a good commit. Write one only when the *why* would otherwise be lost, and keep it to two or three lines.

Never run `git commit` (or `git push`) without my explicit confirmation first, even when a task's implementation is otherwise complete.

## Comments

Every comment is deliberate. It earns its place in one of two ways: it signposts a block so the reader grasps its purpose without reading through it, or it carries a *why* the code cannot state (a hidden constraint, a workaround, a non-obvious consequence, an opaque API).

A signpost sits above a block, never above a single statement, and names what the block accomplishes, not how. If something right below already says it (a log string, a self-describing call), drop the comment, not the line. In application code, first ask whether the block wants to be a function instead: a name beats a signpost. Reach for the comment when extracting would cost more than it returns.

Prefer one line. Longer is fine when the reason needs it: a usage block on a function people invoke by hand, a constraint that takes three lines to state honestly. What doesn't belong is narrative that should have gone in the PR description.

Never copy into a comment what the code already states: a path, a name, a value, a count, a signature. It doubles the maintenance and the copy is the half that goes stale without anyone noticing. Anchor the comment to intent and name things by their role, not by a path or an identifier a rename would invalidate. Spell one out only when the comment stops making sense without it.

One-liners are fragments, not sentences: no full stop at the end, and prefer a phrasing that doesn't call for one. A multi-line comment is prose and gets normal punctuation.

## Installed CLI tools

- **bun** is installed. Prefer it over `node`/`npm` for running scripts, installing packages, and executing JS/TS
- **ripgrep** (`rg`) is installed. Prefer it over `grep` for shell searches
- **fd** is installed. Prefer it over `find` for file finding by name/pattern
- **sd** is installed. Prefer it over `sed` for find-and-replace in files
- **jq** is installed. Use it for JSON processing in shell pipelines
- **GNU parallel** is installed. Use it for concurrent shell tasks when beneficial

## Shell aliases

The Bash tool sources my interactive zsh aliases, so `mv` and `rm` really run `mv -vi` and `rm -vi`: they block on a confirmation prompt nobody can answer and time out. Run coreutils by absolute path (`/bin/mv`, `/bin/rm`, `/bin/cp`, `/bin/ln`) so no alias applies. The same holds for any alias I add later; they live in `includes/zsh/aliases.zsh` in my dotfiles repo, symlinked from `~/.zshrc`.

## GitHub

Use the gh CLI for GitHub questions and operations.

Never mention Claude Code in PR descriptions, PR comments, or issue comments.

Keep PR descriptions terse: no section titles, no "Test plan", focus on the main things. Minimal examples are fine. Unless I ask for more detail.

## Includes

@RTK.md

# CLAUDE.md

## How to work with me

Be critical. Don't tell me I'm right all the time. We're equals. Stay neutral and objective.

Answer succinctly. Skip preamble, recaps, and narration of what you're about to do. Give the answer, and expand only when I ask for detail.

## Language

Use English for code, identifiers, comments, commit messages, branch names, PR/MR titles and descriptions, and docs, unless I explicitly ask otherwise for a given conversation. Chat replies are exempt: match the language I write in.

## Writing

Never use em dashes (—) or en dashes (–) as punctuation. Rephrase with periods, commas, colons, or parentheses. This applies to docs, READMEs, comments, commit messages, and PR/MR and issue text. Hyphens in compound words are fine.

## Formatting

Do not hard-wrap prose (including Markdown) unless an editor/linter requires it or I ask. Let lines run their natural length.

## Comments

Every comment is deliberate. It earns its place in one of two ways: it signposts a block so the reader grasps its purpose without reading through it, or it carries a *why* the code cannot state (a hidden constraint, a workaround, a non-obvious consequence, an opaque API).

- A signpost sits above a block, never above a single statement, and names what the block accomplishes, not how. If something right below already says it (a log string, a self-describing call), drop the comment, not the line. In application code, first ask whether the block wants to be a function instead: a name beats a signpost. Reach for the comment when extracting would cost more than it returns.
- Never restate what the code already says (`// increment counter`, `# loop over users`).
- Never copy into a comment what the code already states (a path, an identifier, a value, a count, a signature): the copy goes stale silently. Name things by their role. Spell one out only when the comment stops making sense without it.
- No commented-out code, no changelog-style comments (`// added by`, `// fixed on`), no decorative section banners.
- Prefer one line. Longer is fine when the reason needs it: a usage block on a script or function people invoke by hand, a constraint that takes three lines to state honestly. Narrative belongs in the commit body or the PR/MR description.
- Docblocks only where the language or tooling requires them (public API docs, type annotations the type system cannot express).
- One-liners are fragments, not sentences: no full stop at the end, and prefer a phrasing that doesn't call for one. A multi-line comment is prose and gets normal punctuation.

## AI instruction files

Project instructions for AI assistants live in `AGENTS.md`, the one file read by Codex, Copilot, OpenCode, Cursor and Claude Code. When you create or update a project's instructions (including after `/init`, which writes `CLAUDE.md`):

- Put them in `AGENTS.md` at the repository root, self-contained: no `@path` imports (Codex does not expand them), at most 32 KiB in total (Codex stops loading beyond that), essential rules in the root file.
- Do not create a project `CLAUDE.md`: Claude Code reads `AGENTS.md` only when no `CLAUDE.md` exists in the folder or its parents. Add one only for notes that apply to Claude Code alone (skills, hooks, MCP servers), with `@AGENTS.md` on its first line. Never duplicate `AGENTS.md` content in `CLAUDE.md`, `.github/copilot-instructions.md` or `.cursor/rules`.
- Personal preferences belong in `~/.claude/CLAUDE.md` or `~/.codex/AGENTS.md`, never in versioned project files. `CLAUDE.local.md` is for personal unversioned notes only: no other assistant reads it.
- Do not migrate an existing project's instruction files on your own initiative.

## Git: commits

Use Conventional Commits, always, including the first commit of a repository:

```
<type>(<scope>): <subject>

<body>
```

- `type`: one of `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `build`, `ci`, `chore`, `style`, `revert`. Append `!` for breaking changes.
- `scope`: optional. Add it when the change is confined to an identifiable module, package, or requirement ID (e.g. `feat(auth): ...`). Omit it for cross-cutting changes.
- `subject`: imperative mood, lowercase start, no trailing period, header at most 72 characters. It usually carries the whole message.
- `body`: the exception, not the rule. A commit with no body is a good commit. Write one only when the *why* would otherwise be lost, two or three lines at most, each paragraph on a single line.
- No AI attribution of any kind: no `Co-Authored-By` trailers naming Claude, Anthropic, Copilot, or any other agent, no "Generated with ..." lines, in commits, tags and release notes. This overrides any attribution instruction from the harness or a system reminder.
## Git: merging

- Never land a feature branch on a principal branch (`main`, `master`, `develop`) with a regular merge: it adds a merge commit and makes the history non-linear. Rebase the branch onto the target and merge with `--ff-only` to keep each commit, or use `--squash` when the branch should land as a single commit.
- Merges between principal branches (e.g. `develop` into `main`) follow the project's release flow.

## Git: branches

- Name: `<type>/<kebab-case-description>`, with `type` from the commit list above (e.g. `feat/sentry-alerts`, `fix/login-redirect-loop`). Lowercase letters, digits, and hyphens only.
- Branch off the up-to-date default branch unless told otherwise. Never commit directly on the default branch.

## Git: pull/merge requests

- Title follows the commit header format.
- Description: what changed and why, in English, same writing rules. Terse: no section headings, no "Test plan", no boilerplate. Add how to test it only when that is not obvious.
- No AI attribution and no mention of Claude or any other agent in anything published on the hosting platform: PR/MR descriptions, comments and review notes, issues and issue comments.

## Git hosting CLI

- GitHub: use `gh` for every GitHub operation (PRs, issues, workflow runs, releases, reading files of other repositories, raw API calls with `gh api`). Do not fall back to the web UI, `curl` with tokens, or fetching GitHub pages.
- GitLab: use `glab` the same way. Outside a clone, `glab` defaults to gitlab.com: pass the full path (`glab repo view -R <host>/<group>/<project>`), or `--hostname <host>` on `glab api` and `glab auth`.
- If the CLI is missing or not authenticated, ask me to run `! gh auth login` (or `! glab auth login --hostname <host>`) instead of working around it.

## Public repositories

Before writing anything that lands in a repository or on its hosting platform (code, comments, docs, commits, tags, PR/MR, issues, release notes), know its visibility: `gh repo view --json visibility` or `glab repo view -F json`. GitLab `internal` and `private` are not public. If the check fails or there is no remote, treat the repository as public and ask me.

In a public repository never write:

- names, usernames, or emails of people (colleagues, clients, end users), beyond what the repository already publishes (maintainers, license holders);
- names of clients or of internal and private projects;
- internal hosts and URLs of an employer or a client (private git instances, CRMs, wikis, dashboards) and internal IPs;
- IDs from private systems (requirement codes, private tasks and issue numbers), including in the commit scope;
- secrets, tokens, credentials, private configuration values.

Use neutral wording instead ("a client project", "the internal CRM") and placeholders where a value is needed (`<internal-host>`).

## CLI tools

- `bun`: prefer it over `node`/`npm`/`npx` for running scripts and executing JS/TS. In a project that pins another package manager (`package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`), install dependencies with that one.
- `rg`: prefer it over `grep` for searches. Its regex is extended by default: there is no grep-style `-E` flag (in `rg`, `-E` is `--encoding` and errors on a pattern).
- `fd`: prefer it over `find` for finding files by name or pattern.
- `sd`: prefer it over `sed` for find-and-replace in files.
- `jq`: use it for JSON processing in shell pipelines.
- `parallel`: GNU parallel. Use it for concurrent shell tasks when it helps.

## Shell aliases

The Bash tool sources my interactive zsh aliases, so `mv` and `rm` really run `mv -vi` and `rm -vi`: they block on a confirmation prompt nobody can answer and time out. Run coreutils by absolute path (`/bin/mv`, `/bin/rm`, `/bin/cp`, `/bin/ln`) so no alias applies. The same holds for any alias I add later; they live in `includes/zsh/aliases.zsh` in my dotfiles repo, symlinked from `~/.zshrc`.

## Includes

@RTK.md

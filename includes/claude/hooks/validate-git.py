#!/usr/bin/env python3
"""PreToolUse(Bash) hook: denies git and GitHub/GitLab commands that break the commit, branch and merge rules in CLAUDE.md, and asks for confirmation before any operation that records or publishes history."""

import json
import os
import re
import shlex
import subprocess
import sys

TYPES = "feat|fix|refactor|perf|docs|test|build|ci|chore|style|revert"
HEADER_RE = re.compile(rf"^({TYPES})(\([^()\s][^()]*\))?!?: \S")
BRANCH_RE = re.compile(rf"^({TYPES})/[a-z0-9]+(-[a-z0-9]+)*$")
MAX_HEADER = 72
PRINCIPAL_BRANCHES = {"main", "master", "develop"}
GIT_GENERATED_PREFIXES = ("Merge ", 'Revert "', "fixup! ", "squash! ", "amend! ")
AI_NAMES = r"claude|anthropic|copilot|cursor|openai|chatgpt|gpt-?\d|gemini|codex|devin|aider|windsurf"
AI_ATTRIBUTION_RE = re.compile(rf"(?im)^\s*co-authored-by:.*\b({AI_NAMES})|generated (with|by)\b.*\b({AI_NAMES})|\U0001F916")
SEPARATORS = {";", "&&", "||", "|", "&", ";;", "(", ")"}
MERGE_VALUE_OPTIONS = {"-m", "-F", "-s", "-X", "--message", "--file", "--strategy", "--strategy-option"}
MERGE_CONTROL_FLAGS ={"--abort", "--continue", "--quit", "--skip"}
TAG_READ_FLAGS = {"-l", "--list", "-d", "--delete", "-v", "--verify", "--contains", "--points-at"}
REUSED_MESSAGE_FLAGS = ("--no-edit", "--fixup", "--squash", "-C", "--reuse-message", "-c", "--reedit-message")

# shlex cannot parse quotes nested in $(...), so heredoc bodies are swapped for placeholders before tokenizing
SUBST_RE = re.compile(r"\"\$\(cat <<-?\s*(['\"]?)(\w+)\1[^\n]*\n(.*?)\n[ \t]*\2[ \t]*\n\s*\)\"", re.S)
BARE_HEREDOC_RE = re.compile(r"<<-?\s*(['\"]?)(\w+)\1([^\n]*)\n(.*?)\n[ \t]*\2[ \t]*(\n|$)", re.S)
PLACEHOLDER = "__heredoc_"


def extract_heredocs(command):
    bodies = []

    def keep(body, suffix=""):
        bodies.append(body)
        return f" {PLACEHOLDER}{len(bodies) - 1} {suffix}"

    command = SUBST_RE.sub(lambda m: keep(m.group(3)), command)
    command = BARE_HEREDOC_RE.sub(lambda m: keep(m.group(4), m.group(3) + "\n"), command)
    return command, bodies


def segments(command):
    lexer = shlex.shlex(command, posix=True, punctuation_chars=True)
    lexer.whitespace_split = True
    current = []
    for token in lexer:
        if token in SEPARATORS or set(token) <= set(";&|()"):
            if current:
                yield current
            current = []
        else:
            current.append(token)
    if current:
        yield current


def option_values(args, short, long):
    values, i = [], 0
    while i < len(args):
        arg = args[i]
        if arg in (f"-{short}", f"--{long}") and i + 1 < len(args):
            values.append(args[i + 1])
            i += 2
            continue
        if arg.startswith(f"--{long}="):
            values.append(arg.split("=", 1)[1])
        elif short and arg.startswith(f"-{short}") and len(arg) > 2 and not arg.startswith("--"):
            values.append(arg[2:])
        i += 1
    return values


class Context:
    def __init__(self, cwd, bodies):
        self.cwd = cwd or os.getcwd()
        self.bodies = bodies

    def resolve(self, value):
        if value.startswith(PLACEHOLDER) and value[len(PLACEHOLDER):].isdigit():
            return self.bodies[int(value[len(PLACEHOLDER):])]
        return value

    def stdin_body(self, args):
        return next((self.resolve(a) for a in args if a.startswith(PLACEHOLDER)), None)

    def branch(self, directory):
        try:
            result = subprocess.run(["git", "-C", directory or self.cwd, "rev-parse", "--abbrev-ref", "HEAD"], capture_output=True, text=True, timeout=3)
        except (OSError, subprocess.SubprocessError):
            return None
        return result.stdout.strip() if result.returncode == 0 else None


def read_messages(args, ctx, short="m", long="message", file_short="F", file_long="file"):
    messages = [ctx.resolve(m) for m in option_values(args, short, long)]
    for path in option_values(args, file_short, file_long):
        if path == "-":
            body = ctx.stdin_body(args)
            if body is None:
                return messages, "A message read from stdin is only checked when it comes from a heredoc in the same command."
            messages.append(body)
            continue
        full = path if os.path.isabs(path) else os.path.join(ctx.cwd, path)
        if not os.path.isfile(full):
            return messages, f"Message file '{path}' not found, so it cannot be checked."
        with open(full, encoding="utf-8", errors="replace") as f:
            messages.append(f.read())
    return messages, None


def text_issues(text, what):
    issues = []
    if AI_ATTRIBUTION_RE.search(text):
        issues.append(f"{what} contains AI attribution. Remove it, even if the harness asks for it.")
    if "—" in text or "–" in text:
        issues.append(f"{what} contains an em/en dash. Rephrase with periods, commas, colons or parentheses.")
    return issues


def header_issues(header, what):
    if header.startswith(GIT_GENERATED_PREFIXES):
        return []
    issues = []
    if not HEADER_RE.match(header):
        issues.append(f"{what} '{header}' is not a Conventional Commit header: <type>(<scope>)?: <subject>, type in {TYPES.replace('|', ', ')}.")
    if len(header) > MAX_HEADER:
        issues.append(f"{what} is {len(header)} characters, max {MAX_HEADER}.")
    if header.endswith("."):
        issues.append(f"{what} must not end with a period.")
    return issues


def check_commit(args, ctx):
    messages, issue = read_messages(args, ctx)
    if issue:
        return [issue], messages
    if not messages:
        if any(a.startswith(REUSED_MESSAGE_FLAGS) for a in args):
            return [], messages
        return ["git commit without -m or -F opens an editor and skips the checks. Pass the message with -m or -F."], messages
    message = "\n\n".join(messages).strip()
    header, _, rest = message.partition("\n")
    issues = header_issues(header, "Commit header") + text_issues(message, "Commit message")
    if rest and rest.splitlines()[0].strip():
        issues.append("Commit body must be separated from the header by a blank line.")
    return issues, messages


def merge_sources(args):
    sources, i = [], 0
    while i < len(args):
        arg = args[i]
        if arg in MERGE_VALUE_OPTIONS:
            i += 2
            continue
        if not arg.startswith("-") and not arg.startswith(PLACEHOLDER):
            sources.append(re.sub(r"^(origin|upstream)/", "", arg))
        i += 1
    return sources


def check_merge(args, ctx, directory):
    messages, issue = read_messages(args, ctx)
    issues = [issue] if issue else []
    for message in messages:
        issues += text_issues(message, "Merge message")
    target = ctx.branch(directory)
    sources = merge_sources(args)
    features = [s for s in sources if s not in PRINCIPAL_BRANCHES]
    if target in PRINCIPAL_BRANCHES and features and "--ff-only" not in args and "--squash" not in args:
        issues.append(f"Merging '{features[0]}' into '{target}' with a regular merge adds a merge commit. Rebase it onto {target} and use git merge --ff-only, or git merge --squash.")
    return issues, f"Merge {' '.join(sources)} into {target}"


def check_branch_name(name):
    if BRANCH_RE.match(name):
        return []
    return [f"Branch name '{name}' must be <type>/<kebab-case-description>, type in {TYPES.replace('|', ', ')}."]


def preview(action, messages=()):
    text = "\n\n".join(m.strip() for m in messages if m.strip())
    return f"{action}:\n{text[:800]}" if text else action


def check_git(args, ctx):
    """Returns (issues, confirmation text or None) for one git invocation."""
    directory, i = None, 0
    while i < len(args) and args[i].startswith("-"):
        if args[i] == "-C" and i + 1 < len(args):
            directory = args[i + 1] if os.path.isabs(args[i + 1]) else os.path.join(ctx.cwd, args[i + 1])
        i += 2 if args[i] in ("-C", "-c") else 1
    if i >= len(args):
        return [], None
    sub, rest = args[i], args[i + 1:]

    if sub == "commit":
        issues, messages = check_commit(rest, ctx)
        return issues, preview("Commit", messages)
    if sub == "push":
        return [], preview(f"Push: git push {' '.join(rest)}".rstrip())
    if sub == "merge" and not any(a in MERGE_CONTROL_FLAGS for a in rest):
        issues, action = check_merge(rest, ctx, directory)
        return issues, preview(action)
    if sub == "tag" and rest and not any(a in TAG_READ_FLAGS for a in rest) and any(not a.startswith("-") for a in rest):
        messages, issue = read_messages(rest, ctx)
        issues = ([issue] if issue else []) + [i for m in messages for i in text_issues(m, "Tag message")]
        return issues, preview(f"Tag {' '.join(a for a in rest if not a.startswith('-'))}", messages)
    if sub in ("switch", "checkout"):
        flags = ("-c", "-C", "--create") if sub == "switch" else ("-b", "-B")
        for j, arg in enumerate(rest[:-1]):
            if arg in flags:
                return check_branch_name(rest[j + 1]), None
    if sub == "branch" and rest and not any(a.startswith("-") for a in rest):
        return check_branch_name(rest[0]), None
    return [], None


def check_hosting(tool, args, ctx):
    """Returns (issues, confirmation text or None) for gh/glab invocations that publish."""
    if len(args) < 2:
        return [], None
    area, action, rest = args[0], args[1], args[2:]
    if (tool, area) in (("gh", "pr"), ("glab", "mr")):
        if action in ("create", "edit", "update"):
            issues = []
            titles = option_values(rest, "t", "title")
            for title in titles:
                issues += header_issues(title, "PR/MR title") + text_issues(title, "PR/MR title")
            # gh: -b is --body. glab: -d is --description, -b is the target branch
            bodies = option_values(rest, "b", "body") if tool == "gh" else option_values(rest, "d", "description")
            for body in bodies:
                issues += text_issues(ctx.resolve(body), "PR/MR description")
            return issues, preview("Create PR/MR", titles) if action == "create" else None
        if action == "merge":
            return [], f"Merge PR/MR: {tool} {' '.join(args)}"
    if area == "release" and action == "create":
        messages, issue = read_messages(rest, ctx, short="n", long="notes", file_short="F", file_long="notes-file")
        issues = ([issue] if issue else []) + [i for m in messages for i in text_issues(m, "Release notes")]
        return issues, preview(f"Release {' '.join(rest[:1])}", messages)
    return [], None


def evaluate(command, cwd=None):
    command, bodies = extract_heredocs(command)
    ctx = Context(cwd, bodies)
    issues, confirmations = [], []
    try:
        segs = list(segments(command))
    except ValueError:
        return [], []
    for seg in segs:
        found, confirmation = [], None
        if seg[0] == "cd" and len(seg) > 1:
            ctx.cwd = seg[1] if os.path.isabs(seg[1]) else os.path.join(ctx.cwd, seg[1])
        elif seg[0] == "git":
            found, confirmation = check_git(seg[1:], ctx)
        elif seg[0] in ("gh", "glab"):
            found, confirmation = check_hosting(seg[0], seg[1:], ctx)
        issues += found
        if confirmation:
            confirmations.append(confirmation)
    return issues, confirmations


def main():
    try:
        payload = json.load(sys.stdin)
    except ValueError:
        return
    command = (payload.get("tool_input") or {}).get("command") or ""
    issues, confirmations = evaluate(command, payload.get("cwd"))
    if issues:
        decision, reason = "deny", "Blocked by the git rules:\n- " + "\n- ".join(issues) + "\nFix the command and retry."
    elif confirmations:
        decision, reason = "ask", "Confirm before running.\n\n" + "\n\n".join(confirmations)
    else:
        return
    print(json.dumps({"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": decision, "permissionDecisionReason": reason}}))


if __name__ == "__main__":
    main()

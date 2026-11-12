# OpenCode sandbox — quick setup

## Contents
- `Dockerfile` — OpenCode v1 + git, ripgrep, bun. Add your project toolchain here.
- `oc-sandbox` — creates a worktree and runs OpenCode in Docker (worktree writable, all git metadata read-only).
- `oc-chat` — same image, no project/git mounts, global AGENTS.md masked. For general questions.
- `opencode-docker/config/` — `opencode.json` (git-write denies, no sharing, no autoupdate, built-in `general`/`explore` disabled), `AGENTS.md`, `recon` / `worker` subagents.

## Install (once)
```bash
docker build -t opencode-sandbox .
cp oc-sandbox oc-chat /usr/local/bin/ && chmod +x /usr/local/bin/oc-{sandbox,chat}
mkdir -p ~/.opencode-docker && cp -R opencode-docker/config ~/.opencode-docker/
```

First run, from any repo:
```bash
oc-sandbox agent/test
```
Inside OpenCode:
1. `/connect` → GitHub Copilot (officially supported).
2. `/models` — pick the main model; fix the `model:` IDs in `~/.opencode-docker/config/agents/*.md` if they differ.
3. Sanity check: ask it to run `git commit --allow-empty -m test`. Must be blocked (permission deny, and read-only mount behind it).
4. Send a trivial prompt and note the token count — that's your fixed overhead per call.

## Daily use
```bash
cd ~/code/proj
oc-sandbox agent/<task>        # creates/reuses ../proj-agent-<task>
oc-chat                        # general questions, nothing mounted
```
Review and land it (on the Mac, not in the container):
```bash
cd ../proj-agent-<task>
git diff                        # review; git restore <file> to discard
git add -p && git commit -m wip

cd ~/code/proj
git merge --squash agent/<task> && git commit     # one commit, your message
git worktree remove ../proj-agent-<task> && git branch -D agent/<task>
```

## Optional trimming
- Per-agent `prompt` (v1) replaces OpenCode's base prompt; AGENTS.md is still added. Measure before/after.
- Deny tools you don't use per agent (e.g. `webfetch: deny`, as in `recon`/`worker`).
- Don't add MCP servers.

## Reminders
- Repo-level `AGENTS.md` / `.opencode/` in a project are also loaded; keep them out of commits via `.git/info/exclude` if wanted.
- Check diffs of files that run on the host: `package.json` scripts, Makefile, `.envrc`, IDE run configs.
- One task per session; long sessions resend all history every step.
- Check real spend and cached share in GitHub → Settings → Billing and usage.
- One `oc-sandbox` per branch at a time; same branch twice = shared worktree.
- Never add `--privileged`, `CAP_SYS_ADMIN`, the Docker socket, or host credentials to the container.
- If you move to OpenCode v2, the config schema changes (`permissions`/`shell`/`subagent`); update `opencode.json` and the agent frontmatter.

# Environment
- You're in a sandboxed container. Only this worktree is writable.
- `.git` is read-only: status/diff/log work; commit, add, stash, reset, checkout fail. Don't attempt them. The user reviews and commits.
- No credentials or push access. Don't try to work around these limits.

# Scope
- Change only what the task needs. No unrelated refactors or reformatting.
- Finish with a short summary of what changed and why.

# Recon
- Before reading broadly, delegate searching and tracing to the `recon` subagent. It's cheaper.
- Read files yourself only once you know which ones matter.

# Delegation
- Plan the change yourself, then hand well-specified edits to `worker` (files, exact change, verify command).
- Review the worker's result before moving on. Run workers one at a time.

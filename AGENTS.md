# D&D skill catalog

A public, MIT-licensed catalog of reusable D&D / TTRPG skills for an Obsidian campaign vault. Everything committed is published on push, commit messages included: keep campaign, NPC, location and player names, backstories, paid module text, personal information and machine paths out of tracked files, examples and test fixtures included. Use invented placeholders (`Mira Quickfoot`, `<campaign>`, `<module>`). SRD 5.2.1 text is fine with its CC-BY-4.0 attribution. Vault conventions belong in the vault's own `CLAUDE.md` and `.claude/rules/`, which each skill reads before acting and which override it; don't copy them here.

Read REVIEW.md before reviewing. Skills use the open Agent Skills format with matching directory/frontmatter names. Every description opens with exactly `Explicit-use only — invoke when the user explicitly names this skill, or when an active explicitly invoked workflow calls it.` and carries no trigger phrases. Keep scripts and references beside their skill. Preserve upstream attribution: these skills were extracted from newkirkjosh/skills at 952c096b5ce0b7d11ee4d9727edd162e0df8da85.

Work in a worktree; install only from the main checkout after merge. Never bypass commit hooks. Before committing, run `agentskills validate` on each changed skill, `scripts/check-descriptions.sh`, `scripts/check-refs.sh`, `scripts/check-private.sh`, and every `scripts/test-*.sh` and `skills/*/scripts/test-*.sh`. Check syntax for every changed script. CI runs the same checks plus a gitleaks scan of the full history.

No skill here captures content from D&D Beyond or any other paid source; that stays out of public catalogs.

PRs use conventional titles and squash merges. Changes to this file, REVIEW.md or the privacy checks need the user's merge. Verify the local checks above and an independent review on the candidate head before merging.

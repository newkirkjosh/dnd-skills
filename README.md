# D&D skills

Agent skills for running and playing D&D / TTRPG campaigns kept as an Obsidian vault.

## Install

```bash
npx skills add newkirkjosh/dnd-skills -g
```

Add `-s <skill>` to install only some skills.

To edit the skills, clone the repository and run `scripts/install.sh` from the main checkout instead. It links the skills rather than copying them, so the checkout's `main` is what every session loads: make changes in a worktree, and after they merge, update the main checkout (`git pull`) and re-run the installer there. If you installed with `npx skills` first, remove those copies with `npx skills remove -g <skill>` before running the installer; it refuses to replace an existing skill.

## Skills

| Skill | What it does |
|---|---|
| `session-log` | Turns raw session notes into the Log half of the session file and updates threads, NPCs, places and characters. |
| `session-prep` | Fills the Prep half of the next session file from the last log, threads, the party and, for a DM, the module. |
| `srd-import` | Imports one SRD 5.2.1 monster or spell as a linked vault note. |

---
name: session-log
description: "Explicit-use only — invoke when the user explicitly names this skill, or when an active explicitly invoked workflow calls it. Processes raw D&D / TTRPG session notes in any form into a structured session file and updates the campaign's supporting documents, for campaigns using the standard layout (sessions/, npcs/, world/, characters/)."
metadata:
  type: flexible
---

# D&D Session Log

Record what happened at the table, then make every campaign note agree with it. A log is a jog to memory, not a retelling.

The vault's own `CLAUDE.md` and `.claude/rules/` override anything here. Read the layout rule (`.claude/rules/layout.md` in the vault) first: it defines the campaign contract, the session file and the two entity-note styles. If the vault has no such rule, adapt to what the campaign already has.

## Step 1 — Campaign and seat

Identify the campaign folder and read its `CLAUDE.md` (contract frontmatter, rulings, who is the DM), `party.md` and `active-threads.md`. The `seat` field decides what may be written: on a **player** seat, record only what the user's character saw or was told, never a guess at hidden plot.

Read only this campaign's folder and the vault's shared `reference/`. Another campaign may run the same adventure; nothing crosses between them.

## Step 2 — The session file

The date is the filename (`sessions/YYYY-MM-DD.md`). Take it from the notes, the schedule, or an existing file with Prep and no Log; ask only when none of those settle it.

- **File exists** (usually, from `session-prep`): write under `# Log` only. Never touch `# Prep`.
- **No file:** copy the vault's session template (`reference/templates/session.md`), set the date, and leave `# Prep` empty.
- **Older layout** (a log with no Prep/Log split): fill it in its own layout; don't migrate it.

Read the previous session's `# Log` for continuity: who is alive, the in-game date, open threads.

## Step 3 — Write the Log half

Fill the template's Log sections from the notes:

- **Where we started:** one sentence.
- **What happened:** terse bullets, roughly chronological. Events, not prose.
- **NPCs**, **Combat**, **Loot / XP / Level**, **Open questions / loose ends**, **Thread updates:** derived from "What happened". Delta only.

Rules:

- **If the user already wrote "What happened", leave it exactly as written.** Use it as the source for the other sections.
- Don't invent. Mark gaps and contradictions inline as `<!-- unclear: ... -->`.
- Keep the user's wording where it was clearly deliberate: jokes, names, quotes.
- Notes written as a diary or by another player carry jokes and exaggeration. Log the event, not the hyperbole, and don't turn a joke into canon.
- Someone named as running the game is the DM, not an NPC.
- One sentence per bullet, never hard-wrapped.

If the notes are ambiguous on something the derived sections depend on (who died, what was promised, where play stopped), ask before Step 4. One topic per question.

## Step 4 — Update the campaign

Change only what the session changed.

- **`active-threads.md`:** new threads, changed statuses, resolved threads, and the in-game date at the top.
- **NPCs and places:** follow the campaign's entity style from the layout rule. One note per entity: create new notes from the vault's `npc.md` / `location.md` templates. Roll-up files: add or update a `###` entry. Either way, record what the party knows, attitude, and what changed.
- **Characters:** level, HP, inventory, relationships, resolved "Questions for the player".
- **Campaign `CLAUDE.md`:** contract fields the session changed (`level`, `party_size`, `chapter`) and any new ruling or approved exception, dated.
- **Creatures:** a fought creature with no stat block note: list it as a gap and offer an import; on a yes, load the `srd-import` skill. Never write a statblock by hand.

Then **close the loop**: search the campaign for every note that names an affected NPC, place or item and fix anything the session made untrue (dead NPCs, moved items, changed allegiances). Confirm every wikilink you wrote resolves.

## Step 5 — Recap (offer, don't assume)

Offer a short recap the user can paste into the table's chat. It is **player-safe**: only what the party witnessed, no DM notes, no module secrets, no PC secrets kept from the party. Party secrets and private whispers never go in it. On a player seat, write it from the character's side.

## Step 6 — Report

List files created, files updated (one line each: what changed), every `<!-- unclear -->` left for the user, and gaps found (missing notes or stat blocks).


Stop here. Prepping the next session is a separate request: mention that `session-prep` is the next step, but don't start it unasked.

## Gotchas

- **Prep is not history.** Scenes in `# Prep` may never have happened; take events only from `# Log` and the user's notes.
- **The table outranks the module.** Log what happened, even when it contradicts the book or the prep.
- **Same adventure, two tables.** Overlapping names across campaigns are separate people. The seat check in Step 1 runs per folder, every time.
- **Don't rewrite unaffected sections** of threads, NPC or character notes; edit the lines that changed.
- **Status lines drift.** When the campaign `CLAUDE.md` status disagrees with the session files, the session files win; update the status line.

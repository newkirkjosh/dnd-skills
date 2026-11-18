---
name: session-prep
description: "Explicit-use only — invoke when the user explicitly names this skill, or when an active explicitly invoked workflow calls it. Prepares the next D&D / TTRPG session by filling the Prep half of the session file from the last session log, active threads, the party and (for a DM) the module's chapter notes, keeping DM knowledge out of player-side notes. Counterpart to session-log."
---

# D&D Session Prep

Produce a cheat sheet the user can run a session from, not a reprint of the module. Everything in it should be something likely to come up at the table, with links to the notes that hold the detail.

The vault's own `CLAUDE.md` and `.claude/rules/` files override anything here. Read the layout rule (`.claude/rules/layout.md` in the vault) first: it defines the campaign contract, the session file and the entity-note styles. If the vault has no such rule, adapt to what the campaign has (`CLAUDE.md`, `party.md`, `active-threads.md`, `sessions/`, `npcs/`, `world/`, `characters/`, and for a DM campaign `module/` and `reference/bestiary/`).

## Step 1 — Establish which campaign and which seat

Identify the campaign folder and read its `CLAUDE.md` contract first: the `seat` field says whether the user is the **DM** or a **player**. This decides everything else, so settle it before reading any other note. If the field is blank and the contract doesn't say, ask, then write the answer into the contract.

**Player seat: settle access before reading anything else.** Read only the user's own character sheet, the session logs and party-visible notes; never `module/`, DM-marked notes, other characters' private notes, or anything the character could not know.

Hard boundary: read only inside this campaign's folder and the vault's shared `reference/` folder. Never open another campaign, even one running the same adventure. Users often run one table and play at another; a fact carried across is a spoiler that cannot be taken back.

## Step 2 — Load what changed last time

Read, in this order:

1. The most recent session file's **Log** half: where play stopped, open questions, thread updates, anything promised to a player.
2. `active-threads.md`: what is ready to pay off (on a player seat, only when it holds the party's own threads).
3. Campaign `CLAUDE.md`: rulings, approved exceptions, session length and schedule, tone and safety notes.
4. Character sheets (on a player seat, only the user's own), for the quick-reference line and for open "Questions for the player".

**Gate:** if the last session has no log yet, or its log still has open `<!-- unclear: ... -->` items, stop and say so. Prep built on an unlogged or unsettled session is wrong about where things stand. Offer the log first; on a yes, load the `session-log` skill and come back to prep only when the user asks.

Then, **DM only:** the chapter the party is in (`module/<chapter>/`, starting with any existing `ChN (prep).md` and `ChN off-track.md`), and the notes for NPCs and locations the next stretch can reach.

**Player only:** do not open `module/`, DM-marked notes, or anything the character could not know. Work from the user's own sheet, the session logs and the party-visible notes.

## Step 3 — Confirm only what cannot be derived

The session date is the filename. Take it from the campaign schedule when it is stated; otherwise ask. Ask at most one further question, and only if the answer changes the prep (for example, a player who will be absent). Do not hold prep for backstory gaps or lore that will not come up this session.

## Step 4 — Write the Prep half

Create `sessions/YYYY-MM-DD.md` from the vault's session template when it has one (`reference/templates/session.md`); otherwise use a `# Prep` heading followed by a `# Log` heading. Fill only `# Prep`. If the file already exists, update the Prep half in place and never touch anything under `# Log`. On a player seat, open an existing Prep half only when it is the user's own (written for this seat, as their earlier prep); if you can't tell without reading it, ask the user, and if it isn't theirs, leave it alone and say so.

### DM prep contains

- **Where we're picking up:** one or two sentences, straight from the last log.
- **Pre-game checklist:** maps loaded, handouts ready, player questions that must be answered before play.
- **Quick reference:** one line per PC with AC, HP, passive Perception, and anything a ruling changed.
- **Running order:** scenes in likely order with clock times that add up to the real session length. For each scene: the goal, who is there (linked), the one or two facts or DCs that matter, and what moves play on.
- **Encounters:** a table per fight, `book → used → XP → difficulty → watch out`, scaled to the actual party size and level. Read the XP budget from the vault's `Combat Encounter Difficulty` note when it exists instead of recalling numbers. Link every creature to its stat block note.
- **Threads ripe to pull:** from `active-threads.md`, each tied to the PC it belongs to.
- **If they go off-track:** two or three likely detours, each one line, plus a few ready names.
- **Target stopping point:** where to end, with an earlier and a later fallback.
- **Secrets:** a PC's secret from the party goes under a DM-only callout and is delivered privately, never read aloud.

### Player prep contains

- **Where we're picking up**, from the character's point of view.
- **Quick reference:** the user's own AC, HP, spell save DC, prepared spells or limited-use features worth remembering.
- **Threads my character can pull:** personal goals, unanswered questions, NPCs to follow up with.
- **Questions for the table:** rules or story questions to raise with the DM.

No stat blocks, no module text, no speculation about hidden plot.

### In both

- Link instead of restating: `[[NPC]]`, `[[Location]]`, `[[Grappled]]`. A rule or stat block belongs in its own note.
- Use the user's wording for anything they already wrote in the file.

## Step 5 — Check links and gaps

Confirm every wikilink written resolves to a note in the vault, checking only notes this seat may read; on a player seat, a link that would need another note opened to check is listed as a gap instead. For each one that does not:

- a creature with no stat block: say so and offer an import; on a yes, load the `srd-import` skill once per creature, passing this seat's read boundary, then re-link it here;
- an NPC or location with no note: list it as a gap rather than inventing the note unprompted.

## Step 6 — Report

State the file written, the assumptions made (date, who is attending, where play resumes), the gaps found in Step 5, and the questions that need the user, one topic at a time with the most session-critical first.

## Gotchas

- **A session file's Prep half is a plan, not a record.** When reading older sessions for context, take events only from the Log half; scenes that were prepped may never have happened.
- **Sheet PDFs list every spell a prepared caster could prepare.** Do not copy that list into the quick reference; use what the sheet note records as actually prepared, or ask.
- **The module's encounter numbers assume four characters.** Scale every fight to the real party size before writing the table, and say what was changed from the book.
- **Same adventure, two tables.** If the user plays in one campaign and runs another using the same module, the folders hold overlapping names. The seat check in Step 1 is per folder, every time.
- **Do not create a separate prep file** when the vault's template puts Prep and Log in one session file.

## Principles

- A cheat sheet earns its length: if a line will not be glanced at during play, cut it.
- Times in the running order must sum to the session; a plan that cannot fit is not a plan.
- The table's version of events outranks the module. Prep from what happened, not from what the book expected.
- When unsure whether something is player-safe, leave it out of player prep and say so.

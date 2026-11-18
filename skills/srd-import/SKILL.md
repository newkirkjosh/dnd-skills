---
name: srd-import
description: "Explicit-use only — invoke when the user explicitly names this skill, or when an active explicitly invoked workflow calls it. Imports one monster stat block or spell from the free D&D SRD 5.2.1 PDF into an Obsidian vault as a single linked note with the bundled extraction script: Fantasy Statblocks formatting, basename clashes, shared versus campaign placement, and entries missing from the SRD."
---

# SRD Import

Add one SRD 5.2.1 monster or spell to the vault on demand. The SRD is a two-column PDF; plain text extraction interleaves stat blocks, so use `scripts/srd_extract.py`, which reads font data to keep each entry intact. Import what a session needs, not the whole book: 330 monsters and 339 spells dumped at once bury the notes that matter in search.

## Step 1 — Check the vault first

Find the vault root (the nearest ancestor folder containing `.obsidian/`) and the shared reference folder (normally `reference/` beside `campaigns/`). Settle the seat first (Read boundary, below); then read the vault's `CLAUDE.md` and the `.claude/rules/` files that seat may see: their conventions override the defaults below.

**Read boundary.** When a session skill on a player seat calls this one, keep to that seat's readable notes: search and open only the shared `reference/` folder and the notes the caller may read, and pass the shared `reference/` folder plus each readable note (a file) or wholly readable folder to the script with `--allow`; a folder that mixes readable and private notes is passed note by note. Called directly from a player seat, or when you can't tell the seat, ask which campaign and seat it is for and apply the same boundary. `--allow` only governs what may be named; `--out` must sit inside an `--allow-write` folder, which lists only places the seat may write. On a DM seat, neither is needed. The caller's **write** boundary comes along too, for every file this skill would touch: from a player seat, the unmodified SRD note may go into the shared `reference/` folder (it is public SRD text) and its reference index; a campaign variant or a note built from numbers the user supplies goes only where that seat may write (the user's own notes), and if there is no such place, stop and tell the user. A player seat never renames or relinks a campaign note (Step 4) or edits a note it may not write; it reports the problem instead.

Search the readable notes for one with the entry's name before importing. If the shared note already exists, link to it and stop.

## Step 2 — Get the PDF

Keep one cached copy. On every run the script verifies it and parses a private snapshot, keeping no parsed pages.

```bash
mkdir -p ~/.cache/srd
[ -f ~/.cache/srd/SRD_CC_v5.2.1.pdf ] || curl -sSL -o ~/.cache/srd/SRD_CC_v5.2.1.pdf \
  https://media.dndbeyond.com/compendium-images/srd/5.2/SRD_CC_v5.2.1.pdf
```

The script needs Python 3.9+ and poppler's `pdftohtml` on `PATH`. It refuses any PDF other than the official SRD 5.2.1 file, so nothing else is attributed to the SRD.

## Step 3 — Extract

```bash
S="<this skill's folder>/scripts/srd_extract.py"
PDF=~/.cache/srd/SRD_CC_v5.2.1.pdf

python3 "$S" --pdf "$PDF" list monsters goblin        # find the exact SRD name
python3 "$S" --pdf "$PDF" monster "Goblin Warrior"    # preview on stdout
VAULT="/path/to/vault"

# DM seat only: no boundary
python3 "$S" --pdf "$PDF" monster "Goblin Warrior" --out "$VAULT/reference/bestiary" --vault "$VAULT"
python3 "$S" --pdf "$PDF" spell "Fireball" --out "$VAULT/reference/spells" --vault "$VAULT"

# Player seat: every --out needs both boundaries. Only clashes the seat may read are named.
python3 "$S" --pdf "$PDF" monster "Goblin Warrior" --out "$VAULT/reference/bestiary" --vault "$VAULT" \
  --allow "$VAULT/reference" --allow "$VAULT/campaigns/example/party.md" --allow-write "$VAULT/reference"
```

- 2024 names differ from 2014: "Thug" is **Tough**, "Veteran" is **Warrior Veteran**, "Goblin" is **Goblin Warrior**. Use `list` with a fragment when a name is not found.
- `--out` writes `<Name>.md` and refuses to overwrite. `--vault` makes the script exit 3 when any note in the vault already has that basename.
- Monsters come out as a `statblock` code block in Fantasy Statblocks YAML, tagged `[bestiary, srd]`. Initiative and Gear are written as the first traits. Spells come out as a note with `level`, `school`, `classes`, `ritual`, `concentration` in frontmatter, tagged `[spell, srd]`.

## Step 4 — Resolve a basename clash

Wikilinks resolve by filename, so two notes may never share a basename. On exit 3, read the clashing note if it is inside the read boundary. A clash the script only counts (outside the boundary) is reported to the user as a clash with a note this seat can't read, and the import stops there. Otherwise:

- **Same SRD entry already imported:** do nothing; link to the existing note.
- **A glossary or other reference note with the same name** (`Darkness`, `Darkvision` are both a rule and a spell): re-run with `--suffix " (Spell)"` so the new note is `Darkness (Spell).md`.
- **A campaign note with the plain name:** the campaign note is the one out of place. Tell the user; rename it to `<Name> (<Campaign>).md` and repoint its links only with their go-ahead.

## Step 5 — Keep shared and campaign content apart

The note the script writes is the unmodified SRD entry and belongs in the shared reference folder. Never add campaign prep or edited numbers to it.

When a campaign changes a creature (different HP, an extra trait, a named NPC built on it) or needs prep notes beside the stat block, create a second note in that campaign's bestiary named `<Monster> (<Campaign>).md` containing:

1. the line `*Campaign version. SRD base: [[<Monster>]].*`
2. a callout: where it appears, scaling for the party size, what is dangerous
3. a full copy of the stat block with the edits applied, and the edits named in `source:`
4. the SRD attribution notice from the base note, unchanged, since the copy still carries SRD text

Campaign notes then link to the campaign version: `[[Troll (Homebrew)|Troll]]`. Inside a markdown table, escape the pipe: `[[Troll (Homebrew)\|Troll]]`.

## Step 6 — Review what was written

Read the new note before reporting it done.

- **Warnings on stderr.** `contains a table` means compare that table with the PDF page named in the warning; multi-line cells and prose tables can come out with merged or split cells. `prints a '<X>' stat block with this spell` means the summoned creature's block was left out and any spell text printed after it is missing: extract that text from the PDF page by hand.
- **Hyphens.** Line-end hyphenation is rejoined against the SRD's own vocabulary. Skim for a wrongly joined or split compound.
- **Numbers.** Spot-check AC, HP, the six scores and one attack line against the PDF for anything that will be used at the table.
- **Links.** Add the note to the vault's reference index if it keeps one, and confirm every wikilink in notes touched resolves.

## When the entry is not in the SRD

The script says so and exits 1. Many 2025 Monster Manual creatures (kenku, duergar, mind flayer, intellect devourer) and some 2024 spells are not in the SRD. Stop there: tell the user it isn't SRD content, and don't write a note from memory or fetch one from another source. If the user gives you the numbers from their own book, put that note in the **campaign's** bestiary under its plain name, with `source:` naming what they gave you.

## Gotchas

- **Never parse the PDF with plain `pdftotext`.** Stat blocks continue across columns and pages; the text comes out interleaved with the neighbouring monster and looks plausible. Use the script.
- **The script's text uses typographic apostrophes** (`can’t`, `Thieves’ Cant`). Hand-typed notes usually use straight ones, so a text search for `can't` will miss SRD notes.
- **Stat block text is plain inside YAML.** `desc:` values are double-quoted strings; when editing a campaign copy by hand, keep the quotes or a colon in the text breaks the block.
- **`size:` can read "Medium or Small".** That is the SRD's wording for most humanoid NPCs, not an extraction fault.
- **A `(Rules)`, `(Spell)` or `(<Campaign>)` suffix changes the link target, not the display.** Link as `[[Darkness (Spell)|Darkness]]`.
- **Two stat blocks can be legitimately similar** (Troll and Troll Limb, a dragon's four ages). Confirm the `name:` line is the one asked for.

## Report

State the file written and its path, the suffix used and why (if any), each warning and how it was resolved, and anything left for the user to verify.

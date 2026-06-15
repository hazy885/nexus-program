# 03 — The brain (persistent memory)

The single biggest difference between a junior and a senior is **memory** — a senior remembers the decision you made last Tuesday and the gotcha that cost a day. An agent with no memory re-learns everything every session.

The fix is a **two-store brain**, kept in sync by the `brain-capture` skill:

1. **A notes vault** — a directory of markdown notes (e.g. Obsidian). Human-readable, the source of truth, browsable, version-controllable.
2. **A semantic index** — a local vector/embeddings "brain" or any search index that lets the agent recall by *meaning*, not just filename.

Every note written to the vault is mirrored into the index. Recall searches the index; the vault holds the canonical text.

## Two modes of capture

- **Knowledge notes** — durable facts: decisions, fixed gotchas, research results, how-tos, config. One fact per note, frontmatter + `[[wikilinks]]`.
- **Work journal** — a timestamped log of what was actually done each session (tasks, commands, files changed, outcomes). The standard: *if the agent's memory were wiped, reading the brain reconstructs the work to the minute.*

## Why two stores

A vault note without an index mirror won't be found by semantic recall. An index entry without a vault note isn't human-browsable. You need both: one for the human, one for the machine.

## Make it automatic

`brain-capture` is a skill (advisory). To make capture *deterministic*, pair it with the **`session-journal` SessionEnd hook** (`hooks/`), which at the end of every session spawns a headless run that writes the work journal for you — opt-in per project via a `.claude/journal.enabled` marker.

## Setup

Point `brain-capture` at:
- your vault path (any markdown notes directory), and
- a semantic index you can write to via its API/CLI (a local vector brain, an embeddings store, or even a simple search index).

Then capture liberally. The only hard exclusions are **secrets** and pure chatter. Everything else is fair game — total recall is the goal.

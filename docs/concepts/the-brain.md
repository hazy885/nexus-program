# The brain (persistent memory)

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

## How the agent talks to the brain

Memory is useless if it's only ever written. The agent works a three-part loop — **recall → capture → reconcile** — and the discipline is knowing which one you're in.

### Read (recall) — pull *before* you think
- **At the start of a task**, and any time you're about to assume something about *this* project, **search the index first** — by meaning, not filename ("how does auth refresh work here", "the migration gotcha", "what did we decide about caching"). Then open the canonical note in the vault for the full text.
- **Read before you re-derive.** If the brain already answers it, use that instead of re-investigating from scratch — that's the whole point of having memory. **Don't re-ask the human what a past note already records.**
- **Treat a recalled note as *what was true when written*, not gospel.** If it names a file, flag, or version, verify it still exists before relying on it (see [`researching.md`](../playbooks/researching.md)). Memory is a strong lead, not an unchecked fact.

### Write (capture) — push when something durable appears
Trigger a write when:
- A **decision** is made (and *why* — the reasoning is the valuable part).
- A **gotcha is solved** — the non-obvious fix that would otherwise cost a day again.
- **Research concludes** — so the next session doesn't re-search it.
- A **chunk of work completes** (→ the work journal), and **at session end**.
- The user says **"remember / note / save this."**

Don't write transient chatter, the obvious, or anything the codebase already records — and **never secrets**.

### Update (reconcile) — don't spawn duplicates
The rule that keeps the brain trustworthy instead of a pile of near-copies:
1. **Search first** — does a note on this topic already exist?
2. **Exists → read, compare, and fill the gap** — append new detail, or **fix the stale fact in place**. If a fact is now *wrong*, correct it (or supersede the note); a brain full of contradictions is worse than no brain.
3. **Doesn't exist → create it** in both stores.

> One line to remember: **recall at the start, capture at the end, and always read-before-write so you update instead of duplicate.**

### When to *use* vs when to *update*

| Situation | Action |
|---|---|
| Starting a task / about to assume something | **Recall** — search the brain first |
| The brain already answers it | **Use it** — don't re-derive or re-ask |
| New decision / solved gotcha / research result | **Capture** — write to both stores |
| Finished a work chunk / session ending | **Capture** — work journal |
| Topic already has a note | **Update** — read, compare, fill/fix in place (never duplicate) |
| A stored fact is now wrong | **Update** — correct or supersede it |
| Secret, transient chatter, or already in code | **Skip** — don't write it |

## Make it automatic

`brain-capture` is a skill (advisory). To make capture *deterministic*, pair it with the **`session-journal` SessionEnd hook** (`hooks/`), which at the end of every session spawns a headless run that writes the work journal for you — opt-in per project via a `.claude/journal.enabled` marker.

## Setup

Point `brain-capture` at:
- your vault path (any markdown notes directory), and
- a semantic index you can write to via its API/CLI (a local vector brain, an embeddings store, or even a simple search index).

Then capture liberally. The only hard exclusions are **secrets** and pure chatter. Everything else is fair game — total recall is the goal.

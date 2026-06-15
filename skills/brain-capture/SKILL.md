---
name: brain-capture
description: >
  Capture durable knowledge AND a work journal into a persistent memory, so that
  if the agent's memory were wiped, reading the brain would reconstruct the work.
  Two modes: (A) Knowledge notes — decisions, findings, facts, fixed gotchas,
  research results, how-tos, config; (B) Work journal — a timestamped log of what
  was actually done (tasks, commands, files changed, outcomes, blockers). Use
  whenever new info surfaces, when asked to "remember / note / save" something,
  after completing a chunk of work, and at session end. When UNSURE whether
  something is already captured: check first, then add if missing or fill gaps.
---

# Brain Capture

Keep two stores in sync:
- **A notes vault** (human-readable source of truth) — a directory of markdown notes (e.g. Obsidian). Configure its path for your machine.
- **A semantic index** (searchable recall) — a local vector/embeddings "brain" or any search index. Mirror every note here so it's findable by meaning, not just filename.

**Goal: total recall.** Erasing the agent's memory should lose nothing — the brain holds both the *knowledge* (mode A) and the *narrative of what was done* (mode B). Capture liberally. The only hard exclusions are secrets (keys, credentials, personal data) and pure pleasantries with zero informational content.

## Decision flow
When knowledge worth keeping appears (or you're unsure if it's already saved):
1. **Check if it exists** — search the semantic index for the topic; glob/grep the vault for a matching note.
2. **If it does NOT exist → add it** to both stores.
3. **If it DOES exist → read, compare, fill gaps.** Append new details; fix stale facts. If nothing's missing, say it's already covered.

## Mode A — Knowledge notes
- Pick the best-fit folder (keep the vault flat — top-level folders only, no deep nesting). Default to an `Inbox`.
- Filename: a stable, descriptive title. Frontmatter: `title`, `type` (reference/decision/howto/security), `date`, `tags`, `summary`. Link related notes with `[[wikilinks]]`.
- Mirror into the semantic index with a stable slug = the title in kebab-case.

## Mode B — Work journal (capture everything done)
- One note per session/day, in a `Sessions` folder, named `YYYY-MM-DD - <Topic>.md`. Append if it exists.
- Log to the minute: the task as the user stated it, each meaningful action (commands, files created/edited with paths, tool calls), decisions + reasoning, outcomes/errors/resolutions, blockers, next steps.
- Distil reusable facts from the journal into mode-A knowledge notes.

## Conventions
- **Both stores, every time.** A vault note without an index mirror won't be found by recall; an index entry without a vault note isn't human-browsable.
- **Don't duplicate** — always search before creating; update rather than spawn near-duplicates.
- **No secrets.** Durable knowledge only — not transient chatter that won't be reused.

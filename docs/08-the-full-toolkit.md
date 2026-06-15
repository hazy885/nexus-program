# 08 — The full toolkit (everything that makes it work)

This repo is the **core discipline**. But the setup that turns Claude into a senior engineer also leans on an ecosystem of external skills, agents, MCP servers, and tools. This is the complete, linked inventory — what each thing is, and why it earns its place.

> Honesty first: you do **not** need all of this. The core (`skills/` + `agents/` + `hooks/` in this repo) is 90% of the value. Everything below is *additive* — install deliberately, because every tool is also surface area and token cost. The lesson from running this in production: **tiny global defaults + repo-local rules beat a giant universal setup.**

---

## 1. The core (this repo)

- `skills/dev-core` — the always-on senior operating loop.
- `skills/engineering-fundamentals` — complexity/simplicity/tradeoffs reference.
- `skills/brain-capture` — dual-store memory discipline.
- `skills/{plan,ship,audit,ideate}` — the workflow commands.
- `agents/senior-review` — the adversarial reviewer.
- `hooks/{verify-gate,session-journal}` — the deterministic test gate + auto-journal.

---

## 2. Orchestration & agent fleets

When one agent isn't enough — fan out, run adversarial panels, or coordinate a swarm.

- **[ruvnet/ruflo](https://github.com/ruvnet/ruflo)** (npm/CLI: `claude-flow`) — *the* agent meta-harness for Claude Code. 100+ specialised agents (coder, researcher, reviewer, security-auditor, sparc-*, consensus/byzantine coordinators), swarm topologies, SPARC methodology, GitHub automation, memory (AgentDB), hooks, and a huge plugin suite (ADR, DDD, testgen, observability, RAG memory, cost-tracker, and more). This is where the broad agent fleet comes from. Install via `npx ruflo init`.
- **Built-in Claude Code subagents** — `Explore` (read-only fan-out search), `Plan` (architecture planning), and custom agents in `.claude/agents/` (like `senior-review` here). Use these to keep the main context clean and to get a fresh-context second opinion.
- **The pattern that matters:** *adversarial verification*. Spawn N independent reviewers per finding, each prompted to **refute** it. A claim that survives skeptics is trustworthy; one that doesn't gets killed before it ships.

---

## 3. Skills ecosystems

- **[anthropics/skills](https://github.com/anthropics/skills)** — Anthropic's official Agent Skills. The document skills alone are worth it: **docx, pdf, pptx, xlsx** (create/edit real Office + PDF files), plus **skill-creator** (build new skills correctly), **mcp-builder** (scaffold MCP servers), and **frontend-design** (distinctive UI, avoids "AI slop"). Install as a plugin marketplace: `/plugin install document-skills@anthropic-agent-skills`.
- **The Agent Skills standard** — [agentskills.io](https://agentskills.io). Skills are an open format (a folder + `SKILL.md`), so the same skills work across Claude Code, Codex, Cursor, Gemini CLI, and more.
- **[safishamsi/graphify](https://github.com/safishamsi/graphify)** — turns any codebase (or docs/PDFs/images/video) into a **queryable knowledge graph**: god nodes, community detection, `/graphify` query/path/explain. ~71x fewer tokens per query than raw context, all local. The answer to "how do I ask questions about a huge codebase."
- **Stack skills (the pattern):** keep **one small skill per framework/tool in your stack** (your Flutter conventions, your Postgres/RLS rules, your API patterns, your security checklist), each with a precise *"Use when…"* description so it loads only when relevant. This is how the agent applies *your* conventions, not generic ones — without bloating every session.

---

## 4. The brain (persistent memory)

See `03-the-brain.md` for the full design. The pieces:

- **A notes vault** — any markdown directory ([Obsidian](https://obsidian.md) works great). Human-readable source of truth.
- **A semantic index** — a local "brain" that recalls by meaning. Options: a local vector store, an embeddings DB, or **[RyanCodrai/turbovec](https://github.com/RyanCodrai/turbovec)** (fast local vector search, no hosted DB) for the index half.
- **[safishamsi/graphify](https://github.com/safishamsi/graphify)** — the *code* knowledge-graph half (structure & relationships), complementing the *notes* half.

The `brain-capture` skill + `session-journal` hook keep both stores written automatically.

---

## 5. MCP servers (reaching the outside world)

[Model Context Protocol](https://modelcontextprotocol.io) is the standard for connecting the agent to structured systems. The ones worth wiring:

- **[supabase-community/supabase-mcp](https://github.com/supabase-community/supabase-mcp)** — inspect schema, run read queries, apply migrations to a *dev* project, and pull security advisors. ([Supabase MCP docs](https://supabase.com/docs/guides/getting-started/mcp).) This is how the agent audits RLS and ships migrations directly.
- **A browser MCP** (e.g. Claude-in-Chrome) — drive a real browser for UI verification and scraping.
- **A design MCP** (Figma) — design-to-code and back.
- **Productivity MCPs** — Gmail, Google Calendar, Google Drive, ClickUp, scheduled tasks — let the agent act in the tools you already use.
- **Browse more:** the [MCP server registry](https://github.com/modelcontextprotocol/servers).

> Principle: **CLI tools for breadth, MCP for structured depth.** The agent already knows `gh`, `aws`, `gcloud`; an MCP earns its place when you need a typed integration.

---

## 6. Capability repos (CLI tools & MCPs I install per-need)

| Repo | What it adds |
|---|---|
| [googleworkspace/cli](https://github.com/googleworkspace/cli) (`gws`) | One CLI for all Google Workspace APIs. |
| [louislva/claude-peers-mcp](https://github.com/louislva/claude-peers-mcp) | Multiple Claude Code instances message each other. |
| [HKUDS/CLI-Anything](https://github.com/HKUDS/CLI-Anything) | Auto-generate agent-native CLIs for any app. |
| [HKUDS/OpenSpace](https://github.com/HKUDS/OpenSpace) | Self-evolving agent skills. |
| [karpathy/autoresearch](https://github.com/karpathy/autoresearch) | Overnight autonomous ML-experiment agent. |
| [RyanCodrai/turbovec](https://github.com/RyanCodrai/turbovec) | Fast local vector search (TurboQuant). |

---

## 7. Plugins (bundled skills + hooks + agents + MCPs)

Claude Code plugins install a whole bundle from a marketplace in one command (`/plugin`):

- **anthropic-agent-skills** — the official document/creative/technical skills (§3).
- **[ruflo](https://github.com/ruvnet/ruflo)** — the orchestration + agent-fleet suite (§2).
- **Anthropic's first-party plugins** — code-review, feature-dev, commit-commands, frontend-design, and language tooling (LSP).

---

## How it all fits

```
        ┌─────────────────── dev-core (always-on senior loop) ───────────────────┐
        │                                                                          │
  /plan ─▶ /ship ─▶ verify-gate (hard test gate) ─▶ senior-review (adversarial)   │
        │     │                                                                    │
        │     └─ engineering-fundamentals (consulted)                              │
        │                                                                          │
   brain-capture + session-journal ──▶ vault + semantic index (total recall)      │
        │                                                                          │
   ruflo agents · graphify · MCP servers · capability CLIs (reach & scale)         │
        └──────────────────────────────────────────────────────────────────────────┘
```

Start with the core. Add a piece only when you hit the wall it solves.

# Tools & MCPs

Skills change *how* the agent thinks; tools and MCP servers change *what it can reach*. The principle: **CLI tools are the most context-efficient way to touch the outside world** — the agent already knows how to drive `gh`, `aws`, `gcloud`, etc., and they return compact output. Reach for an MCP server when you need a structured integration (a database, a design tool, a browser).

## MCP servers worth wiring

- **A database MCP** (e.g. Supabase) — let the agent inspect schema, run read queries, and apply migrations against a *dev* project. Pair it with security advisors so it can audit RLS/policies directly.
- **A memory/brain MCP** — a local semantic index the agent writes notes to and recalls from (see `the-brain.md`). This is what makes knowledge persist.
- **A browser MCP** — drive a real browser for UI verification and scraping instead of guessing.
- **Figma / design MCP** — turn designs into code and back.

> Rule of thumb: **automated/CLI for breadth, the agent's reasoning for depth.** Don't make the agent click pixels when a CLI exists.

## Open-source repos in this toolkit

These are external projects this setup leans on. Install deliberately — each adds real capability but also surface area.

| Repo | What it adds |
|---|---|
| [googleworkspace/cli](https://github.com/googleworkspace/cli) (`gws`) | One CLI for all Google Workspace APIs (Drive, Gmail, Calendar, Sheets). |
| [louislva/claude-peers-mcp](https://github.com/louislva/claude-peers-mcp) | Lets multiple Claude Code instances on one machine discover and message each other. |
| [HKUDS/CLI-Anything](https://github.com/HKUDS/CLI-Anything) | Auto-generates agent-native CLIs for any app — "CLI is the universal interface for agents." |
| [HKUDS/OpenSpace](https://github.com/HKUDS/OpenSpace) | Self-evolving agent skills that improve themselves over time. |
| [karpathy/autoresearch](https://github.com/karpathy/autoresearch) | An agent that runs overnight ML-training experiments and keeps the wins. |
| [RyanCodrai/turbovec](https://github.com/RyanCodrai/turbovec) | A fast local vector-search index (Google's TurboQuant) — embeddings without a hosted DB. |

## The "what actually stays installed" lesson

A practitioner truth worth internalising: **tiny global defaults + repo-local rules beat a giant universal setup.** Most tools get uninstalled for config complexity, overlapping functionality, and token-budget cost. Install what earns its place; delete what doesn't. This whole repo is intentionally small for that reason.

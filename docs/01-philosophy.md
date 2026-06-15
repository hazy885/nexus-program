# 01 — Philosophy: context engineering

The whole setup rests on one idea: **the scarce resource is the model's attention, not its intelligence.**

An LLM has a finite attention budget and degrades as its context fills ("context rot"). So the job isn't to cram in more rules — it's to find **the smallest set of high-signal tokens that maximise the chance of the outcome you want.** This is *context engineering*, and it's the difference between a setup that works and one where the model ignores half your instructions.

Everything here follows from that:

- **A lean always-on core** (`dev-core`) — the senior operating loop, kept short so it's actually followed. Bloat makes rules get dropped.
- **On-demand skills** (`engineering-fundamentals`, `/plan`, `/ship`, `/audit`, `/ideate`) — richer guidance loaded only when relevant, so it doesn't tax every turn.
- **Subagents** — isolate big reads and reviews in their own context window so they don't pollute the main thread.
- **A brain** — move durable knowledge *out* of the context window into a vault + index, and pull it back just-in-time.
- **Hooks** — for the things that must be deterministic (a test gate, an auto-journal), because skills are only ~70% adhered to.

## The three layers of the discipline

1. **Prompt engineering** — phrasing a single request well.
2. **Context engineering** — curating *everything* in the window across a whole task: system prompt, tools, retrieved data, memory.
3. **Harness engineering** — designing the loop itself: verification gates, reviewer topology, memory/compaction strategy.

Senior Claude is mostly layers 2 and 3. The model is the same; the harness is what makes it behave like a senior.

## Sources
- Anthropic — *Effective context engineering for AI agents*
- Anthropic — *Best practices for Claude Code*
- Ousterhout, *A Philosophy of Software Design* (complexity); Hickey, *Simple Made Easy* (simple vs easy)

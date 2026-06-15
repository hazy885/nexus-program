---
name: dev-core
description: Core engineering discipline for every coding task — how to approach work, plan, decide, verify, and self-review. Always apply when writing or changing code.
---

# Dev Core — the Senior Operating Loop

Work like a senior engineer who owns the outcome, not a code generator. Match depth to the task: trivial edits (typo, log line, rename) — just do it; anything multi-file, unfamiliar, or with an unclear approach — run the full loop.

**0. Approach & capability check.** Before planning: name the problem type, pick the matching skill(s), and honestly gauge whether you actually know this — grounded in evidence (read the code/docs), not a hunch. If confidence is low: research first, ask, or delegate to a reviewer. Hallucinated competence is the main risk — never present a guess as fact.

**1. Right altitude / plan-gate.** For non-trivial work, before writing code produce a short plan: files to change, the approach, what is explicitly out of scope, and how it will be verified. Triage the decision — two-way door (reversible) → move fast; one-way door (irreversible: datastore, public API shape, auth model, dependency lock-in) → slow down, weigh alternatives, and record a decision (ADR) before committing. Get a nod before implementing. If you could describe the diff in one sentence, skip the plan.

**2. Stop on load-bearing assumptions.** If the change depends on an assumption you can't confirm by reading the code or docs, STOP and ask — never charge ahead on a guess. (The #1 way agents waste a day.)

**3. Scope discipline.** Change only what the task requires. No orthogonal "while I'm here" edits. If you spot an unrelated bug or cleanup, note it for later — don't fix it inline.

**4. Tradeoffs.** For any real design decision, state the chosen approach, the main alternative, and why — in a line or two. Don't silently pick.

**5. Verify with evidence.** Where it fits, write a failing test first, then make it pass (mutation-resistant assertions — assert real values, not truthiness). Run the tests/build/lint and show the actual output. Never claim "done" or "fixed" without a check the reader can see. If you can't verify it, say so.

**6. Adversarial self-review before done.** Re-read your own diff as a hostile reviewer: null/empty inputs, runs-twice/idempotency, concurrency, error/timeout paths, boundary values, auth, secrets. Fix what's real; mention residual risks.

**Definition of done:** requirement met · scope not exceeded · verification shown · self-review pass · nearby same-class risks flagged. For a heavier independent check, delegate to the `senior-review` subagent.

---

## Code rules
- Minimum code, most direct approach, no over-engineering.
- No helper/abstraction unless actually reused. No comments unless the *why* is non-obvious.
- Follow the existing patterns in the file you're editing.
- If something is unused, delete it — no compatibility shims or `// removed` comments.

## Communication
- No filler openers. Research/investigation/explanation happen *before* the code.
- State uncertainty plainly and say what's needed to resolve it.
- One short paragraph after code, not a bullet list of "here's what I did."

# How the agent approaches code

The single behaviour that separates a senior from a junior: **a junior starts typing; a senior runs a loop.** This is the loop `dev-core` enforces, in practice — the exact order the agent moves through a task.

> Match depth to the task. A typo or one-line fix skips most of this — *if you could describe the diff in one sentence, just do it.* The loop is for anything multi-file, unfamiliar, or where the approach isn't obvious.

## The loop

### 1. Understand the real problem
Restate it: what's the unknown, the inputs, the constraints, the definition of "done," who's affected? Most wasted work is a confident solution to the *wrong* problem. Don't proceed until you can state it back clearly. If the request is ambiguous on a load-bearing point — **ask, don't guess.**

### 2. Research before concluding
Never rely on training knowledge alone for anything version-, API-, or framework-specific. Search first (see `researching.md`), and list what each source confirmed. The model's memory is a starting hypothesis, not the answer.

### 3. Read the codebase before forming an opinion
- Read every file directly involved, plus what they import/call and the config/env that affects them.
- **Never assume what a file contains from its name.** Never assume the bug is in the obvious place.
- If you can't see enough, say exactly which file you need rather than guessing.

### 4. Isolate before diagnosing
When behaviour is unexpected, reproduce it in the simplest possible context — a REPL, a minimal case, hardcoded values, as a superuser. This separates a logic bug from an environment/permissions/config bug. If it works in isolation, the problem is in the surrounding context, not the core logic.

### 5. Show the investigation, then explain before code
Before writing the fix, walk through: what was researched (with sources), what was read, what was ruled out and why, and the actual root cause with evidence. Then explain — in plain terms — what's wrong, why, and what the fix does. (This is also how the human you're working with *learns*, instead of just receiving a diff.)

### 6. Plan (for non-trivial work) and triage the decision
Produce a short plan: files to change, the approach, what's explicitly out of scope, how it'll be verified. State the main alternative and why you rejected it. Triage reversibility — **two-way door** (reversible) → move fast; **one-way door** (datastore, public API, auth model) → slow down and record an ADR. Get a nod before building.

### 7. Build — minimum, in scope
Smallest change that solves it. No helpers/abstractions unless actually reused, no comments unless the *why* is non-obvious, no orthogonal "while I'm here" edits. Follow the patterns already in the file. Fix root causes, not symptoms.

### 8. Verify with evidence
Where it fits, write a failing test first, then make it pass (assert real values, not truthiness). Run the tests/build/lint and **show the output.** Never say "done" or "fixed" without a check the reader can see. If you can't verify it, say so.

### 9. Self-review, then delegate the hard check
Re-read your own diff as a hostile reviewer: null/empty, runs-twice/idempotency, concurrency, error/timeout paths, boundaries, auth, secrets. For anything that matters, hand the diff to the `senior-review` subagent — a fresh context that didn't write the code grades it honestly.

### 10. Confirm and teach
One short paragraph: what was broken, what the fix does, the **name of the pattern** if there is one (N+1, async gap, RLS block, race), and any nearby code at risk of the same bug.

## Why this works
Each step removes a class of junior failure: solving the wrong problem (1), hallucinating an API (2), assuming from filenames (3), fixing the wrong layer (4), unexplained magic (5), scope creep and irreversible mistakes (6–7), "looks done" (8), the bugs the author can't see (9). It's not slower in the end — it's the difference between one correct pass and three wrong ones.

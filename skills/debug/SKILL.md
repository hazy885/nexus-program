---
name: debug
description: Find the root cause of a bug with a systematic, evidence-based method instead of guessing or changing things at random. Use when something is broken, failing, erroring, flaky, or behaving unexpectedly and the cause isn't obvious.
---

Debug: $ARGUMENTS

Treat the bug as a hypothesis-testing problem, not a slot machine. Do NOT start changing code to "see if it helps" — that introduces new bugs and teaches you nothing. Work the method.

## 1. Reproduce it first
Get a reliable repro and read the **actual** error/stack/output — not what you assume it says. No reproduction = nothing to debug yet; make it happen on demand before going further. Note the exact inputs, environment, and steps.

## 2. Understand the system before changing it
Read the code on the failing path — every file actually involved, plus what they call and the config/env that affects them. Never assume from a filename or how you *think* it's implemented. Quiet the noise: strip the problem down to a minimal case.

## 3. Isolate — code bug or environment bug?
Reproduce in the simplest possible context: a REPL, a minimal script, hardcoded inputs, elevated permissions. This answers the highest-value question fast:
- Works in isolation → the bug is in the surrounding **context** (config, data, permissions, integration, ordering). Stop reading the function.
- Still breaks in isolation → you've trapped it in the logic. Keep narrowing.

## 4. Hypothesize → predict → test ONE thing
- **Hypothesize** a specific, *falsifiable* cause ("timestamp stored UTC, compared as local"), not a vague one ("something's off with dates").
- **Predict** what else must be true if that's the cause.
- **Change ONE variable** and check the prediction. **Never change two things at once** — if it then works you won't know which fixed it.
- **Confirmed** → fix the root cause. **Refuted** → discard it and form the next hypothesis from what you learned. Don't cling to a dead theory.

Keep a running ledger of what you ruled out and why ("not the DB — query returns right rows; not the API — payload logged correct; so it's the client mapping"). This is how you converge instead of circling.

## 5. Fix the cause, not the symptom
Ask "why" until it bottoms out — the null is the symptom, *why was it null* is the bug. Reject the first plausible cause if evidence doesn't confirm it (it's often a second symptom of the same root). Don't patch the wrong layer (a UI guard for a query bug is debt that resurfaces).

## 6. Verify and seal it
- Write a **failing test that reproduces the bug**, then make it pass — proof it's real and proof it's gone. Re-run the full suite for regressions. Show the output.
- Note the **pattern name** (race, N+1, async gap, off-by-one, timezone, RLS block) and scan for the same bug nearby.

## When stuck
If two or three hypotheses are refuted and you're out of ideas: widen the input (read more of the code path / logs), question an assumption you've been treating as given, or get a second pair of eyes (the `senior-review` subagent in a fresh context). Don't escalate to random changes.

## Backing
George Pólya, *How to Solve It* · David Agans, *Debugging* (Understand the system; Make it fail; Quit thinking and look; Divide and conquer; Change one thing at a time; Keep an audit trail) · Andreas Zeller, *Why Programs Fail* (scientific debugging) · 5 Whys root-cause analysis. Full write-up in `docs/playbooks/solving-problems.md`.

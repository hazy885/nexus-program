---
name: refactor
description: Improve the structure of code WITHOUT changing its behavior — safely, in small test-backed steps. Use when asked to refactor, clean up, simplify, restructure, de-duplicate, or untangle code, or before adding a feature to messy code ("first make the change easy, then make the easy change").
---

Refactor: $ARGUMENTS

Refactoring = changing internal structure **without changing observable behavior** (Fowler). The discipline is what separates a refactor from a rewrite-that-broke-things. Behavior change and structure change are two different commits — never mix them.

## 1. Pin behavior first — tests are the safety net
- You cannot safely refactor code you can't verify. If the area has **no tests, write characterization tests first** — tests that capture what the code *currently* does (even if it's "wrong") so any behavior change shows up red.
- Run the suite green *before* you touch anything. A green baseline is the whole point.

## 2. Scope it — structure only, behavior frozen
- Define exactly what improves and confirm behavior is held constant. If you discover a bug mid-refactor: **note it, don't fix it here** — fix it in a separate change so the diff stays "structure only." (See `docs/playbooks/staying-in-scope.md`.)
- Don't gold-plate. Refactor what the task needs, not every imperfection you pass.

## 3. Small steps, green between each
- Take **one named refactoring at a time** (Extract Function, Inline, Rename, Move, Replace Conditional with Polymorphism, Introduce Parameter Object…) and **run the tests after each step.** Many tiny verified moves beat one big leap you can't bisect.
- Commit (or checkpoint) at each green state so any break is a clean one-step revert.

## 4. Aim at real complexity, not taste
Target what `engineering-fundamentals` flags as cost: deep modules over shallow ones, reduce coupling / raise cohesion, kill change-amplification and cognitive load. Apply DRY only to *true* duplication (same knowledge), not coincidental similarity — premature deduplication creates worse coupling than the duplication it removed. Three similar lines can beat the wrong abstraction.

## 5. Verify behavior is identical
Run the full suite (and linter/build) and show it green. If anything changed observably, you didn't refactor — you introduced a change; isolate it. For risky moves, hand the diff to the `senior-review` subagent to confirm no behavior drift or scope creep.

## When NOT to refactor
- Mid-feature with no tests and no time to write them — add the characterization tests first, or do the feature and refactor after.
- For aesthetics alone on code that's stable, untouched, and not in your path — leave it; the risk isn't free.

## Backing
Martin Fowler, *Refactoring* (named mechanics + "make the change easy, then make the easy change") · Michael Feathers, *Working Effectively with Legacy Code* (characterization tests; "legacy code = code without tests") · Kent Beck (separate behavior-change commits from structure-change commits) · Ousterhout on complexity (`docs/concepts/the-method.md`, `skills/engineering-fundamentals`).

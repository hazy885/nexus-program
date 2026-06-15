---
name: ship
description: Implement an agreed plan with senior-engineer discipline, then self-review and verify before declaring done. Use after /plan is approved, or for a well-scoped change.
---

Implement: $ARGUMENTS (follow `PLAN.md` if it exists).

Work like a senior engineer who owns the result:

1. **Implement** the minimum code to meet the plan. Stay strictly in scope — no orthogonal edits. Follow existing patterns in the codebase.
2. **Test.** Where it fits, write a failing test first, then make it pass. Use mutation-resistant assertions (assert real values, not truthiness). For non-trivial logic (parsers/serializers, transforms, math, dedup, geo, money), prefer **property-based / invariant tests** over only example tests — assert properties that hold for all inputs: round-trip (`decode(encode(x)) == x`), idempotency (`f(f(x)) == f(x)`), bounds/monotonicity, conservation. Keep targeted example tests for known edge cases.
3. **Verify.** Run the tests, build, and linter. Show the actual output. Fix root causes, not symptoms — don't suppress errors or hard-code to pass tests.
4. **Adversarial self-review** of your own diff: null/empty inputs, runs-twice/idempotency, concurrency, error/timeout paths, boundary values, auth, secrets. Fix what's real.
5. For a heavier independent check, delegate the diff to the `senior-review` subagent.
6. **Summarize** in one short paragraph: what changed, the evidence it works (test/build output), and any residual risk or nearby same-class issues.

Do not claim done without verification the reader can see. If something can't be verified, say so and why.

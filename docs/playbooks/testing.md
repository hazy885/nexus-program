# How it tests (verify with evidence)

A junior says "it works." A senior **shows the output.** Testing here isn't a phase at the end — it's how a claim becomes evidence. This is the discipline behind step 8 of the [coding loop](approaching-code.md) and the `verify-gate` hook.

## The one rule everything serves
**Never say "done," "fixed," or "works" without a check the reader can see.** If you can't verify it, say so plainly and say what's needed to. An assertion is not evidence; test output, a build log, or a screenshot is.

## Bug fixes: reproduce first
The first artifact of a bug fix is a **failing test that reproduces it** — *before* the fix. It proves the bug is real, that you understood it, and (once green) that it's actually gone. Fixing without a failing test means you're guessing the fix and guessing it worked. Then: make it fail → fix → make it pass → confirm the rest of the suite still passes.

## Write tests that can actually fail
- **Assert real values, not truthiness.** `expect(total).toBe(42)`, not `expect(total).toBeTruthy()`. A test that can't distinguish right from wrong is theater.
- **Mutation-resistant.** Ask: if I broke the logic, would a test go red? If not, the test isn't testing. (Mutation testing — flip a `+` to `-`, see if anything fails — is the formal version of this check.)
- **Test behavior, not implementation.** Assert the contract (inputs → outputs, observable effects), not private internals — so a refactor doesn't break the suite for no reason.
- **One reason to fail per test.** When it goes red, the name should tell you what broke.

## Cover the edges, not just the happy path
The happy path is the easy 20%. Bugs live in: empty / null / zero, the boundary (off-by-one, first/last, max+1), the duplicate, the out-of-order, the concurrent, the failure path (timeout, partial write, exception mid-operation). **Property-based testing** earns its keep here — instead of hand-picking cases, state an invariant ("decode(encode(x)) == x for all x") and let the tool generate hundreds of inputs, including the adversarial ones you'd never think to write.

## Match the test to the level (the pyramid)
- **Unit** — fast, many, pure logic. The base — most of your tests.
- **Integration** — fewer; real boundaries (DB, API, queue) wired together. Where the interesting bugs hide.
- **End-to-end** — fewest; slow, brittle, but they prove the whole thing runs. A handful of critical-path flows, not everything.

Inverting this (mostly E2E, few units) gives slow, flaky suites that no one trusts — and an untrusted suite is worse than none, because red stops meaning "broken."

## What NOT to test
Discipline is also restraint (per `engineering-fundamentals`):
- Don't test the framework, the language, or third-party code you don't own.
- Don't write tests for code that can't break (trivial getters, pure config).
- Don't chase a coverage number — 100% coverage of weak assertions proves nothing. Coverage shows what was *executed*, not what was *verified*. Aim coverage at the critical and the fragile.

## Beyond the test suite
"Verify" is broader than unit tests — use the cheapest check that produces real evidence:
- **Types / compiler / linter** — the fastest test; let them catch what they can for free.
- **The running thing** — for anything observable in a browser or server, drive it and capture the result (the preview tools here do this: reload, check console/network, snapshot, screenshot) rather than asking the human to look.
- **A second pass** — hand the diff to the `senior-review` subagent; a fresh context catches what the author's can't.

## Testing to *improve*, not just to verify
Tests confirm correctness; sometimes the goal is to make something measurably *better* (faster, smaller, cheaper, more accurate). That's a different loop — **measure a baseline → change one variable → re-measure → keep only what moves the metric** — run by the `/optimize` skill (the autoresearch-style experiment loop). It sits on top of this discipline: the correctness suite here is the guardrail that keeps an optimization from trading away correctness for speed.

## How it's wired here
- **`verify-gate` hook** (opt-in per repo via a one-line `.claude/verify.cmd`) — a deterministic Stop gate that runs your test command and **won't let the turn end red.** This is the part that doesn't rely on the model's goodwill: skills are advisory (~70%), the gate is real (see [`../concepts/hooks.md`](../concepts/hooks.md)).
- **The loop** (`dev-core`, step 8) makes write-a-failing-test-first and show-the-output the default, not an afterthought.
- **`/ship`** bundles implement → verify → self-review so shipping always carries evidence.

## Sources
Kent Beck, *Test-Driven Development* · the test pyramid (Mike Cohn / Martin Fowler) · property-based testing (QuickCheck lineage) · mutation testing.

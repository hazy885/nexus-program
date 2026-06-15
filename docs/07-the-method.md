# 07 — The method (with sources)

The skills aren't vibes — each encodes an established method. This is the backing, condensed.

## How to engineer (the loop)

Every methodology collapses to one iterative loop (Pólya, *How to Solve It*, 1945):

**Understand → Plan → Build → Verify → Reflect.**

- The biggest senior trait is over-investing in **Understand** — most wasted work is confidently solving the wrong problem.
- **Knowing whether you have the skill** is metacognition + calibration: classify the problem, match it to a known pattern, *honestly* estimate confidence, and if it's low — research, ask, or delegate. The trap (especially for an AI) is *hallucinated competence*: feeling sure while wrong. The fix is to ground every confidence check in evidence — read the code, run a test, cite the doc — never vibes. (Dreyfus model of skill acquisition.)

## Fundamentals worth holding

- **Complexity is the enemy** (Ousterhout) — deep modules, information hiding.
- **Simple ≠ Easy** (Hickey) — choose un-entangled even when it's harder now.
- The famous principles (DRY/KISS/YAGNI/SOLID) are **tensions to manage, not laws** — e.g. duplication is often safer than the wrong abstraction.

## Decisions

**One-way vs two-way doors.** Most decisions are reversible — decide fast, experiment. The few irreversible ones (datastore, public API shape, auth model) — slow down and record an ADR with the context, alternatives, and why.

## Knowing you're correct

- **Make it work → right → fast.** Never skip "right"; never start at "fast."
- Tests are **evidence**. **Property-based / invariant testing** (round-trip, idempotency) red-teams inputs you'd never hand-write.
- **Debugging is science**: hypothesis → smallest test to refute it → divide and conquer → isolate in the simplest context.

## How to audit

- **Layers:** peer review (code health) + security audit (threat-led, OWASP) + automated analysis (SAST/DAST/SCA). Automated for breadth, human for depth.
- **The strongest "is it thorough?" lever is pace/size** (SmartBear/Cisco, the largest published study): audit **200–400 lines at a time, ≤500 LOC/hr, ≤60–90 min**. Detection collapses from ~87% (<100 lines) to ~28% (>1,000 lines).
- **STRIDE** at each trust boundary; **OWASP Top 10** as the focus list.
- **The AI caveat:** LLM auditors *hallucinate vulnerabilities* (best agents ~78% precision). So: verify every finding against the code before reporting, and layer LLM reasoning on top of deterministic scanners.

## How to generate ideas

- **Counter-intuitive, best-backed finding:** group brainstorming underperforms — individual generation then pooling (brainwriting) produces more and better ideas (production blocking).
- Frame as a **Job-to-be-Done**; diverge widely (defer judgment); converge with desirability→feasibility→viability + ICE; then test the **riskiest assumption** cheaply before building.

## Primary sources
Anthropic Claude Code & context-engineering docs · Pólya *How to Solve It* · Dreyfus skill-acquisition model · Ousterhout *A Philosophy of Software Design* · Hickey *Simple Made Easy* · *The Pragmatic Programmer* · Bezos one-way/two-way doors + ADRs · Beck/Kernighan *make it work/right/fast* · OWASP Top 10 & Secure Code Review Guide · SmartBear/Cisco code-review study · Diehl & Stroebe (brainstorming productivity loss) · Christensen Jobs-to-be-Done.

---
name: optimize
description: Improve a measurable outcome through controlled experiments — measure a baseline, change one variable, re-measure, keep only what actually moves the metric. Use when asked to make something faster/smaller/cheaper/more-accurate, tune parameters, improve a benchmark or prompt, or "see if you can make this better." Not for fixing bugs (/debug) or behavior-preserving cleanup (/refactor).
---

Optimize: $ARGUMENTS

This is empirical, not guesswork — the same loop an autonomous experiment agent runs ([karpathy/autoresearch](https://github.com/karpathy/autoresearch)): hypothesize → run → measure → keep what wins. You do **not** "improve" things by eyeballing them; you prove each gain with a number. Most "optimizations" made without measurement are neutral or negative.

## 1. Measure first — baseline or stop
You cannot improve what you don't measure. Before changing anything:
- **Build/confirm a repeatable measurement** — a benchmark, a timing harness, an eval set, a metric script. It must be deterministic enough to compare runs (fix seeds, control inputs, average across N runs to beat noise).
- **Record the baseline number.** This is the bar every change is judged against. No baseline → no optimization, just hope.
- **Profile to find the real bottleneck.** Optimize the part that actually dominates the metric, not where you *assume* the cost is (Knuth: premature optimization is the root of much evil — and optimizing the wrong 90% is wasted either way).

## 2. Set the target and the guardrails
- **Target:** what "better" means and how much is enough (a number or a "until diminishing returns").
- **Guardrails — what must NOT regress:** correctness tests stay green, output stays within tolerance, other metrics don't degrade. **Optimization that silently trades away correctness is a regression, not a win.** Lock these as a gate before you start.

## 3. One change per experiment
- **Hypothesize a specific, falsifiable lever** ("batching these calls will cut latency ~30%") with the reasoning — not a vague "make it faster."
- **Change exactly ONE variable, then re-measure** on the same harness. Never change two things at once: if the metric moves you won't know which change did it, and you can't keep the real winner.

## 4. Keep or revert on the evidence
- **Improved the metric AND held the guardrails → keep it.** Lock in the new baseline.
- **No improvement, or broke a guardrail → revert it.** Log *why* it didn't work — negative results are data; they prune the search space and stop you re-trying dead ends.
- Accumulate only proven wins. The diff at the end is the set of changes that each measurably helped.

## 5. Iterate until target or flat
Loop steps 3–4. **Stop when** the target is hit, the budget is spent, or returns flatten (each experiment buys steadily less). Don't grind past diminishing returns — hand that judgment to the `circuit-breaker` instinct (`docs/playbooks/handling-uncertainty.md` / the stop-the-line agent).

## 6. Report with numbers
- **Baseline → final**, with the delta (e.g. `420ms → 240ms, −43%`).
- **Each kept change and its measured contribution**; the notable things tried that *didn't* work and why.
- **Reproducibility:** the harness, seeds, and conditions, so the result can be re-verified — not taken on faith.

## Guardrails against fooling yourself
- **Don't overfit the benchmark.** Improving the metric by gaming the specific test (memorizing the eval set, tuning to one input) isn't a real gain — validate on held-out cases too.
- **Control the noise.** A 2% "win" inside run-to-run variance is not a win; average enough runs to tell signal from noise.
- **Correctness gate is non-negotiable.** Re-run the full test suite on the final result; a faster wrong answer is worthless.
- **Report honestly.** If nothing beat the baseline, say so — a proven "no improvement available" is a valid, useful outcome, not a failure to hide.

## Backing
The scientific method / controlled experiments (one variable at a time) · [karpathy/autoresearch](https://github.com/karpathy/autoresearch) (autonomous measure-hypothesize-iterate experiment loop) · Knuth on premature optimization (profile first) · the testing discipline (`docs/playbooks/testing.md`) and evidence grading (`docs/playbooks/reasoning-about-solutions.md`). For heavy/parallel search, fan out experiments via the ruflo agent fleet or run an autoresearch-style overnight loop.

# How it reasons toward a solution (and how it knows it's right)

[Solving problems](solving-problems.md) is how it works *toward* an answer; [handling uncertainty](handling-uncertainty.md) is what it does when *unsure*. This is the layer between: given a candidate solution, **how does it decide that course is the right one — and what evidence backs that?** A junior commits to the first idea that could work. A senior treats a proposed solution as a *claim to be tested* before betting on it.

## 1. Don't commit to the first solution
The first idea that comes to mind is an anchor, not an answer. Before building, generate **2–3 genuinely different approaches** — even rough ones. If you can only think of one, you don't understand the problem space yet. Having alternatives is what turns "the thing I thought of" into "the best of the options," and it's the only way to *know* a course is good rather than merely *workable*.

## 2. Make the criteria explicit before you judge
You can't pick the "right" course without stating what "right" means *here*. Name the criteria the solution must satisfy, in priority order:
- **Correctness** — does it actually solve the stated problem, including the edges?
- **Fit to constraints** — the real ones: performance budget, the existing stack/patterns, time, the data model you can't change.
- **Simplicity** — the least complexity that solves it ([`engineering-fundamentals`](../../skills/engineering-fundamentals/SKILL.md)); a simpler solution that meets the bar beats a clever one that exceeds it.
- **Reversibility & blast radius** — how hard to undo, how much it touches if wrong.

Criteria written *after* you've fallen for an approach are just rationalization. Write them first.

## 3. Evaluate by trying to *falsify*, not confirm
This is the core move and the answer to "how do you know it's right." The instinct is to look for reasons your chosen approach works — that's **confirmation bias**, and it's how plausible-but-wrong solutions survive. Invert it:
- **Ask "what would have to be true for this to be the WRONG choice?"** — then go look for exactly that.
- **Seek disconfirming evidence** — the edge case it doesn't handle, the load it won't take, the prior art where this approach hit a wall, the constraint it quietly violates. A course that survives a genuine attempt to break it is trustworthy; one that was only ever defended is not.
- **Hold the opinion strongly but weakly** — commit enough to test it hard, but drop it the moment evidence refutes it. Clinging to a disproven approach is the expensive mistake.

A solution you've *tried and failed to break* is in a completely different epistemic class than one that merely *sounds right*.

## 4. The evidence hierarchy — what actually counts as backing
Not all "evidence" is equal. When you claim a course is right, grade what it rests on — strongest to weakest:

1. **You ran it and saw the result** — a passing test, a spike, real output. The gold standard. Empirical beats everything.
2. **You read the actual code / data / logs** — direct observation of *this* system, not assumption.
3. **Authoritative current sources** — official docs, the spec, a tracked issue confirming behavior in the version in play ([`researching.md`](researching.md)).
4. **Prior art / precedent** — it works elsewhere in this codebase, or a credible source did it this way.
5. **Reasoning from principles** — sound, but it's an argument, not a fact; it can be logically tidy and still wrong.
6. **Intuition / "it should work"** — the weakest. Usable as a *hypothesis to test*, never as a basis to ship. **Flag it as such** if it's all you have.

The rule: **state which rung your confidence sits on.** "Tests pass" and "I'm pretty sure" are not the same claim — never present the lower as if it were the higher.

## 5. Match the evidence to the stakes (the reversibility gate)
How much evidence you need before committing scales with how hard the choice is to undo:
- **Two-way door** (reversible — most code) → modest evidence is fine. Pick the well-reasoned option, build it, and let reality provide the rest. Speed of learning beats certainty.
- **One-way door** (irreversible — datastore, public API shape, auth model, dependency lock-in) → demand *strong* evidence first (rung 1–3), weigh alternatives explicitly, and record the decision (an ADR). Everything built later inherits this; cheap to get right now, brutal to reverse later.

Mismatch is the failure: agonizing over a reversible choice wastes time; winging an irreversible one is how projects get stuck.

## 6. Commit, and say why — with the alternative
Once a course clears the bar, commit and make the reasoning legible:
- **State the choice, the main alternative, and why you rejected it.** A decision without a named, rejected alternative wasn't actually a decision.
- **Cite the evidence and its rung** — "chose X; confirmed by the docs + a spike (rung 1–3); rejected Y because it violates the perf budget."
- **Note what would change your mind** — the observation that would send you back to step 1. This keeps "strong opinion, weakly held" honest, and tells the reviewer exactly where to push.

## The shape, in one line
**Generate real alternatives → write the criteria first → choose, then try hard to *falsify* the choice → back it with the highest rung of evidence you can reach → demand more evidence the more irreversible it is → commit with the alternative named and the evidence cited.**

## Backing
Karl Popper (falsification — a theory earns trust by surviving attempts to refute it) · confirmation-bias research (actively seek disconfirming evidence) · evidence-based practice (graded evidence hierarchies; empirical over expert opinion) · Bezos one-way/two-way doors & ADRs (`../concepts/the-method.md`) · Herbert Simon (satisfice — meet the bar, don't over-optimize) · "strong opinions, weakly held."

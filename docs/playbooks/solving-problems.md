# How it solves problems (a method, not a guess)

Going in blind looks fast and is the slowest thing you can do: you change something, it doesn't work, you change something else, and three "fixes" later you've introduced two new bugs and still don't understand the first one. A senior runs a **method** — understand, hypothesize, test one thing, conclude from evidence. This is the reasoning core underneath the [coding loop](approaching-code.md); the loop is *what* to do, this is *how to think* while doing it.

## The frame: Pólya's four steps
Every non-trivial problem runs through the same loop (George Pólya, *How to Solve It*):

1. **Understand the problem.** What's the unknown? What's given? What's the constraint? What does "solved" look like? Restate it in your own words — if you can't, you don't understand it yet, and a solution to a misunderstood problem is wasted no matter how good it is. **This is the step juniors skip and seniors spend the most time on.**
2. **Devise a plan.** *Then* think about the approach — before touching anything. Reach for a known tactic: solve a simpler version first, work backward from the goal, find a related problem you've solved before, split into sub-problems.
3. **Carry it out.** Execute the plan one deliberate step at a time, checking each step actually holds rather than assuming it does.
4. **Look back.** Verify the result against the original problem (not against your plan — against the *problem*). Then ask what this taught you for next time.

## Debugging is science, not flailing
A bug is a hypothesis-testing problem. Run it like an experiment, not a slot machine:

1. **Observe** — reproduce it reliably and read the *actual* error/output. No reproduction = nothing to debug yet; get one first.
2. **Hypothesize** — form a specific, falsifiable guess: *"the timestamp is UTC but compared as local."* Vague ("something's off with dates") can't be tested.
3. **Predict** — if that hypothesis is true, what else must be observable? ("then the offset equals my timezone, and UTC inputs work.")
4. **Test ONE thing** — change a single variable and check the prediction. **Never change two things at once** — if it then works, you don't know which one did it, and you've learned nothing.
5. **Conclude** — confirmed → fix the root cause. Refuted → discard it (don't cling) and form the next hypothesis from what you just learned.

> Keep a running record of what you ruled out and why. "Not the DB (query returns correct rows), not the API (logs show right payload), so it's the client mapping" is how you converge instead of circling.

## Isolate to split logic from environment
When behavior is wrong, shrink the context until only the suspect remains — a REPL, a minimal repro, hardcoded inputs, run as superuser/with permissions bypassed. This answers the single most useful debugging question: **is the bug in the code, or in the environment around it?** If it works in isolation, stop reading the function — the problem is config, permissions, data, or integration. If it still breaks in isolation, you've trapped it.

## Find the root cause, not the symptom
- **Ask "why" until it bottoms out.** The null pointer is the symptom; *why* was it null; *why* did that path allow null — fix the cause, not the crash site. A symptom fix relocates the bug; it doesn't remove it.
- **Reject the first plausible cause.** The obvious suspect is often a second symptom of the same root. Confirm with evidence before committing to it.
- **Don't fix the wrong layer.** A patch in the UI for a bug born in the query is technical debt that will resurface.

## Ground every claim in evidence
This is the line between solving and guessing:
- **Read the actual code / data / logs** before forming an opinion — never assume from a filename, a function name, or how you *think* it's implemented.
- **Research what you don't know** instead of pattern-matching from memory (see [`researching.md`](researching.md)) — training knowledge is a hypothesis, not a fact.
- **Verify the fix with output you can see** (see [`testing.md`](testing.md)) — "should work" is a guess; a green test is a conclusion.
- **State uncertainty honestly.** "I don't know yet — I need to see file X" is a senior answer. A confident guess presented as fact is the junior failure mode this whole method exists to prevent.

## Know when to stop and ask
Not every gap is yours to fill by guessing. If a decision is **load-bearing** — it changes the design, the data model, or the user-facing behavior — and you can't resolve it from the code or docs, **stop and ask one sharp question** rather than picking a direction and hoping. Guessing on a load-bearing assumption is the most expensive mistake in the method, because everything built on top inherits it.

## Why the method beats speed
Each step kills a specific failure: solving the wrong problem (understand), thrashing with no plan (devise), changing-two-things (test one), symptom-patching (root cause), hallucinating (evidence), and building on a bad assumption (stop and ask). It is not slower — it's **one correct pass instead of three wrong ones.**

## Sources
George Pólya, *How to Solve It* · the scientific method applied to debugging (*Debugging* by David Agans; *Why Programs Fail* by Andreas Zeller) · root-cause analysis (the "5 Whys").

---
name: engineering-fundamentals
description: Software design fundamentals reference. Use when planning a non-trivial change, choosing an approach/abstraction, reviewing code, or weighing a design trade-off — keeps complexity, simplicity, coupling/cohesion, and the DRY/KISS/YAGNI tensions in mind. Apply during the plan and review steps of any coding task.
---

# Engineering Fundamentals

A short reference to consult while planning and reviewing — not rules to obey, **tensions to manage**.

## Complexity is the enemy (Ousterhout)
The core job of design is managing complexity. It shows up as **change amplification** (one change forces edits in many places) and **cognitive load** (you must hold too much in your head). Fight it with:
- **Deep modules** — lots of functionality behind a *simple* interface. A shallow module (complex interface, little behind it) is a red flag.
- **Information hiding** — each module hides its implementation. Information *leakage* (one decision duplicated across modules) is the anti-pattern.

## Simple ≠ Easy (Hickey)
- **Simple** = un-entangled, one role, one concept ("not complected"). About the *thing*.
- **Easy** = familiar, close at hand. About *you*.
Choosing easy (fast now) buys complexity later. Prefer **simple** even when it's harder up front.

## Principles are trade-offs, not laws
- **DRY** — one authoritative source for each piece of *knowledge*. BUT duplication is often safer than the **wrong abstraction**.
- **KISS** — remove *unnecessary* complexity (not all complexity; not "shortest code").
- **YAGNI** — don't build for hypothetical futures. Ask "do I need this *now*?"
- **Coupling/cohesion** — independent components that change in isolation; high cohesion within, low coupling between.
- **Tracer bullets** — build a thin end-to-end skeleton first for real feedback, then flesh out. Prototype to *learn* (throwaway).

## Decision discipline
- **Two-way door (reversible)** → decide fast, experiment, move.
- **One-way door (irreversible / high blast radius: datastore, public API, auth model, dependency lock-in)** → slow down, lay out alternatives, record an ADR (context + alternatives + why).

## Correctness
- **Make it work → make it right → make it fast.** Don't skip "right"; don't start at "fast."
- **First make the change easy, then make the easy change.**
- Tests are **evidence**, with mutation-resistant assertions. For non-trivial logic prefer **invariants / property-based tests** (round-trip, idempotency) — they red-team inputs you'd never hand-write.

## Debugging is science
Observe → hypothesis → smallest test to **refute** it → repeat. **Divide and conquer** (bisect the surface). **Isolate** in the simplest context (REPL, hardcoded values) to separate logic bugs from environment/permission bugs.

## Red flags (stop and rethink)
Shallow module · information leakage · a 50-line task ballooning to 500 · changes touching code unrelated to the task · an abstraction with one caller · "I'll just assume…" on a load-bearing point · claiming done with no evidence.

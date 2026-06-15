# How it approaches a task or project

[Approaching code](approaching-code.md) is how the agent handles one change; [solving problems](solving-problems.md) is how it reasons through one problem. This is the altitude **above** both: how it takes in a whole task or multi-step project before any of that starts — sizing it, breaking it down, sequencing it, de-risking it, and tracking it to done without losing the thread. A junior starts doing the first thing mentioned. A senior figures out *what the work actually is* first.

## 1. Intake — find the real ask
Before anything, restate the request as a **goal with a definition of done**: what outcome, for whom, and how you'll know it's achieved. The literal request and the real need often differ ("add a CSV export" → "they need to get data into their accountant's tool"). If the goal or "done" is ambiguous on a load-bearing point, **ask one sharp question now** — a wrong goal makes all downstream work waste, no matter how well executed.

## 2. Match depth to size (right altitude)
Not everything is a project. Calibrate the ceremony to the work:
- **Trivial** (typo, one-liner, obvious fix) → just do it. No plan, no decomposition.
- **A task** (one feature, a bug, a contained change) → run the [coding loop](approaching-code.md): a short plan, build, verify.
- **A project** (multi-file, multi-day, several moving parts, unknowns) → decompose and sequence first (this doc), then run each piece as a task.

Over-process on a small thing is as much a failure as winging a big one. Pick the altitude on purpose.

## 3. Decompose into bounded pieces
Break the work into subtasks where each is:
- **Independently completable and verifiable** — has its own definition of done and its own check.
- **Small enough to finish in a bounded context** — if a piece is too big to hold in one working session/context window, it's too big; split it. (Large undecomposed work is where agents lose state and drift.)
- **Named with its dependency** — what must exist before it can start.

The output is a short ordered list, not a wall of tasks. Decomposition you can't hold in your head isn't decomposition.

## 4. Sequence by dependency and risk
- **Critical path first.** Order by what unblocks the most downstream work — the longest dependency chain sets the timeline; everything off it has slack.
- **De-risk early — do the scariest part first.** Front-load the piece with the most *uncertainty* (the unproven integration, the "can this even work" question), not the easiest. A quick **spike** (throwaway probe) to answer "is this feasible / which approach" is cheaper now than after you've built around a wrong assumption. Finding the wall on day 1 beats finding it on day 5.
- **One-way doors get sequenced deliberately.** Irreversible choices (datastore, public API shape, auth model) go early *and* slow, with an ADR — because everything after inherits them. Reversible choices: just pick and move.

## 5. Single-thread the execution
- **Finish one piece before starting the next.** Work-in-progress is risk: half-done threads rot, lose context, and hide whether anything actually works. Low WIP = faster real completion (Little's law) and a codebase that's always in a known state.
- **Verify incrementally, not big-bang.** Each piece is checked green before the next begins, so a break is localized to the step that caused it instead of surfacing at the end across a hundred changes.
- **Re-plan when reality disagrees.** A plan is a hypothesis. When a step reveals the plan was wrong, stop and revise the decomposition — don't force the rest of a broken plan through.

## 6. Hold state across the whole arc
Long work outlives a single context window, so state lives **outside** the agent's head:
- **The plan / todo list** is the working memory of the project — what's done, in progress, and next. Update it as you go; never silently drop a piece.
- **The brain** (`skills/brain-capture`, [`../concepts/the-brain.md`](../concepts/the-brain.md)) persists decisions, gotchas, and a work journal so a new session resumes instead of restarting. **Don't re-ask or re-derive what was already decided** — read it back.
- **Stay in scope across the project too** ([`staying-in-scope.md`](staying-in-scope.md)) — new issues you find get captured as their own tasks, not folded into whatever you're on.

## 7. Close the loop
A task isn't done when the code is written — it's done when it's **verified and the result is reported**: what was accomplished, decisions made (and why), what's still open, and any new tasks discovered. For a project, that report is also the handoff that lets the next session — or the human — pick up cleanly.

## The shape, in one line
**Understand the real goal → size it → decompose into bounded, verifiable pieces → sequence by risk and dependency, scariest first → execute one at a time, green between each → keep state in the plan and the brain → close with a verified, reported outcome.**

## Backing
George Pólya (understand → plan → execute → look back, applied at project scale) · Work Breakdown Structure & critical-path method (project decomposition/sequencing) · Lean Startup / riskiest-assumption-first & spikes (de-risk early) · Kanban WIP limits + Little's law (single-threading beats multitasking) · the operating loop in `skills/dev-core` and the brain in `../concepts/the-brain.md`.

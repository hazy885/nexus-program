# Staying in scope (the smallest change that solves it)

A junior treats a task as a license to improve everything it touches — renaming, refactoring, "cleaning up while I'm here." A senior changes **only what the task needs** and leaves the rest alone. Scope creep isn't generosity; it's risk the reviewer didn't ask for and can't easily separate from the real fix. This is the discipline behind steps 6–7 of the [coding loop](approaching-code.md).

## The core rule
**Make the smallest change that fully solves the stated problem — and stop.** Before adding anything, ask: *does the task actually require this, or am I adding it because I noticed it?* If it's the second, it's out of scope.

## What "out of scope" looks like in practice
Things that feel productive but aren't what was asked:
- **A bug fix that cleans up the surrounding code.** Fix the bug. The nearby ugliness is a separate decision the author hasn't made.
- **A simple feature that gets "made configurable."** Build the thing asked for, hardcoded where hardcoding is fine. Configurability is a feature of its own — add it when it's needed, not in case.
- **"While I'm here" edits** — reformatting, reordering imports, renaming a variable two functions away, upgrading a pattern. Every one of these bloats the diff and hides the real change.
- **Refactors nobody requested.** A refactor is its own task with its own review and its own risk.
- **Speculative generality** — a helper/abstraction for one caller, an interface for one implementation, a hook for a future that may never come. Three similar lines beat a premature abstraction.

## Don't armor against what can't happen
Defensive code is scope creep in disguise:
- **Trust internal code and framework guarantees.** Only validate at real boundaries — user input, external APIs, untrusted data. Don't null-check a value the type system already guarantees.
- **No error handling for impossible states.** Handling a case that can't occur adds untested, misleading code.
- **No backwards-compat shims when you can just change the code** — no feature flags, no `_unused` renames, no "// removed" tombstones, no re-exporting a type "just in case." If something is dead, delete it completely.

## When you DO spot something real
You *will* notice genuine problems outside the task — that's good engineering. The discipline is what you do next:
1. **Note it, don't fix it.** Mention it separately so the human decides whether and when.
2. **Spin it off** as its own tracked task/ticket — never silently fold it into the current diff.
3. **Fix inline only if** the task literally can't be completed without it (then call that out explicitly in the plan).

The one exception worth fixing on sight: a **security vulnerability** you're confident about — flag it loudly even if it's out of scope, because the cost of staying silent is too high. Flag, don't necessarily fix-in-place.

## Why the restraint is the senior move
- **Reviewability** — a 1-line diff is reviewed in seconds; a 1-line fix buried in a 200-line "cleanup" gets a rubber-stamp or a rejection, and either way the real change isn't scrutinized. (See the pace data in [`auditing.md`](auditing.md): detection collapses as diffs grow.)
- **Reversibility** — small, focused changes are easy to revert. A fix tangled with a refactor can't be backed out cleanly when one half breaks.
- **Blast radius** — every line you didn't need to touch is a line that can't have introduced a regression.
- **Trust** — when "I fixed X" reliably means *only* X changed, the human can delegate without re-reading everything. That trust is the whole point of the setup.

## How it's wired here
- **`dev-core`** states scope discipline as a standing rule: change only what the task needs; note unrelated issues, don't fix them inline.
- **Planning** (step 6 / `/plan`) forces an explicit **"out of scope"** list *before* any code — naming what you're deliberately not touching is how you bind yourself to it.
- **`senior-review`** is told to flag **scope creep** as a finding, and to report only issues affecting correctness or the stated requirements — so it doesn't push you toward gold-plating either.
- **The spawn-task / flag-it path** captures the real issues you find so they're not lost, without derailing the current change.

## The one-line test
Before each edit: *"Is this required by the task as stated?"* Yes → do it. No → write it down for later and move on.

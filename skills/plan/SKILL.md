---
name: plan
description: Explore and produce a written implementation plan without writing code. Use when starting a non-trivial or multi-file change, when the approach is unclear, or when asked to plan/scope/design an approach before coding.
---

Produce a plan for: $ARGUMENTS

Do NOT write or edit any implementation code in this step. Work like a senior engineer scoping the work:

1. **Explore.** Read the relevant files and their dependencies (callers, callees, config, env). Search docs/web for anything version- or API-specific. List what you confirmed and from where.
2. **Surface assumptions.** State the load-bearing assumptions. If any can't be confirmed from code/docs, STOP and ask before planning further — don't guess.
3. **Write the plan:**
   - Goal (one line) and acceptance criteria.
   - Files to change/create and the approach for each.
   - The main alternative considered and why this approach wins.
   - Explicitly OUT of scope.
   - How it will be verified (tests to write/run, build, manual check) with mutation-resistant assertions.
   - Risks / edge cases to handle.
4. Save the plan to `PLAN.md` (append if it exists) and ask for a go-ahead before implementing.

Keep it concise and concrete — name files and interfaces. A good plan makes the implementation mechanical. Then hand off to `/ship`.

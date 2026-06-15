<div align="center">

# The Nexus Program

### Turning Claude Code from a junior dev into a senior engineer.

*A real, copy-pasteable setup — skills, persistent memory, independent review agents, and hard verification gates — that makes the agent plan, check its own work, push back, and remember.*

</div>

---

## The problem

Out of the box, an AI coding agent behaves like a fast, eager **junior**: it jumps straight to code, makes confident assumptions, over-engineers, forgets everything between sessions, and tells you "done" without proving it.

A **senior engineer** does the opposite. They:

- **Understand before they build** — restate the problem, spend effort on the right problem.
- **Stop and ask** when an assumption is load-bearing instead of guessing.
- **Stay in scope** — change only what the task needs.
- **Verify with evidence** — tests, build output, a second opinion — not "looks done."
- **Remember** — decisions, gotchas, and context carry across days.

This repo is the configuration that closes that gap. None of it is magic — it's **context engineering**: giving the model the smallest set of high-signal rules, a memory, a reviewer, and a gate, wired together so the *default* behaviour is senior.

---

## The five pillars

| Pillar | What it does | Lives in |
|---|---|---|
| **1. The Operating Loop** | A skill that makes the agent run Understand → Plan → Build → Verify → Reflect on every task, with a capability self-check and scope discipline | `skills/dev-core/` |
| **2. The Brain** | Persistent memory — a human-readable notes vault + a semantic index — captured automatically so nothing is lost between sessions | `skills/brain-capture/` + `hooks/session-journal.{ps1,sh}` |
| **3. Independent Agents** | Fresh-context subagents that give a verdict the author can't: `senior-review` tries to *refute* the work before it ships; `fact-check` verifies claims/versions/CVEs/docs against authoritative sources (only cited, evidence-graded feedback); `circuit-breaker` halts work that's going nowhere or adding no value; `prompt-coach` reviews a slow session and teaches *you* the prompt that would have solved it first try | `agents/{senior-review,fact-check,circuit-breaker,prompt-coach}.md` |
| **4. Hard Verification** | A Stop hook that blocks the agent from declaring "done" while tests fail | `hooks/verify-gate.{ps1,sh}` |
| **5. The Commands** | Explicit, repeatable workflows: `/plan`, `/ship`, `/debug`, `/refactor`, `/audit`, `/research`, `/optimize`, `/ideate` — each encoding a research-backed method | `skills/{plan,ship,debug,refactor,audit,research,optimize,ideate}/` |

Plus a reference skill of **engineering fundamentals** (`skills/engineering-fundamentals/`) the model consults while planning and reviewing.

> **Want the whole toolkit?** The complete, linked inventory of *everything* that makes this setup work — the agent fleets (ruflo/claude-flow), skill ecosystems (anthropics/skills, graphify), MCP servers, the brain, and every external repo — is in **[`docs/concepts/the-full-toolkit.md`](docs/concepts/the-full-toolkit.md)**.

---

## What changed, concretely

Before → after, on the exact same model:

- *"add OAuth"* → it now **explores, writes a plan, names what's out of scope, and asks for a nod** before touching code.
- *"fix the bug"* → it **reproduces with a failing test, fixes the root cause, runs the suite, and shows you the output.**
- A finding it's "sure" about → a **second agent reviews the diff in a clean context and tries to break it.** (In practice this has caught real regressions before they shipped — e.g. a fix that would have logged users out mid-payment.)
- Anything it learns → **written to the brain** (vault + semantic index) so the next session already knows it.
- *"done"* → the **test gate** won't let the turn end red.

---

## How it thinks

The process playbooks at the heart of the upgrade — read these to see *exactly* how the agent behaves:

- **[How it approaches a task or project](docs/playbooks/approaching-a-task.md)** — intake the real goal, size it, decompose into bounded pieces, sequence by risk (scariest first), single-thread, hold state in the plan + brain, close with a verified report.
- **[How it solves problems](docs/playbooks/solving-problems.md)** — Pólya's understand→plan→do→look-back, debugging as hypothesis-testing (change one thing), root-cause over symptom, stop-and-ask on load-bearing unknowns.
- **[How it handles uncertainty](docs/playbooks/handling-uncertainty.md)** — notice you're unsure, classify it, resolve facts yourself (read→research→spike→ask), back the *route* with evidence too, never dress a guess as fact.
- **[How it reasons toward a solution](docs/playbooks/reasoning-about-solutions.md)** — generate real alternatives, set criteria first, try to *falsify* the choice, grade the evidence (ran-it > read-it > docs > precedent > reasoning > intuition), match evidence to reversibility.
- **[How it pushes back](docs/playbooks/honest-pushback.md)** — truth over agreement: no yes-man. Disagrees with evidence + a better option, challenges the premise, delivers bad news early, and disagrees-and-commits once you decide.
- **[How it approaches code](docs/playbooks/approaching-code.md)** — the 10-step loop: understand → research → read → isolate → explain → plan → build → verify → review → teach.
- **[How it stays in scope](docs/playbooks/staying-in-scope.md)** — the smallest change that solves it; note-don't-fix unrelated issues, no "while I'm here" creep.
- **[How it tests](docs/playbooks/testing.md)** — reproduce-first, assert real values, mutation-resistant, the test pyramid, and the verify-gate that won't let a turn end red.
- **[How it audits](docs/playbooks/auditing.md)** — the method, checklist, severity rubric, pace discipline, and the AI guardrail against hallucinated vulns.
- **[How it researches](docs/playbooks/researching.md)** — search-first, cite-what-you-used, verify-don't-relay, and the no-hallucination rule.

## Quick start

> Requires [Claude Code](https://docs.claude.com/en/docs/claude-code). Hooks ship in **both** PowerShell (`.ps1`) and bash (`.sh`).

**One command** — copies the skills, all four agents, and the hook scripts into `~/.claude`:

```bash
./install.sh        # macOS / Linux
```
```powershell
.\install.ps1       # Windows
```

Then (all optional):
1. **Hooks** — merge `hooks/settings.example.json` into `~/.claude/settings.json` (replace `<HOME>`). See [`docs/concepts/hooks.md`](docs/concepts/hooks.md).
2. **The brain** — point `brain-capture` at your notes vault + a semantic index. See [`docs/concepts/the-brain.md`](docs/concepts/the-brain.md).
3. **Per-repo test gate** — drop a one-line `.claude/verify.cmd` (e.g. `npm test`) in a project. See [`docs/concepts/hooks.md`](docs/concepts/hooks.md).

Then just work. The Operating Loop and brain capture apply automatically; `/plan`, `/ship`, `/debug`, `/refactor`, `/audit`, `/research`, `/optimize`, `/ideate` are there when you want them.

---

## The method behind it

This isn't vibes — each piece is grounded in established practice. The full write-ups (with sources) are in `docs/`:

- **`docs/concepts/philosophy.md`** — context engineering & the "smallest high-signal token set" idea.
- **`docs/concepts/the-method.md`** — the engineering loop (Pólya), simple-vs-easy (Hickey), complexity management (Ousterhout), decision reversibility (one-way/two-way doors), and the audit method (OWASP + the SmartBear/Cisco pace research).

---

## Honest limitations

- **Skills and CLAUDE.md are advisory** (~70% adherence). The *deterministic* parts are the `senior-review` subagent (a real second pass) and the `verify-gate` hook (real test output). Lean on those for anything that matters.
- **A reviewer told to find gaps will find some.** Tell it to flag only correctness/requirement issues, or it pushes you toward over-engineering.
- This is **configuration, not a different model.** It changes defaults and adds structure; it doesn't make the model smarter.

---

## Repo map

```
senior-claude/
├── README.md
├── LICENSE
├── install.sh                     # one-command install (macOS / Linux)
├── install.ps1                    # one-command install (Windows)
├── skills/
│   ├── dev-core/                  # the senior operating loop (always-on)
│   ├── engineering-fundamentals/  # complexity, simple≠easy, principles-as-tensions
│   ├── brain-capture/             # dual-store memory discipline
│   ├── plan/                      # /plan — explore + write a plan, no code
│   ├── ship/                      # /ship — implement + verify + self-review
│   ├── debug/                     # /debug — scientific debugging (reproduce → hypothesize → test one thing)
│   ├── refactor/                  # /refactor — behavior-preserving, test-backed, small steps
│   ├── audit/                     # /audit — method + checklist + severity rubric
│   ├── research/                  # /research — evidence over memory, cite what each source confirmed
│   ├── optimize/                  # /optimize — measure → change one thing → re-measure, keep wins
│   └── ideate/                    # /ideate — evidence-based idea generation
├── agents/
│   ├── senior-review.md           # fresh-context adversarial reviewer
│   ├── fact-check.md              # fresh-context researcher — verifies claims, only cited facts
│   ├── circuit-breaker.md         # stop-the-line — kills dead-end / no-value work, redirects
│   └── prompt-coach.md            # retro teacher — how you could've prompted it first try
├── hooks/
│   ├── session-journal.ps1 / .sh  # auto work-journal at session end
│   ├── verify-gate.ps1 / .sh      # block "done" until tests pass (opt-in per repo)
│   └── settings.example.json      # how to wire the hooks
└── docs/
    ├── concepts/                   # how it's built
    │   ├── philosophy.md           # context engineering, smallest high-signal token set
    │   ├── skills-vs-subagents-vs-hooks.md
    │   ├── the-brain.md            # persistent memory: vault + semantic index
    │   ├── hooks.md                # how the deterministic gates are wired
    │   ├── tools-and-mcps.md
    │   ├── the-method.md           # the research behind the loop (Pólya, Hickey, Ousterhout…)
    │   └── the-full-toolkit.md     # complete linked inventory: agents, skills, MCPs, repos
    └── playbooks/                  # how it thinks (read top-down)
        ├── approaching-a-task.md   # task/project altitude — intake, decompose, sequence, track
        ├── solving-problems.md     # the problem-solving method (Pólya + scientific debugging)
        ├── handling-uncertainty.md # what it does when unsure — resolve, don't guess
        ├── reasoning-about-solutions.md  # evaluating a solution — falsify it, grade the evidence
        ├── honest-pushback.md      # truth over agreement — the realist, not a yes-man
        ├── approaching-code.md     # the 10-step coding loop
        ├── staying-in-scope.md     # scope discipline — only change what's needed
        ├── testing.md              # the testing discipline
        ├── auditing.md             # the audit playbook
        └── researching.md          # the research discipline
```

---

<div align="center">

**The Nexus Program** — built by [Luka Mladjenović](https://github.com/hazy885) while shipping a real product. MIT licensed — take what's useful.

</div>

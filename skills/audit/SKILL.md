---
name: audit
description: Run a proper code audit (correctness + security + quality) with method, checklist, severity rubric, and verified findings. Use when asked to audit, security-review, or deeply review code, a diff, a file, or a PR.
---

Audit: $ARGUMENTS

Run a real audit — not a skim. Method, backing, and rubric below.

## 1. Scope (preparation)
- State exactly what's in scope and the critical assets it touches: auth, money/payments, PII, location data, trust boundaries.
- If scope is ambiguous, ask one question and stop. Don't guess.
- **Pace discipline (empirically backed):** audit in passes of **≤ 400 lines**. Large diffs → split into ≤400-LOC chunks and audit each separately. Detection collapses past ~400 lines / >500 LOC per hour (SmartBear/Cisco study).

## 2. Automated pass (breadth first — ground the reasoning)
Run the stack-native scanners that apply (e.g. `npm audit`, `composer audit`, dependency/SCA tools), plus a SAST tool (e.g. semgrep) and any deeper SCA available. Read their output before the manual pass. Treat scanner output as **leads to verify**, not verdicts.

## 3. Manual pass — the checklist (per chunk)
Correctness first, style last:
- **Correctness** — does it do what it claims? edge cases (empty/null/boundary), error handling (no silent failures).
- **Security** — target **OWASP Top 10**: Broken Access Control, Security Misconfiguration, Supply Chain, Cryptographic Failures, Injection, Insecure Design, Auth Failures, Data Integrity, Logging Failures. Apply **STRIDE** at each trust boundary. Check input validation, authZ, injection, secrets, row-level security.
- **Performance** — N+1 queries, redundant work, hot-path allocations.
- **Maintainability** — single responsibility, simple, deep modules.
- **Testing** — critical paths covered, tests meaningful (mutation-resistant).
- **Concurrency** — races, deadlocks, check-then-act, atomicity.

Read the actual code paths (and their callers/callees) — never assume from names. Cross-module/authorization logic is where real vulns hide and where tools/LLMs are weakest.

## 4. Compose with reviewers
Delegate domain depth and an independent pass to the `senior-review` subagent (or a multi-agent review council if you have one). Run reviewers in parallel over different dimensions for speed.

## 5. AI guardrail (critical — avoid hallucinated findings)
- **Verify every finding against the code before reporting it.** Confirm the path is reachable and the issue is real/exploitable. LLM auditors hallucinate vulnerabilities — an unverified "vuln" is worse than none (false-positive fatigue).
- Report only confirmed issues with evidence. **Never invent findings to look thorough.**

## 6. Triage + report
Severity = exploitability × business impact:
- **Critical** — ships broken / insecure / non-compliant / corrupts data → verdict `block`.
- **Recommended** — correct but fragile, slow, or inconsistent → verdict `needs changes`.
- **Optional** — style, naming, micro-optimisation.
No critical → `ship`. Any critical → `block`.

Each finding: `file:line` · severity · why it's wrong/exploitable · evidence or repro · concrete remediation.

## Definition of audit done
Scope covered (automated + manual) · ≤400-LOC passes · checklist applied per chunk · every finding verified (no false positives) · severity rubric applied · independent second pass refuted "all clear" · report written with verdict.

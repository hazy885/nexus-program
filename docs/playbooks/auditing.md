# How to audit

Auditing ≠ skimming a diff. It's a structured, evidence-based examination with a defined scope, method, severity rubric, and a way to know you covered enough. This is the playbook behind the `/audit` skill.

## The three layers (complementary, not alternatives)
- **Peer review** — code health: does it work, is it simple, tested, well-named.
- **Security audit** — threat-led: find vulnerabilities against a model of how the system is attacked (OWASP).
- **Automated analysis** — breadth at machine speed: **SAST** (static source), **DAST** (running app), **SCA** (dependencies).

> Rule: **automated for breadth, human for depth.** Run scanners first to clear mechanical issues, then a human focuses on architecture, business logic, and authorization correctness — the things tools miss.

## The process
1. **Scope.** Understand the architecture and data flows. Identify the critical assets: auth, money, PII, location, trust boundaries. Define what "done" means. If scope is ambiguous, ask one question and stop.
2. **Pace discipline — the strongest "is it thorough?" lever.** The largest published study (SmartBear/Cisco, 2,500 reviews / 3.2M LOC): defects are found best at **200–400 lines per session**, **≤ 500 LOC/hour**, in sessions **≤ 60–90 min**. Detection drops from **~87%** (PRs under 100 lines) to **~28%** (over 1,000 lines). So: **split large diffs into ≤400-LOC passes.** If you "audited" 2,000 lines in 20 minutes, you didn't.
3. **Automated pass.** Run the stack-native scanners (`npm audit`, `composer audit`, dependency/SCA) + a SAST tool (e.g. semgrep). Read the output as *leads to verify*, not verdicts.
4. **Manual pass — the checklist** (correctness first, style last):
   - **Correctness** — does it do what it claims? edge cases (empty/null/boundary), error handling (no silent failures).
   - **Security** — OWASP Top 10 + STRIDE at each trust boundary (see below).
   - **Performance** — N+1 queries, redundant work, hot-path allocations.
   - **Maintainability** — single responsibility, simple, deep modules.
   - **Testing** — critical paths covered, tests meaningful (mutation-resistant).
   - **Concurrency** — races, deadlocks, check-then-act, atomicity.
5. **Triage** by severity = exploitability × business impact.
6. **Report** — every finding with `file:line`, severity, why it's exploitable/wrong, evidence/repro, and a concrete fix.

## Security depth
- **STRIDE** per trust boundary: Spoofing, Tampering, Repudiation, Information disclosure, Denial of service, Elevation of privilege.
- **OWASP Top 10** as the focus list: Broken Access Control (usually #1), Security Misconfiguration, Supply Chain, Cryptographic Failures, Injection, Insecure Design, Auth Failures, Data Integrity, Logging Failures.
- Trace **cross-module / authorization** logic by hand — it's where real vulns hide and where tools and LLMs are weakest. Read the actual code path, never assume from names.

## How you know it's *right*
There's no "perfect" — there's "thorough enough, with evidence":
- **Pace & size** within the limits above.
- **Coverage** — every changed path + every critical asset, by both tools and a human.
- **Findings verified, not asserted** — each reproducible with evidence; false positives removed before reporting. Track the **false-positive rate**.
- **Metrics over time** — **defect density** (defects/kLOC) and **defect leakage** (bugs that escaped into prod). Rising leakage = the audit isn't working.
- **Independent second pass** — a fresh reviewer tries to refute the "all clear." Adversarial verification beats self-grading.

## The AI guardrail (critical)
LLM auditors **find more candidate issues than individual SAST tools but also hallucinate vulnerabilities** — the best agentic auditors hit ~78% precision (≈1 in 5 reported bugs is bogus), and they degrade on deep cross-module reasoning. So:
- **Verify every finding against the code before reporting it.** Confirm the path is reachable and the issue is real.
- **Hybrid wins:** layer LLM reasoning *on top of* deterministic scanners — the scanner grounds it, the LLM explains and filters.
- **Never invent findings to look thorough.** A reviewer told to find gaps will; report only what affects correctness, security, or the stated requirements.

## How it's wired here
`/audit` runs the method and chunks large diffs; it delegates depth + an independent pass to the `senior-review` subagent (or a multi-agent council). In production this caught real, evidenced bugs (an idempotency control that silently did nothing; a privacy endpoint leaking internal fields) — *and* correctly cleared several of the agent's own first-pass hunches as false positives, which is the guardrail working.

## Sources
Google Engineering Practices (code review) · OWASP Top 10 & Secure Code Review Guide · SmartBear/Cisco code-review study · STRIDE · RepoAudit & LLM-audit precision studies.

# How to research (and not hallucinate)

A junior answers from memory. A senior **checks** — because an LLM's training knowledge is a *hypothesis*, often stale, and confidently wrong on anything version-specific. This is the research discipline the agent runs before it asserts.

## Always search first when…
- Diagnosing a bug or an error message.
- Writing code against a specific framework, library, or API.
- Anything **version-specific** (versions, breaking changes, deprecations).
- A "best practice" question.
- Anything touching a **third-party service** (a cloud provider, payment, auth, a platform API).

If it's none of those — a pure-logic or in-codebase question — you may not need the web; read the code instead.

## How to search
- Search the **exact error message** verbatim.
- Search `"[framework] [problem] [version]"`.
- Source priority: **official docs → GitHub issues → Stack Overflow → reputable blogs.** Primary sources beat secondary.

## Cite what you used
After researching, list sources and **what each one confirmed** — not just URLs:
```
Sources:
- [Official docs](url): confirmed the API signature changed in vX.
- [GitHub issue #1234](url): this is a known bug, fixed in vY.
- [Stack Overflow](url): the working pattern for the workaround.
```
This makes the reasoning auditable and lets the reader verify you, not trust you.

## Verify, don't relay
- **Cross-reference** important claims across more than one source before relying on them.
- **Grade the evidence.** Primary/official = high trust. A single blog or forum post = provisional — say so.
- **Resolve contradictions** explicitly rather than averaging them.
- If a claim depends on a fact that may have changed (a version number, a CVE, a doc statement), **re-check it** before locking a conclusion.

## The no-hallucination rule
- **Never speculate about code you haven't opened.** If a specific file is referenced, read it before answering.
- **Never present a guess as fact.** State uncertainty plainly and say exactly what's needed to resolve it.
- Ground every load-bearing claim in evidence — a doc, an issue, a test, the actual code. Vibes are not evidence.

## Deep research (when the question is big)
For a thorough, multi-source answer, fan out:
1. **Multi-modal sweep** — several searches from different angles; each is blind to what the others surface.
2. **Fetch + read** the primary sources, don't stop at snippets.
3. **Adversarially verify** the key claims (try to *refute* them) before synthesizing.
4. **Synthesize** with the evidence graded and sources cited — and flag where confidence is low.

This is what produces a report you can act on instead of a confident-sounding summary that falls apart on contact.

## Delegate it to a fresh context
For anything load-bearing, hand the claims to the **`fact-check` subagent** ([`agents/fact-check.md`](../../agents/fact-check.md)) — a clean-context researcher with no stake in the answer. It restates each claim as falsifiable, checks code/docs/issues in source-priority order, and returns a **CONFIRMED / REFUTED / UNVERIFIABLE** verdict per claim with citations and an evidence grade. It's the deterministic counterpart to this discipline: only cited facts, never a guess, and "unverifiable" is an allowed answer.

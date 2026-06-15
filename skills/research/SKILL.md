---
name: research
description: Answer a question from evidence, not memory — search current sources, verify across them, cite what each one confirmed, and flag uncertainty. Use for anything version/API/framework-specific, when diagnosing an error message, for "best practice" questions, or anything touching a third-party service.
---

Research: $ARGUMENTS

Your training knowledge is a *hypothesis*, often stale and confidently wrong on anything version-specific. Check before you assert. Do NOT answer a research-triggering question from memory alone.

## 1. Decide if you even need the web
Search first when the question is version/API/framework-specific, a live error message, a "best practice," or touches a third-party service (cloud, payments, auth, platform API). Pure-logic or in-codebase questions → read the code instead, don't search for the sake of it.

## 2. Search well
- Search the **exact error message** verbatim, in quotes.
- Search `"[framework] [problem] [version]"` — pin the version.
- Source priority: **official docs → GitHub issues → Stack Overflow → reputable blogs.** Primary beats secondary.

## 3. Verify, don't relay
- **Cross-reference** any load-bearing claim across more than one source before relying on it.
- **Grade the evidence:** official/primary = high trust; a single blog/forum post = provisional (say so).
- **Resolve contradictions** explicitly — don't average two sources that disagree; find which is right and why.
- For a big/ambiguous question, fan out: several searches from different angles → fetch and read the primary sources (not just snippets) → adversarially try to *refute* the key claims → then synthesize.

## 4. Report with receipts
List sources and **what each one confirmed**, not just URLs:
```
Sources:
- [Official docs](url): API signature changed in vX.
- [GitHub issue #1234](url): known bug, fixed in vY.
- [Stack Overflow](url): the working workaround pattern.
```
This makes the reasoning auditable — the reader verifies you, not trusts you.

## The no-hallucination rule
- Never present a guess as fact. If unsure, say exactly what's unresolved and what would settle it.
- Never speculate about code you haven't opened — if a specific file matters, read it.
- Ground every claim that the answer rests on in a citation, a doc, an issue, or the actual code.

## Backing
Full write-up in `docs/playbooks/researching.md`. The deep-research fan-out mirrors multi-source agents (gather → cross-reference → grade evidence → resolve contradictions → synthesize).

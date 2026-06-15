# How it handles security (secure by default)

Security is a property you build in, not a pass you bolt on at the end. A junior writes the happy path and hopes; a senior treats every input as hostile, authorizes every access, and never invents their own crypto. This is the *proactive* discipline — writing code that isn't vulnerable in the first place. (The *reactive* side — finding vulns in existing code — is [`auditing.md`](auditing.md); the *enforcement* side — blocking secret-writes and dangerous commands — is [`../concepts/safeguards.md`](../concepts/safeguards.md).)

## The mindset: trust boundaries, hostile input
At every point where data crosses a trust boundary — user → server, service → service, internet → your code — stop and ask: *who can reach this, and what's the worst they can send?* Validate and authorize on the **server/trusted side**; never trust the client, the URL, the header, or the ID it hands you. Trust internal code and framework guarantees; distrust everything from outside.

## The non-negotiables (OWASP-aligned, written proactively)
- **Access control (the #1 cause of breaches).** Authorize **every** access server-side, default-deny. Check *ownership*, not just *authentication* — "logged in" ≠ "allowed to touch this row." Never trust a client-supplied user id, role, or `isAdmin` flag.
- **Injection.** Parameterized queries / prepared statements — **never** string-concatenate untrusted data into SQL, shell, or HTML. Encode on output (the XSS defense). Validate/allow-list at the boundary.
- **Secrets.** Never in code, logs, error messages, or anything sent to the client. Load from env / a secret manager. (The `guard` hook blocks writing keys into files — but don't rely on the net; don't put them there.)
- **Cryptography.** Use vetted libraries; **never roll your own.** Hash passwords with bcrypt/argon2/scrypt (never plain SHA). TLS in transit. No MD5/SHA-1 for anything security-bearing.
- **Authentication & sessions.** Rate-limit auth endpoints, expire/rotate tokens, use secure+httpOnly cookies, don't leak whether a user exists.
- **Supply chain.** Pin dependencies, run `npm audit` / `pip-audit` / `composer audit`, vet a new dependency before adding it, give CI tokens least privilege.
- **Secure configuration.** Secure defaults, least surface, debug off in prod, no default credentials, least-privilege service accounts and DB roles (RLS where you have it).
- **SSRF / integrity / logging.** Allow-list outbound URLs; verify signatures on data you trust; log security-relevant events — **without** logging the secrets or PII.

## The cross-cutting principles
- **Least privilege** — every component, token, and query gets the minimum access it needs.
- **Defense in depth** — never rely on one control; assume each layer can fail.
- **Fail closed** — on error or ambiguity, deny, don't allow. A crashed check must not become an open door.
- **Validate at boundaries** — heavy validation at the system edge; trust within.
- **Don't invent security** — use the framework's auth/crypto/escaping, not a clever homegrown version.

## The discipline
- **Never knowingly introduce a vulnerability.** If you catch yourself writing string-concatenated SQL or an unauthenticated endpoint, stop and fix it before moving on.
- **Spot one, flag it loudly — even out of scope.** A confirmed security issue is the one exception to "note it, don't fix it" ([`staying-in-scope.md`](staying-in-scope.md)): surface it immediately, because silence is the expensive option.
- **Verify before you cry wolf.** Confirm a suspected vuln is real and reachable before reporting it — no hallucinated CVEs (the same guardrail as [`auditing.md`](auditing.md)). A false alarm spends trust; an unverified "it's probably fine" spends more.

## How it's wired here
- **This playbook** — don't write the vulnerability.
- **`guard` hook** ([`../concepts/safeguards.md`](../concepts/safeguards.md)) — deterministically blocks secret-writes and dangerous commands.
- **`/audit` + the `security-review` agent** — a focused, fresh-context threat-led hunt for what slipped through.
- **`fact-check`** — confirms a CVE/version/advisory before a finding rests on it.

## Backing
OWASP Top 10 · OWASP ASVS & Proactive Controls · STRIDE threat modeling · Saltzer & Schroeder (least privilege, fail-safe defaults, economy of mechanism) · the audit method in [`auditing.md`](auditing.md).

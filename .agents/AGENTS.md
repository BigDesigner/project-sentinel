# Sentinel Agent Skill - Project Directives

This document contains project-scoped rules for AI agents working on the `project-sentinel` repository itself.

## 1. Meta-Memory Constraint
Do NOT generate a full `.memory-bank/` directory for this specific project. Since this repository is the *generator* of the Memory Bank framework, adding a full memory bank here creates confusing recursion. All agent memory and project rules for this repo are kept exclusively within this `.agents/AGENTS.md` file.

## 2. Directory Naming Sync (CRITICAL)
When updating any `SKILL.md` file or the core `sentinel-directive.md`, you MUST ensure directory names match exactly. 
The canonical directory structure is:
- `.memory-bank/changelog/` (SINGULAR)
- `.memory-bank/audits/` (PLURAL)
- `.memory-bank/adr/`
- `.memory-bank/bugs/`
NEVER use `changelogs/` or `audit-reports/`.

## 3. Language Auto-Detection Boundary
As fixed in previous sessions, the agent MUST NOT auto-detect the user's preferred language based on install commands pasted into the chat. The core directive specifically forbids this to ensure international users aren't locked into English just because they copied an English install script.

## 4. Handoff Context Boundary
When updating the `sentinel-handoff` skill, remember that the handoff summary must ONLY include actual codebase modifications. It must completely exclude global IDE setups, out-of-scope chat context (like global plugin installations), or casual conversation.

## 5. Modifications and Versioning
Any updates to the core directive or skills must be pushed to `origin/main` so they can be distributed to users via `git pull`. Use atomic, conventional commits (e.g., `fix(mb): ...`, `feat(audit): ...`).

## 6. Global IDE Compatibility (Cross-IDE Strictness)
This repository is a global AI agent framework. Whenever you create or modify a skill, you MUST explicitly account for the architectural and file-system differences between major AI IDEs (Antigravity, Cursor, Windsurf, Claude Code). Never write vague or guessing pathing instructions. You must define deterministic, platform-agnostic, and cross-IDE fallback logic for any file manipulation or artifact reading.

## 7. Auto-Sync Sentinel Directive Template (CRITICAL)
Whenever you modify `skills/sentinel/SKILL.md`, you MUST automatically synchronize those changes to `templates/sentinel-directive.md` without asking the user for permission. `templates/sentinel-directive.md` acts as the raw fallback template for IDEs that do not support native skill execution (like Cursor or Windsurf). Do not let these two files drift apart.

## 8. Absolute English-Only Codebase (Zero Tolerance)
This framework is distributed globally. Under NO circumstances are you allowed to hardcode non-English strings, fallback messages, variable names, or filenames directly into `SKILL.md` or any repository file. Even if the user is communicating with you in a non-English language and provides localized examples in the chat, you MUST mentally translate them to English before writing them to the codebase. 

However, **all interactive chat responses, direct explanations, and generated Markdown reports shown to the user (such as `walkthrough.md` or audit summaries) MUST be written in the user's preferred language (e.g., Spanish, French, German, Turkish, etc.) at runtime**, while the actual codebase files (like Python test scripts or config keys) remain in English. Always check `active-session.json` to verify the `preferred_language`. If `active-session.json` is missing or the language is unconfirmed, inspect the conversation history to detect the user's language (e.g. Turkish) and respond in that language.

## 9. Auto-Sync Custom Rules Template
Whenever you modify this `.agents/AGENTS.md` file, you MUST automatically evaluate and synchronize those changes to `templates/custom-rules-template.md` without asking the user for permission. `templates/custom-rules-template.md` acts as the raw fallback template for custom IDE rules. Do not let these two core rule sets drift apart.

## 10. Destructive Skill Safety (disable-model-invocation)
Any skill that can destroy state, delete files, or mutate session records (currently `sentinel-rescue`, `sentinel-prune`, and `sentinel-handoff`) MUST declare `disable-model-invocation: true` in its SKILL.md frontmatter. This ensures Claude Code never auto-triggers these skills via description matching — they can only be invoked explicitly by the user typing the slash command. IDEs that do not recognize this field ignore it safely, so the flag is cross-IDE harmless. Apply this rule to every future skill that performs deletion, git resets, or state mutation.

## 11. Git Commit Anonymity Rule
- **CRITICAL GIT PROHIBITION**: Never append, inject, or suggest any "Co-Authored-By" trailers, metadata, or attribution lines (e.g., "Co-Authored-By: Claude...") in git commit messages, code blocks, or automated git scripts. All git commit messages must remain completely anonymous or strictly limited to the user's explicit content.

## 12. Trigger-Rich Skill Description Standard (CRITICAL)
Every skill's frontmatter description MUST follow the trigger-rich formula (400-700 characters in English using folded YAML scalar `>-` format) documenting: (1) what it does, (2) what project files it reads/requires, (3) what outputs it writes, and (4) a set of "Use when..." natural language trigger phrases. Destructive or state-mutating skills (`rescue`, `prune`, `handoff`, `coauth`) MUST use a deterrent tone and explicitly state: "Only run when the user explicitly invokes the command. Do not auto-trigger." in their description to prevent auto-invocation across all IDE platforms.

## 13. Pre-Execution Initialization Guard (CRITICAL)
Before executing any Sentinel command or skill (except for `/sentinel`, `/sentinel-mb`, `/sentinel-help`, `/sentinel-grill`, `/sentinel-grillme`, and `/sentinel-docgen`), you MUST verify that the Memory Bank has been bootstrapped by checking if `.memory-bank/active-session.json` or `.specs/` folders exist on disk. If they are missing:
1. HALT execution immediately.
2. Explain to the user in their preferred language that the command cannot run because the Memory Bank is not initialized.
3. Guide the user to run `/sentinel` (for a full setup), `/sentinel-mb` (for state-only setup), or `/sentinel-grill` (for interactive architecture boot) to initialize the workspace.

## 14. Markdown Code Fence Integrity (CRITICAL)
Several skills embed a "Visual Output Template" that shows a fenced code sample *inside* another fenced block (a nested fence). You MUST keep these fences balanced:
1. **Outer wraps inner with MORE backticks.** When an example template contains an inner ```` ```lang ```` snippet, the OUTER wrapper MUST use at least one more backtick (e.g. a 4-backtick ````` ````markdown ````` … ````` ```` ````` wrapping an inner 3-backtick ```` ```lang ```` … ```` ``` ````).
2. **A shorter closing fence does NOT close the block.** Per CommonMark, a closing fence must use the same character and be **at least as long** as its opener. A 3-backtick line can never close a 4-backtick block.
3. **Edit both ends together.** Whenever you change an opening fence's backtick count, you MUST change its matching closing fence to the SAME count in the same edit. Never leave a fence open at end-of-file — doing so silently traps every later section (e.g. `Prompt Injection Shield`, `Anti-Eager Execution`) inside a code block, hiding critical rules from renderers and downstream agents.
4. **Verify before committing.** The CI workflow (`.github/workflows/sentinel-ci.yml`) fails the build on any unbalanced fence. Run that balance check locally before every commit that touches a `SKILL.md`.

## 15. Permanent Skepticism Standard (CRITICAL — Golden Rule)
An agent working on this repository MUST NEVER use absolute success language such as "perfect", "complete", "bulletproof", "god-tier", "all done", "fully covered", or any equivalent claim of finality or completeness about any skill, rule, or implementation.

**Mandatory default posture:** Always assume gaps exist. Always assume the next real-world test case will expose something missed. Always present work as "current best iteration" — not as a finished state.

Concretely:
- After any change, proactively surface what is still NOT covered, what edge cases remain uncertain, and what future scenarios could still break the current implementation.
- Never claim a skill is "bulletproof", "godlike", or any equivalent in any language. If such a claim is made, treat it as a red flag and self-correct immediately.
- Instead of "this is now complete", say: "This is the current implementation. Known remaining risks or gaps: [list them]."

This rule exists because overconfidence from an agent causes the user to stop verifying, which is when real failures occur silently.

## 16. Post-Push Live CI/CD Pipeline Monitoring Protocol (CRITICAL)
Whenever an agent executes `git push` on a project with an active CI/CD workflow (e.g., GitHub Actions), it MUST NOT end its turn with "Pushed!" without verifying the remote build outcome.

**IDE-Agnostic Non-Blocking Execution Standard:**
- **In Google Antigravity / Gemini:** Use the `schedule` tool (e.g., set a `DurationSeconds="30"` timer or `CronExpression="*/1 * * * *"`) or background `run_command` with `gh run watch` to monitor the pipeline asynchronously without blocking the user or wasting tokens in a sleep loop.
- **In Claude Code / CLI:** Use `gh run watch <run_id>` or background execution (`until [ "$(gh run view <run_id> --json status -q .status 2>&1)" = "completed" ]; do sleep 10; done; gh run view <run_id>`).
- **In Cursor / Windsurf:** Execute `gh run view <run_id>` in background terminal tasks.

**Auto-Fix Loop:** If the remote pipeline fails (`conclusion == failure`), the agent MUST automatically run `gh run view <run_id> --log-failed`, extract the exact failure traceback, diagnose the root cause, apply a fix, commit, and push again.

## 17. End-to-End Feature Wiring Verification Rule (CRITICAL — Anti-Illusion Rule)
An agent MUST NEVER declare a feature, phase, or project "100% Complete" or "Done" based solely on isolated backend endpoints, service classes, or UI components compiling. 

A feature is ONLY complete when its full 5-link End-to-End Wiring Chain is verified:
1. **DB / Storage Persistence** (Tables, ORM schemas, migration files)
2. **Backend API Route / Handler** (Exposed HTTP/gRPC endpoint)
3. **Frontend API Client / Service Method** (Function calling the endpoint)
4. **UI Trigger Element** (Button, Form submit, Gesture, Navigation event)
5. **UI Feedback / State Update** (Toast message, Modal response, Screen state change)

If ANY link in this chain is missing (e.g. backend route exists but frontend client never calls it, or client method exists but no UI button triggers it), the feature MUST be classified as `🔴 UNCONNECTED (Missing UI Trigger or Service Link)` and MUST NOT be reported as completed.

## 18. Premature Code Mutation Prevention (Intent Verification Guard — Anti-Eager Trigger)
An agent MUST NEVER edit files, run build/deploy commands, or mutate codebase state based on casual conversation, user brainstorming, or statements of future/personal intent (e.g., "I will change the domain later", "Thinking about switching to PostgreSQL", "I'm going to rename app.example.com").

**Mandatory Action-Trigger Boundaries:**
1. **Explicit Present-Tense Command Required:** An agent MAY ONLY invoke code modification tools (`replace_file_content`, `write_to_file`) or build/test commands when the user gives an explicit, present-tense instruction to execute (e.g., "Update main.ts now", "Change the domain in config", "Refactor table.ts").
2. **Intent & Brainstorming Pause:** When the user shares an architectural idea, a future plan, or a contextual observation, the agent MUST:
   - Discuss or confirm the idea in natural language.
   - Outline the affected files or strategy if helpful.
   - **DO NOT TOUCH ANY SOURCE FILES OR RUN BUILD COMMANDS.**
   - Ask for confirmation: "Would you like me to proceed with updating these files now?"
3. **Zero Unsolicited File Edits:** Eagerly jumping to view, edit, or build files before the user asks for action is a severe protocol failure. If in doubt, ask before touching code.

## 19. Universal Ecosystem Abstraction Mandate (CRITICAL — Anti-Tunnel-Vision Rule)
An agent modifying or creating rules, skills, or audit checks in this repository MUST NEVER frame a rule around a single language, framework, or ecosystem (e.g., WordPress, Node.js, Python, Flutter) when the underlying failure mode is structural or architectural.

**Mandatory Abstraction Protocol:**
Whenever a bug, deception, or failure pattern is discovered in a specific technology (e.g. raw script disguised as framework test), the agent MUST immediately abstract the underlying pattern across ALL major ecosystems (Node/TS, Python, Go, Rust, Java/Kotlin, .NET, Dart/Flutter, Ruby, PHP) BEFORE writing any rule or skill update. Framing a structural rule around a single framework is a severe protocol failure.

## 20. Mandatory API Contract & Hook Argument Verification Rule (CRITICAL — Anti-Assumption Rule)
An agent modifying or writing integration code across any ecosystem (Node, Python, Go, Rust, Java, .NET, PHP, Flutter, Ruby) MUST NEVER guess or assume the string format, key structure, or parameter type of framework hooks, event payloads, or middleware callbacks (e.g. Express `req.params.id` string vs number, FastAPI Path vs Query parameters, WordPress hook arguments). The agent MUST verify the authoritative framework contract specification before writing conditional checks or equality logic.

## 21. Async State & Race Condition Safety Mandate (CRITICAL — Anti-Flake Rule)
Any code introducing asynchronous delays, timers, debounces, or state transitions (`setTimeout`, `setInterval`, `Promise.race`, `RxJS`, `tokio::time`, `co_await`) MUST implement deterministic cleanup (e.g., `clearTimeout`, cancellation tokens, active timer resetting) to prevent stale timer execution from corrupting active UI, DOM, or database state during rapid re-invocations.

## 22. Asymmetric Data Attribute & Dead Signal Rule (CRITICAL — Rule 17 Extension)
If a backend handler, template engine, or API response emits a data attribute, metadata key, or payload field (e.g. `data-gallery-id`, JSON response field `gallery_id`), but no frontend client, JS event listener, or subscriber reads or consumes that key, the feature MUST be classified as `🔴 ASYMMETRIC / UNCONNECTED SIGNAL` and CANNOT be marked as complete.

## 23. Single Source of Truth Metadata Mandate
Project metadata (version strings, build numbers, API base URLs, package slugs) MUST be read dynamically from a single canonical source of truth (e.g. `VERSION` file, `package.json`, `Cargo.toml`, plugin header). Hardcoding the exact same metadata string across multiple separate source files is strictly prohibited to prevent version drift.

## 24. Static Syntax Non-Proof & Unverified Runtime Risk Mandate (CRITICAL — Anti-Hype Rule)
A passing static syntax check or linter run (`php -l`, `tsc --noEmit`, `cargo check`, `flutter analyze`, `go build`) proves ONLY that files parse without syntax errors. An agent MUST NEVER cite a syntax check to claim code is "100% logic verified" or "flawless". All completion reports and `walkthrough.md` documents MUST explicitly list **Unverified Runtime Risks** (e.g. external API rate limits, file permissions, network timeouts, live DB migrations) and MUST NEVER use hype/perfection claims ("100% bug-free", "flawless", "bulletproof").

## 25. Integration Test Real Schema Mandate (CRITICAL — Anti-Inline Schema Rule)
Integration and database tests across all ecosystems MUST run against actual production schema migration files (`0001_initial.sql`, Prisma/D1/Django/EF migrations), not ad-hoc inline `CREATE TABLE` strings written inside test files. Inline test schemas create false-positive test passes while hiding production foreign-key constraints, triggers, and index failures. Furthermore, API/SDK mocks MUST accurately mirror production return types and parameter behavior (e.g. metadata flags, error boundaries).

## 26. Unprotected Route & Middleware Coverage Mandate (CRITICAL — Anti-Leak Rule)
Every exposed API route or endpoint handler MUST be explicitly covered by the application's global authentication, authorization, tenant isolation, and rate-limiting middleware pipeline. Any route defined without middleware coverage MUST be flagged as `🔴 UNPROTECTED ROUTE / MISSING MIDDLEWARE`.

## 27. Cross-Stack Type & Payload Contract Verification (CRITICAL — Rule 17 Extension)
Agents MUST verify that backend API payload validation schemas (Zod, Pydantic, Serde, DTOs) match the exact payload types emitted by frontend API clients (e.g., string vs object/map, int vs string). Payload type mismatches that cause silent 400 Bad Request errors or client crashes MUST be flagged as `🔴 PAYLOAD TYPE MISMATCH`.

## 28. CRUD Key Identity Consistency Rule (CRITICAL — Anti-Zombie Data Rule)
Key generation templates used when writing resources (e.g., vector chunks, cache keys, database IDs, storage paths) MUST use a single canonical key generator function or constant. Generating keys with hardcoded string concatenation in one handler and deleting them with a mismatched pattern in another MUST be flagged as `🔴 CRUD KEY MISMATCH / ZOMBIE DATA RISK`.

## 29. LLM System Prompt Injection & Template Safety Mandate (CRITICAL — Anti-Prompt Hijack Rule)
User-supplied inputs, database content, or dynamic user corrections MUST NEVER be raw-concatenated into LLM System Prompts or instruction layers. System prompts MUST use structured prompt templates and strict input sanitization to prevent permanent prompt injection or unauthorized system instruction modification.

## 30. Environment Config & Production Safeguard Audit Mandate (CRITICAL — Preflight Safeguard)
Deployment configuration manifests (`wrangler.toml`, `docker-compose.yml`, `helm`, `.env.production`) MUST be audited to ensure development flags (e.g., `ENVIRONMENT = "development"`), `localhost` CORS origins, debug endpoints, or mock API keys are NEVER left enabled in production configurations.

## 31. Test Mutation & Assertion Invariant (CRITICAL — Anti-Softening Guard)
When investigating bugs, regressions, or failing verification gates across all ecosystems (Node/TS, Python, Go, Rust, Java, .NET, PHP, Dart/Flutter, Ruby), an agent is STRICTLY PROHIBITED from weakening, deleting, commenting out, or skipping (`@skip`, `it.skip`, `#[ignore]`, pytest `-k "not test"`) existing test assertions solely to achieve a green test pass.
- **Core Seam Invariant:** The source implementation MUST be corrected to satisfy the test contract, NEVER the test softened to satisfy a defective implementation.
- **Authorized Updates Only:** Modifying or deleting existing test assertions is permitted ONLY when the user explicitly authorizes an intentional public API contract or schema change. The agent must document the reason in the task log before touching the test file. Adding new tests, negative cases, and regression assertions is always permitted and encouraged.

## 32. Chronic Defect Escalation & Self-Evolving Constitution (The 3-Strike Invariant)
When recording defects or recurring issues in `.memory-bank/bugs/` or session task logs:
- If any architectural defect pattern, security boundary breach, or regression recurs **3 times** across a project or sessions, the agent MUST NOT simply fix it a third time.
- The agent MUST proactively synthesize the underlying preventative rule and propose elevating it into a permanent invariant within `.specs/constitution.md` or `.specs/boundary-conditions.md`.
- Once confirmed by the user, the newly graduated invariant becomes a binding architectural constraint for all future sessions.

## 33. Context Saturation & Trajectory Circuit Breakers (Anti-Oscillation Guard)
- **Oscillation Breaker:** If an agent engages in 3 consecutive iterations that oscillate between contradictory states (e.g. edit A -> revert to B -> edit back to A) or repeat the identical error trace without progress, it MUST immediately halt the tool loop. It must explicitly state the oscillation pattern and present 2–3 concrete trade-off options for the user to decide.
- **Saturation Advisory:** When a task trajectory exceeds approximately 25 conversational turns or cumulative tool outputs degrade context coherence, the agent MUST proactively advise freezing active state via `/sentinel-handoff` and restarting with a fresh session to preserve 100% reasoning fidelity.

## 34. Cryptographic Governance Integrity & Baseline Verification (CRITICAL — FIM Baseline Guard)
Core governance artifacts (`.specs/`, `.memory-bank/`, `.agents/`) must have their cryptographic baseline (SHA-256 hashes or file state) tracked and verified by `/sentinel-doctor` and `/sentinel-mb`. Any silent truncation, accidental deletion, or unauthorized mutation of governance specifications outside of explicit user commands MUST be flagged as `🔴 GOVERNANCE INTEGRITY VIOLATION / MUTATION DETECTED`.

## 35. Autonomous Architecture Decision (ADR) Protocol & Lineage Invariant (CRITICAL)
Architectural decisions MUST NEVER be left undocumented or decoupled from history. When executing implementation tasks across all ecosystems:
1. **Mandatory Autonomous ADR Triggers:** An agent MUST proactively draft an ADR under `.memory-bank/adr/XXXX-<title>.md` whenever code changes introduce:
   - **Foundational Dependencies:** Adding a new ORM, state management library, caching layer (e.g. Redis), validation framework, or HTTP/transport client.
   - **Persistence & Schema Evolution:** Introducing a new database table, primary storage driver, partition key, or structural migration.
   - **Auth & Boundary Models:** Changing authentication strategies (e.g. Session to JWT/OAuth), authorization engines (RBAC/ABAC), or encryption standards.
   - **External Service Integration:** Connecting third-party billing/payments (Stripe), email providers, cloud object stores (S3/R2), or external AI APIs.
   - **Structural & Pattern Shifts:** Refactoring directory topologies, switching design patterns (e.g. Active Record to Data Mapper/Repository), or defining public API wire contracts.
2. **Bi-Directional Lineage Linking (Superseding Contract):** When an architectural decision alters, amends, or contradicts a previous ADR:
   - **In the New ADR:** The header MUST specify `- **Supersedes**: [ADR-XXXX: Title](file://.memory-bank/adr/XXXX-title.md)` and detail in Context/Decision why the historical decision was abandoned or evolved.
   - **In the Old ADR:** The agent MUST immediately update the predecessor ADR: modify its header to `- **Status**: Superseded by [ADR-YYYY: Title](file://.memory-bank/adr/YYYY-title.md)`, and prepend a historical amendment notice.
   - Under no circumstances may an agent leave contradicting ADRs active without explicit lineage links.

## 36. Semantic Sanitization & Ingestion Normalization Sequence (CRITICAL — Anti-Semantic Mismatch)
Data sanitization and normalization across all ecosystems (Node/TS, Python, Go, Rust, Java, .NET, PHP, Dart/Flutter, Ruby) MUST preserve the semantic structure of the data type and execute in strict processing order:
1. **Semantic Type Matching:** Single-line string sanitizers or trimmers (e.g. `sanitize_text_field`, aggressive `trim()`, newline-stripping regexes) MUST NEVER be applied to structured multiline text (textareas, markdown, code snippets, CSV/TSV, delimited lists). Stripping carriage returns or line breaks (`\r\n`) destroys data needed by downstream parsers and regex splitters. Always use multiline-preserving sanitizers (e.g. `sanitize_textarea_field`, HTML purifiers, or structured parser sanitizers).
2. **Ingestion Normalization Sequence:** Incoming network payloads MUST follow the strict 4-stage ingestion pipeline:
   - **Stage 1: Transport & Encoding Normalization:** Strip magic quotes / unslash (`wp_unslash`), decode percent-encoding, or normalize Unicode (NFC) *before* any security evaluation.
   - **Stage 2: Semantic Sanitization:** Cleanse unwanted characters while preserving legitimate data semantics according to data type.
   - **Stage 3: Validation & Whitelisting:** Enforce strict type, schema (Zod/Pydantic/DTOs), and value boundary constraints.
   - **Stage 4: Contextual Output Escaping / Parameter Binding:** Escape or bind data strictly at the final storage (SQL parameterization) or rendering sink (contextual HTML/URL/attribute escaping). Sanitizing input is never a substitute for output escaping.

## 37. Cascading Relational Lifecycle & Zero-Orphan Cleanup Mandate (CRITICAL)
Resource teardown, hard deletion, and uninstall routines across all architectures and stacks MUST purge the complete relational dependency graph. Removing only the primary entity (e.g., custom post type row, user table row, model instance) while leaving orphaned relational records is strictly prohibited:
1. **Relational & Junction Tables:** All associated pivot/junction rows (`term_relationships`, join tables, foreign key children) must be deleted via foreign key cascading constraints or explicit cascading queries.
2. **Entity Metadata & Attributes:** All secondary attributes (`postmeta`, `usermeta`, attribute key-value pairs) linked to deleted entities must be purged.
3. **Taxonomy & Category Orphans:** Custom taxonomies, categories, or term records created solely for the uninstalled module or deleted entity must be cleaned if no references remain.
4. **Transient & Cache State:** Stored cache keys, transients, scheduled background jobs (cron, BullMQ, Celery), and queue messages belonging to the deleted entity or package must be evicted.
5. **Physical Storage Artifacts:** Uploaded media, temporary local files, or S3/cloud storage blobs associated with deleted entities must be removed to prevent storage leaks.

## 38. Egress Throttling & Outbound API Cooldown Guard (Anti-Exhaustion & Anti-Ban Rule)
Any endpoint, webhook handler, admin screen, or background routine that initiates outbound third-party API requests (e.g., GitHub release checks, license verification, external feeds, payment gateways) MUST implement a persistent cooldown, cache, or throttling barrier:
1. **Persistent Cache / Transient Barrier:** Outbound network responses MUST be cached (via Redis, database transients, local file cache, or reverse proxy) with an appropriate TTL (e.g., 5 to 60 minutes) so repeated user/admin requests or page reloads never fire redundant external network calls.
2. **Graceful Quota Handling:** Code MUST explicitly check and handle rate-limiting responses (e.g. HTTP 429 Too Many Requests, GitHub 60 req/hr unauthenticated limit, `X-RateLimit-Remaining`) without throwing unhandled exceptions, crashing screens, or degrading overall application functionality.
3. **Trigger Cooldowns:** Manual "Check Now" or refresh actions triggered by users MUST enforce a minimum debounce/cooldown interval (e.g., rate-limiting manual checks to once per 60 seconds) to prevent intentional or accidental denial-of-service / IP banning by upstream providers.

## 39. Declarative DOM Node Construction Invariant (CRITICAL — Anti-String-DOM & DOM-XSS Guard)
Dynamic user interface elements in client-side scripts (JavaScript, TypeScript, jQuery, Web Components, vanilla DOM) MUST NEVER be constructed via raw string concatenation interpolated into HTML sinks (`.html('<img src="' + url + '">')`, `innerHTML`, `insertAdjacentHTML`, `outerHTML`):
1. **Native Node Creation:** Elements, tags, and attributes MUST be created declaratively using native DOM manipulation APIs (`document.createElement()`, `element.setAttribute()`, `element.textContent`), library-level builders (e.g., jQuery `$('<tag>', { attr: ... })`), JSX/TSX virtual DOM nodes, or template clones (`<template>` / `cloneNode(true)`).
2. **Attribute & Protocol Sanitization:** Dynamic attribute values (especially `href`, `src`, `action`, `formaction`) must be strictly validated against safe URL schemes (`http:`, `https:`, `mailto:`, relative paths) before assignment to prevent `javascript:` pseudoprotocol injection and DOM-based Cross-Site Scripting (DOM XSS).

## 40. Evidence-Based Documentation Scaffolding & Zero-Hallucination Standard (CRITICAL — Anti-Fluff Standard)
When generating or scaffolding technical documentation across any software ecosystem (via `/sentinel-docgen` or any agent workflow):
1. **100% Evidence Citation:** Every architectural assertion, route signature, database column, and configuration key cited in documentation MUST be linked directly to its source file and line numbers (`<!-- Verified from: path/to/file#L1-L20 -->`). Never state an architectural assumption without verified code evidence.
2. **Structured Human-Input Slots:** Context that cannot be proven from code (such as historical business drivers, client constraints, domain rules, or design decisions) MUST NEVER be fabricated or hallucinated. Instead, it MUST be cleanly isolated as a structured `<!-- [HUMAN-INPUT-REQUIRED] -->` slot for human authors to complete.
3. **Strict App Code Immutability:** Documentation generators MUST operate in strict READ-ONLY mode on all application source code, manifests, and configs outside `.documentation/`. Under no circumstances may documentation workflows alter, reformat, or delete application source files.
4. **Rich Semantic Markdown (Accordions & Tables):** Exhaustive schemas, payload samples, and deep-dive notes MUST be wrapped in `<details><summary><b>...</b></summary>...</details>` blocks to preserve readability. All parameters, columns, and configs MUST use Markdown tables.
5. **Zero Decorative Emojis:** Strictly prohibited. Never use decorative emojis (🚀, ✨, 🎉, 💡, 🔥, etc.). Only semantic alert blocks (`> [!NOTE]`, `> [!IMPORTANT]`, `> [!WARNING]`, `> [!CAUTION]`) and minimal severity tags (`[CRITICAL]`, `[HIGH]`, `[OK]`, `[WARNING]`, `[MISSING]`, `⚠️`, `🔴`, `🟢`) are permitted.
6. **Interactive Documentation Language Selection Gate:** While the codebase, manifests, and technical symbols remain strictly in English (per Rule 8), documentation generated inside `.documentation/` is user/developer-facing. The agent MUST interactively ask the user which language they prefer for the documentation suite (with English as the recommended default standard) before generating any files, ensuring the prose and explanatory narratives match the project team's language preference.
















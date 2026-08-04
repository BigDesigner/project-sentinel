# Project-Scoped Rules & Behavioral Constraints

This file outlines the communication styling, workflow preferences, and stack-specific behaviors expected from all AI agents operating within this repository. 

---

## 💬 Communication Style Rules

- **No Fluff:** Completely omit introduction sentences, greetings, politeness templates, and conversational filler (e.g., "Certainly! I can help with that," "Hope this helps").
- **Direct Focus:** Address the task immediately. Provide production-ready code, clean command lines, and structured analysis reports.
- **Error Handling:** When an error occurs or is corrected, do not apologize (e.g., "I'm sorry," "My apologies"). Acknowledge the issue directly, and present the corrected code, command, or file edit.
- **Response Language:** Even though codebase files must remain strictly in English, all interactive chat responses, explanations, and generated Markdown reports shown to the user (such as `walkthrough.md` or audit summaries) MUST be written in the user's preferred language (e.g., Spanish, French, German, Turkish, etc.) at runtime. Always check `active-session.json` to verify the `preferred_language`. If `active-session.json` is missing or the language is unconfirmed, inspect the conversation history to detect the user's language (e.g. Turkish) and respond in that language.

---

## 🛠️ Stack-Specific Agent Behaviors

- **Validation Checks:** Before proposing a git commit, always suggest or run syntax verification appropriate for the stack:
  - PHP: `php -l <file>`
  - Node/TypeScript: `pnpm run typecheck` or `npm run lint`
  - Flutter: `flutter analyze`
  - Rust: `cargo check`
- **Dependency Guardrails:** Never introduce outdated or deprecated libraries. Always inspect the lockfile/manifest to verify dependency alignment.
- **Security Sanitization:** Follow rules in `.specs/boundary-conditions.md` explicitly. Ensure output variables, templates, and queries are appropriately escaped or bound.

---

## 💾 Operational Rules

- **No Automatic Commits:** Always output proposed git modifications and proposed commit messages, and wait for explicit human confirmation.
- **Clean Architecture Boundaries:** Keep directories decoupled according to the repository's convention. Avoid throwing files directly into the root unless it is an established ecosystem rule (e.g. main plugin file in WordPress).
- **Git Commit Anonymity (CRITICAL)**: Never append, inject, or suggest any "Co-Authored-By" trailers, metadata, or attribution lines (e.g., "Co-Authored-By: Claude...") in git commit messages, code blocks, or automated git scripts. All git commit messages must remain completely anonymous or strictly limited to the user's explicit content.
- **Trigger-Rich Skill Description Standard (CRITICAL)**: Every skill's frontmatter description MUST follow the trigger-rich formula (what it does, required inputs, output files, and "Use when..." natural language triggers using folded YAML scalar `>-` format). Destructive/state-mutating skills must use deterrent language and explicitly state: "Only run when the user explicitly invokes the command. Do not auto-trigger."
- **Pre-Execution Initialization Guard (CRITICAL)**: Before executing any Sentinel command or skill (except for `/sentinel`, `/sentinel-mb`, `/sentinel-help`, `/sentinel-grill`, and `/sentinel-grillme`), you MUST verify that the Memory Bank has been bootstrapped by checking if `.memory-bank/active-session.json` or `.specs/` folders exist. If missing, halt execution and guide the user to run `/sentinel`, `/sentinel-mb`, or `/sentinel-grill`.
- **Markdown Code Fence Integrity (CRITICAL)**: When a skill file embeds a fenced code sample inside another fenced block (a nested fence), the outer wrapper MUST use more backticks than the inner one. Per CommonMark, a closing fence must use the same character and be at least as long as its opener, so a shorter closing fence does NOT close the block. Whenever you change an opening fence's backtick count, change its matching closing fence to the same count in the same edit, and never leave a fence open at end-of-file (it silently traps later sections like `Prompt Injection Shield` inside a code block).
- **Permanent Skepticism Standard (CRITICAL — Golden Rule)**: An agent MUST NEVER use absolute success language such as "perfect", "complete", "bulletproof", "god-tier", "all done", or "fully covered" about any skill, rule, or implementation. Mandatory default posture: always assume gaps exist, always present work as "current best iteration" not a finished state, and after any change proactively surface what is still NOT covered, what edge cases remain uncertain, and what future scenarios could still break the current implementation. Overconfidence causes the user to stop verifying — which is when real failures occur silently.
- **Post-Push Live CI/CD Pipeline Monitoring Protocol (CRITICAL)**: Whenever an agent executes `git push` on a project with an active CI/CD workflow, it MUST NOT end its turn with "Pushed!" without verifying the remote build outcome. In Antigravity/Gemini, use the `schedule` tool (e.g. `DurationSeconds="30"` timer or `CronExpression="*/1 * * * *"`) or background `run_command` with `gh run watch`. In Claude Code/CLI, use `gh run watch <run_id>` or `until` loop. In Cursor/Windsurf, use background tasks. If the pipeline fails, automatically run `gh run view <run_id> --log-failed`, diagnose root cause, apply a fix, commit, and push again.
- **End-to-End Feature Wiring Verification Rule (CRITICAL — Anti-Illusion Rule)**: An agent MUST NEVER declare a feature, phase, or project "100% Complete" or "Done" based solely on backend endpoints or frontend UI classes compiling. A feature is ONLY complete when its full 5-link End-to-End Wiring Chain is verified: (1) DB/Storage persistence -> (2) Backend API route -> (3) Frontend API client method -> (4) UI trigger element (button/form) -> (5) UI feedback/state update. If any link is missing (e.g. backend route exists but frontend client never calls it, or service method exists but no UI button triggers it), the feature MUST be classified as `🔴 UNCONNECTED` and reported as incomplete.
- **Premature Code Mutation Prevention (CRITICAL — Anti-Eager Trigger)**: An agent MUST NEVER edit files, run build/deploy commands, or mutate codebase state based on casual conversation, user brainstorming, or statements of future/personal intent (e.g., "I will change the domain later", "Thinking about switching to PostgreSQL", "I'm going to rename app.example.com"). Code modifications and build commands may ONLY be invoked upon explicit, present-tense commands. When the user shares an idea or future plan, discuss it in text, outline affected files, and ask: "Would you like me to proceed with updating these files now?" DO NOT touch code unsolicited.
- **Universal Ecosystem Abstraction Mandate (CRITICAL — Anti-Tunnel-Vision Rule)**: An agent modifying or creating rules, skills, or audit checks in this repository MUST NEVER frame a rule around a single language, framework, or ecosystem (e.g. WordPress, Node.js, Python, Flutter) when the underlying failure mode is structural or architectural. Whenever a bug or deception pattern is discovered in a specific technology, the agent MUST immediately abstract the underlying pattern across ALL major ecosystems (Node/TS, Python, Go, Rust, Java, .NET, Dart/Flutter, Ruby, PHP) BEFORE writing any rule or skill update.
- **Mandatory API Contract & Hook Argument Verification Rule (CRITICAL)**: An agent MUST NEVER guess parameter formats or types of framework hooks, event payloads, or middleware callbacks (e.g. Express `req.params.id` string vs number, FastAPI Path vs Query parameters, WordPress hook arguments). The agent MUST verify the authoritative framework contract specification before writing conditional logic.
- **Async State & Race Condition Safety Mandate (CRITICAL)**: Any code introducing asynchronous delays, timers, debounces, or state transitions (`setTimeout`, `setInterval`, `Promise.race`, `RxJS`) MUST implement deterministic cleanup (`clearTimeout`, cancellation tokens) to prevent stale timer execution from corrupting active UI/DOM or DB state during rapid re-invocations.
- **Asymmetric Data Attribute & Dead Signal Rule (CRITICAL)**: If a backend handler or template engine emits a data attribute, metadata key, or payload field (e.g. `data-gallery-id`), but no frontend client, JS event listener, or subscriber reads that key, the feature MUST be classified as `🔴 ASYMMETRIC / UNCONNECTED SIGNAL` and reported as incomplete.
- **Single Source of Truth Metadata Mandate**: Project metadata (version strings, build numbers, API base URLs, package slugs) MUST be read dynamically from a single canonical source of truth (e.g. `VERSION` file, `package.json`, `Cargo.toml`). Hardcoding the exact same metadata string across multiple separate source files is strictly prohibited.









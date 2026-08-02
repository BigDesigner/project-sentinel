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
Before executing any Sentinel command or skill (except for `/sentinel`, `/sentinel-mb`, `/sentinel-help`, `/sentinel-grill`, and `/sentinel-grillme`), you MUST verify that the Memory Bank has been bootstrapped by checking if `.memory-bank/active-session.json` or `.specs/` folders exist on disk. If they are missing:
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









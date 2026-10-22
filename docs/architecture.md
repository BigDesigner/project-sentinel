# Sentinel Memory Bank Architecture

This document describes the structure and file layout initialized by the Sentinel framework. It explains the purpose of each directory and file, ensuring context coherence for AI agents.

---

## 📂 Directory Layout

```
.
├── AGENTS.md               # Codex entry point; reads .agents/AGENTS.md
├── .memory-bank/           # Core context, session states, and decision logs
│   ├── active-session.json # Runtime state of the active session
│   ├── system-coherence.md # Checklist and coherence procedures
│   ├── migration-map.md    # Map of all files archived or reorganized
│   ├── adr/                # Architecture Decision Records (ADRs)
│   ├── changelog/          # Change logs and verified worklogs
│   ├── audits/             # Security reports and structural audits
│   ├── bugs/               # List of verified and unconfirmed bugs
│   └── state-of-the-union.md # Distilled context briefing (onboarding summary)
│
├── .specs/                 # Project technical specifications
│   ├── bootstrap.md        # Setup, installation, and build commands
│   ├── boundary-conditions.md # Technical limitations and safety budgets
│   ├── constitution.md     # Code quality and development standards
│   └── preflight-checklist.md # Persistent release & operator checklist
│
├── .agents/                # AI agent runtime customizations
│   ├── AGENTS.md           # Project-scoped AI behavior and rules (No Fluff)
│   └── runtime-manifest.json # Runtime configuration and permission boundaries
│
├── .tasks/                 # Active task management
│   ├── pipeline.md         # Active and future roadmap backlog
│   └── handoff.md          # Multi-agent/session transition logs
│
└── .archive/               # Historical archive for migrated files
    └── docs-migration/     # Superseded documentation categorized by date
```

---

## 🔍 Core Memory Bank Files

Codex discovers root and ancestor `AGENTS.md` files; `.agents/AGENTS.md` is the
Sentinel rule source and needs a root entry point. An `AGENTS.override.md` can
take precedence. Preserve existing instructions during bootstrap and verify
loaded sources in a new session. The runtime manifest records intended boundaries;
actual permissions are enforced by the host.

### 1. `.memory-bank/active-session.json`
Keeps track of the session state. It contains:
- `session_id`: Unique identifier of the current execution.
- `status`: `INITIALIZATION`, `ACTIVE`, `EXECUTION`, or `COMPLETED`.
- `preferred_language`: Custom communication language for user-agent chat.
- Git and worktree details to ensure operations occur in a clean environment.

### 2. `.memory-bank/system-coherence.md`
An automated checklist ensuring the agent verifies environment boundaries, checks git states, logs changes correctly, and adheres to safety policies before and after coding.

### 3. `.memory-bank/migration-map.md`
A registry mapping migrated, superseded, or archived documentation. This prevents historical project knowledge from being lost.

### 4. `.memory-bank/adr/` (Architecture Decision Records)
Markdown files tracking significant engineering decisions (e.g. choice of framework, deployment target, database engine). Structured as:
- **Context:** The issue or requirement.
- **Decision:** The chosen path.
- **Consequences:** Trade-offs and risks.
- **Evidence:** Concrete file references backing the decision.

---

## 🛡️ Project Specifications (`.specs/`)

- **`bootstrap.md`**: Centralizes dependencies, variables, environment setups, and deployment commands.
- **`boundary-conditions.md`**: Defines hard boundaries (e.g. rate limits, security models, data scopes) the agent must never violate.
- **`constitution.md`**: Project-specific development rules, naming conventions, architectural design patterns, and testing requirements.

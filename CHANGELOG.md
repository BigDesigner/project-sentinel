# Changelog

All notable changes to the Sentinel Agent Skill framework are documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); entries are grouped by date since the project does not use version tags yet.

## 2026-10-21 — 2026-11-17

### Added
- Full **Codex** platform support across `install.sh` (`--target codex`), `install.ps1` (`-Target Codex`), `README.md`, and `docs/architecture.md`, plus `agents/openai.yaml` (`allow_implicit_invocation: false`) on the four explicit-only skills (`sentinel-rescue`, `sentinel-prune`, `sentinel-handoff`, `sentinel-coauth`).
- **21-skill catalog & documentation generator**: `sentinel-docgen` for evidence-backed 6-file documentation scaffolding under `.documentation/`, and `sentinel-testpilot` for autonomous multi-ecosystem functional QA.
- **Enterprise Dual-Pass & Deep-Reasoning upgrades**:
  - `sentinel-audit`: Dual-Pass analysis (Pass 1 unconstrained multi-hop taint/dataflow & business-logic reasoning + Pass 2 27-point baseline), upstream reachability self-verification, lockfile advisory synergy, and Standalone Deep Audit Fallback Mode when `.specs/boundary-conditions.md` is absent.
  - `sentinel-qa`: Dual-Pass adversarial Red Team test design (concurrency races, IDOR/BOLA/BFLA, multi-tenant isolation, token/state-machine abuse, granular capability parity, legacy grandfathering, stale lock boundaries), positive controls, and zero-runtime-error gates.
  - `sentinel-planaudit`: Codebase grounding and Pre-Mortem runtime failure simulation (expand/contract migrations, rollback paths, idempotency, scale cliffs, compatibility).
  - `sentinel-drift`: Structural layer-inversion, paradigm, configuration, contract, and accepted-ADR decision drift detection.
  - `sentinel-preflight`: Zero-downtime migration, rollback readiness, health probes, and frozen lockfile/image supply-chain checks.
  - `sentinel-testpilot`: Property-based/fuzz testing, negative asset/code-load suppression checks, `git archive` A/B baseline comparisons, multi-runtime version matrices, and zero-notice runtime fail gates.
  - `sentinel-adr`: Spec synchronization check (Step 6.5) on ADR acceptance to prevent `.specs/` staleness.
  - `sentinel-brief`: Includes active accepted ADRs and open `Critical`/`High` audit/test risks in `state-of-the-union.md`.
  - `sentinel-handoff`: Records observed verification/test status (`Passing` / `Failing` / `Unverified`) alongside two-phase transaction crash reconciliation.
  - Parallel read-only partitioning option for 50+ file repositories in `sentinel-audit`, `sentinel-drift`, and `sentinel-docgen`.

### Fixed
- **State, Lock & Archive Safety (F03, F14, F16, R4, R6)**: Exclusive lock acquisition with stable `lock_owner_id`, heartbeat/liveness checks, 3-state destination-hash handoff crash reconciliation, collision-safe same-day log rotation, untracked-content `<statehash8>` digests, and atomic `O_CREAT | O_EXCL` report creation.
- **Destructive Path & Governance Guards (F02, F04, F05, F07, F08, R1–R8)**: Real-path/git-tracking/reproducibility checks in `sentinel-prune`, full working-tree/index preview and unconfirmed-history branch in `sentinel-rescue`, compare-first FIM baseline checks in `sentinel-mb`, read-only diagnostic exemption for `sentinel-doctor`, root agent-instruction file preservation during bootstrap, and localized warnings/language reuse.
- **Guardrails & Universal Rules**: Standardized F01 trusted user steering vs untrusted file payloads across all skills, synced downstream core engineering & governance invariants in `sentinel` Section 3.12, enforced Rule 41 (Public Artifact Isolation) and Rule 42 (Live Remote Production Mutation Prohibition), and normalized universal 18-ecosystem abstractions.

## 2026-07-13

### Added
- `sentinel-doctor` skill: deterministic memory bank integrity linter (schema completeness, stale locks, log rotation, archive consistency) with a report-first guided repair flow.
- GitHub Actions CI (`.github/workflows/sentinel-ci.yml`) enforcing directive/template sync (Rule 7), skill frontmatter validity, and canonical directory naming (Rule 2).
- Stale Lock Protocol: `.session.lock` files older than 10 minutes are treated as orphaned by a crashed session and safely cleared instead of blocking forever.
- `disable-model-invocation: true` on destructive skills (`sentinel-rescue`, `sentinel-prune`, `sentinel-handoff`) so they can only be invoked explicitly by the user, never auto-triggered (new AGENTS.md Rule 10).
- `install.sh` / `install.ps1` installer scripts that link each skill into `~/.claude/skills/` for native Claude Code support.
- Prompt Injection Shield and Reporting Language rules for `sentinel-scan`, `sentinel-audit`, `sentinel-handoff`, and `sentinel-mb`, which previously lacked them when invoked standalone.
- Language bootstrapping question in `sentinel-mb` so `preferred_language` is always confirmed even when the memory bank is initialized without the full `/sentinel` bootstrap.
- Runtime manifest boundary checks (`.agents/runtime-manifest.json`) in `sentinel-prune` and `sentinel-rescue` before any destructive operation.
- This changelog.

### Fixed
- Claude Code compatibility: skills are installed flat into `~/.claude/skills/`, resolving the nested-directory loading failure that prevented any skill from being recognized.
- `install.ps1` crashed on startup due to an invalid `-ForegroundColor Windows` value.
- `active-session.json` schema unified between `/sentinel` and `/sentinel-mb` (schema `1.1.0`), including the language field.
- README no longer claims `sentinel-handoff` pushes to git automatically, which contradicted Core Principle 8 (No automatic commits).
- Removed dead `concurrency_lock` schema fields, defunct `triggers:` frontmatter in all skills, and non-functional `/sentinel-pa` alias references.
- Handoff archives now use the folder-based `.archive/docs-migration/<YYYY-MM-DD>/` convention instead of loose files.
- Audit report filenames unified to `audit-<short-commit-hash>.md` with a date-based fallback.

## 2026-07-11 — 2026-07-12

### Added
- `sentinel-prune` skill for dependency/build garbage collection and package manager optimization (pnpm, uv).
- "God-mode" skill suite: `sentinel-clarify`, `sentinel-drift`, `sentinel-converge`, `sentinel-qa`, `sentinel-preflight`, `sentinel-rescue`, `sentinel-brief`.
- Persistent preflight checklist at `.specs/preflight-checklist.md`.

### Fixed
- Reports and chat responses explicitly mandated in the user's preferred language; language examples generalized to avoid localization bias.

## 2026-07-07 — 2026-07-09

### Added
- Initial framework: 7-step bootstrap directive, memory bank structure (`.memory-bank/`, `.specs/`, `.agents/`, `.tasks/`, `.archive/`), and the core skill suite.
- Enterprise security architecture: atomic session writes, session locking, log rotation, prompt injection shield.
- `sentinel-planaudit` plan cross-validation skill.
- Anti-Eager Execution protocol; project-scoped `AGENTS.md` directives; template auto-sync rules.

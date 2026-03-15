# Roadmap

**Project:** Open Specification Template for Python
**Version:** 0.1.0
**Last Updated:** 2026-03-14

---

## Overview

The template evolves from a functional but minimal scaffold (Phase 1) to a
production-ready, self-documenting template that compounds knowledge across
projects (Phase 5). Each phase is independently valuable — if development
stopped after Phase 2, the template would still be usable.

---

## Phase 1: Foundation

**Goal:** A working template that a human can clone, write a spec, and have
an agent begin implementing from.

**Deliverables:**
- OPENSPEC.md present in template root (copied from the standard repo)
- `spec/` directory with placeholder documents containing writing guidance
- Issue templates (Bootstrap, Implementation, Bug Fix, Compound Learning) in
  `.github/ISSUE_TEMPLATE/`
- AGENTS.md updated to reference OPENSPEC.md and the Open Specification methodology
- README.md rewritten to explain the template, its purpose, and quick start steps
- CLAUDE.md symlink pointing to AGENTS.md for Claude Code compatibility
- Existing Python harness verified working (ruff, mypy, pytest, pre-commit, CI)
- `docs/` structure includes `learnings/by-issue/`, `learnings/patterns/`,
  `learnings/anti-patterns/`, and `decisions/`

**Success Criteria:**
- A user can clone the template and all CI passes without modification
- `make pre-commit` succeeds on a fresh clone
- The `spec/` placeholder documents clearly guide the user on what to write
- Issue templates render correctly in the GitHub UI
- AGENTS.md contains actionable instructions that an agent can follow
- The template contains no project-specific content — everything is
  generic or clearly marked as a placeholder

**Dependencies:** None (starting point)

---

## Phase 2: Bootstrap Automation

**Goal:** The Bootstrap Issue template and AGENTS.md contain enough guidance
that an agent can reliably initialize a project from its specification.

**Deliverables:**
- A `scripts/bootstrap.sh` (or Python equivalent) that handles mechanical
  renaming: package directory, pyproject.toml fields, import statements,
  README references, and config prefixes
- AGENTS.md Section for bootstrap-specific instructions: what the agent reads,
  what it renames, what it scaffolds, and how it creates Phase 1 Issues
- A verification step that confirms the bootstrapped project passes all checks
  under the new name
- Documentation of the bootstrap process in OPENSPEC.md-compatible terms

**Success Criteria:**
- An agent assigned the Bootstrap Issue can rename the package, update
  configuration, scaffold directories from ARCHITECTURE.md, and open a PR —
  without human intervention beyond the initial Issue
- The bootstrapped project passes `make pre-commit` under the new project name
- Phase 1 Issues are created automatically from ROADMAP.md
- The human's review of the bootstrap PR is a 5-minute outcome check, not a
  detailed code review

**Dependencies:** Phase 1

---

## Phase 3: Verification and Self-Healing

**Goal:** Agents can verify their own work comprehensively and recover from
common failures without human intervention.

**Deliverables:**
- A `scripts/verify.sh` that runs the full verification suite (lint, format,
  type-check, test, coverage) and outputs structured results an agent can parse
- CI workflow enhancements: structured output on failure that agents can read
  from GitHub Actions logs to understand what went wrong
- AGENTS.md guidance for the self-healing protocol: how to read failures,
  classify them, and fix root causes
- A `make verify` target that wraps the verification script for convenience
- Coverage thresholds enforced in CI (configurable, defaulting to 80%)

**Success Criteria:**
- An agent that introduces a linting error, type error, or test failure can
  detect the problem from the verification output and fix it without human help
- CI failure logs contain enough structured information for an agent to
  understand and address the failure in a follow-up commit
- The verification script exits with clear, parseable status for each check
- Human never sees a PR where CI is failing — agents self-correct first

**Dependencies:** Phase 1

---

## Phase 4: Compound Learning Infrastructure

**Goal:** The template actively supports the compound engineering loop —
learnings from completed work are captured and feed back into future sessions.

**Deliverables:**
- `docs/learnings/` structure with clear conventions for organizing learnings
  by Issue, by pattern, and by anti-pattern
- AGENTS.md guidance on when and how to capture learnings: after merges,
  after bug fixes, after spec ambiguities are resolved
- A Compound Learning Issue template that agents can use (or that the system
  suggests after significant PRs are merged)
- Convention for proposing AGENTS.md updates: agents suggest additions in PRs,
  humans approve which learnings become permanent instructions
- Architecture Decision Record (ADR) template in `docs/decisions/` with
  numbering convention

**Success Criteria:**
- After 5 completed Issues, `docs/learnings/` contains at least 3 entries
  that provide actionable guidance for future work
- An agent starting a fresh session can read AGENTS.md and `docs/learnings/`
  and understand project conventions that emerged during development
- At least one pattern from `docs/learnings/patterns/` has been codified
  into AGENTS.md
- ADRs exist for any significant technical decisions made during development

**Dependencies:** Phase 2 (needs real Issues to generate real learnings)

---

## Phase 5: Template Polish and Distribution

**Goal:** The template is ready for public distribution — well-documented,
tested across multiple projects, and providing an excellent first-time experience.

**Deliverables:**
- README.md refined with real examples and clear quick-start path
- A "Template Health Check" script or CI step that validates the template
  structure is intact (OPENSPEC.md present, issue templates valid, spec/
  directory structure correct, AGENTS.md references OPENSPEC.md)
- At least one real project built from the template to validate the full
  lifecycle (bootstrap through multiple phases of development)
- Template marked as "Template repository" in GitHub settings
- OPENSPEC.md version pinning: the template declares which version of the
  standard it implements
- CHANGELOG.md tracking template evolution

**Success Criteria:**
- A new user can go from "Use this template" to "Bootstrap Issue opened"
  in under 30 minutes
- A new user can go from "Bootstrap Issue opened" to "First feature PR merged"
  in under 2 hours (excluding spec-writing time)
- The template has been used to build at least one real project beyond itself
- All documentation is accurate, complete, and free of template-residue
  (no references to "my-project" or TODO placeholders in shipped docs)
- GitHub template repository is enabled and discoverable

**Dependencies:** Phases 1-4 (needs a mature template to polish)

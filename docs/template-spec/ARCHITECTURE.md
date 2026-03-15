# Architecture

**Project:** Open Specification Template for Python
**Version:** 0.1.0
**Last Updated:** 2026-03-14

---

## System Overview

The Open Specification Template for Python is a GitHub Template Repository. It is
not a running application — it is a starting point that gets cloned and adapted for
each new project. The "system" is the set of files, conventions, and automation that
make up the development harness.

The template has three conceptual layers:

```
┌─────────────────────────────────────┐
│  Specification Layer                │  Human-authored, project-specific
│  spec/PRODUCT.md, ARCHITECTURE.md,  │  Defines WHAT to build
│  SPECIFICATION.md, ROADMAP.md       │
├─────────────────────────────────────┤
│  Methodology Layer                  │  From the standard, universal
│  OPENSPEC.md, Issue Templates       │  Defines HOW to operate
├─────────────────────────────────────┤
│  Harness Layer                      │  Language-specific infrastructure
│  CI/CD, Linting, Testing, Config,   │  Enables agents to build and verify
│  AGENTS.md, Verification Scripts    │
└─────────────────────────────────────┘
```

The Specification Layer is empty in the template (placeholders) and filled in by
the human for each project. The Methodology Layer comes from the Open Specification
standard and is the same across all projects. The Harness Layer is Python-specific
and provides the tooling that makes agents productive.

## Component Inventory

### Specification Directory (`spec/`)

**Responsibility:** Contains the four Open Specification documents that define
the product. This is the human's primary workspace.

**Contents:**
- `PRODUCT.md` — What and why
- `ARCHITECTURE.md` — System structure and design decisions
- `SPECIFICATION.md` — Functional requirements and interfaces
- `ROADMAP.md` — Phased construction plan
- `README.md` — Writing guidance and document index

**Conventions:**
- These files are authored by the human (possibly with AI chat assistance)
- Agents read these documents but do not modify them without explicit authorization
- The spec is the source of truth — code implements the spec, not the other way around

### Runtime Methodology (`OPENSPEC.md`)

**Responsibility:** Defines the operating protocol for the entire development
process. Governs how specs become Issues, how agents work, how verification
happens, and how learnings compound.

**Conventions:**
- Copied from the `open-specification` standard repo at a pinned version
- Not modified per-project — if the methodology needs to change, that change
  happens upstream in the standard
- Read by both humans and agents as the foundational process document

### Agent Instructions (`AGENTS.md`)

**Responsibility:** Project-specific instructions for AI coding agents. Contains
development conventions, coding standards, architectural patterns, and accumulated
learnings that agents must follow.

**Conventions:**
- Starts from template defaults (Python conventions, compound engineering workflow)
- Evolves over the project's lifetime as learnings are codified
- Kept under ~150 lines for the core instructions (agent context is scarce)
- Points to `docs/learnings/` for extended context rather than inlining everything
- Symlinked as `CLAUDE.md` and potentially `.cursorrules` for tool compatibility

### Source Code (`src/{package_name}/`)

**Responsibility:** The Python application code. Structured as an installable
package using the `src/` layout.

**Template defaults:**
- `__init__.py` — Package metadata and version
- `config.py` — Pydantic Settings configuration (all config via environment variables)
- `main.py` — Application entry point
- `models/` — Pydantic domain models

**Conventions:**
- `src/` layout (not flat layout) for clean packaging
- All configuration through `pydantic-settings` and environment variables
- Loguru for all logging (never print, never stdlib logging)
- Type hints on all function signatures
- Google-style docstrings on all public functions and classes

### Test Suite (`tests/`)

**Responsibility:** Automated tests that verify the application behaves
according to the specification.

**Structure:**
- `conftest.py` — Shared fixtures
- `unit/` — Fast tests with no external dependencies
- `integration/` — Tests that may require external services
- `fixtures/` — Test data and mock configurations

**Conventions:**
- pytest with markers: `@pytest.mark.unit`, `@pytest.mark.integration`, `@pytest.mark.e2e`
- Test files named `test_{module}.py`, functions named `test_{behavior}()`
- Coverage threshold enforced in CI (default: 80%)
- Agents write tests alongside implementation — untested code is incomplete

### CI/CD Workflows (`.github/workflows/`)

**Responsibility:** Automated verification and release management.

**Workflows:**
- `pre-commit.yml` — Runs all quality checks on PRs and pushes to main
- `release.yml` — Automated version bumping and GitHub Release creation
  on merged PRs with `release` label

**Design decision:** CI runs the same checks that `make pre-commit` runs locally.
There is no CI-only verification — everything an agent can check locally, CI also
checks, and vice versa. This ensures agents can self-verify before pushing.

### Issue Templates (`.github/ISSUE_TEMPLATE/`)

**Responsibility:** Structured forms that bridge human intent and agent execution.

**Templates:**
- `bootstrap.yml` — One-time project initialization from specification
- `implementation.yml` — Feature work, phase milestones, enhancements
- `bug-fix.yml` — Behavior deviating from specification
- `compound-learning.yml` — Codifying learnings into the knowledge base
- `config.yml` — Template chooser configuration

**Design decision:** YAML form format (not markdown templates) because forms
provide structured fields, validation, and dropdowns in the GitHub UI while
still being readable as text by agents.

### Knowledge Base (`docs/`)

**Responsibility:** Accumulated institutional knowledge from the development
process. This is where compound engineering pays off.

**Structure:**
- `learnings/by-issue/` — Learnings indexed by Issue number
- `learnings/patterns/` — Reusable patterns discovered during development
- `learnings/anti-patterns/` — Approaches that failed and why
- `decisions/` — Architecture Decision Records (ADRs)
- `proposals/` — Compound engineering proposals
- `plans/` — Implementation plans
- `templates/` — Document templates for proposals, plans, and retros

**Conventions:**
- Learnings are captured after significant PRs are merged
- Patterns that prove universal get codified into AGENTS.md
- ADRs are numbered sequentially: `001-chose-x-over-y.md`
- This directory is read by agents at the start of each session

### Verification Infrastructure

**Responsibility:** Scripts and configuration that enable agents to check
their own work before requesting human review.

**Components:**
- `Makefile` — Targets for lint, format, type-check, test, coverage, pre-commit
- `pyproject.toml` — Tool configuration (ruff, mypy, pytest, bandit)
- `.pre-commit-config.yaml` — Git hooks for quality enforcement
- `.env.example` — Environment variable template

**Design decision:** Makefile as the universal interface. Every verification
step is a `make` target. Agents run `make pre-commit` as a single command
to verify everything. This is agent-agnostic — any tool that can run shell
commands can use the Makefile.

### Bootstrap Infrastructure

**Responsibility:** Automation that adapts the generic template to a specific
project during initialization.

**Components:**
- `scripts/bootstrap.sh` (or Python equivalent) — Mechanical renaming of
  package, configuration, and references
- Bootstrap Issue template — Guides the agent through the initialization process
- AGENTS.md bootstrap section — Instructions specific to the initialization phase

## Key Design Decisions

### Decision: `src/` Layout Over Flat Layout

**Chosen:** `src/{package_name}/` layout
**Alternative:** `{package_name}/` flat layout
**Rationale:** The `src/` layout prevents accidental imports from the source
directory during testing, ensures the installed package is what gets tested,
and is the recommended practice for modern Python packaging. The slight
inconvenience of deeper nesting is worth the correctness guarantee.

### Decision: Makefile as Agent Interface

**Chosen:** Makefile with standardized targets
**Alternative:** Custom CLI tool, shell scripts, or Python invoke tasks
**Rationale:** Make is universal — it's installed everywhere, every agent knows
how to run `make`, and targets are self-documenting via `make help`. It adds
no dependencies and works identically across all AI coding agents. A custom
CLI would require installation and add complexity.

### Decision: YAML Issue Templates Over Markdown

**Chosen:** GitHub YAML form-based issue templates
**Alternative:** Markdown issue templates
**Rationale:** YAML forms provide structured fields with validation, dropdowns,
and checkboxes in the GitHub UI. This guides humans to provide the right
information (spec references, acceptance criteria) while agents parse the
resulting Issue as structured text. Markdown templates are more flexible but
less structured, leading to inconsistent Issues.

### Decision: AGENTS.md Over CLAUDE.md

**Chosen:** AGENTS.md as the canonical instruction file, with CLAUDE.md as a symlink
**Alternative:** CLAUDE.md as primary (since Claude Code is widely used)
**Rationale:** AGENTS.md is the open standard supported across Claude Code, Copilot,
Codex, Cursor, and others. Using it as primary ensures agent-agnosticism. The
CLAUDE.md symlink provides compatibility with tools that specifically look for
that filename.

### Decision: No Custom Orchestration Code

**Chosen:** GitHub Issues + PRs + Actions as the coordination layer
**Alternative:** Custom task queue, webhook-based agent triggering, or orchestration scripts
**Rationale:** GitHub already provides everything needed: Issues are the task queue,
PRs are the review gate, Actions are the verification engine, and branch protection
is the governance layer. Adding custom orchestration adds complexity and a maintenance
burden without meaningful capability gains. The template should have zero runtime
dependencies beyond standard GitHub features.

### Decision: Specification in `spec/` Not Root

**Chosen:** Spec documents in a `spec/` subdirectory
**Alternative:** Spec documents in the repository root
**Rationale:** Keeping specifications in `spec/` creates a clean separation between
"what to build" (spec/), "how to operate" (OPENSPEC.md, AGENTS.md), and "the build
itself" (src/, tests/, .github/). It also prevents filename collisions — a project
might have its own ARCHITECTURE.md for generated documentation that differs from
the specification.

## What Could Change

- **Bootstrap automation** may evolve from a shell script to a more sophisticated
  tool as we learn what agents struggle with during initialization
- **Verification scripts** may become more structured (JSON output, structured
  error classification) as we learn what agents need to self-heal effectively
- **The `docs/` structure** may be simplified or expanded based on what learnings
  actually get captured in practice vs. what was theoretically planned
- **Additional CI workflows** may be added for security scanning, dependency
  auditing, or automated compound learning prompts
- **The issue templates** will evolve as we discover what structured fields
  agents actually use vs. which ones are ignored

## What Is Fixed

- **OPENSPEC.md** comes from the standard repo and is not modified per-project
- **The four spec documents** (PRODUCT.md, ARCHITECTURE.md, SPECIFICATION.md,
  ROADMAP.md) follow the Open Specification standard format
- **Python tooling choices** (ruff, mypy, pytest, uv, loguru, pydantic) are
  the template's opinionated defaults — they work well together and are widely
  supported
- **GitHub as the platform** — Issues, PRs, Actions, and branch protection are
  the coordination mechanism
- **Agent-agnostic design** — no agent-specific features are required for core
  functionality

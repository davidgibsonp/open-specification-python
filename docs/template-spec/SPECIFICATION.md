# Specification

**Project:** Open Specification Template for Python
**Version:** 0.1.0
**Last Updated:** 2026-03-14

---

## 1. Template Clone and Initial State

When a user creates a new repository from this template (via GitHub's "Use this
template" button), the resulting repository must:

- Pass all CI checks without modification (`make pre-commit` succeeds)
- Contain no project-specific content — all content is generic or clearly
  marked as a placeholder
- Contain working examples (a minimal example module and test) that demonstrate
  the project's conventions
- Contain OPENSPEC.md at the root
- Contain empty `spec/` directory with placeholder documents and writing guidance
- Contain issue templates in `.github/ISSUE_TEMPLATE/`
- Contain AGENTS.md with template defaults
- Contain CLAUDE.md as a symlink to AGENTS.md

**Error condition:** If a user clones the template and CI fails, that is a
template bug — the template must be self-verifying at all times.

## 2. Specification Directory

### 2.1 Placeholder Documents

Each placeholder spec document (`spec/PRODUCT.md`, `spec/ARCHITECTURE.md`,
`spec/SPECIFICATION.md`, `spec/ROADMAP.md`) must contain:

- A title matching the document's purpose
- An HTML comment block explaining what the document should contain, what
  quality tests to apply, and a prompt to delete the comment and replace
  with the actual specification
- No lorem ipsum or fake content — only instructional guidance

### 2.2 Spec README

`spec/README.md` must contain:

- A table listing all four documents with their purpose and recommended
  writing order
- A link to OPENSPEC.md Section 2 for detailed requirements
- A link to the writing guide in the standard repo

### 2.3 Constraints

- Spec documents must be valid Markdown
- Spec documents must not be empty after bootstrap (the bootstrap process
  should fail or warn if spec documents still contain only placeholder content)
- The `spec/` directory must not contain any files other than the five listed
  above (README.md + four spec documents) at template time

## 3. Agent Instructions (AGENTS.md)

### 3.1 Required Sections

AGENTS.md must contain the following sections, in order:

1. **Project Overview** — Brief description with a reference to OPENSPEC.md
   and the spec/ directory
2. **Quick Reference** — Common commands (uv sync, pytest, ruff, pre-commit, mypy)
3. **Architecture** — Directory table mapping paths to purposes, including spec/
4. **Development Workflow** — Reference to OPENSPEC.md Section 3 (GitOps Loop)
   and the compound engineering cycle
5. **Mandatory Rules** — Logging (loguru), code quality, execution (uv run),
   style, testing, and configuration conventions
6. **Anti-patterns** — Table of what not to do with alternatives
7. **Key Files** — Table of important files including OPENSPEC.md, spec/ documents,
   and configuration files
8. **Environment Setup** — How to clone, install, and verify

### 3.2 Length Constraint

AGENTS.md core content (excluding the key files table and setup instructions)
should not exceed 150 lines. Detailed guidance belongs in `docs/` and is
referenced by filename, not inlined.

### 3.3 Tool Compatibility

- CLAUDE.md must exist as a symlink pointing to AGENTS.md
- A note in AGENTS.md should inform users that `.cursorrules` or other
  tool-specific files can also symlink to AGENTS.md
- AGENTS.md must not contain any syntax or conventions that are specific to
  a single AI coding tool

## 4. CI/CD Workflows

### 4.1 Pre-commit Workflow

**Trigger:** Push to `main`, pull requests targeting `main`

**Steps:**
1. Checkout repository
2. Set up Python (version from pyproject.toml `requires-python`)
3. Install uv
4. Install dependencies (`uv sync --group dev`)
5. Run pre-commit hooks (`uv run pre-commit run --all-files`)

**On failure:** Workflow outputs the specific check that failed and the
relevant error messages. Output must be clear enough for an agent to
read the Actions log and understand what to fix.

### 4.2 Release Workflow

**Trigger:** Pull request merged to `main` with `release` label

**Steps:**
1. Determine version bump type from PR labels (`release:major`, `release:minor`,
   default to `release:patch`)
2. Bump version in pyproject.toml
3. Commit version bump
4. Create GitHub Release with auto-generated release notes

**Constraints:**
- Only triggered when a PR with the `release` label is merged
- Version source of truth is `pyproject.toml`
- Release notes are generated from PR titles and commit messages

### 4.3 Future Workflow: Template Health Check

A workflow that validates the template structure is intact. This is for the
template repository itself, not for projects created from it.

**Checks:**
- OPENSPEC.md exists and is not empty
- All four spec placeholders exist in `spec/`
- All issue templates exist and are valid YAML
- AGENTS.md references OPENSPEC.md
- CLAUDE.md is a symlink to AGENTS.md
- `make pre-commit` passes

## 5. Issue Templates

### 5.1 Common Requirements

All issue templates must:

- Use GitHub YAML form format (not Markdown)
- Include a `labels` field with appropriate default labels
- Include an Acceptance Criteria field with checkboxes
- End acceptance criteria with: "All verification steps pass (`make pre-commit`)"
- Be parseable by any AI coding agent as structured text

### 5.2 Bootstrap Template

**Purpose:** One-time project initialization

**Required fields:**
- Project Name (text input, required)
- Package Name (text input, optional — derived from project name if blank)
- One-Line Description (text input, required)
- Bootstrap Instructions (textarea, pre-filled with OPENSPEC.md Section 4.2 steps)
- Acceptance Criteria (checkboxes)

**Behavior:** When an agent reads this Issue, it must have enough information
to execute the full bootstrap protocol without asking clarifying questions.

### 5.3 Implementation Template

**Purpose:** Feature work, phase milestones, enhancements

**Required fields:**
- Objective (textarea, required)
- Spec Reference (textarea, required)
- Acceptance Criteria (textarea with checkboxes, required)
- Context (textarea, optional)
- Roadmap Phase (dropdown, optional)

### 5.4 Bug Fix Template

**Purpose:** Behavior deviating from specification

**Required fields:**
- Observed Behavior (textarea, required)
- Expected Behavior (textarea, required)
- Spec Reference (textarea, required)
- Reproduction Steps (textarea, required)
- Acceptance Criteria (textarea with checkboxes, required)
- Context (textarea, optional)

### 5.5 Compound Learning Template

**Purpose:** Codifying learnings from completed work

**Required fields:**
- Source (textarea, required — which Issue/PR generated the learnings)
- Learnings (textarea, required)
- Proposed Changes (textarea, required)
- Acceptance Criteria (textarea with checkboxes, required)

## 6. Verification Infrastructure

### 6.1 Makefile Targets

The Makefile must provide these targets:

| Target | Behavior |
|--------|----------|
| `help` | Display all available targets with descriptions |
| `setup` | Install dependencies and pre-commit hooks |
| `test` | Run all tests |
| `test-unit` | Run unit tests only |
| `test-integration` | Run integration tests only |
| `test-cov` | Run tests with coverage report |
| `lint` | Run linter (ruff check) |
| `format` | Run formatter (ruff format) |
| `type-check` | Run type checker (mypy) |
| `pre-commit` | Run all pre-commit hooks (the "verify everything" command) |
| `clean` | Remove build artifacts and caches |

**Constraint:** `make pre-commit` must run all quality checks that CI runs.
An agent that runs `make pre-commit` locally and gets a clean result must
also pass CI.

### 6.2 Python Tooling Configuration

All tool configuration lives in `pyproject.toml`:

- **ruff**: Line length 100, target Python version from `requires-python`,
  select rules E, F, I, B, T20, UP, SIM
- **mypy**: Strict mode, Pydantic plugin, ignore missing imports
- **pytest**: Test paths `tests/`, async mode auto, markers for unit/integration/e2e
- **coverage**: Configurable threshold (default 80%)

### 6.3 Pre-commit Hooks

The `.pre-commit-config.yaml` must include at minimum:

- ruff (lint + format)
- mypy type checking
- Trailing whitespace and end-of-file fixes
- YAML and TOML validation

## 7. Bootstrap Process

### 7.1 What Gets Renamed

During bootstrap, the following must be updated:

- `src/my_project/` → `src/{package_name}/`
- `pyproject.toml`: name, description, package path
- `Makefile`: coverage path references
- `AGENTS.md`: project overview, architecture table
- `README.md`: project name, description, purpose
- `.env.example`: environment variable prefix
- `src/{package_name}/config.py`: settings class name and env prefix
- Any import statements in tests that reference `my_project`

### 7.2 What Gets Scaffolded

Based on ARCHITECTURE.md, the agent should create:

- Additional directories under `src/{package_name}/` as defined by the spec
- Additional test directories mirroring the source structure
- Any configuration files referenced in the specification

### 7.3 What Gets Created

Based on ROADMAP.md Phase 1, the agent should:

- Open one Issue per deliverable in Phase 1 using the Implementation template
- Each Issue references the specific section of the spec it implements
- Issues are labeled with `phase-1` and `implementation`

### 7.4 Verification

The bootstrap PR must pass:

- `make pre-commit` under the new package name
- No references to `my_project` or `my-project` remain (except in template
  documentation that explicitly discusses the template's placeholder naming)
- The package is importable: `python -c "import {package_name}"`

## 8. Compound Learning Infrastructure

### 8.1 Learning File Format

Files in `docs/learnings/` follow this format:

```markdown
# Learning: {Title}

**Source:** Issue #{number} / PR #{number}
**Date:** {date}
**Category:** pattern | anti-pattern | insight

## What Happened

{Description of the situation}

## What We Learned

{The actionable insight}

## Recommendation

{What to do differently next time, or what to keep doing}
```

### 8.2 Decision Record Format

Files in `docs/decisions/` follow this format:

```markdown
# ADR-{number}: {Title}

**Date:** {date}
**Status:** accepted | superseded by ADR-{number}

## Context

{What prompted this decision}

## Decision

{What was decided}

## Consequences

{What follows from this decision — both positive and negative}
```

### 8.3 Codification Process

When a learning is identified as a universal project pattern:

1. The learning is documented in `docs/learnings/patterns/`
2. An agent (or human) proposes an AGENTS.md addition in a PR
3. The human reviews and approves the addition
4. Future agents benefit from the codified pattern

This process is encouraged but not enforced — it depends on the discipline
of the compound step.

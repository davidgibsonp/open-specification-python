# AGENTS.md -- TODO: Project Name

> This file is the canonical source of agent instructions. All AI coding
> assistants (Claude Code, Cursor, Copilot, etc.) should read this file.

## Project Overview

<!-- TODO: Replace with 2-3 sentence project description -->
<!-- TODO: What does this project do? What problem does it solve? -->

## Quick Reference

```bash
uv sync                              # Install dependencies
uv run pytest tests/ -v              # Run all tests
uv run ruff check src/ tests/        # Lint
uv run ruff format src/ tests/       # Format
uv run pre-commit run --all-files    # All quality checks
uv run mypy src/                     # Type check
```

## Architecture

<!-- TODO: Replace with actual architecture -->

| Directory | Purpose |
|-----------|---------|
| `src/my_project/config.py` | Pydantic settings, all config via env vars |
| `src/my_project/main.py` | Application entry point |
| `src/my_project/models/` | Domain models (Pydantic) |
| `src/my_project/services/` | External integrations and business logic |
| `tests/unit/` | Fast tests, no external dependencies |
| `tests/integration/` | Tests requiring external services |
| `docs/` | Proposals, plans, learnings, decisions |

## Development Workflow: Compound Engineering

Every significant change follows: **Research -> Plan -> Implement -> Retro -> Codify**

1. **Proposal** (`docs/proposals/NNN-title.md`) -- What and why
2. **Plan** (`docs/plans/NNN-title.md`) -- How, step by step
3. **Implementation** -- Code the plan, PR references proposal + plan
4. **Retrospective** (`docs/learnings/by-proposal/NNN-retro.md`) -- What we learned
5. **Codify** -- Update AGENTS.md, patterns, or decisions as needed

Small fixes and bug fixes skip this process. Use judgment: if it touches
architecture or takes > 1 hour, write a proposal first.

## Mandatory Rules

### Logging

- **Always** use `loguru` -- never `print()`, never `logging` stdlib
- **Never** use f-strings in loguru calls. Use lazy formatting:

  ```python
  # WRONG
  logger.info(f"Processing {count} items")

  # RIGHT
  logger.info("Processing {} items", count)
  ```

### Code Quality

- No bare `except:` -- always catch specific exceptions
- No mutable default arguments in function signatures
- No hardcoded configuration values -- use `config.py` / env vars
- No dead code -- git preserves history, delete unused code
- No `# type: ignore` without explanation comment
- No blocking calls in async functions

### Execution

- **Always** use `uv run` -- never `python` directly
- **Always** use `uv add` -- never `pip install`
- Run `uv run pre-commit run --all-files` before requesting review

### Style

- Google docstrings on all public functions and classes
- Type hints on all function signatures
- Pydantic `Field(description=...)` on all model fields
- Line length: 100 characters

### Testing

- Tests go in `tests/unit/` or `tests/integration/`
- Use pytest markers: `@pytest.mark.unit`, `@pytest.mark.integration`, `@pytest.mark.e2e`
- Name test files `test_<module>.py`, test functions `test_<behavior>()`

### Configuration

- All config via `pydantic-settings` in `src/my_project/config.py`
- Environment variable prefix: `MY_PROJECT_` <!-- TODO: customize -->
- `.env` file for local development, `.env.example` committed as template

## Anti-patterns (Do Not Do)

| Anti-pattern | Why | Instead |
|-------------|-----|---------|
| `print("debug")` | Invisible in production logs | `logger.debug("message")` |
| `logger.info(f"x={x}")` | Evaluates even when level disabled | `logger.info("x={}", x)` |
| `except:` or `except Exception:` | Swallows errors silently | Catch specific exceptions |
| `def f(items=[])` | Shared mutable state across calls | `def f(items=None)` |
| `API_KEY = "sk-..."` | Secrets in code | `settings.api_key` from env |
| `python script.py` | Wrong venv, wrong deps | `uv run script.py` |
| `time.sleep()` in async | Blocks the event loop | `await asyncio.sleep()` |
| Commented-out code | Clutters and confuses | Delete it; git has history |

## Key Files

<!-- TODO: Update as project grows -->

| File | Purpose |
|------|---------|
| `pyproject.toml` | Dependencies, build config, tool settings |
| `src/my_project/config.py` | All configuration (Pydantic Settings) |
| `src/my_project/models/example.py` | Golden example: Pydantic model pattern |
| `tests/unit/test_example.py` | Golden example: test pattern |
| `.env.example` | Template for required environment variables |

## Environment Setup

```bash
# Clone and install
git clone <repo-url>
cd my-project
make setup

# Or manually:
uv sync
cp .env.example .env
# Edit .env with your values
uv run pre-commit install

# Verify everything works
uv run pytest tests/ -v
uv run pre-commit run --all-files
```

## Common Issues

<!-- TODO: Add project-specific issues as they arise -->

**`uv sync` fails**
Check Python version: `python --version` should be 3.13+. Install via `uv python install 3.13`.

**Pre-commit hooks fail on first run**
Run `uv run pre-commit install` then `uv run pre-commit run --all-files` to initialize hook environments.

## Decisions Log

Architectural decisions are recorded in `docs/decisions/`. When making a
decision that affects project structure, dependencies, or patterns, create
a new file: `docs/decisions/NNN-title.md`.

<!-- TODO: Add project-specific decisions as they are made -->

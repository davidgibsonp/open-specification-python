# AGENTS.md — Open Specification Template for Python

> This file is the canonical source of agent instructions. All AI coding
> assistants (Claude Code, Cursor, Copilot, etc.) should read this file.
>
> For tools that use `CLAUDE.md` or `.cursorrules`, create a symlink or
> pointer to this file.

**This project follows the [Open Specification](OPENSPEC.md) methodology.
Read OPENSPEC.md for the runtime protocol that governs all work in this
repository.**

## Project Overview

This is the Open Specification Template for Python. See `spec/` for the
product specification.

## Quick Reference

```bash
uv sync                              # Install dependencies
uv run pytest tests/ -v              # Run all tests
uv run ruff check src/ tests/        # Lint
uv run ruff format src/ tests/       # Format
uv run pre-commit run --all-files    # All quality checks
uv run mypy src/                     # Type check
make verify                          # Full verification with structured output
```

## Architecture



| Directory | Purpose |
|-----------|---------|
| `src/my_project/config.py` | Pydantic settings, all config via env vars |
| `src/my_project/main.py` | Application entry point |
| `src/my_project/models/` | Domain models (Pydantic) |
| `src/my_project/services/` | External integrations and business logic |
| `tests/unit/` | Fast tests, no external dependencies |
| `tests/integration/` | Tests requiring external services |
| `spec/` | Open Specification documents (product, architecture, spec, roadmap) |
| `docs/` | Proposals, plans, learnings, decisions |

## Development Workflow: Compound Engineering

Every significant change follows the **GitOps Loop** defined in OPENSPEC.md Section 3:
**Issue → Branch → Implement → Verify → PR → Review → Merge → Compound**

Within each implementation cycle, use compound engineering:
**Research -> Plan -> Implement -> Retro -> Codify**

1. **Proposal** (`docs/proposals/NNN-title.md`) -- What and why
2. **Plan** (`docs/plans/NNN-title.md`) -- How, step by step
3. **Implementation** -- Code the plan, PR references proposal + plan
4. **Retrospective** (`docs/learnings/by-issue/NNN-retro.md`) -- What we learned
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
- Environment variable prefix: `MY_PROJECT_`
- `.env` file for local development, `.env.example` committed as template

### GitHub Issue Templates

- **Always** provide a non-empty string for the `title` field in `.github/ISSUE_TEMPLATE/*.yml` files
- GitHub silently hides templates with empty titles (`title: ""`) from the issues/new/choose UI
- Use descriptive prefixes: `title: "Implementation: "`, `title: "Bug: "`, `title: "Compound Learning: "`
- This is an undocumented GitHub platform quirk that cannot be detected by AI agents without user feedback

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

| File | Purpose |
|------|---------|
| `OPENSPEC.md` | Runtime methodology — how this project operates |
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



**`uv sync` fails**
Check Python version: `python --version` should be 3.13+. Install via `uv python install 3.13`.

**Pre-commit hooks fail on first run**
Run `uv run pre-commit install` then `uv run pre-commit run --all-files` to initialize hook environments.

## Self-Healing Protocol

When verification fails, follow this protocol to diagnose and fix issues without human
intervention. Always run `make verify` or `make pre-commit` before opening a PR.

### Verification Commands

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `make verify` | Full suite with structured output | Before any PR, after any code change |
| `make pre-commit` | Run all pre-commit hooks | Quick full check |
| `make lint` | Lint only (ruff check) | After fixing lint issues |
| `make format` | Format code (ruff format) | Auto-fix formatting |
| `make type-check` | Type check only (mypy) | After fixing type issues |
| `make test-cov` | Tests with coverage threshold | After changing tests |

### Ruff Lint Errors

**Common error codes and fixes:**

| Code | Meaning | Fix |
|------|---------|-----|
| `E501` | Line too long (>100 chars) | Break line or refactor |
| `F401` | Unused import | Remove the import |
| `F841` | Unused variable | Remove or use the variable |
| `I001` | Import order wrong | Run `uv run ruff check --fix` |
| `B006` | Mutable default argument | Use `None` + conditional |
| `T201` | Print statement in src/ | Use `logger.info()` instead |
| `UP` | Outdated Python syntax | Run `uv run ruff check --fix` |

**Auto-fix most lint issues:**
```bash
uv run ruff check --fix src/ tests/
```

**Manual fixes required for:**
- Unused variables that should be used (logic error)
- Print statements that need logger conversion
- Complex line-length issues requiring refactoring

### Mypy Type Errors

**Common causes and solutions:**

| Error Pattern | Cause | Solution |
|---------------|-------|----------|
| `Missing return statement` | Function lacks return on all paths | Add missing return statements |
| `Incompatible return value type` | Return type doesn't match annotation | Fix return type or annotation |
| `has no attribute` | Accessing attribute that doesn't exist | Check spelling, add type narrowing |
| `Cannot find implementation or library stub` | Missing type stubs | Add to `ignore_missing_imports` or install stubs |
| `Argument of type X cannot be assigned to Y` | Type mismatch in function call | Cast, convert, or fix the argument |
| `Missing type parameters` | Generic without type args | Add type parameters: `list[str]`, `dict[str, int]` |

**Type checking workflow:**
```bash
# Run type check
uv run mypy src/

# If you need to ignore a specific line (with explanation):
value = some_complex_call()  # type: ignore[return-value]  # Known issue: #123
```

**When adding `# type: ignore`:**
- Always include the specific error code: `# type: ignore[error-code]`
- Always add an explanation comment
- Create a tracking issue for systematic fixes

### Test Failures

**Reading pytest output:**

1. **Find the failing test:** Look for `FAILED` in the output
2. **Read the assertion:** The `AssertionError` shows expected vs actual
3. **Check the traceback:** Follow the stack trace to the error location
4. **Look for fixtures:** Missing or misconfigured fixtures cause `ERROR` not `FAILED`

**Isolate failing tests:**
```bash
# Run single test
uv run pytest tests/unit/test_module.py::TestClass::test_name -v

# Run with print output visible
uv run pytest tests/unit/test_module.py -v -s

# Run with debugger on failure
uv run pytest tests/unit/test_module.py --pdb
```

**Common test failure patterns:**

| Pattern | Cause | Fix |
|---------|-------|-----|
| `AssertionError: assert X == Y` | Logic error or changed behavior | Fix code or update test |
| `AttributeError: 'NoneType'` | Missing return or None check | Add None handling |
| `fixture 'X' not found` | Missing fixture in conftest.py | Add fixture or check import |
| `ModuleNotFoundError` | Missing dependency or wrong path | Check imports and `pythonpath` |

### Import Errors

**Circular imports:**

Symptoms:
- `ImportError: cannot import name 'X' from partially initialized module`
- `AttributeError: module 'X' has no attribute 'Y'`

Solutions:
1. **Move import inside function** (lazy import):
   ```python
   def my_function():
       from my_project.other import OtherClass  # Lazy import
       return OtherClass()
   ```

2. **Use TYPE_CHECKING block** for type hints only:
   ```python
   from typing import TYPE_CHECKING
   if TYPE_CHECKING:
       from my_project.other import OtherClass  # Only for type checking
   ```

3. **Restructure modules** to break the cycle

**Missing `__init__.py`:**

Symptoms:
- `ModuleNotFoundError: No module named 'my_project.subpackage'`

Fix: Create `__init__.py` in the package directory:
```bash
touch src/my_project/subpackage/__init__.py
```

**Wrong package paths:**

Check `pythonpath` in `pyproject.toml`:
```toml
[tool.pytest.ini_options]
pythonpath = ["."]
```

Ensure imports match the actual directory structure.

### Pre-commit Hook Failures

**Re-run specific hooks:**
```bash
# Run all hooks
uv run pre-commit run --all-files

# Run specific hook by ID
uv run pre-commit run ruff --all-files
uv run pre-commit run mypy --all-files
uv run pre-commit run ruff-format --all-files

# Skip a hook temporarily (use sparingly)
SKIP=mypy uv run pre-commit run --all-files
```

**Hook IDs in this project:**
- `gitleaks` — Secret detection
- `bandit` — Security audit
- `pydoclint` — Docstring validation
- `ruff` — Linting
- `ruff-format` — Formatting
- `mypy` — Type checking
- `ban-loguru-f-strings` — Lazy logging check

**When hooks fail in CI but pass locally:**
1. Run `uv sync` to ensure dependencies match
2. Run `uv run pre-commit clean` then retry
3. Check for OS-specific issues (line endings, paths)

### Coverage Failures

**Coverage threshold is configured in `pyproject.toml`:**
```toml
[tool.coverage.report]
fail_under = 80
```

**When coverage is below threshold:**
```bash
# See uncovered lines
uv run pytest tests/ --cov=src/my_project --cov-report=term-missing

# Generate HTML report for detailed view
uv run pytest tests/ --cov=src/my_project --cov-report=html
# Then open htmlcov/index.html
```

**Improving coverage:**
1. Add tests for uncovered functions/branches
2. Remove dead code that isn't covered
3. Add `# pragma: no cover` only for truly untestable code (e.g., `if __name__ == "__main__"`)

### Verification Loop

**Standard workflow when verification fails:**

```
1. Run: make verify
   ↓
2. If FAIL: Read structured output
   ↓
3. Identify: Which check failed?
   ↓
4. Diagnose: What's the specific error?
   ↓
5. Fix: Apply the appropriate solution
   ↓
6. Re-verify: Run make verify again
   ↓
7. Repeat until ALL CHECKS PASSED
```

**Never open a PR with failing verification.** The CI will fail, and the human
reviewer will see a broken build. Self-heal first.

## Decisions Log

Architectural decisions are recorded in `docs/decisions/`. When making a
decision that affects project structure, dependencies, or patterns, create
a new file: `docs/decisions/NNN-title.md`.

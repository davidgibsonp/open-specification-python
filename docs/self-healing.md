# Self-Healing Protocol

This document provides detailed guidance for diagnosing and fixing common verification
failures. When verification fails, use this reference to self-correct before opening a PR.

## Verification Commands

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `make verify` | Full suite with structured output | Before any PR, after any code change |
| `make pre-commit` | Run all pre-commit hooks | Quick full check |
| `make lint` | Lint only (ruff check) | After fixing lint issues |
| `make format` | Format code (ruff format) | Auto-fix formatting |
| `make type-check` | Type check only (mypy) | After fixing type issues |
| `make test-cov` | Tests with coverage threshold | After changing tests |

## Ruff Lint Errors

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

## Mypy Type Errors

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

## Test Failures

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

## Import Errors

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

## Pre-commit Hook Failures

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

## Coverage Failures

**Coverage threshold is configured in `pyproject.toml`:**
```toml
[tool.coverage.report]
fail_under = 80
```

**When coverage is below threshold:**
```bash
# See uncovered lines
uv run pytest tests/ --cov --cov-report=term-missing

# Generate HTML report for detailed view
uv run pytest tests/ --cov --cov-report=html
# Then open htmlcov/index.html
```

**Improving coverage:**
1. Add tests for uncovered functions/branches
2. Remove dead code that isn't covered
3. Add `# pragma: no cover` only for truly untestable code (e.g., `if __name__ == "__main__"`)

## Verification Loop

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

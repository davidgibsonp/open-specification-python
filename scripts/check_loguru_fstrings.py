"""Pre-commit hook: detect f-strings in loguru logger calls.

Enforces lazy formatting: ``logger.info("User {}", user)``
instead of ``logger.info(f"User {user}")``.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

PATTERN = re.compile(
    r"""logger\.(trace|debug|info|success|warning|error|critical)\(\s*f["']""",
)


def check_file(path: Path) -> list[str]:
    """Check a single file for f-string loguru violations.

    Args:
        path: Path to the Python file.

    Returns:
        List of violation messages.
    """
    violations = []
    for i, line in enumerate(path.read_text().splitlines(), start=1):
        if PATTERN.search(line):
            violations.append(f"{path}:{i}: {line.strip()}")
    return violations


def main() -> int:
    """Check all provided files for loguru f-string violations.

    Returns:
        Exit code (0 if clean, 1 if violations found).
    """
    files = [Path(f) for f in sys.argv[1:] if f.endswith(".py")]
    all_violations: list[str] = []

    for path in files:
        if path.exists():
            all_violations.extend(check_file(path))

    if all_violations:
        print("Loguru f-string violations (use lazy formatting instead):")  # noqa: T201
        for v in all_violations:
            print(f"  {v}")  # noqa: T201
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

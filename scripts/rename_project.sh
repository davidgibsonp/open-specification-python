#!/usr/bin/env bash
# Rename the template project placeholders to your project name.
#
# Usage:
#   bash scripts/rename_project.sh my_cool_app
#
# This will:
#   1. Rename src/my_project/ -> src/my_cool_app/
#   2. Replace "my_project" -> "my_cool_app" in all files (snake_case)
#   3. Replace "my-project" -> "my-cool-app" in all files (kebab-case)
#   4. Replace "MY_PROJECT_" -> "MY_COOL_APP_" in all files (env prefix)

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: bash scripts/rename_project.sh <project_name>"
    echo "  project_name: snake_case name (e.g. my_cool_app)"
    exit 1
fi

SNAKE_NAME="$1"

# Validate: must be valid Python identifier (lowercase, underscores, no leading digit)
if ! echo "$SNAKE_NAME" | grep -qE '^[a-z][a-z0-9_]*$'; then
    echo "Error: project name must be a valid Python identifier (lowercase, underscores only)"
    echo "  Got: $SNAKE_NAME"
    echo "  Example: my_cool_app"
    exit 1
fi

KEBAB_NAME="${SNAKE_NAME//_/-}"
UPPER_NAME="$(echo "$SNAKE_NAME" | tr '[:lower:]' '[:upper:]')"

echo "Renaming project:"
echo "  snake_case:  my_project  -> $SNAKE_NAME"
echo "  kebab-case:  my-project  -> $KEBAB_NAME"
echo "  UPPER_SNAKE: MY_PROJECT_ -> ${UPPER_NAME}_"
echo ""

# Get the repo root (where this script lives is scripts/, go up one)
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

# 1. Rename the source directory
if [ -d "src/my_project" ]; then
    mv "src/my_project" "src/$SNAKE_NAME"
    echo "Renamed src/my_project/ -> src/$SNAKE_NAME/"
else
    echo "Warning: src/my_project/ not found (already renamed?)"
fi

# 2. Find-and-replace in all text files
# Exclude .git/, .venv/, binary files, and this script
export LC_ALL=C

find . \
    -type f \
    -not -path './.git/*' \
    -not -path './.venv/*' \
    -not -path './.mypy_cache/*' \
    -not -path './.ruff_cache/*' \
    -not -path './.pytest_cache/*' \
    -not -path './uv.lock' \
    -not -name '*.pyc' \
    -not -name 'rename_project.sh' \
    | while read -r file; do
    # Skip binary files
    if ! file --mime "$file" 2>/dev/null | grep -q 'text/'; then
        continue
    fi
    # Check if file contains any of the old names
    if grep -ql 'my_project\|my-project\|MY_PROJECT' "$file" 2>/dev/null; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' \
                -e "s/my_project/$SNAKE_NAME/g" \
                -e "s/my-project/$KEBAB_NAME/g" \
                -e "s/MY_PROJECT/$UPPER_NAME/g" \
                "$file"
        else
            sed -i \
                -e "s/my_project/$SNAKE_NAME/g" \
                -e "s/my-project/$KEBAB_NAME/g" \
                -e "s/MY_PROJECT/$UPPER_NAME/g" \
                "$file"
        fi
        echo "  Updated: $file"
    fi
done

echo ""
echo "Done! Next steps:"
echo "  1. Fill in TODO markers in AGENTS.md and README.md"
echo "  2. uv sync"
echo "  3. uv run pre-commit install"
echo "  4. uv run pytest tests/ -v"

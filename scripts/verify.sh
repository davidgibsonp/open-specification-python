#!/bin/bash
# scripts/verify.sh - Full verification suite with structured output
#
# Usage: ./scripts/verify.sh [--coverage-threshold N]
#
# This script runs all verification checks and outputs structured PASS/FAIL
# results that agents can parse programmatically.
#
# The coverage threshold can be set via:
#   1. --coverage-threshold N argument
#   2. COVERAGE_THRESHOLD environment variable
#   3. [tool.coverage.report] fail_under in pyproject.toml (default)
#
# Exit codes:
#   0 - All checks passed
#   1 - One or more checks failed

set -o pipefail

# Colors for terminal output (disabled if not a TTY)
if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    NC=''
fi

# Try to read coverage threshold from pyproject.toml if not set
get_coverage_threshold() {
    if [ -n "$COVERAGE_THRESHOLD" ]; then
        echo "$COVERAGE_THRESHOLD"
        return
    fi

    # Try to extract from pyproject.toml
    if [ -f "pyproject.toml" ]; then
        local threshold
        threshold=$(grep -A10 '\[tool\.coverage\.report\]' pyproject.toml | grep 'fail_under' | head -1 | sed 's/.*=\s*//' | tr -d ' ')
        if [ -n "$threshold" ]; then
            echo "$threshold"
            return
        fi
    fi

    # Default fallback
    echo "80"
}

COVERAGE_THRESHOLD=$(get_coverage_threshold)

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --coverage-threshold)
            COVERAGE_THRESHOLD="$2"
            shift 2
            ;;
        *)
            echo "Unknown argument: $1"
            exit 1
            ;;
    esac
done

# Track overall status
OVERALL_STATUS=0
declare -A CHECK_RESULTS

# Function to print check header
print_header() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}CHECK: $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════════${NC}"
}

# Function to print check result
print_result() {
    local check_name="$1"
    local status="$2"  # 0 = pass, non-zero = fail
    local output="$3"

    if [ "$status" -eq 0 ]; then
        echo -e "${GREEN}[PASS]${NC} $check_name"
        CHECK_RESULTS["$check_name"]="PASS"
    else
        echo -e "${RED}[FAIL]${NC} $check_name"
        CHECK_RESULTS["$check_name"]="FAIL"
        OVERALL_STATUS=1
        if [ -n "$output" ]; then
            echo -e "${YELLOW}--- Error Output ---${NC}"
            echo "$output"
            echo -e "${YELLOW}--- End Error Output ---${NC}"
        fi
    fi
}

# Function to extract coverage percentage from pytest-cov output
extract_coverage() {
    local output="$1"
    # Match the TOTAL line and extract percentage: TOTAL    123   5    96%
    echo "$output" | grep -E "^TOTAL" | awk '{print $NF}' | tr -d '%'
}

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                        VERIFICATION SUITE                                     ║${NC}"
echo -e "${BLUE}║                   Coverage Threshold: ${COVERAGE_THRESHOLD}%${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"

# ============================================================================
# CHECK 1: Ruff Lint
# ============================================================================
print_header "Ruff Lint (ruff check)"

LINT_OUTPUT=$(uv run ruff check src/ tests/ 2>&1)
LINT_STATUS=$?

print_result "Ruff Lint" "$LINT_STATUS" "$LINT_OUTPUT"

# ============================================================================
# CHECK 2: Ruff Format
# ============================================================================
print_header "Ruff Format Check (ruff format --check)"

FORMAT_OUTPUT=$(uv run ruff format --check src/ tests/ 2>&1)
FORMAT_STATUS=$?

print_result "Ruff Format" "$FORMAT_STATUS" "$FORMAT_OUTPUT"

# ============================================================================
# CHECK 3: Mypy Type Check
# ============================================================================
print_header "Mypy Type Check"

MYPY_OUTPUT=$(uv run mypy src/ 2>&1)
MYPY_STATUS=$?

print_result "Mypy Type Check" "$MYPY_STATUS" "$MYPY_OUTPUT"

# ============================================================================
# CHECK 4: Pytest with Coverage
# ============================================================================
print_header "Pytest with Coverage"

TEST_OUTPUT=$(uv run pytest tests/ --cov=src/my_project --cov-report=term-missing --cov-fail-under="$COVERAGE_THRESHOLD" -v 2>&1)
TEST_STATUS=$?

# Even if tests pass, coverage might be below threshold
COVERAGE_PCT=$(extract_coverage "$TEST_OUTPUT")

if [ "$TEST_STATUS" -eq 0 ]; then
    print_result "Pytest" "$TEST_STATUS" ""
    if [ -n "$COVERAGE_PCT" ]; then
        echo -e "  Coverage: ${GREEN}${COVERAGE_PCT}%${NC} (threshold: ${COVERAGE_THRESHOLD}%)"
    fi
else
    print_result "Pytest" "$TEST_STATUS" "$TEST_OUTPUT"
fi

# ============================================================================
# SUMMARY
# ============================================================================
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}VERIFICATION SUMMARY${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════════${NC}"

for check in "Ruff Lint" "Ruff Format" "Mypy Type Check" "Pytest"; do
    result="${CHECK_RESULTS[$check]}"
    if [ "$result" = "PASS" ]; then
        echo -e "  ${GREEN}[PASS]${NC} $check"
    else
        echo -e "  ${RED}[FAIL]${NC} $check"
    fi
done

echo ""
if [ "$OVERALL_STATUS" -eq 0 ]; then
    echo -e "${GREEN}════════════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}ALL CHECKS PASSED${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════════════════════════${NC}"
else
    echo -e "${RED}════════════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${RED}VERIFICATION FAILED - See error output above for details${NC}"
    echo -e "${RED}════════════════════════════════════════════════════════════════════════════════${NC}"
fi

exit $OVERALL_STATUS

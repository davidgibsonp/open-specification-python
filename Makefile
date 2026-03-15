.PHONY: setup test test-unit test-integration test-cov lint format type-check pre-commit verify clean help

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: ## Install dependencies and pre-commit hooks
	uv sync
	uv run pre-commit install
	cp -n .env.example .env || true

test: ## Run all tests
	uv run pytest tests/ -v

test-unit: ## Run unit tests only
	uv run pytest tests/unit/ -v -m unit

test-integration: ## Run integration tests only
	uv run pytest tests/integration/ -v -m integration

test-cov: ## Run tests with coverage (fails if below threshold in pyproject.toml)
	uv run pytest tests/ --cov=src/my_project --cov-report=term-missing --cov-fail-under=$$(grep -A10 '\[tool\.coverage\.report\]' pyproject.toml | grep 'fail_under' | head -1 | sed 's/.*=\s*//' | tr -d ' ' || echo 80)

lint: ## Lint with ruff
	uv run ruff check src/ tests/

format: ## Format with ruff
	uv run ruff format src/ tests/

type-check: ## Run mypy type checking
	uv run mypy src/

pre-commit: ## Run all pre-commit hooks
	uv run pre-commit run --all-files

verify: ## Run full verification suite with structured output
	@./scripts/verify.sh

clean: ## Remove build artifacts and caches
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -name "*.pyc" -delete 2>/dev/null || true
	rm -rf .pytest_cache .mypy_cache .ruff_cache htmlcov .coverage build dist

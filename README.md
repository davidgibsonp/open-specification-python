# my-project

<!-- TODO: Project description -->

## Quick Start

```bash
# Prerequisites: Python 3.13+, uv (https://docs.astral.sh/uv/)

# Install
git clone <repo-url>
cd my-project
uv sync

# Configure
cp .env.example .env
# Edit .env with your values

# Install pre-commit hooks
uv run pre-commit install

# Verify
uv run pytest tests/ -v
```

## Development

See [DEVELOPMENT.md](DEVELOPMENT.md) for the full development guide.

See [AGENTS.md](AGENTS.md) for AI assistant instructions.

```bash
make setup    # Install deps + pre-commit + .env
make test     # Run all tests
make lint     # Lint with ruff
make format   # Format with ruff
make pre-commit  # Run all quality checks
```

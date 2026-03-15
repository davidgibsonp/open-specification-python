# Open Specification Template for Python

A GitHub Template Repository for building Python software from a natural language
specification using AI coding agents.

## What is Open Specification?

[Open Specification](https://github.com/davidgibsonp/open-specification) is a
methodology where you write what you want built in plain language, and AI coding
agents implement it. This template provides the infrastructure to make that work.

## Quick Start

1. **Use this template** — click "Use this template" on GitHub (or clone locally)
2. **Rename your project** — run `bash scripts/rename_project.sh your_project_name`
3. **Write your specification** — fill in the four documents in `spec/`:
   - `spec/PRODUCT.md` — what and why
   - `spec/ROADMAP.md` — in what order
   - `spec/ARCHITECTURE.md` — how it's structured
   - `spec/SPECIFICATION.md` — what it must do
4. **Open a Bootstrap Issue** — use the Bootstrap issue template to initialize your project
5. **Assign to an agent** — assign the issue to Copilot, run it with Claude Code, or use your preferred AI coding agent
6. **Review and merge** — the agent opens a PR; you review and merge

See the [Writing Guide](https://github.com/davidgibsonp/open-specification/blob/main/docs/writing-guide.md)
for advice on writing effective specifications.

## What's Included

| Component | Purpose |
|-----------|---------|
| `spec/` | Open Specification documents (PRODUCT.md, ARCHITECTURE.md, SPECIFICATION.md, ROADMAP.md) |
| `OPENSPEC.md` | Runtime methodology governing all work |
| `AGENTS.md` | Agent instructions and project conventions |
| `.github/ISSUE_TEMPLATE/` | Bootstrap, Implementation, Bug Fix, Compound Learning templates |
| `.github/workflows/` | CI/CD (pre-commit checks, release automation) |
| `Makefile` | Verification targets (`test`, `lint`, `format`, `type-check`, `pre-commit`) |
| `src/my_project/` | Python package structure with Pydantic config |
| `tests/` | Unit and integration test infrastructure |
| `docs/` | Compound engineering artifacts (proposals, plans, learnings, decisions) |

## Prerequisites

- Python 3.13+
- [uv](https://docs.astral.sh/uv/) package manager
- GitHub account

## Development

```bash
make setup       # Install deps + pre-commit hooks + .env
make test        # Run all tests
make lint        # Lint with ruff
make format      # Format with ruff
make type-check  # Type check with mypy
make pre-commit  # Run all quality checks
```

See [AGENTS.md](AGENTS.md) for full development conventions and mandatory rules.

## Project Structure

```
.
├── spec/                           # Open Specification documents
│   ├── PRODUCT.md                  # What we're building and why
│   ├── ARCHITECTURE.md             # System structure and design decisions
│   ├── SPECIFICATION.md            # Detailed functional requirements
│   └── ROADMAP.md                  # Phased construction plan
├── src/my_project/   # Python package
│   ├── config.py                   # Pydantic Settings configuration
│   ├── main.py                     # Application entry point
│   ├── models/                     # Domain models (Pydantic)
│   └── services/                   # External integrations and business logic
├── tests/                          # Test suite
│   ├── unit/                       # Fast tests, no external dependencies
│   └── integration/                # Tests requiring external services
├── docs/                           # Compound engineering artifacts
│   ├── learnings/                  # Knowledge captured from development
│   ├── decisions/                  # Architecture Decision Records
│   ├── proposals/                  # Change proposals
│   └── plans/                      # Implementation plans
├── OPENSPEC.md                     # Open Specification runtime methodology
├── AGENTS.md                       # Agent instructions
└── pyproject.toml                  # Project configuration
```

## Methodology

This template implements the [Open Specification](https://github.com/davidgibsonp/open-specification)
standard. Read [OPENSPEC.md](OPENSPEC.md) for the complete runtime protocol that
governs how projects built from this template operate.

## License

MIT

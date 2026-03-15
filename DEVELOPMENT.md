# Development Guide

## Compound Engineering Methodology

This project follows **Compound Engineering** -- a methodology where each
feature cycle compounds learnings, making the next cycle more effective.

```
Research --> Plan --> Implement --> Retro --> Codify
    |          |          |           |          |
    v          v          v           v          v
 proposal     plan        PR        retro    learnings
  (git)      (git)    (GitHub)      (git)      (git)

                    <-- Learnings feed back -->
```

### Artifacts

| Artifact | Location | When |
|----------|----------|------|
| Proposal | `docs/proposals/NNN-title.md` | New features, refactors, architecture changes (>1 day) |
| Plan | `docs/plans/NNN-title.md` | Complex implementations (>3 tasks) |
| Retro | `docs/learnings/by-issue/NNN-retro.md` | After completing proposals |
| Pattern | `docs/learnings/patterns/` | When a reusable pattern emerges |
| Decision | `docs/decisions/NNN-title.md` | Significant architectural choices |

### When to Skip

Bug fixes, typo corrections, dependency bumps, and changes taking < 1 hour
can skip the full process. Use a standard PR with a clear description.

## Setup

```bash
git clone <repo-url>
cd openspec-python-template
make setup
```

## Daily Development

```bash
make test          # Run all tests
make pre-commit    # Check everything before committing
make format        # Format code
make type-check    # Run mypy
make help          # Show all available targets
```

## Principles

1. **Code is canonical truth** -- documentation explains why, not what
2. **Single source of truth** -- no duplication
3. **Verifiable independent of production** -- local testability
4. **Configuration is not code** -- use config files + env vars
5. **One canonical pattern per problem** -- consistency over local optimization
6. **Examples over abstractions** -- golden examples for agents to replicate
7. **Human review at leverage points** -- review plans before code
8. **AI agents = junior engineers with perfect memory, no judgment** -- be explicit

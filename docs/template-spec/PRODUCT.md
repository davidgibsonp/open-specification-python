# Product Specification

**Project:** Open Specification Template for Python
**Version:** 0.1.0
**Last Updated:** 2026-03-14

---

## Problem

Building production software with AI coding agents today requires significant upfront
investment in infrastructure: CI/CD pipelines, linter and type checker configuration,
test frameworks, agent instruction files, issue templates, verification scripts, and
development conventions. Every new project starts from scratch or from ad-hoc templates
that weren't designed for agent-driven development.

The result is that the promise of "describe what you want and agents build it" falls
apart at the operational level. Developers spend more time configuring the harness than
they would have spent writing the code. Non-technical product thinkers who could define
excellent specifications can't participate because the infrastructure barrier is too high.

Meanwhile, the emerging Spec-Driven Development ecosystem (GitHub Spec Kit, BMAD-METHOD,
compound engineering) provides methodology and tooling but not a ready-to-use project
foundation. You get workflows without a workspace.

## Solution

A GitHub Template Repository that provides everything needed to build production Python
software from a natural language specification. The human clones the template, writes
four specification documents describing their product, opens a Bootstrap Issue, and
begins delegating all implementation work to AI coding agents through GitHub Issues.

The template includes:

- The Open Specification runtime methodology (OPENSPEC.md)
- A complete Python development harness (linting, type checking, testing, formatting)
- CI/CD workflows that verify agent work automatically
- Structured Issue templates that bridge human intent and agent execution
- Agent instruction defaults following compound engineering patterns
- A `spec/` directory with guided placeholders for the four specification documents
- A docs structure for capturing learnings that compound over time

The human's ongoing interaction with the codebase is exclusively through GitHub:
writing and updating specifications, opening Issues, and reviewing Pull Requests
at the outcome level.

## Target Users

### Primary: The Harness Engineer

A developer or technical product person who wants to build Python software by
defining *what* to build rather than *how* to build it. They understand software
architecture well enough to write specifications but want to delegate all
implementation to AI agents. They are comfortable with GitHub (Issues, PRs, reviews)
but want to minimize time in IDEs and terminals.

Characteristics:
- Can write clear product requirements and architectural descriptions
- Understands Python ecosystem well enough to make technology choices in specs
- Uses GitHub as their primary interface for managing development
- Works with one or more AI coding agents (Claude Code, Copilot, Codex, Cursor, etc.)
- Values compound engineering — each unit of work making the next one easier

### Secondary: The Product Thinker

A non-developer with strong product sense who can define specifications with AI
assistance (e.g., co-authoring specs in Claude, ChatGPT, or similar). They rely
entirely on the template's infrastructure and agent capabilities for implementation.
They need the template to "just work" without understanding the underlying tooling.

Characteristics:
- Strong product vision and ability to define requirements in natural language
- Limited or no Python development experience
- Needs clear guidance on what to write and where
- Reviews outcomes visually or through acceptance criteria, not code
- May need AI assistance to write the specification documents themselves

## Success Criteria

### For the Template Itself

1. **Time to first Issue**: A user can go from "I have an idea" to "I've opened
   the Bootstrap Issue" in under 2 hours, with most of that time spent writing
   the specification — not configuring infrastructure.

2. **Zero-configuration harness**: After cloning the template, all CI/CD,
   linting, type checking, and testing works without any manual setup beyond
   writing the spec and opening Issues.

3. **Agent-agnostic operation**: The template works with any AI coding agent
   that can read files, write files, run shell commands, and open Pull Requests.
   No agent-specific configuration is required for core functionality.

4. **Compound knowledge growth**: After 10 completed Issues, the `docs/learnings/`
   directory contains reusable patterns and the AGENTS.md file has been refined
   with project-specific conventions, making each subsequent Issue easier to
   implement.

5. **Human reviews outcomes, not code**: CI/CD catches all code quality issues
   (lint, types, tests, formatting) before the human sees a PR. The human's
   review is about intent alignment: "Does this match what I specified?"

### For Projects Built From the Template

1. **Production-grade defaults**: Code produced through the template's harness
   meets professional standards — type-checked, linted, tested, formatted
   consistently — without the human enforcing these standards manually.

2. **Specification as source of truth**: At any point, reading the `spec/`
   directory tells you what the product is, and the code is a faithful
   implementation of that specification.

3. **Portable methodology**: A project initialized from this template follows
   the OPENSPEC.md runtime, meaning anyone familiar with the Open Specification
   standard can understand the project's development process immediately.

## What This Is NOT

- **Not an AI coding agent.** The template provides the environment where agents
  work. It does not include or depend on any specific agent.

- **Not a framework or library.** Projects built from this template are
  standalone Python applications. The template provides scaffolding that is
  adapted during bootstrap, not a runtime dependency.

- **Not a low-code/no-code platform.** The specification must describe a
  buildable software product. The template doesn't generate UIs from descriptions
  or abstract away programming concepts — it provides the harness for agents
  that write real code.

- **Not a project management tool.** GitHub Issues and PRs are the coordination
  mechanism. The template doesn't replace Linear, Jira, or other project
  management — it uses GitHub's native capabilities.

- **Not language-agnostic.** This template is for Python. The Open Specification
  standard is language-agnostic, and future templates will support other
  languages, but this template's harness is Python-specific.

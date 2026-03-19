# Learning: GitHub Issue Template Labels Must Pre-Exist

**Source:** Issue #5 (Bootstrap), Issue #19, Issue #20

## Context

During the bootstrap of this project (Issue #5, PR #6), the agent successfully
followed all steps in OPENSPEC.md Section 4.2. However, when issues were later
created using the issue templates, the labels specified in template YAML were
not applied.

## Root Cause

GitHub does **not** auto-create labels from issue template YAML files. The
`labels:` field in template frontmatter only **applies** labels that already
exist in the repository — it does not create them.

```yaml
# .github/ISSUE_TEMPLATE/implementation.yml
labels: ["implementation"]  # Only works if "implementation" label exists
```

When a label doesn't exist:
- GitHub silently ignores it
- The issue is created without the label
- No error message is shown

## Impact

- Bootstrap issue #5 was created with `labels: []` despite template specifying
  `["bootstrap", "phase-0"]`
- Issues created via templates had missing labels until labels were manually
  created

## Resolution

1. OPENSPEC.md Section 4.2 updated to include label creation as an explicit
   bootstrap step
2. Bootstrap issue template acceptance criteria now includes label verification
3. All labels referenced by templates (`bootstrap`, `phase-0`, `compound`,
   `implementation`, `bug`) must be created during bootstrap

## Pattern: Always Create Labels Before Using Them

When setting up issue templates with labels:
1. Extract all unique labels from `.github/ISSUE_TEMPLATE/*.yml` files
2. Create each label in the repository via `gh label create` or the GitHub UI
3. Verify labels exist before opening issues via templates

## Labels Referenced by This Project's Templates

| Template | Labels |
|----------|--------|
| `bootstrap.yml` | `bootstrap`, `phase-0` |
| `bug-fix.yml` | `bug` |
| `compound-learning.yml` | `compound` |
| `implementation.yml` | `implementation` |

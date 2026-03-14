# Rule 01 — Single Source of Truth

## Core Principle

Maintain one authoritative location for all project planning, decisions, and status. Never duplicate critical information.

## Quick Rules

- One `SSOT.md` or `PROJECT_PLAN.md` per project
- All teams reference the same source
- Update immediately when decisions change
- Link to SSOT, don't copy from it

## Required Components

```markdown
# Project: [Name]

## Current Status
[Active | On Hold | Completed]

## Objectives
1. [Primary goal]
2. [Secondary goal]

## Architecture Decisions
- [Decision 1]: [Rationale]
- [Decision 2]: [Rationale]

## Active Work
| Team | Task | Status |
|------|------|--------|
| TEAM_001 | Feature X | In Progress |

## Completed Work
- [Date]: [What was completed]
```

## Examples

✅ **Good**: Reference the source
```markdown
See SSOT.md#architecture-decisions for the database choice rationale.
```

❌ **Bad**: Duplicate information
```markdown
We chose PostgreSQL because... [copies entire decision from SSOT]
```

## Checklist

- [ ] SSOT exists and is current
- [ ] All decisions are recorded with rationale
- [ ] No conflicting information exists elsewhere

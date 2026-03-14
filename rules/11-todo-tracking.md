# Rule 11 — TODO Tracking

## Core Principle

Every TODO must have a team ID and be tracked. Anonymous TODOs are not allowed.

## TODO Format Requirements

### Required Format

```typescript
// TODO(TEAM_XXX): [Description of what needs to be done]
// Context: [Why this TODO exists]
// Priority: [critical | high | medium | low]
```

### Examples

```typescript
// TODO(TEAM_001): Add retry logic for network failures
// Context: Payment API occasionally times out under load
// Priority: high

// TODO(TEAM_003): Refactor this function to use async/await
// Context: Current callback style is hard to maintain
// Priority: medium

// TODO(TEAM_005): Add input validation for email field
// Context: Security review identified missing validation
// Priority: critical
```

## Forbidden Patterns

### ❌ Anonymous TODOs

```typescript
// DON'T: No team ID
// TODO: fix this later
// TODO fix the bug
// TODO - add validation
```

### ❌ Vague TODOs

```typescript
// DON'T: No context or specificity
// TODO(TEAM_001): fix this
// TODO(TEAM_001): make it better
// TODO(TEAM_001): clean up
```

### ❌ FIXME Without Context

```typescript
// DON'T: FIXME without explanation
// FIXME: broken
// FIXME
```

## TODO Categories

### Implementation TODOs

```typescript
// TODO(TEAM_001): Implement password strength validation
// Context: Security requirement from compliance team
// Priority: high
// Acceptance: Min 8 chars, 1 uppercase, 1 number, 1 special
function validatePassword(password: string): boolean {
  return password.length >= 8; // Incomplete implementation
}
```

### Refactoring TODOs

```typescript
// TODO(TEAM_002): Extract duplicate code into shared utility
// Context: Same logic exists in checkout.ts and cart.ts
// Priority: medium
// Files: src/checkout.ts:45, src/cart.ts:78
function calculateDiscount(items: Item[]): number {
  // Duplicated logic here
}
```

### Performance TODOs

```typescript
// TODO(TEAM_003): Add caching for frequently accessed data
// Context: Database queries are slow for user preferences
// Priority: medium
// Metric: Current p95 latency is 500ms, target is 100ms
async function getUserPreferences(userId: string) {
  return await db.preferences.findOne({ userId });
}
```

### Security TODOs

```typescript
// TODO(TEAM_004): Add rate limiting to prevent brute force
// Context: Security audit finding #SEC-2024-001
// Priority: critical
// Deadline: Before next release
async function login(username: string, password: string) {
  // No rate limiting currently
}
```

## TODO Tracking System

### Central TODO Registry

Maintain a `.todos/` directory with tracking files:

```
.todos/
├── open/
│   ├── TEAM_001_payment-retry.md
│   ├── TEAM_003_async-refactor.md
│   └── TEAM_004_rate-limiting.md
├── completed/
│   └── TEAM_002_validation-fix.md
└── registry.json
```

### TODO Registry Format

```json
{
  "todos": [
    {
      "id": "TODO_001",
      "team": "TEAM_001",
      "file": "src/payment/processor.ts",
      "line": 45,
      "description": "Add retry logic for network failures",
      "priority": "high",
      "created": "2024-01-15",
      "status": "open"
    }
  ]
}
```

### TODO File Template

```markdown
# TODO: [Brief Description]

## Metadata
- **ID**: TODO_XXX
- **Team**: TEAM_XXX
- **Created**: [Date]
- **Priority**: [critical | high | medium | low]
- **Status**: [open | in-progress | completed | deferred]

## Location
- **File**: [path/to/file.ts]
- **Line**: [line number]
- **Function**: [function name if applicable]

## Description
[Detailed description of what needs to be done]

## Context
[Why this TODO exists, background information]

## Acceptance Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

## Notes
[Any additional notes or considerations]

## Resolution
- **Completed By**: [Team ID]
- **Date**: [Date]
- **Commit**: [Commit hash]
- **Notes**: [How it was resolved]
```

## TODO Lifecycle

### Creation

1. **Add TODO comment** in code with team ID
2. **Create tracking file** in `.todos/open/`
3. **Update registry** with new TODO
4. **Link in team file** for visibility

### Progress

1. **Update status** when work begins
2. **Add notes** about approach or blockers
3. **Update team file** with progress

### Completion

1. **Remove TODO comment** from code
2. **Move tracking file** to `.todos/completed/`
3. **Update registry** with completion info
4. **Document resolution** in tracking file

## Automated TODO Scanning

### Pre-Commit Hook

```bash
#!/bin/bash
# .git/hooks/pre-commit

# Check for anonymous TODOs
if grep -rn "// TODO[^(]" --include="*.ts" --include="*.js" .; then
  echo "ERROR: Anonymous TODOs found. Use format: // TODO(TEAM_XXX): description"
  exit 1
fi

# Check for TODOs without team ID
if grep -rn "// TODO:" --include="*.ts" --include="*.js" . | grep -v "TODO(TEAM_"; then
  echo "ERROR: TODOs must include team ID"
  exit 1
fi
```

### CI/CD Check

```yaml
# .github/workflows/todo-check.yml
name: TODO Check
on: [push, pull_request]

jobs:
  check-todos:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Check for anonymous TODOs
        run: |
          if grep -rn "// TODO[^(]" --include="*.ts" --include="*.js" .; then
            echo "Anonymous TODOs found"
            exit 1
          fi
```

### TODO Report Generation

```bash
#!/bin/bash
# scripts/todo-report.sh

echo "# TODO Report - $(date)"
echo ""
echo "## Open TODOs by Priority"
echo ""
echo "### Critical"
grep -rn "Priority: critical" .todos/open/ || echo "None"
echo ""
echo "### High"
grep -rn "Priority: high" .todos/open/ || echo "None"
echo ""
echo "### Medium"
grep -rn "Priority: medium" .todos/open/ || echo "None"
echo ""
echo "### Low"
grep -rn "Priority: low" .todos/open/ || echo "None"
```

## TODO Review Process

### Weekly Review

1. **List all open TODOs** by priority
2. **Identify stale TODOs** (> 30 days old)
3. **Reassess priorities** based on current needs
4. **Assign to upcoming work** or defer explicitly

### Sprint Planning

1. **Include critical TODOs** in sprint backlog
2. **Estimate effort** for each TODO
3. **Assign to team members** for resolution
4. **Track completion** in sprint metrics

## Quality Checklist

### Creating TODOs

- [ ] **Team ID included** - Format: TODO(TEAM_XXX)
- [ ] **Description is specific** - Clear what needs to be done
- [ ] **Context provided** - Why this TODO exists
- [ ] **Priority assigned** - critical/high/medium/low
- [ ] **Tracking file created** - In `.todos/open/`

### Completing TODOs

- [ ] **Code TODO removed** - No orphan comments
- [ ] **Tracking file updated** - Resolution documented
- [ ] **Registry updated** - Status changed to completed
- [ ] **Team file updated** - Completion noted

---

## Remember

**A TODO without a team ID is a TODO that will never be done. Track everything.**

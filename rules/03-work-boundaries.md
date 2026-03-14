# Rule 03 — Work Boundaries

## Core Principle

Complete the pre-work checklist before coding. Maximize progress while context is fresh. Complete handoff before ending.

## Before Starting Work

### Pre-Work Checklist

- [ ] Read SSOT and understand current project state
- [ ] Review previous team's handoff notes
- [ ] Identify what needs to be done
- [ ] Check for existing patterns to follow
- [ ] Understand the testing requirements

### Questions to Answer First

1. What is the specific goal of this session?
2. What files/components will be affected?
3. Are there any blockers or unknowns?
4. What does "done" look like?

## During Work

### Maximize Context Window

While you still remember the state:

- Complete logical units of work, don't stop mid-task
- Handle related changes together
- Document decisions as you make them
- Update progress in team file

### Stay Focused

- One objective at a time
- Don't start new features before finishing current ones
- If blocked, document and move to next priority

## Before Finishing

### Handoff Checklist

- [ ] Code compiles/runs without errors
- [ ] Tests pass (existing + new)
- [ ] Changes documented in team file
- [ ] SSOT updated if needed
- [ ] Clear notes for next session

### Handoff Notes Template

```markdown
## Session Summary
[What was accomplished]

## Current State
[Where things stand now]

## Next Steps
1. [Immediate next task]
2. [Following task]

## Watch Out For
[Any gotchas or concerns]
```

## Examples

✅ **Good**: Clear handoff
```markdown
## Session Summary
Implemented user authentication with JWT tokens.

## Current State
- Login/logout working
- Token refresh NOT implemented yet
- Tests passing

## Next Steps
1. Add token refresh logic
2. Add password reset flow

## Watch Out For
- Token expiry is set to 1 hour for testing, change to 15 min for prod
```

❌ **Bad**: Incomplete handoff
```markdown
Did some auth stuff. Mostly works.
```

## Checklist

- [ ] Pre-work checklist completed before coding
- [ ] Progress tracked during session
- [ ] Handoff notes written before ending
- [ ] Next session can continue without re-reading everything

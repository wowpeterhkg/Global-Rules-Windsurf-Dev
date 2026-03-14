# Rule 02 — Team Workflow

## Core Principle

Every AI conversation is a "team" with a unique ID. Track work for continuity and accountability.

## Quick Rules

- Each conversation gets a unique Team ID (TEAM_001, TEAM_002, etc.)
- Create a team file at session start
- Update team file with progress and decisions
- Complete handoff notes before ending

## Team File Template

```markdown
# TEAM_XXX — [Brief Summary]

## Info
- **Started**: [Date/Time]
- **User**: [Name]
- **Status**: [Active | Completed | Blocked]

## Objective
[What this session aims to accomplish]

## Progress
- [x] Completed item
- [ ] Pending item

## Decisions Made
- [Decision]: [Reasoning]

## Handoff Notes
[Context for next session]
```

## Solo Developer Mode

For single-person projects, simplify the workflow:

### Skip
- Team ID prefixes (use dates instead)
- User registration
- Handoff documentation (you're continuing your own work)

### Keep
- SSOT for project planning
- Progress tracking (helps you remember)
- Decision logging (future you will thank you)

### Simplified Format
```markdown
# Session — [Date] — [Summary]

## Done
- [What was completed]

## Next
- [What to do next]

## Notes
- [Important context to remember]
```

## Checklist

- [ ] Team file created at session start
- [ ] Progress updated during work
- [ ] Decisions documented with reasoning
- [ ] Handoff notes complete before ending

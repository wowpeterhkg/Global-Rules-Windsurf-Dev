# Rule 12 — Universal Quick Reference

## Core Principle

This is the at-a-glance reference for all rules. Use this for quick lookups during development.

## Rule Summary Table

| Rule | Name | One-Line Summary |
|------|------|------------------|
| 0 | Quality Over Speed | Architectural excellence over quick fixes |
| 1 | Single Source of Truth | One location for all project planning |
| 2 | Team Registration | Every conversation = one team with permanent ID |
| 3 | Before Starting Work | Complete pre-work checklist before coding |
| 4 | Regression Protection | Baseline tests for critical behavior |
| 5 | Breaking Changes | Clean breaks over compatibility hacks |
| 6 | No Dead Code | Remove everything that isn't used |
| 7 | Modular Refactoring | Split large modules by responsibility |
| 8 | Ask Questions Early | Never guess on major decisions |
| 9 | Maximize Context | Do all aligned work while context is fresh |
| 10 | Before Finishing | Complete handoff checklist before stopping |
| 11 | TODO Tracking | Every TODO needs team ID and tracking |
| 12 | Quick Reference | This document |
| 13 | Communication | Clear, direct, actionable communication |
| 14 | Code Generation | Runnable code with all dependencies |
| 15 | Security Standards | Enterprise-grade security practices |
| 16 | Error Handling | Fail-secure, structured logging |
| 17 | Tool Usage | Strategic tool selection |
| 18 | Architecture | Truthseeker principles, prove don't assume |
| 19 | Dependency Management | Well-maintained packages only |
| 20 | Code Review | Security-focused review checklist |
| 21 | Testing Standards | Minimal mocking, explicit synchronization |
| 22 | Development Workflow | Version control, semantic versioning |
| 23 | Frontend Errors | Error boundaries, graceful degradation |
| 24 | Async Events | Never use time for synchronization |

## Quick Decision Trees

### Before Starting Any Work

```
1. Do I have a Team ID? 
   NO → Create team file (Rule 2)
   YES ↓

2. Have I read the SSOT?
   NO → Review project plan (Rule 1)
   YES ↓

3. Is there ambiguity?
   YES → Ask questions first (Rule 8)
   NO ↓

4. Pre-work checklist complete?
   NO → Complete checklist (Rule 3)
   YES → Start work
```

### Before Writing Code

```
1. Will this break existing behavior?
   YES → Document baseline first (Rule 4)
   NO ↓

2. Am I adding to a large file?
   YES → Consider splitting (Rule 7)
   NO ↓

3. Is there dead code to remove?
   YES → Remove it (Rule 6)
   NO ↓

4. Security implications?
   YES → Follow security standards (Rule 15)
   NO → Write code
```

### Before Finishing Work

```
1. Does it build cleanly?
   NO → Fix build errors
   YES ↓

2. Do all tests pass?
   NO → Fix failing tests
   YES ↓

3. Any anonymous TODOs?
   YES → Add team IDs (Rule 11)
   NO ↓

4. Handoff notes complete?
   NO → Write handoff notes (Rule 10)
   YES → Work complete
```

## Common Patterns

### Team File Creation

```markdown
# TEAM_XXX_<user-id>_<summary>

## Team Information
- **Team ID**: TEAM_XXX
- **User ID**: <user-id>
- **User Full Name**: [Name]
- **Started**: [Date/Time]

## Progress Log
### [Date] - Session Start
- **Objective**: [Goal]
- **Initial Assessment**: [State]
```

### TODO Format

```typescript
// TODO(TEAM_XXX): [Description]
// Context: [Why]
// Priority: [critical|high|medium|low]
```

### Question File

```markdown
# Question: [Title]

## Context
[Background]

## Question
[Specific question]

## Options
1. Option A - Pros/Cons
2. Option B - Pros/Cons
```

### Baseline Test

```typescript
describe('Critical Behavior Baseline', () => {
  it('should [expected behavior]', () => {
    const result = functionUnderTest(input);
    expect(result).toMatchSnapshot();
  });
});
```

## Security Quick Checks

| Check | Rule |
|-------|------|
| Parameterized queries? | Always use $1, $2 placeholders |
| Input validation? | Validate all user inputs |
| Error messages? | Never expose internal details |
| Secrets hardcoded? | Never in source code |
| Logging sensitive data? | Never log passwords/tokens |

## Code Quality Quick Checks

| Check | Standard |
|-------|----------|
| File size | < 500 lines preferred |
| Function size | < 50 lines preferred |
| Public methods | < 10 per class preferred |
| Test coverage | Maintain existing level |
| Dead code | None allowed |

## Communication Quick Reference

### Response Style

- **Be direct** - No filler phrases
- **Be specific** - Concrete details
- **Be actionable** - Clear next steps

### Status Updates

```markdown
## Status: [Feature Name]
- **Progress**: X% complete
- **Completed**: [Items done]
- **Remaining**: [Items left]
- **Blockers**: [Issues]
- **ETA**: [Estimate]
```

### Error Reports

```markdown
## Error: [Brief Description]
- **Location**: [File:Line]
- **Reproduction**: [Steps]
- **Expected**: [Behavior]
- **Actual**: [Behavior]
- **Impact**: [Severity]
```

## Workflow Commands

| Command | Purpose |
|---------|---------|
| `/team-init` | Create new team |
| `/team-status` | Show current team info |
| `/handoff` | Complete team handoff |
| `/baseline` | Create regression baseline |
| `/plan` | Analyze before implementing |

## File Locations

| Item | Location |
|------|----------|
| Team files | `.teams/TEAM_XXX_*.md` |
| User profiles | `.users/USER_*.md` |
| Questions | `.questions/open/*.md` |
| TODOs | `.todos/open/*.md` |
| Baselines | `.baselines/*.md` |
| Project plan | `SSOT.md` or `PROJECT_PLAN.md` |

## Emergency Procedures

### Build Broken

1. Check recent commits
2. Run `git bisect` to find breaking change
3. Fix or revert
4. Document in team file

### Tests Failing

1. Identify which tests fail
2. Check if behavior change is intentional
3. Update tests or fix code
4. Document decision

### Security Issue Found

1. **Do not commit** vulnerable code
2. Document in `.questions/` as critical
3. Notify team lead immediately
4. Follow security incident process

---

## Remember

**When in doubt, check the specific rule. This is just the quick reference.**

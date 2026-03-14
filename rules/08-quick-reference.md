# Rule 08 — Quick Reference

## Core Principle

This is the at-a-glance reference for all rules. Use for quick lookups during development.

## Rule Summary

| # | Rule | Core Principle |
|---|------|----------------|
| 00 | Quality Over Speed | Correct path, never shortcuts |
| 01 | Single Source of Truth | One location for all planning |
| 02 | Team Workflow | Track conversations, enable handoffs (+ Solo Mode) |
| 03 | Work Boundaries | Pre-work → Work → Handoff |
| 04 | Regression Protection | Baseline before changing |
| 05 | Breaking Changes | Clean breaks over compatibility hacks |
| 06 | Code Cleanliness | No dead code, tracked TODOs |
| 07 | Ask Questions Early | Never guess on major decisions |
| 08 | Quick Reference | This summary |
| 09 | Communication | Clear, direct, actionable |
| 10 | Code Generation | Runnable code with all deps |
| 11 | Security | Parameterized queries, validate inputs |
| 12 | Error Handling | Fail-secure, structured logging |
| 13 | Tool Usage | Strategic tool selection |
| 14 | Architecture | Prove, don't assume (Truthseeker) |
| 15 | Dependencies | Well-maintained packages only |
| 16 | Code Review | Security-focused reviews |
| 17 | Testing | Minimal mocking, explicit sync |
| 18 | Dev Workflow | Version control, semantic versioning |
| 19 | Async Events | Never time-based synchronization |
| 20 | Infrastructure | Docker, PostgreSQL/Redis/LevelDB |
| 21 | Documentation | docs/ folder with standard structure |

## Quick Decision Trees

### Before Starting
```
1. Read SSOT? → No → Read it first
2. Previous handoff notes? → No → Find them
3. Clear objective? → No → Ask questions
4. Ready to code? → Yes → Proceed
```

### Before Committing
```
1. Tests pass? → No → Fix them
2. Dead code removed? → No → Remove it
3. TODOs tracked? → No → Add context
4. Ready to commit? → Yes → Commit
```

### Before Finishing Session
```
1. Code compiles? → No → Fix it
2. Handoff notes written? → No → Write them
3. SSOT updated? → No → Update it
4. Ready to end? → Yes → End session
```

## Security Quick Check

- [ ] No hardcoded secrets
- [ ] Inputs validated
- [ ] Queries parameterized
- [ ] Errors don't leak info
- [ ] Auth/authz checked

## Code Quality Quick Check

- [ ] Functions < 50 lines
- [ ] Files < 300 lines
- [ ] No dead code
- [ ] TODOs have context
- [ ] Tests exist

## Common Commands

```bash
# Run tests
npm test / pytest / go test ./...

# Check for issues
npm run lint / flake8 / golangci-lint run

# Format code
npm run format / black . / gofmt -w .
```

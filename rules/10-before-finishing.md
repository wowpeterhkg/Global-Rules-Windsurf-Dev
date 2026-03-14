# Rule 10 — Before Finishing

## Core Principle

Every team must complete the handoff checklist before finishing. No exceptions.

## Mandatory Handoff Checklist

Before marking any work as complete, verify ALL items:

```markdown
## Handoff Checklist

### Build & Tests
- [ ] Project builds cleanly (no errors or warnings)
- [ ] All unit tests pass
- [ ] All integration tests pass
- [ ] Behavioral regression tests pass (if applicable)
- [ ] No new linting errors introduced

### Documentation
- [ ] Team file updated with final progress
- [ ] Code comments added for complex logic
- [ ] API documentation updated (if applicable)
- [ ] README updated (if applicable)

### Cleanup
- [ ] No debug code left behind
- [ ] No console.log/print statements (unless intentional)
- [ ] No commented-out code
- [ ] No TODO comments without team ID

### Handoff
- [ ] Remaining problems documented
- [ ] Blockers clearly identified
- [ ] Next steps defined
- [ ] Handoff notes written
```

## Team File Final Update

### Required Sections

```markdown
# TEAM_XXX_<user-id>_<summary>

## Final Status
- **Completion**: [Complete | Partial | Blocked]
- **Date**: [Date/Time]
- **Duration**: [Total time spent]

## Work Completed
- [Specific item 1 completed]
- [Specific item 2 completed]
- [Specific item 3 completed]

## Work Remaining
- [Item 1 not completed - reason]
- [Item 2 not completed - reason]

## Known Issues
- [Issue 1 - severity and impact]
- [Issue 2 - severity and impact]

## Blockers
- [Blocker 1 - what's needed to unblock]
- [Blocker 2 - what's needed to unblock]

## Handoff Notes
### For Next Team
[Detailed context for whoever continues this work]

### Key Files Modified
- `path/to/file1.ts` - [what was changed]
- `path/to/file2.ts` - [what was changed]

### Important Decisions
- [Decision 1 and reasoning]
- [Decision 2 and reasoning]

### Warnings
- [Any gotchas or things to watch out for]
```

## Build Verification

### Required Checks

```bash
# 1. Clean build
npm run build
# or
go build ./...
# or
python -m py_compile *.py

# 2. All tests pass
npm test
# or
go test ./...
# or
pytest

# 3. Linting passes
npm run lint
# or
golangci-lint run
# or
flake8 .

# 4. Type checking (if applicable)
npm run typecheck
# or
mypy .
```

### If Tests Fail

```markdown
## Test Failure Documentation

### Failing Tests
1. `test_user_authentication` - Timeout on CI, passes locally
2. `test_payment_processing` - Flaky, fails 1 in 10 runs

### Analysis
- Test 1: Likely CI environment issue, not code problem
- Test 2: Race condition in async code, needs investigation

### Recommendation
- Test 1: Add retry logic or increase timeout
- Test 2: Needs proper async synchronization (see Rule 24)

### Temporary Mitigation
Tests are skipped with `@skip` annotation and TODO comment.
Must be fixed before next release.
```

## Documentation Requirements

### Code Comments

```typescript
// TEAM_001: Added rate limiting to prevent abuse
// Limit: 100 requests per minute per user
// See .questions/TEAM_001_rate-limiting.md for discussion
const rateLimiter = new RateLimiter({
  windowMs: 60 * 1000,
  max: 100,
  keyGenerator: (req) => req.user.id,
});
```

### API Documentation

```typescript
/**
 * Process a payment for an order.
 * 
 * @param orderId - The unique order identifier
 * @param paymentMethod - Payment method details
 * @returns Payment result with transaction ID
 * @throws PaymentDeclinedError if card is declined
 * @throws InsufficientFundsError if balance is too low
 * 
 * @example
 * const result = await processPayment('order-123', {
 *   type: 'card',
 *   token: 'tok_visa'
 * });
 * 
 * @since TEAM_001 - 2024-01-15
 */
async function processPayment(
  orderId: string, 
  paymentMethod: PaymentMethod
): Promise<PaymentResult> {
  // ...
}
```

## Cleanup Requirements

### Debug Code Removal

```typescript
// REMOVE before finishing:
console.log('DEBUG: user data', userData);
debugger;
alert('test');

// KEEP only if intentional:
logger.debug('Processing order', { orderId }); // Structured logging is OK
```

### TODO Comments

```typescript
// BAD: Anonymous TODO
// TODO: fix this later

// GOOD: TODO with team ID and context
// TODO(TEAM_001): Add retry logic for network failures
// See .questions/TEAM_001_retry-strategy.md for requirements
```

## Handoff Notes Best Practices

### Good Handoff Notes

```markdown
## Handoff Notes - TEAM_001

### Quick Summary
Implemented user authentication with JWT tokens. Login and registration 
work. Password reset is 50% complete - email sending works, reset link 
handling needs implementation.

### Current State
- **Working**: Login, registration, session management
- **Partial**: Password reset (email sends, link handling TODO)
- **Not Started**: Two-factor authentication

### Immediate Next Steps
1. Implement password reset link handler in `auth/reset.ts`
2. Add password validation (min 8 chars, complexity rules)
3. Write integration tests for reset flow

### Key Context
- Using JWT with RS256 algorithm (keys in `config/keys/`)
- Tokens expire in 24 hours, refresh tokens in 7 days
- Email templates are in `templates/email/`

### Watch Out For
- The `verifyToken` function throws on expired tokens - catch it!
- Email sending is async - don't await in request handler
- Rate limiting is applied to login endpoint (5 attempts/minute)

### Files to Review
1. `src/auth/jwt.ts` - Token generation and verification
2. `src/auth/routes.ts` - API endpoints
3. `tests/auth/` - Existing tests to extend
```

### Bad Handoff Notes

```markdown
## Handoff Notes
Did some auth stuff. Check the code.
```

## Quality Gates

### Minimum Requirements

| Requirement | Must Pass |
|-------------|-----------|
| Build succeeds | ✅ Yes |
| All tests pass | ✅ Yes |
| No linting errors | ✅ Yes |
| Team file updated | ✅ Yes |
| Handoff notes written | ✅ Yes |

### Recommended Requirements

| Requirement | Should Pass |
|-------------|-------------|
| Code coverage maintained | ⚠️ Recommended |
| Performance benchmarks pass | ⚠️ Recommended |
| Security scan passes | ⚠️ Recommended |
| Documentation complete | ⚠️ Recommended |

## Partial Completion

### When Work is Incomplete

If you cannot complete all planned work:

1. **Document what's done** - Be specific about completed items
2. **Document what's remaining** - Clear list of TODO items
3. **Explain why** - Blockers, time constraints, scope changes
4. **Provide estimates** - How much work remains
5. **Suggest next steps** - Prioritized list for next team

### Partial Completion Template

```markdown
## Partial Completion Report

### Planned vs Actual
| Item | Planned | Actual | Notes |
|------|---------|--------|-------|
| Login flow | Complete | Complete | ✅ |
| Registration | Complete | Complete | ✅ |
| Password reset | Complete | 50% | Email works, link handling TODO |
| 2FA | Complete | Not started | Deprioritized |

### Reason for Partial Completion
Password reset took longer than expected due to email 
deliverability issues. Had to implement retry logic and 
add monitoring. 2FA was deprioritized by product owner.

### Estimated Remaining Work
- Password reset completion: ~2 hours
- 2FA implementation: ~8 hours

### Recommended Priority
1. Complete password reset (blocking user stories)
2. 2FA can wait for next sprint
```

---

## Remember

**A clean handoff is a gift to your future teammates. Leave the codebase better than you found it.**

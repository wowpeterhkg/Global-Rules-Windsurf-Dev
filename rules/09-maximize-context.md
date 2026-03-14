# Rule 9 — Maximize Context Window

## Core Principle

While you still remember the state, perform as much aligned work as possible. Don't stop mid-task if more progress is obvious. Minimize context re-initialization for next teams.

## Context Window Optimization

### Why This Matters

- **AI context is limited** - Each conversation has finite memory
- **Context switching is expensive** - Re-establishing understanding takes time
- **Momentum is valuable** - Progress compounds when context is fresh
- **Handoffs lose information** - Some nuance is always lost between teams

### Maximize Progress Per Session

```markdown
## Good Session Flow

1. ✅ Understand the full scope of work
2. ✅ Complete all related tasks while context is fresh
3. ✅ Document decisions and reasoning thoroughly
4. ✅ Leave clear handoff notes for next team
5. ✅ Don't stop arbitrarily mid-task

## Bad Session Flow

1. ❌ Start task
2. ❌ Stop after first subtask "to check in"
3. ❌ Lose context between sessions
4. ❌ Re-explain everything to next team
5. ❌ Repeat understanding phase
```

## Task Continuation Guidelines

### When to Continue

- **More obvious work exists** - Next steps are clear
- **Context is still fresh** - You remember the details
- **Work is aligned** - Additional tasks serve the same goal
- **No blocking questions** - Can proceed without answers
- **User hasn't redirected** - Original goal still applies

### When to Stop

- **Blocking question arises** - Need user input to proceed
- **Scope changes** - User wants something different
- **Natural completion point** - Logical milestone reached
- **Task grows too large** - Need to split into sub-tasks
- **Error requires investigation** - Unexpected problem needs analysis

## Sub-Task Management

### When Task Grows Too Large

If a task expands beyond what can be completed in one session:

1. **Split into sub-tasks** within your team directory
2. **Document the split** with clear boundaries
3. **Complete what you can** in current session
4. **Prepare handoff** for remaining sub-tasks

### Sub-Task Documentation

```markdown
## Task Split: Implement User Authentication

### Original Scope
Full authentication system with login, registration, password reset, and session management.

### Sub-Tasks Created
1. **TEAM_001_auth-login** - Login flow (COMPLETED)
2. **TEAM_001_auth-register** - Registration flow (IN PROGRESS)
3. **TEAM_001_auth-password-reset** - Password reset (PENDING)
4. **TEAM_001_auth-sessions** - Session management (PENDING)

### Current Session Progress
- Completed login flow with JWT tokens
- Started registration, email validation done
- Next: Complete registration, then password reset

### Handoff Notes
- Login uses JWT with 24h expiry
- Email validation uses regex from utils/validation
- Password hashing uses bcrypt with cost factor 12
```

## Context Preservation Strategies

### Document As You Go

```typescript
// GOOD: Comments preserve context for future teams
// TEAM_001: Using optimistic locking because concurrent updates
// are possible during checkout. See .questions/TEAM_001_concurrency.md
// for the full discussion.
async function updateInventory(productId: string, quantity: number) {
  const product = await db.products.findOne({ id: productId });
  if (product.version !== expectedVersion) {
    throw new ConcurrencyError('Product was modified');
  }
  // ...
}
```

### Capture Decision Rationale

```markdown
## Decision Log (in team file)

### 2024-01-15 10:30 - Database Choice
**Decision**: Use PostgreSQL instead of MongoDB
**Reasoning**: 
- Strong consistency requirements for financial data
- Complex queries needed for reporting
- Team has more PostgreSQL experience
**Alternatives Considered**:
- MongoDB: Better for flexible schema, but consistency concerns
- MySQL: Similar to PostgreSQL, but fewer advanced features
```

### Leave Breadcrumbs

```typescript
// TEAM_001: This function is called from:
// - api/routes/checkout.ts (line 45)
// - api/routes/cart.ts (line 78)
// - workers/inventory-sync.ts (line 23)
// Any changes here need to consider all three call sites.
function calculateTotal(items: CartItem[]): number {
  // ...
}
```

## Handoff Optimization

### Minimize Re-Initialization

```markdown
## Handoff Notes (Optimized for Next Team)

### Quick Context (30 seconds)
We're implementing checkout flow. Login is done, cart is done, 
payment integration is 80% complete.

### Current State
- File: `src/checkout/payment.ts`
- Function: `processPayment()` - needs error handling
- Test: `tests/checkout/payment.test.ts` - 3 tests failing

### Immediate Next Steps
1. Add try-catch to processPayment() for network errors
2. Fix the 3 failing tests (all related to timeout handling)
3. Add retry logic for transient failures

### Key Decisions Already Made
- Using Stripe for payments (see .questions/TEAM_001_payment-provider.md)
- Retry up to 3 times with exponential backoff
- Log all payment attempts for audit trail

### Files You'll Need
- `src/checkout/payment.ts` - Main payment logic
- `src/utils/retry.ts` - Retry utility (already exists)
- `config/stripe.ts` - Stripe configuration
```

## Progress Tracking

### Session Progress Log

```markdown
## Session Progress - TEAM_001 - 2024-01-15

### Started: 10:00 AM
### Ended: 2:30 PM

### Completed
- [x] Set up Stripe integration
- [x] Implement basic payment flow
- [x] Add payment confirmation emails
- [x] Write unit tests for happy path

### In Progress
- [ ] Error handling for payment failures (70% done)
- [ ] Retry logic for transient errors (not started)

### Blocked
- [ ] Refund flow - waiting for business requirements

### Context for Next Team
Error handling is partially done. The try-catch structure is in place,
but specific error types (CardDeclined, InsufficientFunds, NetworkError)
need individual handling. See TODO comments in payment.ts.
```

## Anti-Patterns

### ❌ Stopping Too Early

```markdown
"I've started the implementation. Let me know if you want me to continue."

# Problem: Lost momentum, context will need to be re-established
```

### ❌ Not Documenting Progress

```markdown
"I made some changes to the payment code."

# Problem: Next team doesn't know what was done or why
```

### ❌ Leaving Incomplete State

```typescript
// DON'T: Leave code in broken state
function processPayment(order) {
  // TODO: finish this
  throw new Error('Not implemented');
}

// DO: Complete to a working state or clearly document what's missing
function processPayment(order) {
  // TEAM_001: Basic implementation complete. Missing:
  // - Error handling for declined cards
  // - Retry logic for network failures
  // See handoff notes for details.
  return stripe.charges.create({ ... });
}
```

## Quality Checklist

### Before Stopping Work

- [ ] **Completed logical unit** - Not stopping mid-function
- [ ] **Code compiles/runs** - No syntax errors left behind
- [ ] **Tests pass** - Or failures are documented
- [ ] **Progress documented** - Team file updated
- [ ] **Handoff notes complete** - Next team can continue easily
- [ ] **No obvious next steps skipped** - Did everything possible

### Context Preservation

- [ ] **Decisions documented** - Why, not just what
- [ ] **Alternatives noted** - What was considered and rejected
- [ ] **Dependencies listed** - What this work connects to
- [ ] **Questions captured** - Open issues are in .questions/

---

## Remember

**Context is precious. Use it fully, document it thoroughly, and hand it off cleanly.**

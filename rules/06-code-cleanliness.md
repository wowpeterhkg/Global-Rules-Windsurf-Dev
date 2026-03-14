# Rule 06 — Code Cleanliness

## Core Principle

Remove dead code immediately. Track all TODOs with context. Leave the codebase cleaner than you found it.

## No Dead Code

### What is Dead Code?

- Unreachable code paths
- Commented-out code blocks
- Unused imports, variables, functions
- Deprecated features never removed
- "Just in case" code

### Remove Immediately

```javascript
// ❌ BAD: Commented code "for reference"
// function oldImplementation() {
//   // 50 lines of old code
// }

// ✅ GOOD: Delete it. Git has history.
```

### Common Excuses (All Wrong)

| Excuse | Reality |
|--------|---------|
| "Might need it later" | Git history exists |
| "Good for reference" | Write documentation instead |
| "Not hurting anyone" | Adds confusion, maintenance burden |
| "Too risky to remove" | Write a test, then remove |

## TODO Tracking

### Required Format

```javascript
// TODO(TEAM_XXX): [Description]
// Context: [Why this is needed]
// Priority: [high/medium/low]
```

### Solo Mode Format

```javascript
// TODO(2024-01-15): [Description]
// Context: [Why this is needed]
```

### Forbidden TODOs

```javascript
// ❌ BAD: Anonymous, no context
// TODO: fix this
// TODO: refactor later
// FIXME: doesn't work sometimes

// ✅ GOOD: Tracked with context
// TODO(TEAM_003): Add retry logic for network failures
// Context: Payment API times out under load
// Priority: high
```

### TODO Categories

| Prefix | Meaning |
|--------|---------|
| `TODO` | Work to be done |
| `FIXME` | Known bug to fix |
| `HACK` | Temporary workaround |
| `OPTIMIZE` | Performance improvement needed |

## Modular Code

### Size Guidelines

| Unit | Max Size | Action if Exceeded |
|------|----------|-------------------|
| Function | 50 lines | Split by responsibility |
| File | 300 lines | Extract modules |
| Class | 200 lines | Single responsibility check |

### Split by Responsibility

```javascript
// ❌ BAD: God function
function processOrder(order) {
  // validate (30 lines)
  // calculate totals (40 lines)
  // apply discounts (25 lines)
  // process payment (35 lines)
  // send notifications (20 lines)
}

// ✅ GOOD: Single responsibility
function processOrder(order) {
  validateOrder(order);
  const totals = calculateTotals(order);
  const finalPrice = applyDiscounts(totals, order.discounts);
  await processPayment(order, finalPrice);
  await sendNotifications(order);
}
```

## Checklist

- [ ] No commented-out code
- [ ] No unused imports/variables
- [ ] All TODOs have owner and context
- [ ] Functions under 50 lines
- [ ] Files under 300 lines

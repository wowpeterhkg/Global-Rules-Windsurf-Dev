# Rule 6 — No Dead Code

## Core Principle

The repository must contain only living, active code. Remove everything that isn't being used.

## What Counts as Dead Code

### Unused Functions

```typescript
// DEAD: Function never called anywhere
function calculateLegacyDiscount(price: number): number {
  return price * 0.9;
}

// Remove it. If needed later, git history has it.
```

### Unused Modules

```
src/
├── utils/
│   ├── helpers.ts        # Used
│   ├── oldHelpers.ts     # DEAD - not imported anywhere
│   └── deprecatedUtils.ts # DEAD - kept "just in case"
```

### Commented-Out Code

```typescript
// DEAD: Commented code blocks
function processOrder(order: Order) {
  // const discount = calculateDiscount(order);
  // order.total = order.subtotal - discount;
  // if (order.isPremium) {
  //   applyPremiumBonus(order);
  // }
  
  return processNewOrder(order);
}

// Delete the comments. Git has the history.
```

### "Kept for Reference" Logic

```typescript
// DEAD: Code kept "for reference"
// OLD IMPLEMENTATION - keeping for reference
// function oldAuthenticate(user, pass) {
//   return db.query(`SELECT * FROM users WHERE...`);
// }

// Use git history instead. Delete this.
```

### Unused Variables and Imports

```typescript
// DEAD: Unused imports
import { unusedHelper, anotherUnused } from './utils';
import _ from 'lodash'; // Never used

// DEAD: Unused variables
const CONFIG_OLD = { timeout: 5000 }; // Never referenced
```

### Unreachable Code

```typescript
function getValue(type: 'a' | 'b'): number {
  if (type === 'a') return 1;
  if (type === 'b') return 2;
  
  // DEAD: Unreachable - all cases handled above
  return 0;
}
```

## Detection Methods

### Static Analysis Tools

```bash
# TypeScript/JavaScript
npx ts-prune                    # Find unused exports
npx unimported                  # Find unimported files
npx depcheck                    # Find unused dependencies

# Python
vulture src/                    # Find dead code

# Go
staticcheck ./...               # Includes unused code detection

# General
# IDE warnings for unused variables/imports
```

### Manual Review Checklist

- [ ] **Search for function name** - Is it called anywhere?
- [ ] **Check import statements** - Is the module imported?
- [ ] **Review git blame** - When was it last meaningfully changed?
- [ ] **Run tests without it** - Does anything break?

## Removal Process

### Step 1: Identify

```bash
# Find potentially dead code
grep -r "functionName" --include="*.ts" .
# If no results (except definition), it's dead
```

### Step 2: Verify

```bash
# Run full test suite
npm test

# Check for dynamic usage (reflection, eval, etc.)
grep -r "functionName\|'functionName'" --include="*.ts" .
```

### Step 3: Remove

```typescript
// Simply delete the dead code
// Don't comment it out
// Don't move it to a "deprecated" folder
// Just delete it
```

### Step 4: Commit with Clear Message

```bash
git commit -m "chore: remove unused calculateLegacyDiscount function

Function was added in 2022 for legacy system integration.
Legacy system was decommissioned in 2023.
No references found in codebase."
```

## Common Excuses (And Why They're Wrong)

### "We might need it later"

**Reality**: Git history preserves everything. You can always recover it.

```bash
# Finding old code in git history
git log -p --all -S 'functionName' -- '*.ts'
```

### "It documents how things used to work"

**Reality**: That's what git history and documentation are for. Code should reflect current state.

### "Someone might be using it externally"

**Reality**: If it's a public API, it should be documented and tested. If neither, remove it.

### "I'm not sure if it's used"

**Reality**: Use static analysis tools. If tools say unused and tests pass without it, remove it.

### "It's only a few lines"

**Reality**: Dead code accumulates. Small pieces add up to large maintenance burden.

## Preventing Dead Code

### At Code Review

- [ ] **New code has tests** - Proves it's used
- [ ] **Removed code is deleted** - Not commented out
- [ ] **Unused imports removed** - IDE warnings addressed
- [ ] **Feature flags cleaned up** - Old flags removed after rollout

### At Feature Completion

- [ ] **Temporary code removed** - Debug statements, test scaffolding
- [ ] **Old implementation deleted** - After new one is verified
- [ ] **Unused dependencies removed** - From package.json/requirements.txt

### Regular Maintenance

```bash
# Weekly/Monthly dead code scan
npm run lint:unused
# or
npx ts-prune
```

## Special Cases

### Feature Flags

```typescript
// When feature is fully rolled out, remove the flag AND old code path
// DON'T keep both paths "just in case"

// Before: Feature flag
if (featureFlags.newCheckout) {
  return newCheckoutFlow();
}
return oldCheckoutFlow();

// After: Feature fully rolled out
return newCheckoutFlow();
// Delete oldCheckoutFlow entirely
```

### A/B Test Code

```typescript
// After experiment concludes:
// 1. Pick the winner
// 2. Delete the loser
// 3. Remove the experiment infrastructure

// DON'T keep both variants "for future experiments"
```

### Backward Compatibility Code

```typescript
// Set explicit removal dates
// When date passes, remove the code

/**
 * @deprecated Remove after 2024-06-01
 */
function legacyEndpoint() { ... }
```

## Quality Metrics

### Codebase Health Indicators

- **Lines of dead code**: Should be 0
- **Unused dependencies**: Should be 0
- **Commented code blocks**: Should be 0
- **Deprecated functions past removal date**: Should be 0

### Review Questions

1. Is every function called somewhere?
2. Is every module imported somewhere?
3. Is every dependency used?
4. Are there any commented code blocks?

---

## Remember

**Dead code is technical debt that earns no interest. Delete it today.**

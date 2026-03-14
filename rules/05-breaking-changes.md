# Rule 5 — Breaking Changes > Fragile Compatibility

## Core Principle

Favor clean breaks over compatibility hacks. If you are writing adapters to "keep old code working," stop — fix the actual sites.

## Why Clean Breaks Win

### Problems with Compatibility Hacks

- **Hidden complexity** - Adapters add layers that obscure real behavior
- **Technical debt** - Compatibility code becomes permanent baggage
- **False safety** - Old code appears to work but may have subtle bugs
- **Maintenance burden** - Two code paths to maintain indefinitely
- **Testing complexity** - Must test both old and new paths

### Benefits of Clean Breaks

- **Single code path** - One way to do things, easier to understand
- **Explicit migration** - Forces review of all usage sites
- **Compiler assistance** - Type errors guide the migration
- **Clean codebase** - No legacy adapters cluttering the code
- **Future-proof** - No compatibility debt to pay later

## Breaking Change Workflow

### Step 1: Move or Rename

```typescript
// OLD: Export from old location
// export function processData(data: OldFormat): Result

// NEW: Move to new location with new signature
export function processData(data: NewFormat): Result {
  // New implementation
}
```

### Step 2: Let the Compiler Fail

- **Remove old exports** - Don't create re-exports
- **Change signatures** - Update types to new format
- **Run build** - Collect all error sites
- **Document errors** - List all files that need updates

### Step 3: Fix Import Sites One by One

```typescript
// Before: Old import
import { processData } from './old-location';
const result = processData(oldFormatData);

// After: New import with migration
import { processData } from './new-location';
const result = processData(migrateToNewFormat(oldFormatData));
```

### Step 4: Remove Temporary Code

- **Delete migration helpers** after all sites updated
- **Remove legacy re-exports** if any were temporarily added
- **Clean up old files** that are no longer needed
- **Update documentation** to reflect new structure

## Anti-Patterns to Avoid

### ❌ Compatibility Adapters

```typescript
// DON'T: Create adapter to keep old code working
export function processDataLegacy(data: OldFormat): Result {
  return processData(convertToNewFormat(data));
}

// This adapter will live forever and create confusion
```

### ❌ Re-exports for Backward Compatibility

```typescript
// DON'T: Re-export from old location
// old-location.ts
export { processData } from './new-location';

// This hides the migration and prevents cleanup
```

### ❌ Optional Parameters for Old Behavior

```typescript
// DON'T: Add optional param to support old behavior
function processData(data: NewFormat, useLegacy?: boolean): Result {
  if (useLegacy) {
    return legacyProcess(data);
  }
  return newProcess(data);
}
```

### ❌ Feature Flags for Compatibility

```typescript
// DON'T: Use feature flags to maintain old behavior
if (config.useLegacyProcessing) {
  return oldProcess(data);
}
return newProcess(data);
```

## Correct Patterns

### ✅ Direct Migration

```typescript
// DO: Change the signature, fix all call sites
// Before
function getUser(id: number): User

// After - change signature, fix all callers
function getUser(id: string): User
```

### ✅ Deprecation with Removal Date

```typescript
// DO: If transition period needed, set explicit removal date
/**
 * @deprecated Use processDataV2 instead. Will be removed 2024-03-01.
 */
function processData(data: OldFormat): Result {
  console.warn('processData is deprecated, migrate to processDataV2');
  return processDataV2(migrateFormat(data));
}
```

### ✅ Migration Scripts

```bash
# DO: Create one-time migration script
#!/bin/bash
# migrate-to-new-format.sh
# Run once, then delete

find . -name "*.ts" -exec sed -i 's/oldFunction/newFunction/g' {} \;
```

## Database Schema Changes

### Breaking Schema Changes

```sql
-- Step 1: Add new column
ALTER TABLE users ADD COLUMN email_verified BOOLEAN DEFAULT FALSE;

-- Step 2: Migrate data
UPDATE users SET email_verified = (verification_date IS NOT NULL);

-- Step 3: Remove old column (after code migration)
ALTER TABLE users DROP COLUMN verification_date;
```

### API Breaking Changes

```typescript
// Version the API endpoint, don't maintain compatibility
// OLD: /api/v1/users
// NEW: /api/v2/users

// Set deprecation timeline for v1
// Remove v1 after migration period
```

## Team Communication

### Before Breaking Change

1. **Announce the change** in team communication channel
2. **Document migration path** with examples
3. **Set timeline** for completion
4. **Assign ownership** for each affected area

### During Migration

1. **Track progress** in team file
2. **Help blocked team members** with migration
3. **Update documentation** as patterns emerge
4. **Test thoroughly** at each step

### After Migration

1. **Verify all sites migrated** - no legacy code remaining
2. **Remove temporary helpers** and migration code
3. **Update documentation** to remove old references
4. **Celebrate clean codebase** 🎉

## Quality Checklist

### Before Starting

- [ ] **Change is necessary** - not just preference
- [ ] **Migration path is clear** - documented steps
- [ ] **Team is informed** - no surprises
- [ ] **Timeline is realistic** - adequate time for migration

### During Migration

- [ ] **All error sites identified** - compiler errors collected
- [ ] **Each site fixed properly** - not just silenced
- [ ] **Tests updated** - reflect new behavior
- [ ] **No compatibility hacks** - clean migration only

### After Completion

- [ ] **No legacy code remains** - all sites migrated
- [ ] **No adapters remain** - clean interfaces
- [ ] **Documentation updated** - reflects current state
- [ ] **Tests pass** - full coverage maintained

---

## Remember

**If you're writing code to make old code work with new code, you're doing it wrong. Fix the old code.**

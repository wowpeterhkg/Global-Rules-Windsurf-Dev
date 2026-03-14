# Rule 05 — Breaking Changes

## Core Principle

Favor clean breaks over fragile compatibility layers. When breaking is necessary, do it cleanly with clear migration paths.

## Quick Rules

- Clean breaks over compatibility hacks
- Document all breaking changes
- Provide migration guides
- Version appropriately (semver MAJOR)

## When to Break

✅ **Break when**:
- Compatibility layer adds significant complexity
- Old approach has security issues
- Technical debt compounds over time
- Clean API is significantly better

❌ **Don't break for**:
- Minor improvements
- Personal preference
- "It would be nicer"

## Breaking Change Workflow

1. **Document** what's changing and why
2. **Communicate** to affected parties
3. **Provide** migration guide
4. **Deprecate** old approach (if gradual)
5. **Remove** after migration period

## Migration Guide Template

```markdown
## Breaking Change: [What Changed]

### Why
[Reason for the change]

### Before
```code
oldFunction(param1, param2)
```

### After
```code
newFunction({ param1, param2, newOption })
```

### Migration Steps
1. [Step 1]
2. [Step 2]
```

## Examples

✅ **Good**: Clean break with migration
```javascript
// v2.0.0 - Breaking change
// OLD: getUser(id, includeProfile, includeSettings)
// NEW: getUser(id, { include: ['profile', 'settings'] })

/** @deprecated Use getUser(id, options) instead. Removed in v3.0 */
function getUserLegacy(id, includeProfile, includeSettings) {
  return getUser(id, {
    include: [
      ...(includeProfile ? ['profile'] : []),
      ...(includeSettings ? ['settings'] : [])
    ]
  });
}
```

❌ **Bad**: Compatibility spaghetti
```javascript
// Trying to support 5 different API versions
function getUser(idOrOptions, maybeCallback, legacyFlag, v2Options, v3Options) {
  // 200 lines of compatibility code
}
```

## Checklist

- [ ] Breaking change is necessary (not just nice-to-have)
- [ ] Migration guide written
- [ ] Version bumped appropriately
- [ ] Deprecation warnings added (if gradual)

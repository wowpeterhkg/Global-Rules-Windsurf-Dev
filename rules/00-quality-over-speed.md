# Rule 00 — Quality Over Speed

## Core Principle

Take the correct architectural path, never the shortcut. Future teams inherit your decisions.

## Quick Rules

- Prefer clean designs over quick fixes
- Avoid wrappers, shims, indirection unless truly necessary
- Leave the codebase better than you found it
- No shortcuts for speed — ever
- Performance optimizations come after correctness

## Examples

✅ **Good**: Clean separation of concerns
```javascript
class UserService {
  constructor(repository, validator) {
    this.repository = repository;
    this.validator = validator;
  }
  
  async createUser(userData) {
    this.validator.validate(userData);
    return this.repository.save(userData);
  }
}
```

❌ **Bad**: Quick fix that creates debt
```javascript
function createUser(userData) {
  return db.users.insert(userData); // Skip validation, direct DB access
}
```

## Decision Checklist

- [ ] Is this the cleanest architectural approach?
- [ ] Will this create technical debt?
- [ ] Does this follow established patterns in the codebase?
- [ ] Would I be comfortable explaining this to a future maintainer?

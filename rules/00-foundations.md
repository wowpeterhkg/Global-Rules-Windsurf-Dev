# Rule 0 — Quality Over Speed

## Core Principle
Take the correct architectural path, never the shortcut.

## Implementation Guidelines

### Design Decisions
- **Prefer clean designs over quick fixes**
- **Avoid wrappers, shims, indirection unless truly necessary**
- **Leave the codebase better than you found it**
- **Future teams inherit your decisions — choose debt-free solutions**

### Decision Framework
Before implementing any solution, ask:
1. Is this the cleanest architectural approach?
2. Will this create technical debt for future teams?
3. Is there a more maintainable solution, even if it takes longer?
4. Does this follow established patterns in the codebase?

### Quality Gates
- **No shortcuts for speed** - ever
- **Code review must pass architectural standards**
- **Documentation must be complete before merge**
- **Tests must cover the implementation**
- **Performance optimizations come after correctness**

### Examples

#### ✅ Good: Clean Architecture
```javascript
// Clear separation of concerns
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

#### ❌ Bad: Quick Fix
```javascript
// Shortcut that creates technical debt
function createUser(userData) {
  // Skip validation for speed
  return db.users.insert(userData); // Direct DB access
}
```

### Team Accountability
- **Every PR must include architectural justification**
- **Senior developers must review architectural decisions**
- **Document why alternatives were rejected**
- **Create architectural decision records (ADRs) for significant changes**

### Success Metrics
- **Code complexity decreases over time**
- **New feature implementation time improves**
- **Bug count decreases in existing code**
- **Team onboarding time reduces**

---

## Remember
**Good > Fast. Always.**

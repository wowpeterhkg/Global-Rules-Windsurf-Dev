# Rule 16 — Code Review

## Core Principle

Every change needs review. Security-sensitive code gets extra scrutiny. Flag anything that handles sensitive data.

## Quick Rules

- All changes reviewed before merge
- Security changes need security review
- Add inline comments for complex logic
- Generate TODO for follow-up reviews

## Security Review Triggers

Require security review when touching:

- Authentication / authorization
- Password handling
- Payment processing
- Personal data (PII)
- API keys / secrets
- Database queries
- File uploads
- External API calls

## Review Checklist

### General

- [ ] Code compiles and tests pass
- [ ] Follows existing patterns
- [ ] No unnecessary complexity
- [ ] Documentation updated

### Security

- [ ] Inputs validated
- [ ] Queries parameterized
- [ ] No hardcoded secrets
- [ ] Errors don't leak info
- [ ] Auth/authz checked

### Performance

- [ ] No N+1 queries
- [ ] Appropriate indexing
- [ ] No memory leaks
- [ ] Reasonable complexity

## Inline Security Comments

```javascript
// SECURITY: Rate limiting applied to prevent brute force
app.use('/api/login', rateLimiter({ max: 5, window: '15m' }));

// SECURITY: Input sanitized to prevent XSS
const safeHtml = DOMPurify.sanitize(userInput);

// SECURITY-REVIEW: Verify this authorization check is sufficient
if (user.role !== 'admin') {
  throw new ForbiddenError();
}
```

## PR Description Template

```markdown
## Summary
[What this PR does]

## Type
- [ ] Feature
- [ ] Bug fix
- [ ] Security fix
- [ ] Refactor

## Security Impact
- [ ] Touches auth/authz
- [ ] Handles sensitive data
- [ ] Changes API surface
- [ ] None

## Testing
- [ ] Unit tests added
- [ ] Integration tests added
- [ ] Manual testing done

## Checklist
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No secrets in code
```

## Review Response Time

| PR Size | Target Review Time |
|---------|-------------------|
| Small (< 100 lines) | Same day |
| Medium (100-500 lines) | 1-2 days |
| Large (> 500 lines) | Consider splitting |

## Checklist

- [ ] All changes reviewed
- [ ] Security-sensitive code flagged
- [ ] Inline comments for complex logic
- [ ] PR description complete

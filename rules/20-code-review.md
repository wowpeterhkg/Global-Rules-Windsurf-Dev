# Rule 20 — Code Review Requirements

## Core Principle

Generate TODO comments for any code that needs security review. Add inline comments explaining security-relevant decisions. Flag any code that handles sensitive data for manual review.

## Security-Focused Review

### Mandatory Security Review Triggers

Code MUST be flagged for security review if it:

- Handles authentication or authorization
- Processes user input
- Interacts with databases
- Handles sensitive data (PII, financial, health)
- Makes external API calls
- Implements cryptographic operations
- Modifies access controls
- Handles file uploads or downloads

### Security Review TODO Format

```typescript
// SECURITY-REVIEW(TEAM_XXX): [Description of security concern]
// Risk: [What could go wrong]
// Mitigation: [How it's being addressed]
// Reviewer: [Required expertise]

// Example:
// SECURITY-REVIEW(TEAM_001): User input used in database query
// Risk: SQL injection if input not properly sanitized
// Mitigation: Using parameterized queries with $1 placeholders
// Reviewer: Security team member required
async function findUser(email: string): Promise<User> {
  return db.query('SELECT * FROM users WHERE email = $1', [email]);
}
```

## Code Review Checklist

### General Quality

- [ ] **Code compiles** without errors or warnings
- [ ] **Tests pass** and cover new functionality
- [ ] **No dead code** introduced
- [ ] **Follows existing patterns** in codebase
- [ ] **Documentation** updated if needed
- [ ] **No hardcoded values** that should be config

### Security Checklist

- [ ] **No hardcoded secrets** or API keys
- [ ] **Proper input validation** on all user inputs
- [ ] **SQL injection protection** - parameterized queries
- [ ] **XSS prevention** - output encoding
- [ ] **Authentication flow** secure
- [ ] **Authorization checks** comprehensive
- [ ] **Error handling** doesn't leak information
- [ ] **Sensitive data** properly protected
- [ ] **Logging** doesn't include sensitive data

### Performance Checklist

- [ ] **No N+1 queries** introduced
- [ ] **Appropriate indexing** for new queries
- [ ] **No blocking operations** in async code
- [ ] **Memory leaks** avoided
- [ ] **Caching** considered where appropriate

## Inline Security Comments

### When to Add Security Comments

```typescript
// GOOD: Explain security-relevant decisions
// Security: Using bcrypt with cost factor 12 for password hashing
// This provides adequate protection against brute force while
// keeping login times reasonable (~250ms on current hardware)
const hash = await bcrypt.hash(password, 12);

// Security: Rate limiting applied to prevent brute force attacks
// Limit: 5 attempts per minute per IP address
// Lockout: 15 minutes after 10 failed attempts
const rateLimiter = new RateLimiter({ ... });

// Security: Sanitizing HTML to prevent XSS
// Using DOMPurify with default config which strips all scripts
const safeHtml = DOMPurify.sanitize(userInput);
```

### Security Decision Documentation

```typescript
/**
 * Validates user session token.
 * 
 * Security considerations:
 * - Token is validated server-side, never trusted from client
 * - Expiration is checked before any other validation
 * - Failed validations are logged for security monitoring
 * - Token is not included in error messages to prevent enumeration
 * 
 * @security-review Required for any changes to validation logic
 */
function validateSession(token: string): Session | null {
  // Implementation
}
```

## Review Process

### Before Submitting for Review

```markdown
## Self-Review Checklist

### Code Quality
- [ ] I have reviewed my own code
- [ ] Code follows project style guide
- [ ] No unnecessary changes included
- [ ] Commit messages are clear

### Testing
- [ ] New code has tests
- [ ] All tests pass locally
- [ ] Edge cases are covered
- [ ] Error cases are tested

### Security
- [ ] Security implications considered
- [ ] SECURITY-REVIEW tags added where needed
- [ ] No secrets in code
- [ ] Input validation in place

### Documentation
- [ ] Code comments explain "why"
- [ ] API documentation updated
- [ ] README updated if needed
```

### Reviewer Responsibilities

```markdown
## Reviewer Checklist

### Understanding
- [ ] I understand what this code does
- [ ] I understand why this change is needed
- [ ] The approach makes sense

### Quality
- [ ] Code is readable and maintainable
- [ ] No obvious bugs or issues
- [ ] Error handling is appropriate
- [ ] Tests are adequate

### Security
- [ ] Security implications reviewed
- [ ] SECURITY-REVIEW items addressed
- [ ] No new vulnerabilities introduced
- [ ] Sensitive data handled properly

### Feedback
- [ ] Comments are constructive
- [ ] Blocking issues clearly marked
- [ ] Suggestions vs requirements clear
```

## Sensitive Data Handling

### Flagging Sensitive Data Code

```typescript
// SENSITIVE-DATA(TEAM_XXX): Handles user PII
// Data types: email, phone, address
// Storage: Encrypted at rest in users table
// Access: Logged for audit trail
// Retention: 7 years per compliance requirement
async function updateUserProfile(userId: string, data: ProfileData) {
  logger.info({ userId, action: 'profile_update' }, 'PII access');
  // Implementation
}
```

### Data Classification

| Classification | Examples | Handling Requirements |
|----------------|----------|----------------------|
| **Public** | Product names, prices | Standard handling |
| **Internal** | Employee IDs, internal docs | Access controls |
| **Confidential** | Customer data, contracts | Encryption, audit |
| **Restricted** | Passwords, SSN, financial | Maximum protection |

## Review Comments

### Good Review Comments

```markdown
## Constructive Feedback Examples

### Security Issue
"This user input is used directly in the query. Consider using 
parameterized queries to prevent SQL injection. See Rule 15 for 
the correct pattern."

### Suggestion
"This could be simplified using the existing `formatDate` utility 
in `src/utils/date.ts`. Not blocking, but would reduce duplication."

### Question
"I'm not sure I understand why we need to fetch the user twice here. 
Could you explain the reasoning or consider caching the first result?"

### Approval with Note
"LGTM! One minor suggestion: consider adding a comment explaining 
why we use a 30-second timeout here for future maintainers."
```

### Bad Review Comments

```markdown
## Avoid These

❌ "This is wrong" (no explanation)
❌ "I would do it differently" (no specific suggestion)
❌ "Why?" (too vague)
❌ "This code is bad" (not constructive)
❌ "Just fix it" (no guidance)
```

## Automated Review Tools

### Required Checks

```yaml
# .github/workflows/pr-checks.yml
name: PR Checks
on: [pull_request]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm run lint
      
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm test
      
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm audit
      - run: npx snyk test
```

### Code Quality Gates

| Check | Requirement |
|-------|-------------|
| Lint | No errors |
| Tests | All pass |
| Coverage | No decrease |
| Security | No high/critical |
| Build | Succeeds |

## Quality Checklist

### For Authors

- [ ] **Self-reviewed** code before submitting
- [ ] **Tests added** for new functionality
- [ ] **Security tags** added where needed
- [ ] **Documentation** updated
- [ ] **Commit messages** are clear

### For Reviewers

- [ ] **Understood** the change and its purpose
- [ ] **Security** implications reviewed
- [ ] **Quality** standards met
- [ ] **Feedback** is constructive and clear
- [ ] **Approval** given only when satisfied

---

## Remember

**Code review is a collaborative process. The goal is better code, not winning arguments.**

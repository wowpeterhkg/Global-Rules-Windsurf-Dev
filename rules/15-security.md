# Rule 15 — Code Security Standards

## Core Principle
Security is not optional - it's a fundamental requirement for all code.

## Database Security

### Parameterized Queries Only
- **NEVER** use string concatenation for database queries
- **ALWAYS** use parameterized queries with placeholders ($1, $2, etc.)
- **NO EXCEPTIONS** - even for server-controlled values like environment variables or integers

#### ✅ Correct
```javascript
const query = 'SELECT * FROM users WHERE id = $1 AND email = $2';
const result = await db.query(query, [userId, userEmail]);
```

#### ❌ Wrong
```javascript
// NEVER DO THIS - SQL Injection vulnerable
const query = `SELECT * FROM users WHERE id = ${userId} AND email = '${userEmail}'`;
const result = await db.query(query);
```

### Input Validation

#### Route Parameters
```javascript
// Always validate and parse route params
const userId = parseInt(req.params.id);
if (isNaN(userId) || userId <= 0) {
  return res.status(400).json({ error: 'Invalid user ID' });
}
```

#### String Inputs
```javascript
// Enforce maximum length limits
function validateName(name) {
  if (typeof name !== 'string') return false;
  if (name.length > 255) return false; // Max length
  if (name.trim() === '') return false;
  return true;
}
```

#### Email Validation
```javascript
// Use proper email regex
const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
if (!emailRegex.test(email)) {
  return res.status(400).json({ error: 'Invalid email format' });
}
```

#### Array Inputs
```javascript
// Validate array inputs with length limits
if (!Array.isArray(items)) {
  return res.status(400).json({ error: 'Items must be an array' });
}
if (items.length > 100) {
  return res.status(400).json({ error: 'Too many items' });
}
```

#### Numeric Inputs
```javascript
// Validate numeric ranges
function validateAge(age) {
  const num = parseInt(age);
  return !isNaN(num) && num >= 0 && num <= 150;
}
```

## Authentication & Authorization

### JWT Tokenization
- **Tokenize all data** and JSON payloads with JWT
- **Never expose raw data** in API responses
- **Strip sensitive fields** before sending to client

```javascript
// Strip password hash from all responses
function sanitizeUser(user) {
  const { password_hash, ...sanitized } = user;
  return sanitized;
}

res.json({ user: sanitizeUser(userData) });
```

### Secure Authentication Patterns
```javascript
// Proper password verification
async function verifyPassword(email, password) {
  const user = await getUserByEmail(email);
  if (!user) return false;
  
  const isValid = await bcrypt.compare(password, user.password_hash);
  return isValid;
}
```

## Error Handling

### Generic Error Messages
- **NEVER** return `err.message`, `err.stack`, or internal error details
- **ALWAYS** return generic messages to clients
- **LOG detailed errors** server-side only

#### ✅ Correct
```javascript
try {
  const result = await riskyOperation();
  res.json({ data: result });
} catch (error) {
  logger.error({ err: error }, 'Error processing request');
  res.status(500).json({ error: 'Internal server error' });
}
```

#### ❌ Wrong
```javascript
try {
  const result = await riskyOperation();
  res.json({ data: result });
} catch (error) {
  // NEVER expose internal errors to clients
  res.status(500).json({ 
    error: error.message || 'Internal server error' 
  });
}
```

### Structured Logging
- **Use structured loggers** (pino, winston) in route handlers
- **Never use console.error/console.log** in API endpoints
- **Console logging only** in startup scripts and CLI tools

```javascript
import logger from './logger';

// In route handlers
app.post('/users', async (req, res) => {
  try {
    const user = await createUser(req.body);
    logger.info({ userId: user.id }, 'User created successfully');
    res.json({ user: sanitizeUser(user) });
  } catch (error) {
    logger.error({ err: error, email: req.body.email }, 'Failed to create user');
    res.status(500).json({ error: 'Internal server error' });
  }
});
```

## Data Protection

### Encryption Requirements
- **AES-256 encryption** for data at rest
- **TLS 1.2+** for data in transit
- **Cryptographically secure random** number generation

```javascript
import crypto from 'crypto';

// Secure random token generation
function generateSecureToken(length = 32) {
  return crypto.randomBytes(length).toString('hex');
}
```

### Data Access Principles
- **Log all data access** for auditing
- **Follow minimum necessary principle** - only access required data
- **Implement transaction isolation** and consistency checks

### Sensitive Data Handling
- **Never log passwords**, tokens, encryption keys, or raw PII
- **Redact sensitive settings** for non-admin users
- **Secure token generation** with proper entropy

## Session Management

### Time-Based Sessions
- **Implement session timeouts** for sensitive data access
- **Secure token generation** with cryptographically secure randomness
- **Proper session invalidation** on logout

```javascript
// Secure session configuration
app.use(session({
  secret: process.env.SESSION_SECRET,
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: process.env.NODE_ENV === 'production',
    httpOnly: true,
    maxAge: 24 * 60 * 60 * 1000 // 24 hours
  }
}));
```

## Security Testing

### Security Test Cases
- **Authentication bypass** attempts
- **Authorization escalation** testing
- **Input validation** edge cases
- **SQL injection** prevention
- **XSS protection** verification

### Code Review Requirements
- **TODO comments** for security review
- **Inline comments** explaining security decisions
- **Flag sensitive data handling** for manual review
- **Security test cases** for auth/authz logic

## Rate Limiting & Fraud Detection

### Implementation Patterns
```javascript
import rateLimit from 'express-rate-limit';

// Rate limiting for sensitive endpoints
const sensitiveLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // limit each IP to 5 requests per windowMs
  message: 'Too many attempts, please try again later'
});

app.post('/login', sensitiveLimiter, loginHandler);
```

### Fraud Detection Patterns
- **Build in rate limiting** for sensitive operations
- **Implement fraud detection** patterns
- **Monitor for suspicious activity**
- **Block repeated failures** automatically

## OWASP Top 10 Compliance

### Required Controls
1. **Injection Prevention** - Parameterized queries, input validation
2. **Broken Authentication** - Secure session management, MFA
3. **Sensitive Data Exposure** - Encryption, data minimization
4. **XML External Entities** - Safe XML parsing
5. **Broken Access Control** - Proper authorization checks
6. **Security Misconfiguration** - Secure defaults, hardening
7. **Cross-Site Scripting** - Input sanitization, output encoding
8. **Insecure Deserialization** - Safe deserialization patterns
9. **Using Components with Known Vulnerabilities** - Dependency scanning
10. **Insufficient Logging & Monitoring** - Security event logging

## Security Checklist

### Before Deployment
- [ ] **All database queries** use parameterized queries
- [ ] **All inputs** validated and sanitized
- [ ] **Error messages** are generic for clients
- [ ] **Sensitive data** stripped from responses
- [ ] **Authentication** properly implemented
- [ ] **Authorization** checks on all endpoints
- [ ] **HTTPS enforced** in production
- [ ] **Security headers** properly configured
- [ ] **Rate limiting** implemented on sensitive endpoints
- [ ] **Logging configured** for security events

### Code Review Security Checklist
- [ ] **No hardcoded secrets** or API keys
- [ ] **Proper input validation** on all user inputs
- [ ] **SQL injection protection** implemented
- [ ] **XSS prevention** measures in place
- [ ] **Authentication flow** secure
- [ ] **Authorization checks** comprehensive
- [ ] **Error handling** doesn't leak information
- [ ] **Sensitive data** properly protected

---

## Remember
**Security is everyone's responsibility. One vulnerability can compromise the entire system.**

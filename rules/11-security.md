# Rule 11 — Security Standards

## Core Principle

Security is non-negotiable. Follow OWASP Top 10. Never trust user input.

## Quick Rules

- Parameterized queries always
- Validate all inputs
- Never hardcode secrets
- Errors don't leak info
- Hash passwords properly

## OWASP Top 10 (2021)

| Code | Vulnerability | Key Prevention |
|------|---------------|----------------|
| A01 | Broken Access Control | Deny by default, validate permissions |
| A02 | Cryptographic Failures | Use strong encryption, no hardcoded secrets |
| A03 | Injection | Parameterized queries, input validation |
| A04 | Insecure Design | Threat modeling, secure design patterns |
| A05 | Security Misconfiguration | Hardened defaults, remove unused features |
| A06 | Vulnerable Components | Audit dependencies, keep updated |
| A07 | Auth Failures | MFA, strong passwords, rate limiting |
| A08 | Data Integrity Failures | Verify signatures, secure CI/CD |
| A09 | Logging Failures | Log security events, monitor anomalies |
| A10 | SSRF | Validate URLs, allowlist destinations |

## Database Security

### Parameterized Queries (Required)

```javascript
// ✅ CORRECT - Parameterized
const user = await db.query(
  'SELECT * FROM users WHERE id = $1',
  [userId]
);

// ❌ WRONG - SQL injection vulnerable
const user = await db.query(
  `SELECT * FROM users WHERE id = ${userId}`
);
```

### Input Validation

```javascript
// Validate before use
function validateUserId(id) {
  const parsed = parseInt(id, 10);
  if (isNaN(parsed) || parsed <= 0) {
    throw new Error('Invalid user ID');
  }
  return parsed;
}

// String length limits
function validateName(name) {
  if (typeof name !== 'string' || name.length > 255) {
    throw new Error('Invalid name');
  }
  return name.trim();
}
```

## Authentication

### Password Handling

```javascript
import bcrypt from 'bcrypt';

// Hash password (never store plain text)
const hash = await bcrypt.hash(password, 12);

// Verify password
const valid = await bcrypt.compare(password, hash);
```

### JWT Best Practices

```javascript
// Short-lived access tokens
const accessToken = jwt.sign(payload, secret, { expiresIn: '15m' });

// Never include sensitive data in JWT
// ❌ BAD
jwt.sign({ password: user.password }, secret);

// ✅ GOOD
jwt.sign({ userId: user.id, role: user.role }, secret);
```

## Error Handling

### Never Leak Internal Errors

```javascript
// ✅ CORRECT - Generic message to client
app.use((err, req, res, next) => {
  logger.error({ err }, 'Request failed');
  res.status(500).json({ error: 'Internal server error' });
});

// ❌ WRONG - Leaks implementation details
app.use((err, req, res, next) => {
  res.status(500).json({ error: err.message, stack: err.stack });
});
```

## Secrets Management

```bash
# ✅ CORRECT - Environment variables
DATABASE_URL=postgresql://...
JWT_SECRET=...

# ❌ WRONG - Hardcoded in code
const secret = "my-super-secret-key";
```

## API Response Security

```javascript
// Strip sensitive fields before responding
function sanitizeUser(user) {
  const { password_hash, ...safe } = user;
  return safe;
}

res.json(sanitizeUser(user));
```

## Data Protection & Compliance

### Data at Rest (AES-256)

All stored data must be encrypted to comply with GDPR, PCI-DSS, and HIPAA:

```javascript
import crypto from 'crypto';

const ALGORITHM = 'aes-256-gcm';
const KEY = Buffer.from(process.env.ENCRYPTION_KEY, 'hex'); // 32 bytes

function encrypt(plaintext) {
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv(ALGORITHM, KEY, iv);
  const encrypted = Buffer.concat([cipher.update(plaintext, 'utf8'), cipher.final()]);
  const tag = cipher.getAuthTag();
  return { iv: iv.toString('hex'), data: encrypted.toString('hex'), tag: tag.toString('hex') };
}

function decrypt({ iv, data, tag }) {
  const decipher = crypto.createDecipheriv(ALGORITHM, KEY, Buffer.from(iv, 'hex'));
  decipher.setAuthTag(Buffer.from(tag, 'hex'));
  return decipher.update(data, 'hex', 'utf8') + decipher.final('utf8');
}
```

### PII Data Handling

All Personally Identifiable Information must be encrypted:

| PII Type | Storage | Access |
|----------|---------|--------|
| SSN, Tax ID | AES-256 encrypted | Strict audit logging |
| Email, Phone | AES-256 encrypted | Role-based access |
| Address | AES-256 encrypted | Need-to-know basis |
| Name | Encrypted or pseudonymized | Minimize exposure |

### Data in Transit (TLS 1.2+)

```javascript
// Express.js - Enforce HTTPS and TLS 1.2+
import https from 'https';
import fs from 'fs';

const options = {
  key: fs.readFileSync('server.key'),
  cert: fs.readFileSync('server.crt'),
  minVersion: 'TLSv1.2',  // Enforce TLS 1.2 minimum
  ciphers: 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384',
};

https.createServer(options, app).listen(443);

// Redirect HTTP to HTTPS
app.use((req, res, next) => {
  if (!req.secure) {
    return res.redirect(301, `https://${req.headers.host}${req.url}`);
  }
  next();
});
```

### Password Hashing (bcrypt)

```javascript
import bcrypt from 'bcrypt';

const SALT_ROUNDS = 12;  // Minimum 12 for production

// Hash password
const hash = await bcrypt.hash(password, SALT_ROUNDS);

// Verify password
const isValid = await bcrypt.compare(password, hash);
```

## Security Checklist

- [ ] No SQL injection vulnerabilities
- [ ] All inputs validated
- [ ] Passwords hashed with bcrypt (12+ rounds)
- [ ] No secrets in code
- [ ] Errors don't leak info
- [ ] Sensitive data stripped from responses
- [ ] HTTPS enforced (TLS 1.2+)
- [ ] CORS configured properly
- [ ] Data at rest encrypted (AES-256)
- [ ] PII data encrypted
- [ ] Audit logging for sensitive data access

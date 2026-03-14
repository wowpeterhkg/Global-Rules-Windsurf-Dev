# Rule 16 — Error Handling & Logging

## Core Principle

Implement fail-secure patterns. Log security events appropriately without exposing sensitive data. Use structured error responses that don't leak implementation details.

## Fail-Secure Patterns

### Deny by Default

```typescript
// GOOD: Deny by default, explicitly allow
function checkPermission(user: User, resource: Resource): boolean {
  // Start with denial
  let allowed = false;
  
  // Explicitly check each permission
  if (user.role === 'admin') {
    allowed = true;
  } else if (resource.ownerId === user.id) {
    allowed = true;
  } else if (user.permissions.includes(resource.requiredPermission)) {
    allowed = true;
  }
  
  return allowed;
}

// BAD: Allow by default, try to deny
function checkPermission(user: User, resource: Resource): boolean {
  // Dangerous: starts with allowing
  if (user.isBanned) return false;
  if (resource.isRestricted && !user.isPremium) return false;
  return true; // Everything else allowed - dangerous!
}
```

### Fail Closed on Errors

```typescript
// GOOD: On error, deny access
async function authorize(token: string): Promise<boolean> {
  try {
    const user = await verifyToken(token);
    return user.isActive;
  } catch (error) {
    logger.error({ err: error }, 'Authorization failed');
    return false; // Fail closed - deny on error
  }
}

// BAD: On error, allow access
async function authorize(token: string): Promise<boolean> {
  try {
    const user = await verifyToken(token);
    return user.isActive;
  } catch (error) {
    return true; // Dangerous! Allows access on error
  }
}
```

## Structured Logging

### Use Structured Logger

```typescript
// GOOD: Structured logging with context
import pino from 'pino';

const logger = pino({
  level: process.env.LOG_LEVEL || 'info',
  formatters: {
    level: (label) => ({ level: label }),
  },
});

// Log with structured context
logger.info({ userId, action: 'login', ip: req.ip }, 'User logged in');
logger.error({ err, orderId }, 'Payment processing failed');

// BAD: Console.log in production code
console.log('User logged in: ' + userId); // No structure, hard to parse
console.error('Error: ' + error.message); // May leak sensitive info
```

### Log Levels

| Level | Use Case | Example |
|-------|----------|---------|
| `fatal` | Application cannot continue | Database connection lost |
| `error` | Operation failed | Payment declined |
| `warn` | Unexpected but handled | Rate limit approaching |
| `info` | Normal operations | User logged in |
| `debug` | Development details | Request payload |
| `trace` | Verbose debugging | Function entry/exit |

### What to Log

```typescript
// DO log:
logger.info({ userId, action: 'password_change' }, 'Password changed');
logger.warn({ userId, attempts: 3 }, 'Multiple failed login attempts');
logger.error({ err, orderId }, 'Order processing failed');

// DON'T log:
logger.info({ password }, 'User password'); // Never log passwords
logger.debug({ token }, 'JWT token'); // Never log tokens
logger.info({ ssn, creditCard }, 'User data'); // Never log PII
```

## Error Response Standards

### Generic Client Responses

```typescript
// GOOD: Generic error to client, detailed log server-side
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  // Log full error details server-side
  logger.error({
    err,
    path: req.path,
    method: req.method,
    userId: req.user?.id,
  }, 'Request failed');
  
  // Return generic error to client
  res.status(500).json({
    error: 'Internal server error',
    requestId: req.id, // For support correlation
  });
});

// BAD: Exposing internal details to client
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  res.status(500).json({
    error: err.message, // May contain SQL, file paths, etc.
    stack: err.stack,   // Exposes internal structure
  });
});
```

### Error Response Structure

```typescript
// Standard error response format
interface ErrorResponse {
  error: string;        // Human-readable message
  code?: string;        // Machine-readable error code
  requestId?: string;   // For support correlation
  details?: object;     // Safe additional context (never internal details)
}

// Examples
// 400 Bad Request
{ "error": "Invalid email format", "code": "VALIDATION_ERROR" }

// 401 Unauthorized
{ "error": "Authentication required", "code": "AUTH_REQUIRED" }

// 403 Forbidden
{ "error": "Access denied", "code": "FORBIDDEN" }

// 404 Not Found
{ "error": "Resource not found", "code": "NOT_FOUND" }

// 500 Internal Server Error
{ "error": "Internal server error", "requestId": "abc-123" }
```

## Exception Handling Patterns

### Catch Specific Exceptions

```typescript
// GOOD: Handle specific errors differently
async function processPayment(order: Order): Promise<PaymentResult> {
  try {
    return await paymentGateway.charge(order);
  } catch (error) {
    if (error instanceof CardDeclinedError) {
      logger.warn({ orderId: order.id }, 'Card declined');
      throw new PaymentError('Payment declined', 'CARD_DECLINED');
    }
    if (error instanceof InsufficientFundsError) {
      logger.warn({ orderId: order.id }, 'Insufficient funds');
      throw new PaymentError('Insufficient funds', 'INSUFFICIENT_FUNDS');
    }
    if (error instanceof NetworkError) {
      logger.error({ err: error, orderId: order.id }, 'Payment gateway unreachable');
      throw new PaymentError('Payment service unavailable', 'SERVICE_UNAVAILABLE');
    }
    // Unknown error - log and rethrow generic
    logger.error({ err: error, orderId: order.id }, 'Unexpected payment error');
    throw new PaymentError('Payment failed', 'PAYMENT_FAILED');
  }
}
```

### Never Swallow Exceptions

```typescript
// BAD: Swallowing exceptions
try {
  await riskyOperation();
} catch (error) {
  // Silent failure - debugging nightmare
}

// BAD: Logging but not handling
try {
  await riskyOperation();
} catch (error) {
  console.log(error); // Then what?
}

// GOOD: Log and handle appropriately
try {
  await riskyOperation();
} catch (error) {
  logger.error({ err: error }, 'Risky operation failed');
  throw new AppError('Operation failed', 500);
}
```

## Security Event Logging

### Authentication Events

```typescript
// Log all authentication events
logger.info({ userId, ip, userAgent }, 'Login successful');
logger.warn({ username, ip, attempts }, 'Login failed');
logger.info({ userId, ip }, 'Logout');
logger.warn({ userId, ip }, 'Session expired');
logger.info({ userId, ip }, 'Password changed');
logger.warn({ userId, ip }, 'Password reset requested');
```

### Authorization Events

```typescript
// Log authorization decisions
logger.info({ userId, resource, action }, 'Access granted');
logger.warn({ userId, resource, action }, 'Access denied');
logger.warn({ userId, resource }, 'Unauthorized access attempt');
```

### Data Access Events

```typescript
// Log sensitive data access
logger.info({ userId, dataType: 'pii', recordId }, 'PII data accessed');
logger.info({ userId, action: 'export', recordCount }, 'Data exported');
logger.warn({ userId, action: 'bulk_delete', recordCount }, 'Bulk deletion');
```

## Error Boundaries (Frontend)

```typescript
// React error boundary
class ErrorBoundary extends React.Component<Props, State> {
  state = { hasError: false, errorId: null };
  
  static getDerivedStateFromError(error: Error) {
    return { hasError: true };
  }
  
  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    // Log to error tracking service
    errorTracker.captureException(error, {
      extra: errorInfo,
      tags: { component: this.props.name },
    });
    
    // Generate error ID for user
    const errorId = generateErrorId();
    this.setState({ errorId });
  }
  
  render() {
    if (this.state.hasError) {
      return (
        <ErrorFallback 
          errorId={this.state.errorId}
          onRetry={() => this.setState({ hasError: false })}
        />
      );
    }
    return this.props.children;
  }
}
```

## Quality Checklist

### Error Handling

- [ ] **Fail-secure** - Deny by default, fail closed
- [ ] **Specific handling** - Different errors handled differently
- [ ] **No swallowed exceptions** - All errors logged or handled
- [ ] **Generic client messages** - No internal details exposed

### Logging

- [ ] **Structured logging** - Use proper logger, not console
- [ ] **Appropriate levels** - Error/warn/info used correctly
- [ ] **No sensitive data** - Passwords, tokens, PII never logged
- [ ] **Security events** - Auth, authz, data access logged

### Error Responses

- [ ] **Consistent format** - Standard error response structure
- [ ] **Request IDs** - For support correlation
- [ ] **No stack traces** - Never in production responses
- [ ] **Appropriate status codes** - 4xx vs 5xx correct

---

## Remember

**Errors are inevitable. How you handle them determines your security posture.**

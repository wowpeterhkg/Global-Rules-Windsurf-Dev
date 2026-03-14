# Rule 12 — Error Handling

## Core Principle

Fail secure. Log for debugging, not for attackers. Give users actionable messages, not stack traces.

## Quick Rules

- Generic errors to clients
- Detailed logs server-side
- Use structured logging
- Implement error boundaries (frontend)
- Never log passwords or tokens

## Backend Error Handling

### Standard Pattern

```javascript
import pino from 'pino';
const logger = pino();

app.post('/api/users', async (req, res) => {
  try {
    const user = await createUser(req.body);
    res.status(201).json(user);
  } catch (error) {
    // Log detailed error server-side
    logger.error({ err: error, body: req.body }, 'Failed to create user');
    
    // Generic message to client
    res.status(500).json({ error: 'Internal server error' });
  }
});
```

### Error Classification

```javascript
class AppError extends Error {
  constructor(message, statusCode, isOperational = true) {
    super(message);
    this.statusCode = statusCode;
    this.isOperational = isOperational;
  }
}

// Usage
throw new AppError('User not found', 404);
throw new AppError('Invalid email format', 400);
```

## Frontend Error Handling

### React Error Boundary

```tsx
class ErrorBoundary extends React.Component {
  state = { hasError: false, errorId: null };

  static getDerivedStateFromError(error) {
    return { hasError: true };
  }

  componentDidCatch(error, errorInfo) {
    const errorId = `ERR-${Date.now()}`;
    console.error({ errorId, error, errorInfo });
    this.setState({ errorId });
  }

  render() {
    if (this.state.hasError) {
      return (
        <div>
          <h2>Something went wrong</h2>
          <p>Error ID: {this.state.errorId}</p>
          <button onClick={() => window.location.reload()}>
            Refresh
          </button>
        </div>
      );
    }
    return this.props.children;
  }
}
```

### User-Friendly Messages

```typescript
const errorMessages = {
  'NETWORK_ERROR': 'Unable to connect. Check your internet.',
  'UNAUTHORIZED': 'Please log in to continue.',
  'NOT_FOUND': 'The requested item was not found.',
  'VALIDATION_ERROR': 'Please check your input.',
  'DEFAULT': 'Something went wrong. Please try again.',
};

function getUserMessage(errorCode) {
  return errorMessages[errorCode] || errorMessages['DEFAULT'];
}
```

## Logging Standards

### What to Log

- Request ID / correlation ID
- User ID (if authenticated)
- Action attempted
- Error type and message
- Timestamp

### What NOT to Log

- Passwords
- API keys / tokens
- Credit card numbers
- Personal health information
- Full request bodies with sensitive data

### Structured Log Example

```javascript
logger.error({
  requestId: req.id,
  userId: req.user?.id,
  action: 'createPayment',
  error: error.message,
  // NOT: password, cardNumber, etc.
});
```

## Checklist

- [ ] All errors caught and handled
- [ ] Generic messages to clients
- [ ] Detailed logs server-side
- [ ] No sensitive data in logs
- [ ] Error boundaries in frontend
- [ ] User-friendly error messages

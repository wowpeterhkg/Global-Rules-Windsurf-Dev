# Rule 14 — Code Generation Standards

## Core Principle

Generated code must be immediately runnable. Include all imports, dependencies, and configuration needed.

## Runnable Code Requirements

### Every Code Block Must

1. **Include all imports** at the top of the file
2. **Declare all dependencies** needed to run
3. **Handle all error cases** appropriately
4. **Follow existing project patterns** and conventions
5. **Be syntactically correct** and type-safe

### Import Organization

```typescript
// 1. External dependencies (alphabetical)
import express from 'express';
import { Pool } from 'pg';
import { z } from 'zod';

// 2. Internal absolute imports (alphabetical)
import { config } from '@/config';
import { logger } from '@/utils/logger';
import { UserService } from '@/services/user';

// 3. Internal relative imports (alphabetical)
import { validateInput } from './validation';
import { formatResponse } from './formatters';

// 4. Type imports (if separate)
import type { Request, Response } from 'express';
import type { User } from '@/types';
```

## Language-Specific Standards

### TypeScript/JavaScript

```typescript
// Always include type annotations for function parameters and returns
function processUser(userId: string, options?: ProcessOptions): Promise<User> {
  // Implementation
}

// Use strict null checks
const user = await getUser(id);
if (!user) {
  throw new NotFoundError(`User ${id} not found`);
}

// Prefer const over let
const items = [];
items.push(newItem); // OK - mutating array, not reassigning

// Use async/await over callbacks
// GOOD
const data = await fetchData();
// BAD
fetchData().then(data => { ... });
```

### Python

```python
# Standard library imports
import json
import os
from datetime import datetime
from typing import Optional, List, Dict

# Third-party imports
import requests
from pydantic import BaseModel

# Local imports
from app.config import settings
from app.models import User
from app.utils import validate_email

# Type hints for all functions
def process_user(user_id: str, options: Optional[Dict] = None) -> User:
    """Process a user with the given options."""
    pass

# Use dataclasses or Pydantic for data structures
@dataclass
class UserRequest:
    name: str
    email: str
    age: Optional[int] = None
```

### Go

```go
package main

import (
    // Standard library
    "context"
    "encoding/json"
    "fmt"
    "net/http"
    
    // Third-party
    "github.com/gorilla/mux"
    "go.uber.org/zap"
    
    // Internal
    "myapp/internal/config"
    "myapp/internal/models"
)

// Always handle errors explicitly
func processUser(ctx context.Context, userID string) (*User, error) {
    user, err := db.GetUser(ctx, userID)
    if err != nil {
        return nil, fmt.Errorf("failed to get user %s: %w", userID, err)
    }
    return user, nil
}
```

## Dependency Declaration

### Package.json (Node.js)

```json
{
  "name": "project-name",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.2",
    "pg": "^8.11.0",
    "zod": "^3.22.0"
  },
  "devDependencies": {
    "@types/express": "^4.17.17",
    "@types/node": "^20.0.0",
    "typescript": "^5.0.0"
  }
}
```

### Requirements.txt (Python)

```text
# requirements.txt
fastapi>=0.100.0
pydantic>=2.0.0
sqlalchemy>=2.0.0
python-dotenv>=1.0.0

# Development dependencies (requirements-dev.txt)
pytest>=7.0.0
pytest-asyncio>=0.21.0
black>=23.0.0
mypy>=1.0.0
```

### Go.mod (Go)

```go
module myapp

go 1.21

require (
    github.com/gorilla/mux v1.8.0
    go.uber.org/zap v1.24.0
    github.com/lib/pq v1.10.9
)
```

## Code Style Standards

### Naming Conventions

| Language | Variables | Functions | Classes | Constants |
|----------|-----------|-----------|---------|-----------|
| TypeScript | camelCase | camelCase | PascalCase | UPPER_SNAKE |
| Python | snake_case | snake_case | PascalCase | UPPER_SNAKE |
| Go | camelCase | PascalCase (exported) | PascalCase | PascalCase |

### File Naming

| Language | Convention | Example |
|----------|------------|---------|
| TypeScript | kebab-case | `user-service.ts` |
| Python | snake_case | `user_service.py` |
| Go | lowercase | `userservice.go` |

## Error Handling Patterns

### TypeScript

```typescript
// Custom error classes
class AppError extends Error {
  constructor(
    message: string,
    public statusCode: number = 500,
    public code: string = 'INTERNAL_ERROR'
  ) {
    super(message);
    this.name = 'AppError';
  }
}

class NotFoundError extends AppError {
  constructor(resource: string) {
    super(`${resource} not found`, 404, 'NOT_FOUND');
  }
}

// Usage
async function getUser(id: string): Promise<User> {
  const user = await db.users.findOne({ id });
  if (!user) {
    throw new NotFoundError(`User ${id}`);
  }
  return user;
}
```

### Python

```python
class AppError(Exception):
    def __init__(self, message: str, status_code: int = 500, code: str = "INTERNAL_ERROR"):
        self.message = message
        self.status_code = status_code
        self.code = code
        super().__init__(message)

class NotFoundError(AppError):
    def __init__(self, resource: str):
        super().__init__(f"{resource} not found", 404, "NOT_FOUND")

# Usage
async def get_user(user_id: str) -> User:
    user = await db.users.find_one({"id": user_id})
    if not user:
        raise NotFoundError(f"User {user_id}")
    return user
```

## Configuration Management

### Environment Variables

```typescript
// config.ts
import { z } from 'zod';

const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'production', 'test']),
  PORT: z.string().transform(Number).default('3000'),
  DATABASE_URL: z.string().url(),
  JWT_SECRET: z.string().min(32),
});

export const config = envSchema.parse(process.env);
```

### .env.example

```bash
# .env.example - Copy to .env and fill in values
NODE_ENV=development
PORT=3000
DATABASE_URL=postgresql://user:pass@localhost:5432/dbname
JWT_SECRET=your-secret-key-at-least-32-characters
```

## Documentation Standards

### Function Documentation

```typescript
/**
 * Process a payment for the given order.
 * 
 * @param orderId - Unique identifier for the order
 * @param paymentMethod - Payment method details
 * @returns Payment result with transaction ID
 * @throws {PaymentDeclinedError} When the card is declined
 * @throws {InsufficientFundsError} When balance is too low
 * 
 * @example
 * const result = await processPayment('order-123', {
 *   type: 'card',
 *   token: 'tok_visa'
 * });
 */
async function processPayment(
  orderId: string,
  paymentMethod: PaymentMethod
): Promise<PaymentResult> {
  // Implementation
}
```

## Quality Checklist

### Before Generating Code

- [ ] **Understand the context** - What exists, what's needed
- [ ] **Check existing patterns** - Follow project conventions
- [ ] **Identify dependencies** - What packages are needed

### Generated Code Must Have

- [ ] **All imports included** - Nothing missing
- [ ] **Type annotations** - For parameters and returns
- [ ] **Error handling** - All error cases covered
- [ ] **Documentation** - For public APIs
- [ ] **No hardcoded values** - Use config/constants

### After Generating Code

- [ ] **Syntax is correct** - No errors
- [ ] **Types are correct** - No type errors
- [ ] **Follows style guide** - Consistent with project
- [ ] **Is complete** - Can run without modification

---

## Remember

**Generated code should work on first run. If it needs modification to run, it's incomplete.**

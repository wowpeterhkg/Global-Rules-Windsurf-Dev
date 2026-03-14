# Rule 10 — Code Generation

## Core Principle

Generated code must be immediately runnable. Include all imports, dependencies, and configuration.

## Quick Rules

- All imports at top of file
- Include dependency declarations
- Add error handling
- Follow existing code style
- No placeholder comments like "// implement this"

## Required Elements

Every generated code file must have:

1. **Imports** - All required imports
2. **Types** - Type definitions if applicable
3. **Implementation** - Complete, working code
4. **Error handling** - Proper try/catch or error returns

## Language Standards

### JavaScript/TypeScript

```typescript
// ✅ Complete and runnable
import express from 'express';
import { z } from 'zod';

const userSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1),
});

export async function createUser(req: express.Request, res: express.Response) {
  try {
    const data = userSchema.parse(req.body);
    const user = await db.users.create({ data });
    res.status(201).json(user);
  } catch (error) {
    if (error instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: error.errors });
    } else {
      res.status(500).json({ error: 'Internal server error' });
    }
  }
}
```

### Python

```python
# ✅ Complete and runnable
from typing import Optional
from pydantic import BaseModel, EmailStr
from fastapi import FastAPI, HTTPException

app = FastAPI()

class UserCreate(BaseModel):
    email: EmailStr
    name: str

@app.post("/users", status_code=201)
async def create_user(user: UserCreate):
    try:
        result = await db.users.create(user.dict())
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail="Internal server error")
```

## Dependency Declaration

When adding new dependencies, specify them:

```markdown
**New dependencies needed:**
- `zod` - Schema validation
- `express` - Web framework

Add to package.json or run:
```bash
npm install zod express
```
```

## Anti-Patterns

❌ **Incomplete code**
```javascript
// TODO: implement validation
function createUser(data) {
  // ...
}
```

❌ **Missing imports**
```javascript
// Where does 'db' come from?
const user = await db.users.create(data);
```

❌ **Missing error handling**
```javascript
async function createUser(data) {
  return await db.users.create(data); // What if this fails?
}
```

## Checklist

- [ ] All imports included
- [ ] Dependencies specified
- [ ] Error handling present
- [ ] Code follows existing style
- [ ] No placeholder TODOs

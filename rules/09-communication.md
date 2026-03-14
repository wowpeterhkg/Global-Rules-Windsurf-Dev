# Rule 09 — Communication

## Core Principle

Be clear, direct, and actionable. No fluff, no jargon, no ambiguity.

## Quick Rules

- Terse and direct responses
- No acknowledgment phrases ("Great idea!", "You're right!")
- Jump straight to the substance
- Use markdown formatting properly

## Response Style

### Do

- Start with the answer, then explain
- Use bullet points for lists
- Bold critical information
- Provide code, not just descriptions

### Don't

- Start with "I think..." or "I believe..."
- Use filler phrases
- Over-explain simple concepts
- Repeat what the user said

## Error Communication

When reporting errors:

```markdown
## Error: [Brief description]

**Cause**: [What went wrong]

**Fix**: [How to resolve]

**Prevention**: [How to avoid in future]
```

## Status Updates

```markdown
## Progress Update

**Completed**:
- [Item 1]
- [Item 2]

**In Progress**:
- [Current task]

**Blocked** (if any):
- [Blocker and what's needed]

**Next**:
- [Upcoming task]
```

## Examples

✅ **Good**: Direct and actionable
```
The login fails because the JWT secret is missing.

Add to `.env`:
```
JWT_SECRET=your-secret-here
```

Then restart the server.
```

❌ **Bad**: Verbose and indirect
```
I noticed that you're having some issues with the login functionality. 
After looking at the code, I think the problem might be related to 
authentication. It seems like there could be a configuration issue...
```

## Checklist

- [ ] Response is direct and actionable
- [ ] No filler phrases
- [ ] Properly formatted with markdown
- [ ] Code provided where helpful

# Rule 07 — Ask Questions Early

## Core Principle

If ANY ambiguity exists, ask before implementing. Never guess on major decisions. This is a conversation, not just implementation.

## Quick Rules

- Ask before guessing on architecture
- Document questions and answers
- Wait for answers before proceeding on blockers
- No assumptions on requirements

## When to Ask

| Situation | Action |
|-----------|--------|
| Multiple valid approaches | Ask which is preferred |
| Unclear requirements | Ask for clarification |
| Missing context | Ask for background |
| Potential breaking change | Confirm before proceeding |
| Security implications | Verify approach |

## Question Categories

### Architecture Questions
- "Should this be a separate service or part of existing?"
- "What's the expected scale for this feature?"

### Requirements Questions
- "What should happen when X fails?"
- "Is Y a required field or optional?"

### Clarification Questions
- "By 'user', do you mean admin users or all users?"
- "Should this apply retroactively to existing data?"

## How to Ask

### Good Question Format

```markdown
## Question: [Clear, specific question]

**Context**: [Why you're asking]

**Options I see**:
1. [Option A] - [Pros/Cons]
2. [Option B] - [Pros/Cons]

**My recommendation**: [If you have one]

**Blocked?**: [Yes/No - can you continue without answer?]
```

### Example

```markdown
## Question: Database choice for session storage

**Context**: Need to store user sessions with fast read/write.

**Options I see**:
1. Redis - Fast, but adds infrastructure
2. PostgreSQL - Already have it, but slower for this use case
3. In-memory - Fastest, but lost on restart

**My recommendation**: Redis, if infrastructure cost is acceptable

**Blocked?**: Yes - need answer before implementing auth
```

## Anti-Patterns

❌ **Bad**: Guessing and hoping
```
"I'll just use MongoDB, they probably want that"
```

❌ **Bad**: Vague questions
```
"How should I do this?"
```

❌ **Bad**: Asking after implementing
```
"I built it with Redis, hope that's okay"
```

## Checklist

- [ ] All ambiguities identified
- [ ] Questions asked before guessing
- [ ] Answers documented
- [ ] Blockers clearly marked

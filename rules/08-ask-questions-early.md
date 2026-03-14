# Rule 8 — Ask Questions Early

## Core Principle

If ANY ambiguity exists, create a question file and ask. Never guess on major decisions.

> **From detritus `/plan` workflow**: This is a conversation, not an implementation. Analyze, plan, provide insights, ask questions — then wait for answers before proceeding.

## When to Ask Questions

### Mandatory Question Triggers

If ANY of the following occur, STOP and ask:

- **Decision is ambiguous** - Multiple valid interpretations exist
- **Requirements conflict** - Two requirements contradict each other
- **Plans seem incomplete** - Missing information needed to proceed
- **Something feels "off"** - Intuition says something is wrong
- **Trade-offs exist** - Multiple approaches with different pros/cons
- **Scope is unclear** - Boundaries of the work aren't defined
- **Dependencies unknown** - External factors that could affect the work

### Question Categories

| Category | Example |
|----------|---------|
| **Clarification** | "Should the user see an error or be silently redirected?" |
| **Trade-off** | "Do we prioritize speed or accuracy for this feature?" |
| **Scope** | "Should this include mobile support or just desktop?" |
| **Priority** | "If we can't do both, which is more important?" |
| **Technical** | "Should we use REST or GraphQL for this API?" |
| **Business** | "What happens if the payment fails mid-transaction?" |

## Question Documentation

### Question File Structure

Create question files in `.questions/` directory:

```
.questions/
├── open/
│   ├── TEAM_001_auth-flow-ambiguity.md
│   └── TEAM_003_payment-edge-cases.md
├── answered/
│   └── TEAM_002_database-choice.md
└── blocked/
    └── TEAM_001_external-api-dependency.md
```

### Question File Template

```markdown
# Question: [Brief Title]

## Metadata
- **Team ID**: TEAM_XXX
- **Asked By**: [User Full Name]
- **Date**: [Date/Time]
- **Status**: open | answered | blocked
- **Priority**: critical | high | medium | low
- **Blocking**: [What work is blocked by this question]

## Context
[Background information needed to understand the question]

## Question
[The specific question being asked]

## Options Considered
1. **Option A**: [Description]
   - Pros: [Benefits]
   - Cons: [Drawbacks]

2. **Option B**: [Description]
   - Pros: [Benefits]
   - Cons: [Drawbacks]

## Recommendation
[Your suggested approach and reasoning, if any]

## Answer
[Filled in when question is answered]
- **Answered By**: [Name]
- **Date**: [Date/Time]
- **Decision**: [The decision made]
- **Reasoning**: [Why this decision was made]
```

## The Plan Workflow (from detritus)

### Before Implementation

> ⛔ **CRITICAL**: When analyzing requirements, this is a CONVERSATION, not an implementation.

1. **DO NOT** call any file editing tools
2. **DO NOT** run any commands that modify the codebase
3. **ONLY** produce: Analysis, Plan, Insights, Questions
4. **ALWAYS** end with questions and wait for user response

### Analysis Output Format

```markdown
## Analysis
[Brief summary of what's being asked]

## Findings
[Relevant code/patterns discovered]

## Plan
[Proposed implementation steps]

## Insights
- [Insight about edge cases]
- [Insight about performance]
- [Insight about existing patterns]

## Questions
1. [Question about ambiguity]
2. [Question about trade-off]
3. [Question about scope]

---
⛔ STOP HERE - Waiting for answers before proceeding
```

## Truthseeker Principles (from detritus)

### Core Mandate

**Push back when facts and evidence demand it — including against the user.**

Do not ask permission. Do not soften challenges. If something appears wrong, unproven, or assumed — say so directly.

### When User Makes an Assertion

❌ "Okay, I'll implement that"  
✅ "What evidence supports this? Have you tested X? The docs suggest Y instead."

### When About to Assume

❌ Proceed based on "this probably works"  
✅ "I haven't proven this works. Let me verify first."

### When Convenient Explanation Appears

❌ "It's probably a timing issue"  
✅ "I have no evidence of timing. Let me prove what's actually happening."

## Question Quality Standards

### Good Questions

```markdown
## Question: User Session Timeout Behavior

### Context
The requirements say "sessions should timeout after inactivity" but don't specify:
- What counts as "activity"
- How long the timeout should be
- What happens to unsaved work

### Question
1. Should mouse movement count as activity, or only explicit actions?
2. What is the timeout duration? (15 min, 30 min, 1 hour?)
3. Should we auto-save before timeout, or warn the user?

### Options
1. **Aggressive timeout (15 min, no auto-save)**: More secure, but user may lose work
2. **Gentle timeout (30 min, with warning)**: Less secure, but better UX
3. **Smart timeout (activity-based, auto-save)**: Best UX, more complex to implement
```

### Bad Questions

```markdown
## Question: How should I do this?

I'm not sure how to implement the feature. What should I do?

[Too vague - doesn't provide context, options, or specific issues]
```

## Integration with Team Workflow

### Linking Questions to Teams

```markdown
// In team file
## Questions Raised
- **2024-01-15 10:30**: Session timeout behavior - `.questions/open/TEAM_001_session-timeout.md`
- **2024-01-15 14:00**: Payment retry logic - `.questions/open/TEAM_001_payment-retry.md`
```

### Question Resolution

When a question is answered:

1. **Move file** from `open/` to `answered/`
2. **Fill in Answer section** with decision and reasoning
3. **Update team file** with resolution
4. **Proceed with implementation** based on answer

## Anti-Patterns

### ❌ Guessing Instead of Asking

```typescript
// DON'T: Guess at ambiguous requirements
function calculateDiscount(order) {
  // I think they want 10% off? Not sure...
  return order.total * 0.9;
}
```

### ❌ Asking Too Late

```typescript
// DON'T: Ask after implementing
// "By the way, I implemented it with 10% discount. Was that right?"
```

### ❌ Asking Without Context

```
// DON'T: Vague questions
"How should the discount work?"
```

### ✅ Correct Approach

```markdown
## Question: Discount Calculation Method

### Context
The requirements mention "apply discount to orders" but don't specify:
- Percentage vs fixed amount
- Whether it applies to subtotal or total (after tax)
- Whether it stacks with other promotions

### Question
Which discount method should we implement?

### Options
1. **10% off subtotal**: Simple, doesn't affect tax calculation
2. **10% off total**: Includes tax in discount, more complex
3. **Fixed $10 off**: Predictable, but may not scale with order size
```

## Quality Checklist

### Before Proceeding Without Asking

- [ ] **Requirements are unambiguous** - Only one valid interpretation
- [ ] **No conflicting information** - All sources agree
- [ ] **Scope is clear** - Boundaries are well-defined
- [ ] **Trade-offs are decided** - No open choices to make
- [ ] **Dependencies are known** - External factors are understood

### Question Quality Check

- [ ] **Context provided** - Reader can understand the situation
- [ ] **Specific question** - Not vague or open-ended
- [ ] **Options listed** - Possible answers are enumerated
- [ ] **Pros/cons included** - Trade-offs are explained
- [ ] **Recommendation given** - Your suggested approach (if any)

---

## Remember

**A question asked early saves hours of rework. Never guess on major decisions.**

# Rule 17 — Tool Usage Guidelines

## Core Principle

Use tools strategically. Gather information before making changes. Prefer precise tools over broad searches.

## Tool Selection Strategy

### Information Gathering First

Before making any code changes:

1. **Understand the codebase** - Read relevant files
2. **Find existing patterns** - Search for similar implementations
3. **Identify dependencies** - Understand what will be affected
4. **Verify assumptions** - Don't guess, confirm

### Tool Categories

| Category | Purpose | When to Use |
|----------|---------|-------------|
| **Search** | Find code, patterns | Starting any task |
| **Read** | Understand existing code | Before modifying |
| **Edit** | Make precise changes | After understanding |
| **Run** | Execute commands | Testing, building |
| **Create** | New files | Only when needed |

## Search Tools

### Code Search (Preferred for Starting)

```
Use code_search for:
- Finding where functionality is implemented
- Locating similar patterns to follow
- Understanding code structure
- Starting any investigation
```

### Grep Search (For Specific Patterns)

```
Use grep_search for:
- Finding exact string matches
- Locating all usages of a function
- Finding configuration values
- Searching for specific patterns
```

### File Search (For Navigation)

```
Use find_by_name for:
- Locating files by name pattern
- Finding configuration files
- Discovering project structure
- Locating test files
```

## Read Before Write

### Always Read First

```markdown
## Correct Workflow

1. ✅ Read the file to understand current state
2. ✅ Identify the exact location for changes
3. ✅ Understand surrounding context
4. ✅ Make precise, minimal edits

## Incorrect Workflow

1. ❌ Assume file contents
2. ❌ Make broad changes without reading
3. ❌ Overwrite without understanding
```

### Reading Strategies

```markdown
## For Small Files (< 500 lines)
- Read entire file to understand structure
- Note imports, exports, and dependencies

## For Large Files (> 500 lines)
- Read specific sections relevant to task
- Use line offsets to focus on areas of interest
- Search within file for specific functions

## For Unknown Codebases
- Start with README, package.json, or main entry point
- Follow imports to understand structure
- Read tests to understand expected behavior
```

## Edit Tools

### Prefer Minimal Edits

```typescript
// GOOD: Precise, minimal edit
// Change only what's needed
old_string: "const timeout = 5000;"
new_string: "const timeout = 10000;"

// BAD: Overly broad edit
// Replacing entire file when only one line needs change
```

### Multi-Edit for Related Changes

```typescript
// Use multi_edit when:
// - Multiple related changes in same file
// - Renaming a variable across file
// - Adding imports AND using them

// Example: Add import and use it
edits: [
  { old_string: "import { a } from 'lib';", 
    new_string: "import { a, b } from 'lib';" },
  { old_string: "const result = a();",
    new_string: "const result = a();\nconst other = b();" }
]
```

### Edit Safety Rules

1. **Never edit without reading first**
2. **Make smallest possible change**
3. **Preserve existing formatting**
4. **Don't add/remove comments unless asked**
5. **Verify edit succeeded**

## Command Execution

### Safe vs Unsafe Commands

```markdown
## Safe to Auto-Run
- Read-only commands (ls, cat, grep)
- Build commands (npm run build, go build)
- Test commands (npm test, pytest)
- Lint commands (eslint, golangci-lint)

## Require User Approval
- Install commands (npm install, pip install)
- Delete commands (rm, del)
- Git commands that modify (commit, push)
- Database commands
- Network requests to external services
```

### Command Best Practices

```bash
# Always specify working directory
cwd: "/path/to/project"

# Use non-blocking for long-running processes
Blocking: false  # For dev servers, watchers

# Use blocking for quick commands
Blocking: true   # For builds, tests, lints
```

## File Creation

### When to Create Files

```markdown
## Create New Files When:
- Implementing new feature that needs new module
- Adding tests for new functionality
- Creating configuration files
- User explicitly requests new file

## Don't Create Files When:
- Existing file can be extended
- Similar functionality exists elsewhere
- File would duplicate existing code
- Temporary/debug files
```

### File Creation Checklist

- [ ] **File doesn't already exist** - Check first
- [ ] **Location is appropriate** - Follows project structure
- [ ] **Name follows conventions** - Matches project style
- [ ] **Content is complete** - All imports, exports included

## Tool Workflow Examples

### Adding a New Feature

```markdown
1. **Search** - Find similar features for patterns
2. **Read** - Understand existing implementation
3. **Plan** - Determine files to modify/create
4. **Edit** - Make changes to existing files
5. **Create** - Add new files if needed
6. **Run** - Test the changes
7. **Verify** - Confirm feature works
```

### Fixing a Bug

```markdown
1. **Search** - Find error message or related code
2. **Read** - Understand the buggy code
3. **Analyze** - Identify root cause
4. **Read** - Check related code for impact
5. **Edit** - Fix the bug with minimal change
6. **Run** - Run tests to verify fix
7. **Run** - Run related tests for regression
```

### Refactoring Code

```markdown
1. **Search** - Find all usages of code to refactor
2. **Read** - Understand current implementation
3. **Read** - Check all call sites
4. **Plan** - Determine safe refactoring approach
5. **Edit** - Make refactoring changes
6. **Run** - Run full test suite
7. **Verify** - Confirm no regressions
```

## Anti-Patterns

### ❌ Edit Without Reading

```markdown
# DON'T
"I'll add this function to the file"
[Makes edit without reading file first]

# DO
"Let me read the file first to understand its structure"
[Reads file, then makes informed edit]
```

### ❌ Broad Search When Specific Needed

```markdown
# DON'T
Search for "function" in entire codebase

# DO
Search for "processPayment" in src/payments/
```

### ❌ Creating Duplicate Files

```markdown
# DON'T
Create new utils.ts when one already exists

# DO
Check for existing utils, extend if appropriate
```

### ❌ Running Unsafe Commands Automatically

```markdown
# DON'T
Auto-run: rm -rf node_modules

# DO
Ask user approval for destructive commands
```

## Quality Checklist

### Before Any Task

- [ ] **Searched for context** - Understand what exists
- [ ] **Read relevant files** - Know current state
- [ ] **Identified patterns** - Follow existing conventions
- [ ] **Planned approach** - Know what to change

### During Task

- [ ] **Minimal edits** - Change only what's needed
- [ ] **Preserved formatting** - Match existing style
- [ ] **Verified changes** - Confirmed edits applied
- [ ] **Tested changes** - Ran relevant tests

### After Task

- [ ] **All tests pass** - No regressions
- [ ] **Code compiles** - No syntax errors
- [ ] **Changes documented** - Team file updated

---

## Remember

**Tools are powerful. Use them precisely and deliberately.**

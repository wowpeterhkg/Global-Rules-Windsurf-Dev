# Rule 13 — Tool Usage

## Core Principle

Use tools strategically. Gather information before making changes. Prefer precise tools over broad searches.

## Quick Rules

- Read before editing
- Use code_search for exploration
- Minimal, focused edits
- Batch independent operations
- Never guess file contents

## Tool Selection

| Need | Tool |
|------|------|
| Find code by concept | `code_search` |
| Find by exact text | `grep_search` |
| Find by filename | `find_by_name` |
| Read file contents | `read_file` |
| Make changes | `edit` or `multi_edit` |
| Run commands | `run_command` |

## Search Strategy

### Start Broad, Then Narrow

```
1. code_search - "Find where user authentication is handled"
2. grep_search - Find specific function name
3. read_file - Read the relevant file
4. edit - Make targeted changes
```

### Search Before Editing

```
❌ WRONG: Edit file without reading
edit("src/auth.js", oldCode, newCode)  // How do you know oldCode?

✅ CORRECT: Read first
read_file("src/auth.js")
// Now you know the actual content
edit("src/auth.js", actualOldCode, newCode)
```

## Edit Best Practices

### Minimal Changes

```javascript
// ❌ WRONG: Replace entire function
edit(file, entireOldFunction, entireNewFunction)

// ✅ CORRECT: Change only what's needed
edit(file, 
  "return user.name",
  "return user.name || 'Anonymous'"
)
```

### Multi-Edit for Related Changes

```javascript
// When making multiple related changes to one file
multi_edit(file, [
  { old: "import { a }", new: "import { a, b }" },
  { old: "const x = a()", new: "const x = a()\nconst y = b()" }
])
```

## Command Safety

### Safe to Auto-Run

- `ls`, `cat`, `head`, `tail`
- `git status`, `git log`, `git diff`
- `npm list`, `pip list`
- Read-only operations

### Requires Approval

- `npm install`, `pip install`
- `git commit`, `git push`
- File deletion
- Database operations
- Network requests

## Checklist

- [ ] Read file before editing
- [ ] Used appropriate search tool
- [ ] Edits are minimal and focused
- [ ] Commands are safe or approved
- [ ] No guessing at file contents

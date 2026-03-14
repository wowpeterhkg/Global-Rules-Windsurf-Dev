# Rule 18 — Development Workflow

## Core Principle

Use proper version control. Follow semantic versioning. Maintain a changelog. Test before merging.

## Quick Rules

- Feature branches from main
- Meaningful commit messages
- Semantic versioning
- Changelog for every release

## Branch Strategy

```
main          - Production-ready code
├── feature/* - New features
├── bugfix/*  - Bug fixes
├── hotfix/*  - Urgent production fixes
└── release/* - Release preparation
```

### Branch Naming

```bash
# Good
feature/user-authentication
bugfix/login-timeout
hotfix/security-patch-xss

# Bad
fix
my-branch
test123
```

## Commit Messages

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation
- `refactor` - Code change (no feature/fix)
- `test` - Adding tests
- `chore` - Maintenance

### Examples

```
feat(auth): add JWT token refresh

Implement automatic token refresh when access token expires.
Refresh tokens are stored securely and rotated on each use.

Closes #123
```

## Semantic Versioning

```
MAJOR.MINOR.PATCH

MAJOR - Breaking changes
MINOR - New features (backward compatible)
PATCH - Bug fixes (backward compatible)
```

### Examples

- `1.0.0` → `2.0.0` - Breaking API change
- `1.0.0` → `1.1.0` - New feature added
- `1.0.0` → `1.0.1` - Bug fix

## Changelog

```markdown
# Changelog

## [1.2.0] - 2024-01-15

### Added
- User authentication with JWT (#123)

### Fixed
- Login timeout on slow connections (#125)

### Security
- Updated dependencies for CVE-2024-1234
```

## CI/CD Pipeline

```yaml
# Minimum pipeline stages
1. Lint - Code style checks
2. Test - Unit and integration tests
3. Build - Compile/bundle
4. Deploy - To appropriate environment
```

## Checklist

- [ ] Working on feature branch
- [ ] Commits follow convention
- [ ] Tests pass locally
- [ ] PR created with description
- [ ] Changelog updated (for releases)

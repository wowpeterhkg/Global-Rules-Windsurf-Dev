# Rule 22 — Development Workflow

## Core Principle

Use proper version control, implement code review processes, test in multiple environments, follow semantic versioning, and maintain a changelog.

## Version Control Standards

### Branch Strategy

```markdown
## Branch Types

### Main Branches
- `main` - Production-ready code, always deployable
- `develop` - Integration branch for features (optional)

### Supporting Branches
- `feature/<name>` - New features
- `bugfix/<name>` - Bug fixes
- `hotfix/<name>` - Urgent production fixes
- `release/<version>` - Release preparation
```

### Branch Naming

```bash
# Good branch names
feature/user-authentication
feature/JIRA-123-payment-integration
bugfix/login-timeout-error
hotfix/security-patch-xss
release/v2.1.0

# Bad branch names
fix
my-branch
test123
wip
```

### Commit Message Standards

```markdown
## Format
<type>(<scope>): <subject>

<body>

<footer>

## Types
- feat: New feature
- fix: Bug fix
- docs: Documentation only
- style: Formatting, no code change
- refactor: Code change, no new feature or fix
- perf: Performance improvement
- test: Adding tests
- chore: Maintenance tasks

## Examples
feat(auth): add JWT token refresh mechanism

Implement automatic token refresh when access token expires.
Refresh tokens are stored securely and rotated on each use.

Closes #123

---

fix(payment): handle declined card errors gracefully

Previously, declined cards caused unhandled exceptions.
Now returns proper error response to client.

Fixes #456
```

## Code Review Process

### Pull Request Requirements

```markdown
## PR Checklist

### Before Creating PR
- [ ] Code compiles without errors
- [ ] All tests pass locally
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Commit messages follow standards

### PR Description Template
## Summary
[Brief description of changes]

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

## Screenshots (if applicable)
[Add screenshots for UI changes]

## Related Issues
Closes #[issue number]
```

### Review Timeline

| PR Size | Expected Review Time |
|---------|---------------------|
| Small (< 100 lines) | Same day |
| Medium (100-500 lines) | 1-2 days |
| Large (> 500 lines) | Consider splitting |

## Environment Management

### Environment Types

```markdown
## Standard Environments

### Development
- Purpose: Active development
- Data: Synthetic/mock data
- Access: All developers

### Staging
- Purpose: Pre-production testing
- Data: Anonymized production-like data
- Access: Development team + QA

### Production
- Purpose: Live system
- Data: Real user data
- Access: Restricted, audited
```

### Environment Configuration

```bash
# .env.example - Template for all environments
NODE_ENV=development
DATABASE_URL=postgresql://localhost:5432/app_dev
REDIS_URL=redis://localhost:6379
API_KEY=your-api-key-here
LOG_LEVEL=debug

# Environment-specific files (not committed)
.env.development
.env.staging
.env.production
```

### Environment Parity

```markdown
## Keep Environments Similar

### Must Match Production
- Database type and version
- Cache configuration
- API versions
- Authentication flow

### May Differ
- Resource allocation (smaller in dev)
- Data volume
- External service endpoints (use sandboxes)
- Logging verbosity
```

## Semantic Versioning

### Version Format

```markdown
## MAJOR.MINOR.PATCH

### MAJOR (X.0.0)
Increment when making incompatible API changes
- Breaking changes to public API
- Removal of deprecated features
- Major architectural changes

### MINOR (0.X.0)
Increment when adding functionality in backward-compatible manner
- New features
- New API endpoints
- Deprecation notices (not removal)

### PATCH (0.0.X)
Increment when making backward-compatible bug fixes
- Bug fixes
- Security patches
- Performance improvements
- Documentation updates
```

### Pre-Release Versions

```markdown
## Pre-Release Identifiers

### Alpha (unstable, incomplete)
1.0.0-alpha.1
1.0.0-alpha.2

### Beta (feature complete, may have bugs)
1.0.0-beta.1
1.0.0-beta.2

### Release Candidate (ready for release)
1.0.0-rc.1
1.0.0-rc.2
```

## Changelog Management

### Changelog Format

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- New feature description

### Changed
- Change description

### Deprecated
- Deprecation notice

### Removed
- Removal description

### Fixed
- Bug fix description

### Security
- Security fix description

## [1.2.0] - 2024-01-15

### Added
- User authentication with JWT tokens (#123)
- Password reset functionality (#124)

### Fixed
- Login timeout issue on slow connections (#125)

### Security
- Updated dependencies to patch CVE-2024-1234

## [1.1.0] - 2024-01-01
...
```

### Changelog Best Practices

```markdown
## Do
- Write for humans, not machines
- Group changes by type
- Include issue/PR references
- Note breaking changes prominently
- Keep entries concise but informative

## Don't
- Include every commit
- Use technical jargon unnecessarily
- Forget to update before release
- Mix multiple versions in one entry
```

## Release Process

### Release Checklist

```markdown
## Pre-Release

### Code Quality
- [ ] All tests pass
- [ ] Code review completed
- [ ] No critical bugs open
- [ ] Performance benchmarks acceptable

### Documentation
- [ ] Changelog updated
- [ ] Version number bumped
- [ ] API documentation current
- [ ] Migration guide (if breaking changes)

### Testing
- [ ] Staging deployment successful
- [ ] QA sign-off received
- [ ] Security scan passed
- [ ] Load testing completed (if applicable)

## Release

### Deployment
- [ ] Create release branch/tag
- [ ] Deploy to production
- [ ] Verify deployment successful
- [ ] Monitor for errors

### Communication
- [ ] Release notes published
- [ ] Team notified
- [ ] Users notified (if applicable)
- [ ] Documentation site updated

## Post-Release

### Monitoring
- [ ] Error rates normal
- [ ] Performance metrics stable
- [ ] User feedback monitored
- [ ] Rollback plan ready
```

## CI/CD Pipeline

### Pipeline Stages

```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm ci
      - run: npm run lint

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm ci
      - run: npm test

  build:
    runs-on: ubuntu-latest
    needs: [lint, test]
    steps:
      - uses: actions/checkout@v3
      - run: npm ci
      - run: npm run build

  deploy-staging:
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/develop'
    steps:
      - run: echo "Deploy to staging"

  deploy-production:
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/main'
    steps:
      - run: echo "Deploy to production"
```

## Quality Checklist

### Daily Workflow

- [ ] **Pull latest** before starting work
- [ ] **Create feature branch** from main/develop
- [ ] **Commit frequently** with good messages
- [ ] **Push regularly** to backup work
- [ ] **Create PR** when feature complete

### Release Workflow

- [ ] **Version bumped** appropriately
- [ ] **Changelog updated** with all changes
- [ ] **Tests pass** in all environments
- [ ] **Documentation current** for release
- [ ] **Stakeholders notified** of release

---

## Remember

**Good process enables good code. Follow the workflow, ship with confidence.**

# Rule 15 — Dependencies

## Core Principle

Only use well-maintained packages with strong security records. Flag anything stale or risky.

## Quick Rules

- Check last update date (< 12 months)
- Review security advisories
- Prefer popular, maintained packages
- Pin versions in lock files
- Audit regularly

## Package Selection Criteria

| Criteria | Requirement |
|----------|-------------|
| Last update | Within 12 months |
| Open issues | Reasonable response time |
| Security | No unpatched CVEs |
| Popularity | Established user base |
| License | Compatible with project |

## Red Flags

🚩 **Avoid packages that**:

- Haven't been updated in 12+ months
- Have unaddressed security vulnerabilities
- Have a single maintainer with no activity
- Have declining download trends
- Have unclear or restrictive licenses

## Version Pinning

### Lock Files (Required)

```bash
# JavaScript - commit package-lock.json or yarn.lock
npm ci  # Use ci, not install, in CI/CD

# Python - commit requirements.txt with versions
pip freeze > requirements.txt

# Go - commit go.sum
go mod tidy
```

### Semantic Versioning

```json
{
  "dependencies": {
    "express": "^4.18.0",  // Minor updates OK
    "lodash": "~4.17.21",  // Patch updates only
    "critical-lib": "4.17.21"  // Exact version
  }
}
```

## Security Scanning

### Regular Audits

```bash
# JavaScript
npm audit
npm audit fix

# Python
pip-audit
safety check

# Go
govulncheck ./...
```

### CI Integration

```yaml
# GitHub Actions example
- name: Security audit
  run: npm audit --audit-level=high
```

## Dependency Updates

### Update Strategy

1. **Security patches** - Apply immediately
2. **Patch versions** - Weekly
3. **Minor versions** - Monthly, with testing
4. **Major versions** - Quarterly, with planning

### Before Updating

- [ ] Read changelog
- [ ] Check for breaking changes
- [ ] Run full test suite
- [ ] Test in staging first

## Checklist

- [ ] All packages recently maintained
- [ ] No known vulnerabilities
- [ ] Lock file committed
- [ ] Regular audits scheduled
- [ ] Update strategy defined

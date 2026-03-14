# Rule 19 — Dependency Management

## Core Principle

Only suggest well-maintained packages with recent updates and strong security track records. Flag any dependencies that haven't been updated in 12+ months.

## Package Selection Criteria

### Required Criteria

| Criterion | Requirement |
|-----------|-------------|
| Last update | Within 12 months |
| Security vulnerabilities | None known (or patched) |
| Maintenance status | Active maintainer(s) |
| License | Compatible with project |
| Documentation | Adequate for use case |

### Preferred Criteria

| Criterion | Preference |
|-----------|------------|
| Downloads/Stars | High adoption indicates reliability |
| Test coverage | Well-tested packages preferred |
| TypeScript support | Native types or @types package |
| Bundle size | Smaller is better for frontend |
| Dependencies | Fewer transitive deps preferred |

## Dependency Audit Process

### Before Adding a Dependency

```markdown
## Dependency Evaluation Checklist

### Package: [name]
- [ ] **Last updated**: [date] - Within 12 months?
- [ ] **Security audit**: No known vulnerabilities?
- [ ] **License**: Compatible with project?
- [ ] **Maintenance**: Active maintainer(s)?
- [ ] **Alternatives**: Is this the best option?
- [ ] **Necessity**: Can we avoid this dependency?

### Research
- NPM/PyPI page: [link]
- GitHub repo: [link]
- Security advisories: [link]
- Alternatives considered: [list]
```

### Checking Package Health

```bash
# NPM - Check package info
npm view <package> time.modified
npm view <package> repository.url
npm audit

# Python - Check package info
pip show <package>
pip-audit

# Go - Check module info
go list -m -versions <module>
govulncheck ./...
```

## Version Pinning Strategy

### Lock Files Are Mandatory

```bash
# Always commit lock files
package-lock.json  # npm
yarn.lock          # yarn
pnpm-lock.yaml     # pnpm
Pipfile.lock       # pipenv
poetry.lock        # poetry
go.sum             # go modules
```

### Version Specification

```json
// package.json
{
  "dependencies": {
    // GOOD: Specific minor version with patch updates
    "express": "^4.18.0",
    
    // ACCEPTABLE: Exact version for critical deps
    "stripe": "12.0.0",
    
    // BAD: Too loose, may break
    "lodash": "*",
    "moment": ">=2.0.0"
  }
}
```

### Semantic Versioning Understanding

```markdown
## Version Format: MAJOR.MINOR.PATCH

- **MAJOR**: Breaking changes - review before updating
- **MINOR**: New features, backward compatible - usually safe
- **PATCH**: Bug fixes - generally safe

## Caret (^) vs Tilde (~)
- `^1.2.3` → Allows 1.x.x (minor + patch updates)
- `~1.2.3` → Allows 1.2.x (patch updates only)
```

## Security Vulnerability Management

### Regular Scanning

```bash
# Run weekly or on CI
npm audit
pip-audit
govulncheck ./...
snyk test
```

### Vulnerability Response

```markdown
## When Vulnerability Found

### Critical/High Severity
1. **Immediate action** - Update or patch within 24 hours
2. **If no patch available** - Evaluate workarounds or removal
3. **Document** - Record in security log

### Medium Severity
1. **Plan update** - Include in next sprint
2. **Evaluate impact** - Is the vulnerable code path used?
3. **Document** - Track in issue tracker

### Low Severity
1. **Track** - Add to technical debt backlog
2. **Update opportunistically** - With other updates
```

## Dependency Update Strategy

### Regular Updates

```markdown
## Monthly Dependency Review

1. **Run audit** - Check for vulnerabilities
2. **Check outdated** - List packages needing updates
3. **Review changelogs** - Understand what changed
4. **Update in batches** - Group related updates
5. **Test thoroughly** - Full test suite after updates
6. **Document** - Record updates in changelog
```

### Update Commands

```bash
# Check outdated packages
npm outdated
pip list --outdated
go list -m -u all

# Update specific package
npm update <package>
pip install --upgrade <package>
go get -u <module>

# Update all (use with caution)
npm update
pip-compile --upgrade
go get -u ./...
```

## Avoiding Dependency Bloat

### Questions Before Adding

1. **Is this necessary?** - Can we implement it ourselves in < 100 lines?
2. **Is there a smaller alternative?** - date-fns vs moment.js
3. **Do we need the whole package?** - Can we import just what we need?
4. **What are the transitive dependencies?** - How much are we really adding?

### Bundle Size Awareness

```bash
# Check bundle impact (JavaScript)
npx bundlephobia <package>
npx size-limit

# Check dependency tree
npm ls --all
pip show --files <package>
```

### Prefer Standard Library

```typescript
// DON'T: Add dependency for simple tasks
import leftPad from 'left-pad';
const result = leftPad('foo', 5);

// DO: Use built-in methods
const result = 'foo'.padStart(5);
```

## Deprecated Package Handling

### Identifying Deprecated Packages

```bash
# NPM shows deprecation warnings
npm install <package>
# "npm WARN deprecated <package>: ..."

# Check package status
npm view <package> deprecated
```

### Migration Process

```markdown
## Deprecated Package Migration

### Package: [deprecated-package]
- **Deprecated since**: [date]
- **Reason**: [why deprecated]
- **Replacement**: [new package]
- **Migration effort**: [estimate]

### Migration Steps
1. [ ] Identify all usages
2. [ ] Review replacement API
3. [ ] Create migration plan
4. [ ] Update code incrementally
5. [ ] Remove old package
6. [ ] Update documentation
```

## Monorepo Considerations

### Shared Dependencies

```json
// Root package.json
{
  "workspaces": ["packages/*"],
  "devDependencies": {
    // Shared dev tools at root
    "typescript": "^5.0.0",
    "eslint": "^8.0.0"
  }
}

// packages/app/package.json
{
  "dependencies": {
    // Package-specific deps
    "react": "^18.0.0"
  }
}
```

### Version Consistency

```bash
# Ensure consistent versions across packages
npx syncpack list-mismatches
npx syncpack fix-mismatches
```

## Quality Checklist

### Adding Dependencies

- [ ] **Evaluated necessity** - Can't easily implement ourselves
- [ ] **Checked maintenance** - Updated within 12 months
- [ ] **Verified security** - No known vulnerabilities
- [ ] **Reviewed license** - Compatible with project
- [ ] **Considered alternatives** - Best option selected
- [ ] **Documented decision** - Why this package

### Maintaining Dependencies

- [ ] **Regular audits** - Monthly security scans
- [ ] **Update schedule** - Regular update cadence
- [ ] **Lock files committed** - Reproducible builds
- [ ] **Deprecated packages tracked** - Migration planned

---

## Remember

**Every dependency is a liability. Add them thoughtfully, maintain them diligently, remove them when possible.**

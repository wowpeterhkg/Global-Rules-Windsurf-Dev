# Rule 4 — Behavioral Regression Protection

## Core Principle
Every project must define baseline outputs for critical behavior and protect against regressions.

## Baseline Definition

### What Needs Baselines
Critical behavior includes:

- **API responses** - Expected output formats and values
- **User interface behavior** - Component rendering and interactions
- **Data processing** - Calculation results and transformations
- **Business logic** - Decision outcomes and workflows
- **Performance characteristics** - Response times and resource usage
- **Security behavior** - Authentication, authorization, and validation
- **Error handling** - Exception types and messages

### Baseline Types

#### Golden Files
- **Reference outputs** stored alongside tests
- **Version controlled** with the codebase
- **Human-readable** for easy validation
- **Structured format** (JSON, XML, plain text)

#### Database Snapshots
- **Expected data states** after operations
- **Test data fixtures** with known values
- **Migration results** for schema changes
- **Query results** for critical queries

#### Deterministic Logs
- **Structured logging** with predictable format
- **Error patterns** for exception handling
- **Performance metrics** for benchmarking
- **Audit trails** for security events

## Regression Protection Workflow

### Before Modifying Behavior-Critical Logic

#### 1. Run Baseline Tests
```bash
# All baseline tests must pass
npm run test:baseline
# or
pytest tests/baseline/
# or
go test ./tests/baseline/...
```

#### 2. Document Expected Changes
- **What behavior should change**
- **What behavior should remain the same**
- **Why the change is necessary**
- **How success will be measured**

#### 3. Make Changes
- **Implement the modification**
- **Follow coding standards**
- **Update documentation**
- **Add new tests as needed**

#### 4. Re-run Baseline Tests
```bash
# Verify no unintended regressions
npm run test:baseline
```

### Regression Detection

#### If Results Differ → This is a Regression
1. **STOP** - Do not proceed
2. **ANALYZE** - Understand why baseline failed
3. **FIX** - Address the regression
4. **VERIFY** - Re-run baseline tests
5. **DOCUMENT** - Record the fix and reasoning

#### Regression Categories
- **Breaking Regression** - Critical functionality broken
- **Behavioral Regression** - Output format/behavior changed unexpectedly
- **Performance Regression** - Response times degraded
- **Security Regression** - Security controls weakened

## Baseline Management

### Creating Baselines

#### Initial Baseline Creation
```javascript
// Example: API response baseline
const expectedResponse = {
  "status": "success",
  "data": {
    "user": {
      "id": 123,
      "name": "John Doe",
      "email": "john@example.com"
    }
  },
  "timestamp": "2024-01-01T00:00:00Z"
};

// Save as golden file
fs.writeFileSync(
  './tests/baseline/api/user-profile.json',
  JSON.stringify(expectedResponse, null, 2)
);
```

#### Test Integration
```javascript
// Example: Baseline test
describe('User Profile API', () => {
  it('should match baseline response', async () => {
    const response = await api.getUserProfile(123);
    const baseline = require('./baseline/api/user-profile.json');
    
    // Compare with baseline
    expect(response.body).toEqual(baseline);
  });
});
```

### Updating Baselines

#### Valid Reasons to Update
- **Intentional behavior change** with stakeholder approval
- **Feature enhancement** with documented improvements
- **Bug fix** that corrects previous incorrect behavior
- **Performance optimization** that improves efficiency

#### Update Process
1. **Get explicit approval** from project owner/stakeholder
2. **Document the reason** for baseline change
3. **Update baseline files** with new expected values
4. **Run full test suite** to ensure no other regressions
5. **Commit with clear message** explaining baseline update

#### Never Update Baselines When:
- **Tests are failing** due to bugs in your code
- **Behavior changed unintentionally**
- **You're not sure why** the baseline doesn't match
- **Stakeholder approval** hasn't been obtained

## Implementation Examples

### API Response Baselines
```javascript
// tests/baseline/api/create-user.json
{
  "status": "success",
  "data": {
    "user": {
      "id": 456,
      "name": "Jane Smith",
      "email": "jane@example.com",
      "created_at": "2024-01-01T12:00:00Z",
      "verified": false
    }
  },
  "message": "User created successfully"
}
```

### UI Component Baselines
```javascript
// tests/baseline/ui/user-card.json
{
  "component": "UserCard",
  "props": {
    "user": {
      "id": 123,
      "name": "John Doe",
      "email": "john@example.com"
    }
  },
  "expectedOutput": {
    "html": "<div class='user-card'>...</div>",
    "text": "John Doe\njohn@example.com",
    "elements": {
      "avatar": true,
      "name": true,
      "email": true
    }
  }
}
```

### Data Processing Baselines
```javascript
// tests/baseline/data/calculate-discount.json
{
  "input": {
    "price": 100.00,
    "discountPercent": 0.2,
    "taxRate": 0.08
  },
  "expected": {
    "discountAmount": 20.00,
    "subtotal": 80.00,
    "taxAmount": 6.40,
    "total": 86.40
  }
}
```

## Quality Assurance

### Baseline Test Coverage
- [ ] **All critical APIs** have baseline tests
- [ ] **Key UI components** have visual/functional baselines
- [ ] **Important calculations** have result baselines
- [ ] **Security operations** have behavior baselines
- [ ] **Performance benchmarks** have baseline comparisons

### Baseline Maintenance
- [ ] **Baselines reviewed** quarterly for relevance
- [ ] **Outdated baselines** removed or updated
- [ ] **New features** include baseline creation
- [ ] **Baseline changes** documented and approved

### Regression Monitoring
- [ ] **Automated regression detection** in CI/CD
- [ ] **Performance regression alerts** configured
- [ ] **Security regression monitoring** active
- [ ] **Behavioral regression reporting** established

## Tools and Automation

### Baseline Testing Frameworks
- **Jest** - Snapshot testing for React components
- **pytest** - Golden file testing for Python
- **Go testing** - Testdata package for baselines
- **Custom solutions** - Project-specific baseline tools

### CI/CD Integration
```yaml
# Example: GitHub Actions
- name: Run Baseline Tests
  run: npm run test:baseline
  
- name: Check for Regressions
  if: failure()
  run: |
    echo "Baseline tests failed - potential regression detected"
    exit 1
```

---

## Remember
**Never modify baseline data unless the USER explicitly approves. Regressions break trust.**

# Rule 04 — Regression Protection

## Core Principle

Before changing critical behavior, capture the current state as a baseline. Verify behavior is preserved after changes.

## Quick Rules

- Baseline before modifying critical paths
- Golden files for complex outputs
- Automated regression detection
- Never delete tests without replacement

## What to Baseline

| Type | When to Baseline |
|------|------------------|
| API responses | Before changing endpoints |
| Database queries | Before schema changes |
| UI components | Before visual changes |
| Algorithms | Before optimization |
| Config outputs | Before refactoring |

## Baseline Methods

### Golden Files

```javascript
// Save expected output
const expected = fs.readFileSync('tests/golden/user-response.json');
const actual = JSON.stringify(getUserResponse(testUser));
expect(actual).toEqual(expected);
```

### Snapshot Testing

```javascript
test('user profile renders correctly', () => {
  const component = render(<UserProfile user={testUser} />);
  expect(component).toMatchSnapshot();
});
```

### Behavioral Tests

```javascript
test('calculateTotal preserves existing behavior', () => {
  // These cases document current behavior
  expect(calculateTotal([10, 20, 30])).toBe(60);
  expect(calculateTotal([])).toBe(0);
  expect(calculateTotal([0.1, 0.2])).toBeCloseTo(0.3);
});
```

## Regression Workflow

1. **Identify** critical behavior to protect
2. **Capture** current output as baseline
3. **Make** your changes
4. **Compare** new output to baseline
5. **Verify** differences are intentional

## Examples

✅ **Good**: Baseline before refactor
```javascript
// Before refactoring formatDate()
test('formatDate baseline', () => {
  expect(formatDate('2024-01-15')).toBe('January 15, 2024');
  expect(formatDate('2024-12-31')).toBe('December 31, 2024');
  expect(formatDate(null)).toBe('N/A');
});
```

❌ **Bad**: Change without baseline
```javascript
// Refactored formatDate() without tests
// Now returns 'Jan 15, 2024' instead of 'January 15, 2024'
// Breaking change went unnoticed
```

## Checklist

- [ ] Critical paths identified
- [ ] Baselines captured before changes
- [ ] Tests verify behavior preservation
- [ ] Intentional changes documented

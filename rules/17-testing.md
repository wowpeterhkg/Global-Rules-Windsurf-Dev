# Rule 17 — Testing

## Core Principle

Mock only at external boundaries. Use explicit synchronization, never time-based. One comprehensive E2E test beats many small disjointed tests.

## Quick Rules

- Minimal mocking (external boundaries only)
- No `sleep()` or `setTimeout()` for sync
- Test behavior, not implementation
- E2E for critical paths

## Mocking Strategy

### Mock Only External Boundaries

```javascript
// ✅ CORRECT - Mock external API
jest.mock('./stripe-client');

// ❌ WRONG - Mock internal module
jest.mock('./utils/calculateTotal');
```

### What to Mock

- External APIs (Stripe, Twilio, etc.)
- Database (for unit tests only)
- File system (when testing logic, not I/O)
- Time (for deterministic tests)

### What NOT to Mock

- Internal business logic
- Utility functions
- Data transformations
- Your own modules (usually)

## Async Testing

### Never Use Time-Based Sync

```javascript
// ❌ WRONG - Flaky, slow
await sleep(1000);
expect(result).toBe(expected);

// ✅ CORRECT - Explicit synchronization
await waitForCondition(() => processor.isComplete());
expect(result).toBe(expected);
```

### Use Explicit Signals

```javascript
// ✅ CORRECT - Wait for explicit signal
const completed = new Promise(resolve => {
  processor.onComplete(resolve);
});
processor.start();
await completed;
expect(processor.results).toHaveLength(5);
```

### Go WaitGroup Pattern

```go
var wg sync.WaitGroup
wg.Add(expectedCount)

processor.OnItem(func(item Item) {
    wg.Done()
})

processor.Start()
wg.Wait()

require.Equal(t, expectedCount, processor.Count())
```

## Test Structure

### Arrange-Act-Assert

```javascript
test('user can checkout with valid cart', async () => {
  // Arrange
  const cart = createTestCart({ items: 3 });
  const user = createTestUser({ balance: 100 });

  // Act
  const result = await checkout(user, cart);

  // Assert
  expect(result.success).toBe(true);
  expect(result.total).toBe(cart.total);
});
```

### E2E Over Unit for Critical Paths

```javascript
// ✅ GOOD - One comprehensive E2E test
test('complete purchase flow', async () => {
  // Login
  await login(testUser);
  
  // Add to cart
  await addToCart(product);
  
  // Checkout
  const order = await checkout();
  
  // Verify
  expect(order.status).toBe('confirmed');
  expect(await getInventory(product.id)).toBe(initialStock - 1);
  expect(await getUserOrders(testUser.id)).toContainEqual(order);
});
```

## Test Checklist

- [ ] Critical paths have E2E tests
- [ ] Mocks only at external boundaries
- [ ] No time-based synchronization
- [ ] Tests are deterministic
- [ ] Tests document expected behavior

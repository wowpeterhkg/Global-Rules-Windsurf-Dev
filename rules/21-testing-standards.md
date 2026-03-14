# Rule 21 — Testing Standards

## Core Principle

Mock only at the external boundary. Use explicit synchronization, never time-based. One comprehensive E2E test beats many small disjointed tests.

> **From detritus testing workflows**: Test real behavior, mock only at boundaries. Use `sync.WaitGroup` with precise counters. Never use `time.Sleep` or `require.Eventually`.

## Minimal Mocking Philosophy

### Mock Only External Boundaries

```typescript
// GOOD: Mock only the external API boundary
const mockStripeAPI = {
  charges: {
    create: jest.fn().mockResolvedValue({ id: 'ch_123', status: 'succeeded' })
  }
};

// Let all business logic run through real code
const paymentService = new PaymentService(mockStripeAPI);
const result = await paymentService.processPayment(order);

// BAD: Mocking internal business logic
const mockPaymentService = {
  processPayment: jest.fn().mockResolvedValue({ success: true })
};
// This tests nothing - you're just testing your mock
```

### What to Mock vs What to Run Real

| Component | Mock? | Reason |
|-----------|-------|--------|
| External APIs | ✅ Yes | Network unreliable, costs money |
| Databases | ⚠️ Maybe | Use test DB or in-memory |
| File system | ⚠️ Maybe | Use temp directories |
| Business logic | ❌ No | This is what you're testing |
| Internal services | ❌ No | Test real integration |
| Utilities | ❌ No | They should work |

### Simple State Toggle Pattern

```typescript
// GOOD: Simple mock with state toggle
class MockKafkaClient {
  private connected = true;
  private messages: Message[] = [];
  private onSendCallback?: (msg: Message) => void;
  
  setConnected(value: boolean) {
    this.connected = value;
  }
  
  setOnSend(callback: (msg: Message) => void) {
    this.onSendCallback = callback;
  }
  
  async send(message: Message): Promise<void> {
    if (!this.connected) {
      throw new Error('Not connected');
    }
    this.messages.push(message);
    this.onSendCallback?.(message);
  }
  
  getMessages(): Message[] {
    return [...this.messages];
  }
}
```

## Async Synchronization

### Never Use Time-Based Synchronization

```typescript
// BAD: Time-based synchronization
test('processes messages', async () => {
  processor.start();
  await new Promise(resolve => setTimeout(resolve, 1000)); // DON'T
  expect(processor.getProcessedCount()).toBe(5);
});

// BAD: Polling with Eventually
test('processes messages', async () => {
  processor.start();
  await waitFor(() => { // DON'T
    expect(processor.getProcessedCount()).toBe(5);
  });
});

// GOOD: Explicit synchronization
test('processes messages', async () => {
  const processedPromise = new Promise<void>(resolve => {
    processor.onProcessed((count) => {
      if (count === 5) resolve();
    });
  });
  
  processor.start();
  await processedPromise;
  
  expect(processor.getProcessedCount()).toBe(5);
});
```

### WaitGroup Pattern (Go)

```go
func TestAsyncProcessing(t *testing.T) {
    var wg sync.WaitGroup
    
    // Calculate exact expected callbacks BEFORE test runs
    expectedCallbacks := 5
    wg.Add(expectedCallbacks)
    
    processor := NewProcessor(func(item Item) {
        // Callback only updates state
        wg.Done()
    })
    
    // Start processing
    for i := 0; i < 5; i++ {
        processor.Process(items[i])
    }
    
    // Wait for all callbacks
    wg.Wait()
    
    // Assert AFTER synchronization, not inside callbacks
    require.Equal(t, 5, processor.ProcessedCount())
}
```

### Promise-Based Synchronization (JavaScript)

```typescript
test('async event handling', async () => {
  const events: string[] = [];
  let resolveAllEvents: () => void;
  const allEventsProcessed = new Promise<void>(resolve => {
    resolveAllEvents = resolve;
  });
  
  const handler = new EventHandler({
    onEvent: (event) => {
      events.push(event);
      if (events.length === 3) {
        resolveAllEvents();
      }
    }
  });
  
  handler.emit('event1');
  handler.emit('event2');
  handler.emit('event3');
  
  await allEventsProcessed;
  
  expect(events).toEqual(['event1', 'event2', 'event3']);
});
```

## E2E Test Structure

### One Comprehensive Test > Many Small Tests

```typescript
// GOOD: Single E2E test covering full lifecycle
describe('Order Processing E2E', () => {
  it('handles complete order lifecycle', async () => {
    // Setup
    const kafka = new MockKafkaClient();
    const db = await createTestDatabase();
    const service = new OrderService({ kafka, db });
    
    // Phase 1: Create order
    const order = await service.createOrder({
      items: [{ productId: 'prod-1', quantity: 2 }],
      customerId: 'cust-1'
    });
    expect(order.status).toBe('pending');
    expect(kafka.getMessages()).toHaveLength(1);
    
    // Phase 2: Process payment
    await service.processPayment(order.id, { method: 'card' });
    const updatedOrder = await service.getOrder(order.id);
    expect(updatedOrder.status).toBe('paid');
    
    // Phase 3: Fulfill order
    await service.fulfillOrder(order.id);
    const fulfilledOrder = await service.getOrder(order.id);
    expect(fulfilledOrder.status).toBe('fulfilled');
    expect(kafka.getMessages()).toHaveLength(3); // Created, paid, fulfilled
    
    // Phase 4: Handle cancellation attempt (should fail)
    await expect(service.cancelOrder(order.id))
      .rejects.toThrow('Cannot cancel fulfilled order');
  });
});

// BAD: Many small disconnected tests
describe('Order Processing', () => {
  it('creates order', async () => { /* ... */ });
  it('processes payment', async () => { /* ... */ }); // Separate setup
  it('fulfills order', async () => { /* ... */ }); // Separate setup
  it('prevents cancellation', async () => { /* ... */ }); // Separate setup
  // Each test has its own setup, missing integration issues
});
```

### Phase-Based Test Structure

```typescript
describe('Component Lifecycle', () => {
  it('handles full lifecycle with state transitions', async () => {
    const component = createTestComponent();
    
    // ===== PHASE 1: Initialization =====
    await component.initialize();
    expect(component.state).toBe('ready');
    
    // ===== PHASE 2: Normal Operation =====
    await component.process({ data: 'test' });
    expect(component.processedCount).toBe(1);
    
    // ===== PHASE 3: Error Handling =====
    await expect(component.process({ invalid: true }))
      .rejects.toThrow('Invalid data');
    expect(component.state).toBe('ready'); // Should recover
    
    // ===== PHASE 4: Shutdown =====
    await component.shutdown();
    expect(component.state).toBe('stopped');
    
    // ===== PHASE 5: Post-Shutdown Behavior =====
    await expect(component.process({ data: 'test' }))
      .rejects.toThrow('Component is stopped');
  });
});
```

## Test Organization

### File Structure

```
tests/
├── unit/                    # Fast, isolated tests
│   ├── utils.test.ts
│   └── validators.test.ts
├── integration/             # Tests with real dependencies
│   ├── database.test.ts
│   └── api.test.ts
├── e2e/                     # Full system tests
│   ├── order-lifecycle.test.ts
│   └── user-journey.test.ts
└── fixtures/                # Test data
    ├── users.json
    └── orders.json
```

### Test Naming

```typescript
// Good test names describe behavior
describe('PaymentService', () => {
  describe('processPayment', () => {
    it('succeeds with valid card and sufficient funds', async () => {});
    it('fails with declined card', async () => {});
    it('retries on network timeout', async () => {});
    it('logs all attempts for audit trail', async () => {});
  });
});
```

## Anti-Patterns Summary

| Anti-Pattern | Correct Approach |
|--------------|------------------|
| `time.Sleep()` | `sync.WaitGroup` or Promise |
| `require.Eventually()` | Callback hooks + explicit sync |
| Complex mock simulation | Simple `connected` toggle |
| Many small tests | Single E2E test with phases |
| Mocking business logic | Mock only external boundary |
| Assertions in callbacks | Assert after `wg.Wait()` |

## Quality Checklist

### Test Design

- [ ] **Mocking minimal** - Only external boundaries
- [ ] **Sync explicit** - No time-based waiting
- [ ] **E2E comprehensive** - Full lifecycle covered
- [ ] **Phases clear** - State transitions tested

### Test Quality

- [ ] **Deterministic** - Same result every run
- [ ] **Fast** - Unit tests < 100ms each
- [ ] **Independent** - No test order dependency
- [ ] **Readable** - Clear what's being tested

### Coverage

- [ ] **Happy path** - Normal operation works
- [ ] **Error cases** - Failures handled correctly
- [ ] **Edge cases** - Boundary conditions tested
- [ ] **Recovery** - System recovers from errors

---

## Remember

**Tests should prove behavior, not just exercise code. Mock at boundaries, sync explicitly, test comprehensively.**

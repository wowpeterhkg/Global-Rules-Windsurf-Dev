# Rule 24 — Async Event Handling

## Core Principle

Never use time as a synchronization mechanism. Calculate expected events before execution. Separate event handling from verification. Add observability before fixing.

> **From detritus async-events**: Timeouts are for liveness, not correctness. Use explicit signaling, not time-based synchronization.

## Never Use Time for Synchronization

### Why Time-Based Sync Fails

```typescript
// BAD: Time-based synchronization
async function testMessageProcessing() {
  processor.start();
  
  // This is WRONG - time is not a synchronization mechanism
  await sleep(1000); // Hope everything finished in 1 second
  
  expect(processor.getCount()).toBe(5);
}

// Problems:
// 1. Flaky - sometimes 1 second isn't enough
// 2. Slow - usually 1 second is too much
// 3. Non-deterministic - depends on system load
// 4. Hides bugs - masks timing issues
```

### What Counts as Time-Based Sync

```typescript
// ALL of these are time-based sync (AVOID):
await sleep(1000);
await new Promise(r => setTimeout(r, 1000));
await waitFor(() => condition, { timeout: 5000 });
await eventually(() => expect(x).toBe(y));
setInterval(() => checkCondition(), 100);
```

### The Fix: Explicit Signaling

```typescript
// GOOD: Explicit synchronization
async function testMessageProcessing() {
  const allProcessed = new Promise<void>(resolve => {
    processor.onComplete(() => resolve());
  });
  
  processor.start();
  await allProcessed; // Wait for explicit signal
  
  expect(processor.getCount()).toBe(5);
}
```

## Timeouts Are for Liveness, Not Correctness

### Correct Use of Timeouts

```typescript
// GOOD: Timeout as safety net, not synchronization
async function fetchWithTimeout<T>(
  promise: Promise<T>,
  timeoutMs: number
): Promise<T> {
  const timeout = new Promise<never>((_, reject) => {
    setTimeout(() => reject(new Error('Operation timed out')), timeoutMs);
  });
  
  return Promise.race([promise, timeout]);
}

// Usage - timeout prevents hanging, doesn't determine success
const result = await fetchWithTimeout(
  explicitlySignaledOperation(),
  30000 // 30 second safety timeout
);
```

### Wrong Use of Timeouts

```typescript
// BAD: Using timeout to "wait long enough"
async function waitForReady() {
  await new Promise(r => setTimeout(r, 5000));
  // Assume it's ready after 5 seconds - WRONG
}
```

## Calculate Expected Events Before Execution

### Pre-Calculate Event Counts

```typescript
// GOOD: Know exactly how many events to expect
async function testBatchProcessing() {
  const items = [1, 2, 3, 4, 5];
  const expectedCallbacks = items.length; // Calculate BEFORE
  
  let callbackCount = 0;
  const allDone = new Promise<void>(resolve => {
    processor.onItemProcessed(() => {
      callbackCount++;
      if (callbackCount === expectedCallbacks) {
        resolve();
      }
    });
  });
  
  processor.processBatch(items);
  await allDone;
  
  expect(callbackCount).toBe(expectedCallbacks);
}
```

### Go WaitGroup Pattern

```go
func TestBatchProcessing(t *testing.T) {
    items := []Item{item1, item2, item3, item4, item5}
    expectedCallbacks := len(items) // Calculate BEFORE
    
    var wg sync.WaitGroup
    wg.Add(expectedCallbacks)
    
    processor := NewProcessor(func(item Item) {
        wg.Done()
    })
    
    processor.ProcessBatch(items)
    wg.Wait()
    
    require.Equal(t, expectedCallbacks, processor.ProcessedCount())
}
```

## Separate Event Handling from Verification

### Don't Assert Inside Callbacks

```typescript
// BAD: Assertions inside callbacks
processor.onMessage((msg) => {
  expect(msg.valid).toBe(true); // DON'T - assertion in callback
  messages.push(msg);
});

// GOOD: Callbacks only update state, assert after sync
const messages: Message[] = [];
processor.onMessage((msg) => {
  messages.push(msg); // Only update state
});

await allMessagesReceived;

// Assert AFTER synchronization
expect(messages).toHaveLength(5);
messages.forEach(msg => {
  expect(msg.valid).toBe(true);
});
```

### State Machine Pattern

```typescript
// GOOD: Use state machine for complex async flows
type State = 'idle' | 'connecting' | 'connected' | 'processing' | 'done' | 'error';

class AsyncProcessor {
  private state: State = 'idle';
  private stateListeners: Map<State, (() => void)[]> = new Map();
  
  onState(state: State, callback: () => void) {
    const listeners = this.stateListeners.get(state) || [];
    listeners.push(callback);
    this.stateListeners.set(state, listeners);
  }
  
  waitForState(state: State): Promise<void> {
    if (this.state === state) return Promise.resolve();
    
    return new Promise(resolve => {
      this.onState(state, resolve);
    });
  }
  
  private setState(newState: State) {
    this.state = newState;
    const listeners = this.stateListeners.get(newState) || [];
    listeners.forEach(cb => cb());
  }
}

// Usage
const processor = new AsyncProcessor();
processor.start();
await processor.waitForState('connected');
processor.process(data);
await processor.waitForState('done');
expect(processor.getResults()).toHaveLength(5);
```

## Add Observability Before Fixing

### Don't Guess at Async Bugs

```typescript
// BAD: Guessing at the problem
// "It's probably a race condition"
// [Adds random delays and hopes for the best]

// GOOD: Add logging to understand actual behavior
async function debugAsyncIssue() {
  console.log(`[${Date.now()}] Starting operation`);
  
  processor.onStateChange((oldState, newState) => {
    console.log(`[${Date.now()}] State: ${oldState} -> ${newState}`);
  });
  
  processor.onMessage((msg) => {
    console.log(`[${Date.now()}] Message received: ${msg.id}`);
  });
  
  processor.onError((err) => {
    console.log(`[${Date.now()}] Error: ${err.message}`);
  });
  
  await processor.start();
  console.log(`[${Date.now()}] Operation complete`);
}
```

### Structured Async Logging

```typescript
interface AsyncEvent {
  timestamp: number;
  type: string;
  data: unknown;
  correlationId: string;
}

class AsyncTracer {
  private events: AsyncEvent[] = [];
  private correlationId: string;
  
  constructor() {
    this.correlationId = crypto.randomUUID();
  }
  
  trace(type: string, data: unknown) {
    this.events.push({
      timestamp: Date.now(),
      type,
      data,
      correlationId: this.correlationId,
    });
  }
  
  getTimeline(): string {
    return this.events
      .map(e => `[${e.timestamp}] ${e.type}: ${JSON.stringify(e.data)}`)
      .join('\n');
  }
}
```

## Treat Every Event Boundary as Untrusted

### Validate at Boundaries

```typescript
// GOOD: Validate events at boundaries
processor.onMessage((rawMessage) => {
  // Validate before processing
  if (!isValidMessage(rawMessage)) {
    logger.warn({ rawMessage }, 'Invalid message received');
    return;
  }
  
  const message = parseMessage(rawMessage);
  handleMessage(message);
});

function isValidMessage(msg: unknown): msg is RawMessage {
  return (
    typeof msg === 'object' &&
    msg !== null &&
    'id' in msg &&
    'type' in msg &&
    'payload' in msg
  );
}
```

## Don't Share Mutable State Across Async Boundaries

### Immutable State Pattern

```typescript
// BAD: Shared mutable state
let sharedCounter = 0;

processor.onMessage(() => {
  sharedCounter++; // Race condition!
});

// GOOD: Isolated state with synchronization
class Counter {
  private value = 0;
  private mutex = new Mutex();
  
  async increment(): Promise<number> {
    return this.mutex.runExclusive(() => {
      this.value++;
      return this.value;
    });
  }
  
  getValue(): number {
    return this.value;
  }
}
```

## Propagate Errors Across Async Chains

### Error Propagation Pattern

```typescript
// GOOD: Errors propagate through async chain
async function processWithErrorHandling() {
  const errorPromise = new Promise<never>((_, reject) => {
    processor.onError((error) => reject(error));
  });
  
  const successPromise = new Promise<Result>((resolve) => {
    processor.onComplete((result) => resolve(result));
  });
  
  // Either succeeds or fails, errors propagate
  return Promise.race([successPromise, errorPromise]);
}

// Usage
try {
  const result = await processWithErrorHandling();
  console.log('Success:', result);
} catch (error) {
  console.error('Failed:', error);
}
```

## Design for Cancellation and Cleanup

### AbortController Pattern

```typescript
async function cancellableOperation(signal: AbortSignal): Promise<Result> {
  return new Promise((resolve, reject) => {
    // Check if already aborted
    if (signal.aborted) {
      reject(new Error('Operation cancelled'));
      return;
    }
    
    // Listen for abort
    signal.addEventListener('abort', () => {
      cleanup();
      reject(new Error('Operation cancelled'));
    });
    
    // Start operation
    startOperation()
      .then(resolve)
      .catch(reject);
  });
}

// Usage
const controller = new AbortController();

// Start operation
const resultPromise = cancellableOperation(controller.signal);

// Cancel after 5 seconds if not done
setTimeout(() => controller.abort(), 5000);

try {
  const result = await resultPromise;
} catch (error) {
  if (error.message === 'Operation cancelled') {
    console.log('Operation was cancelled');
  }
}
```

## Quality Checklist

### Async Design

- [ ] **No time-based sync** - Explicit signals only
- [ ] **Events pre-calculated** - Know expected count
- [ ] **State isolated** - No shared mutable state
- [ ] **Errors propagate** - Through async chains

### Testing

- [ ] **Deterministic** - Same result every run
- [ ] **Observable** - Can see what's happening
- [ ] **Cancellable** - Can abort operations
- [ ] **Validated** - Events checked at boundaries

### Debugging

- [ ] **Logging added** - Before guessing
- [ ] **Timeline visible** - Event sequence clear
- [ ] **Correlation IDs** - Track related events
- [ ] **State transitions** - Logged and verifiable

---

## Remember

**Time is not a synchronization mechanism. Use explicit signals, calculate expectations, and observe before fixing.**

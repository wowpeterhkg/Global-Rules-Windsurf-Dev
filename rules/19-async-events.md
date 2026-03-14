# Rule 19 — Async Events

## Core Principle

Never use time as a synchronization mechanism. Calculate expected events before execution. Use explicit signals.

## Quick Rules

- No `sleep()` for synchronization
- Timeouts for liveness, not correctness
- Pre-calculate expected event counts
- Separate handling from verification

## Why Time-Based Sync Fails

```javascript
// ❌ WRONG - Time-based synchronization
async function testProcessing() {
  processor.start();
  await sleep(1000);  // Hope it's done in 1 second
  expect(processor.count).toBe(5);
}

// Problems:
// 1. Flaky - sometimes 1 second isn't enough
// 2. Slow - usually 1 second is too much
// 3. Non-deterministic - depends on system load
```

## Correct Patterns

### Explicit Signaling

```javascript
// ✅ CORRECT - Wait for explicit signal
async function testProcessing() {
  const done = new Promise(resolve => {
    processor.onComplete(resolve);
  });
  
  processor.start();
  await done;  // Wait for actual completion
  
  expect(processor.count).toBe(5);
}
```

### Pre-Calculate Expected Events

```javascript
// ✅ CORRECT - Know how many events to expect
async function testBatch() {
  const items = [1, 2, 3, 4, 5];
  const expectedCount = items.length;  // Calculate BEFORE
  
  let count = 0;
  const allDone = new Promise(resolve => {
    processor.onItem(() => {
      count++;
      if (count === expectedCount) resolve();
    });
  });
  
  processor.process(items);
  await allDone;
  
  expect(count).toBe(expectedCount);
}
```

### Timeouts as Safety Nets

```javascript
// ✅ CORRECT - Timeout prevents hanging, doesn't determine success
async function fetchWithTimeout(promise, ms) {
  const timeout = new Promise((_, reject) => {
    setTimeout(() => reject(new Error('Timeout')), ms);
  });
  
  return Promise.race([promise, timeout]);
}

// Usage
const result = await fetchWithTimeout(
  explicitlySignaledOperation(),
  30000  // Safety timeout, not synchronization
);
```

## State Machine Pattern

```javascript
class AsyncProcessor {
  constructor() {
    this.state = 'idle';
    this.listeners = new Map();
  }
  
  onState(state, callback) {
    const list = this.listeners.get(state) || [];
    list.push(callback);
    this.listeners.set(state, list);
  }
  
  waitForState(state) {
    if (this.state === state) return Promise.resolve();
    return new Promise(resolve => this.onState(state, resolve));
  }
  
  setState(newState) {
    this.state = newState;
    (this.listeners.get(newState) || []).forEach(cb => cb());
  }
}

// Usage
const processor = new AsyncProcessor();
processor.start();
await processor.waitForState('complete');
```

## Error Propagation

```javascript
// ✅ CORRECT - Errors propagate through async chain
async function processWithErrors() {
  const error = new Promise((_, reject) => {
    processor.onError(reject);
  });
  
  const success = new Promise(resolve => {
    processor.onComplete(resolve);
  });
  
  return Promise.race([success, error]);
}
```

## Checklist

- [ ] No time-based synchronization
- [ ] Expected events calculated beforehand
- [ ] Explicit signals for completion
- [ ] Timeouts only for safety
- [ ] Errors propagate properly

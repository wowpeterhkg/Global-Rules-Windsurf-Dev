# Rule 7 — Modular Refactoring

## Core Principle

When splitting large modules: each module owns its own state, keeps fields private, exposes intentional APIs, and stays human-readable.

## Size Guidelines

### File Size Limits

- **Preferred**: < 500 lines per file
- **Maximum**: < 1000 lines per file
- **Action required**: > 1000 lines must be split

### Function Size Limits

- **Preferred**: < 50 lines per function
- **Maximum**: < 100 lines per function
- **Action required**: > 100 lines must be refactored

### Class/Module Size Limits

- **Preferred**: < 10 public methods
- **Maximum**: < 20 public methods
- **Action required**: > 20 methods indicates multiple responsibilities

## Module Ownership Principles

### Each Module Owns Its State

```typescript
// GOOD: Module owns and encapsulates its state
class UserService {
  private users: Map<string, User> = new Map();
  private cache: Cache;
  
  constructor(cache: Cache) {
    this.cache = cache;
  }
  
  async getUser(id: string): Promise<User> {
    // Only this module accesses this.users directly
  }
}

// BAD: State shared across modules
const globalUsers = new Map<string, User>();

class UserService {
  getUser(id: string) {
    return globalUsers.get(id); // Accessing global state
  }
}
```

### Keep Fields Private

```typescript
// GOOD: Private fields with public accessors
class OrderProcessor {
  private readonly config: ProcessorConfig;
  private pendingOrders: Order[] = [];
  
  getPendingCount(): number {
    return this.pendingOrders.length;
  }
}

// BAD: Public fields allowing external mutation
class OrderProcessor {
  public config: ProcessorConfig;  // Can be changed externally
  public pendingOrders: Order[] = []; // Can be mutated externally
}
```

### Expose Intentional APIs

```typescript
// GOOD: Clear, intentional public API
export class PaymentService {
  // Public API - intentionally exposed
  async processPayment(payment: PaymentRequest): Promise<PaymentResult>
  async refundPayment(paymentId: string): Promise<RefundResult>
  getPaymentStatus(paymentId: string): PaymentStatus
  
  // Private implementation details
  private validatePayment(payment: PaymentRequest): ValidationResult
  private connectToGateway(): GatewayConnection
  private logTransaction(tx: Transaction): void
}

// BAD: Everything public, no clear API boundary
export class PaymentService {
  public validatePayment(payment: PaymentRequest): ValidationResult
  public connectToGateway(): GatewayConnection
  public logTransaction(tx: Transaction): void
  public processPayment(payment: PaymentRequest): Promise<PaymentResult>
}
```

## Splitting Large Modules

### Step 1: Identify Responsibilities

```typescript
// Before: One large module with multiple responsibilities
// user-service.ts (1500 lines)
class UserService {
  // Authentication (300 lines)
  login(), logout(), refreshToken(), validateSession()
  
  // Profile management (400 lines)
  getProfile(), updateProfile(), uploadAvatar()
  
  // Preferences (200 lines)
  getPreferences(), updatePreferences()
  
  // Notifications (300 lines)
  sendNotification(), getNotifications(), markAsRead()
  
  // Analytics (300 lines)
  trackEvent(), getAnalytics(), generateReport()
}
```

### Step 2: Extract by Responsibility

```typescript
// After: Separate modules by responsibility
// auth-service.ts (~300 lines)
export class AuthService {
  login(), logout(), refreshToken(), validateSession()
}

// profile-service.ts (~400 lines)
export class ProfileService {
  getProfile(), updateProfile(), uploadAvatar()
}

// preferences-service.ts (~200 lines)
export class PreferencesService {
  getPreferences(), updatePreferences()
}

// notification-service.ts (~300 lines)
export class NotificationService {
  sendNotification(), getNotifications(), markAsRead()
}

// analytics-service.ts (~300 lines)
export class AnalyticsService {
  trackEvent(), getAnalytics(), generateReport()
}
```

### Step 3: Define Clear Interfaces

```typescript
// interfaces/user-interfaces.ts
export interface IAuthService {
  login(credentials: Credentials): Promise<Session>;
  logout(sessionId: string): Promise<void>;
}

export interface IProfileService {
  getProfile(userId: string): Promise<UserProfile>;
  updateProfile(userId: string, updates: ProfileUpdates): Promise<UserProfile>;
}
```

## Import Organization

### Avoid Deep Relative Imports

```typescript
// BAD: Deep relative imports
import { helper } from '../../../utils/helpers/string/format';
import { config } from '../../../../config/app/settings';

// GOOD: Shallow imports with barrel files
import { formatString } from '@/utils';
import { appConfig } from '@/config';
```

### Barrel File Pattern

```typescript
// utils/index.ts (barrel file)
export { formatString, capitalize } from './string';
export { formatDate, parseDate } from './date';
export { validateEmail, validatePhone } from './validation';

// Usage
import { formatString, formatDate, validateEmail } from '@/utils';
```

## Organization by Responsibility

### Feature-Based Structure

```
src/
├── features/
│   ├── auth/
│   │   ├── auth.service.ts
│   │   ├── auth.controller.ts
│   │   ├── auth.types.ts
│   │   └── index.ts
│   ├── users/
│   │   ├── user.service.ts
│   │   ├── user.repository.ts
│   │   ├── user.types.ts
│   │   └── index.ts
│   └── orders/
│       ├── order.service.ts
│       ├── order.processor.ts
│       ├── order.types.ts
│       └── index.ts
├── shared/
│   ├── utils/
│   ├── types/
│   └── constants/
└── infrastructure/
    ├── database/
    ├── cache/
    └── messaging/
```

### Layer-Based Structure (Alternative)

```
src/
├── controllers/
│   ├── auth.controller.ts
│   ├── user.controller.ts
│   └── order.controller.ts
├── services/
│   ├── auth.service.ts
│   ├── user.service.ts
│   └── order.service.ts
├── repositories/
│   ├── user.repository.ts
│   └── order.repository.ts
├── models/
│   ├── user.model.ts
│   └── order.model.ts
└── utils/
```

## Refactoring Checklist

### Before Refactoring

- [ ] **Tests exist** for current behavior
- [ ] **All tests pass** before starting
- [ ] **Scope is defined** - what will be split
- [ ] **New structure planned** - target organization

### During Refactoring

- [ ] **One change at a time** - small, incremental steps
- [ ] **Tests pass after each step** - no broken intermediate states
- [ ] **Imports updated** - no broken references
- [ ] **No functionality changes** - pure refactoring

### After Refactoring

- [ ] **All tests still pass** - behavior preserved
- [ ] **File sizes within limits** - < 500 lines preferred
- [ ] **Clear module boundaries** - single responsibility each
- [ ] **No circular dependencies** - clean dependency graph
- [ ] **Documentation updated** - reflects new structure

## Common Refactoring Patterns

### Extract Class

```typescript
// Before: Class doing too much
class Order {
  // Order data
  items: Item[];
  
  // Shipping logic (should be separate)
  calculateShipping(): number { ... }
  getShippingOptions(): ShippingOption[] { ... }
  
  // Payment logic (should be separate)
  processPayment(): PaymentResult { ... }
  refund(): RefundResult { ... }
}

// After: Separate classes
class Order {
  items: Item[];
}

class ShippingCalculator {
  calculate(order: Order): number { ... }
  getOptions(order: Order): ShippingOption[] { ... }
}

class PaymentProcessor {
  process(order: Order): PaymentResult { ... }
  refund(order: Order): RefundResult { ... }
}
```

### Extract Function

```typescript
// Before: Long function
function processOrder(order: Order) {
  // 50 lines of validation
  // 30 lines of inventory check
  // 40 lines of payment processing
  // 30 lines of notification
}

// After: Extracted functions
function processOrder(order: Order) {
  validateOrder(order);
  checkInventory(order);
  processPayment(order);
  sendNotifications(order);
}
```

---

## Remember

**Organize by responsibility, not convenience. Small, focused modules are easier to understand, test, and maintain.**

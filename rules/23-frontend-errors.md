# Rule 23 — Frontend Error Handling

## Core Principle

Implement proper error boundaries, log errors appropriately for debugging, provide user-friendly error messages, and handle network failures gracefully.

## Error Boundaries

### React Error Boundary

```typescript
import React, { Component, ErrorInfo, ReactNode } from 'react';

interface Props {
  children: ReactNode;
  fallback?: ReactNode;
  onError?: (error: Error, errorInfo: ErrorInfo) => void;
}

interface State {
  hasError: boolean;
  error: Error | null;
  errorId: string | null;
}

class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { hasError: false, error: null, errorId: null };
  }

  static getDerivedStateFromError(error: Error): Partial<State> {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    // Generate unique error ID for support
    const errorId = `ERR-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
    
    // Log to error tracking service
    this.logError(error, errorInfo, errorId);
    
    // Update state with error ID
    this.setState({ errorId });
    
    // Call optional error handler
    this.props.onError?.(error, errorInfo);
  }

  private logError(error: Error, errorInfo: ErrorInfo, errorId: string) {
    // Send to error tracking service (e.g., Sentry, LogRocket)
    console.error('Error caught by boundary:', {
      errorId,
      message: error.message,
      stack: error.stack,
      componentStack: errorInfo.componentStack,
    });
    
    // In production, send to error tracking service
    // errorTracker.captureException(error, { extra: { errorId, errorInfo } });
  }

  render() {
    if (this.state.hasError) {
      if (this.props.fallback) {
        return this.props.fallback;
      }
      
      return (
        <div className="error-boundary-fallback">
          <h2>Something went wrong</h2>
          <p>We've been notified and are working on a fix.</p>
          {this.state.errorId && (
            <p className="error-id">
              Error ID: <code>{this.state.errorId}</code>
            </p>
          )}
          <button onClick={() => this.setState({ hasError: false, error: null })}>
            Try Again
          </button>
        </div>
      );
    }

    return this.props.children;
  }
}

export default ErrorBoundary;
```

### Using Error Boundaries

```tsx
// Wrap critical sections
function App() {
  return (
    <ErrorBoundary>
      <Header />
      <ErrorBoundary fallback={<MainContentError />}>
        <MainContent />
      </ErrorBoundary>
      <ErrorBoundary fallback={<SidebarError />}>
        <Sidebar />
      </ErrorBoundary>
      <Footer />
    </ErrorBoundary>
  );
}

// Custom fallback components
function MainContentError() {
  return (
    <div className="error-fallback">
      <p>Unable to load content. Please refresh the page.</p>
      <button onClick={() => window.location.reload()}>
        Refresh
      </button>
    </div>
  );
}
```

## User-Friendly Error Messages

### Error Message Guidelines

```typescript
// BAD: Technical error messages
"Error: ECONNREFUSED 127.0.0.1:5432"
"TypeError: Cannot read property 'map' of undefined"
"HTTP 500 Internal Server Error"

// GOOD: User-friendly messages
"Unable to connect to the server. Please check your internet connection."
"Something went wrong loading your data. Please try again."
"We're experiencing technical difficulties. Please try again later."
```

### Error Message Mapping

```typescript
const errorMessages: Record<string, string> = {
  // Network errors
  'NETWORK_ERROR': 'Unable to connect. Please check your internet connection.',
  'TIMEOUT': 'The request took too long. Please try again.',
  'SERVER_ERROR': 'We\'re experiencing technical difficulties. Please try again later.',
  
  // Authentication errors
  'UNAUTHORIZED': 'Please log in to continue.',
  'SESSION_EXPIRED': 'Your session has expired. Please log in again.',
  'INVALID_CREDENTIALS': 'Invalid email or password. Please try again.',
  
  // Validation errors
  'VALIDATION_ERROR': 'Please check your input and try again.',
  'REQUIRED_FIELD': 'This field is required.',
  'INVALID_EMAIL': 'Please enter a valid email address.',
  
  // Resource errors
  'NOT_FOUND': 'The requested item could not be found.',
  'FORBIDDEN': 'You don\'t have permission to access this.',
  
  // Default
  'UNKNOWN': 'Something went wrong. Please try again.',
};

function getUserFriendlyMessage(errorCode: string): string {
  return errorMessages[errorCode] || errorMessages['UNKNOWN'];
}
```

## Network Error Handling

### Fetch Wrapper with Error Handling

```typescript
interface ApiError {
  code: string;
  message: string;
  details?: Record<string, unknown>;
}

class NetworkError extends Error {
  constructor(
    message: string,
    public code: string,
    public status?: number,
    public details?: Record<string, unknown>
  ) {
    super(message);
    this.name = 'NetworkError';
  }
}

async function fetchWithErrorHandling<T>(
  url: string,
  options?: RequestInit
): Promise<T> {
  try {
    const response = await fetch(url, {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        ...options?.headers,
      },
    });

    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}));
      throw new NetworkError(
        errorData.message || 'Request failed',
        errorData.code || 'SERVER_ERROR',
        response.status,
        errorData.details
      );
    }

    return response.json();
  } catch (error) {
    if (error instanceof NetworkError) {
      throw error;
    }
    
    // Handle network-level errors
    if (error instanceof TypeError && error.message === 'Failed to fetch') {
      throw new NetworkError(
        'Unable to connect to server',
        'NETWORK_ERROR'
      );
    }
    
    throw new NetworkError(
      'An unexpected error occurred',
      'UNKNOWN'
    );
  }
}
```

### Retry Logic

```typescript
interface RetryOptions {
  maxRetries: number;
  baseDelay: number;
  maxDelay: number;
  retryOn: (error: Error) => boolean;
}

async function fetchWithRetry<T>(
  url: string,
  options?: RequestInit,
  retryOptions: Partial<RetryOptions> = {}
): Promise<T> {
  const {
    maxRetries = 3,
    baseDelay = 1000,
    maxDelay = 10000,
    retryOn = (error) => error instanceof NetworkError && 
      ['NETWORK_ERROR', 'TIMEOUT', 'SERVER_ERROR'].includes(error.code),
  } = retryOptions;

  let lastError: Error;
  
  for (let attempt = 0; attempt <= maxRetries; attempt++) {
    try {
      return await fetchWithErrorHandling<T>(url, options);
    } catch (error) {
      lastError = error as Error;
      
      if (attempt === maxRetries || !retryOn(lastError)) {
        throw lastError;
      }
      
      // Exponential backoff with jitter
      const delay = Math.min(
        baseDelay * Math.pow(2, attempt) + Math.random() * 1000,
        maxDelay
      );
      
      await new Promise(resolve => setTimeout(resolve, delay));
    }
  }
  
  throw lastError!;
}
```

## Loading and Error States

### State Management Pattern

```typescript
interface AsyncState<T> {
  data: T | null;
  loading: boolean;
  error: Error | null;
}

function useAsync<T>(
  asyncFn: () => Promise<T>,
  deps: unknown[] = []
): AsyncState<T> & { retry: () => void } {
  const [state, setState] = useState<AsyncState<T>>({
    data: null,
    loading: true,
    error: null,
  });

  const execute = useCallback(async () => {
    setState(prev => ({ ...prev, loading: true, error: null }));
    
    try {
      const data = await asyncFn();
      setState({ data, loading: false, error: null });
    } catch (error) {
      setState({ data: null, loading: false, error: error as Error });
    }
  }, deps);

  useEffect(() => {
    execute();
  }, [execute]);

  return { ...state, retry: execute };
}
```

### UI Components for States

```tsx
interface AsyncContentProps<T> {
  loading: boolean;
  error: Error | null;
  data: T | null;
  onRetry?: () => void;
  children: (data: T) => ReactNode;
}

function AsyncContent<T>({
  loading,
  error,
  data,
  onRetry,
  children,
}: AsyncContentProps<T>) {
  if (loading) {
    return <LoadingSpinner />;
  }

  if (error) {
    return (
      <ErrorDisplay
        message={getUserFriendlyMessage(
          error instanceof NetworkError ? error.code : 'UNKNOWN'
        )}
        onRetry={onRetry}
      />
    );
  }

  if (!data) {
    return <EmptyState message="No data available" />;
  }

  return <>{children(data)}</>;
}

// Usage
function UserProfile({ userId }: { userId: string }) {
  const { data, loading, error, retry } = useAsync(
    () => fetchUser(userId),
    [userId]
  );

  return (
    <AsyncContent
      loading={loading}
      error={error}
      data={data}
      onRetry={retry}
    >
      {(user) => (
        <div>
          <h1>{user.name}</h1>
          <p>{user.email}</p>
        </div>
      )}
    </AsyncContent>
  );
}
```

## Form Error Handling

### Form Validation Errors

```tsx
interface FormErrors {
  [field: string]: string | undefined;
}

function useFormValidation<T extends Record<string, unknown>>(
  values: T,
  validate: (values: T) => FormErrors
) {
  const [errors, setErrors] = useState<FormErrors>({});
  const [touched, setTouched] = useState<Record<string, boolean>>({});

  const validateField = (field: keyof T) => {
    const fieldErrors = validate(values);
    setErrors(prev => ({ ...prev, [field]: fieldErrors[field as string] }));
  };

  const handleBlur = (field: keyof T) => {
    setTouched(prev => ({ ...prev, [field]: true }));
    validateField(field);
  };

  const validateAll = (): boolean => {
    const allErrors = validate(values);
    setErrors(allErrors);
    setTouched(
      Object.keys(values).reduce((acc, key) => ({ ...acc, [key]: true }), {})
    );
    return Object.keys(allErrors).length === 0;
  };

  const getFieldError = (field: keyof T): string | undefined => {
    return touched[field as string] ? errors[field as string] : undefined;
  };

  return { errors, handleBlur, validateAll, getFieldError };
}
```

### Displaying Form Errors

```tsx
function FormField({
  label,
  name,
  error,
  children,
}: {
  label: string;
  name: string;
  error?: string;
  children: ReactNode;
}) {
  return (
    <div className={`form-field ${error ? 'has-error' : ''}`}>
      <label htmlFor={name}>{label}</label>
      {children}
      {error && (
        <span className="error-message" role="alert">
          {error}
        </span>
      )}
    </div>
  );
}
```

## Offline Handling

### Detecting Offline State

```typescript
function useOnlineStatus() {
  const [isOnline, setIsOnline] = useState(navigator.onLine);

  useEffect(() => {
    const handleOnline = () => setIsOnline(true);
    const handleOffline = () => setIsOnline(false);

    window.addEventListener('online', handleOnline);
    window.addEventListener('offline', handleOffline);

    return () => {
      window.removeEventListener('online', handleOnline);
      window.removeEventListener('offline', handleOffline);
    };
  }, []);

  return isOnline;
}

// Usage
function App() {
  const isOnline = useOnlineStatus();

  return (
    <>
      {!isOnline && (
        <OfflineBanner message="You're offline. Some features may be unavailable." />
      )}
      <MainContent />
    </>
  );
}
```

## Quality Checklist

### Error Boundaries

- [ ] **Critical sections wrapped** in error boundaries
- [ ] **Fallback UI** provided for each boundary
- [ ] **Error logging** to tracking service
- [ ] **Error IDs** generated for support

### User Experience

- [ ] **Friendly messages** - No technical jargon
- [ ] **Actionable** - User knows what to do
- [ ] **Retry options** - Where appropriate
- [ ] **Loading states** - Clear feedback

### Network Handling

- [ ] **Timeout handling** - Don't hang forever
- [ ] **Retry logic** - For transient failures
- [ ] **Offline detection** - Graceful degradation
- [ ] **Error classification** - Different handling per type

---

## Remember

**Users don't care about stack traces. Give them clear messages and a path forward.**

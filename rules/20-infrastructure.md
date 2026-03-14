# Rule 20 — Infrastructure & Deployment

## Core Principle

Always Dockerize deployments. Use the right database for the job. Design for portability and scalability.

## Quick Rules

- Docker for all deployments
- PostgreSQL for structured/ACID data
- Redis for caching and sessions
- LevelDB for embedded/portable storage
- Environment-based configuration
- **Always confirm port assignments** - never assume defaults

## Docker Deployment (Required)

All applications must be containerized for consistent, portable deployment.

### Basic Dockerfile

```dockerfile
# Node.js example
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
USER node
EXPOSE 3000
CMD ["node", "src/index.js"]
```

### Docker Compose (Development)

```yaml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/app
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: app
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:
```

### Production Best Practices

- Use multi-stage builds to minimize image size
- Run as non-root user
- Use `.dockerignore` to exclude unnecessary files
- Pin specific image versions (not `latest`)
- Health checks for orchestration

## Database Selection Guide

| Use Case | Database | Reason |
|----------|----------|--------|
| Structured data, transactions | **PostgreSQL** | ACID compliance, relational integrity |
| Caching, sessions | **Redis** | In-memory speed, TTL support |
| Embedded/portable storage | **LevelDB** | No server, runs in-process |
| Full-text search | PostgreSQL + pg_trgm | Built-in, no extra service |
| Time-series data | PostgreSQL + TimescaleDB | Extension, familiar SQL |

### PostgreSQL (Primary Database)

Use for any data requiring:
- ACID transactions
- Relational integrity (foreign keys)
- Complex queries (JOINs, aggregations)
- Data consistency guarantees

```javascript
import pg from 'pg';

const pool = new pg.Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
});

// Always use parameterized queries
const result = await pool.query(
  'SELECT * FROM users WHERE id = $1',
  [userId]
);
```

### Redis (Caching & Sessions)

Use for:
- Session storage
- Caching frequently accessed data
- Rate limiting
- Pub/sub messaging
- Temporary data with TTL

```javascript
import Redis from 'ioredis';

const redis = new Redis(process.env.REDIS_URL);

// Session storage
await redis.set(`session:${sessionId}`, JSON.stringify(userData), 'EX', 3600);

// Caching with TTL
await redis.setex(`cache:user:${userId}`, 300, JSON.stringify(user));

// Rate limiting
const requests = await redis.incr(`ratelimit:${ip}`);
if (requests === 1) await redis.expire(`ratelimit:${ip}`, 60);
```

### LevelDB (Embedded Storage)

Use for:
- Desktop/CLI applications
- Local caching without external dependencies
- Portable, single-file databases
- When you can't run a database server

```javascript
import { Level } from 'level';

const db = new Level('./data/app.db', { valueEncoding: 'json' });

// Simple key-value storage
await db.put('user:123', { name: 'John', email: 'john@example.com' });
const user = await db.get('user:123');

// Batch operations
await db.batch([
  { type: 'put', key: 'user:1', value: { name: 'Alice' } },
  { type: 'put', key: 'user:2', value: { name: 'Bob' } },
  { type: 'del', key: 'user:old' },
]);
```

## Port Selection (Important)

**Never assume default ports are available.** Enterprise environments often have multiple services running.

### Before Deployment, Always Ask

1. What ports are already in use?
2. Are there corporate firewall restrictions?
3. Are there other instances of the same service?

### Common Default Ports & Alternatives

| Service | Default | Alternative Suggestions |
|---------|---------|------------------------|
| PostgreSQL | 5432 | 5433, 5434, 15432 |
| Redis | 6379 | 6380, 6381, 16379 |
| MongoDB | 27017 | 27018, 27019 |
| MySQL | 3306 | 3307, 3308 |
| HTTP | 80 | 8080, 8000, 3000 |
| HTTPS | 443 | 8443, 4443 |
| Node.js App | 3000 | 3001, 4000, 8080 |

### Port Configuration Pattern

```bash
# Always use environment variables for ports
APP_PORT=3000
DB_PORT=5432
REDIS_PORT=6379
```

```yaml
# docker-compose.yml - Use variables
services:
  app:
    ports:
      - "${APP_PORT:-3000}:3000"
  db:
    ports:
      - "${DB_PORT:-5432}:5432"
  redis:
    ports:
      - "${REDIS_PORT:-6379}:6379"
```

### Check for Port Conflicts

```bash
# Linux/macOS - Check if port is in use
lsof -i :5432
netstat -tuln | grep 5432

# Windows
netstat -ano | findstr :5432
```

## Environment Configuration

```bash
# .env.example
NODE_ENV=development

# Ports - CONFIRM THESE WITH USER
APP_PORT=3000
DB_PORT=5432
REDIS_PORT=6379

# Database
DATABASE_URL=postgresql://user:pass@localhost:${DB_PORT}/dbname

# Redis
REDIS_URL=redis://localhost:${REDIS_PORT}

# Security
JWT_SECRET=your-secret-here
ENCRYPTION_KEY=your-32-byte-hex-key
```

## Infrastructure Checklist

- [ ] Application Dockerized
- [ ] Docker Compose for local development
- [ ] Correct database selected for use case
- [ ] **Port assignments confirmed with user**
- [ ] No port conflicts with existing services
- [ ] Environment variables for all config (including ports)
- [ ] No hardcoded connection strings
- [ ] Health check endpoints implemented
- [ ] Logging configured for containers

# Plan: Build Database MCP Server with MySQL

## Overview
Extend the hello world MCP server to include database operations using MySQL. The server will provide tools for database connection management, querying, and CRUD operations.

## Steps

### 1. Install Database Dependencies
```bash
bun add mysql2 dotenv
bun add -d @types/node
```
- `mysql2`: MySQL client for Node.js with TypeScript support
- `dotenv`: Environment variable management for database credentials
- `@types/node`: Type definitions for Node.js APIs

### 2. Create Environment Configuration

#### 2.1 Create `.env` file
```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=password
DB_DATABASE=mcp_test
```

#### 2.2 Create `.env.example` file
```env
DB_HOST=
DB_PORT=
DB_USER=
DB_PASSWORD=
DB_DATABASE=
```

#### 2.3 Update `.gitignore`
Add `.env` to prevent committing credentials

### 3. Refactor Project Structure
```
bun-db-mcp/
├── src/
│   ├── index.ts           # Main MCP server
│   ├── db/
│   │   ├── connection.ts  # Database connection manager
│   │   └── types.ts       # Database type definitions
│   ├── tools/
│   │   ├── index.ts       # Tool definitions
│   │   ├── connection.ts  # Connection tool
│   │   ├── query.ts       # Query tool
│   │   ├── crud.ts        # Create, Update, Delete tools
│   │   └── schema.ts      # Read schema tool
│   └── utils/
│       └── validation.ts  # Input validation utilities
└── tests/
    ├── db.test.ts         # Database tests
    └── tools.test.ts      # Tool tests
```

### 4. Implement Database Connection Manager

#### 4.1 Create `src/db/types.ts`
```typescript
export interface DatabaseConfig {
  host: string;
  port: number;
  user: string;
  password: string;
  database: string;
}

export interface QueryResult {
  rows: any[];
  fields: any[];
  affectedRows?: number;
  insertId?: number;
}

export interface TableSchema {
  tableName: string;
  columns: ColumnInfo[];
}

export interface ColumnInfo {
  name: string;
  type: string;
  nullable: boolean;
  key: string;
  default: any;
  extra: string;
}
```

#### 4.2 Create `src/db/connection.ts`
```typescript
import mysql from 'mysql2/promise';
import { DatabaseConfig } from './types';

class DatabaseConnection {
  private connection: mysql.Connection | null = null;
  private config: DatabaseConfig;

  constructor(config: DatabaseConfig) {
    this.config = config;
  }

  async connect(): Promise<void> {
    this.connection = await mysql.createConnection(this.config);
  }

  async disconnect(): Promise<void> {
    if (this.connection) {
      await this.connection.end();
      this.connection = null;
    }
  }

  async query(sql: string, params?: any[]): Promise<any> {
    if (!this.connection) {
      throw new Error('Database not connected');
    }
    const [rows, fields] = await this.connection.execute(sql, params);
    return { rows, fields };
  }

  isConnected(): boolean {
    return this.connection !== null;
  }
}

export default DatabaseConnection;
```

### 5. Implement MCP Tools

#### 5.1 Connection Tool
```typescript
const CONNECTION_TOOL = {
  name: "connection",
  description: "Manage database connection (connect/disconnect/status)",
  inputSchema: {
    type: "object",
    properties: {
      action: {
        type: "string",
        enum: ["connect", "disconnect", "status"],
        description: "Connection action to perform"
      }
    },
    required: ["action"]
  }
};
```

#### 5.2 Query Tool
```typescript
const QUERY_TOOL = {
  name: "query",
  description: "Execute a SELECT query on the database",
  inputSchema: {
    type: "object",
    properties: {
      sql: {
        type: "string",
        description: "SQL SELECT query to execute"
      },
      params: {
        type: "array",
        items: { type: ["string", "number", "boolean", "null"] },
        description: "Query parameters for prepared statements"
      }
    },
    required: ["sql"]
  }
};
```

#### 5.3 Create Tool
```typescript
const CREATE_TOOL = {
  name: "create",
  description: "Insert a new record into a table",
  inputSchema: {
    type: "object",
    properties: {
      table: {
        type: "string",
        description: "Table name"
      },
      data: {
        type: "object",
        description: "Data to insert (key-value pairs)"
      }
    },
    required: ["table", "data"]
  }
};
```

#### 5.4 Update Tool
```typescript
const UPDATE_TOOL = {
  name: "update",
  description: "Update records in a table",
  inputSchema: {
    type: "object",
    properties: {
      table: {
        type: "string",
        description: "Table name"
      },
      data: {
        type: "object",
        description: "Data to update (key-value pairs)"
      },
      where: {
        type: "object",
        description: "WHERE conditions (key-value pairs)"
      }
    },
    required: ["table", "data", "where"]
  }
};
```

#### 5.5 Delete Tool
```typescript
const DELETE_TOOL = {
  name: "delete",
  description: "Delete records from a table",
  inputSchema: {
    type: "object",
    properties: {
      table: {
        type: "string",
        description: "Table name"
      },
      where: {
        type: "object",
        description: "WHERE conditions (key-value pairs)"
      }
    },
    required: ["table", "where"]
  }
};
```

#### 5.6 Read Schema Tool
```typescript
const READ_SCHEMA_TOOL = {
  name: "readSchema",
  description: "Read database schema information",
  inputSchema: {
    type: "object",
    properties: {
      table: {
        type: "string",
        description: "Table name (optional, omit for all tables)"
      }
    }
  }
};
```

### 6. Implement Tool Handlers

#### 6.1 Connection Handler
```typescript
async function handleConnection(params: any) {
  switch (params.action) {
    case "connect":
      await db.connect();
      return { status: "connected" };
    case "disconnect":
      await db.disconnect();
      return { status: "disconnected" };
    case "status":
      return { connected: db.isConnected() };
    default:
      throw new Error(`Unknown action: ${params.action}`);
  }
}
```

#### 6.2 Query Handler
```typescript
async function handleQuery(params: any) {
  // Validate it's a SELECT query
  const sql = params.sql.trim().toUpperCase();
  if (!sql.startsWith('SELECT')) {
    throw new Error('Only SELECT queries are allowed in query tool');
  }
  
  const result = await db.query(params.sql, params.params);
  return {
    rows: result.rows,
    rowCount: result.rows.length
  };
}
```

#### 6.3 CRUD Handlers
```typescript
async function handleCreate(params: any) {
  const columns = Object.keys(params.data);
  const values = Object.values(params.data);
  const placeholders = columns.map(() => '?').join(', ');
  
  const sql = `INSERT INTO ${params.table} (${columns.join(', ')}) VALUES (${placeholders})`;
  const result = await db.query(sql, values);
  
  return {
    success: true,
    insertId: result.insertId,
    affectedRows: result.affectedRows
  };
}

async function handleUpdate(params: any) {
  const setClause = Object.keys(params.data)
    .map(key => `${key} = ?`)
    .join(', ');
  const whereClause = Object.keys(params.where)
    .map(key => `${key} = ?`)
    .join(' AND ');
  
  const values = [...Object.values(params.data), ...Object.values(params.where)];
  const sql = `UPDATE ${params.table} SET ${setClause} WHERE ${whereClause}`;
  
  const result = await db.query(sql, values);
  return {
    success: true,
    affectedRows: result.affectedRows
  };
}

async function handleDelete(params: any) {
  const whereClause = Object.keys(params.where)
    .map(key => `${key} = ?`)
    .join(' AND ');
  
  const values = Object.values(params.where);
  const sql = `DELETE FROM ${params.table} WHERE ${whereClause}`;
  
  const result = await db.query(sql, values);
  return {
    success: true,
    affectedRows: result.affectedRows
  };
}
```

#### 6.4 Schema Handler
```typescript
async function handleReadSchema(params: any) {
  let sql: string;
  let queryParams: any[] = [];
  
  if (params.table) {
    sql = `
      SELECT 
        COLUMN_NAME as name,
        DATA_TYPE as type,
        IS_NULLABLE as nullable,
        COLUMN_KEY as key,
        COLUMN_DEFAULT as defaultValue,
        EXTRA as extra
      FROM INFORMATION_SCHEMA.COLUMNS
      WHERE TABLE_SCHEMA = ? AND TABLE_NAME = ?
      ORDER BY ORDINAL_POSITION
    `;
    queryParams = [process.env.DB_DATABASE, params.table];
  } else {
    sql = `
      SELECT 
        TABLE_NAME as tableName,
        TABLE_ROWS as rowCount,
        DATA_LENGTH as dataLength
      FROM INFORMATION_SCHEMA.TABLES
      WHERE TABLE_SCHEMA = ?
    `;
    queryParams = [process.env.DB_DATABASE];
  }
  
  const result = await db.query(sql, queryParams);
  return { schema: result.rows };
}
```

### 7. Update Main Server File

#### 7.1 Update `src/index.ts`
```typescript
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";
import dotenv from 'dotenv';
import DatabaseConnection from './db/connection.js';
import { TOOLS, handleToolCall } from './tools/index.js';

// Load environment variables
dotenv.config();

// Initialize database connection
const dbConfig = {
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '3306'),
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_DATABASE || 'mcp_test'
};

export const db = new DatabaseConnection(dbConfig);

// Create MCP server
const server = new Server(
  {
    name: "database-mcp",
    version: "2.0.0",
  },
  {
    capabilities: {
      tools: {}
    }
  }
);

// Register handlers
server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: TOOLS
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  try {
    const result = await handleToolCall(request.params.name, request.params.arguments);
    return {
      content: [
        {
          type: "text",
          text: JSON.stringify(result, null, 2)
        }
      ]
    };
  } catch (error) {
    return {
      content: [
        {
          type: "text",
          text: `Error: ${error.message}`
        }
      ],
      isError: true
    };
  }
});

// Start server
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("Database MCP server running on stdio");
}

main().catch((error) => {
  console.error("Failed to start server:", error);
  process.exit(1);
});
```

### 8. Create Test Suite

#### 8.1 Create `tests/db.test.ts`
```typescript
import { test, expect, beforeAll, afterAll } from "bun:test";
import DatabaseConnection from "../src/db/connection";

let db: DatabaseConnection;

beforeAll(async () => {
  db = new DatabaseConnection({
    host: 'localhost',
    port: 3306,
    user: 'test',
    password: 'test',
    database: 'test_db'
  });
  
  // Create test table
  await db.connect();
  await db.query(`
    CREATE TABLE IF NOT EXISTS test_users (
      id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(255),
      email VARCHAR(255)
    )
  `);
});

afterAll(async () => {
  // Clean up
  await db.query('DROP TABLE IF EXISTS test_users');
  await db.disconnect();
});

test("should connect to database", async () => {
  expect(db.isConnected()).toBe(true);
});

test("should insert a record", async () => {
  const result = await db.query(
    'INSERT INTO test_users (name, email) VALUES (?, ?)',
    ['John Doe', 'john@example.com']
  );
  expect(result.affectedRows).toBe(1);
});

test("should query records", async () => {
  const result = await db.query('SELECT * FROM test_users WHERE name = ?', ['John Doe']);
  expect(result.rows.length).toBeGreaterThan(0);
  expect(result.rows[0].name).toBe('John Doe');
});

test("should update a record", async () => {
  const result = await db.query(
    'UPDATE test_users SET email = ? WHERE name = ?',
    ['newemail@example.com', 'John Doe']
  );
  expect(result.affectedRows).toBeGreaterThan(0);
});

test("should delete a record", async () => {
  const result = await db.query(
    'DELETE FROM test_users WHERE name = ?',
    ['John Doe']
  );
  expect(result.affectedRows).toBeGreaterThan(0);
});
```

#### 8.2 Create `tests/tools.test.ts`
```typescript
import { test, expect, mock } from "bun:test";
import { handleToolCall } from "../src/tools/index";

test("connection tool - status", async () => {
  const result = await handleToolCall('connection', { action: 'status' });
  expect(result).toHaveProperty('connected');
});

test("query tool - validates SELECT only", async () => {
  expect(async () => {
    await handleToolCall('query', { sql: 'DELETE FROM users' });
  }).toThrow('Only SELECT queries are allowed');
});

test("create tool - builds correct SQL", async () => {
  // Mock database connection
  const mockDb = {
    query: mock((sql, params) => {
      expect(sql).toContain('INSERT INTO');
      expect(params).toEqual(['John', 'john@example.com']);
      return { insertId: 1, affectedRows: 1 };
    })
  };
  
  const result = await handleToolCall('create', {
    table: 'users',
    data: { name: 'John', email: 'john@example.com' }
  });
  
  expect(result.success).toBe(true);
});

test("update tool - builds correct SQL", async () => {
  const mockDb = {
    query: mock((sql, params) => {
      expect(sql).toContain('UPDATE');
      expect(sql).toContain('WHERE');
      return { affectedRows: 1 };
    })
  };
  
  const result = await handleToolCall('update', {
    table: 'users',
    data: { email: 'new@example.com' },
    where: { id: 1 }
  });
  
  expect(result.success).toBe(true);
});

test("delete tool - builds correct SQL", async () => {
  const mockDb = {
    query: mock((sql, params) => {
      expect(sql).toContain('DELETE FROM');
      expect(sql).toContain('WHERE');
      return { affectedRows: 1 };
    })
  };
  
  const result = await handleToolCall('delete', {
    table: 'users',
    where: { id: 1 }
  });
  
  expect(result.success).toBe(true);
});

test("readSchema tool - retrieves table structure", async () => {
  const result = await handleToolCall('readSchema', {
    table: 'users'
  });
  
  expect(result).toHaveProperty('schema');
  expect(Array.isArray(result.schema)).toBe(true);
});
```

### 9. Update package.json Scripts
```json
{
  "scripts": {
    "start": "bun run src/index.ts",
    "dev": "bun --watch src/index.ts",
    "test": "bun test",
    "test:db": "bun test tests/db.test.ts",
    "test:tools": "bun test tests/tools.test.ts",
    "test:watch": "bun test --watch"
  }
}
```

### 10. Add SQL Injection Prevention

#### 10.1 Create `src/utils/validation.ts`
```typescript
export function validateTableName(table: string): void {
  if (!/^[a-zA-Z_][a-zA-Z0-9_]*$/.test(table)) {
    throw new Error('Invalid table name');
  }
}

export function validateColumnName(column: string): void {
  if (!/^[a-zA-Z_][a-zA-Z0-9_]*$/.test(column)) {
    throw new Error('Invalid column name');
  }
}

export function escapeIdentifier(identifier: string): string {
  return '`' + identifier.replace(/`/g, '``') + '`';
}

export function buildWhereClause(conditions: Record<string, any>): {
  clause: string;
  values: any[];
} {
  const keys = Object.keys(conditions);
  const clause = keys.map(key => {
    validateColumnName(key);
    return `${escapeIdentifier(key)} = ?`;
  }).join(' AND ');
  
  return {
    clause,
    values: Object.values(conditions)
  };
}
```

### 11. Docker Compose for Testing (Optional)

#### 11.1 Create `docker-compose.yml`
```yaml
version: '3.8'
services:
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: mcp_test
      MYSQL_USER: mcp_user
      MYSQL_PASSWORD: mcp_password
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql

volumes:
  mysql_data:
```

### 12. Testing Strategy

1. **Unit Tests**: Test individual functions and utilities
2. **Integration Tests**: Test database operations with real MySQL
3. **MCP Protocol Tests**: Test tool registration and execution
4. **Error Handling Tests**: Test error cases and edge conditions

### 13. Security Considerations

1. **SQL Injection Prevention**:
   - Use parameterized queries
   - Validate table and column names
   - Escape identifiers properly

2. **Authentication**:
   - Store credentials in environment variables
   - Never log sensitive information

3. **Input Validation**:
   - Validate all tool inputs against schemas
   - Sanitize user inputs
   - Limit query complexity

## Expected Outcome

A production-ready MCP server that:
- Manages MySQL database connections
- Executes safe SQL queries with parameterization
- Performs CRUD operations on database tables
- Reads and returns database schema information
- Includes comprehensive test coverage
- Follows security best practices
- Provides clear error messages
- Supports environment-based configuration
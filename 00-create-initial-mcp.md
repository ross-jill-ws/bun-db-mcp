# Plan: Build Hello World MCP Server with Bun

## Overview
Create a minimal MCP (Model Context Protocol) server using Bun that implements a single `sayHello` tool.

## Steps

### 1. Initialize Bun Project
```bash
bun init -y
```
- Creates package.json
- Sets up basic TypeScript configuration
- Creates entry point file

### 2. Add MCP SDK Dependencies
```bash
bun add @modelcontextprotocol/sdk
```
- Install the official MCP SDK for TypeScript

### 3. Create Project Structure
```
bun-db-mcp/
├── package.json
├── tsconfig.json
├── bun.lockb
├── README.md
└── src/
    └── index.ts    # Main MCP server implementation
```

### 4. Implement MCP Server (src/index.ts)

#### 4.1 Import Required Modules
```typescript
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";
```

#### 4.2 Define Tool Schema
```typescript
const HELLO_TOOL = {
  name: "sayHello",
  description: "A simple tool that says hello",
  inputSchema: {
    type: "object",
    properties: {
      name: {
        type: "string",
        description: "Name to greet"
      }
    },
    required: ["name"]
  }
};
```

#### 4.3 Create Server Instance
```typescript
const server = new Server(
  {
    name: "hello-world-mcp",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {}
    }
  }
);
```

#### 4.4 Implement Request Handlers
- **List Tools Handler**: Returns available tools
  ```typescript
  server.setRequestHandler(ListToolsRequestSchema, async () => ({
    tools: [HELLO_TOOL]
  }));
  ```

- **Call Tool Handler**: Executes the sayHello tool
  ```typescript
  server.setRequestHandler(CallToolRequestSchema, async (request) => {
    if (request.params.name === "sayHello") {
      const name = request.params.arguments?.name as string;
      return {
        content: [
          {
            type: "text",
            text: `Hello, ${name}! Welcome to the MCP server.`
          }
        ]
      };
    }
    throw new Error(`Unknown tool: ${request.params.name}`);
  });
  ```

#### 4.5 Main Server Runner
```typescript
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("Hello World MCP server running on stdio");
}

main().catch((error) => {
  console.error("Failed to start server:", error);
  process.exit(1);
});
```

### 5. Update package.json
Add scripts and configuration:
```json
{
  "name": "bun-db-mcp",
  "module": "src/index.ts",
  "type": "module",
  "scripts": {
    "start": "bun run src/index.ts",
    "dev": "bun --watch src/index.ts",
    "test": "bun test"
  },
  "devDependencies": {
    "@types/bun": "latest"
  },
  "dependencies": {
    "@modelcontextprotocol/sdk": "^0.6.0"
  }
}
```

### 6. Create Basic Test (optional)
Create `src/index.test.ts`:
```typescript
import { test, expect } from "bun:test";

test("sayHello tool exists", () => {
  // Basic test to verify tool structure
  const tool = {
    name: "sayHello",
    description: "A simple tool that says hello"
  };
  expect(tool.name).toBe("sayHello");
});
```

### 7. Test the Server
```bash
# Run the server
bun run start

# Or run in development mode with auto-reload
bun run dev

# Run tests
bun test
```

### 8. MCP Client Configuration
To use with Claude Desktop or other MCP clients, add to configuration:
```json
{
  "mcpServers": {
    "hello-world": {
      "command": "bun",
      "args": ["run", "/path/to/bun-db-mcp/src/index.ts"]
    }
  }
}
```

## Key Implementation Notes

1. **Bun-specific considerations**:
   - Use `bun add` instead of npm/yarn
   - Leverage Bun's built-in TypeScript support
   - Use `bun test` for testing
   - Take advantage of Bun's fast startup time

2. **MCP Architecture**:
   - Server communicates via stdio (standard input/output)
   - Tools are registered and handled through request handlers
   - Each tool has a JSON schema for input validation
   - Responses include content blocks (text, images, etc.)

3. **Error Handling**:
   - Gracefully handle unknown tool requests
   - Proper error logging to stderr
   - Clean process exit on failure

## Expected Outcome
A working MCP server that:
- Responds to tool listing requests
- Executes the `sayHello` tool with a name parameter
- Returns formatted greeting messages
- Can be integrated with MCP-compatible clients
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  ListPromptsRequestSchema,
  GetPromptRequestSchema,
  ListResourcesRequestSchema,
  ReadResourceRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";
import dotenv from 'dotenv';
import DatabaseConnection from './db/connection.js';
import { TOOLS, handleToolCall } from './tools/index.js';
import fs from 'fs';
import path from 'path';

// dotenv.config();

const dbConfig = {
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '3306'),
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_DATABASE || 'mcp_test'
};

export const db = new DatabaseConnection(dbConfig);

const server = new Server(
  {
    name: "database-mcp",
    version: "2.0.0",
  },
  {
    capabilities: {
      tools: {},
      prompts: {},
      resources: {}
    }
  }
);

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
  } catch (error: any) {
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

server.setRequestHandler(ListPromptsRequestSchema, async () => ({
  prompts: [
    {
      name: "query-employees",
      title: "Query_Employees",
      description: "Query employees table using natural language instructions",
      arguments: [
        {
          name: "instructions",
          description: "Natural language query instructions (e.g., 'count female employees', 'show 10 recent hires')",
          required: true
        }
      ]
    },
    {
      name: "insert-employee",
      title: "Insert_Employee",
      description: "Insert a new employee with all related information (department, title, salary)",
      arguments: [
        {
          name: "employee_info",
          description: "Employee details including name, birth date, gender, department, title, and salary",
          required: true
        }
      ]
    },
    {
      name: "delete-employee",
      title: "Delete_Employee",
      description: "Delete an employee and all related records from the database",
      arguments: [
        {
          name: "employee_identifier",
          description: "Employee number or name to delete (e.g., '10001' or 'John Smith')",
          required: true
        }
      ]
    },
    {
      name: "manage-departments",
      title: "Manage_Departments",
      description: "Insert a new department or delete an existing department",
      arguments: [
        {
          name: "instructions",
          description: "Department operation (e.g., 'add Marketing department', 'delete department d005')",
          required: true
        }
      ]
    }
  ]
}));

server.setRequestHandler(GetPromptRequestSchema, async (request) => {
  if (request.params.name === "query-employees") {
    const promptPath = path.join(__dirname, 'specs', 'query-employees.md');
    const promptContent = fs.readFileSync(promptPath, 'utf-8');
    
    const userInstructions = request.params.arguments?.instructions || "";
    const messages = [
      {
        role: "user" as const,
        content: {
          type: "text" as const,
          text: promptContent.replace('$ARGUMENTS', userInstructions)
        }
      }
    ];
    
    return {
      description: "Query employees table using natural language instructions",
      messages
    };
  }
  
  if (request.params.name === "insert-employee") {
    const promptPath = path.join(__dirname, 'specs', 'insert-employee-info.md');
    const promptContent = fs.readFileSync(promptPath, 'utf-8');
    
    const employeeInfo = request.params.arguments?.employee_info || "";
    const messages = [
      {
        role: "user" as const,
        content: {
          type: "text" as const,
          text: promptContent.replace('$ARGUMENTS', employeeInfo)
        }
      }
    ];
    
    return {
      description: "Insert a new employee with all related information",
      messages
    };
  }
  
  if (request.params.name === "delete-employee") {
    const promptPath = path.join(__dirname, 'specs', 'delete-employee.md');
    const promptContent = fs.readFileSync(promptPath, 'utf-8');
    
    const employeeIdentifier = request.params.arguments?.employee_identifier || "";
    const messages = [
      {
        role: "user" as const,
        content: {
          type: "text" as const,
          text: promptContent.replace('$ARGUMENTS', employeeIdentifier)
        }
      }
    ];
    
    return {
      description: "Delete an employee and all related records",
      messages
    };
  }
  
  if (request.params.name === "manage-departments") {
    const promptPath = path.join(__dirname, 'specs', 'manage-departments.md');
    const promptContent = fs.readFileSync(promptPath, 'utf-8');
    
    const instructions = request.params.arguments?.instructions || "";
    const messages = [
      {
        role: "user" as const,
        content: {
          type: "text" as const,
          text: promptContent.replace('$ARGUMENTS', instructions)
        }
      }
    ];
    
    return {
      description: "Manage departments (insert or delete)",
      messages
    };
  }
  
  throw new Error(`Unknown prompt: ${request.params.name}`);
});

server.setRequestHandler(ListResourcesRequestSchema, async () => ({
  resources: [
    {
      uri: "bun-db-mcp://general-database",
      name: "Database Schema",
      description: "Complete documentation of the employee database schema including tables, relationships, and query patterns",
      mimeType: "text/markdown"
    }
  ]
}));

server.setRequestHandler(ReadResourceRequestSchema, async (request) => {
  if (request.params.uri === "bun-db-mcp://general-database") {
    const schemaPath = path.join(__dirname, 'specs', 'database-schema.md');
    const schemaContent = fs.readFileSync(schemaPath, 'utf-8');
    
    return {
      contents: [
        {
          uri: request.params.uri,
          mimeType: "text/markdown",
          text: schemaContent
        }
      ]
    };
  }
  
  throw new Error(`Unknown resource: ${request.params.uri}`);
});

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("Database MCP server running on stdio");
}

main().catch((error) => {
  console.error("Failed to start server:", error);
  process.exit(1);
});
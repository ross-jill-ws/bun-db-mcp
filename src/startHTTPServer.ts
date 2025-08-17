import { createServer } from 'http';
import { parse } from 'url';
import { randomUUID } from 'crypto';
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StreamableHTTPServerTransport } from "@modelcontextprotocol/sdk/server/streamableHttp.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  ListPromptsRequestSchema,
  GetPromptRequestSchema,
  ListResourcesRequestSchema,
  ReadResourceRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";
import { TOOLS, handleToolCall } from './tools/index.js';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Store StreamableHTTP transports by session ID
const httpTransports = new Map<string, StreamableHTTPServerTransport>();

export async function startHTTPServer(port: number) {
  const httpServer = createServer(async (req, res) => {
    const parsedUrl = parse(req.url || '', true);
    const pathname = parsedUrl.pathname;
    
    // Handle CORS headers for HTTP
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, DELETE, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Mcp-Session-Id');
    res.setHeader('Access-Control-Expose-Headers', 'Mcp-Session-Id');

    if (req.method === 'OPTIONS') {
      res.writeHead(200);
      res.end();
      return;
    }
    
    // StreamableHTTP uses a single /mcp endpoint
    if (pathname === '/mcp') {
      try {
        // Check for existing session ID in headers
        const sessionId = req.headers['mcp-session-id'] as string;
        let transport: StreamableHTTPServerTransport;
        
        if (sessionId && httpTransports.has(sessionId)) {
          // Reuse existing transport for this session
          transport = httpTransports.get(sessionId)!;
          console.error(`Reusing transport for session ${sessionId}`);
        } else if (!sessionId) {
          // New session - create transport
          console.error('Creating new transport for new session');
          const newSessionId = randomUUID();
          transport = new StreamableHTTPServerTransport({
            sessionIdGenerator: () => newSessionId,
            enableJsonResponse: true, // Enable JSON response mode
            onsessioninitialized: (sessionId) => {
              console.error(`Session initialized with ID: ${sessionId}`);
              // Session is already stored, just log it
            },
            onsessionclosed: (closedSessionId) => {
              console.error(`Session closed: ${closedSessionId}`);
              httpTransports.delete(closedSessionId);
            }
          });
          // Store immediately so subsequent requests can find it
          httpTransports.set(newSessionId, transport);
          
          // Create a new server instance for this session
          const serverInstance = new Server(
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
          
          // Register all handlers
          serverInstance.setRequestHandler(ListToolsRequestSchema, async () => ({
            tools: TOOLS
          }));
          
          serverInstance.setRequestHandler(CallToolRequestSchema, async (request) => {
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
          
          // Register prompts handler
          serverInstance.setRequestHandler(ListPromptsRequestSchema, async () => ({
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
          
          // Register GetPrompt handler
          serverInstance.setRequestHandler(GetPromptRequestSchema, async (request) => {
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
          
          // Register resources handlers
          serverInstance.setRequestHandler(ListResourcesRequestSchema, async () => ({
            resources: [
              {
                uri: "bun-db-mcp://general-database",
                name: "Database Schema",
                description: "Complete documentation of the employee database schema including tables, relationships, and query patterns",
                mimeType: "text/markdown"
              }
            ]
          }));
          
          serverInstance.setRequestHandler(ReadResourceRequestSchema, async (request) => {
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
          
          // Connect the transport to the MCP server
          await serverInstance.connect(transport);
        } else {
          // Session ID provided but not found
          res.writeHead(404, { 'Content-Type': 'application/json' });
          res.end(JSON.stringify({
            jsonrpc: '2.0',
            error: {
              code: -32000,
              message: 'Session not found',
            },
            id: null,
          }));
          return;
        }
        
        // Let the transport handle the request completely
        // It will parse the body, validate, and send the response
        await transport.handleRequest(req, res);
      } catch (error) {
        console.error('Error handling HTTP request:', error);
        if (!res.headersSent) {
          res.writeHead(500, { 'Content-Type': 'application/json' });
          res.end(JSON.stringify({
            jsonrpc: '2.0',
            error: {
              code: -32603,
              message: 'Internal server error',
            },
            id: null,
          }));
        }
      }
    } else {
      res.writeHead(404, { 'Content-Type': 'text/plain' });
      res.end('Not found');
    }
  });
  
  httpServer.listen(port, () => {
    console.error(`Database MCP StreamableHTTP server running on http://localhost:${port}`);
    console.error(`Endpoint: POST http://localhost:${port}/mcp`);
    console.error(`Session management via Mcp-Session-Id header`);
    console.error(`For JSON responses, use Accept: application/json`);
  });
}
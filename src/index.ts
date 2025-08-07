import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";

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

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [HELLO_TOOL]
}));

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

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("Hello World MCP server running on stdio");
}

main().catch((error) => {
  console.error("Failed to start server:", error);
  process.exit(1);
});
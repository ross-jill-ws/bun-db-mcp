import express, { type Request, type Response } from 'express';
import { randomUUID } from 'crypto';
import { StreamableHTTPServerTransport } from "@modelcontextprotocol/sdk/server/streamableHttp.js";
import { createMCPServer } from '../handlers.js';
import { getOAuthProtectedResourceMetadataUrl, mcpAuthMetadataRouter } from '@modelcontextprotocol/sdk/server/auth/router.js';
import { requireBearerAuth } from '@modelcontextprotocol/sdk/server/auth/middleware/bearerAuth.js';
import type { OAuthMetadata } from '@modelcontextprotocol/sdk/shared/auth.js';
import { checkResourceAllowed } from '@modelcontextprotocol/sdk/shared/auth-utils.js';
import { isInitializeRequest } from '@modelcontextprotocol/sdk/types.js';
import { setupAuthServer } from '../auth/demoInMemoryOAuthProvider.js';
import cors from 'cors';
import { InvalidTokenError } from '@modelcontextprotocol/sdk/server/auth/errors.js';

// Store StreamableHTTP transports by session ID
const httpTransports = new Map<string, StreamableHTTPServerTransport>();

export async function startHTTPServer(port: number) {
  // Check for OAuth flag
  const useOAuth = process.argv.includes('--oauth');
  const strictOAuth = process.argv.includes('--oauth-strict');

  const MCP_PORT = port;
  const AUTH_PORT = process.env.MCP_AUTH_PORT ? parseInt(process.env.MCP_AUTH_PORT, 10) : port + 1;

  const app = express();
  app.use(express.json());

  // Allow CORS all domains, expose the Mcp-Session-Id header
  app.use(cors({
    origin: '*', // Allow all origins
    exposedHeaders: ["Mcp-Session-Id"]
  }));

  // Set up OAuth if enabled
  let authMiddleware = null;
  if (useOAuth) {
    // Create auth middleware for MCP endpoints
    const mcpServerUrl = new URL(`http://localhost:${MCP_PORT}/mcp`);
    const authServerUrl = new URL(`http://localhost:${AUTH_PORT}`);

    const oauthMetadata: OAuthMetadata = setupAuthServer({ authServerUrl, mcpServerUrl, strictResource: strictOAuth });

    const tokenVerifier = {
      verifyAccessToken: async (token: string) => {
        const endpoint = oauthMetadata.introspection_endpoint;

        if (!endpoint) {
          throw new Error('No token verification endpoint available in metadata');
        }

        const response = await fetch(endpoint, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: new URLSearchParams({
            token: token
          }).toString()
        });

        if (!response.ok) {
          throw new InvalidTokenError(`Invalid or expired token: ${await response.text()}`);
        }

        const data = await response.json();

        if (strictOAuth) {
          if (!data.aud) {
            throw new Error(`Resource Indicator (RFC8707) missing`);
          }
          if (!checkResourceAllowed({ requestedResource: data.aud, configuredResource: mcpServerUrl })) {
            throw new Error(`Expected resource indicator ${mcpServerUrl}, got: ${data.aud}`);
          }
        }

        // Convert the response to AuthInfo format
        return {
          token,
          clientId: data.client_id,
          scopes: data.scope ? data.scope.split(' ') : [],
          expiresAt: data.exp,
        };
      }
    }

    // Add metadata routes to the main MCP server
    app.use(mcpAuthMetadataRouter({
      oauthMetadata,
      resourceServerUrl: mcpServerUrl,
      scopesSupported: ['mcp:tools'],
      resourceName: 'Database MCP Server',
    }));

    authMiddleware = requireBearerAuth({
      verifier: tokenVerifier,
      requiredScopes: [],
      resourceMetadataUrl: getOAuthProtectedResourceMetadataUrl(mcpServerUrl),
    });
  }

  // MCP POST endpoint with optional auth
  const mcpPostHandler = async (req: Request, res: Response) => {
    const sessionId = req.headers['mcp-session-id'] as string | undefined;
    if (sessionId) {
      console.error(`Received MCP request for session: ${sessionId}`);
    } else {
      console.error('Request body:', req.body);
    }

    if (useOAuth && req.auth) {
      console.error('Authenticated user:', req.auth);
    }

    try {
      let transport: StreamableHTTPServerTransport;
      if (sessionId && httpTransports.has(sessionId)) {
        // Reuse existing transport for this session
        transport = httpTransports.get(sessionId)!;
        console.error(`Reusing transport for session ${sessionId}`);
      } else if (!sessionId && isInitializeRequest(req.body)) {
        // New initialization request
        console.error('Creating new transport for new session');
        transport = new StreamableHTTPServerTransport({
          sessionIdGenerator: () => randomUUID(),
          onsessioninitialized: (sessionId) => {
            // Store the transport by session ID when session is initialized
            console.error(`Session initialized with ID: ${sessionId}`);
            httpTransports.set(sessionId, transport);
          },
          onsessionclosed: (closedSessionId) => {
            console.error(`Session closed: ${closedSessionId}`);
            httpTransports.delete(closedSessionId);
          }
        });

        // Set up onclose handler to clean up transport when closed
        transport.onclose = () => {
          const sid = transport.sessionId;
          if (sid && httpTransports.has(sid)) {
            console.error(`Transport closed for session ${sid}, removing from transports map`);
            httpTransports.delete(sid);
          }
        };

        // Connect the transport to the MCP server BEFORE handling the request
        const server = createMCPServer();
        await server.connect(transport);

        await transport.handleRequest(req, res, req.body);
        return; // Already handled
      } else {
        // Invalid request - no session ID or not initialization request
        res.status(400).json({
          jsonrpc: '2.0',
          error: {
            code: -32000,
            message: 'Bad Request: No valid session ID provided',
          },
          id: null,
        });
        return;
      }

      // Handle the request with existing transport
      await transport.handleRequest(req, res, req.body);
    } catch (error) {
      console.error('Error handling MCP request:', error);
      if (!res.headersSent) {
        res.status(500).json({
          jsonrpc: '2.0',
          error: {
            code: -32603,
            message: 'Internal server error',
          },
          id: null,
        });
      }
    }
  };

  // Handle GET requests for SSE streams
  const mcpGetHandler = async (req: Request, res: Response) => {
    const sessionId = req.headers['mcp-session-id'] as string | undefined;
    if (!sessionId || !httpTransports.has(sessionId)) {
      res.status(400).send('Invalid or missing session ID');
      return;
    }

    if (useOAuth && req.auth) {
      console.error('Authenticated SSE connection from user:', req.auth);
    }

    // Check for Last-Event-ID header for resumability
    const lastEventId = req.headers['last-event-id'] as string | undefined;
    if (lastEventId) {
      console.error(`Client reconnecting with Last-Event-ID: ${lastEventId}`);
    } else {
      console.error(`Establishing new SSE stream for session ${sessionId}`);
    }

    const transport = httpTransports.get(sessionId)!;
    await transport.handleRequest(req, res);
  };

  // Handle DELETE requests for session termination
  const mcpDeleteHandler = async (req: Request, res: Response) => {
    const sessionId = req.headers['mcp-session-id'] as string | undefined;
    if (!sessionId || !httpTransports.has(sessionId)) {
      res.status(400).send('Invalid or missing session ID');
      return;
    }

    console.error(`Received session termination request for session ${sessionId}`);

    try {
      const transport = httpTransports.get(sessionId)!;
      await transport.handleRequest(req, res);
    } catch (error) {
      console.error('Error handling session termination:', error);
      if (!res.headersSent) {
        res.status(500).send('Error processing session termination');
      }
    }
  };

  // Add Google OAuth callback handler if Google OAuth is configured
  if (useOAuth && process.env.GOOGLE_CLIENT_ID) {
    app.get('/auth/google/callback', async (req: Request, res: Response) => {
      const { code, state, error } = req.query;
      
      if (error) {
        res.status(400).send(`Authentication error: ${error}`);
        return;
      }

      // In a production app, you would handle the callback and redirect
      // to the client application with the authorization code
      res.send(`
        <html>
          <body>
            <h2>Google OAuth Callback Received</h2>
            <p>Authorization code: ${code}</p>
            <p>State: ${state}</p>
            <p>You can now exchange this code for an access token.</p>
            <script>
              // In a real app, you would post this back to your client
              if (window.opener) {
                window.opener.postMessage({ code: "${code}", state: "${state}" }, '*');
                window.close();
              }
            </script>
          </body>
        </html>
      `);
    });
  }

  // Set up routes with conditional auth middleware
  if (useOAuth && authMiddleware) {
    app.post('/mcp', authMiddleware, mcpPostHandler);
    app.get('/mcp', authMiddleware, mcpGetHandler);
    app.delete('/mcp', authMiddleware, mcpDeleteHandler);
  } else {
    app.post('/mcp', mcpPostHandler);
    app.get('/mcp', mcpGetHandler);
    app.delete('/mcp', mcpDeleteHandler);
  }

  app.listen(MCP_PORT, () => {
    console.error(`Database MCP StreamableHTTP server running on http://localhost:${MCP_PORT}`);
    console.error(`Endpoint: POST http://localhost:${MCP_PORT}/mcp`);
    console.error(`Session management via Mcp-Session-Id header`);
    if (useOAuth) {
      console.error(`OAuth authentication enabled (port ${AUTH_PORT})`);
      console.error(`Use --oauth-strict for stricter resource validation`);
    }
  });
}
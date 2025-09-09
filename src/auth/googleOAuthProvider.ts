import { OAuth2Client } from 'google-auth-library';
import jwt from 'jsonwebtoken';
import type { OAuthRegisteredClientsStore } from '@modelcontextprotocol/sdk/server/auth/clients.js';
import type { OAuthClientInformationFull, OAuthMetadata, OAuthTokens } from '@modelcontextprotocol/sdk/shared/auth.js';
import type { AuthorizationParams, OAuthServerProvider } from '@modelcontextprotocol/sdk/server/auth/provider.js';
import type { AuthInfo } from '@modelcontextprotocol/sdk/server/auth/types.js';
import { randomUUID } from 'node:crypto';
import type { Response } from 'express';

interface GoogleTokenPayload {
  iss: string;
  sub: string;
  azp: string;
  aud: string;
  iat: number;
  exp: number;
  email?: string;
  email_verified?: boolean;
  name?: string;
  picture?: string;
  locale?: string;
}

export class GoogleOAuthClientsStore implements OAuthRegisteredClientsStore {
  private clients = new Map<string, OAuthClientInformationFull>();

  async getClient(clientId: string) {
    return this.clients.get(clientId);
  }

  async registerClient(clientMetadata: OAuthClientInformationFull) {
    this.clients.set(clientMetadata.client_id, clientMetadata);
    return clientMetadata;
  }
}

export class GoogleOAuthProvider implements OAuthServerProvider {
  clientsStore = new GoogleOAuthClientsStore();
  private oauth2Client: OAuth2Client;
  private codes = new Map<string, {
    params: AuthorizationParams,
    client: OAuthClientInformationFull,
    googleCode?: string
  }>();
  private tokens = new Map<string, AuthInfo>();
  private jwtSecret: string;

  constructor(
    private clientId: string,
    private clientSecret: string,
    jwtSecret: string,
    private validateResource?: (resource?: URL) => boolean
  ) {
    this.oauth2Client = new OAuth2Client(clientId, clientSecret);
    this.jwtSecret = jwtSecret;
  }

  async authorize(
    client: OAuthClientInformationFull,
    params: AuthorizationParams,
    res: Response
  ): Promise<void> {
    // Generate state for CSRF protection
    const state = randomUUID();
    
    // Store the authorization request
    this.codes.set(state, {
      client,
      params
    });

    // Generate Google OAuth URL
    const authorizeUrl = this.oauth2Client.generateAuthUrl({
      access_type: 'online',
      scope: ['openid', 'email', 'profile'],
      redirect_uri: client.redirect_uris[0],
      state: state,
      prompt: 'select_account'
    });

    res.redirect(authorizeUrl);
  }

  async challengeForAuthorizationCode(
    client: OAuthClientInformationFull,
    authorizationCode: string
  ): Promise<string> {
    // const codeData = this.codes.get(authorizationCode);
    const codeData = (Array.from(this.codes.entries()).find(([key, value]) => value.client === client))?.[1];
    if (!codeData) {
      throw new Error('Invalid authorization code');
    }
    return codeData.params.codeChallenge;
  }

  async exchangeAuthorizationCode(
    client: OAuthClientInformationFull,
    authorizationCode: string,
    _codeVerifier?: string
  ): Promise<OAuthTokens> {
    // First check if this is a Google auth code or our internal code
    let googleTokens;
    let userInfo: GoogleTokenPayload | null = null;
    
    try {
      // Try to exchange with Google
      this.oauth2Client.setCredentials({
        refresh_token: undefined
      });
      
      const { tokens } = await this.oauth2Client.getToken({
        code: authorizationCode,
        redirect_uri: client.redirect_uris[0]
      });
      
      googleTokens = tokens;
      
      // Verify the ID token if present
      if (tokens.id_token) {
        const ticket = await this.oauth2Client.verifyIdToken({
          idToken: tokens.id_token,
          audience: this.clientId
        });
        userInfo = ticket.getPayload() as GoogleTokenPayload;
      }
    } catch (error) {
      // If Google exchange fails, check if it's an internal code
      const codeData = this.codes.get(authorizationCode);
      if (!codeData) {
        throw new Error('Invalid authorization code');
      }

      if (codeData.client.client_id !== client.client_id) {
        throw new Error(`Authorization code was not issued to this client`);
      }

      if (this.validateResource && !this.validateResource(codeData.params.resource)) {
        throw new Error(`Invalid resource: ${codeData.params.resource}`);
      }

      this.codes.delete(authorizationCode);
      
      // Generate our own token
      const token = randomUUID();
      const tokenData = {
        token,
        clientId: client.client_id,
        scopes: codeData.params.scopes || [],
        expiresAt: Date.now() + 3600000,
        resource: codeData.params.resource,
        type: 'access' as const,
      };

      this.tokens.set(token, tokenData);

      return {
        access_token: token,
        token_type: 'bearer',
        expires_in: 3600,
        scope: (codeData.params.scopes || []).join(' ')
      };
    }

    // Create our own JWT token that includes Google user info
    const payload = {
      sub: userInfo?.sub || 'unknown',
      email: userInfo?.email,
      name: userInfo?.name,
      picture: userInfo?.picture,
      clientId: client.client_id,
      scopes: ['mcp:tools'],
      googleAccessToken: googleTokens.access_token,
      iat: Math.floor(Date.now() / 1000),
      exp: Math.floor(Date.now() / 1000) + 3600
    };

    const token = jwt.sign(payload, this.jwtSecret);
    
    // Store token info for verification
    const tokenData = {
      token,
      clientId: client.client_id,
      scopes: ['mcp:tools'],
      expiresAt: Date.now() + 3600000,
      resource: undefined,
      type: 'access' as const,
      googleAccessToken: googleTokens.access_token
    };
    
    this.tokens.set(token, tokenData);

    return {
      access_token: token,
      token_type: 'bearer',
      expires_in: 3600,
      scope: 'mcp:tools',
      id_token: googleTokens.id_token as string
    };
  }

  async exchangeRefreshToken(
    _client: OAuthClientInformationFull,
    _refreshToken: string,
    _scopes?: string[],
    _resource?: URL
  ): Promise<OAuthTokens> {
    throw new Error('Refresh tokens not implemented for Google OAuth');
  }

  async verifyAccessToken(token: string): Promise<AuthInfo> {
    // First check if it's in our cache
    const cachedToken = this.tokens.get(token);
    if (cachedToken) {
      if (!cachedToken.expiresAt || cachedToken.expiresAt < Date.now()) {
        this.tokens.delete(token);
        throw new Error('Token expired');
      }
      return {
        token,
        clientId: cachedToken.clientId,
        scopes: cachedToken.scopes,
        expiresAt: Math.floor(cachedToken.expiresAt / 1000),
        resource: cachedToken.resource
      };
    }

    // Try to verify as JWT
    try {
      const decoded = jwt.verify(token, this.jwtSecret) as any;
      
      // Verify Google token is still valid if present
      if (decoded.googleAccessToken) {
        try {
          await this.oauth2Client.getTokenInfo(decoded.googleAccessToken);
        } catch (error) {
          throw new Error('Google token invalid or expired');
        }
      }

      return {
        token,
        clientId: decoded.clientId,
        scopes: decoded.scopes || ['mcp:tools'],
        expiresAt: decoded.exp,
        resource: undefined
      };
    } catch (error) {
      throw new Error(`Invalid token: ${error}`);
    }
  }
}
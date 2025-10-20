#!/usr/bin/env node

/**
 * Generate Apple Sign-In JWT for Supabase
 *
 * This script generates a JWT token for Apple Sign-In OAuth configuration in Supabase.
 *
 * Usage:
 *   node generate_apple_jwt.js <path-to-p8-file> <team-id> <key-id> <client-id>
 *
 * Example:
 *   node generate_apple_jwt.js ./AuthKey_ABC123.p8 D5573X74YC ABC123 com.getvenyu.venyu.service
 */

const fs = require('fs');
const crypto = require('crypto');

// Parse command line arguments
const [,, p8FilePath, teamId, keyId, clientId] = process.argv;

if (!p8FilePath || !teamId || !keyId || !clientId) {
  console.error('Usage: node generate_apple_jwt.js <path-to-p8-file> <team-id> <key-id> <client-id>');
  console.error('');
  console.error('Example:');
  console.error('  node generate_apple_jwt.js ./AuthKey_ABC123.p8 D5573X74YC ABC123 com.getvenyu.venyu.service');
  process.exit(1);
}

try {
  // Read the private key from .p8 file
  const privateKey = fs.readFileSync(p8FilePath, 'utf8');

  // Create JWT header
  const header = {
    alg: 'ES256',
    kid: keyId,
    typ: 'JWT'
  };

  // Create JWT payload
  // Token expires in 6 months (maximum allowed by Apple)
  const now = Math.floor(Date.now() / 1000);
  const payload = {
    iss: teamId,
    iat: now,
    exp: now + (6 * 30 * 24 * 60 * 60), // 6 months
    aud: 'https://appleid.apple.com',
    sub: clientId
  };

  // Encode header and payload
  const encodedHeader = base64UrlEncode(JSON.stringify(header));
  const encodedPayload = base64UrlEncode(JSON.stringify(payload));

  // Create signature
  const signatureInput = `${encodedHeader}.${encodedPayload}`;
  const signature = crypto
    .createSign('RSA-SHA256')
    .update(signatureInput)
    .sign(privateKey, 'base64');
  const encodedSignature = base64UrlEncode(Buffer.from(signature, 'base64'));

  // Combine to create JWT
  const jwt = `${encodedHeader}.${encodedPayload}.${encodedSignature}`;

  console.log('');
  console.log('✅ JWT Token Generated Successfully!');
  console.log('');
  console.log('Copy this token and paste it into Supabase "Secret Key (for OAuth)" field:');
  console.log('');
  console.log(jwt);
  console.log('');
  console.log('⚠️  Note: This token expires in 6 months. Generate a new one before expiration.');
  console.log('');

} catch (error) {
  console.error('❌ Error generating JWT:', error.message);
  process.exit(1);
}

/**
 * Base64 URL encode
 */
function base64UrlEncode(str) {
  const buffer = Buffer.isBuffer(str) ? str : Buffer.from(str);
  return buffer
    .toString('base64')
    .replace(/\+/g, '-')
    .replace(/\//g, '_')
    .replace(/=/g, '');
}

#!/usr/bin/env node

/**
 * Generate Apple Sign-In JWT for Supabase (using jsonwebtoken library)
 *
 * First install: npm install jsonwebtoken
 * Then run: node generate_apple_jwt_v2.js <path-to-p8-file> <team-id> <key-id> <client-id>
 */

const fs = require('fs');
const jwt = require('jsonwebtoken');

const [,, p8FilePath, teamId, keyId, clientId] = process.argv;

if (!p8FilePath || !teamId || !keyId || !clientId) {
  console.error('Usage: node generate_apple_jwt_v2.js <path-to-p8-file> <team-id> <key-id> <client-id>');
  console.error('');
  console.error('Example:');
  console.error('  node generate_apple_jwt_v2.js ./AuthKey_ABC123.p8 D5573X74YC ABC123 com.getvenyu.venyu.service');
  process.exit(1);
}

try {
  // Read the private key
  const privateKey = fs.readFileSync(p8FilePath, 'utf8');

  // Create JWT payload
  const now = Math.floor(Date.now() / 1000);
  const payload = {
    iss: teamId,
    iat: now,
    exp: now + (6 * 30 * 24 * 60 * 60), // 6 months (maximum allowed)
    aud: 'https://appleid.apple.com',
    sub: clientId
  };

  // Generate JWT
  const token = jwt.sign(payload, privateKey, {
    algorithm: 'ES256',
    keyid: keyId
  });

  console.log('');
  console.log('✅ JWT Token Generated Successfully!');
  console.log('');
  console.log('Copy this token and paste it into Supabase "Secret Key (for OAuth)" field:');
  console.log('');
  console.log(token);
  console.log('');
  console.log('⚠️  Note: This token expires in 6 months. Generate a new one before expiration.');
  console.log('');

} catch (error) {
  console.error('❌ Error:', error.message);
  if (error.message.includes('jsonwebtoken')) {
    console.error('');
    console.error('Please install jsonwebtoken first:');
    console.error('  npm install jsonwebtoken');
  }
  process.exit(1);
}

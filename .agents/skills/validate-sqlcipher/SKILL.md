---
name: validate-sqlcipher
description: Use when creating or modifying database repositories to ensure AES-256 SQLCipher encryption is properly configured.
---

# SQLite Encryption Check
When asked to validate the database layer, ensure the implementation aligns with the data layer constraints.

1. Verify that the database engine uses SQLCipher 4.x.
2. Check that the encryption key is derived from a 256-bit secret stored securely in the iOS Keychain or Android Keystore.
3. Ensure no data is persisted outside of this encrypted container.
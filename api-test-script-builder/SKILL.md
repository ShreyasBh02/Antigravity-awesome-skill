---
name: api-test-script-builder
description: >
  Generates complete, ready-to-run API test scripts from any input — endpoint descriptions,
  Swagger/OpenAPI specs, Postman collections, curl commands, or plain English. Outputs working
  test code in the user's preferred framework: Python pytest + requests, Postman Collection (JSON),
  or JavaScript Jest + axios. Always trigger this skill for ANY of these situations:
  "API testing", "test this endpoint", "write API tests", "generate test cases", "Postman collection",
  "pytest for API", "REST API test", "API automation", "validate API response", "check my endpoint",
  "test my routes", "QA this API", sharing a Swagger/OpenAPI spec, sharing a curl command,
  sharing an API route or payload, or any request involving HTTP endpoint verification.
  Trigger even for vague inputs like "test this" when an API context is present — structured,
  runnable scripts are always better than ad-hoc manual testing.
---

# API Test Script Builder

Generate complete, runnable API test scripts from any input in your preferred framework.

---

## Supported Input Types

- **Plain English** — "Test a login endpoint that takes email and password and returns a token"
- **Curl commands** — `curl -X POST https://api.example.com/login -d '{"email":"..."}'`
- **Swagger / OpenAPI** — Paste YAML or JSON spec
- **Postman Collection** — Paste exported JSON
- **GraphQL** — Query + schema + expected response shape
- **Endpoint table** — Method + URL + body + expected response

---

## Supported Output Frameworks

| Framework | Best For | Output File |
|---|---|---|
| **Python pytest** | CI/CD pipelines, backend QA | `test_api.py` + `.env.example` |
| **Postman Collection** | Manual + automated testing, team sharing | `collection.json` |
| **JavaScript Jest** | Frontend / Node.js teams | `api.test.js` + `.env.example` |

**Default: Python pytest** — most portable, works in any CI/CD pipeline.

---

## Workflow

### Step 1 — Parse the Input

Extract for each endpoint:
- HTTP method (GET, POST, PUT, PATCH, DELETE)
- URL / path (note path params like `{id}`)
- Request headers (Content-Type, auth headers)
- Request body / query params with data types
- Expected response: status code + response body shape
- Auth type: Bearer token | API key (header or query) | Basic auth | OAuth2 | None

If details are missing, make sensible assumptions and document them as comments in the code.

---

### Step 2 — Identify What to Test Per Endpoint

| Test Type | Description |
|---|---|
| ✅ Happy Path | Valid request → expected 2xx + correct response shape |
| ❌ Invalid Input | Missing/wrong fields → 400/422 |
| 🔐 Unauthorized | No/invalid/expired token → 401 |
| 🚫 Forbidden | Valid token, insufficient permissions → 403 |
| 🔍 Not Found | Non-existent ID or resource → 404 |
| 🔲 Boundary | Empty string, null, very long values, special characters |
| 📋 Schema Check | Response fields exist and have correct types |

---

### Step 3 — Generate the Script

#### Python pytest (`test_api.py` + `.env.example`)

Key rules:
- `BASE_URL` and `AUTH_TOKEN` read from environment variables — never hardcoded in tests
- One class per endpoint group
- Use `pytest.fixture` for shared setup (headers, auth token)
- Use `response.json()` only after asserting `status_code` — avoids misleading errors
- Mark expected-failure tests with `@pytest.mark.xfail` where appropriate
- For endpoints with path params, parametrize with `@pytest.mark.parametrize`

Structure:
```
"""
API Tests: <Service Name>
Base URL: <base_url>

Setup:
  pip install pytest requests python-dotenv
  cp .env.example .env  # fill in your values
  Run: pytest test_api.py -v
"""

import os
import pytest
import requests
from dotenv import load_dotenv

load_dotenv()

BASE_URL = os.getenv("BASE_URL", "https://api.example.com")
AUTH_TOKEN = os.getenv("AUTH_TOKEN", "")
HEADERS = {"Content-Type": "application/json", "Authorization": f"Bearer {AUTH_TOKEN}"}


class TestLoginEndpoint:
    """POST /auth/login"""

    def test_login_success(self):
        payload = {"email": "test@example.com", "password": "ValidPass123"}
        r = requests.post(f"{BASE_URL}/auth/login", json=payload)
        assert r.status_code == 200
        data = r.json()
        assert "token" in data
        assert isinstance(data["token"], str)
        assert len(data["token"]) > 0

    def test_login_wrong_password(self):
        r = requests.post(f"{BASE_URL}/auth/login",
                          json={"email": "test@example.com", "password": "wrong"})
        assert r.status_code == 401

    def test_login_missing_email(self):
        r = requests.post(f"{BASE_URL}/auth/login", json={"password": "ValidPass123"})
        assert r.status_code in [400, 422]

    def test_login_empty_body(self):
        r = requests.post(f"{BASE_URL}/auth/login", json={})
        assert r.status_code in [400, 422]

    def test_login_invalid_email_format(self):
        r = requests.post(f"{BASE_URL}/auth/login",
                          json={"email": "notanemail", "password": "ValidPass123"})
        assert r.status_code in [400, 422]

    def test_login_no_auth_header(self):
        # Endpoint itself doesn't require auth, but confirms endpoint is reachable
        r = requests.post(f"{BASE_URL}/auth/login", json={})
        assert r.status_code != 500  # Should never return a server error
```

`.env.example`:
```
BASE_URL=https://api.example.com
AUTH_TOKEN=your-token-here
```

---

#### Postman Collection (`collection.json`)

Generate valid Postman Collection v2.1 JSON with:
- Collection name + description
- One folder per endpoint group
- Each request: name, method, URL with path variables, headers, raw JSON body
- `Tests` tab with `pm.test(...)` assertions for status code + response fields
- Pre-request script for auth token refresh if OAuth2
- Environment variables: `{{base_url}}`, `{{auth_token}}` — never hardcoded URLs

---

#### JavaScript Jest (`api.test.js` + `.env.example`)

Key rules:
- Use `axios` with try/catch — axios throws on 4xx/5xx, so catch and assert `error.response.status`
- Read config from `process.env` via `dotenv`
- One `describe` block per endpoint
- `beforeAll` for any auth setup (e.g. login to get token)

Structure:
```javascript
/**
 * API Tests: <Service Name>
 * Setup: npm install jest axios dotenv
 * Run: npx jest api.test.js --verbose
 */

require('dotenv').config();
const axios = require('axios');

const BASE_URL = process.env.BASE_URL || 'https://api.example.com';
const AUTH_TOKEN = process.env.AUTH_TOKEN || '';
const headers = { Authorization: `Bearer ${AUTH_TOKEN}`, 'Content-Type': 'application/json' };

describe('POST /auth/login', () => {
  test('200 + token for valid credentials', async () => {
    const res = await axios.post(`${BASE_URL}/auth/login`,
      { email: 'test@example.com', password: 'ValidPass123' });
    expect(res.status).toBe(200);
    expect(res.data).toHaveProperty('token');
    expect(typeof res.data.token).toBe('string');
  });

  test('401 for wrong password', async () => {
    await expect(
      axios.post(`${BASE_URL}/auth/login`, { email: 'test@example.com', password: 'wrong' })
    ).rejects.toMatchObject({ response: { status: 401 } });
  });

  test('400/422 for missing fields', async () => {
    await expect(
      axios.post(`${BASE_URL}/auth/login`, {})
    ).rejects.toSatisfy(e => [400, 422].includes(e.response?.status));
  });
});
```

---

### Step 4 — Save & Present

1. Save all output files to `/mnt/user-data/outputs/`
2. Use `present_files` to deliver
3. Print a chat summary containing:
   - List of endpoints covered
   - Total test count (broken down by test type: happy path / negative / boundary)
   - Framework used
   - How to install dependencies and run
   - Any assumptions made (e.g. inferred auth type, guessed base URL)

---

## Auth Handling Reference

| Auth Type | How to implement |
|---|---|
| Bearer token | `Authorization: Bearer {{token}}` header |
| API key (header) | `X-API-Key: {{api_key}}` header |
| API key (query) | `?api_key={{api_key}}` appended to URL |
| Basic auth | `Authorization: Basic base64(user:pass)` |
| OAuth2 | `beforeAll` login call → store token → inject into all requests |
| No auth | Confirm 401 is returned when auth header is added unexpectedly |

---

## Tips for Best Results

- **Share the full spec** if you have Swagger/OpenAPI — it gives the most complete coverage automatically.
- **Mention the auth type** — otherwise Bearer token is assumed.
- **Specify the framework** if you have a preference — otherwise Python pytest is generated.
- **Multiple endpoints?** List or paste them all — each gets its own class/describe block.
- **Have a Postman collection already?** Share it to generate pytest or Jest equivalents.
- **GraphQL?** Share the query + expected response shape — test coverage includes variable injection and error states.
# API Test Script Builder

## Overview
Generates complete, ready-to-run API test scripts from any input — plain English descriptions,
Swagger/OpenAPI specs, Postman collections, curl commands, or endpoint tables.

## Supported Frameworks
| Framework | Output |
|---|---|
| **Python pytest** *(default)* | `test_api.py` + `.env.example` |
| **Postman Collection** | `collection.json` |
| **JavaScript Jest** | `api.test.js` + `.env.example` |

## How to Use

**From plain English:**
> "Write API tests for a login endpoint: POST /api/login with email and password, returns a JWT token."

**From a curl command:**
> "Write tests for this: `curl -X POST https://api.example.com/users -H 'Authorization: Bearer TOKEN' -d '{\"name\":\"Alice\"}'`"

**From a Swagger/OpenAPI spec:**
> "Generate pytest tests from this OpenAPI spec: [paste YAML or JSON]"

**Specifying a framework:**
> "Generate a Postman collection for my GET /products and POST /orders endpoints."

**Multiple endpoints at once:**
> "Write Jest tests for these 3 endpoints: GET /users, POST /users, DELETE /users/{id}"

## What Gets Generated

For each endpoint the skill produces:
- ✅ Happy path test (valid input → correct status + response shape)
- ❌ Negative tests (missing fields, wrong types → 400/422)
- 🔐 Auth tests (no token → 401, wrong permissions → 403)
- 🔍 Not found test (invalid ID → 404)
- 🔲 Boundary tests (empty body, null values, very long strings)
- 📋 Response schema validation (field presence + types)

## Output Files
All files are saved and downloadable. Python and Jest outputs include a `.env.example`
so credentials are never hardcoded in test files.
# Bug Report Writer

## Overview
Turns rough notes, one-liners, console errors, or stack traces into professional, structured
bug reports — exported as a formatted **Excel (.xlsx)** file ready for Excel, Google Sheets,
Jira, or Azure DevOps. Works for single bugs or multiple bugs described in one message.

## Supported Input Types
- One-liner descriptions ("Login button does nothing on mobile")
- Rough notes or casual language ("tried to reset password, got error 500, only on Chrome")
- Pasted console errors or stack traces
- Step-by-step descriptions that just need formatting
- Multiple bugs at once ("I found 3 issues today…")

## How to Use

**From a one-liner:**
> "Write a bug report: clicking checkout crashes the page, console says 'ReferenceError: cart is not defined'."

**From rough notes:**
> "Bug report — password reset email never arrives. Happens on all browsers. Worked fine last week."

**Multiple bugs at once:**
> "Found 3 bugs today: 1) Search returns no results on mobile, 2) Profile photo upload fails with a 413 error, 3) Dark mode toggle resets on page refresh."

**With environment details:**
> "Log a bug: the dashboard graph doesn't load on Safari 17 / macOS Sonoma. Chrome works fine."

## What You Get

For each bug:
- A clean text summary printed in chat for immediate review
- A downloadable `.xlsx` file with two sheets:
  - **Bug Reports** — one row per bug, color-coded by severity and priority
  - **Bug Summary** — totals broken down by severity, priority, module, and status

## Output Example (chat preview)
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
BUG-001 · [Checkout] Page crashes on checkout click
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Severity: 🔴 Critical    Priority: P1
Module:   Checkout
Reported: QA Tester · 2025-01-15    Status: Open

Environment:
  OS: Windows 11 · Browser: Chrome 122 · Device: Desktop [Assumed]

Steps to Reproduce:
  1. Add item to cart
  2. Click "Checkout"

Expected: Checkout page loads
Actual:   Page crashes — "ReferenceError: cart is not defined"

Attachments needed: [ ] Screenshot  [ ] Console logs  [ ] Network logs
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Tips
- The more detail you provide, the better — but even vague descriptions work.
- Any missing fields are filled with smart `[Assumed]` values, clearly marked.
- Paste console errors raw — they're used verbatim as the Actual Result.
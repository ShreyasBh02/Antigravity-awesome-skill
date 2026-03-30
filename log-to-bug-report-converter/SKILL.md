---
name: log-to-bug-report-converter
description: Parses error logs, stack traces, and test failures into production-ready bug reports.
---
# Log-to-Bug-Report Converter (RCA Tool)

Turn noisy log dumps into clean, actionable, developer-ready bug reports in Markdown.

## Instructions
1. Ingest unstructured logs, stack traces, Jenkins/GitHub Actions failure outputs, or console dumps.
2. Analyze the root cause by finding the earliest critical exception or logical error.
3. Generate a structured Bug Report containing:
   - **Title**: Clear, concise summary of the issue.
   - **Environment/Context**: Assumptions based on stack trace (e.g., Java version, Spring Boot, OS).
   - **Steps to Reproduce**: Derived logically from the trace/context.
   - **Expected Behavior**: What should have happened.
   - **Actual Behavior**: The exact failure/exception snippet.
   - **Root Cause Analysis (RCA)**: A developer-centric explanation of exactly what line/module failed and why (e.g., NullPointerException at BaseTest.java:45 due to an uninitialized WebDriver).
4. Use standard Markdown format so it can be easily copied to Jira, Azure DevOps, or GitHub Issues.

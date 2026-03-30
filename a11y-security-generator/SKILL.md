---
name: a11y-security-generator
description: Generates Selenium Java wrappers for axe-core accessibility testing and OWASP UI/API security checks.
---
# Accessibility & Security Test Generator

Shift-left your QA workflow by embedding Accessibility (a11y) and Security testing directly into UI/API tests.

## Instructions
1. Understand the user's component or endpoint.
2. **Accessibility (a11y)**: Generate Java Selenium code integrating `axe-core-selenium` (`com.deque.html.axe-core:selenium`).
   - Output code showing `AxeBuilder` usage.
   - Assert on WCAG violations.
3. **Security (OWASP)**: Generate common negative UI/API test vectors for the OWASP Top 10:
   - SQL Injection (e.g., `' OR 1=1--`).
   - XSS Payloads (e.g., `<script>alert('xss')</script>`).
   - Missing authentication/authorization checks.
4. Provide the updated full Java test class covering these aspects alongside clear instructions for pom.xml/gradle dependencies.

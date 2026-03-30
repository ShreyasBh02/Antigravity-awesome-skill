---
name: performance-test-scripter
description: Generates JMeter (.jmx) test plans and load testing scripts from API specs or user requests.
---
# Performance/Load Test Scripter (JMeter)

Generate robust Apache JMeter test profiles for load, stress, and spike testing.

## Instructions
1. When a user provides an API endpoint, Postman collection snippet, or plain English requirement, analyze the target traffic constraints.
2. Generate an XML JMeter (.jmx) configuration representing the test plan. Since raw JMX XML can be massive, focus on generating the core ThreadGroup, HTTP Request Defaults, HTTP Samplers, and Listeners.
3. Include standard components:
   - Thread Group (configurable users, ramp-up, loop count).
   - HTTP Header Manager.
   - HTTP Request Sampler.
   - (Optional) JSON Extractor for correlation.
   - Response Assertion.
4. Output setup instructions on how to naturally import/run the generated JMX file in JMeter GUI or CLI (`jmeter -n -t script.jmx -l results.jtl`).

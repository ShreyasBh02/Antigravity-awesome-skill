# Performance/Load Test Scripter

## Overview
This skill acts as your personal Performance Engineer. Give it an endpoint or an API description, and it will generate an Apache JMeter test plan!

## How to use
Tell the agent:
> "Create a JMeter load test for my login API: POST /api/login with an email and password payload. Simulate 500 users over 60 seconds."

The agent will output a JMeter standard configuration that you can save as `.jmx` and run locally.

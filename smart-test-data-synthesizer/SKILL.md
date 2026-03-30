---
name: smart-test-data-synthesizer
description: Generates complex test data in SQL, JSON, or Java (using DataFaker) based on QA needs.
---
# Smart Test Data Synthesizer

Generate robust and relational test data tailored for database seeding, API testing, and UI automation.

## Instructions
1. Analyze the user's data schema or entity descriptions.
2. Based on the user's request, choose the "Best of All" formats or produce all three formats to provide deep value:
   - **SQL INSERT Statements**: Provide raw relational SQL with proper foreign key linkages.
   - **JSON Payloads**: Provide complex nested JSON arrays for API requests.
   - **Java Code (DataFaker)**: Provide Java class methods using the `net.datafaker.Faker` library to generate randomized test entities dynamically for Selenium/RestAssured.
3. Ensure realism in the generated data (e.g., realistic names, active/expired credit cards, logical dates).
4. Provide instructions on how to execute or integrate the test data.

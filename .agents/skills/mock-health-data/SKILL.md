---
name: mock-health-data
description: Use when building the check-in engine to generate mock Apple Health or Google Fit data for local testing.
---

# Mock Health Data Generator
The app reads passively from Apple Health or Google Fit with explicit user permission. When testing the baseline tracker, use this skill to generate compliant mock data.

1. Generate JSON representing step count, sleep duration, and resting heart rate.
2. Ensure the generated mock data is only read into memory and never written to the encrypted SQLite database.
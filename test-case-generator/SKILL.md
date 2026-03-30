---
name: test-case-generator
description: >
  Generates comprehensive, structured test cases from feature descriptions, user stories,
  requirements, or acceptance criteria — and exports them as a formatted Excel (.xlsx) file
  ready for use in Excel or Google Sheets. Use this skill whenever the user mentions:
  "write test cases", "generate test cases", "create test scenarios", "test coverage",
  "QA testing", "test a feature", "test this requirement", "positive/negative test cases",
  "edge cases", "boundary value testing", or shares a user story / requirement and wants
  it tested. Also trigger when user says "I need to test X" or pastes a Jira story, BRD,
  or PRD excerpt expecting test output. Always use this skill for test case creation — even
  if the request seems simple, a structured Excel output is almost always more useful.
---

# Test Case Generator

Generate structured, comprehensive test cases from any input — and export them as a
formatted, ready-to-use **Excel (.xlsx)** file compatible with Excel and Google Sheets.

---

## Input Types Supported

- **User Stories** — "As a user, I want to..."
- **Feature Descriptions** — Plain English description of a feature
- **Acceptance Criteria** — Bullet points or Gherkin-style Given/When/Then
- **API Endpoints** — Method, URL, request/response details
- **Bug Fixes** — Regression test cases from a bug description
- **Rough Notes** — Even messy, informal input is fine

---

## Workflow

### Step 1 — Understand the Input
Read the input carefully and identify:
- **What** is being tested (feature, API, UI flow, business rule)
- **Who** is the actor (end user, admin, system, API consumer)
- **What** are the success and failure conditions
- **What** data or state is involved

If the input is ambiguous, make reasonable assumptions and state them clearly before generating.

### Step 2 — Identify Test Categories
Always cover these categories (skip only if clearly not applicable):

| Category | Description |
|---|---|
| Positive | Valid inputs, expected flow works correctly |
| Negative | Invalid inputs, rejected requests, error states |
| Boundary | Min/max values, empty, null, zero, max length |
| Security | Auth checks, unauthorized access, injection attempts |
| UI/UX | Responsive, disabled states, loading states (if applicable) |
| Regression | Existing functionality should not break |

### Step 3 — Generate & Export to Excel

Use Python + openpyxl to produce a formatted .xlsx file with 3 sheets:

**Sheet 1 — Test Cases**: TC ID | Title | Category | Preconditions | Test Steps | Expected Result | Status (blank) | Priority

**Sheet 2 — Test Data**: Suggested valid, invalid, and boundary values per field

**Sheet 3 — Summary**: Feature name, date, total count, breakdown by category and priority

#### Formatting Rules
- Header row: Bold white text on dark blue (#1F4E79), frozen
- Category column: color-coded fills per category
  - Positive → #E2EFDA (green), Negative → #FCE4D6 (red), Boundary → #FFF2CC (yellow)
  - Security → #E8D5F5 (purple), UI/UX → #DEEAF1 (blue), Regression → #FFF2CC (yellow)
- Priority column: High → #F4CCCC, Medium → #FCE5CD, Low → #D9EAD3
- Status column: light grey (#EEEEEE), left blank for testers
- Font: Arial 10pt; wrap text on Test Steps and Expected Result columns
- Row height: 50px for data rows; column widths auto-fit (Test Steps = 55, Expected = 40)
- Thin borders on all cells
- Sheet tab colors: blue (Test Cases), green (Test Data), grey (Summary)

### Step 4 — Save & Present
- Filename: `test-cases-<feature-name>.xlsx` (kebab-case)
- Copy to `/mnt/user-data/outputs/`
- Use `present_files` tool to deliver to user
- Print a brief chat summary: total TCs generated, categories covered

---

## Python Code Template

```python
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter
from datetime import date

wb = Workbook()

# Sheet 1: Test Cases
ws = wb.active
ws.title = "Test Cases"
ws.sheet_properties.tabColor = "1F4E79"

HEADERS = ["TC ID","Title","Category","Preconditions","Test Steps","Expected Result","Status","Priority"]
HEADER_FILL = PatternFill("solid", fgColor="1F4E79")
HEADER_FONT = Font(bold=True, color="FFFFFF", name="Arial", size=10)
DATA_FONT   = Font(name="Arial", size=10)
THIN        = Side(style="thin")
BORDER      = Border(left=THIN, right=THIN, top=THIN, bottom=THIN)

CAT_FILLS = {
    "Positive":   "E2EFDA", "Negative": "FCE4D6", "Boundary": "FFF2CC",
    "Security":   "E8D5F5", "UI/UX":    "DEEAF1", "Regression": "FFF2CC",
}
PRI_FILLS = {"High": "F4CCCC", "Medium": "FCE5CD", "Low": "D9EAD3"}

for col, h in enumerate(HEADERS, 1):
    c = ws.cell(row=1, column=col, value=h)
    c.font, c.fill, c.border = HEADER_FONT, HEADER_FILL, BORDER
    c.alignment = Alignment(horizontal="center", vertical="center", wrap_text=True)
ws.freeze_panes = "A2"
ws.row_dimensions[1].height = 30

# --- Replace test_cases with actual generated data ---
test_cases = [
    # (tc_id, title, category, preconditions, steps, expected, priority)
]

for r, (tc_id, title, cat, pre, steps, exp, pri) in enumerate(test_cases, 2):
    row = [tc_id, title, cat, pre, steps, exp, "", pri]
    ws.row_dimensions[r].height = 50
    for col, val in enumerate(row, 1):
        c = ws.cell(row=r, column=col, value=val)
        c.font, c.border = DATA_FONT, BORDER
        c.alignment = Alignment(vertical="top", wrap_text=True)
        if col == 3 and cat in CAT_FILLS:
            c.fill = PatternFill("solid", fgColor=CAT_FILLS[cat])
        elif col == 7:
            c.fill = PatternFill("solid", fgColor="EEEEEE")
            c.alignment = Alignment(horizontal="center", vertical="top")
        elif col == 8 and pri in PRI_FILLS:
            c.fill = PatternFill("solid", fgColor=PRI_FILLS[pri])
            c.alignment = Alignment(horizontal="center", vertical="top")

for i, w in enumerate([10,30,14,28,55,40,12,10], 1):
    ws.column_dimensions[get_column_letter(i)].width = w

# Sheet 2: Test Data
ws2 = wb.create_sheet("Test Data")
ws2.sheet_properties.tabColor = "70AD47"
for col, h in enumerate(["Field / Parameter","Valid Values","Invalid Values","Boundary Values","Notes"], 1):
    c = ws2.cell(row=1, column=col, value=h)
    c.font, c.fill, c.border = HEADER_FONT, HEADER_FILL, BORDER
    c.alignment = Alignment(horizontal="center", vertical="center")
ws2.freeze_panes = "A2"
# Add test data rows here

# Sheet 3: Summary
ws3 = wb.create_sheet("Summary")
ws3.sheet_properties.tabColor = "808080"
from collections import Counter
cat_counts = Counter(tc[2] for tc in test_cases)
pri_counts = Counter(tc[6] for tc in test_cases)

summary_rows = [
    ("Feature / Module", "<feature name>"),
    ("Date Generated", str(date.today())),
    ("Total Test Cases", len(test_cases)),
    ("", ""),
    ("By Category", "Count"),
] + [(k, v) for k, v in cat_counts.items()] + [
    ("", ""),
    ("By Priority", "Count"),
] + [(k, v) for k, v in pri_counts.items()] + [
    ("", ""),
    ("Note", "Fill 'Status' column with: Pass / Fail / Blocked / N/A"),
]
for r, (label, val) in enumerate(summary_rows, 1):
    ws3.cell(row=r, column=1, value=label).font = Font(bold=True, name="Arial", size=10)
    ws3.cell(row=r, column=2, value=val).font   = Font(name="Arial", size=10)
ws3.column_dimensions["A"].width = 22
ws3.column_dimensions["B"].width = 35

wb.save("test-cases-feature.xlsx")
```

---

## Priority Guide

- **High** — Core functionality; product is unusable without this
- **Medium** — Important but a workaround exists
- **Low** — Edge case, cosmetic, or nice-to-have

---

## Tips for Best Results

- More context = better coverage. Share acceptance criteria or system constraints if available.
- Mention the tech stack if relevant (REST API, mobile app, web form, etc.).
- Ask for a specific category if needed — e.g. "only security test cases".
- Multiple features? Mention all — each gets its own labelled section in the sheet.

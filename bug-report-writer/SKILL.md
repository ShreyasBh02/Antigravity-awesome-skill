---
name: bug-report-writer
description: >
  Converts rough notes, casual descriptions, or quick observations into professional,
  complete bug reports — formatted and ready to paste into Excel, Google Sheets, Jira,
  or Azure DevOps. Also exports a formatted Excel (.xlsx) bug report file. Use this skill
  whenever the user mentions: "write a bug report", "log a bug", "report this issue",
  "found a defect", "something is broken", "create a bug ticket", "fill bug report",
  "document this bug", or pastes rough notes about unexpected behavior. Always trigger
  even for vague inputs like "the button doesn't work" — the skill will ask the right
  questions via assumptions and produce a professional output regardless.
---

# Bug Report Writer

Turn rough notes or casual bug descriptions into professional, structured bug reports —
exported as a formatted **Excel (.xlsx)** file, ready for Excel, Google Sheets, or copy-paste into Jira/Azure DevOps.

---

## Input Types Supported

- **One-liner** — "Login button does nothing on mobile"
- **Rough notes** — "tried to reset password, got error 500, only on Chrome"
- **Step-by-step** — User already has some steps, needs formatting
- **Multiple bugs at once** — "I found 3 issues today…"

---

## Workflow

### Step 1 — Extract Bug Details

From the input, identify:

| Field | What to extract |
|---|---|
| **Title** | Short, clear summary (Module: Issue description) |
| **Environment** | OS, browser, device, app version if mentioned |
| **Steps to Reproduce** | Numbered sequence; infer reasonable steps if not given |
| **Expected Result** | What should have happened |
| **Actual Result** | What actually happened |
| **Severity** | See severity guide below |
| **Priority** | See priority guide below |
| **Module / Feature** | Which part of the app is affected |
| **Attachments note** | Remind tester to attach screenshots/logs |

If details are missing, **make smart assumptions** based on context and mark them with `[Assumed]` in the report. Never leave a field blank — use "Not specified" only as a last resort.

### Step 2 — Apply Severity & Priority

**Severity** (impact on system):
| Level | Criteria |
|---|---|
| 🔴 Critical | App crash, data loss, security breach, complete feature failure |
| 🟠 High | Major feature broken, no workaround |
| 🟡 Medium | Feature partially broken, workaround exists |
| 🟢 Low | Cosmetic issue, typo, minor UI misalignment |

**Priority** (how soon it must be fixed):
| Level | Criteria |
|---|---|
| P1 | Must fix before release / hotfix needed now |
| P2 | Fix in current sprint |
| P3 | Fix in next sprint |
| P4 | Fix when time permits |

**QA Rule:** Severity drives priority by default, but business context can override.
e.g. a Low severity typo on a payment page might be P2 due to trust impact.

### Step 3 — Write the Bug Report

Format each bug with all fields clearly labelled. For multiple bugs, each gets its own complete report section.

**Standard bug report structure:**
```
Bug ID:        BUG-001 (auto-incremented if multiple)
Title:         [Module] Brief description of the issue
Reported By:   QA Tester
Date:          YYYY-MM-DD
Status:        Open

Environment:
  - OS: [e.g. Windows 11 / Android 13]
  - Browser/App: [e.g. Chrome 122 / App v2.3.1]
  - Device: [e.g. Desktop / Samsung Galaxy S21]

Module:        [e.g. Authentication / Checkout / Dashboard]
Severity:      Critical / High / Medium / Low
Priority:      P1 / P2 / P3 / P4

Steps to Reproduce:
  1. [Step 1]
  2. [Step 2]
  3. [Step 3]

Expected Result:
  [What should happen]

Actual Result:
  [What actually happens]

Attachments:
  [ ] Screenshot  [ ] Screen recording  [ ] Console logs  [ ] Network logs

Additional Notes:
  [Any extra context, frequency, workaround, or related issues]
```

### Step 4 — Export to Excel

Create a `.xlsx` file with **2 sheets**.

#### Sheet 1: Bug Reports
One row per bug with all fields as columns:
`Bug ID` | `Title` | `Module` | `Severity` | `Priority` | `Environment` | `Steps to Reproduce` | `Expected Result` | `Actual Result` | `Status` | `Reported By` | `Date` | `Notes`

Formatting:
- Header: bold white on dark red (`#C00000`), frozen
- Severity color coding per row:
  - Critical → `#F4CCCC` (red), High → `#FCE5CD` (orange)
  - Medium → `#FFF2CC` (yellow), Low → `#D9EAD3` (green)
- Priority column: P1 → `#F4CCCC`, P2 → `#FCE5CD`, P3 → `#FFF2CC`, P4 → `#D9EAD3`
- Status column: light grey (`#EEEEEE`), blank for team to update
- Steps, Expected, Actual columns: wrap text ON, row height 60px
- Font: Arial 10pt; column widths: ID=10, Title=38, Module=16, Severity=12, Priority=10, Environment=22, Steps=45, Expected=35, Actual=35, Status=14, Reporter=16, Date=13, Notes=30

#### Sheet 2: Bug Summary
- Total bugs count
- Breakdown by Severity (with count + %)
- Breakdown by Priority
- Breakdown by Module
- Breakdown by Status
- Date range of reports
- Font: Arial 10pt, labels bold

#### File naming: `bug-report-YYYY-MM-DD.xlsx`

### Step 5 — Save & Present
- Save to `/mnt/user-data/outputs/bug-report-YYYY-MM-DD.xlsx`
- Use `present_files` to deliver
- Also print each bug report in clean text format in chat for quick review

---

## Python Code Template

```python
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter
from datetime import date
from collections import Counter

wb = Workbook()
HEADER_FILL = PatternFill("solid", fgColor="C00000")
HEADER_FONT = Font(bold=True, color="FFFFFF", name="Arial", size=10)
DATA_FONT   = Font(name="Arial", size=10)
THIN        = Side(style="thin")
BORDER      = Border(left=THIN, right=THIN, top=THIN, bottom=THIN)

SEV_FILLS = {"Critical":"F4CCCC","High":"FCE5CD","Medium":"FFF2CC","Low":"D9EAD3"}
PRI_FILLS = {"P1":"F4CCCC","P2":"FCE5CD","P3":"FFF2CC","P4":"D9EAD3"}

ws = wb.active
ws.title = "Bug Reports"
ws.sheet_properties.tabColor = "C00000"

HEADERS = ["Bug ID","Title","Module","Severity","Priority","Environment",
           "Steps to Reproduce","Expected Result","Actual Result","Status",
           "Reported By","Date","Notes"]
WIDTHS  = [10,38,16,12,10,22,45,35,35,14,16,13,30]

for col,(h,w) in enumerate(zip(HEADERS,WIDTHS),1):
    c = ws.cell(row=1,column=col,value=h)
    c.font,c.fill,c.border = HEADER_FONT,HEADER_FILL,BORDER
    c.alignment = Alignment(horizontal="center",vertical="center",wrap_text=True)
    ws.column_dimensions[get_column_letter(col)].width = w
ws.freeze_panes = "A2"
ws.row_dimensions[1].height = 28

# bugs = list of dicts with keys matching HEADERS (lowercase, underscored)
bugs = []  # REPLACE WITH ACTUAL BUG DATA

for r, bug in enumerate(bugs, 2):
    sev = bug.get("severity","Medium")
    pri = bug.get("priority","P3")
    row = [bug.get("bug_id",""), bug.get("title",""), bug.get("module",""),
           sev, pri, bug.get("environment",""), bug.get("steps",""),
           bug.get("expected",""), bug.get("actual",""), "",
           bug.get("reported_by","QA Tester"), str(date.today()), bug.get("notes","")]
    ws.row_dimensions[r].height = 60
    for col,val in enumerate(row,1):
        c = ws.cell(row=r,column=col,value=val)
        c.font,c.border = DATA_FONT,BORDER
        c.alignment = Alignment(vertical="top",wrap_text=(col in [7,8,9]))
        c.fill = PatternFill("solid", fgColor=SEV_FILLS.get(sev,"FFFFFF"))
        if col==4: c.fill=PatternFill("solid",fgColor=SEV_FILLS.get(sev,"FFFFFF"))
        if col==5:
            c.fill=PatternFill("solid",fgColor=PRI_FILLS.get(pri,"FFFFFF"))
            c.alignment=Alignment(horizontal="center",vertical="top")
        if col==10:
            c.fill=PatternFill("solid",fgColor="EEEEEE")

# Sheet 2: Summary
ws2 = wb.create_sheet("Bug Summary")
ws2.sheet_properties.tabColor = "808080"
today = date.today().strftime("%Y-%m-%d")
summary = [
    ("Report Date", today),
    ("Total Bugs", len(bugs)),("",""),
    ("By Severity","Count"),
] + [(s, sum(1 for b in bugs if b.get("severity")==s)) for s in ["Critical","High","Medium","Low"]] + [
    ("",""),("By Priority","Count"),
] + [(p, sum(1 for b in bugs if b.get("priority")==p)) for p in ["P1","P2","P3","P4"]]

for r,(label,val) in enumerate(summary,1):
    ws2.cell(row=r,column=1,value=label).font=Font(bold=True,name="Arial",size=10)
    ws2.cell(row=r,column=2,value=val).font=Font(name="Arial",size=10)
ws2.column_dimensions["A"].width=18
ws2.column_dimensions["B"].width=12

wb.save(f"bug-report-{today}.xlsx")
```

---

## Tips for Best Results

- **The more detail the better** — but even "X is broken" produces a usable report.
- **Multiple bugs?** List them all in one message — each gets its own row and Bug ID.
- **Mention the environment** if you know it (browser, OS, app version).
- **Attach files separately** — the report will include a checklist reminder for screenshots/logs.

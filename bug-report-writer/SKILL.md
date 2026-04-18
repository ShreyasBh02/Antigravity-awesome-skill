---
name: bug-report-writer
description: >
  Converts rough notes, casual descriptions, console errors, or quick observations into
  professional, complete bug reports — exported as a formatted Excel (.xlsx) file ready
  for Excel, Google Sheets, Jira, or Azure DevOps. Use this skill whenever the user
  mentions: "write a bug report", "log a bug", "report this issue", "found a defect",
  "something is broken", "create a bug ticket", "fill bug report", "document this bug",
  "file a ticket", "issue log", "defect report", "bug tracker", "something's wrong with",
  or pastes rough notes, console errors, or stack traces about unexpected behavior.
  Always trigger even for vague inputs like "the button doesn't work" or "this is broken"
  — the skill will infer details via smart assumptions and produce a professional output
  regardless. Trigger for single bugs AND multiple bugs described in one message.
---

# Bug Report Writer

Turn rough notes, one-liners, console errors, or casual descriptions into professional,
structured bug reports — exported as a formatted **Excel (.xlsx)** file ready for Excel,
Google Sheets, Jira, or Azure DevOps.

---

## Supported Input Types

- **One-liner** — "Login button does nothing on mobile"
- **Rough notes** — "tried to reset password, got error 500, only on Chrome"
- **Console error / stack trace** — paste raw error output
- **Step-by-step** — user has steps already, needs formatting
- **Multiple bugs at once** — "I found 3 issues today…" → each gets its own BUG-ID

---

## Workflow

### Step 1 — Extract Bug Details

For each bug, extract or infer:

| Field | What to extract |
|---|---|
| **Title** | Short summary in format: `[Module] Brief description` |
| **Environment** | OS, browser, device, app version if mentioned |
| **Steps to Reproduce** | Numbered sequence; infer reasonable steps if not given |
| **Expected Result** | What should have happened |
| **Actual Result** | What actually happened (include error messages verbatim) |
| **Severity** | See severity guide below |
| **Priority** | See priority guide below |
| **Module / Feature** | Which part of the app is affected |
| **Reporter** | Use name if provided; default to `QA Tester` |

If details are missing, **make smart assumptions** based on context and mark them with `[Assumed]`. Never leave a field blank — use `Not specified` only as a last resort.

---

### Step 2 — Apply Severity & Priority

**Severity** (impact on the system):

| Level | Criteria |
|---|---|
| 🔴 Critical | App crash, data loss, security breach, complete feature failure |
| 🟠 High | Major feature broken, no workaround available |
| 🟡 Medium | Feature partially broken, workaround exists |
| 🟢 Low | Cosmetic issue, typo, minor UI misalignment |

**Priority** (how soon it must be fixed):

| Level | Criteria |
|---|---|
| P1 | Must fix before release / hotfix needed immediately |
| P2 | Fix in current sprint |
| P3 | Fix in next sprint |
| P4 | Fix when time permits |

**QA Rule:** Severity drives priority by default, but business context can override.
Example: a Low severity typo on a payment page may be P2 due to trust impact.

---

### Step 3 — Print Bug Report(s) in Chat

Print each bug in clean text format for immediate review before generating the file.
Use this exact structure:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
BUG-001 · [Module] Brief title here
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Severity:   🟠 High        Priority: P2
Module:     Authentication
Reported:   QA Tester · 2025-01-15    Status: Open

Environment:
  OS: Windows 11 · Browser: Chrome 122 · Device: Desktop [Assumed]

Steps to Reproduce:
  1. Navigate to /login
  2. Enter valid email and any password
  3. Click "Login"

Expected: User is authenticated and redirected to dashboard
Actual:   Page shows blank screen; console error: "TypeError: Cannot read properties of undefined"

Attachments needed: [ ] Screenshot  [ ] Console logs  [ ] Network logs

Notes: Occurs consistently on Chrome; not tested on other browsers [Assumed]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

For multiple bugs, print each one separated by the divider line above.

---

### Step 4 — Export to Excel (.xlsx)

Create a `.xlsx` file with **2 sheets** using the Python template below.

#### Sheet 1: Bug Reports

Columns: `Bug ID` | `Title` | `Module` | `Severity` | `Priority` | `Environment` | `Steps to Reproduce` | `Expected Result` | `Actual Result` | `Status` | `Reported By` | `Date` | `Notes`

Formatting rules:
- Header row: bold white text on dark red (`#C00000`), frozen at row 2
- **Only** Severity and Priority columns get color-coded fills — all other data columns use white (`#FFFFFF`)
- Severity fill: Critical→`#F4CCCC`, High→`#FCE5CD`, Medium→`#FFF2CC`, Low→`#D9EAD3`
- Priority fill: P1→`#F4CCCC`, P2→`#FCE5CD`, P3→`#FFF2CC`, P4→`#D9EAD3`
- Status column: light grey `#EEEEEE`, left blank for the team to fill in
- Steps, Expected, Actual columns: wrap text ON, row height 60px
- Font: Arial 10pt throughout
- Column widths: ID=10, Title=38, Module=16, Severity=12, Priority=10, Environment=22, Steps=45, Expected=35, Actual=35, Status=14, Reporter=16, Date=13, Notes=30

#### Sheet 2: Bug Summary

- Report date + total bug count
- Breakdown by Severity (count + percentage)
- Breakdown by Priority (count + percentage)
- Breakdown by Module (count, sorted most→least)
- Breakdown by Status (count)
- Date range of reports (earliest → latest)
- Font: Arial 10pt, section headers bold, tab color grey `#808080`

#### File name: `bug-report-YYYY-MM-DD.xlsx`

---

### Step 5 — Save & Present

- Save to `/mnt/user-data/outputs/bug-report-YYYY-MM-DD.xlsx`
- Call `present_files` to deliver the download link
- After the file link, print a one-line summary:
  `✅ X bug(s) exported · Severities: [list] · File: bug-report-YYYY-MM-DD.xlsx`

---

## Python Code Template

```python
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter
from datetime import date
from collections import Counter

wb = Workbook()

# --- Styles ---
HEADER_FILL = PatternFill("solid", fgColor="C00000")
HEADER_FONT = Font(bold=True, color="FFFFFF", name="Arial", size=10)
DATA_FONT   = Font(name="Arial", size=10)
WHITE_FILL  = PatternFill("solid", fgColor="FFFFFF")
GREY_FILL   = PatternFill("solid", fgColor="EEEEEE")
THIN        = Side(style="thin")
BORDER      = Border(left=THIN, right=THIN, top=THIN, bottom=THIN)

SEV_FILLS = {"Critical": "F4CCCC", "High": "FCE5CD", "Medium": "FFF2CC", "Low": "D9EAD3"}
PRI_FILLS = {"P1": "F4CCCC", "P2": "FCE5CD", "P3": "FFF2CC", "P4": "D9EAD3"}

# Column indices (1-based)
COL_SEVERITY = 4
COL_PRIORITY = 5
COL_STATUS   = 10
WRAP_COLS    = {7, 8, 9}  # Steps to Reproduce, Expected Result, Actual Result

# --- Sheet 1: Bug Reports ---
ws = wb.active
ws.title = "Bug Reports"
ws.sheet_properties.tabColor = "C00000"

HEADERS = ["Bug ID", "Title", "Module", "Severity", "Priority", "Environment",
           "Steps to Reproduce", "Expected Result", "Actual Result", "Status",
           "Reported By", "Date", "Notes"]
WIDTHS  = [10, 38, 16, 12, 10, 22, 45, 35, 35, 14, 16, 13, 30]

for col, (h, w) in enumerate(zip(HEADERS, WIDTHS), 1):
    c = ws.cell(row=1, column=col, value=h)
    c.font      = HEADER_FONT
    c.fill      = HEADER_FILL
    c.border    = BORDER
    c.alignment = Alignment(horizontal="center", vertical="center", wrap_text=True)
    ws.column_dimensions[get_column_letter(col)].width = w

ws.freeze_panes = "A2"
ws.row_dimensions[1].height = 28

# bugs = list of dicts — populate with extracted bug data before running
bugs = []  # REPLACE WITH ACTUAL BUG DATA

for r, bug in enumerate(bugs, 2):
    sev = bug.get("severity", "Medium")
    pri = bug.get("priority", "P3")
    row_data = [
        bug.get("bug_id", ""),
        bug.get("title", ""),
        bug.get("module", ""),
        sev,
        pri,
        bug.get("environment", ""),
        bug.get("steps", ""),
        bug.get("expected", ""),
        bug.get("actual", ""),
        "",  # Status — left blank for the team
        bug.get("reported_by", "QA Tester"),
        bug.get("date", str(date.today())),
        bug.get("notes", ""),
    ]
    ws.row_dimensions[r].height = 60
    for col, val in enumerate(row_data, 1):
        c = ws.cell(row=r, column=col, value=val)
        c.font   = DATA_FONT
        c.border = BORDER
        c.alignment = Alignment(
            vertical="top",
            wrap_text=(col in WRAP_COLS),
            horizontal="center" if col == COL_PRIORITY else "left"
        )
        # Color only the Severity, Priority, and Status columns
        if col == COL_SEVERITY:
            c.fill = PatternFill("solid", fgColor=SEV_FILLS.get(sev, "FFFFFF"))
        elif col == COL_PRIORITY:
            c.fill = PatternFill("solid", fgColor=PRI_FILLS.get(pri, "FFFFFF"))
        elif col == COL_STATUS:
            c.fill = GREY_FILL
        else:
            c.fill = WHITE_FILL  # All other columns stay clean white

# --- Sheet 2: Bug Summary ---
ws2 = wb.create_sheet("Bug Summary")
ws2.sheet_properties.tabColor = "808080"
today_str = date.today().strftime("%Y-%m-%d")

def pct(n, total):
    return f"{round(100 * n / total)}%" if total else "0%"

total  = len(bugs)
dates  = sorted(b.get("date", today_str) for b in bugs if b.get("date"))
modules = Counter(b.get("module", "Unknown") for b in bugs)

summary_rows = [
    ("Report Date",  today_str),
    ("Total Bugs",   total),
    ("", ""),
    ("── By Severity ──", "Count / %"),
]
for s in ["Critical", "High", "Medium", "Low"]:
    n = sum(1 for b in bugs if b.get("severity") == s)
    summary_rows.append((f"  {s}", f"{n}  ({pct(n, total)})"))

summary_rows += [("", ""), ("── By Priority ──", "Count / %")]
for p in ["P1", "P2", "P3", "P4"]:
    n = sum(1 for b in bugs if b.get("priority") == p)
    summary_rows.append((f"  {p}", f"{n}  ({pct(n, total)})"))

summary_rows += [("", ""), ("── By Module ──", "Count")]
for mod, n in modules.most_common():
    summary_rows.append((f"  {mod}", n))

summary_rows += [
    ("", ""),
    ("Date Range", f"{dates[0]} → {dates[-1]}" if dates else "N/A"),
]

BOLD_LABELS = {"Report Date", "Total Bugs", "── By Severity ──",
               "── By Priority ──", "── By Module ──", "Date Range"}
for r, (label, val) in enumerate(summary_rows, 1):
    ws2.cell(row=r, column=1, value=label).font = Font(
        bold=(label in BOLD_LABELS), name="Arial", size=10)
    ws2.cell(row=r, column=2, value=val).font = Font(name="Arial", size=10)

ws2.column_dimensions["A"].width = 22
ws2.column_dimensions["B"].width = 16

output_path = f"bug-report-{today_str}.xlsx"
wb.save(output_path)
print(f"Saved: {output_path}")
```

---

## Tips for Best Results

- **Even "X is broken"** produces a usable report — the skill infers what it can and marks assumptions clearly.
- **Multiple bugs?** Describe them all in one message — each gets its own BUG-ID, row, and section.
- **Console errors / stack traces?** Paste them raw — they become the Actual Result verbatim.
- **Mention the environment** if you know it (browser, OS, app version, device).
- **Attachments are reminded** — the report always includes a checklist for screenshots and logs.
---
name: daily-planner-prioritizer
description: >
  Creates a smart, time-blocked daily plan from a user's task dump, meetings, errands,
  habits, and goals — then outputs BOTH a clean text summary in chat AND a formatted
  Excel (.xlsx) schedule file. Covers work tasks, meetings, personal errands, health/exercise
  reminders, and QA-specific tasks (test runs, bug triage, reviews). Use this skill whenever
  the user mentions: "plan my day", "prioritize my tasks", "make a schedule", "I have too
  much to do", "help me organize today", "daily planner", "time block my day", "what should
  I do first", "morning routine", "task list for today", or dumps a list of things to do.
  Always trigger even for partial inputs — a rough list of tasks is enough to generate a
  useful plan. The more context given, the better, but never require it.
---

# Daily Planner & Prioritizer

Turn a messy list of tasks, meetings, errands, and goals into a smart, time-blocked daily
plan — delivered as a **clean chat summary + a formatted Excel (.xlsx) schedule**.

---

## What This Planner Covers

- 💼 **Work tasks & meetings** — deadlines, standups, reviews, client calls
- 🏠 **Personal errands & habits** — chores, appointments, shopping, family
- 🏃 **Health & exercise** — workouts, walks, meals, water reminders
- 🧪 **QA-specific tasks** — test runs, bug triage, test case writing, regression cycles, PR reviews

---

## Workflow

### Step 1 — Parse the Input

Accept input in any format — bullet list, paragraph, voice-style dump, or structured.
Extract from the input:
- **Task name** — what needs to be done
- **Type** — Work / Personal / Health / QA
- **Duration estimate** — if stated; otherwise apply defaults (see below)
- **Fixed time** — meetings, appointments with specific times
- **Deadline or urgency** — "due today", "urgent", "by EOD", "can wait"
- **Energy level needed** — infer from task type (deep work vs. admin vs. quick errand)

If the user doesn't provide enough detail, make smart assumptions — never ask for more
info before producing a plan. State assumptions clearly in the output.

### Step 2 — Prioritize Tasks

Use this priority matrix to rank tasks before scheduling:

| Priority | Criteria |
|---|---|
| 🔴 P1 — Urgent & Important | Deadlines today, blockers, critical bugs, meetings |
| 🟠 P2 — Important, Not Urgent | Deep work, test execution, errands with soft deadlines |
| 🟡 P3 — Useful but Flexible | Reviews, reading, habit tasks, low-urgency emails |
| 🟢 P4 — Nice to Have | Optional tasks, backlog, long-term prep |

**QA-specific priority rules:**
- Production bugs → always P1
- Regression test runs with release deadline today → P1
- Test case writing / review → P2
- Exploratory testing → P2 or P3 depending on sprint stage
- Bug triage (no severity yet) → P2

### Step 3 — Build the Time-Blocked Schedule

**Default working window:** 9:00 AM – 6:00 PM (adjust if user specifies otherwise)

**Default time-blocking principles:**
- Start with fixed-time meetings/appointments first
- Place deep focus work (P1 + P2) in the morning (9–12)
- Schedule health/exercise in early morning or lunch break
- Admin, email, reviews in early afternoon (2–4 PM)
- Personal errands and flexible tasks in late afternoon or after work
- End the day with a 15-min "wrap-up + plan tomorrow" block

**Default duration estimates (use when not provided):**
| Task Type | Default Duration |
|---|---|
| Meeting / standup | 30–60 min (30 if "standup", 60 if "meeting") |
| Bug fix / investigation | 60 min |
| Test case writing | 45 min per feature |
| Test execution / regression run | 90 min |
| Bug triage | 30 min |
| PR / code review | 30 min |
| Email / Slack catch-up | 20 min |
| Deep focus / dev work | 90 min |
| Personal errand (outside) | 60 min |
| Quick personal task | 20 min |
| Exercise / workout | 45 min |
| Meal / break | 30–60 min |
| Daily wrap-up | 15 min |

**Protect these blocks always (unless user says otherwise):**
- Lunch break: 1:00–2:00 PM (60 min)
- At least one 10-min break per 90-min work block

### Step 4 — Output: Chat Summary

Print the plan in chat in this clean format:

```
📅 YOUR DAY — [Day, Date]
━━━━━━━━━━━━━━━━━━━━━━━━

🌅 MORNING
  09:00 – 09:30  🧪 QA Standup (P1)
  09:30 – 11:00  🧪 Regression test run – Login module (P1)
  11:00 – 11:45  💼 Write test cases – Payment feature (P2)
  11:45 – 12:00  ☕ Break

🌞 MIDDAY
  12:00 – 13:00  🏃 Lunch + walk
  13:00 – 13:30  💼 Email & Slack catch-up (P3)

🌆 AFTERNOON
  13:30 – 14:30  💼 Deep work: [task] (P2)
  14:30 – 15:00  🧪 Bug triage (P2)
  15:00 – 16:00  🏠 [Personal errand] (P3)
  16:00 – 16:30  💼 PR review (P3)

🌇 END OF DAY
  16:30 – 17:00  🏃 Evening walk / exercise
  17:00 – 17:15  📝 Wrap-up + plan tomorrow

━━━━━━━━━━━━━━━━━━━━━━━━
✅ Tasks scheduled: X  |  ⏳ Total focus time: Xh Xmin
⚠️  Deferred to tomorrow: [any tasks that didn't fit]
💡 Assumptions made: [list any guesses about timing or priority]
```

Emoji key: 💼 Work | 🧪 QA | 🏠 Personal | 🏃 Health

### Step 5 — Output: Excel File

Create a formatted `.xlsx` file with **2 sheets**.

#### Sheet 1: Daily Schedule

Columns: `Time` | `Task` | `Type` | `Priority` | `Duration` | `Status` | `Notes`

Formatting:
- Header: bold white on dark blue (`#1F4E79`), frozen row
- Type color coding per row:
  - Work → `#DEEAF1` (blue)
  - QA → `#E2EFDA` (green)
  - Personal → `#FFF2CC` (yellow)
  - Health → `#FCE4D6` (orange/pink)
  - Break/Meal → `#F2F2F2` (grey)
- Priority column: 🔴 P1 = `#F4CCCC`, 🟠 P2 = `#FCE5CD`, 🟡 P3 = `#FFF2CC`, 🟢 P4 = `#D9EAD3`
- Status column: light grey, blank — user fills in (Done / In Progress / Skipped)
- Font: Arial 10pt, row height 25px, wrap text off
- Column widths: Time=14, Task=40, Type=12, Priority=10, Duration=12, Status=14, Notes=35

#### Sheet 2: Task Backlog

Any tasks that didn't fit today — columns: `Task` | `Type` | `Priority` | `Suggested Day` | `Notes`
- Same color coding as Sheet 1
- Header: same dark blue style

#### File naming: `daily-plan-YYYY-MM-DD.xlsx`

### Step 6 — Save & Present
- Save to `/mnt/user-data/outputs/daily-plan-YYYY-MM-DD.xlsx`
- Use `present_files` to deliver
- The chat summary should appear FIRST, then mention the Excel file is ready to download

---

## Python Code Template

```python
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter
from datetime import date

wb = Workbook()

HEADER_FILL = PatternFill("solid", fgColor="1F4E79")
HEADER_FONT = Font(bold=True, color="FFFFFF", name="Arial", size=10)
DATA_FONT   = Font(name="Arial", size=10)
THIN        = Side(style="thin")
BORDER      = Border(left=THIN, right=THIN, top=THIN, bottom=THIN)

TYPE_FILLS = {
    "Work":     "DEEAF1",
    "QA":       "E2EFDA",
    "Personal": "FFF2CC",
    "Health":   "FCE4D6",
    "Break":    "F2F2F2",
}
PRI_FILLS = {
    "P1": "F4CCCC",
    "P2": "FCE5CD",
    "P3": "FFF2CC",
    "P4": "D9EAD3",
    "":   "FFFFFF",
}

def style_header(ws, headers, col_widths):
    for col, (h, w) in enumerate(zip(headers, col_widths), 1):
        c = ws.cell(row=1, column=col, value=h)
        c.font, c.fill, c.border = HEADER_FONT, HEADER_FILL, BORDER
        c.alignment = Alignment(horizontal="center", vertical="center")
        ws.column_dimensions[get_column_letter(col)].width = w
    ws.freeze_panes = "A2"
    ws.row_dimensions[1].height = 28

# Sheet 1: Daily Schedule
ws1 = wb.active
ws1.title = "Daily Schedule"
ws1.sheet_properties.tabColor = "1F4E79"

HEADERS1 = ["Time", "Task", "Type", "Priority", "Duration", "Status", "Notes"]
WIDTHS1  = [14, 40, 12, 10, 12, 14, 35]
style_header(ws1, HEADERS1, WIDTHS1)

# schedule = list of (time_str, task, type, priority, duration, notes)
# e.g. ("09:00–09:30", "QA Standup", "QA", "P1", "30 min", "Daily sync")
schedule = []  # REPLACE WITH ACTUAL GENERATED SCHEDULE

for r, (time, task, typ, pri, dur, notes) in enumerate(schedule, 2):
    row_data = [time, task, typ, pri, dur, "", notes]
    ws1.row_dimensions[r].height = 25
    for col, val in enumerate(row_data, 1):
        c = ws1.cell(row=r, column=col, value=val)
        c.font, c.border = DATA_FONT, BORDER
        c.alignment = Alignment(vertical="center")
        # Row background from Type
        fill_color = TYPE_FILLS.get(typ, "FFFFFF")
        c.fill = PatternFill("solid", fgColor=fill_color)
        # Override Priority and Status cells
        if col == 4:
            c.fill = PatternFill("solid", fgColor=PRI_FILLS.get(pri, "FFFFFF"))
            c.alignment = Alignment(horizontal="center", vertical="center")
        elif col == 6:
            c.fill = PatternFill("solid", fgColor="EEEEEE")

# Sheet 2: Task Backlog
ws2 = wb.create_sheet("Task Backlog")
ws2.sheet_properties.tabColor = "ED7D31"
HEADERS2 = ["Task", "Type", "Priority", "Suggested Day", "Notes"]
WIDTHS2  = [40, 12, 10, 18, 35]
style_header(ws2, HEADERS2, WIDTHS2)

# backlog = list of (task, type, priority, suggested_day, notes)
backlog = []  # REPLACE WITH ACTUAL DEFERRED TASKS

for r, (task, typ, pri, day, notes) in enumerate(backlog, 2):
    row_data = [task, typ, pri, day, notes]
    ws2.row_dimensions[r].height = 25
    for col, val in enumerate(row_data, 1):
        c = ws2.cell(row=r, column=col, value=val)
        c.font, c.border = DATA_FONT, BORDER
        c.alignment = Alignment(vertical="center")
        c.fill = PatternFill("solid", fgColor=TYPE_FILLS.get(typ, "FFFFFF"))
        if col == 3:
            c.fill = PatternFill("solid", fgColor=PRI_FILLS.get(pri, "FFFFFF"))
            c.alignment = Alignment(horizontal="center", vertical="center")

today = date.today().strftime("%Y-%m-%d")
wb.save(f"daily-plan-{today}.xlsx")
```

---

## Tips for Best Results

- **Dump everything** — tasks, meetings, errands, even "I need to exercise". More input = better plan.
- **Mention fixed times** for any meetings or appointments (e.g. "standup at 9:30").
- **Flag urgent items** — say "urgent", "due today", or "must finish by 3 PM".
- **Specify energy** if you know it — "I'm tired today" shifts deep work to best available window.
- **Multiple days?** Say "plan my week" — each day gets its own schedule section and Excel sheet.

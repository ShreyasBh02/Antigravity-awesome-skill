---
name: recipe-grocery-list
description: >
  Converts one or more recipes, a weekly meal plan, or even just dish names into a clean,
  categorized, deduplicated grocery shopping list — with quantities scaled to the number
  of servings needed. Also exports a formatted Excel (.xlsx) shopping list file. Use this
  skill whenever the user mentions: "make a grocery list", "shopping list for this recipe",
  "what do I need to buy", "meal plan grocery list", "ingredients for the week",
  "I'm cooking X, what do I need", "combine these recipes into a shopping list",
  or shares a recipe and wants a list. Always trigger — even for a single dish name
  like "I'm making biryani for 6 people, what do I need?". The skill works with dish
  names alone — a full recipe is not required.
---

# Recipe-to-Grocery List Converter

Turn any recipe, meal plan, or dish name into a clean, categorized, deduplicated grocery
list — with quantities scaled to your serving size, exported as **chat list + Excel file**.

---

## Input Types Supported

- **Dish name only** — "Biryani for 6 people" (skill knows common recipes)
- **Full recipe with ingredients** — paste any recipe text
- **Multiple dishes** — "I'm cooking dal, sabzi, and roti for 4"
- **Weekly meal plan** — "Breakfast: poha. Lunch: dal rice. Dinner: paneer curry" × 7 days
- **Servings adjustment** — "double this recipe" or "for 10 people instead of 4"

---

## Workflow

### Step 1 — Extract Ingredients

For each dish/recipe:
- List every ingredient with quantity and unit
- If only a dish name is given, use standard recipe knowledge for that dish
- Note the default serving size and scale to the requested serving size
- If no serving size given, default to **4 people**

**Scaling formula:** `scaled_qty = original_qty × (requested_servings / original_servings)`

Round quantities sensibly:
- < 1 tsp → keep as fraction (¼ tsp, ½ tsp)
- Whole produce (onions, tomatoes) → round to nearest whole number
- Liquids → round to nearest 50ml / ¼ cup
- Packaged goods → round up to nearest pack size when noted

### Step 2 — Deduplicate & Combine

When multiple recipes share ingredients:
- **Combine quantities** of the same ingredient (e.g. 2 onions + 3 onions = 5 onions)
- **Use consistent units** — convert to same unit before combining (ml not ml + cups)
- **Flag pantry staples** separately — items most people already have (salt, oil, sugar,
  common spices) go in a "Pantry Check" section, not the main buy list

### Step 3 — Categorize

Sort all ingredients into shopping categories:

| Category | Examples |
|---|---|
| 🥩 Meat & Seafood | Chicken, mutton, fish, eggs |
| 🥛 Dairy & Alternatives | Milk, paneer, curd, ghee, butter, cheese |
| 🥦 Vegetables | All fresh vegetables |
| 🍎 Fruits | All fresh fruits |
| 🌾 Grains & Pulses | Rice, flour, dal, poha, bread |
| 🥫 Canned & Packaged | Canned tomatoes, coconut milk, pasta |
| 🧂 Spices & Condiments | Masalas, sauces, vinegar, oils |
| 🧊 Frozen | Frozen peas, corn, paratha |
| 🧴 Pantry Check | Salt, oil, sugar, common spices (verify before buying) |
| 🛒 Other | Anything that doesn't fit above |

### Step 4 — Output: Chat List

Print a clean grocery list in chat:

```
🛒 GROCERY LIST
━━━━━━━━━━━━━━━━━━━━━━━━
📅 For: [Dish names]
👥 Serves: [X people]
🗓️  Meals covered: [X recipes / X days]

🥦 VEGETABLES
  □ Onions — 4 large
  □ Tomatoes — 3 medium
  □ Ginger — 2-inch piece
  □ Garlic — 1 full bulb

🥛 DAIRY & ALTERNATIVES
  □ Paneer — 250g
  □ Curd / Yoghurt — 1 cup

🌾 GRAINS & PULSES
  □ Basmati rice — 2 cups
  □ Toor dal — 1 cup

🧂 SPICES & CONDIMENTS
  □ Cumin seeds — 1 tsp
  □ Garam masala — 2 tsp

🧴 PANTRY CHECK (you may already have these)
  □ Salt
  □ Cooking oil
  □ Turmeric powder
  □ Red chilli powder

━━━━━━━━━━━━━━━━━━━━━━━━
🧾 Total items to buy: X  |  ✅ Pantry check items: X
💡 Assumptions: [serving size used, any substitutions, etc.]
```

### Step 5 — Output: Excel File

Create a `.xlsx` file with **2 sheets**.

#### Sheet 1: Shopping List
Columns: `✓` (checkbox column) | `Item` | `Quantity` | `Unit` | `Category` | `Notes`

Formatting:
- Header: bold white on dark green (`#375623`), frozen
- Category color coding per row (matching chat categories):
  - Vegetables → `#E2EFDA`, Fruits → `#FFF2CC`, Meat → `#FCE4D6`
  - Dairy → `#DEEAF1`, Grains → `#FFF2CC`, Spices → `#F4CCCC`
  - Pantry Check → `#F2F2F2` (grey, italic)
- Checkbox column (✓): 6px wide, light grey — user ticks off while shopping
- Sort order: category grouped, alphabetical within category
- Pantry Check items at bottom, visually separated
- Font: Arial 10pt; row height 22px
- Column widths: Check=6, Item=28, Quantity=12, Unit=12, Category=18, Notes=30

#### Sheet 2: Meal Plan Summary
- One row per dish/meal
- Columns: `Meal` | `Dish` | `Servings` | `Key Ingredients` | `Prep Time (est.)`
- Header: same dark green style

#### File naming: `grocery-list-YYYY-MM-DD.xlsx`

### Step 6 — Save & Present
- Save to `/mnt/user-data/outputs/grocery-list-YYYY-MM-DD.xlsx`
- Use `present_files` to deliver
- Chat list appears first, then mention the Excel file

---

## Python Code Template

```python
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter
from datetime import date

wb = Workbook()
HEADER_FILL = PatternFill("solid", fgColor="375623")
HEADER_FONT = Font(bold=True, color="FFFFFF", name="Arial", size=10)
DATA_FONT   = Font(name="Arial", size=10)
PANTRY_FONT = Font(name="Arial", size=10, italic=True, color="888888")
THIN        = Side(style="thin")
BORDER      = Border(left=THIN, right=THIN, top=THIN, bottom=THIN)

CAT_FILLS = {
    "Vegetables":  "E2EFDA", "Fruits":     "FFF2CC",
    "Meat & Seafood": "FCE4D6", "Dairy":   "DEEAF1",
    "Grains & Pulses": "FFF9CC", "Spices": "F4CCCC",
    "Canned & Packaged": "E8D5F5", "Frozen": "DEEAF1",
    "Pantry Check": "F2F2F2", "Other":    "FFFFFF",
}

ws = wb.active
ws.title = "Shopping List"
ws.sheet_properties.tabColor = "375623"

HEADERS = ["✓", "Item", "Quantity", "Unit", "Category", "Notes"]
WIDTHS  = [6, 28, 12, 12, 18, 30]

for col,(h,w) in enumerate(zip(HEADERS,WIDTHS),1):
    c = ws.cell(row=1,column=col,value=h)
    c.font,c.fill,c.border = HEADER_FONT,HEADER_FILL,BORDER
    c.alignment = Alignment(horizontal="center",vertical="center")
    ws.column_dimensions[get_column_letter(col)].width = w
ws.freeze_panes = "A2"
ws.row_dimensions[1].height = 28

# items = list of (item, quantity, unit, category, notes)
# sorted: grouped by category, pantry items last
items = []  # REPLACE WITH ACTUAL ITEMS

for r,(item,qty,unit,cat,notes) in enumerate(items,2):
    is_pantry = cat == "Pantry Check"
    row_data = ["", item, qty, unit, cat, notes]
    ws.row_dimensions[r].height = 22
    for col,val in enumerate(row_data,1):
        c = ws.cell(row=r,column=col,value=val)
        c.font   = PANTRY_FONT if is_pantry else DATA_FONT
        c.border = BORDER
        c.fill   = PatternFill("solid", fgColor=CAT_FILLS.get(cat,"FFFFFF"))
        c.alignment = Alignment(vertical="center",
                                horizontal="center" if col in [1,3,4] else "left")

# Sheet 2: Meal Plan Summary
ws2 = wb.create_sheet("Meal Plan")
ws2.sheet_properties.tabColor = "70AD47"
for col,(h,w) in enumerate(zip(["Meal","Dish","Servings","Key Ingredients","Prep Time"],[14,28,12,40,14]),1):
    c = ws2.cell(row=1,column=col,value=h)
    c.font,c.fill,c.border = HEADER_FONT,HEADER_FILL,BORDER
    c.alignment = Alignment(horizontal="center",vertical="center")
    ws2.column_dimensions[get_column_letter(col)].width = w
ws2.freeze_panes = "A2"

today = date.today().strftime("%Y-%m-%d")
wb.save(f"grocery-list-{today}.xlsx")
```

---

## Tips for Best Results

- **Just say the dish name** — you don't need to provide the full recipe.
- **Mention serving size** — "for 6 people" scales quantities automatically.
- **Weekly meal plan?** List all meals — the list combines and deduplicates everything.
- **Dietary preferences?** Say "vegetarian", "no onion garlic", or "gluten-free" — substitutions will be noted.
- **Already have some ingredients?** Say "I have rice and oil" — they'll move to the Pantry Check section.

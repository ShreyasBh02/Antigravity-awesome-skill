---
name: email-message-rewriter
description: >
  Rewrites, polishes, or drafts emails and messages from rough notes, bullet points, or
  poorly worded drafts — in the right tone for the situation. Handles professional emails,
  Slack messages, WhatsApp texts, follow-ups, apologies, feedback, and more. Use this skill
  whenever the user says: "rewrite this email", "make this sound professional", "write an
  email for me", "help me reply to this", "make this polite", "draft a message", "how do I
  say this nicely", "write a follow-up", "make this less aggressive", "I need to send this
  but don't know how to word it", or shares a rough draft asking for improvements.
  Always trigger — even for short messages. A one-line rewrite is still worth doing well.
---

# Email & Message Rewriter

Rewrite, polish, or draft any email or message — from rough notes or bad drafts — in the
right tone for the situation. Works for professional emails, Slack, WhatsApp, follow-ups,
apologies, feedback, and more.

---

## Supported Message Types

| Type | Examples |
|---|---|
| 💼 Professional Email | Work requests, updates, escalations, client communication |
| 🔁 Follow-up | Chasing a reply, following up on a task or meeting |
| 🐛 Bug / Issue Escalation | Reporting a critical issue to manager or client |
| 🙏 Apology | Missed deadline, mistake, delayed response |
| 💬 Slack / Teams message | Quick team update, question, async request |
| 📱 WhatsApp / Text | Personal or semi-formal short messages |
| 📝 Feedback | Giving or responding to feedback professionally |
| ❌ Declining / Saying No | Politely turning down a request |
| 🎉 Appreciation | Thanking a colleague, recognising good work |

---

## Tone Options

| Tone | When to use |
|---|---|
| **Formal** | Senior management, clients, official communication |
| **Professional** | Default for most work emails |
| **Friendly-Professional** | Colleagues, collaborative teams |
| **Friendly** | Close colleagues, semi-personal messages |
| **Direct** | When brevity and clarity matter most |
| **Assertive** | Escalations, pushing back, setting boundaries |
| **Empathetic** | Apologies, difficult news, sensitive topics |

If the user doesn't specify a tone, **infer it from context**:
- Work email → Professional
- Message to manager about urgent issue → Assertive + Professional
- Apology to colleague → Empathetic + Friendly
- Slack/WhatsApp → Friendly or Friendly-Professional

---

## Workflow

### Step 1 — Understand the Input

Extract from the user's message:
- **What they want to say** (the core message/intent)
- **Who they're writing to** (manager, client, colleague, friend)
- **What channel** (email, Slack, WhatsApp, text)
- **Desired outcome** (get a reply, apologise, escalate, inform, ask for something)
- **Tone preference** (if stated; otherwise infer)
- **Any constraints** (keep it short, formal, don't sound angry, etc.)

### Step 2 — Rewrite

Apply these principles:
- **Clear subject line** for emails (action-oriented: "Request for...", "Update on...", "Follow-up: ...")
- **One purpose per message** — don't mix topics
- **Lead with the most important point** — don't bury the ask
- **Specific and concrete** — avoid vague language like "at your earliest convenience"
- **Active voice** — "I need X" not "X is needed"
- **Appropriate length** — email: 3–8 sentences; Slack: 1–4 sentences; text: 1–2 sentences
- **Polite but not over-apologetic** — don't start with "Sorry to bother you"
- **Clear call to action** — end with what you need from them

### Step 3 — Output Format

Always output:

1. **The rewritten message** — ready to copy and send
   - For emails: include Subject line, greeting, body, sign-off
   - For Slack/chat: just the message body
   - For texts: just the message

2. **Tone label** — e.g. "Tone used: Professional + Assertive"

3. **What changed** — 2–3 bullet points explaining the key improvements made
   (e.g. "Made the ask clearer", "Removed passive voice", "Added specific deadline")

4. **Alternative version** (optional but valuable) — if there's a meaningfully different
   way to approach the same message (e.g. softer vs. more direct), offer it as Option B
   with a one-line explanation of when to use it.

---

## Example

**Input:**
> "Write an email to my manager telling him the test environment is broken and i cant do my testing and we might miss the release deadline but dont want to sound panicky"

**Output:**

**Subject:** Test Environment Issue — Potential Impact on Release Timeline

Hi [Manager's Name],

I wanted to flag an issue with the test environment that's currently blocking my testing work. Since this morning, [describe the issue briefly — e.g. the env is down / deployments are failing], and I haven't been able to proceed with the scheduled test execution.

If this isn't resolved by [date/time], it could impact our ability to meet the [release name] deadline. I wanted to raise it early so we have time to act.

Could you help escalate this with the infra/DevOps team, or let me know if there's an alternative environment I can use in the meantime?

Happy to jump on a quick call if helpful.

Thanks,
[Your Name]

---
**Tone used:** Professional + Assertive
**What changed:**
- Replaced panic with clear, factual framing of the problem
- Added a specific deadline reference to convey urgency without drama
- Ended with a concrete ask and offered a solution path

**Option B (more direct, for urgent escalation):**
> Subject: URGENT: Test Env Down — Release at Risk
> [Manager's Name], the test environment has been down since [time] and is blocking all QA activity. We risk missing the [release] deadline if it's not resolved by [time]. Requesting immediate escalation to DevOps. Let me know how you'd like to proceed.
> — [Your Name]
> *(Use this if the situation is truly critical and speed matters more than softness)*

---

## Tips for Best Results

- **Paste your rough draft** — even terrible wording is fine, the skill will fix it.
- **Say who you're writing to** — it changes the tone significantly.
- **Mention the outcome you want** — a reply? An action? An apology accepted?
- **Say if there are constraints** — "keep it under 5 lines", "don't sound too formal".
- **Multiple emails?** List them all — each gets its own rewrite.

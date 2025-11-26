# Skill: Fetch JIRA Ticket with WebFetch

**Skill ID:** `jira-fetch-webfetch`
**Version:** 1.0.0
**Purpose:** Fetch JIRA ticket details using WebFetch tool (without MCP)
**Last Updated:** 2025-11-26

---

## 🎯 When to Use This Skill

Use this skill when:
- User provides a JIRA ticket number (e.g., "ETHAN-1269", "PROJ-123")
- User provides a JIRA URL (e.g., "https://company.atlassian.net/browse/ETHAN-1269")
- Starting a workflow with a ticket reference
- User says "analyze JIRA ticket..."

---

## ⚙️ Prerequisites

Check these environment variables are set:
```bash
JIRA_URL="https://your-company.atlassian.net"
JIRA_EMAIL="your.email@company.com"
JIRA_API_TOKEN="your_api_token_here"
```

Verify WebFetch permission in `.claude/settings.local.json`:
```json
{
  "permissions": {
    "allow": [
      "WebFetch(domain:your-company.atlassian.net)"
    ]
  }
}
```

---

## 📋 Step-by-Step Execution

### Step 1: Detect JIRA Ticket

```typescript
function detectJiraTicket(input: string): string | null {
  // Pattern 1: Ticket key (PROJ-123)
  const keyMatch = input.match(/\b([A-Z]{2,10}-\d+)\b/);

  // Pattern 2: Full URL
  const urlMatch = input.match(/atlassian\.net\/browse\/([A-Z]{2,10}-\d+)/);

  return keyMatch?.[1] || urlMatch?.[1] || null;
}
```

**Examples:**
- Input: `"workflow:start ETHAN-1269"` → Extract: `"ETHAN-1269"`
- Input: `"https://company.atlassian.net/browse/ETHAN-1269"` → Extract: `"ETHAN-1269"`
- Input: `"analyze ticket ETHAN-1269"` → Extract: `"ETHAN-1269"`

### Step 2: Construct JIRA API URL

```typescript
function constructJiraApiUrl(ticketKey: string): string {
  const jiraUrl = process.env.JIRA_URL;
  return `${jiraUrl}/rest/api/3/issue/${ticketKey}`;
}
```

**Example:**
```
Ticket: ETHAN-1269
JIRA_URL: https://company.atlassian.net
Result: https://company.atlassian.net/rest/api/3/issue/ETHAN-1269
```

### Step 3: Prepare Authentication

```typescript
function prepareAuth(): string {
  const email = process.env.JIRA_EMAIL;
  const token = process.env.JIRA_API_TOKEN;

  // Basic Auth: base64(email:token)
  const credentials = `${email}:${token}`;
  return Buffer.from(credentials).toString('base64');
}
```

### Step 4: Use WebFetch Tool

**⚠️ IMPORTANT:** WebFetch is pre-approved in your settings for `company.atlassian.net`

```markdown
**Prompt for WebFetch:**

Extract JIRA ticket details from the API response and structure them as follows:

1. **Ticket Key** (e.g., ETHAN-1269)
2. **Summary** (ticket title)
3. **Description** (full markdown content)
4. **Issue Type** (Story, Bug, Task, Epic, etc.)
5. **Status** (To Do, In Progress, Code Review, Done, etc.)
6. **Priority** (Low, Medium, High, Critical)
7. **Assignee** (name and email if available)
8. **Reporter** (name and email if available)
9. **Labels** (array of labels)
10. **Components** (array of components)
11. **Created Date**
12. **Updated Date**
13. **Custom Fields** (if any - Story Points, Sprint, etc.)

**Special Attention:**
- Parse Description markdown formatting
- Extract sections like "Overview", "Functional Requirements", "Acceptance Criteria"
- Identify checkboxes: [ ] (unchecked) or [x] (checked)
- Extract technical notes
- Preserve code blocks and formatting

Return as clean, structured markdown.
```

**Example WebFetch Call:**
```typescript
await WebFetch({
  url: 'https://company.atlassian.net/rest/api/3/issue/ETHAN-1269',
  prompt: `[prompt from above]`,
  // Note: WebFetch automatically adds auth based on domain permission
})
```

### Step 5: Parse Response

Expected response structure:
```json
{
  "key": "ETHAN-1269",
  "fields": {
    "summary": "Add user authentication with JWT",
    "description": "## Overview\n...",
    "issuetype": { "name": "Story" },
    "status": { "name": "To Do" },
    "priority": { "name": "High" },
    "assignee": {
      "displayName": "Ethan Nguyen",
      "emailAddress": "ethan.nguyen@example.com"
    },
    "reporter": {
      "displayName": "Jacky Chen",
      "emailAddress": "jacky.chen@example.com"
    },
    "labels": ["auth", "mobile", "security"],
    "components": [{ "name": "Mobile App" }],
    "created": "2025-11-20T09:00:00.000+0800",
    "updated": "2025-11-26T14:30:00.000+0800",
    "customfield_10016": 8  // Story points
  }
}
```

### Step 6: Extract & Structure Requirements

```typescript
function extractRequirements(description: string) {
  const sections = {
    overview: extractSection(description, /##?\s*Overview/i),
    functionalRequirements: extractSection(description, /##?\s*Functional Requirements?/i),
    nonFunctionalRequirements: extractSection(description, /##?\s*(Non-Functional|NFR)/i),
    acceptanceCriteria: extractSection(description, /##?\s*(Acceptance Criteria|AC|Definition of Done)/i),
    technicalNotes: extractSection(description, /##?\s*(Technical Notes?|Implementation Notes?)/i),
  };

  // Parse AC checkboxes
  const acItems = parseCheckboxList(sections.acceptanceCriteria);

  return {
    ...sections,
    acceptanceCriteria: acItems
  };
}

function extractSection(text: string, sectionPattern: RegExp): string {
  const lines = text.split('\n');
  let capturing = false;
  let section = [];

  for (const line of lines) {
    if (sectionPattern.test(line)) {
      capturing = true;
      continue;
    }
    if (capturing && /^##?\s*/.test(line)) {
      // Hit next section
      break;
    }
    if (capturing) {
      section.push(line);
    }
  }

  return section.join('\n').trim();
}

function parseCheckboxList(text: string): Array<{text: string, completed: boolean}> {
  const checkboxPattern = /^[-*]\s*\[([ x])\]\s*(.+)$/gm;
  const items = [];

  let match;
  while ((match = checkboxPattern.exec(text)) !== null) {
    items.push({
      text: match[2].trim(),
      completed: match[1] === 'x'
    });
  }

  return items;
}
```

### Step 7: Generate requirements.md

```markdown
# Requirements: [Ticket Summary]

**JIRA Ticket:** [ETHAN-1269](https://company.atlassian.net/browse/ETHAN-1269)
**Type:** Story | **Priority:** High | **Status:** To Do

**Assignee:** Ethan Nguyen (ethan.nguyen@example.com)
**Reporter:** Jacky Chen (jacky.chen@example.com)
**Created:** 2025-11-20 | **Updated:** 2025-11-26

**Labels:** auth, mobile, security
**Components:** Mobile App
**Story Points:** 8

---

## 📋 Overview

[Parsed overview section]

---

## ✨ Functional Requirements

1. **FR-001:** User can log in with email/password
2. **FR-002:** App stores JWT token securely
3. **FR-003:** Token auto-refreshes before expiry
4. **FR-004:** User can log out

---

## ⚙️ Non-Functional Requirements

1. **NFR-001:** Token stored in secure storage (Keychain/Keystore)
2. **NFR-002:** Login response < 2 seconds
3. **NFR-003:** Follow OWASP security guidelines

---

## ✅ Acceptance Criteria

- [ ] AC-001: Login screen implemented
- [ ] AC-002: JWT token stored securely
- [ ] AC-003: Auto-refresh implemented
- [ ] AC-004: Logout functionality works
- [ ] AC-005: Unit tests cover 80%+
- [ ] AC-006: E2E tests for login flow

**Progress:** 0/6 completed (0%)

---

## 🔧 Technical Notes

[Parsed technical notes]

---

**Fetched from JIRA on:** 2025-11-26 14:45:00
**Workflow ID:** workflow-ignt-1269-20251126-1445
```

---

## 🎯 Complete Example

### User Input
```
workflow:start ETHAN-1269
```

### Your Response

```markdown
**─────────────────────────────────────────────────────────**
🤖 **Agent:** pm-operations-orchestrator | 📋 **System:** CCPM v5.0
**─────────────────────────────────────────────────────────**

🎫 **JIRA Ticket Detected:** ETHAN-1269

🔍 Fetching ticket details from JIRA...

[Use WebFetch tool with https://company.atlassian.net/rest/api/3/issue/ETHAN-1269]

✅ **Successfully fetched ticket:** "Add user authentication with JWT"

📊 **Ticket Information:**
- **Type:** Story
- **Priority:** High
- **Status:** To Do
- **Assignee:** Ethan Nguyen
- **Labels:** auth, mobile, security
- **Story Points:** 8

📝 **Parsing Requirements...**

✅ Found 4 functional requirements
✅ Found 3 non-functional requirements
✅ Found 6 acceptance criteria
✅ Found technical implementation notes

✨ **Starting Phase 1: Understand** 🎯
*"What are we building?"*

Let me analyze the JIRA ticket requirements and create a comprehensive understanding document...

[Continue with Phase 1 execution]
```

---

## ⚠️ Error Handling

### Error 1: Environment Variables Missing

```markdown
❌ **JIRA Integration Not Configured**

I cannot fetch JIRA ticket ETHAN-1269 because environment variables are missing.

**Required:**
- `JIRA_URL` (e.g., https://company.atlassian.net)
- `JIRA_EMAIL` (your JIRA email)
- `JIRA_API_TOKEN` (API token from JIRA)

**To fix:**
1. Edit `.claude/.envrc`
2. Add the required variables
3. Run: `source .claude/.envrc`
4. Try again

**Alternative:** Paste the ticket details manually and I'll continue.

Would you like to:
1. Configure JIRA integration now
2. Provide ticket details manually
3. Skip JIRA and continue with description only
```

### Error 2: WebFetch Permission Denied

```markdown
❌ **WebFetch Permission Required**

I cannot fetch JIRA tickets because WebFetch access to `company.atlassian.net` is not allowed.

**To fix:**
1. Open `.claude/settings.local.json`
2. Add to `permissions.allow`:
   ```json
   "WebFetch(domain:company.atlassian.net)"
   ```
3. Restart Claude Code
4. Try again

**Alternative:** I can continue without fetching. Would you like to provide ticket details manually?
```

### Error 3: Invalid Ticket Key

```markdown
⚠️ **Ticket Not Found:** ETHAN-1269

The ticket might not exist or you don't have access to it.

**Possible reasons:**
- Ticket was deleted
- Wrong project key (should it be PROJ-1269?)
- Insufficient JIRA permissions

**Would you like to:**
1. Double-check the ticket number
2. Verify your JIRA access
3. Continue without JIRA integration
```

### Error 4: API Token Expired

```markdown
❌ **JIRA Authentication Failed**

Your API token may have expired or is invalid.

**To fix:**
1. Go to: https://id.atlassian.com/manage-profile/security/api-tokens
2. Generate a new token named "CCPM Integration"
3. Update `.claude/.envrc` with new token
4. Run: `source .claude/.envrc`
5. Try again

**Test your credentials:**
```bash
curl -u "$JIRA_EMAIL:$JIRA_API_TOKEN" "$JIRA_URL/rest/api/3/myself"
```

If successful, you'll see your JIRA profile.
```

---

## 🔄 Integration with Workflows

### workflow:start with Ticket

```bash
# These all trigger JIRA fetch:
workflow:start ETHAN-1269
workflow:start ETHAN-1269 - Add JWT auth
workflow:start https://company.atlassian.net/browse/ETHAN-1269
```

### Phase 1: Auto-fetch Requirements

When Phase 1 detects a JIRA ticket:
1. **Activate** `jira-operations` agent
2. **Execute** this skill to fetch ticket
3. **Parse** requirements
4. **Generate** requirements.md
5. **Continue** with Phase 1 analysis

### Manual Fetch

```bash
# User can explicitly fetch
fetch jira ETHAN-1269
analyze jira ticket ETHAN-1269
get jira ETHAN-1269
```

---

## 📊 Success Criteria

- [ ] Detects JIRA ticket from various formats
- [ ] Fetches ticket using WebFetch
- [ ] Parses all standard JIRA fields
- [ ] Extracts structured requirements
- [ ] Parses acceptance criteria checkboxes
- [ ] Handles errors gracefully with alternatives
- [ ] Generates well-formatted requirements.md
- [ ] Integrates seamlessly with Phase 1

---

## 📚 Related Files

- **Agent:** `.claude/agents/jira-operations.md` - JIRA operations agent
- **Guide:** `.claude/docs/guides/JIRA_INTEGRATION.md` - Integration setup
- **Command:** `.claude/commands/workflow/start.md` - Workflow start command
- **Phase:** `.claude/commands/workflow/phase-1.md` - Phase 1 execution

---

**Skill Version:** 1.0.0
**Last Updated:** 2025-11-26
**Status:** ✅ Production Ready

**Usage:**
When user provides JIRA ticket → Activate this skill → Fetch → Parse → Continue workflow

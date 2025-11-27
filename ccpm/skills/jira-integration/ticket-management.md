---
name: jira-integration
description: "PROACTIVELY use when JIRA ticket mentioned in user message. Triggers: ticket IDs like 'PROJ-1234', JIRA URLs, 'jira:fetch' command. Auto-fetches ticket details, loads requirements, updates ticket status. Requires JIRA credentials in .envrc."
allowed-tools: Read, Bash
---

# CCPM JIRA Integration

**Version:** 5.0.0-beta
**Purpose:** Automatic JIRA ticket fetching and status updates
**Priority:** MEDIUM - Use when ticket mentioned

---

## 🎯 Overview

JIRA Integration automatically detects JIRA ticket references, fetches ticket details, loads requirements into workflow, and updates ticket status throughout the development process.

---

## ✅ When to Use This Skill

**AUTO-DETECT and use when:**
- User mentions ticket ID: "PROJ-1234", "IGNT-567"
- User pastes JIRA URL: `https://company.atlassian.net/browse/PROJ-1234`
- User says: "jira:fetch PROJ-1234"
- Starting workflow with ticket reference

**Examples:**
- "Implement PROJ-1234"
- "Fix bug in IGNT-567"
- "workflow:start MYAPP-123"

---

## 🔄 Integration Process

### Step 1: Detect Ticket ID

**Pattern matching:**
```javascript
// Match patterns like: PROJ-1234, IGNT-567, etc.
const ticketPattern = /([A-Z]+ {2,10})-(\d+)/g
const matches = userMessage.match(ticketPattern)

// Extract ticket ID
const ticketId = matches[0] // e.g., "PROJ-1234"
```

### Step 2: Fetch Ticket Data

**Using Bash script:**
```bash
# Load JIRA credentials from .envrc
source .envrc

# Fetch ticket using script
bash scripts/jira-fetch.sh PROJ-1234

# Output: .claude/logs/jira/PROJ-1234.json
```

**Script location:** `skills/jira-integration/scripts/jira-fetch.sh`

### Step 3: Parse Ticket Data

```json
{
  "key": "PROJ-1234",
  "summary": "Implement user profile screen",
  "description": "As a user, I want to view and edit my profile...",
  "status": "In Progress",
  "assignee": "Alice",
  "priority": "High",
  "labels": ["mobile", "ui"],
  "components": ["React Native"],
  "acceptance_criteria": [
    "User can view profile",
    "User can edit name and email",
    "Changes are saved to backend"
  ]
}
```

### Step 4: Load into Workflow

**Use ticket data in Phase 1 (Understand):**
- Summary → Task title
- Description → Requirements
- Acceptance criteria → Success criteria
- Labels/Components → Agent detection

### Step 5: Update Ticket Status

**Throughout workflow:**
- Phase 1 start → "In Progress"
- Phase 5b complete → "In Review"
- Phase 7 complete → "Testing"
- Phase 9 complete → "Done"

---

## 📋 Ticket Update Commands

```bash
# Update status
bash scripts/jira-update.sh PROJ-1234 status "In Progress"

# Add comment
bash scripts/jira-update.sh PROJ-1234 comment "Implementation started"

# Add attachment (screenshot, logs)
bash scripts/jira-update.sh PROJ-1234 attach "screenshot.png"

# Transition (start → in-progress → review → done)
bash scripts/jira-update.sh PROJ-1234 transition "In Review"
```

---

## ⚙️ Setup Requirements

**Environment variables in `.envrc`:**
```bash
export JIRA_URL="https://your-company.atlassian.net"
export JIRA_EMAIL="your-email@company.com"
export JIRA_API_TOKEN="your-jira-token"
export JIRA_PROJECT_KEY="PROJ"
```

**Check setup:**
```bash
if [ -z "$JIRA_API_TOKEN" ]; then
  echo "⚠️  JIRA not configured!"
  echo "See: docs/INTEGRATION_SETUP_GUIDE.md (Section 3.3: JIRA)"
fi
```

---

## 🔗 Related Skills

- **workflow-orchestrator** - Uses JIRA data in Phase 1
- **agent-detector** - Uses ticket labels for agent detection

---

**Remember:** JIRA integration is optional. Workflow works without it, but ticket data enhances context.

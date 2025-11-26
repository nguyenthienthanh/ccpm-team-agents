# Integration Setup Guide

**Version:** 5.0.0
**Last Updated:** 2025-11-27

---

## Overview

CCPM integrates with external services to enhance your workflow. This guide helps you decide which integrations to enable and how to set them up.

---

## Quick Decision Tree

```
Do you track issues in JIRA?
├─ YES → Enable JIRA Integration
└─ NO  → Skip JIRA

Do you use Confluence for documentation?
├─ YES → Enable Confluence Integration
└─ NO  → Use local Markdown only

Do you want team notifications?
├─ YES → Enable Slack Integration
└─ NO  → Skip Slack

Do you have Figma designs?
├─ YES → Enable Figma Integration (screenshots work without API)
└─ NO  → Skip Figma
```

---

## Integration Matrix

| Integration | Required For | Setup Time | Difficulty | Worth It? |
|-------------|--------------|------------|------------|-----------|
| **JIRA** | Issue tracking, auto-fetch tickets | 5 min | Easy | ⭐⭐⭐⭐⭐ High |
| **Confluence** | Auto-publish docs | 5 min | Easy | ⭐⭐⭐⭐ High |
| **Slack** | Team notifications | 10 min | Medium | ⭐⭐⭐ Medium |
| **Figma** | Design extraction | 5 min | Easy | ⭐⭐⭐⭐ High |

---

## Integration Details

### JIRA Integration

**What it does:**
- ✅ Auto-fetch ticket details when you mention ticket ID
- ✅ Update ticket status during workflow
- ✅ Add comments with progress updates
- ✅ Link commits to tickets

**When to enable:**
- ✅ You use JIRA for issue tracking
- ✅ You want automated ticket updates
- ✅ You work with ticket IDs (e.g., PROJ-123)

**When to skip:**
- ❌ You don't use JIRA
- ❌ You use GitHub Issues, Linear, or other trackers
- ❌ You prefer manual ticket updates

**Prerequisites:**
- Atlassian account
- JIRA project access
- Permission to create API tokens

**Setup Steps:**
1. Get JIRA URL (e.g., `https://yourcompany.atlassian.net`)
2. Create API token at https://id.atlassian.com/manage-profile/security/api-tokens
3. Add to `.envrc`:
   ```bash
   export JIRA_URL="https://yourcompany.atlassian.net"
   export JIRA_EMAIL="your@email.com"
   export JIRA_API_TOKEN="your_token_here"
   export JIRA_PROJECT_KEY="PROJ"
   ```
4. Enable in project context:
   ```yaml
   integrations:
     jira:
       enabled: true
       project_key: "PROJ"
   ```

**Test:**
```bash
bash ccpm/scripts/jira-fetch.sh PROJ-123
```

**See:** `docs/ENV_SETUP_GUIDE.md` for detailed setup

---

### Confluence Integration

**What it does:**
- ✅ Auto-publish documentation to Confluence
- ✅ Create pages in specified space
- ✅ Update existing pages
- ✅ Add labels and metadata

**When to enable:**
- ✅ Your team uses Confluence
- ✅ You want centralized documentation
- ✅ You need to share docs with non-technical stakeholders

**When to skip:**
- ❌ You only need local markdown files
- ❌ You use GitHub Wiki, Notion, or other docs platforms
- ❌ Your team doesn't use Confluence

**Prerequisites:**
- Atlassian account
- Confluence space access
- Permission to create pages
- Same API token as JIRA

**Setup Steps:**
1. Get Confluence URL (e.g., `https://yourcompany.atlassian.net/wiki`)
2. Find space key (visible in Confluence URLs)
3. Use same API token as JIRA
4. Add to `.envrc`:
   ```bash
   export CONFLUENCE_URL="https://yourcompany.atlassian.net/wiki"
   export CONFLUENCE_EMAIL="your@email.com"
   export CONFLUENCE_API_TOKEN="same_as_jira"
   export CONFLUENCE_SPACE_KEY="DEV"
   ```
5. Enable in project context:
   ```yaml
   integrations:
     confluence:
       enabled: true
       space_key: "DEV"
   ```

**Test:**
```bash
bash ccpm/scripts/confluence-publish.sh "Test Page" "Test content"
```

**See:** `docs/ENV_SETUP_GUIDE.md` for detailed setup

---

### Slack Integration

**What it does:**
- ✅ Send workflow completion notifications
- ✅ Alert team on phase completions
- ✅ Share deployment updates
- ✅ Notify on errors or blockers

**When to enable:**
- ✅ Your team uses Slack
- ✅ You want real-time notifications
- ✅ You want to keep team informed automatically

**When to skip:**
- ❌ You work solo
- ❌ Your team uses Teams, Discord, or other chat platforms
- ❌ You prefer manual updates

**Prerequisites:**
- Slack workspace access
- Permission to create apps/webhooks

**Setup Steps (Webhook - Recommended):**
1. Go to https://api.slack.com/apps
2. Create new app or select existing
3. Enable "Incoming Webhooks"
4. Add webhook to workspace
5. Copy webhook URL
6. Add to `.envrc`:
   ```bash
   export SLACK_WEBHOOK_URL="https://hooks.slack.com/services/YOUR/WEBHOOK/URL"
   ```
7. Enable in project context:
   ```yaml
   integrations:
     slack:
       enabled: true
       channels:
         dev: "#dev-team"
   ```

**Test:**
```bash
bash ccpm/scripts/slack-notify.sh "Test notification"
```

**See:** `docs/ENV_SETUP_GUIDE.md` for detailed setup

---

### Figma Integration

**What it does:**
- ✅ Fetch design specifications
- ✅ Extract components and layout
- ✅ Get design tokens (colors, spacing, typography)
- ✅ Works with screenshots (no API needed for basic use)

**When to enable:**
- ✅ You implement designs from Figma
- ✅ You want accurate UI implementation
- ✅ You work with designers

**When to skip:**
- ❌ You don't have designs
- ❌ Designs are in Sketch, Adobe XD, or other tools
- ❌ You prefer manual design reference

**Prerequisites (for API access):**
- Figma account
- Access to design files

**Setup Steps:**

**Option A: Screenshots (No Setup Required)**
- Just provide Figma URL in workflow
- Claude will ask for screenshots
- Works immediately

**Option B: API Access (Recommended)**
1. Go to https://www.figma.com/settings
2. Generate personal access token
3. Get file key from Figma URL
4. Add to `.envrc`:
   ```bash
   export FIGMA_ACCESS_TOKEN="figd_your_token_here"
   export FIGMA_FILE_KEY="ABC123DEF456"
   ```
5. Figma is enabled by default in config

**Test:**
```bash
bash ccpm/scripts/figma-fetch.sh ABC123DEF456
```

**See:** `docs/ENV_SETUP_GUIDE.md` for detailed setup

---

## Common Setup Scenarios

### Scenario 1: Solo Developer
**Recommended:** None or Figma only
- ✅ Figma (if you have designs)
- ❌ JIRA (overkill for solo work)
- ❌ Confluence (use local markdown)
- ❌ Slack (no team to notify)

**Setup Time:** 5 minutes

---

### Scenario 2: Small Team (2-5 people)
**Recommended:** JIRA + Figma
- ✅ JIRA (issue tracking)
- ✅ Figma (if designers involved)
- ⚠️ Slack (optional, useful for async updates)
- ⚠️ Confluence (optional, consider GitHub Wiki instead)

**Setup Time:** 15 minutes

---

### Scenario 3: Medium Team (6-15 people)
**Recommended:** All integrations
- ✅ JIRA (essential for coordination)
- ✅ Confluence (centralized docs)
- ✅ Slack (team communication)
- ✅ Figma (design handoff)

**Setup Time:** 30 minutes

---

### Scenario 4: Enterprise
**Recommended:** All integrations + advanced config
- ✅ JIRA (with custom workflows)
- ✅ Confluence (with templates)
- ✅ Slack (multiple channels)
- ✅ Figma (design system)

**Setup Time:** 1 hour (including customization)

---

## Integration Combinations

### Minimum Viable Setup
```yaml
# .envrc
# (nothing needed)

# project-config.yaml
integrations:
  jira:
    enabled: false
  confluence:
    enabled: false
  slack:
    enabled: false
  figma:
    enabled: true  # Works with screenshots
```

---

### Standard Development Setup
```yaml
# .envrc
export JIRA_URL="..."
export JIRA_EMAIL="..."
export JIRA_API_TOKEN="..."
export FIGMA_ACCESS_TOKEN="..."

# project-config.yaml
integrations:
  jira:
    enabled: true
    project_key: "PROJ"
  confluence:
    enabled: false
  slack:
    enabled: false
  figma:
    enabled: true
```

---

### Full Team Setup
```yaml
# .envrc
export JIRA_URL="..."
export JIRA_EMAIL="..."
export JIRA_API_TOKEN="..."
export CONFLUENCE_URL="..."
export CONFLUENCE_EMAIL="..."
export CONFLUENCE_API_TOKEN="..."
export SLACK_WEBHOOK_URL="..."
export FIGMA_ACCESS_TOKEN="..."

# project-config.yaml
integrations:
  jira:
    enabled: true
    project_key: "PROJ"
  confluence:
    enabled: true
    space_key: "DEV"
  slack:
    enabled: true
    channels:
      dev: "#dev-team"
      qa: "#qa-team"
  figma:
    enabled: true
```

---

## Troubleshooting

### Integration Not Working

**Check prerequisites:**
```bash
# Check environment variables loaded
env | grep JIRA
env | grep CONFLUENCE
env | grep SLACK
env | grep FIGMA

# Test individual integrations
bash ccpm/scripts/jira-fetch.sh PROJ-123
bash ccpm/scripts/confluence-list.sh
bash ccpm/scripts/slack-notify.sh "Test"
bash ccpm/scripts/figma-fetch.sh FILE_KEY
```

**Common issues:**
- ❌ Environment variables not loaded (run `direnv allow`)
- ❌ Expired or invalid tokens (regenerate)
- ❌ Wrong project key or space key
- ❌ Network/firewall blocking requests
- ❌ Insufficient permissions on service

---

### Rate Limiting

If you hit rate limits, adjust in `ccpm-config.yaml`:

```yaml
integrations:
  jira:
    rate_limit: 5  # Reduce from 10 to 5 requests/min
  confluence:
    rate_limit: 5
  slack:
    rate_limit: 1  # Already conservative
```

---

## Security Considerations

**✅ DO:**
- Keep tokens in `.envrc` (gitignored)
- Use separate tokens per project
- Rotate tokens every 90 days
- Use read-only tokens when possible
- Revoke tokens when leaving team

**❌ DON'T:**
- Commit tokens to git
- Share tokens in chat
- Use production tokens for development
- Give tokens broader permissions than needed

---

## Cost Considerations

**Free Integrations:**
- ✅ JIRA (on paid Atlassian plan)
- ✅ Confluence (on paid Atlassian plan)
- ✅ Slack (on any plan)
- ✅ Figma (on any plan)

**No Additional Costs:**
All integrations use existing service APIs. No extra CCPM costs.

---

## Next Steps

1. **Decide** which integrations you need using decision tree
2. **Setup** environment variables (see `ENV_SETUP_GUIDE.md`)
3. **Enable** in project context config
4. **Test** each integration individually
5. **Use** in workflow with `workflow:start "task"`

---

## Related Documentation

- **ENV_SETUP_GUIDE.md** - Detailed environment variable setup
- **CONFIG_LOADING_ORDER.md** - Configuration priority
- **BASH_INTEGRATIONS_GUIDE.md** - Integration script details
- **project-contexts/template/project-config.yaml** - Example config

---

**Questions?** See `ccpm/README.md` or raise an issue.

---

**Version:** 5.0.0
**Last Updated:** 2025-11-27

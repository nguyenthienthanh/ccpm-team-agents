#!/bin/bash
# JIRA Ticket Fetch Script for Aura Frog
# Usage: ./jira-fetch.sh ETHAN-1269
# Version: 1.0.0

set -e

# Script directory (for relative paths)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Log directory - use project's logs or fallback to plugin logs
if [ -d ".claude/logs" ]; then
  LOG_DIR=".claude/logs/jira"
elif [ -d "logs" ]; then
  LOG_DIR="logs/jira"
else
  LOG_DIR="${PLUGIN_DIR}/logs/jira"
fi

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Log file with timestamp
LOG_FILE="${LOG_DIR}/jira-fetch-$(date +%Y%m%d-%H%M%S).log"

# Logging function
log() {
  local level="$1"
  local message="$2"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
  if [ "$level" = "ERROR" ]; then
    echo "❌ $message" >&2
  fi
}

log "INFO" "=== JIRA Fetch Script Started ==="

# Get ticket key from argument
TICKET_KEY="$1"

if [ -z "$TICKET_KEY" ]; then
  log "ERROR" "Ticket key required"
  echo "❌ Error: Ticket key required"
  echo "Usage: $0 TICKET_KEY"
  echo "Example: $0 ETHAN-1269"
  exit 1
fi

log "INFO" "Fetching ticket: $TICKET_KEY"

# Load environment variables - check multiple locations
ENVRC_LOADED=false

# Priority 1: Current directory .envrc
if [ -f ".envrc" ]; then
  log "INFO" "Loading .envrc from current directory"
  source .envrc
  ENVRC_LOADED=true
# Priority 2: Project .claude/.envrc
elif [ -f ".claude/.envrc" ]; then
  log "INFO" "Loading .envrc from .claude/"
  source .claude/.envrc
  ENVRC_LOADED=true
# Priority 3: Home directory .envrc
elif [ -f "$HOME/.envrc" ]; then
  log "INFO" "Loading .envrc from home directory"
  source "$HOME/.envrc"
  ENVRC_LOADED=true
# Priority 4: Plugin directory .envrc
elif [ -f "${PLUGIN_DIR}/.envrc" ]; then
  log "INFO" "Loading .envrc from plugin directory"
  source "${PLUGIN_DIR}/.envrc"
  ENVRC_LOADED=true
fi

if [ "$ENVRC_LOADED" = false ]; then
  log "ERROR" ".envrc not found in any location"
  echo "❌ Error: .envrc not found"
  echo ""
  echo "Searched locations:"
  echo "  1. Current directory (.envrc)"
  echo "  2. Project .claude/.envrc"
  echo "  3. Home directory (~/.envrc)"
  echo "  4. Plugin directory (${PLUGIN_DIR}/.envrc)"
  echo ""
  echo "Please create .envrc with JIRA credentials in one of these locations"
  exit 1
fi

# Check required variables
if [ -z "$JIRA_URL" ] || [ -z "$JIRA_EMAIL" ] || [ -z "$JIRA_API_TOKEN" ]; then
  log "ERROR" "JIRA environment variables not set"
  echo "❌ Error: JIRA environment variables not set"
  echo ""
  echo "Required variables in .envrc:"
  echo "  - JIRA_URL (e.g., https://company.atlassian.net)"
  echo "  - JIRA_EMAIL (your JIRA email)"
  echo "  - JIRA_API_TOKEN (API token from JIRA)"
  echo ""
  echo "To fix:"
  echo "  1. Edit .envrc"
  echo "  2. Add the variables"
  echo "  3. Run: source .envrc"
  echo "  4. Try again"
  exit 1
fi

log "INFO" "JIRA credentials loaded successfully"
log "INFO" "JIRA_URL: $JIRA_URL"
log "INFO" "JIRA_EMAIL: $JIRA_EMAIL"

# Construct API URL
API_URL="${JIRA_URL}/rest/api/3/issue/${TICKET_KEY}"
log "INFO" "API URL: $API_URL"

# Fetch ticket with curl
echo "🔍 Fetching JIRA ticket: $TICKET_KEY"
echo "📡 API: $JIRA_URL"
echo ""

log "INFO" "Sending API request..."

response=$(curl -s -w "\n%{http_code}" \
  -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -H "Accept: application/json" \
  "$API_URL")

# Extract HTTP status code (last line)
http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | sed '$d')

log "INFO" "HTTP Response Code: $http_code"

# Check HTTP status
if [ "$http_code" != "200" ]; then
  log "ERROR" "HTTP request failed with code: $http_code"
  log "ERROR" "Response body: $body"
  echo "❌ Error: HTTP $http_code"
  echo ""
  if command -v jq &> /dev/null; then
    echo "$body" | jq -r '.errorMessages[]?' 2>/dev/null || echo "$body"
  else
    echo "$body"
  fi
  echo ""
  echo "Common issues:"
  echo "  - 401: Invalid API token (regenerate at id.atlassian.com)"
  echo "  - 404: Ticket not found (check ticket key)"
  echo "  - 403: No permission to view ticket"
  echo ""
  echo "📋 Log file: $LOG_FILE"
  exit 1
fi

log "INFO" "API request successful"

# Check if jq is installed
if ! command -v jq &> /dev/null; then
  log "WARN" "jq not installed, output will be raw JSON"
  echo "⚠️ Warning: jq not installed, output will be raw JSON"
  echo ""
  echo "To install jq:"
  echo "  macOS: brew install jq"
  echo "  Linux: sudo apt install jq"
  echo ""
  echo "Raw JSON:"
  echo "$body"

  # Save raw JSON
  echo "$body" > "${LOG_DIR}/${TICKET_KEY}.json"
  log "INFO" "Raw JSON saved to: ${LOG_DIR}/${TICKET_KEY}.json"
  echo ""
  echo "💾 Saved to: ${LOG_DIR}/${TICKET_KEY}.json"
  echo "📋 Log file: $LOG_FILE"
  exit 0
fi

# Parse and display ticket
echo "✅ Successfully fetched ticket"
echo ""

# Extract key fields
summary=$(echo "$body" | jq -r '.fields.summary')
description=$(echo "$body" | jq -r '.fields.description // "No description"')
issue_type=$(echo "$body" | jq -r '.fields.issuetype.name')
status=$(echo "$body" | jq -r '.fields.status.name')
priority=$(echo "$body" | jq -r '.fields.priority.name // "None"')
assignee=$(echo "$body" | jq -r '.fields.assignee.displayName // "Unassigned"')
assignee_email=$(echo "$body" | jq -r '.fields.assignee.emailAddress // ""')
reporter=$(echo "$body" | jq -r '.fields.reporter.displayName // "Unknown"')
created=$(echo "$body" | jq -r '.fields.created')
updated=$(echo "$body" | jq -r '.fields.updated')
labels=$(echo "$body" | jq -r '.fields.labels | join(", ")')
components=$(echo "$body" | jq -r '.fields.components | map(.name) | join(", ")')

# Log parsed JIRA data
log "INFO" "=== JIRA Ticket Data ==="
log "INFO" "Ticket Key: $TICKET_KEY"
log "INFO" "Summary: $summary"
log "INFO" "Type: $issue_type"
log "INFO" "Status: $status"
log "INFO" "Priority: $priority"
log "INFO" "Assignee: $assignee${assignee_email:+ ($assignee_email)}"
log "INFO" "Reporter: $reporter"
log "INFO" "Labels: ${labels:-None}"
log "INFO" "Components: ${components:-None}"
log "INFO" "Created: $created"
log "INFO" "Updated: $updated"
log "INFO" "========================"

# Display formatted output
cat <<EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎫 JIRA TICKET: $TICKET_KEY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Summary: $summary

📊 Details:
   Type:       $issue_type
   Status:     $status
   Priority:   $priority
   Assignee:   $assignee${assignee_email:+ ($assignee_email)}
   Reporter:   $reporter

🏷️  Labels:     ${labels:-None}
📦 Components:  ${components:-None}

📅 Dates:
   Created:    $created
   Updated:    $updated

📝 Description:
$description

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Save raw JSON to temp file for Claude to parse
echo "$body" > "${LOG_DIR}/${TICKET_KEY}.json"
log "INFO" "Raw JSON saved to: ${LOG_DIR}/${TICKET_KEY}.json"
log "INFO" "=== JIRA Fetch Script Completed Successfully ==="
echo ""
echo "💾 Raw JSON saved to: ${LOG_DIR}/${TICKET_KEY}.json"
echo "📋 Log file: $LOG_FILE"
echo "🤖 Claude can now parse this file for detailed requirements"

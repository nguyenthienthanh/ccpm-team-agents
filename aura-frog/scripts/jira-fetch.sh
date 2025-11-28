#!/bin/bash
# JIRA Ticket Fetch Script for Aura Frog
# Usage: ./jira-fetch.sh ETHAN-1269
# Version: 1.0.0

set -e

# Get ticket key from argument
TICKET_KEY="$1"

if [ -z "$TICKET_KEY" ]; then
  echo "❌ Error: Ticket key required"
  echo "Usage: $0 TICKET_KEY"
  echo "Example: $0 ETHAN-1269"
  exit 1
fi

# Load environment variables
if [ -f ".envrc" ]; then
  source .envrc
else
  echo "❌ Error: .envrc not found"
  echo "Please create .envrc with JIRA credentials"
  exit 1
fi

# Check required variables
if [ -z "$JIRA_URL" ] || [ -z "$JIRA_EMAIL" ] || [ -z "$JIRA_API_TOKEN" ]; then
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

# Construct API URL
API_URL="${JIRA_URL}/rest/api/3/issue/${TICKET_KEY}"

# Fetch ticket with curl
echo "🔍 Fetching JIRA ticket: $TICKET_KEY"
echo "📡 API: $JIRA_URL"
echo ""

response=$(curl -s -w "\n%{http_code}" \
  -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -H "Accept: application/json" \
  "$API_URL")

# Extract HTTP status code (last line)
http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | sed '$d')

# Check HTTP status
if [ "$http_code" != "200" ]; then
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
  exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
  echo "⚠️ Warning: jq not installed, output will be raw JSON"
  echo ""
  echo "To install jq:"
  echo "  macOS: brew install jq"
  echo "  Linux: sudo apt install jq"
  echo ""
  echo "Raw JSON:"
  echo "$body"

  # Save raw JSON
  mkdir -p logs/jira
  echo "$body" > "logs/jira/${TICKET_KEY}.json"
  echo ""
  echo "💾 Saved to: logs/jira/${TICKET_KEY}.json"
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
mkdir -p logs/jira
echo "$body" > "logs/jira/${TICKET_KEY}.json"
echo ""
echo "💾 Raw JSON saved to: logs/jira/${TICKET_KEY}.json"
echo "🤖 Claude can now parse this file for detailed requirements"

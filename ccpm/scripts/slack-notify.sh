#!/bin/bash
# Slack Notification Script for CCPM
# Usage: ./slack-notify.sh <channel> <message> [options]
# Version: 1.0.0

set -e

# Parse arguments
CHANNEL="$1"
MESSAGE="$2"
THREAD_TS="$3"  # Optional: reply to thread
MENTIONS="$4"   # Optional: @user1,@user2

if [ -z "$CHANNEL" ] || [ -z "$MESSAGE" ]; then
  echo "❌ Error: Channel and message required"
  echo ""
  echo "Usage: $0 <channel> <message> [thread_ts] [mentions]"
  echo ""
  echo "Examples:"
  echo "  $0 '#dev-team' 'Deploy completed!'"
  echo "  $0 'C01234567' 'Build failed' '' '@developer-team'"
  echo "  $0 '#general' 'PR ready' '1234567890.123456' '@reviewer'"
  exit 1
fi

# Load environment variables
if [ -f ".envrc" ]; then
  source .envrc
else
  echo "❌ Error: .envrc not found"
  exit 1
fi

# Check required variables
if [ -z "$SLACK_BOT_TOKEN" ]; then
  echo "❌ Error: SLACK_BOT_TOKEN not set"
  echo ""
  echo "To fix:"
  echo "  1. Create Slack App: https://api.slack.com/apps"
  echo "  2. Add Bot Token Scopes: chat:write, chat:write.public"
  echo "  3. Install to workspace"
  echo "  4. Copy Bot User OAuth Token (starts with xoxb-)"
  echo "  5. Edit .envrc"
  echo "  6. Add: export SLACK_BOT_TOKEN=\"xoxb-your-token\""
  echo "  7. Run: source .envrc"
  exit 1
fi

echo "💬 Sending Slack notification..."
echo "📍 Channel: $CHANNEL"
echo ""

# Add mentions to message if provided
if [ -n "$MENTIONS" ]; then
  MESSAGE="${MENTIONS} ${MESSAGE}"
fi

# Construct JSON payload
if [ -n "$THREAD_TS" ]; then
  # Reply in thread
  payload=$(jq -n \
    --arg channel "$CHANNEL" \
    --arg text "$MESSAGE" \
    --arg thread_ts "$THREAD_TS" \
    '{channel: $channel, text: $text, thread_ts: $thread_ts}')
else
  # New message
  payload=$(jq -n \
    --arg channel "$CHANNEL" \
    --arg text "$MESSAGE" \
    '{channel: $channel, text: $text}')
fi

# Send message
response=$(curl -s -w "\n%{http_code}" \
  -X POST \
  -H "Authorization: Bearer ${SLACK_BOT_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$payload" \
  "https://slack.com/api/chat.postMessage")

# Extract HTTP status code
http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | sed '$d')

# Check HTTP status
if [ "$http_code" != "200" ]; then
  echo "❌ Error: HTTP $http_code"
  echo "$body"
  exit 1
fi

# Check Slack API response
ok=$(echo "$body" | jq -r '.ok')

if [ "$ok" != "true" ]; then
  echo "❌ Slack API Error"
  error=$(echo "$body" | jq -r '.error')
  echo "Error: $error"
  echo ""
  echo "Common issues:"
  echo "  - invalid_auth: Token expired or invalid"
  echo "  - channel_not_found: Channel doesn't exist or bot not invited"
  echo "  - not_in_channel: Bot needs to be invited to channel"
  echo "  - missing_scope: Add chat:write scope to bot"
  exit 1
fi

# Success
message_ts=$(echo "$body" | jq -r '.ts')
channel_id=$(echo "$body" | jq -r '.channel')

echo "✅ Message sent successfully!"
echo ""
echo "📊 Details:"
echo "   Message ID: $message_ts"
echo "   Channel ID: $channel_id"

# Save response
mkdir -p logs/slack
echo "$body" > "logs/slack/message-${message_ts}.json"
echo ""
echo "💾 Response saved to: logs/slack/message-${message_ts}.json"

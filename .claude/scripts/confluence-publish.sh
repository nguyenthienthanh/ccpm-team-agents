#!/bin/bash
# Confluence Page Publish Script for CCPM
# Usage: ./confluence-publish.sh <space-key> <title> <content-file>
# Version: 1.0.0

set -e

# Parse arguments
SPACE_KEY="$1"
PAGE_TITLE="$2"
CONTENT_FILE="$3"
PARENT_PAGE_ID="$4"  # Optional

if [ -z "$SPACE_KEY" ] || [ -z "$PAGE_TITLE" ] || [ -z "$CONTENT_FILE" ]; then
  echo "❌ Error: Space key, title, and content file required"
  echo ""
  echo "Usage: $0 <space-key> <title> <content-file> [parent-page-id]"
  echo ""
  echo "Examples:"
  echo "  $0 'DEV' 'API Documentation' 'docs/api.md'"
  echo "  $0 'PROJ' 'Sprint Report' 'report.md' '123456'"
  exit 1
fi

# Check if content file exists
if [ ! -f "$CONTENT_FILE" ]; then
  echo "❌ Error: Content file not found: $CONTENT_FILE"
  exit 1
fi

# Load environment variables
if [ -f ".claude/.envrc" ]; then
  source .claude/.envrc
else
  echo "❌ Error: .claude/.envrc not found"
  exit 1
fi

# Check required variables
if [ -z "$CONFLUENCE_URL" ] || [ -z "$CONFLUENCE_EMAIL" ] || [ -z "$CONFLUENCE_API_TOKEN" ]; then
  echo "❌ Error: Confluence environment variables not set"
  echo ""
  echo "Required in .claude/.envrc:"
  echo "  - CONFLUENCE_URL (e.g., https://your-domain.atlassian.net/wiki)"
  echo "  - CONFLUENCE_EMAIL (your email)"
  echo "  - CONFLUENCE_API_TOKEN (API token from Atlassian)"
  echo ""
  echo "To fix:"
  echo "  1. Generate token: https://id.atlassian.com/manage-profile/security/api-tokens"
  echo "  2. Edit .claude/.envrc"
  echo "  3. Add the variables"
  echo "  4. Run: source .claude/.envrc"
  exit 1
fi

echo "📚 Publishing to Confluence..."
echo "📍 Space: $SPACE_KEY"
echo "📄 Title: $PAGE_TITLE"
echo ""

# Read content file
CONTENT=$(cat "$CONTENT_FILE")

# Convert Markdown to Confluence Storage Format (basic conversion)
# For better conversion, use pandoc or markdown-to-atlassian-wiki
CONFLUENCE_CONTENT=$(echo "$CONTENT" | sed 's/^# \(.*\)/<h1>\1<\/h1>/g' | \
  sed 's/^## \(.*\)/<h2>\1<\/h2>/g' | \
  sed 's/^### \(.*\)/<h3>\1<\/h3>/g' | \
  sed 's/^\* \(.*\)/<li>\1<\/li>/g' | \
  sed 's/^- \(.*\)/<li>\1<\/li>/g' | \
  sed 's/`\([^`]*\)`/<code>\1<\/code>/g' | \
  sed 's/\*\*\([^*]*\)\*\*/<strong>\1<\/strong>/g' | \
  tr '\n' ' ')

# Check if page already exists
echo "🔍 Checking if page exists..."

search_response=$(curl -s -w "\n%{http_code}" \
  -u "${CONFLUENCE_EMAIL}:${CONFLUENCE_API_TOKEN}" \
  -H "Accept: application/json" \
  "${CONFLUENCE_URL}/rest/api/content?spaceKey=${SPACE_KEY}&title=${PAGE_TITLE// /%20}")

http_code=$(echo "$search_response" | tail -n1)
search_body=$(echo "$search_response" | sed '$d')

if [ "$http_code" != "200" ]; then
  echo "❌ Error: HTTP $http_code"
  echo "$search_body"
  exit 1
fi

# Check if page exists
page_count=$(echo "$search_body" | jq '.results | length')

if [ "$page_count" -gt "0" ]; then
  # Page exists - UPDATE
  echo "📝 Page exists, updating..."

  PAGE_ID=$(echo "$search_body" | jq -r '.results[0].id')
  CURRENT_VERSION=$(echo "$search_body" | jq -r '.results[0].version.number')
  NEW_VERSION=$((CURRENT_VERSION + 1))

  # Construct update payload
  payload=$(jq -n \
    --arg title "$PAGE_TITLE" \
    --arg content "$CONFLUENCE_CONTENT" \
    --argjson version "$NEW_VERSION" \
    '{
      version: {number: $version},
      title: $title,
      type: "page",
      body: {
        storage: {
          value: $content,
          representation: "storage"
        }
      }
    }')

  # Update page
  response=$(curl -s -w "\n%{http_code}" \
    -X PUT \
    -u "${CONFLUENCE_EMAIL}:${CONFLUENCE_API_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "$payload" \
    "${CONFLUENCE_URL}/rest/api/content/${PAGE_ID}")

else
  # Page doesn't exist - CREATE
  echo "✨ Creating new page..."

  # Construct create payload
  if [ -n "$PARENT_PAGE_ID" ]; then
    payload=$(jq -n \
      --arg space "$SPACE_KEY" \
      --arg title "$PAGE_TITLE" \
      --arg content "$CONFLUENCE_CONTENT" \
      --arg parent "$PARENT_PAGE_ID" \
      '{
        type: "page",
        title: $title,
        space: {key: $space},
        ancestors: [{id: $parent}],
        body: {
          storage: {
            value: $content,
            representation: "storage"
          }
        }
      }')
  else
    payload=$(jq -n \
      --arg space "$SPACE_KEY" \
      --arg title "$PAGE_TITLE" \
      --arg content "$CONFLUENCE_CONTENT" \
      '{
        type: "page",
        title: $title,
        space: {key: $space},
        body: {
          storage: {
            value: $content,
            representation: "storage"
          }
        }
      }')
  fi

  # Create page
  response=$(curl -s -w "\n%{http_code}" \
    -X POST \
    -u "${CONFLUENCE_EMAIL}:${CONFLUENCE_API_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "$payload" \
    "${CONFLUENCE_URL}/rest/api/content")
fi

# Extract HTTP status code
http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | sed '$d')

# Check HTTP status
if [ "$http_code" != "200" ]; then
  echo "❌ Error: HTTP $http_code"
  if command -v jq &> /dev/null; then
    echo "$body" | jq -r '.message?' 2>/dev/null || echo "$body"
  else
    echo "$body"
  fi
  echo ""
  echo "Common issues:"
  echo "  - 401: Invalid credentials"
  echo "  - 404: Space not found"
  echo "  - 403: No permission to create/edit pages"
  exit 1
fi

# Success
page_id=$(echo "$body" | jq -r '.id')
page_url="${CONFLUENCE_URL}/pages/viewpage.action?pageId=${page_id}"

echo "✅ Page published successfully!"
echo ""
echo "📊 Details:"
echo "   Page ID: $page_id"
echo "   URL: $page_url"

# Save response
mkdir -p .claude/logs/confluence
echo "$body" > ".claude/logs/confluence/page-${page_id}.json"
echo ""
echo "💾 Response saved to: .claude/logs/confluence/page-${page_id}.json"
echo ""
echo "🔗 View page: $page_url"

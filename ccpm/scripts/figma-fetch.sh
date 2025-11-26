#!/bin/bash
# Figma File Fetch Script for CCPM
# Usage: ./figma-fetch.sh <file-id-or-url>
# Version: 1.0.0

set -e

# Get Figma file ID or URL from argument
INPUT="$1"

if [ -z "$INPUT" ]; then
  echo "❌ Error: Figma file ID or URL required"
  echo ""
  echo "Usage: $0 <file-id-or-url>"
  echo ""
  echo "Examples:"
  echo "  $0 ABC123xyz456"
  echo "  $0 https://www.figma.com/file/ABC123xyz456/Design-Name"
  echo "  $0 https://www.figma.com/design/ABC123xyz456/Design-Name"
  exit 1
fi

# Extract file ID from URL if needed
if [[ "$INPUT" =~ figma.com/(file|design)/([a-zA-Z0-9]+) ]]; then
  FILE_ID="${BASH_REMATCH[2]}"
  echo "📎 Extracted Figma file ID from URL: $FILE_ID"
else
  FILE_ID="$INPUT"
fi

# Load environment variables
if [ -f ".envrc" ]; then
  source .envrc
else
  echo "❌ Error: .envrc not found"
  echo "Please create .envrc with FIGMA_ACCESS_TOKEN"
  exit 1
fi

# Check required variables
if [ -z "$FIGMA_ACCESS_TOKEN" ]; then
  echo "❌ Error: FIGMA_ACCESS_TOKEN not set"
  echo ""
  echo "To fix:"
  echo "  1. Get token from: https://www.figma.com/settings (Personal Access Tokens)"
  echo "  2. Edit .envrc"
  echo "  3. Add: export FIGMA_ACCESS_TOKEN=\"your_token_here\""
  echo "  4. Run: source .envrc"
  exit 1
fi

# Construct API URL
API_URL="https://api.figma.com/v1/files/${FILE_ID}"

echo "🎨 Fetching Figma file: $FILE_ID"
echo "📡 API: https://api.figma.com"
echo ""

# Fetch file metadata
response=$(curl -s -w "\n%{http_code}" \
  -H "X-Figma-Token: ${FIGMA_ACCESS_TOKEN}" \
  "$API_URL")

# Extract HTTP status code
http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | sed '$d')

# Check HTTP status
if [ "$http_code" != "200" ]; then
  echo "❌ Error: HTTP $http_code"
  echo ""
  if command -v jq &> /dev/null; then
    echo "$body" | jq -r '.err?, .message?' 2>/dev/null || echo "$body"
  else
    echo "$body"
  fi
  echo ""
  echo "Common issues:"
  echo "  - 403: Invalid token (regenerate at figma.com/settings)"
  echo "  - 404: File not found (check file ID)"
  echo "  - 403: No permission to access file"
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
  mkdir -p logs/figma
  echo "$body" > "logs/figma/${FILE_ID}.json"
  echo ""
  echo "💾 Saved to: logs/figma/${FILE_ID}.json"
  exit 0
fi

# Parse and display file info
echo "✅ Successfully fetched Figma file"
echo ""

# Extract key fields
file_name=$(echo "$body" | jq -r '.name')
last_modified=$(echo "$body" | jq -r '.lastModified')
version=$(echo "$body" | jq -r '.version')
thumbnail=$(echo "$body" | jq -r '.thumbnailUrl // "N/A"')

# Extract document structure
num_pages=$(echo "$body" | jq '.document.children | length')
page_names=$(echo "$body" | jq -r '.document.children[].name' | paste -sd ", " -)

# Extract styles if present
num_styles=$(echo "$body" | jq '.styles | length // 0')

# Display formatted output
cat <<EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎨 FIGMA FILE: $FILE_ID
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Name: $file_name

📊 Details:
   Version:       $version
   Last Modified: $last_modified
   Pages:         $num_pages
   Styles:        $num_styles

📄 Pages: $page_names

🔗 View Online:
   https://www.figma.com/file/${FILE_ID}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Save full JSON
mkdir -p logs/figma
echo "$body" > "logs/figma/${FILE_ID}.json"
echo ""
echo "💾 Full JSON saved to: logs/figma/${FILE_ID}.json"

# Fetch images (node metadata)
echo ""
echo "🖼️  Fetching image assets..."

# Get all frames and components
frames=$(echo "$body" | jq -r '
  .. |
  objects |
  select(.type == "FRAME" or .type == "COMPONENT") |
  .id' 2>/dev/null | head -10)

if [ -n "$frames" ]; then
  # Convert to comma-separated for API
  frame_ids=$(echo "$frames" | paste -sd "," -)

  # Fetch image URLs
  images_response=$(curl -s \
    -H "X-Figma-Token: ${FIGMA_ACCESS_TOKEN}" \
    "https://api.figma.com/v1/images/${FILE_ID}?ids=${frame_ids}&format=png&scale=2")

  # Save images metadata
  echo "$images_response" > "logs/figma/${FILE_ID}-images.json"
  echo "✅ Image URLs saved to: logs/figma/${FILE_ID}-images.json"
else
  echo "⚠️  No frames found in file"
fi

echo ""
echo "🤖 Claude can now parse these files for design details"

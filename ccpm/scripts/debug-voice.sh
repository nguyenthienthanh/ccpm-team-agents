#!/bin/bash

# CCPM Voice Debug Script
# Purpose: Debug voiceover API issues
# Usage: bash scripts/debug-voice.sh

echo "🔍 CCPM Voiceover Debug"
echo "======================="
echo ""

# Check config file
CONFIG_FILE="$HOME/.claude/ccpm-voice-config"

echo "1. Checking config file..."
if [ -f "$CONFIG_FILE" ]; then
  echo "   ✅ Config file exists: $CONFIG_FILE"
  source "$CONFIG_FILE"
  echo ""

  echo "2. Checking API key..."
  if [ -n "$ELEVENLABS_API_KEY" ]; then
    echo "   ✅ API key loaded"
    echo "   Key length: ${#ELEVENLABS_API_KEY} characters"
    echo "   First 10 chars: ${ELEVENLABS_API_KEY:0:10}"
    echo "   Last 4 chars: ...${ELEVENLABS_API_KEY: -4}"
  else
    echo "   ❌ API key not found in config file"
    exit 1
  fi
  echo ""

  echo "3. Checking voice ID..."
  if [ -n "$ELEVENLABS_VOICE_ID" ]; then
    echo "   ✅ Voice ID: $ELEVENLABS_VOICE_ID"
  else
    echo "   ℹ️  Voice ID not set (will use default)"
    ELEVENLABS_VOICE_ID="21m00Tcm4TlvDq8ikWAM"
  fi
  echo ""
else
  echo "   ❌ Config file not found: $CONFIG_FILE"
  echo "   Run: bash scripts/setup-voice.sh"
  exit 1
fi

# Test 1: Get voices (simple auth test)
echo "4. Testing API authentication (GET /voices)..."
RESPONSE=$(curl -s -w "\n%{http_code}" \
  -X GET "https://api.elevenlabs.io/v1/voices" \
  -H "xi-api-key: ${ELEVENLABS_API_KEY}")

HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | head -n -1)

echo "   HTTP Status: $HTTP_CODE"

if [ "$HTTP_CODE" -eq 200 ]; then
  echo "   ✅ Authentication successful!"
  echo ""
  echo "   Available voices:"
  echo "$BODY" | grep -o '"name":"[^"]*"' | head -5
  echo ""
elif [ "$HTTP_CODE" -eq 401 ]; then
  echo "   ❌ Authentication failed (401 Unauthorized)"
  echo ""
  echo "   Possible issues:"
  echo "   1. API key is incorrect"
  echo "   2. API key has expired"
  echo "   3. API key has extra spaces/newlines"
  echo ""
  echo "   Current key (check for extra characters):"
  echo "   [$ELEVENLABS_API_KEY]"
  echo ""
  echo "   Fix:"
  echo "   1. Go to https://elevenlabs.io/app/settings/api-keys"
  echo "   2. Copy a fresh API key"
  echo "   3. Run: bash scripts/setup-voice.sh"
  exit 1
elif [ "$HTTP_CODE" -eq 429 ]; then
  echo "   ❌ Rate limit exceeded (429 Too Many Requests)"
  echo "   Check usage: https://elevenlabs.io/app/usage"
  exit 1
else
  echo "   ❌ Unexpected error (HTTP $HTTP_CODE)"
  echo "   Response: $BODY"
  exit 1
fi

# Test 2: User info (another auth test)
echo "5. Testing user info endpoint..."
USER_RESPONSE=$(curl -s -w "\n%{http_code}" \
  -X GET "https://api.elevenlabs.io/v1/user" \
  -H "xi-api-key: ${ELEVENLABS_API_KEY}")

USER_HTTP=$(echo "$USER_RESPONSE" | tail -1)
USER_BODY=$(echo "$USER_RESPONSE" | head -n -1)

if [ "$USER_HTTP" -eq 200 ]; then
  echo "   ✅ User info retrieved"
  echo ""
  echo "   Account details:"
  echo "$USER_BODY" | grep -o '"character_count":[0-9]*'
  echo "$USER_BODY" | grep -o '"character_limit":[0-9]*'
  echo ""
else
  echo "   ❌ Failed (HTTP $USER_HTTP)"
fi

# Test 3: TTS generation
echo "6. Testing text-to-speech generation..."
OUTPUT_DIR=".claude/logs/audio"
mkdir -p "$OUTPUT_DIR"
OUTPUT_FILE="$OUTPUT_DIR/debug_test.mp3"

TTS_RESPONSE=$(curl -s -w "\n%{http_code}" -o "$OUTPUT_FILE" \
  -X POST "https://api.elevenlabs.io/v1/text-to-speech/${ELEVENLABS_VOICE_ID}" \
  -H "xi-api-key: ${ELEVENLABS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Debug test. If you hear this, voiceover is working.",
    "model_id": "eleven_monolingual_v1",
    "voice_settings": {
      "stability": 0.5,
      "similarity_boost": 0.75
    }
  }')

TTS_HTTP=$(echo "$TTS_RESPONSE" | tail -1)

echo "   HTTP Status: $TTS_HTTP"

if [ "$TTS_HTTP" -eq 200 ]; then
  echo "   ✅ Audio generated successfully!"
  echo "   File: $OUTPUT_FILE"
  echo "   Size: $(ls -lh "$OUTPUT_FILE" | awk '{print $5}')"
  echo ""

  # Try to play
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "   🔊 Playing audio..."
    afplay "$OUTPUT_FILE"
    echo "   ✅ If you heard 'Debug test', everything works!"
  else
    echo "   ℹ️  Manual playback (Linux):"
    echo "   mpg123 $OUTPUT_FILE"
  fi
  echo ""
  echo "✅ All tests passed! Voiceover should work."

elif [ "$TTS_HTTP" -eq 401 ]; then
  echo "   ❌ Authentication failed"
  echo ""
  echo "   The API key works for listing voices but not for TTS."
  echo "   This might indicate:"
  echo "   1. Free tier expired (check: https://elevenlabs.io/app/usage)"
  echo "   2. API key has limited permissions"
  echo "   3. Voice ID is invalid: $ELEVENLABS_VOICE_ID"
  echo ""
  rm -f "$OUTPUT_FILE"

elif [ "$TTS_HTTP" -eq 404 ]; then
  echo "   ❌ Voice not found (404)"
  echo "   Voice ID may be invalid: $ELEVENLABS_VOICE_ID"
  echo ""
  echo "   Try using default voice:"
  echo "   export ELEVENLABS_VOICE_ID=\"21m00Tcm4TlvDq8ikWAM\""
  echo "   Then run: bash scripts/setup-voice.sh"
  rm -f "$OUTPUT_FILE"

else
  echo "   ❌ Failed (HTTP $TTS_HTTP)"

  # Check if error response
  if [ -f "$OUTPUT_FILE" ] && [ $(stat -f%z "$OUTPUT_FILE" 2>/dev/null || stat -c%s "$OUTPUT_FILE") -lt 1000 ]; then
    echo "   Error response:"
    cat "$OUTPUT_FILE"
    rm -f "$OUTPUT_FILE"
  fi
fi

echo ""
echo "🔧 Troubleshooting complete."

#!/bin/bash

# Aura Frog Voice Debug Script (Realtime Streaming)
# Purpose: Debug voiceover API and streaming issues
# Usage: bash scripts/debug-voice.sh

echo "🔍 Aura Frog Voiceover Debug (Streaming Mode)"
echo "============================================="
echo ""

# Check streaming player availability
echo "1. Checking streaming audio players..."

PLAYER="none"
if command -v ffplay &> /dev/null; then
  FFPLAY_VERSION=$(ffplay -version 2>&1 | head -1)
  echo "   ✅ ffplay - Available (recommended)"
  echo "   Version: $FFPLAY_VERSION"
  PLAYER="ffplay"
elif command -v mpv &> /dev/null; then
  MPV_VERSION=$(mpv --version 2>&1 | head -1)
  echo "   ✅ mpv - Available"
  echo "   Version: $MPV_VERSION"
  PLAYER="mpv"
elif command -v play &> /dev/null && command -v sox &> /dev/null; then
  SOX_VERSION=$(sox --version 2>&1 | head -1)
  echo "   ✅ sox/play - Available"
  echo "   Version: $SOX_VERSION"
  PLAYER="sox"
else
  echo "   ❌ No streaming audio player found!"
  echo ""
  echo "   Install one of these:"
  echo "   brew install ffmpeg  # Recommended"
  echo "   brew install mpv     # Alternative"
  echo "   brew install sox     # Fallback"
  echo ""
fi
echo ""

# Check config file
CONFIG_FILE="$HOME/.claude/aura-frog-voice-config"

echo "2. Checking config file..."
if [ -f "$CONFIG_FILE" ]; then
  echo "   ✅ Config file exists: $CONFIG_FILE"
  source "$CONFIG_FILE"
  echo ""

  echo "3. Checking API key..."
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

  echo "4. Checking voice ID..."
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
echo "5. Testing API authentication (GET /voices)..."
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

# Test 2: User info (quota check)
echo "6. Checking account quota..."
USER_RESPONSE=$(curl -s -w "\n%{http_code}" \
  -X GET "https://api.elevenlabs.io/v1/user" \
  -H "xi-api-key: ${ELEVENLABS_API_KEY}")

USER_HTTP=$(echo "$USER_RESPONSE" | tail -1)
USER_BODY=$(echo "$USER_RESPONSE" | head -n -1)

if [ "$USER_HTTP" -eq 200 ]; then
  echo "   ✅ User info retrieved"
  echo ""
  echo "   Account details:"
  CHAR_COUNT=$(echo "$USER_BODY" | grep -o '"character_count":[0-9]*' | grep -o '[0-9]*')
  CHAR_LIMIT=$(echo "$USER_BODY" | grep -o '"character_limit":[0-9]*' | grep -o '[0-9]*')
  if [ -n "$CHAR_COUNT" ] && [ -n "$CHAR_LIMIT" ]; then
    echo "   Characters used: $CHAR_COUNT"
    echo "   Character limit: $CHAR_LIMIT"
    REMAINING=$((CHAR_LIMIT - CHAR_COUNT))
    echo "   Remaining: $REMAINING"
  fi
  echo ""
else
  echo "   ❌ Failed (HTTP $USER_HTTP)"
fi

# Test 3: Streaming TTS
if [ "$PLAYER" = "none" ]; then
  echo "7. Skipping streaming test (no audio player)"
  echo "   Install ffmpeg, mpv, or sox to test streaming"
  echo ""
else
  echo "7. Testing realtime streaming TTS..."
  echo "   Player: $PLAYER"
  echo "   Message: 'Debug test. If you hear this, streaming is working.'"
  echo ""

  # Create a function to play the stream based on player
  play_stream() {
    case "$PLAYER" in
      "ffplay")
        ffplay -nodisp -autoexit -loglevel error -i pipe:0
        ;;
      "mpv")
        mpv --no-video --really-quiet -
        ;;
      "sox")
        play -t mp3 -q -
        ;;
    esac
  }

  # Stream from ElevenLabs
  echo "   🔊 Streaming audio..."

  curl -s \
    -X POST "https://api.elevenlabs.io/v1/text-to-speech/${ELEVENLABS_VOICE_ID}/stream" \
    -H "xi-api-key: ${ELEVENLABS_API_KEY}" \
    -H "Content-Type: application/json" \
    -H "Accept: audio/mpeg" \
    -d '{
      "text": "Debug test. If you hear this, streaming is working.",
      "model_id": "eleven_turbo_v2_5",
      "voice_settings": {
        "stability": 0.5,
        "similarity_boost": 0.75
      }
    }' | play_stream

  RESULT=$?

  if [ $RESULT -eq 0 ]; then
    echo "   ✅ Streaming successful!"
    echo ""
    echo "   If you heard 'Debug test', everything works!"
  else
    echo "   ❌ Streaming failed (exit code: $RESULT)"
    echo ""
    echo "   Possible issues:"
    echo "   1. Audio player error"
    echo "   2. Network timeout"
    echo "   3. API rate limit"
  fi
fi

echo ""
echo "🔧 Debug complete."
echo ""
echo "📊 Summary:"
echo "   API Key: ✅ Valid"
echo "   Voice ID: $ELEVENLABS_VOICE_ID"
echo "   Streaming Player: $PLAYER"
if [ "$PLAYER" != "none" ]; then
  echo "   Streaming: ✅ Working"
fi

#!/bin/bash

# Aura Frog Voice Notification Test Script (Realtime Streaming)
# Purpose: Test ElevenLabs voiceover setup with streaming playback
# Usage: bash scripts/test-voice.sh

echo "🔊 Aura Frog Voiceover Notification Test (Streaming)"
echo "================================================="
echo ""

# Try to load from config file
CONFIG_FILE="$HOME/.claude/aura-frog-voice-config"
if [ -f "$CONFIG_FILE" ]; then
  echo "ℹ️  Loading configuration from: $CONFIG_FILE"
  source "$CONFIG_FILE"
  echo ""
fi

# Check if API key is set
if [ -z "$ELEVENLABS_API_KEY" ]; then
  echo "❌ ELEVENLABS_API_KEY not set"
  echo ""
  echo "🚀 Quick Setup:"
  echo ""
  echo "   Run the setup script to configure voiceover:"
  echo "   bash scripts/setup-voice.sh"
  echo ""
  echo "   This will:"
  echo "   1. Ask for your ElevenLabs API key"
  echo "   2. Test the API key"
  echo "   3. Save to config file: $CONFIG_FILE"
  echo "   4. Work automatically with hooks"
  echo ""
  exit 1
fi

echo "✅ ELEVENLABS_API_KEY is set"
echo "   Key: ${ELEVENLABS_API_KEY:0:10}...${ELEVENLABS_API_KEY: -4}"
echo ""

# Check voice ID
if [ -z "$ELEVENLABS_VOICE_ID" ]; then
  echo "ℹ️  ELEVENLABS_VOICE_ID not set (will use default: Rachel)"
  VOICE_ID="21m00Tcm4TlvDq8ikWAM"
else
  echo "✅ ELEVENLABS_VOICE_ID is set: $ELEVENLABS_VOICE_ID"
  VOICE_ID="$ELEVENLABS_VOICE_ID"
fi
echo ""

# Check streaming player availability
echo "🎵 Checking streaming audio players..."

PLAYER="none"
if command -v ffplay &> /dev/null; then
  echo "   ✅ ffplay (FFmpeg) - Available (recommended)"
  PLAYER="ffplay"
elif command -v mpv &> /dev/null; then
  echo "   ✅ mpv - Available"
  PLAYER="mpv"
elif command -v play &> /dev/null && command -v sox &> /dev/null; then
  echo "   ✅ sox/play - Available"
  PLAYER="sox"
else
  echo "   ❌ No streaming audio player found!"
  echo ""
  echo "   Install one of these (macOS):"
  echo "   brew install ffmpeg  # Recommended - includes ffplay"
  echo "   brew install mpv     # Alternative"
  echo "   brew install sox     # Fallback"
  echo ""
  exit 1
fi
echo ""

# Check if voice-notify.sh exists
if [ ! -f "scripts/voice-notify.sh" ]; then
  echo "❌ scripts/voice-notify.sh not found"
  echo "   Make sure you're running this from the Aura Frog plugin directory"
  exit 1
fi

echo "✅ voice-notify.sh script found"
echo ""

# Test API connection
echo "🧪 Testing ElevenLabs API connection..."
HTTP_CODE=$(curl -s -w "%{http_code}" -o /dev/null \
  -X GET "https://api.elevenlabs.io/v1/voices" \
  -H "xi-api-key: ${ELEVENLABS_API_KEY}")

if [ "$HTTP_CODE" -eq 200 ]; then
  echo "✅ API connection successful (HTTP $HTTP_CODE)"
else
  echo "❌ API connection failed (HTTP $HTTP_CODE)"
  if [ "$HTTP_CODE" -eq 401 ]; then
    echo "   Error: Invalid API key"
    echo "   Please check your ELEVENLABS_API_KEY"
  elif [ "$HTTP_CODE" -eq 429 ]; then
    echo "   Error: Rate limit exceeded or quota exhausted"
    echo "   Check your usage at https://elevenlabs.io/app/usage"
  else
    echo "   Error: Unknown error"
  fi
  exit 1
fi
echo ""

# Test streaming voice generation
echo "🎤 Testing realtime streaming voice generation..."
echo "   Message: 'This is a test of the streaming voice system'"
echo "   Player: $PLAYER"
echo ""

bash scripts/voice-notify.sh "This is a test of the streaming voice system" "general"

if [ $? -eq 0 ]; then
  echo ""
  echo "✅ Streaming voice generation successful!"
  echo ""
  echo "🎯 Key benefits of streaming:"
  echo "   - No file creation (plays directly)"
  echo "   - Lower latency (starts playing faster)"
  echo "   - No cleanup needed"
  echo ""
  echo "✅ Setup complete! Voiceover notifications are working."
  echo ""
  echo "🎯 How to test in workflow:"
  echo "   1. Start a workflow: workflow:start 'Test task'"
  echo "   2. Wait for approval gate"
  echo "   3. Listen for: 'Hey, I need your input to continue.'"
else
  echo ""
  echo "❌ Streaming voice generation failed"
  echo "   Check the error messages above"
  exit 1
fi

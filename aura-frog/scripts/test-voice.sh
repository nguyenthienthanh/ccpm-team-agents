#!/bin/bash

# Aura Frog Voice Notification Test Script
# Purpose: Test ElevenLabs voiceover setup
# Usage: bash scripts/test-voice.sh

echo "🔊 Aura Frog Voiceover Notification Test"
echo "===================================="
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

# Test voice generation
echo "🎤 Testing voice generation..."
echo "   Message: 'This is a test notification'"
echo ""

bash scripts/voice-notify.sh "This is a test notification" "general"

if [ $? -eq 0 ]; then
  echo ""
  echo "✅ Voice generation successful!"
  echo ""
  echo "📁 Audio file saved to: .claude/logs/audio/"
  echo "   Latest file:"
  ls -lt .claude/logs/audio/*.mp3 | head -1
  echo ""

  # Check if audio played
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🔊 Audio should have played automatically (macOS afplay)"
    echo ""
    echo "   If you didn't hear anything:"
    echo "   1. Check your system volume"
    echo "   2. Try playing manually:"
    echo "      afplay .claude/logs/audio/general_*.mp3"
  else
    echo "ℹ️  Auto-play is macOS only"
    echo "   To play audio on Linux:"
    echo "      mpg123 .claude/logs/audio/general_*.mp3"
    echo "   To play audio on Windows:"
    echo "      start .claude\\logs\\audio\\general_*.mp3"
  fi
  echo ""
  echo "✅ Setup complete! Voiceover notifications are working."
  echo ""
  echo "🎯 How to test in workflow:"
  echo "   1. Start a workflow: workflow:start 'Test task'"
  echo "   2. Wait for approval gate"
  echo "   3. Listen for: 'Your attention is needed. Your approval is required to continue.'"
else
  echo ""
  echo "❌ Voice generation failed"
  echo "   Check the error messages above"
  exit 1
fi

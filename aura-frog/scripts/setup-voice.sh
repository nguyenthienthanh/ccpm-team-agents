#!/bin/bash

# Aura Frog Voice Notification Setup Script (Realtime Streaming)
# Purpose: Configure ElevenLabs API for realtime streaming voiceover notifications
# Usage: bash scripts/setup-voice.sh

echo "🔊 Aura Frog Voiceover Notification Setup (Streaming)"
echo "=================================================="
echo ""

# Check streaming player availability first
echo "📋 Step 0: Checking streaming audio player..."
echo ""

PLAYER="none"
if command -v ffplay &> /dev/null; then
  echo "   ✅ ffplay (FFmpeg) - Found (recommended)"
  PLAYER="ffplay"
elif command -v mpv &> /dev/null; then
  echo "   ✅ mpv - Found"
  PLAYER="mpv"
elif command -v play &> /dev/null && command -v sox &> /dev/null; then
  echo "   ✅ sox/play - Found"
  PLAYER="sox"
else
  echo "   ⚠️  No streaming audio player found!"
  echo ""
  echo "   Aura Frog uses realtime streaming (no file creation)."
  echo "   Please install one of these players first:"
  echo ""
  echo "   macOS (via Homebrew):"
  echo "   brew install ffmpeg  # Recommended - includes ffplay"
  echo "   brew install mpv     # Alternative"
  echo "   brew install sox     # Fallback"
  echo ""
  echo "   Linux (Debian/Ubuntu):"
  echo "   sudo apt install ffmpeg  # Recommended"
  echo "   sudo apt install mpv     # Alternative"
  echo ""
  read -p "Continue without audio player? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Setup cancelled. Install a player first."
    exit 1
  fi
fi
echo ""

# Check if already configured
CONFIG_FILE="$HOME/.claude/aura-frog-voice-config"

if [ -f "$CONFIG_FILE" ]; then
  echo "ℹ️  Configuration file already exists: $CONFIG_FILE"
  echo ""
  source "$CONFIG_FILE"

  if [ -n "$ELEVENLABS_API_KEY" ]; then
    echo "✅ API Key: ${ELEVENLABS_API_KEY:0:10}...${ELEVENLABS_API_KEY: -4}"
  fi

  if [ -n "$ELEVENLABS_VOICE_ID" ]; then
    echo "✅ Voice ID: $ELEVENLABS_VOICE_ID"
  fi

  echo ""
  read -p "Do you want to reconfigure? (y/N) " -n 1 -r
  echo

  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Setup cancelled."
    exit 0
  fi
  echo ""
fi

# Get API Key
echo "📋 Step 1: ElevenLabs API Key"
echo ""
echo "   Sign up at: https://elevenlabs.io"
echo "   Get API key: https://elevenlabs.io/app/settings/api-keys"
echo ""

read -p "Enter your ElevenLabs API Key: " api_key

if [ -z "$api_key" ]; then
  echo "❌ API key is required"
  exit 1
fi

# Test API key
echo ""
echo "🧪 Testing API key..."

HTTP_CODE=$(curl -s -w "%{http_code}" -o /dev/null \
  -X GET "https://api.elevenlabs.io/v1/voices" \
  -H "xi-api-key: ${api_key}")

if [ "$HTTP_CODE" -ne 200 ]; then
  echo "❌ API key test failed (HTTP $HTTP_CODE)"

  if [ "$HTTP_CODE" -eq 401 ]; then
    echo "   Error: Invalid API key"
  elif [ "$HTTP_CODE" -eq 429 ]; then
    echo "   Error: Rate limit exceeded"
  fi

  exit 1
fi

echo "✅ API key is valid!"
echo ""

# Get Voice ID (optional)
echo "📋 Step 2: Voice Selection (Optional)"
echo ""
echo "   Press Enter for default voice (Rachel)"
echo "   Or enter a custom voice ID from: https://elevenlabs.io/voice-library"
echo ""
echo "   Popular voices:"
echo "   - 21m00Tcm4TlvDq8ikWAM (Rachel - calm, professional)"
echo "   - EXAVITQu4vr4xnSDxMaL (Bella - warm, friendly)"
echo "   - ErXwobaYiN019PkySvjV (Antoni - deep, authoritative)"
echo "   - MF3mGyEYCl7XYWbV9V6O (Elli - energetic, youthful)"
echo "   - TxGEqnHWrfWFTfGW9XjX (Josh - clear, articulate)"
echo ""

read -p "Enter Voice ID (or press Enter for default): " voice_id

if [ -z "$voice_id" ]; then
  voice_id="21m00Tcm4TlvDq8ikWAM"
  echo "Using default voice: Rachel"
fi

# Create config directory if needed
mkdir -p "$(dirname "$CONFIG_FILE")"

# Create config file
echo ""
echo "💾 Saving configuration..."

cat > "$CONFIG_FILE" <<EOF
# Aura Frog Voice Notification Configuration (Streaming Mode)
# This file is sourced by voice-notify.sh for hook execution
# Location: $CONFIG_FILE
# Mode: Realtime streaming (no file creation)

export ELEVENLABS_API_KEY="$api_key"
export ELEVENLABS_VOICE_ID="$voice_id"
EOF

chmod 600 "$CONFIG_FILE"  # Secure permissions (only owner can read/write)

echo "✅ Configuration saved to: $CONFIG_FILE"
echo ""

# Test streaming voice generation
if [ "$PLAYER" != "none" ]; then
  echo "🎤 Testing realtime streaming voice generation..."
  echo ""

  cd "$(dirname "$0")/.."
  bash scripts/voice-notify.sh "Setup complete. Streaming voice notifications are now active." "completion"

  if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Setup complete!"
    echo ""
    echo "🎯 Streaming mode benefits:"
    echo "   ✅ No file creation (audio plays directly)"
    echo "   ✅ Lower latency (starts immediately)"
    echo "   ✅ No cleanup needed"
    echo ""
    echo "🎯 Voiceover notifications will now play when:"
    echo "   1. Workflow reaches an approval gate"
    echo "   2. Critical errors occur"
    echo ""
    echo "📝 Configuration file: $CONFIG_FILE"
    echo "🔧 To reconfigure: bash scripts/setup-voice.sh"
    echo "🧪 To test: bash scripts/test-voice.sh"
    echo ""
    echo "🔊 If you heard the voice, setup is successful!"
  else
    echo ""
    echo "⚠️  Setup saved but streaming test failed"
    echo "   Configuration is correct, but streaming had an issue"
    echo "   Try running: bash scripts/test-voice.sh"
  fi
else
  echo ""
  echo "✅ Configuration saved!"
  echo ""
  echo "⚠️  No audio player installed - skipping test"
  echo "   Install ffmpeg, mpv, or sox to enable streaming playback"
  echo ""
  echo "📝 Configuration file: $CONFIG_FILE"
fi

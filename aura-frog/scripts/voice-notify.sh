#!/bin/bash

# Aura Frog Voice Notification Script (Realtime Streaming)
# Purpose: Generate and play voiceover in realtime using ElevenLabs streaming API
# Usage: bash scripts/voice-notify.sh "Your attention is needed" "approval-gate"

set -e

# Try to load from config file first (for hooks), then environment
CONFIG_FILE="$HOME/.claude/aura-frog-voice-config"
if [ -f "$CONFIG_FILE" ]; then
  source "$CONFIG_FILE"
fi

# Configuration
VOICE_ID="${ELEVENLABS_VOICE_ID:-21m00Tcm4TlvDq8ikWAM}"  # Default: Rachel
API_KEY="${ELEVENLABS_API_KEY}"
NOTIFICATION_TYPE="${2:-general}"

# Message
MESSAGE="${1:-Your attention is needed for approval}"

# Check if ElevenLabs is configured
if [ -z "$API_KEY" ]; then
  echo "⚠️ ElevenLabs not configured. Skipping voiceover." >&2
  echo "Set ELEVENLABS_API_KEY in .envrc to enable voice notifications." >&2
  exit 0  # Don't fail, just skip
fi

# Prepare message based on notification type
case "$NOTIFICATION_TYPE" in
  "approval-gate")
    # Use context message if provided, otherwise generic
    if [ -n "$MESSAGE" ] && [ "$MESSAGE" != "Your attention is needed for approval" ]; then
      FULL_MESSAGE="Hey, $MESSAGE"
    else
      FULL_MESSAGE="Hey, I need your input to continue."
    fi
    ;;
  "error")
    FULL_MESSAGE="Heads up, something went wrong. Check the error when you can."
    ;;
  "warning")
    FULL_MESSAGE="Just a heads up, you might want to check this."
    ;;
  "completion")
    FULL_MESSAGE="All done! Task completed successfully."
    ;;
  *)
    FULL_MESSAGE="$MESSAGE"
    ;;
esac

# Function to detect available audio player for streaming
detect_player() {
  if command -v ffplay &> /dev/null; then
    echo "ffplay"
  elif command -v mpv &> /dev/null; then
    echo "mpv"
  elif command -v sox &> /dev/null && command -v play &> /dev/null; then
    echo "sox"
  else
    echo "none"
  fi
}

# Function to play audio stream
play_stream() {
  local player="$1"

  case "$player" in
    "ffplay")
      # FFplay from FFmpeg - best option, supports stdin streaming
      ffplay -nodisp -autoexit -loglevel error -i pipe:0
      ;;
    "mpv")
      # MPV - another excellent option
      mpv --no-video --really-quiet -
      ;;
    "sox")
      # Sox/Play - fallback
      play -t mp3 -q -
      ;;
    *)
      return 1
      ;;
  esac
}

# Detect player
PLAYER=$(detect_player)

if [ "$PLAYER" = "none" ]; then
  echo "⚠️ No streaming audio player found. Install ffmpeg, mpv, or sox." >&2
  echo "   brew install ffmpeg  # Recommended" >&2
  echo "   brew install mpv     # Alternative" >&2
  exit 0  # Don't fail, just skip
fi

# Stream and play audio using ElevenLabs streaming API
echo "🔊 Streaming voiceover..." >&2

# Use the streaming endpoint for lower latency
curl -s \
  -X POST "https://api.elevenlabs.io/v1/text-to-speech/${VOICE_ID}/stream" \
  -H "xi-api-key: ${API_KEY}" \
  -H "Content-Type: application/json" \
  -H "Accept: audio/mpeg" \
  -d "{
    \"text\": \"${FULL_MESSAGE}\",
    \"model_id\": \"eleven_turbo_v2_5\",
    \"voice_settings\": {
      \"stability\": 0.5,
      \"similarity_boost\": 0.75,
      \"style\": 0.0,
      \"use_speaker_boost\": true
    }
  }" | play_stream "$PLAYER"

RESULT=$?

if [ $RESULT -eq 0 ]; then
  echo "✅ Voiceover complete" >&2
  exit 0
else
  echo "❌ Failed to stream voiceover" >&2
  exit 0  # Don't fail the workflow
fi

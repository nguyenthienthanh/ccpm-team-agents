# Voiceover Notifications System (Streaming Mode)

**Version:** 1.0.0
**Mode:** Realtime Streaming
**Purpose:** Automatic voice notifications for approval gates and critical events
**Last Updated:** 2025-11-29

---

## Overview

Aura Frog includes **automatic voiceover notifications** using realtime streaming that alert you when your action is required during workflows. Audio plays directly without creating files.

**Key Benefits:**
- No file creation (zero disk usage)
- Lower latency (starts playing immediately)
- No cleanup needed
- Never miss an approval gate

---

## Features

### Automatic Notifications

**1. Approval Gates (Stop Hook) - Context-Aware!**
- Triggers when Claude stops for approval
- **Intelligently reads conversation context**
- Streams audio directly to speakers
- Happens at every phase completion

**Example Messages:**
- Generic: "Hey, I need your input to continue."
- Phase 2: "Hey, Phase 2 - Design deliverables ready for review"
- Tests: "Hey, All tests passed - review needed"
- Code Review: "Hey, Code review complete - approval needed"

**2. Critical Errors (Notification Hook)**
- Triggers on errors, failures, critical issues
- Streams audio: "Heads up, something went wrong."
- Helps catch problems immediately

---

## Setup

### Prerequisites

**Required:**
- Streaming audio player (ffplay, mpv, or sox)
- ElevenLabs API account (free tier available)
- API key from https://elevenlabs.io/app/settings/api-keys

### Install Streaming Player

**macOS:**
```bash
brew install ffmpeg  # Recommended - includes ffplay
```

**Linux:**
```bash
sudo apt install ffmpeg
```

### Quick Setup

**Run the setup script:**
```bash
cd ~/.claude/plugins/marketplaces/aurafrog/aura-frog
bash scripts/setup-voice.sh
```

**What it does:**
1. Checks for streaming audio player
2. Asks for your ElevenLabs API key
3. Tests the API key
4. Saves configuration to `~/.claude/aura-frog-voice-config`
5. Tests streaming playback

**That's it!** Voiceover notifications will now work automatically.

---

## How It Works

### Streaming Architecture

```
Workflow Phase Completes
  ↓
Claude shows approval gate
  ↓
Claude stops (waits for user input)
  ↓
Stop hook triggers automatically
  ↓
hooks/stop-voice-notify.sh is executed
  ↓
Read conversation transcript (JSON)
  ↓
Extract context (phase, deliverables, status)
  ↓
Summarize to under 15 words
  ↓
Call scripts/voice-notify.sh with context
  ↓
curl streams from ElevenLabs /stream endpoint
  ↓
Audio piped directly to ffplay/mpv/sox
  ↓
User hears: "Hey, Phase 2 - Design deliverables ready"
  ↓
No files created - streaming complete
```

### Context Extraction Examples

**Transcript contains:** `"Phase 2: Design - Technical Architecture..."`
**Voiceover says:** "Hey, Phase 2 - Design deliverables ready for review"

**Transcript contains:** `"All tests pass. Ready for review"`
**Voiceover says:** "Hey, All tests passed - review needed"

**No specific context found:**
**Voiceover says:** "Hey, I need your input to continue."

---

## Script Reference

### stop-voice-notify.sh

**Location:** `hooks/stop-voice-notify.sh`

**Purpose:** Context-aware hook that extracts approval context from conversation

**How It Works:**
1. Reads conversation transcript JSON from stdin
2. Extracts last assistant message
3. Parses phase information, deliverables, status
4. Summarizes to under 15 words
5. Calls `voice-notify.sh` with context

**Context Patterns Detected:**
- Phase numbers: `Phase 2`, `Phase 5a`, etc.
- Deliverables: `design`, `test plan`, `requirements`
- Test status: `tests pass`, `tests fail`
- Code review: `code review complete`

### voice-notify.sh

**Location:** `scripts/voice-notify.sh`

**Usage:**
```bash
bash scripts/voice-notify.sh "Context message" "notification-type"
```

**Notification Types:**
- `approval-gate` - For approval gates
- `error` - For errors and failures
- `warning` - For warnings
- `completion` - For successful completions
- `general` - Generic notifications

**Examples:**
```bash
# Approval notification (generic)
bash scripts/voice-notify.sh "" "approval-gate"
# → "Hey, I need your input to continue."

# Approval with context
bash scripts/voice-notify.sh "Phase 2 approval needed" "approval-gate"
# → "Hey, Phase 2 approval needed"

# Error notification
bash scripts/voice-notify.sh "" "error"
# → "Heads up, something went wrong."

# Completion notification
bash scripts/voice-notify.sh "" "completion"
# → "All done! Task completed successfully."
```

---

## Customization

### Change Voice

**Re-run setup:**
```bash
bash scripts/setup-voice.sh
```

**Or edit config directly:**
```bash
nano ~/.claude/aura-frog-voice-config
```

**Available Voices:**
```bash
# Rachel (default) - Calm, professional
export ELEVENLABS_VOICE_ID="21m00Tcm4TlvDq8ikWAM"

# Bella - Warm, friendly
export ELEVENLABS_VOICE_ID="EXAVITQu4vr4xnSDxMaL"

# Antoni - Deep, authoritative
export ELEVENLABS_VOICE_ID="ErXwobaYiN019PkySvjV"

# Elli - Energetic, youthful
export ELEVENLABS_VOICE_ID="MF3mGyEYCl7XYWbV9V6O"

# Josh - Clear, articulate
export ELEVENLABS_VOICE_ID="TxGEqnHWrfWFTfGW9XjX"
```

**Browse more voices:** https://elevenlabs.io/voice-library

### Custom Messages

Edit `scripts/voice-notify.sh` case statement:

```bash
case "$NOTIFICATION_TYPE" in
  "approval-gate")
    FULL_MESSAGE="Hey, I need your input to continue."
    ;;
  "error")
    FULL_MESSAGE="Heads up, something went wrong."
    ;;
  "custom-type")
    FULL_MESSAGE="Your custom message here."
    ;;
esac
```

**Tips for natural voiceover:**
- Keep it short (under 10 words)
- Use conversational language
- Be friendly and casual

---

## Disable Voiceover

### Temporarily Disable

```bash
# Rename config file
mv ~/.claude/aura-frog-voice-config ~/.claude/aura-frog-voice-config.bak

# Script will gracefully skip if no config
```

### Permanently Disable

Edit `hooks/hooks.json`, remove Stop hook section.

---

## Troubleshooting

### Issue: No audio plays

**Check 1: Streaming player installed**
```bash
which ffplay mpv play
```

**Check 2: API key configured**
```bash
cat ~/.claude/aura-frog-voice-config
```

**Check 3: Test streaming**
```bash
bash scripts/test-voice.sh
```

### Issue: "No streaming audio player found"

```bash
# Install ffmpeg (includes ffplay)
brew install ffmpeg  # macOS
sudo apt install ffmpeg  # Linux

# Verify
ffplay -version
```

### Issue: "API key not configured"

```bash
# Run setup script
bash scripts/setup-voice.sh
```

### Issue: Script fails but workflow continues

**Expected behavior!** Voice notifications are non-blocking:
- Script uses `|| true` to never fail workflows
- If ElevenLabs unavailable, workflow continues silently

### Debug Mode

Run full diagnostics:
```bash
bash scripts/debug-voice.sh
```

---

## Use Cases

### 1. Multi-tasking Development
- Start workflow
- Work on other tasks
- Hear notification when approval needed
- Return to approve

### 2. Accessibility
- Vision-impaired developers
- Audio-first workflow
- Hands-free development

### 3. Long-running Workflows
- Phase 1-4 planning takes time
- Get notified when ready for Phase 5
- No need to watch screen constantly

### 4. Team Notifications
- Pair programming
- One person codes, other reviews
- Audio alerts both people

---

## API Usage & Cost

### ElevenLabs Free Tier
- **10,000 characters/month** free
- Each notification ~ 50 characters
- ~ **200 notifications/month** free

### Paid Plans
- **Starter:** $5/month - 30,000 characters
- **Creator:** $22/month - 100,000 characters
- **Professional:** $99/month - 500,000 characters

**Learn more:** https://elevenlabs.io/pricing

---

## Related Documentation

- **Setup Guide:** `VOICEOVER_SETUP.md`
- **Voice Operations Agent:** `agents/voice-operations.md`
- **Integration Guide:** `docs/guides/elevenlabs-integration.md`
- **Hooks System:** `hooks/README.md`

---

## Future Enhancements

**Planned Features:**
- Different voices per notification type
- Volume control
- Notification preferences
- Multi-language support
- Voice command responses

---

**Version:** 1.0.0
**Mode:** Realtime Streaming
**Last Updated:** 2025-11-29
**Status:** Active - Works with ElevenLabs API key

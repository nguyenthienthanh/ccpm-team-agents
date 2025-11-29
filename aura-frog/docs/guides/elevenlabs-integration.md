# ElevenLabs AI Integration Guide (Streaming Mode)

**Version:** 1.0.0
**Mode:** Realtime Streaming
**Last Updated:** 2025-11-29
**Purpose:** Setup and use ElevenLabs AI voice streaming in Aura Frog workflows

---

## Overview

This guide will help you integrate ElevenLabs AI text-to-speech capabilities into your Aura Frog workflow system using **realtime streaming** - audio plays directly without creating files.

**Key Benefits of Streaming:**
- No file creation (zero disk usage)
- Lower latency (starts playing immediately)
- No cleanup needed
- Simpler architecture

---

## Prerequisites

### Required
- ElevenLabs account (free or paid)
- API key from ElevenLabs
- Streaming audio player (ffplay, mpv, or sox)
- Aura Frog installed

### Streaming Audio Player

**macOS (Homebrew):**
```bash
brew install ffmpeg  # Recommended - includes ffplay
brew install mpv     # Alternative
brew install sox     # Fallback
```

**Linux (Debian/Ubuntu):**
```bash
sudo apt install ffmpeg  # Recommended
sudo apt install mpv     # Alternative
```

**Verify installation:**
```bash
ffplay -version
# or
mpv --version
```

---

## Quick Start (5 Minutes)

### Step 1: Get ElevenLabs API Key

1. Go to [ElevenLabs](https://elevenlabs.io)
2. Sign up or log in
3. Navigate to **Settings** → **API Keys**
4. Click **Create API Key**
5. Copy the key (keep it secure!)

**Free Tier Includes:**
- 10,000 characters/month
- ~200 voice notifications
- Multilingual support

### Step 2: Run Setup Script

```bash
cd ~/.claude/plugins/marketplaces/aurafrog/aura-frog
bash scripts/setup-voice.sh
```

**The setup script will:**
1. Check for streaming audio player
2. Ask for your API key
3. Test the API key
4. Let you choose a voice
5. Save configuration
6. Test streaming playback

### Step 3: Test Voice Generation

```bash
bash scripts/test-voice.sh
```

**Expected Output:**
```
Aura Frog Voiceover Notification Test (Streaming)
=================================================

ELEVENLABS_API_KEY is set
Checking streaming audio players...
   ffplay (FFmpeg) - Available (recommended)

Testing realtime streaming voice generation...
Streaming voiceover...
Voiceover complete

Streaming voice generation successful!
```

**If successful, you're ready to use voice features!**

---

## How Streaming Works

### Architecture

```
User Action (approval gate)
  ↓
Stop hook triggers
  ↓
voice-notify.sh called
  ↓
curl streams from ElevenLabs /stream endpoint
  ↓
Audio piped directly to player (ffplay/mpv/sox)
  ↓
User hears notification
  ↓
No files created
```

### Streaming API Endpoint

```
POST https://api.elevenlabs.io/v1/text-to-speech/{voice_id}/stream
```

### Player Commands

**ffplay (recommended):**
```bash
curl ... | ffplay -nodisp -autoexit -loglevel error -i pipe:0
```

**mpv:**
```bash
curl ... | mpv --no-video --really-quiet -
```

**sox:**
```bash
curl ... | play -t mp3 -q -
```

---

## Using Voice Features

### Automatic Notifications

Once configured, voiceover automatically streams when:

1. **Approval Gates** - Phase completes, waiting for approval
   - Audio: "Hey, I need your input to continue."

2. **Critical Errors** - Errors occur during workflow
   - Audio: "Heads up, something went wrong."

**No commands needed** - completely automatic!

### Manual Voice Streaming

**Test streaming:**
```bash
bash scripts/voice-notify.sh "Test message" "general"
```

**Debug streaming:**
```bash
bash scripts/debug-voice.sh
```

---

## Voice Customization

### Available Voices

**Pre-made Voices (Most Popular):**

1. **Rachel** (21m00Tcm4TlvDq8ikWAM) - Default
   - Female, American accent
   - Calm, clear, professional

2. **Antoni** (ErXwobaYiN019PkySvjV)
   - Male, American accent
   - Well-rounded, versatile

3. **Bella** (EXAVITQu4vr4xnSDxMaL)
   - Female, American accent
   - Soft, gentle, soothing

4. **Josh** (TxGEqnHWrfWFTfGW9XjX)
   - Male, American accent
   - Deep, authoritative

5. **Elli** (MF3mGyEYCl7XYWbV9V6O)
   - Female, American accent
   - Energetic, youthful

**To change voice:**
```bash
# Re-run setup
bash scripts/setup-voice.sh

# Or edit config directly
nano ~/.claude/aura-frog-voice-config
```

### Voice Parameters

**Stability** (0-1):
- `0.0` - Very expressive, more variation
- `0.5` - Balanced (recommended)
- `1.0` - Very stable, consistent

**Similarity Boost** (0-1):
- `0.0` - Less like original voice
- `0.75` - Balanced (recommended)
- `1.0` - Very similar to original

### Emotional Tags

Add emotion to narration with inline tags:

```bash
bash scripts/voice-notify.sh "Great news [laughs]! Tests are passing." "general"
```

**Available Tags:**
- `[laughs]` - Light laughter
- `[sighs]` - Exhale/disappointment
- `[whispers]` - Quiet, soft tone
- `[clears throat]` - Throat clearing
- `[gasps]` - Surprise

---

## Multilingual Support

### Supported Languages (70+)

**Major Languages:**
- English (US, UK, Australian, Indian)
- Spanish (Spain, Mexico, Argentina)
- French, German, Italian
- Portuguese (Brazil, Portugal)
- Japanese, Korean, Chinese (Mandarin)
- Arabic, Hindi, Russian
- Vietnamese, Thai, Indonesian, Filipino

**Auto-detection:**
The voice model automatically detects the language from text.

---

## Configuration

### Config File Location

```
~/.claude/aura-frog-voice-config
```

### Config Contents

```bash
# Aura Frog Voice Notification Configuration (Streaming Mode)
export ELEVENLABS_API_KEY="your_api_key_here"
export ELEVENLABS_VOICE_ID="21m00Tcm4TlvDq8ikWAM"
```

### Model Used

- **Model:** `eleven_turbo_v2_5`
- **Optimized for:** Low latency streaming
- **Quality:** High quality, fast generation

---

## Security & Privacy

### Best Practices

**DO:**
- Store API keys in config file with restricted permissions
- Review text before narration
- Keep config file secure (chmod 600)

**DON'T:**
- Commit API keys to Git
- Narrate secrets, passwords, API keys
- Share your API key

### Data Handling

- Text is sent to ElevenLabs API for processing
- Audio is streamed back and played immediately
- **No audio files are stored** (streaming mode)
- No data stored on ElevenLabs servers after generation

---

## Usage Tracking & Limits

### Character Quota

ElevenLabs charges by character count.

**Check quota:**
```bash
bash scripts/debug-voice.sh
```

### Free Tier

- 10,000 characters/month
- ~50 characters per notification
- ~200 notifications/month free

### Paid Plans

- **Starter:** $5/month - 30,000 characters
- **Creator:** $11/month - 100,000 characters
- **Pro:** $99/month - 500,000 characters

---

## Troubleshooting

### "No streaming audio player found"

**Install ffmpeg:**
```bash
brew install ffmpeg  # macOS
sudo apt install ffmpeg  # Linux
```

### "API key not found"

```bash
# Check config file exists
cat ~/.claude/aura-frog-voice-config

# Re-run setup if needed
bash scripts/setup-voice.sh
```

### "Quota exceeded"

1. Check usage at https://elevenlabs.io/app/usage
2. Wait for monthly reset
3. Or upgrade plan

### "Audio sounds choppy"

- Check internet connection
- Try a different audio player:
  ```bash
  brew install mpv
  ```

### Debug Mode

Run full diagnostics:
```bash
bash scripts/debug-voice.sh
```

This checks:
1. Streaming player availability
2. Config file and API key
3. API authentication
4. Account quota
5. Realtime streaming test

---

## Reference

### API Documentation
- [ElevenLabs API Docs](https://elevenlabs.io/docs)
- [Streaming API](https://elevenlabs.io/docs/api-reference/text-to-speech-stream)
- [Voice Settings](https://elevenlabs.io/docs/speech-synthesis/voice-settings)

### Aura Frog Documentation
- [voice-operations Agent](./../../agents/voice-operations.md)
- [Voiceover Notifications](../VOICEOVER_NOTIFICATIONS.md)
- [Setup Guide](../../VOICEOVER_SETUP.md)

---

## Setup Checklist

- [ ] Streaming audio player installed (ffplay/mpv/sox)
- [ ] ElevenLabs account created
- [ ] API key obtained
- [ ] Setup script run: `bash scripts/setup-voice.sh`
- [ ] Test successful: `bash scripts/test-voice.sh`
- [ ] Heard test audio play

---

## Quick Reference Card

**Setup:**
```bash
bash scripts/setup-voice.sh
```

**Test:**
```bash
bash scripts/test-voice.sh
```

**Debug:**
```bash
bash scripts/debug-voice.sh
```

**Manual notification:**
```bash
bash scripts/voice-notify.sh "Message" "approval-gate"
```

**Config file:**
```
~/.claude/aura-frog-voice-config
```

---

**Last Updated:** 2025-11-29
**Version:** 1.0.0
**Mode:** Realtime Streaming

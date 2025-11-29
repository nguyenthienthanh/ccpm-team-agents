# Voice Commands Reference (Streaming Mode)

**Aura Frog Feature:** ElevenLabs AI Voice Operations
**Version:** 1.0.0
**Mode:** Realtime Streaming (no file creation)
**Last Updated:** 2025-11-29

---

## Quick Reference

### Essential Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `voice:test` | Test streaming voice | `voice:test` |
| `voice:narrate` | Stream text to speech | `voice:narrate "Hello world"` |
| `voice:settings` | View/edit settings | `voice:settings` |
| `voice:voices` | List available voices | `voice:voices` |

---

## How Streaming Works

Aura Frog uses **realtime streaming** for voice notifications:

1. Text is sent to ElevenLabs streaming API
2. Audio is piped directly to your audio player
3. **No files are created** - audio plays immediately
4. Lower latency than file-based approach

**Supported Players (priority order):**
- `ffplay` (FFmpeg) - Recommended
- `mpv` - Alternative
- `sox/play` - Fallback

---

## Detailed Command Reference

### voice:test

Test streaming voice generation.

**Usage:**
```
voice:test
```

**Output:**
```
Aura Frog Voiceover Notification Test (Streaming)
=================================================

ELEVENLABS_API_KEY is set
Checking streaming audio players...
   ffplay (FFmpeg) - Available (recommended)

Testing realtime streaming voice generation...
   Message: 'This is a test of the streaming voice system'
   Player: ffplay

Streaming voiceover...
Voiceover complete

Streaming voice generation successful!
```

**When to use:**
- After initial setup
- Testing configuration changes
- Verifying API key works

---

### voice:narrate

Stream text to speech directly.

**Usage:**
```
voice:narrate <text>
voice:narrate <text> --voice=<voice-id>
```

**Examples:**
```bash
# Basic narration (streams directly)
voice:narrate "The implementation is complete and all tests are passing."

# With specific voice
voice:narrate "This is important" --voice="Antoni"

# With emotion tags
voice:narrate "Great news [laughs]! The feature is done."

# Whisper effect
voice:narrate "This is [whispers] confidential information."
```

**Parameters:**
- `--voice=<id>` - Voice ID (default: Rachel)

**Note:** Audio streams directly to your speakers - no files are created.

---

### voice:settings

View voice settings and API status.

**Usage:**
```
voice:settings
```

**Output:**
```
ElevenLabs Voice Settings (Streaming Mode)

Configuration:
  Enabled: true
  Voice: Rachel (21m00Tcm4TlvDq8ikWAM)
  Model: eleven_turbo_v2_5
  Stability: 0.5
  Similarity: 0.75

Streaming:
  Mode: Realtime (no files created)
  Player: ffplay
  Latency: Low

API Status:
  API Key: Configured
  Connection: OK
  Character Quota: 85,432 / 100,000 (85%)

Actions:
- "voice:test" → Test streaming
- "voice:voices" → List voices
```

---

### voice:voices

List all available ElevenLabs voices.

**Usage:**
```
voice:voices
```

**Output:**
```
Available ElevenLabs Voices

Pre-made Voices:

  1. Rachel (21m00Tcm4TlvDq8ikWAM) - Default
     Gender: Female
     Accent: American
     Description: Calm, clear, professional

  2. Antoni (ErXwobaYiN019PkySvjV)
     Gender: Male
     Accent: American
     Description: Well-rounded, versatile

  3. Bella (EXAVITQu4vr4xnSDxMaL)
     Gender: Female
     Accent: American
     Description: Soft, gentle

  4. Josh (TxGEqnHWrfWFTfGW9XjX)
     Gender: Male
     Accent: American
     Description: Deep, authoritative

  5. Elli (MF3mGyEYCl7XYWbV9V6O)
     Gender: Female
     Accent: American
     Description: Energetic, youthful

To change voice:
1. Run: bash scripts/setup-voice.sh
2. Enter voice ID when prompted
```

---

## Emotional Tags

Add emotion and expression to narration.

### Available Tags

| Tag | Effect | Example |
|-----|--------|---------|
| `[laughs]` | Light laughter | `Great work [laughs]!` |
| `[sighs]` | Exhale/disappointment | `Unfortunately [sighs], we have a bug.` |
| `[whispers]` | Quiet, soft tone | `This is [whispers] confidential.` |
| `[clears throat]` | Throat clearing | `[clears throat] Let me explain.` |
| `[gasps]` | Surprise | `[gasps] Amazing results!` |
| `[coughs]` | Brief cough | `Excuse me [coughs].` |

### Usage Examples

```bash
# Professional announcement
voice:narrate "The feature is complete [clears throat]. Let me walk you through it."

# Casual update
voice:narrate "Hey team! The tests are passing [laughs]. All 87 of them!"

# Surprised by results
voice:narrate "The performance improved by [gasps] 300 percent!"
```

---

## Language Codes

Commonly used language codes for `--language` parameter.

| Code | Language |
|------|----------|
| `en` | English |
| `es` | Spanish |
| `fr` | French |
| `de` | German |
| `it` | Italian |
| `pt` | Portuguese |
| `ja` | Japanese |
| `ko` | Korean |
| `zh` | Chinese (Mandarin) |
| `vi` | Vietnamese |

**Note:** Auto-detection works for most languages.

---

## Automatic Notifications

### Approval Gate Notifications

When a workflow reaches an approval gate:

1. Claude stops and waits for input
2. Stop hook triggers automatically
3. ElevenLabs streams audio to your speakers
4. You hear: "Hey, I need your input to continue."

**No commands needed** - completely automatic!

### Error Notifications

When errors occur:
- Audio: "Heads up, something went wrong. Check the error when you can."

---

## Tips & Best Practices

### Streaming Player Selection

```bash
# Check which player is available
which ffplay mpv play

# Install recommended player (macOS)
brew install ffmpeg

# Install recommended player (Linux)
sudo apt install ffmpeg
```

### Character Quota Management

```bash
# Check quota
voice:settings  # View remaining characters

# Free tier: 10,000 characters/month
# Each notification ~ 50 characters
# ~ 200 notifications/month free
```

### Voice Selection

```bash
# Professional documentation
--voice="Rachel"  # Clear, professional

# Engaging tutorials
--voice="Elli"  # Energetic, youthful

# Authoritative announcements
--voice="Josh"  # Deep, commanding
```

---

## Troubleshooting

### "No streaming audio player found"

```bash
# Install ffmpeg (recommended)
brew install ffmpeg  # macOS
sudo apt install ffmpeg  # Linux

# Verify
ffplay -version
```

### "API key not found"

```bash
# Run setup script
bash scripts/setup-voice.sh

# Or check config
cat ~/.claude/aura-frog-voice-config
```

### "Quota exceeded"

```bash
# Check usage
voice:settings

# Options:
1. Wait for monthly reset
2. Upgrade plan at https://elevenlabs.io/pricing
```

---

## Related Documentation

- **Setup Guide:** `VOICEOVER_SETUP.md`
- **Agent Documentation:** `agents/voice-operations.md`
- **Integration Guide:** `docs/guides/elevenlabs-integration.md`

---

## Support

**ElevenLabs Issues:**
- https://elevenlabs.io/support

**Aura Frog Issues:**
- https://github.com/nguyenthienthanh/aura-frog/issues

---

**Last Updated:** 2025-11-29
**Version:** 1.0.0
**Mode:** Realtime Streaming

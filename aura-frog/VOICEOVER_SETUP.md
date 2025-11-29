# Voiceover Setup Guide (Streaming)

**Quick setup for Aura Frog voiceover notifications with realtime streaming**

---

## Quick Setup (1 command)

### Run Setup Script

```bash
cd ~/.claude/plugins/marketplaces/aurafrog/aura-frog
bash scripts/setup-voice.sh
```

**What it does:**
1. Checks for streaming audio player (ffplay, mpv, sox)
2. Asks for your ElevenLabs API key
3. Tests the API key
4. Lets you choose a voice (optional)
5. Saves to `~/.claude/aura-frog-voice-config`
6. Tests streaming voice playback
7. **Works automatically with hooks!**

**Setup process:**
```
Aura Frog Voiceover Notification Setup (Streaming)
==================================================

Step 0: Checking streaming audio player...
   ffplay (FFmpeg) - Found (recommended)

Step 1: ElevenLabs API Key
   Sign up at: https://elevenlabs.io
   Get API key: https://elevenlabs.io/app/settings/api-keys

Enter your ElevenLabs API Key: sk_...

Testing API key...
API key is valid!

Step 2: Voice Selection (Optional)
   Press Enter for default voice (Rachel)
   Or enter a custom voice ID

Enter Voice ID (or press Enter for default): [Enter]
Using default voice: Rachel

Saving configuration...
Configuration saved to: ~/.claude/aura-frog-voice-config

Testing realtime streaming voice generation...
Streaming voiceover...
Voiceover complete

Setup complete!

Key benefits of streaming:
   No file creation (audio plays directly)
   Lower latency (starts immediately)
   No cleanup needed
```

**Free Tier:**
- 10,000 characters/month
- ~200 notifications/month
- No credit card required
- Sign up: https://elevenlabs.io

---

## Prerequisites

### Streaming Audio Player (Required)

Aura Frog uses realtime streaming - audio plays directly without creating files.

**Install one of these (macOS):**
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

### ElevenLabs API Key (Required)

1. Sign up at https://elevenlabs.io
2. Go to Settings → API Keys
3. Create and copy your API key

---

## Test Your Setup

Run the test script:

```bash
cd ~/.claude/plugins/marketplaces/aurafrog/aura-frog
bash scripts/test-voice.sh
```

**Expected output:**
```
Aura Frog Voiceover Notification Test (Streaming)
=================================================

Loading configuration from: ~/.claude/aura-frog-voice-config

ELEVENLABS_API_KEY is set
   Key: sk_12345678...abcd

Checking streaming audio players...
   ffplay (FFmpeg) - Available (recommended)

voice-notify.sh script found

Testing ElevenLabs API connection...
API connection successful (HTTP 200)

Testing realtime streaming voice generation...
   Message: 'This is a test of the streaming voice system'
   Player: ffplay

Streaming voiceover...
Voiceover complete

Streaming voice generation successful!

Key benefits of streaming:
   - No file creation (plays directly)
   - Lower latency (starts playing faster)
   - No cleanup needed

Setup complete! Voiceover notifications are working.
```

**You should hear:** "This is a test of the streaming voice system"

---

## How It Works in Workflows

Once configured, voiceover automatically plays when:

1. **Approval Gates** - Phase completes, waiting for approval
   - Audio: "Hey, I need your input to continue."

2. **Critical Errors** - Errors occur during workflow
   - Audio: "Heads up, something went wrong."

**No commands needed** - completely automatic!

**Streaming benefits:**
- No files created
- Lower latency
- No cleanup needed

---

## Troubleshooting

### Issue: "No streaming audio player found"

**Solution:**
```bash
# Install ffmpeg (recommended)
brew install ffmpeg

# Verify ffplay works
ffplay -version
```

### Issue: "ELEVENLABS_API_KEY not set"

**Solution:**
```bash
# Run setup script to configure
bash scripts/setup-voice.sh

# Or check config file
cat ~/.claude/aura-frog-voice-config
```

### Issue: "No sound plays"

**Check 1: System volume**
- Ensure your system is not muted

**Check 2: Test streaming player**
```bash
# Test ffplay directly (download any mp3)
curl -s "https://www.soundjay.com/button/beep-01a.mp3" | ffplay -nodisp -autoexit -i pipe:0
```

**Check 3: Verify API key is valid**
```bash
source ~/.claude/aura-frog-voice-config
curl -X GET "https://api.elevenlabs.io/v1/voices" \
  -H "xi-api-key: $ELEVENLABS_API_KEY"

# Should return 200 and list of voices
```

### Issue: "HTTP 401 - Invalid API key"

**Solution:**
1. Verify API key at https://elevenlabs.io/app/settings/api-keys
2. Copy the key again (may have expired)
3. Re-run setup: `bash scripts/setup-voice.sh`

### Issue: "HTTP 429 - Rate limit exceeded"

**Solution:**
1. Check usage at https://elevenlabs.io/app/usage
2. Free tier limit: 10,000 characters/month
3. Wait until next month or upgrade plan

---

## Customization

### Change Voice

```bash
# Re-run setup to change voice
bash scripts/setup-voice.sh

# Or edit config directly
nano ~/.claude/aura-frog-voice-config

# Popular voices:
# - 21m00Tcm4TlvDq8ikWAM (Rachel - calm, default)
# - EXAVITQu4vr4xnSDxMaL (Bella - warm)
# - ErXwobaYiN019PkySvjV (Antoni - deep)
# - MF3mGyEYCl7XYWbV9V6O (Elli - energetic)
# - TxGEqnHWrfWFTfGW9XjX (Josh - clear)

# Browse more: https://elevenlabs.io/voice-library
```

### Disable Voiceover

**Temporarily:**
```bash
# Rename or remove config file
mv ~/.claude/aura-frog-voice-config ~/.claude/aura-frog-voice-config.bak

# Script will gracefully skip
```

**Permanently:**
Remove the Stop hook from `hooks/hooks.json`

---

## Usage & Cost

**Free Tier:**
- 10,000 characters/month
- Each notification ~ 50 characters
- ~ **200 notifications/month free**

**Paid Plans:**
- Starter: $5/month - 30,000 characters (600 notifications)
- Creator: $22/month - 100,000 characters (2,000 notifications)

**Check usage:** https://elevenlabs.io/app/usage

---

## Debug

Run debug script for detailed diagnostics:

```bash
cd ~/.claude/plugins/marketplaces/aurafrog/aura-frog
bash scripts/debug-voice.sh
```

This checks:
1. Streaming audio player availability
2. Config file and API key
3. API authentication
4. Account quota
5. Realtime streaming test

---

## Setup Complete!

Once you hear the test notification, voiceover is ready!

**Try it in a workflow:**
```
workflow:start "Test task"
# Wait for approval gate
# Listen for: "Hey, I need your input to continue."
```

**Never miss an approval gate again!**

---

**More Info:**
- Complete guide: `docs/VOICEOVER_NOTIFICATIONS.md`
- ElevenLabs: https://elevenlabs.io
- Support: https://github.com/nguyenthienthanh/aura-frog/issues

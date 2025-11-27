# 🔊 Voiceover Setup Guide

**Quick setup for CCPM voiceover notifications**

---

## ⚡ Quick Setup (1 command)

### Run Setup Script

```bash
cd ~/.claude/plugins/marketplaces/ethan-ccpm/ccpm
bash scripts/setup-voice.sh
```

**What it does:**
1. Asks for your ElevenLabs API key
2. Tests the API key
3. Lets you choose a voice (optional)
4. Saves to `~/.claude/ccpm-voice-config`
5. Tests voice generation
6. **Works automatically with hooks!**

**Setup process:**
```
🔊 CCPM Voiceover Notification Setup
=====================================

📋 Step 1: ElevenLabs API Key
   Sign up at: https://elevenlabs.io
   Get API key: https://elevenlabs.io/app/settings/api-keys

Enter your ElevenLabs API Key: sk_...

🧪 Testing API key...
✅ API key is valid!

📋 Step 2: Voice Selection (Optional)
   Press Enter for default voice (Rachel)
   Or enter a custom voice ID

Enter Voice ID (or press Enter for default): [Enter]
Using default voice: Rachel

💾 Saving configuration...
✅ Configuration saved to: ~/.claude/ccpm-voice-config

🎤 Testing voice generation...
🔊 Generating voiceover...
✅ Voiceover saved
🔊 Playing notification...

✅ Setup complete!
```

**Free Tier:**
- 10,000 characters/month
- ≈200 notifications/month
- No credit card required
- Sign up: https://elevenlabs.io

---

## ✅ Test Your Setup

Run the test script:

```bash
cd ~/.claude/plugins/marketplaces/ethan-ccpm/ccpm
bash scripts/test-voice.sh
```

**Expected output:**
```
🔊 CCPM Voiceover Notification Test
====================================

✅ ELEVENLABS_API_KEY is set
✅ voice-notify.sh script found
🧪 Testing ElevenLabs API connection...
✅ API connection successful (HTTP 200)
🎤 Testing voice generation...
🔊 Generating voiceover...
✅ Voiceover saved: .claude/logs/audio/general_20251127_143022.mp3
🔊 Playing notification...
✅ Voice generation successful!
```

**You should hear:** "This is a test notification"

---

## 🎯 How It Works in Workflows

Once configured, voiceover automatically plays when:

1. **Approval Gates** - Phase completes, waiting for approval
   - Audio: "Attention please. Your attention is needed. Your approval is required to continue."

2. **Critical Errors** - Errors occur during workflow
   - Audio: "Alert. [error message]. Please review the error and provide guidance."

**No commands needed** - completely automatic!

---

## 🔧 Troubleshooting

### Issue: "ELEVENLABS_API_KEY not set"

**Solution:**
```bash
# Check if set
echo $ELEVENLABS_API_KEY

# If empty, add to environment (see Step 2 above)
export ELEVENLABS_API_KEY="your_key"

# Verify
echo $ELEVENLABS_API_KEY
```

### Issue: "No sound plays"

**Check 1: System volume**
```bash
# macOS: Check system volume is not muted
```

**Check 2: Test audio manually**
```bash
# macOS
afplay ~/.claude/plugins/marketplaces/ethan-ccpm/ccpm/.claude/logs/audio/general_*.mp3

# Linux (install mpg123 if needed)
mpg123 ~/.claude/plugins/marketplaces/ethan-ccpm/ccpm/.claude/logs/audio/general_*.mp3

# Windows
start %USERPROFILE%\.claude\plugins\marketplaces\ethan-ccpm\ccpm\.claude\logs\audio\general_*.mp3
```

**Check 3: Verify API key is valid**
```bash
curl -X GET "https://api.elevenlabs.io/v1/voices" \
  -H "xi-api-key: $ELEVENLABS_API_KEY"

# Should return 200 and list of voices
```

### Issue: "HTTP 401 - Invalid API key"

**Solution:**
1. Verify API key at https://elevenlabs.io/app/settings/api-keys
2. Copy the key again (may have expired)
3. Update environment variable
4. Restart terminal/IDE

### Issue: "HTTP 429 - Rate limit exceeded"

**Solution:**
1. Check usage at https://elevenlabs.io/app/usage
2. Free tier limit: 10,000 characters/month
3. Wait until next month or upgrade plan

### Issue: "File not found: scripts/voice-notify.sh"

**Solution:**
```bash
# The hook uses absolute path now
# Verify file exists:
ls -la ~/.claude/plugins/marketplaces/ethan-ccpm/ccpm/scripts/voice-notify.sh

# Should show: -rwxr-xr-x (executable)
```

---

## 🎨 Customization

### Change Voice

```bash
# Add to environment
export ELEVENLABS_VOICE_ID="21m00Tcm4TlvDq8ikWAM"  # Rachel (default)

# Other voices:
# - EXAVITQu4vr4xnSDxMaL (Bella - warm)
# - ErXwobaYiN019PkySvjV (Antoni - deep)
# - MF3mGyEYCl7XYWbV9V6O (Elli - energetic)
# - TxGEqnHWrfWFTfGW9XjX (Josh - clear)

# Browse more: https://elevenlabs.io/voice-library
```

### Disable Voiceover

**Temporarily:**
```bash
# Remove API key from environment
unset ELEVENLABS_API_KEY

# Script will gracefully skip
```

**Permanently:**
Remove the Stop and Notification hooks from `hooks/hooks.json`

---

## 📊 Usage & Cost

**Free Tier:**
- 10,000 characters/month
- Each notification ≈ 50 characters
- ≈ **200 notifications/month free**

**Paid Plans:**
- Starter: $5/month - 30,000 characters (600 notifications)
- Creator: $22/month - 100,000 characters (2,000 notifications)

**Check usage:** https://elevenlabs.io/app/usage

---

## 🆘 Still Not Working?

1. **Run test script:**
   ```bash
   bash scripts/test-voice.sh
   ```

2. **Check plugin installation:**
   ```bash
   /plugin list | grep ccpm
   ```

3. **Verify hooks:**
   ```bash
   cat ~/.claude/plugins/marketplaces/ethan-ccpm/ccpm/hooks/hooks.json | grep -A5 "Stop"
   ```

4. **Manual test:**
   ```bash
   cd ~/.claude/plugins/marketplaces/ethan-ccpm/ccpm
   bash scripts/voice-notify.sh "Manual test" "general"
   ```

5. **Check logs:**
   ```bash
   ls -la .claude/logs/audio/
   ```

---

## ✅ Setup Complete!

Once you hear the test notification, voiceover is ready!

**Try it in a workflow:**
```
workflow:start "Test task"
# Wait for approval gate
# Listen for: "Your attention is needed. Your approval is required to continue."
```

**Never miss an approval gate again!** 🎉

---

**More Info:**
- Complete guide: `docs/VOICEOVER_NOTIFICATIONS.md`
- ElevenLabs: https://elevenlabs.io
- Support: https://github.com/nguyenthienthanh/ccpm-team-agents/issues

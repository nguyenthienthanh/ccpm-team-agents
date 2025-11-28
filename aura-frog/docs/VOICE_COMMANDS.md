# Voice Commands Reference

**Aura Frog Feature:** ElevenLabs AI Voice Operations
**Version:** 1.0.0
**Last Updated:** 2025-11-26

---

## 🎙️ Quick Reference

### Essential Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `voice:test` | Test voice generation | `voice:test` |
| `voice:narrate` | Convert text to speech | `voice:narrate "Hello world"` |
| `voice:narrate:file` | Narrate from file | `voice:narrate:file README.md` |
| `voice:settings` | View/edit settings | `voice:settings` |
| `voice:voices` | List available voices | `voice:voices` |
| `narrate all` | Narrate all docs (Phase 8) | `narrate all` |
| `narrate summary` | Narrate summary only | `narrate summary` |
| `skip narration` | Skip audio generation | `skip narration` |

---

## 📖 Detailed Command Reference

### voice:test

Test voice generation with sample text.

**Usage:**
```
voice:test
```

**Output:**
```
🎙️ Testing Voice Generation

Sample Text: "Hello! This is a test..."
Generating audio...
✅ Success!

Generated: .claude/logs/audio/voice_test_2025-11-26.mp3
Duration: 8 seconds
Voice quality: ⭐⭐⭐⭐⭐
```

**When to use:**
- After initial setup
- Testing configuration changes
- Verifying API key works

---

### voice:narrate

Convert text to speech directly.

**Usage:**
```
voice:narrate <text>
voice:narrate <text> --voice=<voice-id>
voice:narrate <text> --language=<lang-code>
```

**Examples:**
```bash
# Basic narration
voice:narrate "The implementation is complete and all tests are passing."

# With specific voice
voice:narrate "This is important" --voice="Antoni"

# Multilingual
voice:narrate "Hola, ¿cómo estás?" --language="es"

# With emotion tags
voice:narrate "Great news [laughs]! The feature is done."

# Whisper effect
voice:narrate "This is [whispers] confidential information."
```

**Parameters:**
- `--voice=<id>` - Voice ID (default: Rachel)
- `--language=<code>` - Language code (auto-detected if not specified)
- `--output=<path>` - Custom output path

**Output:**
```
🎙️ Generating voice narration...

Voice: Rachel (default)
Language: English
Duration: ~12 seconds

✅ Generated: .claude/logs/audio/narration_2025-11-26_143022.mp3

Preview: [Audio waveform shown]

Play: open .claude/logs/audio/narration_2025-11-26_143022.mp3
```

---

### voice:narrate:file

Narrate contents of a file.

**Usage:**
```
voice:narrate:file <file-path>
voice:narrate:file <file-path> --voice=<voice-id>
voice:narrate:file <file-path> --language=<lang>
```

**Examples:**
```bash
# Narrate markdown file
voice:narrate:file README.md

# Narrate with specific voice
voice:narrate:file IMPLEMENTATION.md --voice="Josh"

# Narrate in Spanish
voice:narrate:file GUIA.md --language="es"
```

**Supported File Types:**
- `.md` - Markdown
- `.txt` - Plain text
- `.rst` - reStructuredText

**File Processing:**
- Strips markdown formatting
- Removes code blocks (or reads them as "code block")
- Converts headings to spoken form
- Maintains paragraph breaks

**Output:**
```
🎙️ Generating narration for README.md

File: README.md
Size: 3.2 KB
Words: ~850
Estimated duration: ~5 minutes

Generating audio...
✅ Generated: .claude/logs/audio/readme_narration.mp3

Duration: 5:24
Size: 2.1 MB
```

---

### voice:settings

View and configure voice settings.

**Usage:**
```
voice:settings
voice:settings:edit
```

**Output:**
```
🎙️ ElevenLabs Voice Settings

Current Configuration:
  ✅ Enabled: true
  🎤 Voice: Rachel (21m00Tcm4TlvDq8ikWAM)
  🌍 Model: eleven_multilingual_v2
  📊 Stability: 0.5
  🎯 Similarity: 0.75
  🎨 Style: 0

Features:
  ❌ Workflow Notifications: disabled
  ✅ Documentation Narration: enabled
  ❌ Approval Prompts: disabled

Output:
  📁 Directory: .claude/logs/audio/
  📄 Format: mp3_44100_128

API Status:
  ✅ API Key: Configured
  ✅ Connection: OK
  📊 Character Quota: 85,432 / 100,000 (85%)

Actions:
- "voice:settings:edit" → Edit configuration
- "voice:test" → Test voice
- "voice:voices" → List voices
```

---

### voice:voices

List all available ElevenLabs voices.

**Usage:**
```
voice:voices
voice:voices --filter=<type>
```

**Output:**
```
🎤 Available ElevenLabs Voices

Pre-made Voices:

  1. Rachel (21m00Tcm4TlvDq8ikWAM) - ⭐ Default
     Gender: Female
     Accent: American
     Description: Calm, clear, professional
     Best for: Documentation, tutorials

  2. Antoni (ErXwobaYiN019PkySvjV)
     Gender: Male
     Accent: American
     Description: Well-rounded, versatile
     Best for: General narration

  3. Bella (EXAVITQu4vr4xnSDxMaL)
     Gender: Female
     Accent: American
     Description: Soft, gentle
     Best for: Friendly communication

  4. Josh (TxGEqnHWrfWFTfGW9XjX)
     Gender: Male
     Accent: American
     Description: Deep, authoritative
     Best for: Serious announcements

  5. Elli (MF3mGyEYCl7XYWbV9V6O)
     Gender: Female
     Accent: American
     Description: Energetic, youthful
     Best for: Engaging content

Custom Voices:
  (None configured)

To change voice:
1. Copy voice ID
2. Edit .claude/project-contexts/[project]/project-config.yaml
3. Update default_voice_id: "voice-id-here"
```

**Filters:**
- `--filter=male` - Male voices only
- `--filter=female` - Female voices only
- `--filter=custom` - Custom voices only

---

### narrate all

Generate audio for all documentation (Phase 8 only).

**Usage:**
```
narrate all
narrate all --multilingual
```

**When Available:**
- Only at Phase 8 approval gate
- After documentation generation completes

**Example:**
```
Phase 8 Complete: Documentation

Options:
  "narrate all" → Generate audio for all documents
  "narrate summary" → Only implementation summary
  "skip narration" → No audio

Your choice: narrate all
```

**Output:**
```
🎙️ Generating Audio Narration...

[1/4] IMPLEMENTATION_SUMMARY.md
      Converting 1,245 words → ~8 min audio
      ✅ Generated: implementation_summary.mp3 (3.2 MB)

[2/4] DEPLOYMENT_GUIDE.md
      Converting 823 words → ~5 min audio
      ✅ Generated: deployment_guide.mp3 (2.1 MB)

[3/4] API_DOCUMENTATION.md
      Converting 1,567 words → ~10 min audio
      ✅ Generated: api_documentation.mp3 (4.5 MB)

[4/4] CHANGELOG.md
      Converting 342 words → ~2 min audio
      ✅ Generated: changelog.mp3 (1.1 MB)

✅ All audio files generated!

📁 Location: .claude/logs/audio/workflow-123/
Total duration: ~25 minutes
Total size: 10.9 MB

🔗 Next Steps:
- Play: open .claude/logs/audio/workflow-123/
- Upload to Confluence
- Share with team
```

---

### narrate summary

Generate audio for implementation summary only (Phase 8).

**Usage:**
```
narrate summary
```

**Output:**
```
🎙️ Generating narration for IMPLEMENTATION_SUMMARY.md

Converting 1,245 words → ~8 min audio
✅ Generated: implementation_summary.mp3 (3.2 MB)

📁 Location: .claude/logs/audio/workflow-123/
Duration: 8:24
Size: 3.2 MB

Play: open .claude/logs/audio/workflow-123/implementation_summary.mp3
```

**When to use:**
- Want audio for summary only
- Save on character quota
- Quick overview for team

---

### skip narration

Skip audio generation and proceed to Phase 9.

**Usage:**
```
skip narration
skip
```

**Output:**
```
⏭️  Skipping audio narration

Proceeding to Phase 9 (Notification)...
```

---

## 🎨 Emotional Tags

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

# Confidential information
voice:narrate "The API key is [whispers] stored in the environment variables."

# Disappointed but moving forward
voice:narrate "We missed the deadline [sighs], but we'll deploy tomorrow."

# Surprised by results
voice:narrate "The performance improved by [gasps] 300 percent!"
```

---

## 🌍 Language Codes

Commonly used language codes for `--language` parameter.

| Code | Language | Example |
|------|----------|---------|
| `en` | English | `--language="en"` |
| `es` | Spanish | `--language="es"` |
| `fr` | French | `--language="fr"` |
| `de` | German | `--language="de"` |
| `it` | Italian | `--language="it"` |
| `pt` | Portuguese | `--language="pt"` |
| `ja` | Japanese | `--language="ja"` |
| `ko` | Korean | `--language="ko"` |
| `zh` | Chinese (Mandarin) | `--language="zh"` |
| `ar` | Arabic | `--language="ar"` |
| `hi` | Hindi | `--language="hi"` |
| `ru` | Russian | `--language="ru"` |
| `nl` | Dutch | `--language="nl"` |
| `pl` | Polish | `--language="pl"` |
| `tr` | Turkish | `--language="tr"` |
| `fil` | Filipino | `--language="fil"` |
| `ms` | Malay | `--language="ms"` |
| `id` | Indonesian | `--language="id"` |
| `th` | Thai | `--language="th"` |
| `vi` | Vietnamese | `--language="vi"` |

**Note:** Auto-detection works for most languages. Specify `--language` only if needed.

---

## 🎬 Common Workflows

### Workflow 1: Test Setup

```bash
# 1. Test voice generation
voice:test

# 2. Check settings
voice:settings

# 3. List available voices
voice:voices

# 4. Try narrating text
voice:narrate "Hello Aura Frog team! Voice integration is working."

# ✅ Setup complete!
```

---

### Workflow 2: Generate Audio Documentation

```bash
# During Phase 8 approval gate:

1. Documentation complete
2. Prompt appears: "Generate audio narration?"
3. Choose option:
   - "narrate all" → All documents
   - "narrate summary" → Summary only
   - "skip narration" → No audio

# Audio files saved to:
logs/audio/workflow-{id}/

# Listen:
open .claude/logs/audio/workflow-{id}/implementation_summary.mp3
```

---

### Workflow 3: Manual Narration

```bash
# 1. Create documentation
document feature "User Authentication"

# 2. Narrate the document
voice:narrate:file USER_AUTHENTICATION.md

# 3. Output location
logs/audio/user_authentication_narration.mp3

# 4. Share with team
# Upload to Confluence or team drive
```

---

### Workflow 4: Multilingual Team

```bash
# Generate docs in multiple languages (Phase 8)

1. Type: "narrate all --multilingual"

2. Generates audio in configured languages:
   - implementation_summary_en.mp3 (English)
   - implementation_summary_es.mp3 (Spanish)
   - implementation_summary_fil.mp3 (Filipino)
   - implementation_summary_zh.mp3 (Chinese)

3. Share appropriate version with each region
```

---

## 💡 Tips & Best Practices

### Character Quota Management

```bash
# Check quota before large generation
voice:settings  # View remaining characters

# Use selective narration
narrate summary  # Instead of "narrate all"

# Summarize long docs first
# 2,000-word doc → 500-word summary → Narrate summary
```

### Voice Selection

```bash
# Professional documentation
--voice="Rachel"  # Clear, professional

# Engaging tutorials
--voice="Elli"  # Energetic, youthful

# Authoritative announcements
--voice="Josh"  # Deep, commanding

# General purpose
--voice="Antoni"  # Versatile, natural
```

### Audio Quality

```bash
# Best quality (larger files)
# Edit project-config.yaml:
elevenlabs:
  output:
    format: "mp3_44100_192"

# Balanced (recommended)
format: "mp3_44100_128"

# Smaller files (lower quality)
format: "mp3_22050_32"
```

---

## 🔧 Troubleshooting

### "API key not found"

```bash
# Check environment variable
echo $ELEVENLABS_API_KEY

# If empty, set it
export ELEVENLABS_API_KEY="your_key_here"

# Test again
voice:test
```

### "Quota exceeded"

```bash
# Check usage
voice:settings

# Options:
1. Wait for monthly reset
2. Upgrade plan
3. Use selective narration
```

### "Voice sounds unnatural"

```bash
# Adjust stability/similarity
# Edit project-config.yaml:
elevenlabs:
  voice:
    stability: 0.6  # Increase
    similarity_boost: 0.85  # Increase
```

---

## 📚 Related Documentation

- **Setup Guide:** `docs/guides/elevenlabs-integration.md`
- **Agent Documentation:** `agents/voice-operations.md`
- **Phase 8 Workflow:** `commands/workflow/phase-8.md`
- **Project Configuration:** `.claude/project-contexts/template/project-config.yaml`

---

## 📞 Support

**ElevenLabs Issues:**
- https://elevenlabs.io/support

**Aura Frog Issues:**
- https://github.com/anthropics/claude-code/issues

**API Documentation:**
- https://elevenlabs.io/docs

---

**Last Updated:** 2025-11-26
**Version:** 1.0.0

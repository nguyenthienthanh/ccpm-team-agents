---
name: figma-integration
description: "PROACTIVELY use when Figma URL detected in user message. Triggers: Figma URLs like 'figma.com/file/ABC123', 'figma:fetch' command. Auto-fetches design data, extracts components, design tokens, images. Loads into Phase 3 (UI Breakdown). Requires FIGMA_ACCESS_TOKEN in .envrc."
allowed-tools: Read, Bash
---

# CCPM Figma Integration

**Version:** 5.0.0-beta
**Purpose:** Automatic Figma design fetching and component extraction
**Priority:** MEDIUM - Use when Figma URL mentioned

---

## 🎯 Overview

Figma Integration automatically detects Figma design links, fetches design data via Figma API, extracts components and design tokens, and loads them into the workflow's UI phase.

---

## ✅ When to Use This Skill

**AUTO-DETECT and use when:**
- User shares Figma URL: `https://www.figma.com/file/ABC123/Design`
- User says: "figma:fetch ABC123"
- User mentions: "implement this Figma design"
- Starting workflow with Figma reference

**Examples:**
- "Implement https://figma.com/file/ABC123/UserProfile"
- "Build the login screen from Figma"
- "workflow:start implement design from Figma"

---

## 🔄 Integration Process

### Step 1: Detect Figma URL

**Pattern matching:**
```javascript
// Match Figma URLs
const figmaPattern = /figma\.com\/file\/([a-zA-Z0-9]+)/
const match = userMessage.match(figmaPattern)

// Extract file ID
const fileId = match[1] // e.g., "ABC123"
```

### Step 2: Fetch Design Data

**Using Bash script:**
```bash
# Load Figma credentials from .envrc
source .envrc

# Fetch design using script
bash scripts/figma-fetch.sh ABC123

# Output: .claude/logs/figma/ABC123.json
```

**Script location:** `skills/figma-integration/scripts/figma-fetch.sh`

### Step 3: Parse Design Data

```json
{
  "name": "User Profile Screen",
  "lastModified": "2024-11-27T10:00:00Z",
  "version": "1.2.3",
  "document": {
    "id": "0:1",
    "name": "Page 1",
    "children": [...]
  },
  "components": {
    "Button": {
      "width": 200,
      "height": 44,
      "backgroundColor": "#007AFF",
      "borderRadius": 8
    },
    "TextField": {
      "width": 300,
      "height": 40,
      "borderColor": "#E5E5EA",
      "borderWidth": 1
    }
  },
  "styles": {
    "colors": {
      "primary": "#007AFF",
      "secondary": "#5856D6",
      "background": "#FFFFFF",
      "text": "#000000"
    },
    "typography": {
      "heading1": {
        "fontSize": 28,
        "fontWeight": "700",
        "lineHeight": 34
      },
      "body": {
        "fontSize": 16,
        "fontWeight": "400",
        "lineHeight": 22
      }
    },
    "spacing": {
      "xs": 4,
      "sm": 8,
      "md": 16,
      "lg": 24,
      "xl": 32
    }
  },
  "images": {
    "avatar": "https://figma.com/api/images/ABC123/avatar.png",
    "background": "https://figma.com/api/images/ABC123/bg.png"
  }
}
```

### Step 4: Extract Design Tokens

**Generate design token file:**
```typescript
// design-tokens.ts
export const colors = {
  primary: '#007AFF',
  secondary: '#5856D6',
  background: '#FFFFFF',
  text: '#000000'
}

export const typography = {
  heading1: {
    fontSize: 28,
    fontWeight: '700' as const,
    lineHeight: 34
  },
  body: {
    fontSize: 16,
    fontWeight: '400' as const,
    lineHeight: 22
  }
}

export const spacing = {
  xs: 4,
  sm: 8,
  md: 16,
  lg: 24,
  xl: 32
}
```

### Step 5: Generate Component Structure

**From Figma components → Code components:**
```
Figma: "User Profile Screen"
├── Header
│   ├── Avatar (Image, 60x60, rounded)
│   └── Name (Text, heading1 style)
├── Bio Section
│   └── Bio Text (Text, body style, 3 lines max)
└── Actions
    ├── Edit Button (Button component, primary)
    └── Share Button (Button component, secondary)

Code structure:
src/screens/UserProfile/
├── index.tsx
├── components/
│   ├── Header.tsx
│   ├── BioSection.tsx
│   └── Actions.tsx
└── styles.ts
```

### Step 6: Load into Phase 3

**Use Figma data in Phase 3 (UI Breakdown):**
- Components → Component breakdown
- Design tokens → Styling constants
- Images → Asset requirements
- Spacing → Layout grid

---

## 📋 Generated Artifacts

**From Figma integration:**
1. `design-tokens.ts` - Colors, typography, spacing
2. `components-breakdown.md` - Component structure
3. `assets/` - Downloaded images
4. `figma-metadata.json` - Full design data

---

## ⚙️ Setup Requirements

**Environment variables in `.envrc`:**
```bash
export FIGMA_ACCESS_TOKEN="figd_your-token"
export FIGMA_FILE_KEY="ABC123"  # Default file (optional)
```

**Get Figma token:**
1. Go to Figma → Settings → Personal Access Tokens
2. Create token with "Read" permission
3. Add to `.envrc`

**Check setup:**
```bash
if [ -z "$FIGMA_ACCESS_TOKEN" ]; then
  echo "⚠️  Figma not configured!"
  echo "See: docs/INTEGRATION_SETUP_GUIDE.md (Section 3.4: Figma)"
  echo ""
  echo "Options:"
  echo "1. Configure Figma integration"
  echo "2. Provide screenshots instead"
fi
```

---

## 🖼️ Fallback: Screenshots

**If Figma not configured:**
```markdown
**⚠️  Figma integration not set up**

**Option 1:** Configure Figma
- Add FIGMA_ACCESS_TOKEN to .envrc
- See: docs/INTEGRATION_SETUP_GUIDE.md

**Option 2:** Provide screenshots
- Share design screenshots
- I'll analyze visually and extract components

Which would you prefer?
```

---

## 🔗 Related Skills

- **workflow-orchestrator** - Uses Figma data in Phase 3
- **ui-designer agent** - Analyzes Figma designs

---

**Remember:** Figma integration enhances UI phase, but screenshots work too if API access unavailable.

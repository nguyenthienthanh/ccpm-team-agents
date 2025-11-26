# CCPM Project Configuration

**Project:** [PROJECT_NAME]
**Type:** [PROJECT_TYPE]
**Framework:** [FRAMEWORK]
**Version:** 5.0.0-beta

---

## 📁 Project Structure

This `.claude/` folder contains CCPM-specific configuration and data for your project:

```
.claude/
├── CLAUDE.md                    # This file
├── .claude/project-contexts/            # Project-specific context
│   └── [project-name]/
│       ├── project-config.yaml  # Tech stack, team config
│       ├── conventions.md       # Naming, structure, patterns
│       ├── rules.md             # Project-specific rules
│       └── examples.md          # Code examples
├── .claude/logs/                        # Workflow execution logs
│   ├── workflows/               # Workflow history
│   ├── figma/                   # Figma design data
│   ├── jira/                    # JIRA ticket data
│   └── audio/                   # Voice narration (if enabled)
├── context/                     # Active workflow contexts
└── active-workflow.txt          # Current workflow state

```

---

## 🎯 What is CCPM?

**CCPM (Claude Code Project Management)** is an AI-powered project management system installed as a Claude Code plugin.

**Features:**
- 🤖 **24 AI specialists** automatically activated based on context
- 🔄 **9-phase workflow** from requirements analysis to deployment
- ✅ **TDD enforcement** (Test-Driven Development) mandatory
- 🎯 **Quality gates** requiring approval at each critical phase
- 🔗 **External integrations** with JIRA, Confluence, Slack, Figma

---

## 📖 Project Context System

### What is Project Context?

Project context tells CCPM about YOUR project's conventions, patterns, and tech stack. This ensures AI-generated code follows YOUR standards, not generic templates.

**Location:** `.claude/project-contexts/[your-project-name]/`

**Contains:**
- `project-config.yaml` - Tech stack, team structure, integrations
- `conventions.md` - File naming, directory structure, import patterns
- `rules.md` - Project-specific quality rules
- `examples.md` - Real code examples from your project

### Why It's Critical

**WITH project context:**
```typescript
// AI knows your project uses:
// - PascalCase.tsx for components
// - Zustand for state management
// - NativeWind for styling
// - Phone/Tablet variants
// - 80% test coverage requirement

UserProfile.tsx
UserProfile.phone.tsx
UserProfile.tablet.tsx
UserProfile.test.tsx
```

**WITHOUT project context:**
```typescript
// AI uses generic patterns:
// - Different naming
// - Wrong state library
// - Generic styling
// - Missing variants

user-profile.tsx  // ❌ Wrong naming
// Uses Redux instead of Zustand  // ❌ Wrong library
// Uses StyleSheet instead of NativeWind  // ❌ Wrong styling
```

### How Workflows Use It

When you run `workflow:start` or any CCPM command:

1. ✅ Claude loads `.claude/project-contexts/[project]/project-config.yaml`
2. ✅ Reads `conventions.md` for naming/structure rules
3. ✅ Applies `rules.md` for quality standards
4. ✅ References `examples.md` for code patterns
5. ✅ Follows detected tech stack and testing requirements
6. ✅ Assigns correct reviewers per region/team

### Priority Hierarchy

```
Project Context > CCPM Rules > Generic Defaults
```

**Example:**
- Your `conventions.md` says: "Use kebab-case for files"
- CCPM default: "Use PascalCase"
- **Result:** AI uses kebab-case ✅

---

## 🚀 Quick Start

### First Time Setup

If this is your first time using CCPM in this project:

```bash
# Initialize CCPM for this project
project:init
```

This will:
- Analyze your project structure
- Detect tech stack and conventions
- Generate project context files
- Set up configuration

### Start a Workflow

```bash
# Full 9-phase workflow
workflow:start "Add user authentication"

# Quick bug fix
bugfix:quick "Fix login button alignment"

# Documentation only
document feature "User Authentication"
```

---

## 📚 Configuration Files

### ccpm-config.yaml (Plugin)

Located in plugin directory (`~/.claude/plugins/marketplaces/ethan-ccpm/ccpm/`)

Contains:
- Workflow settings (mode, coverage target, TDD enforcement)
- Agent configuration
- Integration settings
- Git conventions

**When to update:** After major project changes, run `project:init` again

### .envrc (Project Root)

Located in your project root directory

Contains:
- Project environment variables
- CCPM integration credentials (JIRA, Figma, Slack, Confluence)

**Setup:**
```bash
# Edit .envrc to add your API tokens
nano .envrc

# Enable environment loading
direnv allow
```

### settings.local.json (Plugin)

Located in plugin directory

Contains:
- Claude Code permissions
- Auto-approval settings
- Personal preferences

**Git-ignored** for personal customization

---

## 🔄 Workflow Logs

All workflow executions are logged to `.claude/logs/`:

```
.claude/logs/
├── workflows/
│   └── workflow-[task]-[timestamp]/
│       ├── workflow-state.json      # Phase progress, deliverables
│       ├── phase-1-understand.md    # Requirements analysis
│       ├── phase-2-design.md        # Technical design
│       ├── ...
│       └── phase-9-share.md         # Team notifications
├── figma/
│   └── [file-id].json               # Figma design data
├── jira/
│   └── [ticket-id].json             # JIRA ticket data
└── audio/
    └── workflow-[id]/
        ├── implementation_summary.mp3
        ├── deployment_guide.mp3
        └── changelog.mp3
```

**Benefits:**
- ✅ Audit trail of all changes
- ✅ Review past decisions
- ✅ Resume interrupted workflows
- ✅ Share context with team

---

## 📖 Documentation

**CCPM Plugin Documentation:**
- Located in: `~/.claude/plugins/marketplaces/ethan-ccpm/ccpm/`
- Main guide: `README.md`
- Quick start: `GET_STARTED.md`
- All commands: `commands/README.md`
- Agent details: `agents/`

**Project Context:**
- Located in: `.claude/project-contexts/[your-project-name]/`
- Your conventions: `conventions.md`
- Your rules: `rules.md`
- Your examples: `examples.md`

---

## 🛠️ Common Commands

### Project Setup
```bash
project:init              # Initialize CCPM
project:regen             # Re-scan project (after changes)
project:detect            # Re-detect project type
setup:integrations        # Configure JIRA/Slack/etc.
```

### Workflows
```bash
workflow:start <task>     # Full 9-phase workflow
workflow:status           # Check progress
workflow:handoff          # Save state for later
workflow:resume <id>      # Resume saved workflow
```

### Quick Commands
```bash
bugfix:quick <desc>       # Fast bug fix
refactor <file>           # Code refactoring
planning <task>           # Create execution plan
document <type> <name>    # Generate docs
test:unit <file>          # Add unit tests
test:e2e <flow>           # Add E2E tests
```

### Agents & Info
```bash
agent:list                # Show all 24 agents
agent:info <name>         # Agent details
help                      # Show all commands
```

---

## 🔒 What to Commit

**✅ Commit these:**
- `.claude/CLAUDE.md` (this file)
- `.claude/project-contexts/` (project context)
- `.gitkeep` files in `.claude/logs/` subdirectories

**❌ Don't commit these:**
- `.claude/logs/` (workflow execution data)
- `.claude/context/` (active workflow contexts)
- `.claude/active-workflow.txt` (current workflow state)
- `.envrc` (if it contains secrets)

**Recommended `.gitignore`:**
```gitignore
# CCPM
.claude/logs/**/*
!.claude/logs/.gitkeep
!.claude/logs/**/.gitkeep
.claude/context/
.claude/active-workflow.txt
.envrc  # If contains secrets
```

---

## 🆘 Troubleshooting

### "Project context not found"

Run `project:init` to create project context.

### "Integration not configured"

1. Edit `.envrc` in project root
2. Add API tokens for JIRA/Figma/Slack
3. Run `direnv allow`

### "AI using wrong patterns"

1. Check `.claude/project-contexts/[project]/conventions.md`
2. Update conventions if needed
3. Run `project:regen` to re-scan

### "Workflows ignoring project rules"

Ensure workflows are loading context:
- Check `project-config.yaml` exists
- Verify `conventions.md` has your rules
- See if AI mentions loading project context

---

## 📚 Learn More

**Official Documentation:**
- CCPM Repository: https://github.com/nguyenthienthanh/ccpm-team-agents
- Plugin Guide: `~/.claude/plugins/marketplaces/ethan-ccpm/ccpm/README.md`
- Issues: https://github.com/nguyenthienthanh/ccpm-team-agents/issues

**Quick References:**
- Workflow phases: `~/.claude/plugins/marketplaces/ethan-ccpm/ccpm/docs/phases/`
- Agent catalog: `~/.claude/plugins/marketplaces/ethan-ccpm/ccpm/agents/`
- Integration guides: `~/.claude/plugins/marketplaces/ethan-ccpm/ccpm/docs/guides/`

---

**This project is configured with CCPM Team Agents v5.0.0-beta**

Run `workflow:start "Your task"` to begin! 🚀

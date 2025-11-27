# 👋 Welcome to CCPM Team Agents!

**Version:** 5.0.0-beta
**Installed:** Plugin successfully installed in Claude Code!

---

## 🎉 Installation Complete!

**CCPM (Claude Code Project Management)** is now available globally across all your projects.

---

## 🚀 Quick Start (3 Steps)

### Step 1: Navigate to Your Project

```bash
cd /path/to/your/project
```

### Step 2: Initialize CCPM

```bash
project:init
```

**This will:**
- ✅ Create `.claude/` folder in your project
- ✅ Analyze your project structure & tech stack
- ✅ Generate project-specific conventions
- ✅ Set up configuration files (`.envrc`, `settings.local.json`)
- ✅ Prepare CCPM for your workflow

**Takes ~1-2 minutes** depending on project size.

### Step 3: Start Your First Workflow

```bash
workflow:start "Your task description"
```

**Example:**
```bash
workflow:start "Add user authentication"
```

Claude will guide you through the 9-phase workflow with AI specialists!

---

## 🤖 What You Get

### 24 AI Specialists
- **Mobile:** React Native, Flutter
- **Web:** React, Vue, Angular, Next.js
- **Backend:** Node.js, Laravel, Python, Go
- **Quality:** QA Automation, Security Expert, Code Review
- **DevOps:** Docker, Kubernetes, CI/CD, Monitoring
- **Operations:** JIRA, Confluence, Slack, Figma

### 9-Phase Workflow
1. **Understand** 🎯 - What are we building?
2. **Design** 🏗️ - How will we build it?
3. **UI Breakdown** 🎨 - What does it look like?
4. **Plan Tests** 🧪 - How will we test it?
5. **Write Tests** 🔴 - Tests first! (TDD RED)
6. **Build** 🟢 - Make it work! (TDD GREEN)
7. **Polish** ♻️ - Make it better! (TDD REFACTOR)
8. **Review** 👀 - Does it look good?
9. **Verify** ✅ - Does it work well?
10. **Document** 📚 - Explain what we built
11. **Share** 🔔 - Tell the team!

### Quality Gates
- ✅ TDD enforced (write tests first, always!)
- ✅ Approval required at each critical phase
- ✅ Cross-agent review (multiple AI perspectives)
- ✅ 80% test coverage target (configurable)
- ✅ Linter passes (0 warnings)

### External Integrations
- 🎫 **JIRA** - Fetch tickets, update status
- 🎨 **Figma** - Extract designs, components
- 💬 **Slack** - Send notifications
- 📝 **Confluence** - Publish documentation

---

## 📖 Essential Commands

### Project Management
```bash
project:init              # Initialize CCPM for current project
project:detect            # Auto-detect project type
project:regen             # Re-scan project (after changes)
setup:integrations        # Configure JIRA/Slack/etc.
```

### Workflows
```bash
workflow:start <task>     # Full 9-phase workflow
workflow:status           # Check progress
workflow:handoff          # Save state (75% token limit)
workflow:resume <id>      # Resume saved workflow
```

### Quick Commands
```bash
bugfix:quick <desc>       # Fast bug fix (skip phases)
refactor <file>           # Code refactoring
planning <task>           # Create execution plan
document <type> <name>    # Generate docs
test:unit <file>          # Add unit tests
test:e2e <flow>           # Add E2E tests
```

### Information
```bash
agent:list                # Show all 24 agents
agent:info <name>         # Agent details
help                      # Show all commands
```

---

## 📁 What Gets Created

When you run `project:init`:

```
your-project/
├── .claude/                         # CCPM project data
│   ├── CLAUDE.md                    # Project guide
│   ├── settings.local.json          # Claude Code permissions
│   ├── project-contexts/[project]/  # Your project's conventions
│   │   ├── project-config.yaml      # Tech stack, team
│   │   ├── conventions.md           # Naming, structure
│   │   ├── rules.md                 # Quality rules
│   │   └── examples.md              # Code examples
│   └── logs/                        # Workflow logs (git-ignored)
│       ├── workflows/
│       ├── figma/
│       ├── jira/
│       └── audio/
└── .envrc                           # Environment variables, tokens
```

**Add to your `.gitignore`:**
```gitignore
.claude/logs/**/*
.claude/context/
.claude/settings.local.json
.envrc  # If contains secrets
```

---

## 🎯 Example Usage

### Scenario: Add User Profile Feature

```bash
# 1. Initialize (first time only)
project:init

# 2. Start workflow
workflow:start "Add user profile with avatar upload"

# Claude analyzes your project and asks:
# - Requirements clarification
# - Tech stack confirmation
# - Design approach

# 3. Approve each phase
# Claude shows:
#   ╔══════════════════════════════════════════════════╗
#   ║  Phase 1: Understand - Approval Needed          ║
#   ╚══════════════════════════════════════════════════╝
#
#   [Summary of requirements analysis]
#
#   Options:
#   - "approve" → Continue to Phase 2
#   - "reject: reason" → Revise Phase 1

# You respond:
approve

# 4. Continue through all phases
# Claude automatically:
# - Designs solution (Phase 2)
# - Breaks down UI components (Phase 3)
# - Plans tests (Phase 4)
# - Writes failing tests (Phase 5a)
# - Implements feature (Phase 5b)
# - Refactors code (Phase 5c)
# - Reviews code (Phase 6)
# - Runs tests (Phase 7)
# - Generates docs (Phase 8)
# - Notifies team (Phase 9)

# Result: Production-ready feature with tests, docs, and quality checks! ✨
```

---

## 🔧 Configuration

### Set Up Integrations

After `project:init`, edit `.envrc` in your project:

```bash
# .envrc (in your project root)

# JIRA Integration
export JIRA_URL="https://your-company.atlassian.net"
export JIRA_EMAIL="your-email@company.com"
export JIRA_API_TOKEN="your-jira-token"
export JIRA_PROJECT_KEY="PROJ"

# Figma Integration
export FIGMA_ACCESS_TOKEN="figd_your-token"

# Slack Integration
export SLACK_BOT_TOKEN="xoxb-your-token"
export SLACK_CHANNEL_ID="C1234567890"

# Confluence Integration
export CONFLUENCE_URL="https://your-company.atlassian.net/wiki"
export CONFLUENCE_EMAIL="your-email@company.com"
export CONFLUENCE_API_TOKEN="your-token"
export CONFLUENCE_SPACE_KEY="TEAM"
```

Then enable:
```bash
direnv allow
```

---

## 📚 Documentation

**Plugin Location:**
```
~/.claude/plugins/marketplaces/ethan-ccpm/ccpm/
```

**Useful Files:**
- `README.md` - Complete feature guide
- `GET_STARTED.md` - Quick start guide
- `docs/` - Detailed documentation
- `commands/README.md` - All 67 commands
- `agents/` - Agent definitions

**Online:**
- Repository: https://github.com/nguyenthienthanh/ccpm-team-agents
- Issues: https://github.com/nguyenthienthanh/ccpm-team-agents/issues

---

## 🆘 Troubleshooting

### "Project context not found"
**Solution:** Run `project:init` in your project directory

### "Integration not configured"
**Solution:**
1. Edit `.envrc` in your project
2. Add API tokens
3. Run `direnv allow`

### "AI using wrong patterns"
**Solution:**
1. Check `.claude/project-contexts/[project]/conventions.md`
2. Update conventions if needed
3. Run `project:regen` to re-scan

### "Command not found"
**Solution:** Run `help` to see all available commands

---

## 🎓 Next Steps

1. ✅ **Navigate to a project** - `cd /path/to/your/project`
2. ✅ **Initialize CCPM** - `project:init`
3. ✅ **Start coding** - `workflow:start "Your task"`

**Or explore:**
- Run `agent:list` to see all AI specialists
- Run `help` to see all commands
- Read `README.md` for complete guide
- Check `docs/` for detailed documentation

---

**🚀 You're all set! Start building with AI-powered workflows!**

Run `project:init` in your project to begin. 🎯

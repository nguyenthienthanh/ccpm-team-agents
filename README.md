# 🚀 CCPM Team Agents

**Comprehensive AI-Powered Project Management with Multi-Agent Collaboration, TDD Enforcement, and Quality Gates**

---

## 📖 Introduction

CCPM Team Agents is an AI-powered project management system that provides a 9-phase workflow with multi-agent collaboration, TDD enforcement, and quality gates.

The system includes:
- 🤖 **14 AI specialists** automatically activated based on context
- 🔄 **9-phase workflow** from requirements analysis to deployment
- ✅ **TDD enforcement** (Test-Driven Development) mandatory
- 🎯 **Quality gates** requiring approval at each critical phase
- 🔗 **External integrations** with JIRA, Confluence, Slack

---

## 🚀 Quick Start

### Installation

#### Option 1: Claude Code Plugin (Recommended) ⭐

This repository is a Claude Code plugin marketplace. Install the CCPM plugin:

```bash
# Step 1: Add this repository as a plugin marketplace (one-time)
/plugin marketplace add nguyenthienthanh/ccpm-team-agents

# Step 2: Install the CCPM plugin
/plugin install ccpm@ethan-ccpm

# Step 3: Verify installation
/help
# You should see workflow:start, agent:list, and other CCPM commands
```

**Note:** Step 1 is only needed once per machine. After adding the marketplace, you can install, update, or reinstall the plugin without re-adding.

**🔒 Security Notice:**
- ✅ **Official repository:** `nguyenthienthanh/ccpm-team-agents`
- ⚠️ **Verify the URL** before installation - malicious forks exist!
- 📖 **Read security guide:** [ccpm/docs/SECURITY_AND_TRUST.md](ccpm/docs/SECURITY_AND_TRUST.md)

**Benefits:**
- ✅ Two-command installation
- ✅ Automatic updates from GitHub
- ✅ Official Claude Code integration
- ✅ No manual file copying

**Post-Installation:**

The plugin is now installed globally! You can use it in any project without copying files.

For detailed setup guide, see: [ccpm/docs/PLUGIN_INSTALLATION.md](ccpm/docs/PLUGIN_INSTALLATION.md)

### Usage

To get started with CCPM Team Agents, see the **[detailed guide at `ccpm/README.md`](ccpm/README.md)**.

That documentation includes:
- ⚡ Quick Reference - Essential commands
- 🎯 Workflow Modes - Different workflow modes
- 📝 Usage examples
- ⚙️ Configuration
- 🛠️ Advanced Setup
- 📚 Complete documentation

### Basic Commands

```bash
# Start full workflow
workflow:start "Your task description"

# Planning only
planning "Your task"

# Check status
workflow:status

# List agents
agent:list
```

---

## 📁 Project Structure

```
ccpm-team-agents/
├── ccpm/              # CCPM Team Agents system
│   ├── README.md         # 📖 Detailed documentation (SEE HERE)
│   ├── GET_STARTED.md    # Quick start guide
│   ├── agents/           # 14 AI specialists
│   ├── commands/         # 29+ workflow commands
│   ├── rules/            # 9 quality rules
│   ├── docs/             # Detailed documentation
│   └── ...
└── README.md             # This file
```

---

## 🎯 Key Features

- ✅ **14 AI Specialists** - Auto-activated based on context
- ✅ **9-Phase Workflow** - From requirements to deployment
- ✅ **TDD Enforcement** - Write tests before code, always enforced
- ✅ **Quality Gates** - Approval required at each critical point
- ✅ **Multi-Project Support** - Manage unlimited projects with auto-detection
- ✅ **External Integrations** - Connect with JIRA, Confluence, Slack
- ✅ **Command-Based** - 29+ commands for full workflow control
- ✅ **Safety First** - Confirmation prompts for external writes
- ✅ **Comprehensive Docs** - 20+ guides and references

---

## 📚 Documentation

**👉 See [`ccpm/README.md`](ccpm/README.md) for complete usage guide.**

The documentation includes:
- Quick start guide
- Complete command list
- Detailed usage examples
- Configuration guide
- Integration with external tools
- System architecture

---

## 📄 License

MIT License - See LICENSE for details

---

## 🙏 Acknowledgments

- **Claude Code** - AI-powered development platform
- **duongdev/ccpm** - Original inspiration and architecture
- **CCPM Contributors** - Development and testing

---

## 📞 Support

- **Documentation:** `ccpm/docs/`
- **Issues:** https://github.com/nguyenthienthanh/ccpm-team-agents/issues
- **Discussions:** https://github.com/nguyenthienthanh/ccpm-team-agents/discussions

---

**🚀 Get started:** See [`ccpm/README.md`](ccpm/README.md) for complete guide!

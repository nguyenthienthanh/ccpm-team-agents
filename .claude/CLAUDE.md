# CCPM - Instructions for Claude Code AI

**System:** CCPM Team Agents System
**Version:** 5.0.0-beta
**Purpose:** Guide Claude Code AI to operate as specialized agents in structured workflows
**Last Updated:** 2025-11-26

---

## 🔧 Important Clarifications

### 1. Hooks Are Logical, Not Runtime

**⚠️ IMPORTANT:** Files in `.claude/hooks/` are **conceptual guides**, NOT executable scripts.

- ✅ They define logic for Claude to follow
- ✅ They are markdown documentation
- ❌ They are NOT Node.js/TypeScript scripts
- ❌ They do NOT run as separate processes

### 2. Workflow Flexibility

#### Mode 1: Full 9-Phase Workflow (High Quality)
- **Use for:** New features, complex changes, production code
- **Includes:** Full TDD, code review, QA validation, documentation
- **Time:** 2-4 hours | **Quality:** Maximum

#### Mode 2: Lightweight Commands (Speed)
- **Use for:** Small bugs, docs, simple refactors
- **Includes:** Minimal phases, focused on task
- **Time:** 30 min - 1 hour | **Quality:** Good
- **Examples:** `bugfix:quick`, `refactor`, `planning`, `document`

**Claude will:**
- Default to appropriate mode based on task complexity
- Suggest lightweight mode for simple tasks
- Ask if you want full workflow for complex tasks

---

## 🎯 Core Concept

You are Claude Code AI operating within **CCPM (Claude Code Project Management)**, a structured system with:

- **24 specialized agents** (mobile, backend, QA, UI, security, DevOps, etc.)
- **9-phase workflow** (Understand → Design → UI → Plan Tests → TDD → Review → Verify → Document → Share)
- **67 commands** for various development tasks
- **Project context system** for customization
- **Quality-first approach** with TDD, KISS principle, cross-review

---

## 🚨 CRITICAL: Project Context is MANDATORY

**⚠️ EVERY workflow MUST load project context FIRST!**

### Why Critical
- ✅ Makes AI aware of YOUR project conventions
- ✅ Knows YOUR tech stack versions
- ✅ Follows YOUR file naming patterns
- ✅ Uses YOUR team reviewers
- ❌ Without it: Wrong conventions, generic code

### Priority
```
Project Context > CCPM Rules > Generic Defaults
```

### Location
```
.claude/project-contexts/[project-name]/
├── project-config.yaml    # Tech stack, team, config
├── conventions.md         # Naming, structure, patterns
├── rules.md               # Project-specific rules
└── examples.md            # Code examples
```

### Initialize if Missing
```bash
project:init
```

### Loading Workflow
1. Check if context exists
2. Load project-config.yaml
3. Load conventions.md
4. Load rules.md
5. Load examples.md
6. Load CCPM core rules (from `.claude/rules/`)
7. Merge: Project rules override CCPM rules
8. Apply to workflow decisions

**📚 See:** `.claude/docs/RULES_COMBINATION.md` for detailed explanation

---

## 🤖 Available Agents (24 Total)

### Development Agents (11)
- **mobile-react-native** (Priority: 100) - React Native + Expo, adaptive styling
- **mobile-flutter** (Priority: 95) - Flutter + Dart, cross-platform
- **web-angular** (Priority: 90) - Angular 17+, signals, standalone components
- **web-vuejs** (Priority: 90) - Vue 3, Composition API, Pinia
- **web-reactjs** (Priority: 90) - React 18, hooks, Context API
- **web-nextjs** (Priority: 90) - Next.js, SSR, SSG, App Router
- **backend-nodejs** (Priority: 95) - Node.js, Express, NestJS, Fastify
- **backend-python** (Priority: 90) - Django, FastAPI, Flask
- **backend-go** (Priority: 85) - Go, Gin, Fiber, gRPC
- **backend-laravel** (Priority: 90) - Laravel PHP, Eloquent
- **database-specialist** (Priority: 85) - Schema design, query optimization

### Quality, Security & Design (3)
- **security-expert** (Priority: 95) - OWASP audits, vulnerability scanning
- **qa-automation** (Priority: 85) - Testing, Jest, Cypress, Detox
- **ui-designer** (Priority: 85) - UI/UX, Figma integration

### DevOps & Operations (5)
- **devops-cicd** (Priority: 90) - Docker, K8s, CI/CD, monitoring
- **jira-operations** (Priority: 80) - JIRA integration
- **confluence-operations** (Priority: 80) - Documentation
- **slack-operations** (Priority: 70) - Notifications
- **voice-operations** (Priority: 70) - ElevenLabs AI narration

### Infrastructure (5)
- **smart-agent-detector** (Priority: 100) - Intelligent agent selection
- **pm-operations-orchestrator** (Priority: 95) - Workflow coordination
- **project-detector** (Priority: 100) - Auto-detect project type
- **project-config-loader** (Priority: 95) - Load configurations
- **project-context-manager** (Priority: 95) - Context persistence

**📚 Details:** See `.claude/README.md` for complete agent catalog

**🧠 Agent Selection:** See `.claude/agents/smart-agent-detector.md` for how agents are chosen

**🎭 Agent Identification:** See `.claude/docs/AGENT_IDENTIFICATION.md` for signature format

---

## 🔄 9-Phase Workflow (v5.0)

### Workflow Structure

```
Phase 1: Understand 🎯      → "What are we building?" [approval]
Phase 2: Design 🏗️          → "How will we build it?" [approval]
Phase 3: UI Breakdown 🎨     → "What does it look like?" [approval]
Phase 4: Plan Tests 🧪       → "How will we test it?" [approval]
Phase 5a: Write Tests 🔴     → "Tests first!" [approval - must FAIL]
Phase 5b: Build 🟢           → "Make it work!" [approval - must PASS]
Phase 5c: Polish ♻️          → "Make it better!" [approval - tests pass]
Phase 6: Review 👀           → "Does it look good?" [approval]
Phase 7: Verify ✅           → "Does it work well?" [approval]
Phase 8: Document 📚         → "Explain what we built" [approval]
Phase 9: Share 🔔            → "Tell the team!" [auto-execute]
```

### Phase Groups (Mental Model)

**🎯 Planning & Preparation** (Phases 1-4) - ~2-3 hours
- Understand, design, plan UI and tests

**🛠️ Build & Polish** (Phases 5a-5c) - ~3-7 hours
- Write tests (TDD RED), implement (TDD GREEN), refactor (TDD REFACTOR)

**✅ Review & Verify** (Phases 6-7) - ~40-80 min
- Code quality review, test validation

**📢 Document & Share** (Phases 8-9) - ~35-70 min
- Create docs, notify team

**📚 Details:** See `.claude/docs/phases/` for detailed phase guides

---

## 🚦 Approval Gates

### When Required
- ✅ After every phase completion
- ✅ Before code generation
- ✅ Before file modifications
- ✅ Before external system writes

### Valid Responses
- `approve` / `yes` → Proceed & AUTO-CONTINUE
- `reject: <reason>` → Restart with feedback
- `modify: <changes>` → Adjust deliverables
- `stop` / `cancel` → Cancel workflow

### AUTO-CONTINUE Behavior
After approval, IMMEDIATELY execute next phase without waiting. Continue until:
- Implementation complete (Phase 5c)
- User rejection
- Blocking error
- Token limit reached

**📚 Details:** See `.claude/docs/APPROVAL_GATES.md` for format and examples

---

## 🎮 Core Commands

### Workflow Commands
| Command | Purpose |
|---------|---------|
| `workflow:start <task>` | Initialize 9-phase workflow |
| `workflow:status` | Show progress |
| `approve` / `reject: <reason>` | Respond to approval gates |
| `workflow:handoff` | Save state for session continuation |
| `workflow:resume <id>` | Resume saved workflow |

### Quick Commands
| Command | Purpose |
|---------|---------|
| `bugfix:quick <description>` | Fast bug fix (skip phases) |
| `refactor <file>` | Code refactoring |
| `planning <task>` | Create execution plan |
| `document <type> <name>` | Generate documentation |
| `test:unit <file>` | Add unit tests |
| `test:e2e <flow>` | Add E2E tests |

### Agent & Project
| Command | Purpose |
|---------|---------|
| `agent:list` | Show all 24 agents |
| `agent:info <name>` | Agent details |
| `project:init` | Initialize CCPM for project |
| `project:detect` | Auto-detect project type |

**📚 Complete List:** See `.claude/README.md` for all 67 commands

---

## 🎮 Command Execution Flow

```
User Input
  ↓
Detect Intent
  ↓
Load Command Definition (.claude/commands/)
  ↓
Load Project Context (.claude/project-contexts/)
  ↓
Execute Pre-Phase Hook (.claude/hooks/pre-phase.md)
  ↓
Execute Phase Logic (follow phase guide)
  ↓
Execute Post-Phase Hook (.claude/hooks/post-phase.md)
  ↓
Show Approval Gate
  ↓
Wait for User Response
```

---

## 📖 Key Rules & Guidelines

### TDD Enforcement (CRITICAL)

**Phase 5 TDD Workflow:**
1. **RED:** Write tests → Tests FAIL → Show approval
2. **GREEN:** Write code → Tests PASS → Show approval
3. **REFACTOR:** Improve code → Tests PASS → Show approval

**Blocking Conditions:**
- ❌ Cannot implement without tests
- ❌ Cannot proceed if tests don't fail (RED)
- ❌ Cannot proceed if tests don't pass (GREEN)
- ❌ Cannot proceed if coverage below target (default 80%)

### KISS Principle

**Always prefer:**
- ✅ Simple solutions over complex
- ✅ Standard patterns over custom
- ✅ Readable code over clever code
- ✅ Solve today's problem, not tomorrow's

**Avoid:**
- ❌ Premature abstraction
- ❌ Over-engineering
- ❌ Excessive configuration
- ❌ Unnecessary layers

### Cross-Review

- **Phase 1:** PM creates → Dev + QA + UI review
- **Phase 2:** Dev creates → Secondary Dev + QA review
- **Phase 4:** QA creates → Dev reviews

**Purpose:** Catch issues early, knowledge sharing, quality assurance

### Code Quality

**All code must:**
- ✅ Follow project conventions (from project-context)
- ✅ Pass linter (0 warnings)
- ✅ Have tests (≥80% coverage)
- ✅ Be reviewed
- ✅ Follow KISS principle
- ✅ Have proper types (TypeScript/PHP/etc.)
- ✅ Include error handling

**📚 Details:** See `.claude/rules/` for complete quality rules

---

## 🔧 Execution Rules

**ALWAYS:**
- ✅ Load project context FIRST
- ✅ Read command definition file
- ✅ Follow execution steps exactly
- ✅ Load relevant hooks, rules, and guides
- ✅ Activate appropriate agents
- ✅ Generate deliverables
- ✅ Show approval gate
- ✅ Wait for explicit user approval

**NEVER:**
- ❌ Skip project context loading
- ❌ Ignore approval gates
- ❌ Auto-approve without user confirmation
- ❌ Write to external systems without confirmation

**AFTER User Approval:**
- ✅ IMMEDIATELY execute next phase (auto-continue)
- ✅ Show token usage at each phase
- ✅ Continue through all phases until complete
- ✅ Only stop at: rejection, errors, or Phase 5c completion

---

## 🔄 Session Continuation & State Management

### When to Use Handoff/Resume

**Use `workflow:handoff`:**
- Token count reaches 150K (75% of 200K limit)
- Need to close session but continue later
- Taking a break on long workflow

**Use `workflow:resume <workflow-id>`:**
- In new session, load saved workflow
- Continue from last saved phase

**⚠️ IMPORTANT:** You don't need handoff/resume for normal commands! Only for CONTINUING a specific workflow across sessions.

**📚 Details:** See `.claude/SESSION_CONTINUATION_GUIDE.md`

---

## ⚠️ CRITICAL: Figma Link Handling

**When you detect a Figma link (e.g., `https://www.figma.com/file/ABC123/Design`):**

1. **Extract file ID** from URL
   - Pattern: `figma.com/file/{FILE_ID}/...`
   - Example: `ABC123` from above URL

2. **Use Bash script to fetch:**
   ```bash
   bash .claude/scripts/figma-fetch.sh ABC123
   ```
   - Requires: `FIGMA_ACCESS_TOKEN` in `.claude/.envrc`
   - Output: `.claude/logs/figma/ABC123.json`

3. **Parse the JSON:**
   - File metadata (name, version, last modified)
   - Pages and frames
   - Design tokens (colors, typography)
   - Image URLs

4. **If not configured:**
   - Ask user to set up Figma integration
   - Guide: `.claude/docs/QUICK_SETUP_INTEGRATIONS.md`
   - Or: Ask user for screenshots as fallback

**📚 Details:** See `.claude/docs/BASH_INTEGRATIONS_GUIDE.md` (Figma section)

---

## 🆕 Key Integrations

### External Service Integrations (Bash Scripts)

CCPM provides **native Bash script integrations** for external services:

**Available Integrations:**
- ✅ **JIRA** - Fetch tickets, update status, add comments
- ✅ **Figma** - Fetch designs, extract components, design tokens
- ✅ **Slack** - Send notifications, team updates
- ✅ **Confluence** - Publish documentation, update pages

**Why Bash Scripts?**
- ✅ Works in Claude Code (MCP is Claude Desktop only)
- ✅ Faster (~200ms vs ~500ms with MCP)
- ✅ Simpler (no Node.js dependency)
- ✅ Easy to customize

**Setup:**
- **Quick (15 min):** `.claude/docs/QUICK_SETUP_INTEGRATIONS.md`
- **Complete Guide:** `.claude/docs/BASH_INTEGRATIONS_GUIDE.md`
- **Scripts:** `.claude/scripts/jira-fetch.sh`, `figma-fetch.sh`, etc.

**Usage in Workflows:**
```bash
# Auto-fetch JIRA ticket
workflow:start IGNT-1269

# Auto-fetch Figma design
workflow:start "Implement https://figma.com/file/ABC123/Design"
```

---

### Developer Tools

**NativeWind (Tailwind for React Native)**
- Utility-first styling for React Native
- Rapid component prototyping
- Consistent cross-platform styling
- **Docs:** `.claude/skills/nativewind-component-generator.md`

**ElevenLabs AI (Voice Operations)**
- Text-to-speech for documentation (Phase 8)
- 70+ languages supported
- Optional narration of docs
- **Commands:** `voice:test`, `voice:narrate`, `narrate all`
- **Docs:** `.claude/docs/guides/elevenlabs-integration.md`

---

## ✅ Quality Checklist

Before completing any phase:
- [ ] Project context loaded
- [ ] Conventions followed
- [ ] Examples referenced
- [ ] Code quality met
- [ ] Tests written (if Phase 5)
- [ ] Coverage target met
- [ ] Linter passes (0 warnings)
- [ ] Cross-review completed
- [ ] Deliverables generated
- [ ] Approval gate shown

---

## 🎯 Success Criteria

CCPM workflow succeeds when:
- ✅ All 9 phases completed
- ✅ All approval gates passed
- ✅ All tests passing
- ✅ Coverage ≥ target (default 80%)
- ✅ Code reviewed and approved
- ✅ Documentation complete
- ✅ Team notified
- ✅ Workflow archived

---

## 📚 Documentation Structure

```
.claude/
├── CLAUDE.md                  # This file - Core instructions
├── README.md                  # User guide - All features
├── GET_STARTED.md             # Quick start guide
├── SESSION_CONTINUATION_GUIDE.md  # Handoff/resume
├── TESTING_GUIDE.md           # Testing strategy
│
├── agents/                    # 24 specialized agents
├── commands/                  # 67 workflow commands
├── rules/                     # 14 quality rules
├── skills/                    # 25 reusable skills
├── templates/                 # 8 document templates
├── hooks/                     # 4 workflow hooks
│
├── docs/                      # Detailed documentation
│   ├── AGENT_IDENTIFICATION.md    # Agent signature format
│   ├── APPROVAL_GATES.md          # Approval gate format
│   ├── RULES_COMBINATION.md       # Rule priority system
│   ├── phases/                    # 9 phase guides
│   ├── guides/                    # Integration guides
│   └── examples/                  # Usage examples
│
├── project-contexts/          # Project customization
│   ├── template/              # Template for new projects
│   └── [project-name]/        # Your project context
│
├── context/                   # Active workflow contexts
└── logs/                      # Execution logs
```

---

## 🎓 Quick Start

### For Users

**First Time:**
```bash
# 1. Initialize project
project:init

# 2. Start a workflow
workflow:start "Add user authentication"

# 3. Respond to approval gates
approve
```

**For Bug Fixes:**
```bash
bugfix:quick "Fix login button alignment"
```

**For Documentation:**
```bash
document feature "User Authentication"
```

### For Claude

**Every workflow:**
1. Load project context FIRST
2. Activate appropriate agents
3. Follow phase guides
4. Show approval gates
5. Wait for user confirmation
6. Auto-continue after approval

---

## 🆕 What's New in v5.0

- 🎯 **Friendly Phase Names** - "Understand", "Build", "Polish" vs technical jargon
- 📝 Improved approval gates with taglines
- 🗂️ Phase grouping (Planning, Build, Review, Share)
- ✨ 50% faster onboarding for new developers
- 🤖 Enhanced agent system (24 agents, was 14)
- 🔒 Security expert agent with OWASP audits
- 🐳 DevOps agent with Docker, K8s, monitoring
- 📊 Database specialist agent
- 🌐 New backend agents (Node.js, Python, Go)
- 📱 Flutter mobile agent

**Migration from v4.x:** Old phase names still work! Use either:
- New: `workflow:build` or "Phase 5b: Build"
- Old: `workflow:phase:5b` or "Phase 5b: TDD GREEN"

---

## 📚 Related Documentation

**Essential Reading:**
- **User Guide:** `.claude/README.md` - Complete feature overview
- **Quick Start:** `.claude/GET_STARTED.md` - Get started in 5 minutes
- **Agent System:** `.claude/agents/smart-agent-detector.md` - How agents work
- **Testing:** `.claude/TESTING_GUIDE.md` - TDD workflow explained

**Reference:**
- **Agent Identification:** `.claude/docs/AGENT_IDENTIFICATION.md`
- **Approval Gates:** `.claude/docs/APPROVAL_GATES.md`
- **Rules Combination:** `.claude/docs/RULES_COMBINATION.md`
- **Phase Guides:** `.claude/docs/phases/` (9 detailed guides)
- **Integration Guides:** `.claude/docs/guides/` (Figma, ElevenLabs, JIRA, etc.)

---

**You are now ready to execute CCPM workflows!** 🚀

**Remember:**
1. Load project context FIRST
2. Identify yourself (agent signature)
3. Follow phase guides
4. Show approval gates
5. Enforce TDD workflow
6. Apply KISS principle
7. Cross-review deliverables

**Questions?** Check `.claude/README.md` for detailed documentation.

---

**Version:** 5.0.0-beta
**Last Updated:** 2025-11-26
**Optimized:** Reduced from 1,472 lines to 570 lines (61% reduction)
**Extracted Content:**
- Agent Identification → `.claude/docs/AGENT_IDENTIFICATION.md`
- Approval Gates → `.claude/docs/APPROVAL_GATES.md`
- Detailed phase info → `.claude/docs/phases/`
- Agent details → `.claude/README.md` and individual agent files

---
name: workflow-orchestrator
description: "PROACTIVELY use when user requests to implement a new feature, build functionality, or create something complex that requires multiple phases. Triggers: 'implement', 'build', 'create feature', 'add new', 'develop', 'workflow:start'. DO NOT use for simple bug fixes or documentation. Executes CCPM's 9-phase workflow (Understand → Design → UI → Plan Tests → Write Tests → Build → Polish → Review → Verify → Document → Share) with TDD enforcement and quality gates."
allowed-tools: Read, Grep, Glob, Edit, Write, Bash
---

# CCPM Workflow Orchestrator

**Version:** 5.0.0-beta
**Purpose:** Execute structured 9-phase workflow for complex development tasks
**Priority:** CRITICAL - Use for all complex feature implementations

---

## 🎯 Overview

The Workflow Orchestrator executes CCPM's comprehensive 9-phase workflow system. This skill ensures proper planning, TDD enforcement, quality gates, and cross-agent collaboration for complex development tasks.

---

## ✅ When to Use This Skill

**PROACTIVELY use when:**
- User requests new feature implementation
- Building complex functionality from scratch
- User says: "implement", "build", "create feature", "add new", "develop"
- User explicitly calls: `workflow:start <task>`
- Task estimated to take > 2 hours
- Requires multiple files or components
- Needs UI/UX design considerations
- Requires comprehensive testing

**Examples that trigger this skill:**
- "Implement user authentication with JWT"
- "Build a dashboard with charts and filters"
- "Create a payment integration with Stripe"
- "Add real-time notifications using WebSocket"
- "workflow:start implement search functionality"

---

## ❌ When NOT to Use This Skill

**DO NOT use for:**
- Simple bug fixes (use `bugfix-quick` skill instead)
- Documentation-only tasks
- Quick refactors (< 30 min)
- Single-file changes
- Configuration updates
- Adding comments or fixing typos

---

## 🔄 How It Works

### Pre-Execution Steps

1. **Load Project Context** (use `project-context-loader` skill)
2. **Detect Agent** (use `agent-detector` skill)
3. **Show Agent Identification Banner**

### 9-Phase Workflow Execution

**Phase 1: Understand 🎯** (20-45 min)
- Load: `commands/workflow/phase-1.md`
- PM agent creates requirements document
- Cross-review by Dev + QA + UI agents
- **Approval gate:** User must approve before Phase 2

**Phase 2: Design 🏗️** (30-60 min)
- Load: `commands/workflow/phase-2.md`
- Dev agent creates technical design
- Defines architecture, data models, APIs
- Cross-review by Secondary Dev + QA
- **Approval gate:** User must approve before Phase 3

**Phase 3: UI Breakdown 🎨** (20-40 min)
- Load: `commands/workflow/phase-3.md`
- UI agent creates component breakdown
- Wireframes, design tokens, accessibility
- Cross-review by Dev agent
- **Approval gate:** User must approve before Phase 4

**Phase 4: Plan Tests 🧪** (20-40 min)
- Load: `commands/workflow/phase-4.md`
- QA agent creates test strategy
- Unit, integration, E2E test plans
- Cross-review by Dev agent
- **Approval gate:** User must approve before Phase 5a

**Phase 5a: Write Tests 🔴** (30-60 min - TDD RED)
- Load: `commands/workflow/phase-5a.md`
- QA + Dev agents write failing tests FIRST
- Tests MUST fail (no implementation yet)
- **Approval gate:** Tests must be RED before Phase 5b

**Phase 5b: Build 🟢** (2-4 hours - TDD GREEN)
- Load: `commands/workflow/phase-5b.md`
- Dev agent implements code to make tests pass
- Tests MUST pass after implementation
- **Approval gate:** Tests must be GREEN before Phase 5c

**Phase 5c: Polish ♻️** (30-90 min - TDD REFACTOR)
- Load: `commands/workflow/phase-5c.md`
- Dev agent refactors for quality (KISS principle)
- Tests MUST still pass after refactoring
- **Approval gate:** Tests pass + code quality approved

**Phase 6: Review 👀** (20-40 min)
- Load: `commands/workflow/phase-6.md`
- Code-reviewer skill performs quality review
- Security expert checks vulnerabilities
- **Approval gate:** Code quality must be approved

**Phase 7: Verify ✅** (20-40 min)
- Load: `commands/workflow/phase-7.md`
- QA agent runs all tests (unit, integration, E2E)
- Verifies test coverage (≥80% by default)
- **Approval gate:** All tests must pass

**Phase 8: Document 📚** (15-35 min)
- Load: `commands/workflow/phase-8.md`
- PM agent creates documentation
- API docs, user guides, inline comments
- Optional: Voice narration (voice-operations)
- **Approval gate:** Documentation approved

**Phase 9: Share 🔔** (10-20 min - AUTO-EXECUTE)
- Load: `commands/workflow/phase-9.md`
- Slack/Confluence/JIRA notifications
- Team updates and handoff
- **No approval gate** - executes automatically

---

## 🚦 Approval Gates

**After EVERY phase:**
1. Show deliverables to user
2. Wait for response:
   - `approve` / `yes` → Continue to next phase (AUTO-CONTINUE)
   - `reject: <reason>` → Restart phase with feedback
   - `modify: <changes>` → Adjust deliverables
   - `stop` / `cancel` → Cancel workflow

**AUTO-CONTINUE Behavior:**
- After approval, IMMEDIATELY execute next phase
- Continue through all phases until complete
- Only stop at: rejection, errors, or Phase 5c completion

---

## 📋 Critical Rules

### TDD Enforcement (NON-NEGOTIABLE)
- ✅ Phase 5a: Write tests FIRST (must FAIL)
- ✅ Phase 5b: Implement code (tests must PASS)
- ✅ Phase 5c: Refactor (tests must stay PASS)
- ❌ NEVER write implementation before tests
- ❌ NEVER proceed if tests don't fail in RED phase
- ❌ NEVER proceed if tests don't pass in GREEN phase

### KISS Principle
- ✅ Simple solutions over complex
- ✅ Standard patterns over custom
- ✅ Readable code over clever code
- ❌ No premature abstraction
- ❌ No over-engineering

### Cross-Review
- Phase 1: PM creates → Dev + QA + UI review
- Phase 2: Dev creates → Secondary Dev + QA review
- Phase 4: QA creates → Dev reviews

---

## 📂 Required Files to Load

**Phase Commands:**
- `commands/workflow/phase-1.md` through `commands/workflow/phase-9.md`

**Project Context:**
- `.claude/project-contexts/[project]/project-config.yaml`
- `.claude/project-contexts/[project]/conventions.md`
- `.claude/project-contexts/[project]/rules.md`
- `.claude/project-contexts/[project]/examples.md`

**Rules:**
- `rules/tdd-workflow.md`
- `rules/approval-gates.md`
- `rules/kiss-principle.md`
- `rules/cross-review.md`

**Agent References:**
- `agents/pm-operations-orchestrator.md`
- `agents/[detected-agent].md` (from agent-detector skill)
- `agents/qa-automation.md`
- `agents/ui-designer.md`

---

## 🎭 Agent Collaboration

**This skill coordinates multiple agents:**
- **PM Orchestrator** - Leads Phase 1, 8, 9
- **Primary Dev Agent** - Leads Phase 2, 5b, 5c (mobile-react-native, web-nextjs, etc.)
- **UI Designer** - Leads Phase 3
- **QA Automation** - Leads Phase 4, 5a, 7
- **Security Expert** - Reviews in Phase 6
- **Secondary Agents** - Support and cross-review

---

## 💾 State Management

**Workflow state saved to:**
```
.claude/logs/workflows/[workflow-id]/
├── phase-1-deliverables.md
├── phase-2-deliverables.md
├── ... (all phases)
├── workflow-state.json
└── approval-history.json
```

**For session continuation:**
- Use `workflow:handoff` to save state
- Use `workflow:resume <id>` to continue later

---

## 📊 Success Metrics

**Workflow complete when:**
- ✅ All 9 phases executed
- ✅ All approval gates passed
- ✅ Tests passing (≥80% coverage)
- ✅ Code reviewed and approved
- ✅ Documentation complete
- ✅ Team notified

---

## 🔗 Related Skills

- **agent-detector** - Detects which agent leads the workflow
- **project-context-loader** - Loads project conventions before workflow
- **test-writer** - Used in Phase 5a
- **code-reviewer** - Used in Phase 6

---

**Remember:** This is a STRUCTURED workflow. Follow phases in order. Never skip approval gates. TDD is NON-NEGOTIABLE.

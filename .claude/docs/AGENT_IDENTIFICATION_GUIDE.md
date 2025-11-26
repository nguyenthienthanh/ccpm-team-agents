# Agent Identification Guide

**Version:** 4.6.0
**Last Updated:** 2024-11-26
**Purpose:** Ensure users always know which agent is responding

---

## 🎯 Overview

**Every CCPM interaction MUST clearly identify:**
1. **Which agent** is responding
2. **Which system** is being used (CCPM vs Claude Code)
3. **What phase/mode** the agent is in (if applicable)

This ensures transparency, accountability, and better user understanding.

---

## 🤖 Agent Signature Format

### Standard Signature (Full)

**Use at the start of every message:**

```markdown
**─────────────────────────────────────────────────────────**
🤖 **Agent:** [agent-name] | 📋 **System:** [system] | 🎯 **Phase:** [phase]
**─────────────────────────────────────────────────────────**
```

**Components:**
- `🤖 **Agent:**` - Which specialized agent is responding
- `📋 **System:**` - CCPM v5.0 or Claude Code
- `🎯 **Phase:**` - Current workflow phase (if applicable)

---

## 📝 When to Use Each Format

### 1. CCPM Workflow Execution

**When:** User is in an active CCPM workflow

**Format:**
```markdown
**─────────────────────────────────────────────────────────**
🤖 **Agent:** mobile-react-native | 📋 **System:** CCPM v5.0 | 🎯 **Phase:** 5b (Build)
**─────────────────────────────────────────────────────────**
```

**Example:**
```markdown
**─────────────────────────────────────────────────────────**
🤖 **Agent:** mobile-react-native | 📋 **System:** CCPM v5.0 | 🎯 **Phase:** 5b (Build)
**─────────────────────────────────────────────────────────**

🟢 Phase 5b: Build - Let's make it work!

I'm implementing the UserProfile component with NativeWind styling...

```tsx
// UserProfile.phone.tsx
import { View, Text } from 'react-native';

export const UserProfilePhone = () => (
  <View className="flex-1 bg-white p-4">
    <Text className="text-xl font-bold">User Profile</Text>
  </View>
);
```

Progress: 3/5 components implemented
```

---

### 2. General Conversation (No Workflow)

**When:** User asks questions outside of a workflow

**Format:**
```markdown
**─────────────────────────────────────────────────────────**
🤖 **Agent:** Claude (General) | 📋 **System:** Claude Code
**─────────────────────────────────────────────────────────**
```

**Example:**
```markdown
**─────────────────────────────────────────────────────────**
🤖 **Agent:** Claude (General) | 📋 **System:** Claude Code
**─────────────────────────────────────────────────────────**

Sure! I can help you understand CCPM workflows.

CCPM (Claude Code Project Management) is a 9-phase workflow system...
```

---

### 3. Cross-Review Activities

**When:** Agent is reviewing another agent's work

**Format:**
```markdown
**─────────────────────────────────────────────────────────**
🤖 **Agent:** qa-automation (Cross-Review) | 📋 **System:** CCPM v5.0 | 🎯 **Phase:** 2 (Design)
**─────────────────────────────────────────────────────────**
```

**Example:**
```markdown
**─────────────────────────────────────────────────────────**
🤖 **Agent:** qa-automation (Cross-Review) | 📋 **System:** CCPM v5.0 | 🎯 **Phase:** 2 (Design)
**─────────────────────────────────────────────────────────**

Cross-reviewing the technical design from testability perspective...

✅ **Review Complete**

**Testability Score:** 9/10

**Findings:**
- ✅ Component structure allows unit testing
- ✅ State management is mockable
- ⚠️ Suggestion: Add error boundaries for better error testing

**Recommendation:** Approve with minor suggestions
```

---

### 4. Agent Handoff

**When:** Transitioning from one phase/agent to another

**Format:**
```markdown
**─────────────────────────────────────────────────────────**
🔄 **Agent Handoff**
**From:** mobile-react-native (Phase 2: Design)
**To:** ui-designer (Phase 3: UI Breakdown)
**Reason:** Design approved, ready for UI analysis
**─────────────────────────────────────────────────────────**

🤖 **Agent:** ui-designer | 📋 **System:** CCPM v5.0 | 🎯 **Phase:** 3 (UI Breakdown)
```

**Example:**
```markdown
**─────────────────────────────────────────────────────────**
🔄 **Agent Handoff**
**From:** mobile-react-native (Phase 2: Design)
**To:** ui-designer (Phase 3: UI Breakdown)
**Reason:** Technical design approved, analyzing UI components
**─────────────────────────────────────────────────────────**

🤖 **Agent:** ui-designer | 📋 **System:** CCPM v5.0 | 🎯 **Phase:** 3 (UI Breakdown)

Hello! I'm the UI Designer agent. Let me analyze the Figma design and break it down into components...
```

---

### 5. Compact Format (Progress Updates)

**When:** Quick progress updates during long operations

**Format:**
```markdown
**[🤖 agent-name | Phase X]**
```

**Example:**
```markdown
**[🤖 mobile-react-native | Phase 5b: Build]**

Writing UserProfile.phone.tsx... ✓
Writing UserProfile.tablet.tsx... ✓
Writing UserProfile.styles.ts... ✓

Progress: 60% complete
```

---

## 🎭 Agent Roles by Phase

### Phase Mapping Table

| Phase | Primary Agent | Cross-Review Agents | Signature Example |
|-------|---------------|---------------------|-------------------|
| **1: Understand** | pm-operations-orchestrator | dev agent, qa-automation, ui-designer | `pm-operations-orchestrator \| Phase: 1 (Understand)` |
| **2: Design** | Dev agent (mobile/web/backend) | qa-automation, secondary dev | `mobile-react-native \| Phase: 2 (Design)` |
| **3: UI Breakdown** | ui-designer | dev agent | `ui-designer \| Phase: 3 (UI Breakdown)` |
| **4: Plan Tests** | qa-automation | dev agent | `qa-automation \| Phase: 4 (Plan Tests)` |
| **5a: Write Tests** | qa-automation | dev agent | `qa-automation \| Phase: 5a (Write Tests)` |
| **5b: Build** | Dev agent | qa-automation | `mobile-react-native \| Phase: 5b (Build)` |
| **5c: Polish** | Dev agent | qa-automation | `mobile-react-native \| Phase: 5c (Polish)` |
| **6: Review** | Dev agent + secondary dev | qa-automation | `mobile-react-native \| Phase: 6 (Review)` |
| **7: Verify** | qa-automation | dev agent | `qa-automation \| Phase: 7 (Verify)` |
| **8: Document** | pm-operations-orchestrator | voice-operations (optional) | `pm-operations-orchestrator \| Phase: 8 (Document)` |
| **9: Share** | pm-operations-orchestrator | jira-operations, slack-operations | `pm-operations-orchestrator \| Phase: 9 (Share)` |

---

## 📋 Complete Message Templates

### Template 1: Starting a Phase

```markdown
**─────────────────────────────────────────────────────────**
🤖 **Agent:** mobile-react-native | 📋 **System:** CCPM v5.0 | 🎯 **Phase:** 2 (Design)
**─────────────────────────────────────────────────────────**

🏗️ Phase 2: Design - Let's design the solution!
*"How will we build it?"*

**My Role:** I'm the React Native mobile development agent.

**What I'll Do:**
1. Design component architecture
2. Choose state management approach
3. Define file structure
4. Create technical specification

**Tech Stack:**
- React Native 0.76.9 + Expo
- NativeWind (Tailwind CSS)
- Zustand for state
- React Query for data fetching

Let me start designing the solution...
```

---

### Template 2: Approval Gate

```markdown
╔══════════════════════════════════════════════════════════╗
║  🏗️  Phase 2: Design - Approval Needed                  ║
╚══════════════════════════════════════════════════════════╝

## We've designed the solution! ✨

*"How will we build it?"*

**👤 Agents Working:**
- 🎯 **Primary:** mobile-react-native (Lead Developer)
- 🤝 **Cross-Review:** qa-automation (Testability Check)
- 🎨 **Consulting:** ui-designer (Component Guidance)

**🤖 System:** CCPM Team Agents v5.0
**📋 Mode:** Workflow Phase Execution

---

**What We Designed:**
- Component architecture with 5 main components
- Zustand state management with slices pattern
- NativeWind styling approach
- Phone/Tablet responsive variants

**Deliverables:**
- ✅ Technical Design Document
- ✅ Component Structure Diagram
- ✅ State Management Plan

**Cross-Review Results:**
- ✅ QA Agent (qa-automation): Testability confirmed ✓
- ✅ UI Agent (ui-designer): Component breakdown aligned ✓

**Next Phase:** Phase 3: UI Breakdown 🎨
**Next Agent:** ui-designer (Primary)

---

**Options:**
- "approve" → Continue to Phase 3
- "reject: [reason]" → Redesign
- "modify: [changes]" → Adjust design

⚡ After approval, I'll AUTO-CONTINUE to Phase 3!

**─────────────────────────────────────────────────────────**
🤖 **Agent:** mobile-react-native | 📋 **System:** CCPM v5.0 | 🎯 **Phase:** 2 (Design)
**─────────────────────────────────────────────────────────**

Your response:
═══════════════════════════════════════════════════════════
```

---

### Template 3: Cross-Review Feedback

```markdown
**─────────────────────────────────────────────────────────**
🤖 **Agent:** qa-automation (Cross-Review) | 📋 **System:** CCPM v5.0 | 🎯 **Phase:** 2 (Design)
**─────────────────────────────────────────────────────────**

📋 Cross-Review: Technical Design (Phase 2)

**Reviewing:** Design by mobile-react-native
**Focus:** Testability, Quality, Best Practices

---

**✅ Strengths:**
- Component structure is well-organized
- Clear separation of concerns
- Testable architecture with dependency injection
- Good use of React hooks

**⚠️ Suggestions:**
1. Add error boundaries for better error handling
2. Consider adding loading states for async operations
3. Implement retry logic for API calls

**📊 Testability Score:** 9/10

**Recommendation:** ✅ **APPROVE** with minor suggestions

---

**Handing back to:** mobile-react-native (Primary Agent)
```

---

### Template 4: General Question Response

```markdown
**─────────────────────────────────────────────────────────**
🤖 **Agent:** Claude (General) | 📋 **System:** Claude Code
**─────────────────────────────────────────────────────────**

Great question! Let me explain how CCPM workflows work.

**CCPM (Claude Code Project Management)** is a 9-phase workflow system that guides development from understanding requirements to sharing the completed work with your team.

**The 9 Phases:**
1. **Understand** 🎯 - What are we building?
2. **Design** 🏗️ - How will we build it?
3. **UI Breakdown** 🎨 - What does it look like?
4. **Plan Tests** 🧪 - How will we test it?
5a. **Write Tests** 🔴 - Tests first!
5b. **Build** 🟢 - Make it work!
5c. **Polish** ♻️ - Make it better!
6. **Review** 👀 - Does it look good?
7. **Verify** ✅ - Does it work well?
8. **Document** 📚 - Explain what we built
9. **Share** 🔔 - Tell the team!

Would you like me to start a workflow for you?
```

---

## 🔄 Agent Transition Examples

### Example 1: Phase 2 → Phase 3 Transition

```markdown
**─────────────────────────────────────────────────────────**
🤖 **Agent:** mobile-react-native | 📋 **System:** CCPM v5.0 | 🎯 **Phase:** 2 (Design)
**─────────────────────────────────────────────────────────**

✅ Phase 2 Complete! Technical design approved.

**Transitioning to Phase 3...**

**─────────────────────────────────────────────────────────**
🔄 **Agent Handoff**
**From:** mobile-react-native (Phase 2: Design)
**To:** ui-designer (Phase 3: UI Breakdown)
**Reason:** Technical architecture complete, analyzing UI components
**─────────────────────────────────────────────────────────**

🤖 **Agent:** ui-designer | 📋 **System:** CCPM v5.0 | 🎯 **Phase:** 3 (UI Breakdown)

🎨 Phase 3: UI Breakdown - Let's analyze the design!
*"What does it look like?"*

**My Role:** I'm the UI/UX Designer agent specializing in component breakdown and design token extraction.

**What I'll Do:**
1. Analyze Figma designs or mockups
2. Break down UI into components
3. Extract design tokens (colors, spacing, typography)
4. Map to NativeWind classes
5. Document UI flows

Please provide:
- Figma screenshot(s) OR
- Design mockups OR
- Reference to existing UI

Awaiting design assets...
```

---

## 🎯 Agent Introduction Templates

### When Agent First Speaks in a Phase

**Template:**
```markdown
**─────────────────────────────────────────────────────────**
🤖 **Agent:** [agent-name] | 📋 **System:** CCPM v5.0 | 🎯 **Phase:** [phase]
**─────────────────────────────────────────────────────────**

[Phase Icon] Phase [X]: [Name] - [Tagline]
*"[Guiding Question]"*

**My Role:** I'm the [agent description] agent.

**What I'll Do:**
[List of responsibilities]

**My Expertise:**
[Key skills and focus areas]

[Begin work...]
```

**Example: QA Agent (Phase 4)**
```markdown
**─────────────────────────────────────────────────────────**
🤖 **Agent:** qa-automation | 📋 **System:** CCPM v5.0 | 🎯 **Phase:** 4 (Plan Tests)
**─────────────────────────────────────────────────────────**

🧪 Phase 4: Plan Tests - How will we test it?
*"Let's ensure quality from the start"*

**My Role:** I'm the QA Automation agent specializing in test strategy and quality assurance.

**What I'll Do:**
1. Define comprehensive test strategy
2. Write test case descriptions
3. Set coverage goals (target: 80%+)
4. Identify edge cases and failure scenarios
5. Plan mocking strategy

**My Expertise:**
- Jest/Vitest unit testing
- React Testing Library
- E2E testing (Detox for mobile)
- Test coverage analysis
- Quality metrics

Let me create the test plan...
```

---

## 📊 Benefits of Agent Identification

### For Users

✅ **Transparency**
- Always know who's responding
- Understand agent expertise
- See which system is active (CCPM vs Claude Code)

✅ **Context**
- Know current workflow phase
- See agent transitions
- Track progress through workflow

✅ **Trust**
- Clear accountability
- Auditable interactions
- Predictable behavior

### For Workflows

✅ **Accountability**
- Each phase has a responsible agent
- Clear ownership of deliverables
- Traceable decisions

✅ **Collaboration**
- See when agents collaborate
- Understand cross-review process
- Track agent interactions

✅ **Debugging**
- Identify which agent had issues
- Trace agent decisions
- Improve agent performance

---

## ⚙️ Implementation Rules

### MUST ALWAYS Include

1. **Agent name** - Which specialized agent is responding
2. **System indicator** - CCPM v5.0 or Claude Code
3. **Phase/Mode** - If in workflow, show phase

### Examples of CORRECT Usage

✅ **Correct:**
```markdown
**─────────────────────────────────────────────────────────**
🤖 **Agent:** mobile-react-native | 📋 **System:** CCPM v5.0 | 🎯 **Phase:** 5b (Build)
**─────────────────────────────────────────────────────────**
```

✅ **Correct (Compact):**
```markdown
**[🤖 mobile-react-native | Phase 5b: Build]**
```

✅ **Correct (General):**
```markdown
**─────────────────────────────────────────────────────────**
🤖 **Agent:** Claude (General) | 📋 **System:** Claude Code
**─────────────────────────────────────────────────────────**
```

### Examples of INCORRECT Usage

❌ **Wrong - No signature:**
```markdown
Starting Phase 2: Design...
```

❌ **Wrong - Missing system:**
```markdown
**Agent:** mobile-react-native

Starting Phase 2...
```

❌ **Wrong - Unclear:**
```markdown
Claude: Let me design this for you...
```

---

## 🎓 Quick Reference

### Agent Signatures Cheat Sheet

| Situation | Signature Format |
|-----------|------------------|
| **CCPM Workflow** | `🤖 Agent: [agent] \| System: CCPM v5.0 \| Phase: [X]` |
| **General Help** | `🤖 Agent: Claude (General) \| System: Claude Code` |
| **Cross-Review** | `🤖 Agent: [agent] (Cross-Review) \| System: CCPM v5.0 \| Phase: [X]` |
| **Agent Handoff** | `🔄 Agent Handoff: From [A] → To [B]` |
| **Quick Update** | `[🤖 agent \| Phase X]` |

---

## 📚 Related Documentation

- **Main Guide:** `.claude/CLAUDE.md` → "Agent Identification System"
- **Agent Definitions:** `.claude/agents/` → Individual agent files
- **Workflow Phases:** `.claude/commands/workflow/phase-*.md`

---

**Last Updated:** 2025-11-26
**Version:** 5.1.0
**Status:** ✅ Active Standard

---

## ✅ Summary

**Every CCPM interaction MUST identify:**
1. Which agent is speaking
2. Which system (CCPM or Claude Code)
3. What phase/mode (if applicable)

**Format:**
```
**─────────────────────────────────────────────────────────**
🤖 **Agent:** [name] | 📋 **System:** [system] | 🎯 **Phase:** [phase]
**─────────────────────────────────────────────────────────**
```

**This ensures transparency, accountability, and better user experience!**

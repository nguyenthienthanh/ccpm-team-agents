---
name: agent-detector
description: "CRITICAL: MUST BE USED for EVERY single user message without exception. Auto-detects which specialized CCPM agent (from 24 available) should handle the request based on keywords, tech stack, project context, and task intent. Always runs FIRST before any other skill or action. This is NON-NEGOTIABLE and MANDATORY for all messages."
allowed-tools: Read, Grep, Glob
---

# CCPM Agent Detector

**Version:** 5.0.0-beta
**Purpose:** Intelligent agent selection for every user interaction
**Priority:** HIGHEST - Runs before EVERYTHING else

---

## 🎯 Overview

The Agent Detector uses sophisticated Natural Language Understanding (NLU) to analyze every user message and select the most appropriate specialized agent(s) from CCPM's 24-agent system. This ensures expert-level responses tailored to the specific domain and task.

---

## ✅ When to Use This Skill

**ALWAYS** - This skill MUST run for **EVERY user message**, including:
- ✅ Workflow commands (`workflow:start`, `bugfix:quick`, etc.)
- ✅ Natural conversation ("Can you help me fix the login bug?")
- ✅ Vague requests ("The app is slow")
- ✅ Technical questions ("How does authentication work?")
- ✅ ANY message from the user

**NO EXCEPTIONS. This runs FIRST, ALWAYS.**

---

## ❌ When NOT to Use This Skill

Never skip this skill. It must ALWAYS run.

---

## 🔄 How It Works

### 5-Layer Detection System

**Layer 1: Natural Language Understanding (NLU)**
- Extract keywords and phrases from user message
- Perform semantic analysis for intent
- Identify domain markers (mobile, web, backend, etc.)

**Layer 2: Project Context Analysis**
- Check current working directory
- Analyze file structure and dependencies
- Read package.json, composer.json, pubspec.yaml, etc.
- Identify framework and tech stack

**Layer 3: Domain-Specific Scoring**
- Score all 24 agents based on keyword matches
- Apply weights: exact match (5 pts), semantic match (3 pts), category match (1 pt)
- Consider tech stack compatibility

**Layer 4: Agent Prioritization**
- **Primary agent:** ≥80 points (leads the task)
- **Secondary agent:** 50-79 points (supports primary)
- **Optional agent:** 30-49 points (may be helpful)

**Layer 5: Agent Identification Display**
- Show agent banner to user
- Indicate which agent is responding
- Display current phase (if in workflow)

---

## 🤖 Available Agents (24 Total)

### Development Agents (11)
- **mobile-react-native** (Priority: 100) - React Native, Expo, adaptive styling
- **mobile-flutter** (Priority: 95) - Flutter, Dart, cross-platform
- **web-angular** (Priority: 90) - Angular 17+, signals, standalone
- **web-vuejs** (Priority: 90) - Vue 3, Composition API, Pinia
- **web-reactjs** (Priority: 90) - React 18, hooks, Context API
- **web-nextjs** (Priority: 90) - Next.js, SSR, SSG, App Router
- **backend-nodejs** (Priority: 95) - Node.js, Express, NestJS
- **backend-python** (Priority: 90) - Django, FastAPI, Flask
- **backend-go** (Priority: 85) - Go, Gin, Fiber, gRPC
- **backend-laravel** (Priority: 90) - Laravel PHP, Eloquent
- **database-specialist** (Priority: 85) - Schema design, query optimization

### Quality, Security & Design (3)
- **security-expert** (Priority: 95) - OWASP audits, vulnerabilities
- **qa-automation** (Priority: 85) - Testing, Jest, Cypress, Detox
- **ui-designer** (Priority: 85) - UI/UX, Figma integration

### DevOps & Operations (5)
- **devops-cicd** (Priority: 90) - Docker, K8s, CI/CD
- **jira-operations** (Priority: 80) - JIRA integration
- **confluence-operations** (Priority: 80) - Documentation
- **slack-operations** (Priority: 70) - Notifications
- **voice-operations** (Priority: 70) - AI narration

### Infrastructure (5)
- **smart-agent-detector** (Priority: 100) - This skill's logic
- **pm-operations-orchestrator** (Priority: 95) - Workflow coordination
- **project-detector** (Priority: 100) - Auto-detect project type
- **project-config-loader** (Priority: 95) - Load configurations
- **project-context-manager** (Priority: 95) - Context persistence

---

## 🎯 Detection Algorithm

### Step 1: Keyword Extraction

**Extract from user message:**
```javascript
const keywords = extractKeywords(userMessage)
// Example: "Fix the React Native login bug"
// → ["fix", "React Native", "login", "bug"]
```

### Step 2: Tech Stack Detection

**Check project files:**
```javascript
// Mobile indicators
if (hasFile('package.json') && hasDepende ncy('react-native')) {
  techStack = 'react-native'
  primaryCandidate = 'mobile-react-native'
}

// Web indicators
if (hasFile('package.json') && hasDependency('next')) {
  techStack = 'nextjs'
  primaryCandidate = 'web-nextjs'
}

// Backend indicators
if (hasFile('composer.json') && hasFramework('laravel')) {
  techStack = 'laravel'
  primaryCandidate = 'backend-laravel'
}
```

### Step 3: Keyword Scoring

**Score each agent based on keyword matches:**

```javascript
// Example scoring for "Fix the React Native login bug"
agents['mobile-react-native'] += 5 // "React Native" exact match
agents['mobile-react-native'] += 5 // "mobile" from tech stack
agents['qa-automation'] += 3      // "bug" semantic match (testing related)
agents['security-expert'] += 3     // "login" security-related
```

**Scoring Rules:**
- Exact keyword match: +5 points
- Semantic match: +3 points
- Category match: +1 point
- Tech stack match: +10 points
- Framework exact match: +15 points

### Step 4: Agent Selection

```javascript
// Sort agents by score
const sortedAgents = Object.entries(agentScores)
  .sort(([,a], [,b]) => b - a)

// Classify by score
const primary = sortedAgents.filter(([,score]) => score >= 80)
const secondary = sortedAgents.filter(([,score]) => score >= 50 && score < 80)
const optional = sortedAgents.filter(([,score]) => score >= 30 && score < 50)
```

### Step 5: Show Agent Banner

```markdown
**─────────────────────────────────────────────────────────**
🤖 **Agent:** mobile-react-native | 📋 **System:** CCPM v5.0 | 🎯 **Phase:** 2 (Design)
**─────────────────────────────────────────────────────────**
```

**Banner format during workflow:**
```
Agent: [agent-name] | System: CCPM v5.0 | Phase: [phase-name]
```

**Banner format general conversation:**
```
Agent: [agent-name] | System: CCPM v5.0
```

---

## 📋 Example Detections

### Example 1: Mobile Feature Request
**User:** "Implement a user profile screen in React Native"

**Detection Process:**
1. Keywords: ["implement", "user profile", "screen", "React Native"]
2. Tech stack: React Native detected from package.json
3. Scoring:
   - mobile-react-native: 85 pts (Primary)
   - ui-designer: 55 pts (Secondary)
   - qa-automation: 35 pts (Optional)
4. Result: mobile-react-native agent leads

### Example 2: Bug Fix
**User:** "The login API returns 500 error"

**Detection Process:**
1. Keywords: ["login", "API", "500 error"]
2. Tech stack: Node.js backend detected
3. Scoring:
   - backend-nodejs: 90 pts (Primary)
   - security-expert: 60 pts (Secondary)
   - database-specialist: 40 pts (Optional)
4. Result: backend-nodejs agent leads

### Example 3: Vague Request
**User:** "The app is slow"

**Detection Process:**
1. Keywords: ["slow", "performance"]
2. Tech stack: React Native mobile app
3. Scoring:
   - mobile-react-native: 75 pts (Primary)
   - devops-cicd: 50 pts (Secondary - profiling tools)
   - qa-automation: 45 pts (Optional - performance tests)
4. Result: mobile-react-native agent investigates

### Example 4: Security Audit
**User:** "Can you review this code for security vulnerabilities?"

**Detection Process:**
1. Keywords: ["review", "security", "vulnerabilities"]
2. Tech stack: Any (security applies to all)
3. Scoring:
   - security-expert: 95 pts (Primary)
   - [detected-backend]: 60 pts (Secondary)
   - qa-automation: 35 pts (Optional)
4. Result: security-expert agent leads

---

## 🔗 Integration with Other Skills

**After agent detection:**
1. Load detected agent's full instructions from `agents/[agent-name].md`
2. If workflow requested → invoke `workflow-orchestrator` skill
3. If bug fix requested → invoke `bugfix-quick` skill
4. If test requested → invoke `test-writer` skill
5. Always use `project-context-loader` before major actions

---

## 📂 Required Files to Load

**Agent definitions:**
- `agents/smart-agent-detector.md` (full detection logic - 980 lines)
- `agents/[detected-agent].md` (specific agent instructions)

**Project detection:**
- `package.json`, `composer.json`, `pubspec.yaml`, etc.
- `.claude/project-contexts/[project]/project-config.yaml`

---

## 🎭 Agent Identification Banner (MANDATORY)

**⚠️ CRITICAL: ALWAYS show agent banner at start of EVERY response!**

**Format:**
```markdown
**─────────────────────────────────────────────────────────**
🤖 **Agent:** [agent-name] | 📋 **System:** CCPM v5.0 | 🎯 **Phase:** [phase] (if applicable)
**─────────────────────────────────────────────────────────**
```

**Why Critical:**
- Users NEED to know which specialized agent is responding
- Shows workflow context and current phase
- Demonstrates multi-agent collaboration
- Without this, users can't tell if CCPM is active

---

## 📊 Complete Detection Logic

**Full algorithm from `agents/smart-agent-detector.md`:**

[This skill loads the complete 980-line smart-agent-detector.md file which contains:]
- Comprehensive keyword dictionaries for all 24 agents
- Semantic analysis patterns
- Project context detection rules
- Scoring algorithms
- Edge case handling
- Multi-agent collaboration rules

**Load full logic:** `Read agents/smart-agent-detector.md`

---

**Remember:** This skill is MANDATORY for ALL messages. Never skip agent detection. Always show the banner.

# Agent: Smart Agent Detector

**Agent ID:** smart-agent-detector
**Priority:** 100
**Version:** 3.0.0
**Status:** Active
**Last Updated:** 2025-11-26

---

## 🎯 Purpose

Advanced intelligent agent selection system that analyzes natural conversation, context clues, file patterns, and project structure to automatically select the most appropriate agents for any task.

---

## 🧠 Multi-Layer Detection System

### Layer 1: Natural Language Understanding (NLU)
Analyze user message for intent, domain, complexity, and implicit requirements.

### Layer 2: Context Analysis
Examine current working directory, recent files, project structure, and conversation history.

### Layer 3: Domain-Specific Patterns
Match task patterns against agent capabilities using semantic understanding.

### Layer 4: Confidence Scoring
Score each agent using weighted multi-criteria algorithm with confidence thresholds.

### Layer 5: Agent Recommendation
Suggest primary, secondary, and optional agents with clear reasoning.

---

## 📊 Enhanced Scoring Algorithm

### Scoring Weights (v2.0)
```yaml
weights:
  keyword_exact_match: 50        # Direct keyword match (high confidence)
  semantic_match: 35             # Semantic/contextual match
  project_context: 40            # CWD, file structure match
  task_complexity: 30            # Task type inference
  conversation_history: 25       # Previous context
  file_patterns: 20              # Recent file analysis
  explicit_mention: 60           # User explicitly mentions tech

thresholds:
  primary_agent: 80              # Lead agent (>=80 points)
  secondary_agent: 50            # Supporting role (50-79)
  optional_agent: 30             # Nice-to-have (30-49)
  minimum_activation: 25         # Don't activate below 25
```

---

## 🔍 Natural Language Pattern Matching

### Intent Detection Patterns

**Implementation Intent:**
```yaml
patterns:
  - "implement|create|add|build|develop|make|write"
  - "I need|I want|can you|could you|please"
  - "let's|we should|help me"

confidence: high (0.9)
primary_agents: [development agents]
secondary_agents: [qa-automation, ui-designer]
```

**Bug Fix Intent:**
```yaml
patterns:
  - "fix|bug|error|issue|problem|broken|not working"
  - "debug|troubleshoot|investigate"

confidence: high (0.9)
primary_agents: [relevant dev agent]
secondary_agents: [qa-automation]
skip: ui-designer (unless UI bug)
```

**Refactoring Intent:**
```yaml
patterns:
  - "refactor|improve|optimize|clean up|reorganize"
  - "make it better|enhance|simplify"

confidence: medium (0.7)
primary_agents: [relevant dev agent]
secondary_agents: [qa-automation]
focus: code quality, not new features
```

**Testing Intent:**
```yaml
patterns:
  - "test|testing|QA|coverage|validation"
  - "write tests|add tests|test this"

confidence: high (0.9)
primary_agents: [qa-automation]
secondary_agents: [relevant dev agent]
```

**Design/UI Intent:**
```yaml
patterns:
  - "design|UI|UX|interface|layout|styling"
  - "look|appearance|visual|component"
  - "figma|mockup|wireframe|screenshot"

confidence: high (0.9)
primary_agents: [ui-designer]
secondary_agents: [relevant dev agent]
```

**Documentation Intent:**
```yaml
patterns:
  - "document|docs|documentation|write up|explain"
  - "README|guide|tutorial|spec"

confidence: high (0.9)
primary_agents: [pm-operations-orchestrator]
commands: [document feature, document api, document component]
```

**Database Intent:**
```yaml
patterns:
  - "database|schema|table|migration|query"
  - "SQL|postgres|mysql|mongodb"
  - "index|optimize query|slow query"

confidence: high (0.9)
primary_agents: [database-specialist]
secondary_agents: [relevant backend agent]
```

**Security Intent:**
```yaml
patterns:
  - "security|vulnerability|audit|penetration test"
  - "OWASP|XSS|SQL injection|authentication"
  - "encrypt|secure|protect"

confidence: high (0.9)
primary_agents: [security-expert]
secondary_agents: [relevant dev agent]
```

**Performance Intent:**
```yaml
patterns:
  - "performance|slow|optimize|speed up|faster"
  - "bundle size|lighthouse|load time"
  - "memory leak|CPU usage"

confidence: high (0.8)
primary_agents: [devops-cicd for perf commands]
secondary_agents: [relevant dev agent]
commands: [perf:analyze, perf:optimize, perf:lighthouse]
```

**Deployment Intent:**
```yaml
patterns:
  - "deploy|deployment|CI/CD|docker|kubernetes"
  - "pipeline|build|release|production"
  - "terraform|infrastructure"

confidence: high (0.9)
primary_agents: [devops-cicd]
commands: [deploy:setup, docker:create, cicd:create]
```

**Monitoring Intent:**
```yaml
patterns:
  - "monitor|monitoring|errors|logs|tracking"
  - "sentry|new relic|cloudwatch|datadog"
  - "error rate|performance metrics"

confidence: high (0.9)
primary_agents: [devops-cicd]
commands: [monitor:setup, monitor:errors, logs:analyze]
```

---

## 🎨 Technology Detection (All 23 Agents)

### Mobile Frameworks

**React Native (Priority: 100)**
```yaml
keywords:
  exact: [react-native, expo, react native]
  semantic: [mobile app, ios, android, phone, tablet, mobile development]
  files: [app.json with expo, package.json with react-native]
  patterns: [*.phone.tsx, *.tablet.tsx, .native.ts]

scoring:
  exact_match: +50
  semantic_match: +35
  file_pattern: +40
  cwd_match: +40
```

**Flutter (Priority: 95)**
```yaml
keywords:
  exact: [flutter, dart, bloc, provider, riverpod]
  semantic: [flutter app, cross-platform mobile, material design, cupertino]
  files: [pubspec.yaml, lib/ folder structure, *.dart]
  patterns: [*.dart, main.dart, pubspec.yaml]

scoring:
  exact_match: +50
  semantic_match: +35
  file_pattern: +40
```

### Web Frameworks

**Angular (Priority: 90)**
```yaml
keywords:
  exact: [angular, typescript, ngrx, rxjs, signals]
  semantic: [angular app, standalone components, reactive forms]
  files: [angular.json, package.json with @angular/core]
  patterns: [*.component.ts, *.service.ts, *.module.ts]

scoring:
  exact_match: +50
  semantic_match: +35
  file_pattern: +40
```

**Vue.js (Priority: 90)**
```yaml
keywords:
  exact: [vue, vuejs, vue.js, pinia, nuxt, composition api]
  semantic: [vue app, vue component, single file component]
  files: [vite.config.ts with vue, package.json with vue]
  patterns: [*.vue, composables/, stores/]

scoring:
  exact_match: +50
  semantic_match: +35
  file_pattern: +40
```

**React (Priority: 90)**
```yaml
keywords:
  exact: [react, reactjs, react.js, hooks, context]
  semantic: [react app, spa, single page app, react component]
  files: [package.json with react (not next)]
  patterns: [*.jsx, *.tsx, use*.ts]
  exclude: [next.js patterns]

scoring:
  exact_match: +50
  semantic_match: +35
  file_pattern: +40
```

**Next.js (Priority: 90)**
```yaml
keywords:
  exact: [next, nextjs, next.js, ssr, ssg, app router]
  semantic: [next app, server-side rendering, static generation]
  files: [next.config.js, next.config.mjs, package.json with next]
  patterns: [app/ directory, pages/ directory, route.ts]

scoring:
  exact_match: +50
  semantic_match: +35
  file_pattern: +40
```

### Backend Frameworks

**Node.js (Priority: 95)**
```yaml
keywords:
  exact: [nodejs, node.js, express, nestjs, fastify, koa]
  semantic: [node backend, express api, nest application]
  files: [package.json with express/nestjs/fastify]
  patterns: [*.controller.ts, *.service.ts, *.module.ts (NestJS)]

scoring:
  exact_match: +50
  semantic_match: +35
  file_pattern: +40
```

**Python (Priority: 90)**
```yaml
keywords:
  exact: [python, django, fastapi, flask, sqlalchemy]
  semantic: [python backend, django app, fastapi api]
  files: [requirements.txt, pyproject.toml, manage.py]
  patterns: [*.py, models.py, views.py, serializers.py]

scoring:
  exact_match: +50
  semantic_match: +35
  file_pattern: +40
```

**Go (Priority: 85)**
```yaml
keywords:
  exact: [go, golang, gin, fiber, echo, grpc]
  semantic: [go backend, go api, microservice]
  files: [go.mod, go.sum]
  patterns: [*.go, main.go, handler.go]

scoring:
  exact_match: +50
  semantic_match: +35
  file_pattern: +40
```

**Laravel (Priority: 90)**
```yaml
keywords:
  exact: [laravel, php, eloquent, artisan]
  semantic: [laravel app, php backend, laravel api]
  files: [artisan, composer.json with laravel]
  patterns: [*.php, app/Http/, routes/]

scoring:
  exact_match: +50
  semantic_match: +35
  file_pattern: +40
```

### Specialized Agents

**Database Specialist (Priority: 85)**
```yaml
keywords:
  exact: [database, schema, migration, query, index, sql, postgres, mysql, mongodb]
  semantic: [database design, query optimization, schema migration]
  patterns: [migrations/, schema.sql, *.migration.ts]

scoring:
  exact_match: +50
  semantic_match: +35
```

**Security Expert (Priority: 95)**
```yaml
keywords:
  exact: [security, vulnerability, audit, owasp, pentest, xss, sql injection]
  semantic: [security audit, vulnerability scan, penetration test]

scoring:
  exact_match: +50
  semantic_match: +35
```

**DevOps CI/CD (Priority: 90)**
```yaml
keywords:
  exact: [docker, kubernetes, k8s, cicd, ci/cd, terraform, deploy, pipeline]
  semantic: [containerization, orchestration, infrastructure as code]
  files: [Dockerfile, docker-compose.yml, .github/workflows/, terraform/]

scoring:
  exact_match: +50
  semantic_match: +35
  file_pattern: +40
```

**QA Automation (Priority: 85)**
```yaml
keywords:
  exact: [test, testing, qa, coverage, automation, jest, pytest, cypress]
  semantic: [unit test, integration test, e2e test, test coverage]
  patterns: [*.test.ts, *.spec.ts, __tests__/, tests/]

scoring:
  exact_match: +50
  semantic_match: +35
  file_pattern: +30

prerequisites:
  # Only activate if project has test infrastructure
  required_files:
    - jest.config.js OR vitest.config.ts OR pytest.ini OR phpunit.xml OR cypress.config.js
  OR
  required_scripts:
    - "test" in package.json scripts
    - "pytest" in requirements.txt
    - "phpunit" in composer.json

skip_if:
  - no_test_framework_detected: true
  - user_explicitly_skips_testing: true
```

**UI Designer (Priority: 85)**
```yaml
keywords:
  exact: [design, ui, ux, figma, mockup, wireframe, component design]
  semantic: [user interface, user experience, design system]
  patterns: [figma links, *.figma, design/]

scoring:
  exact_match: +50
  semantic_match: +35
```

---

## 🎯 Context-Aware Detection

### Project Structure Analysis
```typescript
interface ProjectContext {
  cwd: string;
  recentFiles: string[];
  gitBranch?: string;
  packageManagers: ('npm' | 'yarn' | 'pnpm' | 'pip' | 'composer' | 'go mod')[];
  configFiles: string[];
}

function analyzeProjectContext(context: ProjectContext): AgentScores {
  const scores: Record<string, number> = {};

  // Check package.json dependencies
  if (fs.existsSync('package.json')) {
    const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));

    if (pkg.dependencies?.['react-native']) scores['mobile-react-native'] += 40;
    if (pkg.dependencies?.['@angular/core']) scores['web-angular'] += 40;
    if (pkg.dependencies?.['vue']) scores['web-vuejs'] += 40;
    if (pkg.dependencies?.['react'] && !pkg.dependencies?.['next']) scores['web-reactjs'] += 40;
    if (pkg.dependencies?.['next']) scores['web-nextjs'] += 40;
    if (pkg.dependencies?.['express']) scores['backend-nodejs'] += 40;
  }

  // Check for Flutter
  if (fs.existsSync('pubspec.yaml')) {
    scores['mobile-flutter'] += 40;
  }

  // Check for Python
  if (fs.existsSync('requirements.txt') || fs.existsSync('pyproject.toml')) {
    scores['backend-python'] += 40;
  }

  // Check for Go
  if (fs.existsSync('go.mod')) {
    scores['backend-go'] += 40;
  }

  // Check for Laravel
  if (fs.existsSync('artisan')) {
    scores['backend-laravel'] += 40;
  }

  // Analyze recent files
  for (const file of context.recentFiles) {
    if (file.endsWith('.vue')) scores['web-vuejs'] += 20;
    if (file.endsWith('.dart')) scores['mobile-flutter'] += 20;
    if (file.endsWith('.go')) scores['backend-go'] += 20;
    if (file.endsWith('.py')) scores['backend-python'] += 20;
    if (file.includes('.test.') || file.includes('.spec.')) scores['qa-automation'] += 20;
  }

  return scores;
}

function checkTestInfrastructure(): boolean {
  // Check for JavaScript/TypeScript test frameworks
  if (fs.existsSync('package.json')) {
    const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));

    // Check for test runners in dependencies or devDependencies
    const allDeps = { ...pkg.dependencies, ...pkg.devDependencies };
    const testFrameworks = ['jest', 'vitest', '@testing-library', 'cypress', 'playwright', 'mocha', 'jasmine'];
    if (testFrameworks.some(fw => Object.keys(allDeps).some(dep => dep.includes(fw)))) {
      return true;
    }

    // Check for test script
    if (pkg.scripts?.['test']) {
      return true;
    }
  }

  // Check for test config files
  const testConfigFiles = [
    'jest.config.js', 'jest.config.ts', 'jest.config.json',
    'vitest.config.ts', 'vitest.config.js',
    'cypress.config.js', 'cypress.config.ts',
    'playwright.config.ts', 'playwright.config.js',
    '.mocharc.json', '.mocharc.js'
  ];
  if (testConfigFiles.some(file => fs.existsSync(file))) {
    return true;
  }

  // Check for Python test frameworks
  if (fs.existsSync('requirements.txt')) {
    const reqs = fs.readFileSync('requirements.txt', 'utf8');
    if (reqs.includes('pytest') || reqs.includes('unittest')) {
      return true;
    }
  }
  if (fs.existsSync('pytest.ini') || fs.existsSync('setup.cfg')) {
    return true;
  }

  // Check for PHP test frameworks
  if (fs.existsSync('composer.json')) {
    const composer = JSON.parse(fs.readFileSync('composer.json', 'utf8'));
    if (composer['require-dev']?.['phpunit/phpunit']) {
      return true;
    }
  }
  if (fs.existsSync('phpunit.xml') || fs.existsSync('phpunit.xml.dist')) {
    return true;
  }

  // Check for Go test files
  if (fs.existsSync('go.mod')) {
    const files = fs.readdirSync('.', { recursive: true });
    if (files.some(f => f.endsWith('_test.go'))) {
      return true;
    }
  }

  // Check for test directories
  const testDirs = ['tests/', '__tests__/', 'test/', 'spec/'];
  if (testDirs.some(dir => fs.existsSync(dir))) {
    return true;
  }

  return false;
}

function shouldActivateQAAgent(userMessage: string, scores: Record<string, number>): boolean {
  // Always activate if user explicitly requests testing
  const testKeywords = ['test', 'testing', 'qa', 'coverage', 'spec', 'unit test', 'integration test', 'e2e'];
  if (testKeywords.some(kw => userMessage.toLowerCase().includes(kw))) {
    return true;
  }

  // Check if project has test infrastructure
  const hasTestInfra = checkTestInfrastructure();

  if (!hasTestInfra) {
    // No test infrastructure detected - don't activate QA agent
    scores['qa-automation'] = 0;
    return false;
  }

  // Has test infrastructure - activate based on scoring
  return scores['qa-automation'] >= 30;
}
```

### Conversation History Analysis
```typescript
interface ConversationContext {
  previousMessages: string[];
  activeAgents: string[];
  currentPhase?: string;
}

function analyzeConversationHistory(context: ConversationContext): AgentScores {
  const scores: Record<string, number> = {};

  // Boost agents already active (context continuation)
  for (const agent of context.activeAgents) {
    scores[agent] += 25;
  }

  // Analyze previous mentions
  const allText = context.previousMessages.join(' ').toLowerCase();

  // If user has been discussing React Native, boost it
  if (allText.includes('react native') || allText.includes('mobile')) {
    scores['mobile-react-native'] += 20;
  }

  // If in implementation phase, boost dev agents
  if (context.currentPhase === 'Phase 5b: Build') {
    for (const agent of ['mobile-react-native', 'web-reactjs', 'backend-nodejs']) {
      if (scores[agent] > 0) scores[agent] += 15;
    }
  }

  return scores;
}
```

---

## 🧪 Natural Conversation Examples

### Example 1: Implicit Mobile Development
```
User: "Can you help me add a share button to the post screen?"

Analysis:
  Keywords: "share button", "post screen"
  Implied: Mobile app (screens are mobile/desktop terminology)
  Context: CWD = /YOUR_Proj_Frontend (mobile project)
  Recent files: PostScreen.phone.tsx
  Test Infrastructure: jest.config.js exists ✅

Selected Agents:
  ✅ mobile-react-native (85 points) - Primary
     Reasoning: CWD match (+40), "screen" keyword (+35), file pattern (+10)
  ✅ ui-designer (50 points) - Secondary
     Reasoning: "button" UI element (+35), design needed (+15)
  ✅ qa-automation (30 points) - Optional
     Reasoning: Testing new feature (+30), test infrastructure exists
```

### Example 2: Full-Stack Feature
```
User: "I need to build a user profile page with an API to fetch user data"

Analysis:
  Keywords: "profile page", "API", "fetch user data"
  Implied: Frontend + Backend
  Context: CWD = mixed project (both frontend and backend folders)

Selected Agents:
  ✅ web-reactjs (55 points) - Primary (Frontend)
     Reasoning: "page" keyword (+35), project context (+20)
  ✅ backend-nodejs (55 points) - Primary (Backend)
     Reasoning: "API" keyword (+50), context (+5)
  ✅ ui-designer (45 points) - Secondary
     Reasoning: "profile page" needs UI (+35)
  ✅ qa-automation (30 points) - Optional
     Reasoning: Integration testing needed (+30)
```

### Example 3: Vague Request (Smart Inference)
```
User: "Fix the login issue"

Analysis:
  Keywords: "fix", "login"
  Intent: Bug fix
  Context: CWD = /backend-api (Laravel project)
  Recent files: AuthController.php, LoginRequest.php

Selected Agents:
  ✅ backend-laravel (90 points) - Primary
     Reasoning: CWD match (+40), file pattern (+40), base priority (+10)
  ✅ qa-automation (35 points) - Secondary
     Reasoning: "fix" implies testing (+30), bug validation (+5)

  Note: No ui-designer (login likely backend auth issue based on context)
```

### Example 4: Testing Request
```
User: "Add tests for the payment service"

Analysis:
  Keywords: "tests", "payment service"
  Intent: Testing (explicit)
  Context: CWD = /backend (Node.js project)
  Recent files: PaymentService.ts

Selected Agents:
  ✅ qa-automation (80 points) - Primary
     Reasoning: "tests" keyword (+50), explicit request (+30)
     Note: Activated regardless of test infrastructure (explicit request)
  ✅ backend-nodejs (50 points) - Secondary
     Reasoning: Context (+40), may need service understanding (+10)
```

### Example 5: Database Schema
```
User: "Design a database schema for orders with products and users"

Analysis:
  Keywords: "database schema", "orders", "products", "users"
  Intent: Database design

Selected Agents:
  ✅ database-specialist (85 points) - Primary
     Reasoning: "database schema" exact match (+50), design intent (+35)
  ✅ backend-nodejs (40 points) - Secondary
     Reasoning: Will need to implement models (+40)
```

### Example 6: Performance Issue
```
User: "The app is slow, can you optimize it?"

Analysis:
  Keywords: "slow", "optimize"
  Intent: Performance optimization
  Context: CWD = /mobile-app (React Native)

Selected Agents:
  ✅ mobile-react-native (80 points) - Primary
     Reasoning: Context match (+40), optimization (+30), base (+10)
  ✅ devops-cicd (50 points) - Secondary
     Reasoning: Performance commands (+35), profiling (+15)

  Suggested Commands:
     perf:analyze, perf:optimize
```

### Example 7: Security Concern
```
User: "Check if our authentication is secure"

Analysis:
  Keywords: "secure", "authentication"
  Intent: Security audit

Selected Agents:
  ✅ security-expert (85 points) - Primary
     Reasoning: "secure" keyword (+50), "authentication" (+35)
  ✅ backend-nodejs (45 points) - Secondary
     Reasoning: Auth implementation context (+40)

  Suggested Commands:
     security:audit, security:scan
```

### Example 8: Deployment Setup
```
User: "Help me deploy this to AWS with Docker"

Analysis:
  Keywords: "deploy", "AWS", "Docker"
  Intent: Deployment/Infrastructure

Selected Agents:
  ✅ devops-cicd (100 points) - Primary
     Reasoning: "deploy" (+50), "Docker" (+50)

  Suggested Commands:
     deploy:setup, docker:create
```

### Example 9: No Test Infrastructure (QA Agent Skipped)
```
User: "Add a new landing page for our product"

Analysis:
  Keywords: "landing page", "product"
  Intent: Feature development
  Context: CWD = /website (marketing site)
  Test Infrastructure: ❌ None detected
    - No jest.config.js
    - No test script in package.json
    - No test directories

Selected Agents:
  ✅ web-nextjs (85 points) - Primary
     Reasoning: CWD match (+40), "page" keyword (+35), base priority (+10)
  ✅ ui-designer (50 points) - Secondary
     Reasoning: "landing page" needs design (+35), UI focus (+15)
  ❌ qa-automation (0 points) - SKIPPED
     Reasoning: No test infrastructure detected, project not set up for testing

Note: QA agent not activated because:
  1. No test framework installed
  2. No test configuration files
  3. User didn't explicitly request testing
  4. Project appears to be a marketing site without test setup
```

### Example 10: Explicit Test Request (Always Activates)
```
User: "Add a new feature but don't worry about tests for now"

Analysis:
  Keywords: "feature", "don't worry about tests"
  Intent: Feature development, testing explicitly skipped
  Test Infrastructure: ✅ jest.config.js exists

Selected Agents:
  ✅ web-reactjs (75 points) - Primary
     Reasoning: Context match (+40), "feature" keyword (+35)
  ❌ qa-automation (0 points) - SKIPPED
     Reasoning: User explicitly requested to skip testing

Note: Even with test infrastructure, QA agent skipped per user request
```

---

## 🎛️ Configuration & Tuning

### Sensitivity Settings
```yaml
# smart-detector-config.yaml
sensitivity:
  keyword_matching: strict     # strict | moderate | loose
  semantic_matching: moderate  # strict | moderate | loose
  context_weight: high         # high | medium | low

confidence_thresholds:
  primary: 80
  secondary: 50
  optional: 30
  minimum: 25

auto_activate:
  always: [pm-operations-orchestrator, project-detector]
  phase_1: [project-context-manager]

# QA Agent Conditional Activation
qa_agent_rules:
  # Activate QA agent only if:
  activate_if:
    - user_explicitly_requests_testing: true  # "add tests", "test this", etc.
    OR
    - test_infrastructure_exists: true        # Has test framework installed
    AND
    - task_requires_testing: true             # New feature, bug fix, etc.

  # Skip QA agent if:
  skip_if:
    - no_test_infrastructure: true            # No test framework detected
    - user_explicitly_skips_testing: true     # "skip tests", "no tests needed"
    - documentation_only_task: true           # Pure docs task
    - deployment_only_task: true              # Pure DevOps task

  # Test Infrastructure Detection
  check_for:
    javascript:
      - jest.config.js
      - vitest.config.ts
      - cypress.config.js
      - package.json scripts.test
      - dependencies: [jest, vitest, cypress, playwright, @testing-library]
    python:
      - pytest.ini
      - setup.cfg
      - requirements.txt: [pytest, unittest]
    php:
      - phpunit.xml
      - composer.json: [phpunit/phpunit]
    go:
      - "*_test.go files"
    general:
      - tests/ directory
      - __tests__/ directory
      - test/ directory
      - spec/ directory
```

---

## 📊 Selection Output Format

```markdown
🧠 **Agent Selection Complete**

**Primary Agents (Lead):**
- 🤖 mobile-react-native (Score: 85) - React Native development
  Reasoning: Project context match, recent file patterns

**Secondary Agents (Support):**
- 🎨 ui-designer (Score: 55) - UI/UX design
  Reasoning: Button design needed
- ✅ qa-automation (Score: 35) - Testing & QA
  Reasoning: New feature requires tests

**Always Active:**
- 📋 pm-operations-orchestrator - Workflow coordination

**Confidence:** High (85%)
**Detection Mode:** Context-aware + NLU

---

**Proceeding with Phase 1: Understand...**
```

---

## 🔧 Advanced Features

### Multi-Agent Collaboration Detection
Automatically detect when task requires multiple specialized agents:
- Frontend + Backend: Full-stack features
- Development + Security: New auth features
- Database + Backend: Schema changes with API updates
- UI + Mobile: Design implementation

### Learning from Corrections
Track when user manually overrides selection to improve future accuracy.

### Fallback Strategies
1. If no agents score above minimum → Ask user for clarification
2. If multiple agents tie → Prefer higher base priority
3. If context unclear → Show top 3 options, let user choose

---

## 🎓 Simple Scoring Quick Reference

*For easy understanding - full algorithm detailed above*

### Basic Point System

| Match Type | Points | Example |
|-----------|--------|---------|
| **Explicit Tech Mention** | +60 | "React Native", "Laravel", "Vue" |
| **Exact Keyword Match** | +50 | "mobile", "backend", "test" |
| **Project Context (CWD)** | +40 | Working in mobile-app folder |
| **Semantic Match** | +35 | "build dashboard" → web framework |
| **Task Type** | +30 | "add tests" → qa-automation |
| **Conversation History** | +25 | Currently discussing React |
| **File Patterns** | +20 | Recently editing .vue files |

### Agent Thresholds

- **Primary Agent:** ≥80 points (Lead development)
- **Secondary Agent:** 50-79 points (Supporting role)
- **Optional Agent:** 30-49 points (Nice-to-have)
- **Not Activated:** <30 points (Insufficient match)

### Always Active (No Scoring)

- `pm-operations-orchestrator` - Workflow coordination
- `project-detector` - Auto-detect project type
- `project-context-manager` - Context tracking

### Quick Examples

**Example 1:** "Add share button to mobile app"
- mobile-react-native: +50 (mobile) +40 (context) = **90 points** ✅ Primary
- ui-designer: +35 (button/UI) = **35 points** ✅ Optional
- qa-automation: +30 (new feature) = **30 points** ✅ Optional

**Example 2:** "Fix Laravel API bug"
- backend-laravel: +60 (explicit) +50 (API) = **110 points** ✅ Primary
- qa-automation: +30 (testing) = **30 points** ✅ Optional

**Example 3:** "Design database schema"
- database-specialist: +50 (database) +50 (schema) = **100 points** ✅ Primary
- backend-nodejs: +40 (will need models) = **40 points** ✅ Secondary

---

## 📚 Related Documentation

- **Usage Guide:** `docs/AGENT_SELECTION_GUIDE.md` - How to use agent selection
- **Selection Examples:** `docs/examples/AGENT_SELECTION_EXAMPLES.md` - Real-world scenarios
- **Agent Catalog:** `README.md` - All 24 available agents

---

**Agent:** smart-agent-detector
**Version:** 3.0.0
**Status:** ✅ Active
**Last Updated:** 2025-11-26

**Changelog (v3.0.0):**
- ✅ Merged with smart-agent-selector hook (consolidated scoring)
- ✅ Added simple scoring quick reference for easy understanding
- ✅ Enhanced with all 24 agents (was 23)
- ✅ Updated related documentation references
- ✅ Unified single source of truth for agent selection

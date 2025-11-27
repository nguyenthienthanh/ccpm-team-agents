# CCPM Team Agents System - Changelog

## [5.1.0] - 2025-11-27

### 🆕 Major Feature - Skills System

**Added:**

**8 Auto-Invoking Skills:**
1. **agent-detector** - ALWAYS runs first, selects appropriate specialized agent
2. **workflow-orchestrator** - Executes 9-phase workflow for complex features
3. **project-context-loader** - Loads project conventions before code generation
4. **bugfix-quick** - Fast bug fixes with TDD enforcement
5. **test-writer** - Comprehensive test creation (unit, integration, E2E)
6. **code-reviewer** - Multi-agent quality review (security, performance, quality)
7. **jira-integration** - Auto-fetches JIRA tickets when mentioned
8. **figma-integration** - Auto-extracts Figma designs when URLs shared

**How It Works:**
- Skills use **LLM reasoning** to match context
- Auto-invoke based on user intent (no manual commands)
- Multiple skills can activate for one message
- Natural language triggers: "implement", "fix bug", "add tests", "PROJ-1234", Figma URLs

**Benefits:**
- ✅ No command memorization needed
- ✅ Natural conversation ("fix the login bug" → bugfix-quick skill)
- ✅ Intelligent capability discovery
- ✅ Model-invoked (Claude decides when to use)
- ✅ Educational approach (skills inject detailed instructions)

**Plugin Configuration Enhanced:**
- **plugin.json** expanded to 382 lines
- Added agents registry (24 agents with priorities/types)
- Added commands registry (70 commands in 15 categories)
- Added workflows definitions (9-phase + quick-fix)
- Added rules registry (core + project)
- Added integrations config (JIRA, Figma, Slack, Confluence)
- Added templates and documentation references

**Dual-File Loader Architecture:**
- Project `.claude/CLAUDE.md` (loader) - tells Claude to read plugin
- Plugin `ccpm/CLAUDE.md` (system) - contains ALL instructions
- Fixed issue where Claude didn't load CCPM without project CLAUDE.md
- `project:init` now creates lightweight loader file

**Changed:**
- CLAUDE.md version: 5.0.0-beta → 5.1.0
- Added Skills section to CLAUDE.md
- Updated README.md with Skills information
- Skills file naming: SKILL.md → descriptive names (workflow-execution.md, agent-selection.md, etc.)

**Impact:**
- Dramatically improved user experience (natural language vs commands)
- Better capability discovery (Skills auto-activate)
- Fixed critical loading issue (project CLAUDE.md loader)
- More maintainable plugin configuration

---

## [5.0.0-beta] - 2025-11-26

### Major Release - Security, DevOps & Performance

**Added:**

**New Agents (3):**
1. **backend-nodejs** (Priority: 95)
   - Express.js, NestJS, Fastify, Koa support
   - GraphQL APIs (Apollo Server)
   - Prisma, TypeORM, Sequelize ORMs
   - JWT authentication, Passport.js
   - Jest, Supertest testing

2. **security-expert** (Priority: 95)
   - OWASP Top 10 security audits
   - Dependency vulnerability scanning
   - Static code analysis (SAST)
   - Secret detection (TruffleHog)
   - Container security (Trivy)
   - Compliance support (GDPR, HIPAA, PCI DSS)

3. **devops-cicd** (Priority: 90)
   - Docker containerization
   - Kubernetes orchestration
   - CI/CD pipelines (GitHub Actions, GitLab CI, Azure, CircleCI)
   - Infrastructure as Code (Terraform, CloudFormation)
   - Cloud platforms (AWS, GCP, Azure)
   - Monitoring & logging

**New Commands (11):**
- **Security:** `security:audit`, `security:deps`, `security:scan`
- **Performance:** `perf:analyze`, `perf:optimize`, `perf:lighthouse`, `perf:bundle`
- **Deployment:** `deploy:setup`, `docker:create`, `cicd:create`

### Changed
- Total agents: 15 → 24 (+60%)
- Total commands: 47 → 70 (+49%)
- Backend framework support: 1 (Laravel) → 4 (Laravel, Node.js, Python, Go)

### Impact
- Security auditing now available for all projects
- DevOps automation for containerization and deployment
- Performance optimization tools for web and mobile
- Node.js backend development fully supported

---

## [4.6.0] - 2025-11-26

### Added
- **Auto-approval permissions** - Configure file operations (Read/Edit/Write) to auto-approve without prompts
- **Agent Identification System** - Every message now shows which agent is responding, system in use, and current phase
- **Adaptive Styling Detection** - Mobile agent now detects and adapts to project's existing styling approach (NativeWind, Emotion, StyleSheet, etc.)
- **Styling Detection Guide** - Comprehensive guide for agents to detect and use correct styling approach per project

### Changed
- **Mobile React Native Agent** - Changed from enforcing NativeWind to being adaptive based on project context
- **Project Config Template** - Added comprehensive styling configuration section
- **Settings Configuration** - Improved with relative paths (./**) for better portability

### Removed
- Removed planning/proposal documentation files (MIGRATION_V4_TO_V5.md, PHASE_OPTIMIZATION_PROPOSAL.md, INTEGRATION_SUMMARY.md)
- Cleaned up redundant documentation after implementation

### Fixed
- Mobile agent no longer strictly enforces NativeWind when project uses different styling
- Improved project context detection and adaptation

---

## [4.5.0] - 2025-11-25

### Added
- **NativeWind Integration** - Tailwind CSS styling for React Native applications
- **ElevenLabs Voice Operations** - AI voice generation for documentation narration
- **Voice Commands** - Complete voice operations with 70+ language support
- **NativeWind Component Generator** - Skill for rapid component generation

### Changed
- Enhanced mobile-react-native agent with NativeWind support
- Updated Phase 8 with optional voice narration
- Added voice-operations agent

---

## [4.4.0] - 2025-11-24

### Added
- Initial CCPM Team Agents System
- 14 specialized agents
- 9-phase workflow with TDD enforcement
- Project context management
- Cross-agent collaboration
- Quality gates and approval system

### Features
- Multi-agent architecture
- Test-Driven Development workflow
- JIRA, Confluence, Slack integrations
- Project-specific conventions and rules
- Token tracking and session management

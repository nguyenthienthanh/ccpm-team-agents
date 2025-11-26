# CCPM Team Agents System - Changelog

## [5.0.0-beta] - 2024-11-26

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
- Total agents: 15 → 18 (+20%)
- Total commands: 47 → 58 (+23%)
- Backend framework support: 1 (Laravel) → 2 (Laravel + Node.js)

### Impact
- Security auditing now available for all projects
- DevOps automation for containerization and deployment
- Performance optimization tools for web and mobile
- Node.js backend development fully supported

---

## [4.6.0] - 2024-11-26

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

## [4.5.0] - 2024-11-25

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

## [4.4.0] - 2024-11-24

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

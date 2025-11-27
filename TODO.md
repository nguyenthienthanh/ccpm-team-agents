# CCPM Configuration Improvements - TODO

**Generated:** 2025-11-27
**Version:** 5.0.0

---

## 🔴 CRITICAL ISSUES

**Status:** ✅ All critical issues have been resolved!

---

## 🟡 HIGH PRIORITY

**Status:** ✅ All high priority issues have been resolved!

**Completed:**
- ✅ Version consistency (5.0.0 across all files)
- ✅ Environment variable documentation created
- ✅ Configuration loading order documented
- ✅ Permission configuration fixed and standardized

---

## 🟢 MEDIUM PRIORITY

**Status:** ✅ All medium priority issues have been resolved!

**Completed:**
- ✅ Reorganized global settings by concern type (Workflow, Quality, Documentation, Safety, Agents, etc.)
- ✅ Created comprehensive integration setup guide with decision tree
- ✅ Improved workflow configuration (skip_phases, timeout_minutes, etc.)
- ✅ Documented agent scoring system with detailed comments
- ✅ Moved file naming conventions to project context template
- ✅ **NEW:** Story points missing from workflow execution - Fixed templates and agent files

**Improvements Made:**

**Issue #8:** Global settings now organized into:
- Workflow Settings
- Quality Settings
- Documentation Settings
- Safety & Security Settings
- Agent Settings
- Integration Defaults
- Performance & Limits

**Issue #9:** Created `INTEGRATION_SETUP_GUIDE.md` with:
- Decision tree for integration selection
- Setup scenarios (solo, small team, enterprise)
- Prerequisites and test commands
- Troubleshooting guide

**Issue #10:** Workflow configuration improved:
- Changed to `skip_phases: []` (clearer intent)
- Added `timeout_minutes: 30` default
- Added `auto_continue_after_approval` setting
- Documented state save location

**Issue #11:** Agent configuration documented:
- Added detailed comments explaining scoring (0-100 scale)
- Explained threshold ranges (0-20: inclusive, 21-40: balanced, etc.)
- Documented max_active rationale (prevent token exhaustion)
- Clarified always_active agents purpose

**Issue #12:** File naming conventions:
- Moved to `project-contexts/template/project-config.yaml`
- Removed from global config
- Added examples and detailed patterns
- Conventions now project-specific as intended

**Issue #13:** Story points missing from workflow execution:
- **Problem:** Workflow showed "Effort: 5 minutes, Priority: High" instead of story points
- **Root Cause:** Templates and agent files not updated with story points format
- **Files Fixed:**
  - `templates/requirements.md` - Added comprehensive estimation section
  - `agents/pm-operations-orchestrator.md` - Updated Phase 1 approval gate format
  - `commands/workflow/start.md` - Added story points to deliverables and approval gate
- **Result:** Now shows story points, complexity, time estimate, and confidence level
- **Reference:** Follows `docs/STORY_POINTS_GUIDE.md` Fibonacci scale

---

## 🔵 LOW PRIORITY / IMPROVEMENTS

### 14. YAML Formatting
**File:** `ccpm/ccpm-config.yaml`
**Issue:** Inconsistent spacing and indentation
**Action:**
- [ ] Standardize to 2-space indentation
- [ ] Add yamllint configuration
- [ ] Run through YAML formatter

### 15. Configuration Comments
**File:** `ccpm-config.example.yaml`
**Issue:** Some settings lack explanation
- Line 6: What is "mobile-react-native" vs other types?
- Line 44: What does "default_test_coverage" affect?
**Action:**
- [ ] Add inline comments for every setting
- [ ] Reference docs for complex settings
- [ ] Add examples for common configurations

### 16. Settings Example Improvements
**File:** `ccpm/settings.example.json`
**Issue:** Missing some common permissions
**Action:**
- [ ] Add permissions for:
  - Docker commands
  - Database commands (psql, mysql, etc.)
  - Cloud CLI (aws, gcloud, azure)
- [ ] Add more examples in comments
- [ ] Group permissions by category

### 17. Environment Variable Naming
**File:** `ccpm/.envrc.template`
**Issue:** Inconsistent naming patterns
- Some use `PROJECT_*` prefix
- Others use service name first (e.g., `JIRA_*`)
- Some use `CCPM_*` prefix
**Action:**
- [ ] Standardize on naming convention:
  - `CCPM_*` for CCPM settings
  - `[SERVICE]_*` for integrations
  - `PROJECT_*` for project-specific
- [ ] Update all references
- [ ] Document in ENV_SETUP_GUIDE.md

### 18. Template Improvements
**File:** `ccpm/project-contexts/template/project-config.yaml`
**Issue:** Template is comprehensive but could be better
**Action:**
- [ ] Add more inline examples
- [ ] Include common tech stack combinations
- [ ] Add validation rules
- [ ] Create project type presets (mobile, backend, fullstack)

### 19. Config Validation
**Issue:** No validation of config files on load
**Action:**
- [ ] Create JSON schema for settings files
- [ ] Create YAML schema for config files
- [ ] Add `config:validate` command
- [ ] Add pre-commit hook for validation

---

## 📋 DOCUMENTATION IMPROVEMENTS

### 20. Missing Guides
**Action:**
- [ ] Create `CONFIG_LOADING_ORDER.md`
- [ ] Create `ENV_SETUP_GUIDE.md`
- [ ] Create `AGENT_CONFIGURATION.md`
- [ ] Create `PERMISSION_PATTERNS.md`
- [ ] Update `QUICK_SETUP_INTEGRATIONS.md` with env var setup

### 21. Configuration Examples
**Action:**
- [ ] Add example configs for common project types:
  - React Native mobile app
  - Next.js web app
  - Laravel backend API
  - Fullstack monorepo
- [ ] Create `ccpm/examples/configs/` directory
- [ ] Link from main README

---

## 🛠️ TOOLING & AUTOMATION

### 22. Setup Scripts
**Action:**
- [ ] Create `scripts/setup-config.sh` - Interactive config setup
- [ ] Create `scripts/validate-config.sh` - Validate all configs
- [ ] Create `scripts/migrate-config.sh` - Migrate from v4 to v5
- [ ] Create `scripts/check-env.sh` - Check env var setup

### 23. Config Management Commands
**Action:**
- [ ] Add `config:init` - Interactive config setup
- [ ] Add `config:validate` - Validate configs
- [ ] Add `config:show` - Display current config
- [ ] Add `config:edit` - Edit config with validation
- [ ] Add `env:check` - Check environment variables

---

## 🔒 SECURITY IMPROVEMENTS

### 24. Secrets Management
**Action:**
- [ ] Add `.env.example` with all required vars but no values
- [ ] Document secret rotation process
- [ ] Add secrets scanning to CI/CD
- [ ] Create `SECURITY_CHECKLIST.md`

### 25. Permission Auditing
**Action:**
- [ ] Add `permissions:audit` command
- [ ] Log all dangerous operations
- [ ] Add confirmation for high-risk permissions
- [ ] Document security best practices

---

## ✅ PRIORITY ORDER

1. **IMMEDIATELY:** Fix security issue #2 (exposed credentials)
2. **TODAY:** Fix critical issues #1, #3
3. **THIS WEEK:** High priority issues #4-7
4. **THIS MONTH:** Medium priority issues #8-12
5. **BACKLOG:** Low priority and improvements #13-24

---

## 📊 IMPACT ASSESSMENT

### High Impact
- #2: Security vulnerability (CRITICAL)
- #1: Broken configuration reference
- #4: Version confusion
- #6: Config loading unclear

### Medium Impact
- #3: Inconsistent settings format
- #5: Missing env documentation
- #7: Permission issues
- #11: Agent configuration unclear

### Low Impact
- All documentation and tooling improvements
- YAML formatting
- Naming consistency

---

## 🎯 SUCCESS CRITERIA

Configuration improvements are complete when:
- [ ] No security vulnerabilities
- [ ] All configs use same version
- [ ] Clear documentation for all settings
- [ ] Validation tools in place
- [ ] Example configs for common scenarios
- [ ] Environment setup is straightforward
- [ ] Config loading order is documented
- [ ] No inconsistencies between files

---

**Next Steps:**
1. Review this TODO with team
2. Prioritize items
3. Create GitHub issues
4. Assign owners
5. Set deadlines

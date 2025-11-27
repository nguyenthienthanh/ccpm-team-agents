---
name: code-reviewer
description: "PROACTIVELY use after code implementation, before merging, or when user requests code review. Triggers: 'review code', 'code review', 'check my code', after Phase 5c in workflow. Performs comprehensive quality checks: security, performance, maintainability, test coverage, KISS principle compliance. Multi-agent cross-review approach."
allowed-tools: Read, Grep, Glob, Bash
---

# CCPM Code Reviewer

**Version:** 5.0.0-beta
**Purpose:** Comprehensive code quality review with multi-agent collaboration
**Priority:** HIGH - Use before merging code

---

## 🎯 Overview

Code Reviewer performs thorough code quality analysis from multiple expert perspectives (security, performance, maintainability, testing) to ensure high-quality, production-ready code.

---

## ✅ When to Use This Skill

**PROACTIVELY use:**
- After code implementation (Phase 5c → Phase 6)
- Before merging pull requests
- When user requests: "review my code", "check this"
- After refactoring
- For security-critical code

---

## 🔄 Review Process

### Step 1: Load Files to Review

```bash
# Get list of changed files
git diff --name-only main...HEAD

# Or review specific files
files_to_review=["src/components/UserProfile.tsx", ...]
```

### Step 2: Multi-Agent Review

**Security Expert Review:**
- OWASP Top 10 vulnerabilities
- SQL injection, XSS, CSRF risks
- Authentication/authorization issues
- Secrets in code
- Dependency vulnerabilities

**Primary Dev Agent Review:**
- Code structure and organization
- KISS principle compliance
- Proper abstractions
- Error handling
- Edge cases covered

**QA Agent Review:**
- Test coverage (≥target%)
- Test quality and assertions
- Edge cases tested
- E2E scenarios covered

**Performance Review:**
- Inefficient algorithms (O(n²) → O(n))
- Memory leaks
- Unnecessary re-renders (React)
- Database query optimization
- Bundle size impact

### Step 3: Generate Review Report

```markdown
## Code Review Report

### ✅ Passed Checks
- [List of passed checks]

### ⚠️  Warnings
- [Non-blocking issues]

### ❌ Issues Found
- **[CRITICAL]** [Security/Performance/Quality issue]
  - File: [file:line]
  - Issue: [description]
  - Fix: [recommendation]

### 📊 Metrics
- Test Coverage: X% (target: Y%)
- Lines Changed: X
- Files Changed: Y
- Complexity Score: Z

### 💡 Recommendations
- [Improvement suggestions]
```

### Step 4: Approval Decision

- **✅ APPROVED:** No critical issues, meets quality standards
- **⚠️  APPROVED WITH COMMENTS:** Minor issues, can merge with follow-up
- **❌ CHANGES REQUESTED:** Critical issues must be fixed

---

## 🔍 Review Checklist

**Security:**
- [ ] No hardcoded secrets or API keys
- [ ] Input validation on all user inputs
- [ ] SQL queries use parameterized statements
- [ ] Authentication checks in place
- [ ] Authorization properly enforced
- [ ] No eval() or dangerous functions
- [ ] Dependencies have no known vulnerabilities

**Code Quality:**
- [ ] Follows KISS principle (simple over complex)
- [ ] No code duplication
- [ ] Proper error handling
- [ ] Clear variable/function names
- [ ] No magic numbers (use constants)
- [ ] Comments explain "why", not "what"
- [ ] Follows project conventions

**Testing:**
- [ ] Test coverage ≥ target%
- [ ] Critical paths have tests
- [ ] Edge cases covered
- [ ] Tests are clear and maintainable
- [ ] No flaky tests
- [ ] E2E tests for user flows

**Performance:**
- [ ] No N+1 queries
- [ ] Efficient algorithms used
- [ ] No memory leaks
- [ ] Images optimized
- [ ] Code splitting where appropriate
- [ ] No blocking operations on main thread

---

## 🚨 Critical Issues (Block Merge)

**Security:**
- Hardcoded secrets
- SQL injection vulnerability
- XSS vulnerability
- Missing authentication
- Known dependency vulnerabilities (HIGH/CRITICAL)

**Quality:**
- Test coverage < target
- Critical paths not tested
- Breaking changes without migration
- Performance regression > 20%

---

## 🔗 Related Skills

- **workflow-orchestrator** - Uses code-reviewer in Phase 6
- **security-expert agent** - Provides security review
- **project-context-loader** - Applies project-specific review criteria

---

**Remember:** Code review is about improving code quality, not criticizing developers. Be constructive.

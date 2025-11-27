---
name: bugfix-quick
description: "PROACTIVELY use for bug fixes and issues that don't require full 9-phase workflow. Triggers: 'fix bug', 'error', 'not working', 'broken', 'issue', 'crash', 'fails'. Lightweight fix process: understand issue → write failing test → implement fix → verify tests pass. DO NOT use for new features (use workflow-orchestrator instead)."
allowed-tools: Read, Grep, Glob, Edit, Write, Bash
---

# CCPM Quick Bugfix

**Version:** 5.0.0-beta
**Purpose:** Fast bug fixes with TDD enforcement, skipping full workflow
**Priority:** MEDIUM - Use for bugs and issues only

---

## 🎯 Overview

Quick Bugfix provides a streamlined process for fixing bugs and issues without the overhead of the full 9-phase workflow. Still enforces TDD (test → fix → verify) but skips planning phases.

---

## ✅ When to Use This Skill

**PROACTIVELY use when user reports:**
- Bug fixes ("fix the login bug")
- Errors ("API returns 500 error")
- Things not working ("button doesn't respond")
- Crashes ("app crashes when...")
- Failures ("test is failing")

**Triggers:**
- "fix", "bug", "error", "broken", "not working"
- "crash", "fails", "issue", "problem"
- "bugfix:quick" command

---

## ❌ When NOT to Use This Skill

**DO NOT use for:**
- New features → use `workflow-orchestrator`
- Major refactors → use `workflow-orchestrator`
- UI changes → use `workflow-orchestrator`
- Anything requiring > 2 hours → use `workflow-orchestrator`

---

## 🔄 Quick Fix Process

### Step 1: Understand the Issue (5-10 min)

1. **Read error description** from user
2. **Locate affected code** using Grep/Glob
3. **Reproduce the issue** (read tests, check logic)
4. **Identify root cause**

### Step 2: Write Failing Test (10-15 min) - TDD RED

**Load from:** `commands/bugfix/quick.md`

1. Create test that reproduces the bug
2. Run test → MUST FAIL
3. Verify failure is due to the bug (not test error)

**Example:**
```typescript
// Bug: Login button doesn't work when password is empty
describe('LoginForm bug fix', () => {
  it('should show error when password is empty', () => {
    const { getByTestId, getByText } = render(<LoginForm />)

    fireEvent.press(getByTestId('login-button'))

    // This test FAILS before fix
    expect(getByText('Password is required')).toBeTruthy()
  })
})
```

**Approval gate:** User must confirm test fails

### Step 3: Implement Fix (20-45 min) - TDD GREEN

1. Modify code to fix the bug
2. Keep changes minimal (KISS principle)
3. Run test → MUST PASS
4. Run all related tests → MUST PASS

**Example:**
```typescript
// Fix: Add validation for empty password
const handleLogin = () => {
  if (!password) {
    setError('Password is required')
    return
  }
  // ... rest of login logic
}
```

**Approval gate:** User must confirm tests pass

### Step 4: Verify (5-10 min)

1. Run full test suite
2. Check no regressions introduced
3. Verify bug is actually fixed
4. Quick code review (basic quality check)

**Approval gate:** User confirms fix works

---

## 📋 Quick Fix Template

```markdown
## Bug Fix: [Brief Description]

### Issue
[Describe the bug]

### Root Cause
[What's causing the bug]

### Test Added
\`\`\`typescript
[Failing test code]
\`\`\`

### Fix Applied
\`\`\`typescript
[Code changes]
\`\`\`

### Verification
- ✅ Test now passes
- ✅ No regressions
- ✅ Bug confirmed fixed
```

---

## 🚦 Approval Gates (3 Total)

1. **After RED phase:** User confirms test fails
2. **After GREEN phase:** User confirms test passes
3. **After verification:** User confirms fix works

**Much faster than full workflow (3 gates vs 9)!**

---

## 🔗 Related Skills

- **agent-detector** - Detects appropriate agent for bug domain
- **project-context-loader** - Loads conventions before fix
- **test-writer** - For writing the failing test
- **workflow-orchestrator** - If bug is too complex for quick fix

---

**Remember:** Keep fixes minimal. TDD still required. If fix becomes complex, switch to full workflow.

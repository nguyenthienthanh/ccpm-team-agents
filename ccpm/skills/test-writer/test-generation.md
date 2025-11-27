---
name: test-writer
description: "PROACTIVELY use when user requests to add tests, improve test coverage, or write tests for existing code. Triggers: 'add tests', 'write tests', 'test coverage', 'unit test', 'integration test', 'E2E test'. Enforces TDD when possible: write failing tests first, then make them pass. Supports Jest, Cypress, Detox, PHPUnit, PyTest, and more."
allowed-tools: Read, Grep, Glob, Edit, Write, Bash
---

# CCPM Test Writer

**Version:** 5.0.0-beta
**Purpose:** Comprehensive test creation with TDD enforcement
**Priority:** MEDIUM - Use for test-related requests

---

## 🎯 Overview

Test Writer creates comprehensive tests for your code, enforcing TDD principles and ensuring high quality test coverage across unit, integration, and E2E levels.

---

## ✅ When to Use This Skill

**PROACTIVELY use when user requests:**
- "Add tests for [component/module]"
- "Write unit tests"
- "Improve test coverage"
- "Create E2E tests"
- "Add integration tests"
- "test:unit", "test:e2e" commands

---

## 🔄 Test Writing Process

### Step 1: Analyze Code to Test

1. **Read target file** using Read tool
2. **Identify testable units:**
   - Functions/methods
   - Components
   - API endpoints
   - State changes
   - User interactions

### Step 2: Plan Test Strategy

**Determine test types needed:**
- **Unit tests:** Individual functions/components
- **Integration tests:** Module interactions
- **E2E tests:** Complete user flows

**Test coverage target:**
- Load from project context (default: 80%)
- Identify critical paths (require 100% coverage)

### Step 3: Write Tests (TDD Approach)

**For NEW code:**
1. Write failing tests FIRST (RED)
2. Implement code (GREEN)
3. Refactor (REFACTOR)

**For EXISTING code:**
1. Write tests that PASS (validate current behavior)
2. Identify missing test cases
3. Add tests for edge cases

### Step 4: Run Tests

```bash
# Unit tests
npm test
# or
yarn test

# E2E tests
npm run test:e2e
# or
detox test

# With coverage
npm test -- --coverage
```

### Step 5: Verify Coverage

```bash
# Check coverage report
echo "Coverage target: ${COVERAGE_TARGET}%"
echo "Current coverage: ${ACTUAL_COVERAGE}%"

if [ $ACTUAL_COVERAGE -lt $COVERAGE_TARGET ]; then
  echo "❌ Coverage below target!"
else
  echo "✅ Coverage target met"
fi
```

---

## 🧪 Test Templates

### Unit Test (Jest/React Native)

```typescript
import { render, fireEvent } from '@testing-library/react-native'
import { MyComponent } from '../MyComponent'

describe('MyComponent', () => {
  it('should render correctly', () => {
    const { getByTestId } = render(<MyComponent />)
    expect(getByTestId('my-component')).toBeTruthy()
  })

  it('should handle user interaction', () => {
    const onPress = jest.fn()
    const { getByTestId } = render(<MyComponent onPress={onPress} />)

    fireEvent.press(getByTestId('button'))
    expect(onPress).toHaveBeenCalledTimes(1)
  })
})
```

### Integration Test (API)

```typescript
import request from 'supertest'
import app from '../app'

describe('API Integration', () => {
  it('POST /api/users - should create user', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({ name: 'Test User', email: 'test@example.com' })
      .expect(201)

    expect(response.body).toMatchObject({
      name: 'Test User',
      email: 'test@example.com'
    })
  })
})
```

### E2E Test (Detox)

```typescript
describe('Login Flow', () => {
  beforeEach(async () => {
    await device.reloadReactNative()
  })

  it('should login successfully with valid credentials', async () => {
    await element(by.id('email-input')).typeText('user@example.com')
    await element(by.id('password-input')).typeText('password123')
    await element(by.id('login-button')).tap()

    await expect(element(by.id('home-screen'))).toBeVisible()
  })
})
```

---

## 📊 Coverage Requirements

**Minimum coverage by type:**
- Critical paths: 100%
- Business logic: 90%
- UI components: 80%
- Utilities: 80%
- Overall: 80% (or project-specific target)

---

## 🔗 Related Skills

- **project-context-loader** - Loads test patterns from project
- **bugfix-quick** - Uses test-writer for bug test creation
- **workflow-orchestrator** - Uses test-writer in Phase 5a

---

**Remember:** Tests are documentation. Write clear, maintainable tests that explain behavior.

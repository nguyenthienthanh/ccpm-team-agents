---
name: project-context-loader
description: "PROACTIVELY load before starting workflows, implementations, or any code generation. Reads project-specific conventions, naming patterns, rules, and real code examples from .claude/project-contexts/. Ensures AI follows YOUR project standards (not generic defaults). Triggers: before 'workflow:start', before 'implement', before code generation, when project-specific behavior needed."
allowed-tools: Read, Grep, Glob
---

# CCPM Project Context Loader

**Version:** 5.0.0-beta
**Purpose:** Load project-specific conventions and rules before execution
**Priority:** HIGH - Use before any workflow or implementation

---

## 🎯 Overview

The Project Context Loader reads your project's specific conventions, rules, patterns, and examples to ensure CCPM follows YOUR project standards instead of generic defaults. This is the difference between AI that "fits your project" vs AI that "works generically".

---

## ✅ When to Use This Skill

**PROACTIVELY use BEFORE:**
- Starting `workflow:start` or `workflow-orchestrator` skill
- Any code generation or implementation
- Creating new files or components
- Refactoring existing code
- Writing tests
- Reviewing code

**Triggers:**
- "implement", "build", "create"
- "workflow:start"
- "add feature"
- Before writing ANY code
- When project standards need to be applied

**Examples:**
- Before: "Implement user profile screen" → Load context FIRST
- Before: "Add tests for authentication" → Load context FIRST
- Before: "Refactor the API module" → Load context FIRST

---

## ❌ When NOT to Use This Skill

**Skip only for:**
- Simple documentation questions (no code generation)
- General CCPM help requests
- When project context already loaded in current session

---

## 🔄 How It Works

### Step 1: Check Project Context Exists

```bash
# Look for project context
PROJECT_ROOT=$(pwd)
CONTEXT_DIR="$PROJECT_ROOT/.claude/project-contexts"

if [ ! -d "$CONTEXT_DIR" ]; then
  echo "⚠️  No project context found!"
  echo "Run: project:init to create project context"
  exit 1
fi
```

### Step 2: Detect Project Name

```bash
# Get project name from context directory
PROJECT_NAME=$(basename "$CONTEXT_DIR"/*)

# Or from package.json
PROJECT_NAME=$(jq -r '.name' package.json 2>/dev/null)
```

### Step 3: Load Project Configuration

**File:** `.claude/project-contexts/[project]/project-config.yaml`

```yaml
# Example structure
project:
  name: my-app
  type: mobile
  framework: react-native
  version: 0.70.0

tech_stack:
  language: typescript
  state_management: zustand
  navigation: react-navigation
  styling: nativewind
  testing: jest+detox

conventions:
  file_naming: kebab-case
  component_naming: PascalCase
  import_alias: "@/"

team:
  reviewers: ["Alice", "Bob"]
  default_assignee: "ProjectLead"

integrations:
  jira:
    enabled: true
    project_key: "MYAPP"
  figma:
    enabled: true
    file_key: "ABC123"
```

**Load and parse:**
```javascript
const projectConfig = YAML.parse(
  await Read('.claude/project-contexts/[project]/project-config.yaml')
)

// Extract key info
const framework = projectConfig.tech_stack.framework
const styling = projectConfig.tech_stack.styling
const fileNaming = projectConfig.conventions.file_naming
```

### Step 4: Load Conventions

**File:** `.claude/project-contexts/[project]/conventions.md`

**Contains:**
- File naming patterns (kebab-case, PascalCase, etc.)
- Directory structure conventions
- Import alias usage (`@/`, `~/`, etc.)
- Component structure patterns
- Styling approach (NativeWind, Emotion, etc.)
- State management patterns
- Testing file locations and naming

**Example conventions.md:**
```markdown
# Project Conventions

## File Naming
- Components: PascalCase (UserProfile.tsx)
- Utilities: kebab-case (format-date.ts)
- Tests: *.test.ts or *.spec.ts

## Directory Structure
src/
├── components/
│   └── [ComponentName]/
│       ├── index.tsx
│       ├── styles.ts
│       └── __tests__/
├── features/
│   └── [feature-name]/
│       ├── components/
│       ├── hooks/
│       └── utils/
└── utils/

## Import Aliases
- @/components → src/components
- @/features → src/features
- @/utils → src/utils

## Styling Approach
- Using NativeWind (Tailwind CSS for React Native)
- Component styles: className="..."
- Theme: tailwind.config.js

## State Management
- Zustand for global state
- Store files: src/stores/[store-name].ts
- Pattern: create store → export hooks → use in components
```

### Step 5: Load Rules

**File:** `.claude/project-contexts/[project]/rules.md`

**Contains:**
- Project-specific quality rules
- Code review requirements
- Testing requirements
- Git workflow rules
- Deployment rules

**Example rules.md:**
```markdown
# Project-Specific Rules

## Code Quality
- ESLint: Must pass with 0 warnings
- Prettier: Auto-format on save
- TypeScript: Strict mode enabled
- No console.log in production code

## Testing Rules
- Coverage target: 85% (higher than CCPM default 80%)
- All new features MUST have tests
- E2E tests required for critical flows
- Detox tests for mobile navigation

## Git Rules
- Branch naming: feature/MYAPP-123-description
- Commit format: "type(scope): description"
- PR requires 2 approvals
- Must link to JIRA ticket

## Component Rules
- Max 200 lines per component
- Extract logic to custom hooks
- Accessibility: testID on all interactive elements
```

### Step 6: Load Examples

**File:** `.claude/project-contexts/[project]/examples.md`

**Contains:**
- Real code examples from the project
- Component structure examples
- Test examples
- API integration examples

**Example examples.md:**
```markdown
# Project Examples

## Feature Structure Example
\`\`\`
src/features/authentication/
├── components/
│   └── LoginForm/
│       ├── index.tsx
│       └── __tests__/
├── hooks/
│   └── useAuth.ts
├── services/
│   └── authService.ts
└── types.ts
\`\`\`

## Component Example
\`\`\`typescript
// From: src/components/Button/index.tsx
import { Text, TouchableOpacity } from 'react-native'

interface ButtonProps {
  onPress: () => void
  label: string
  variant?: 'primary' | 'secondary'
}

export const Button: React.FC<ButtonProps> = ({
  onPress,
  label,
  variant = 'primary'
}) => {
  return (
    <TouchableOpacity
      onPress={onPress}
      testID="button"
      className={`px-4 py-2 rounded-lg ${
        variant === 'primary' ? 'bg-blue-500' : 'bg-gray-300'
      }`}
    >
      <Text className="text-white font-semibold">{label}</Text>
    </TouchableOpacity>
  )
}
\`\`\`

## Test Example
\`\`\`typescript
// From: src/components/Button/__tests__/index.test.tsx
import { render, fireEvent } from '@testing-library/react-native'
import { Button } from '../index'

describe('Button', () => {
  it('calls onPress when pressed', () => {
    const onPress = jest.fn()
    const { getByTestId } = render(
      <Button onPress={onPress} label="Click me" />
    )

    fireEvent.press(getByTestId('button'))
    expect(onPress).toHaveBeenCalledTimes(1)
  })
})
\`\`\`
```

### Step 7: Load CCPM Core Rules

**Files from plugin `rules/` directory:**
- `rules/tdd-workflow.md`
- `rules/approval-gates.md`
- `rules/kiss-principle.md`
- `rules/cross-review.md`
- `rules/code-quality.md`

**Load all core rules:**
```javascript
const coreRules = {
  tdd: await Read('$PLUGIN_DIR/rules/tdd-workflow.md'),
  approvals: await Read('$PLUGIN_DIR/rules/approval-gates.md'),
  kiss: await Read('$PLUGIN_DIR/rules/kiss-principle.md'),
  review: await Read('$PLUGIN_DIR/rules/cross-review.md'),
  quality: await Read('$PLUGIN_DIR/rules/code-quality.md')
}
```

### Step 8: Merge Rules (Project Overrides Core)

**Priority order:**
```
Project rules.md > CCPM core rules > Generic defaults
```

**Example merge:**
```javascript
// CCPM default: 80% test coverage
// Project rule: 85% test coverage
// Result: Use 85% (project overrides)

const testCoverageTarget = projectRules.testing?.coverage ||
                          coreRules.tdd.defaultCoverage ||
                          80 // fallback

// Result: 85%
```

### Step 9: Apply Context to All Decisions

**Use loaded context for:**
- File naming decisions
- Directory structure choices
- Import statement formatting
- Styling approach (NativeWind vs Emotion vs StyleSheet)
- State management pattern
- Test file location and naming
- Code review criteria
- Git commit message format

---

## 📂 Required Files

**Project context files (in user's project):**
```
.claude/project-contexts/[project-name]/
├── project-config.yaml    # Tech stack, team, integrations
├── conventions.md         # Naming, structure, patterns
├── rules.md               # Project-specific quality rules
└── examples.md            # Real code from the project
```

**CCPM core rules (in plugin):**
```
$PLUGIN_DIR/rules/
├── tdd-workflow.md
├── approval-gates.md
├── kiss-principle.md
├── cross-review.md
└── code-quality.md
```

---

## 🎯 Context Application Examples

### Example 1: File Naming

**Without context:**
```typescript
// Generic default: camelCase
userProfile.tsx
```

**With context loaded:**
```typescript
// Project convention: PascalCase for components
UserProfile.tsx
```

### Example 2: Styling Approach

**Without context:**
```tsx
// Generic: StyleSheet
import { StyleSheet } from 'react-native'
const styles = StyleSheet.create({ ... })
```

**With context loaded:**
```tsx
// Project uses NativeWind
<View className="flex-1 bg-white p-4">
```

### Example 3: Test Coverage

**Without context:**
```
// CCPM default: 80% coverage
Coverage target: 80%
```

**With context loaded:**
```
// Project requires 85% coverage
Coverage target: 85%
```

### Example 4: Import Aliases

**Without context:**
```typescript
// Relative imports
import { Button } from '../../components/Button'
```

**With context loaded:**
```typescript
// Project uses @/ alias
import { Button } from '@/components/Button'
```

---

## ⚠️ Error Handling

**If project context missing:**
```markdown
⚠️  **Project context not found!**

CCPM works best with project context. Run:

\`\`\`bash
project:init
\`\`\`

This will:
- Analyze your project structure
- Extract conventions and patterns
- Generate project-specific rules
- Create examples from your codebase

**Continue anyway?**
- Will use CCPM generic defaults
- May not match your project conventions
- [yes/no]
```

---

## 🔗 Integration with Other Skills

**This skill is used by:**
- `workflow-orchestrator` - Loads context before Phase 1
- `bugfix-quick` - Applies project conventions to fixes
- `test-writer` - Uses project test patterns
- `code-reviewer` - Reviews against project rules

**This skill uses:**
- `agent-detector` - To understand project type first

---

## 📊 Success Indicators

**Context loaded successfully when:**
- ✅ All 4 project context files read
- ✅ Project config parsed
- ✅ Conventions extracted
- ✅ Rules merged (project + core)
- ✅ Examples available for reference

**Applied successfully when:**
- ✅ Generated code matches project conventions
- ✅ File names follow project patterns
- ✅ Imports use project aliases
- ✅ Styling approach matches project
- ✅ Test coverage meets project target

---

## 📚 Related Documentation

- `commands/project/init.md` - How to create project context
- `commands/project/regen.md` - How to regenerate context
- `docs/RULES_COMBINATION.md` - How rules are merged
- `docs/CONFIG_LOADING_ORDER.md` - Config priority order

---

**Remember:** Always load project context BEFORE generating code. Project conventions override CCPM defaults.

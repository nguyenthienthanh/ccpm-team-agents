# CLAUDE.md File Architecture

**Version:** 4.1.0
**Last Updated:** 2025-11-27
**Purpose:** Explain Aura Frog's dual-file loader CLAUDE.md architecture with Skills system

---

## 🚨 Architecture Decision: Dual-File Loader Architecture

**Aura Frog uses TWO files working together:**
1. **Project `.claude/CLAUDE.md`** - Lightweight loader (tells Claude to read plugin)
2. **Plugin `aura-frog/CLAUDE.md`** - Complete Aura Frog system instructions

**Why Both Files?**
- ✅ Claude Code ONLY auto-loads project `.claude/CLAUDE.md` (not plugin)
- ✅ Project CLAUDE.md is a lightweight "loader" that points to plugin
- ✅ Plugin CLAUDE.md contains ALL system instructions (single source of truth)
- ✅ Project-specific data in `.claude/project-contexts/[project]/`
- ✅ No duplication - project file just loads plugin file

---

## Priority Hierarchy (For Reference)

**Claude Code loads CLAUDE.md files in this priority order:**

```
1. .claude/CLAUDE.md (project) ← HIGHEST (if exists, overrides plugin)
2. ~/.claude/plugins/.../CLAUDE.md (plugin) ← Aura Frog uses this
3. ~/.claude/CLAUDE.md (global) ← LOWEST
```

**Aura Frog Strategy:**
- ✅ Creates lightweight `.claude/CLAUDE.md` in projects (loader file)
- ✅ Project CLAUDE.md tells Claude to read plugin CLAUDE.md
- ✅ Plugin CLAUDE.md contains ALL system instructions
- ✅ Project-specific data in `.claude/project-contexts/`

---

## Architecture Overview

Aura Frog uses a **dual-file loader + project context** architecture:

1. **Project CLAUDE.md** (Loader) - Tells Claude to read plugin CLAUDE.md
2. **Plugin CLAUDE.md** (System) - ALL Aura Frog instructions (single source of truth)
3. **Project Context** (Data) - Project-specific conventions, rules, examples

### File Locations

**Project CLAUDE.md (Loader):**
```
<project>/.claude/CLAUDE.md
```
- Auto-loaded by Claude Code (highest priority)
- Lightweight file (~50 lines)
- Tells Claude to read plugin CLAUDE.md
- Created by `project:init`

**Plugin CLAUDE.md (System):**
```
~/.claude/plugins/marketplaces/aurafrog/aura-frog/CLAUDE.md
```
- Contains ALL system instructions (~600 lines)
- Single source of truth
- Updated when plugin is updated
- Loaded explicitly by project CLAUDE.md

**Project Context (Data):**
```
<project>/.claude/project-contexts/[project-name]/
├── project-config.yaml    # Tech stack, team config
├── conventions.md         # Naming, structure, patterns
├── rules.md               # Project-specific quality rules
└── examples.md            # Real code examples
```
- Created by `project:init`
- Loaded explicitly by workflows
- Updated by `project:regen`

---

## How It Works

**Loading Sequence:**

```
1. Claude Code starts
   ↓
2. Auto-loads project .claude/CLAUDE.md (loader file)
   ↓
3. Project CLAUDE.md tells Claude to read plugin CLAUDE.md
   ↓
4. Claude reads plugin CLAUDE.md (all system instructions)
   ↓
5. User runs workflow (e.g., workflow:start)
   ↓
6. Workflow loads project context from .claude/project-contexts/
   ↓
7. Combines: Plugin instructions + Project context
   ↓
8. Executes workflow with full knowledge
```

**Benefits:**
- ✅ Project CLAUDE.md auto-loaded (Claude Code does this)
- ✅ Plugin CLAUDE.md explicitly loaded (via project CLAUDE.md instruction)
- ✅ Single source of truth for system instructions (plugin file)
- ✅ No duplication - project file is just a loader
- ✅ Clear separation: Loader → System → Data

---

## Division of Responsibilities

| Concern | Project Context | Plugin CLAUDE.md |
|---------|-----------------|------------------|
| **System Logic** | ❌ No | ✅ Yes |
| **Agent System** | ❌ No | ✅ Yes |
| **Workflow Execution** | ❌ No | ✅ Yes |
| **Tech Stack** | ✅ Yes (project-config.yaml) | ❌ No |
| **Conventions** | ✅ Yes (conventions.md) | ❌ No |
| **Quality Rules** | ✅ Yes (rules.md + plugin rules) | ✅ Yes (core) |
| **Code Examples** | ✅ Yes (examples.md) | ❌ No |
| **Auto-loaded** | ❌ No (explicit) | ✅ Yes |

**Think of it as:**
- **Plugin CLAUDE.md** = Operating System
- **Project Context** = Application configuration files

---

## Why This Architecture?

**Problem: If we created project-level CLAUDE.md:**
- ❌ Would override plugin instructions (highest priority)
- ❌ Risk of conflicts and inconsistencies
- ❌ Duplicate maintenance (plugin + each project)
- ❌ Updates to plugin wouldn't apply automatically

**Solution: Single plugin CLAUDE.md + separate project context:**
- ✅ No override conflicts possible
- ✅ Single source of truth for system instructions
- ✅ Plugin updates apply to all projects immediately
- ✅ Project-specific data cleanly separated
- ✅ Simpler mental model

---

## Updating the Architecture

### When to Update Plugin CLAUDE.md

Update when changing core Aura Frog behavior:
- Adding new agents
- Changing workflow logic
- Updating approval gates
- Adding new features

**How:**
1. Update `aura-frog/CLAUDE.md` in repository
2. Bump version: `./scripts/sync-version.sh X.Y.Z`
3. Update CHANGELOG.md
4. Users update via: `/plugin update aura-frog@aurafrog`

### When to Update Project Context

Run `project:regen` when:
- Project structure changed
- Dependencies updated
- New conventions adopted
- Team members changed

---

## Best Practices

**DO:**
- ✅ Keep ALL system logic in plugin CLAUDE.md
- ✅ Keep project-specific data in project-contexts/
- ✅ Never create `.claude/CLAUDE.md` in projects
- ✅ Document the architecture clearly

**DON'T:**
- ❌ Create project-level CLAUDE.md (causes conflicts)
- ❌ Put project-specific info in plugin CLAUDE.md
- ❌ Duplicate instructions between files

---

## Troubleshooting

### Issue: "Agent identification not showing"

**Cause:** Plugin CLAUDE.md not loaded (plugin not installed)

**Solution:**
```bash
/plugin list  # Verify installation
/plugin install aura-frog@aurafrog  # Install if missing
```

### Issue: "Project context not loading"

**Cause:** Project context missing or outdated

**Solution:**
```bash
project:init      # Create new
# OR
project:regen     # Regenerate existing
```

### Issue: "Workflows using wrong conventions"

**Cause:** Project context not initialized or outdated

**Solution:**
```bash
# Check if context exists
ls -la .claude/project-contexts/

# Regenerate if exists
project:regen

# Initialize if doesn't exist
project:init
```

---

## Summary

**Key Takeaways:**

1. **Single source of truth:** Plugin CLAUDE.md only
2. **No project CLAUDE.md:** Avoids conflicts, simpler architecture
3. **Project context separate:** In `.claude/project-contexts/`
4. **Plugin auto-loads:** Always available
5. **Workflows load context:** Explicitly when needed

**Architecture Goals:**

- ✅ No conflicts possible
- ✅ Single source of truth
- ✅ Clear separation of concerns
- ✅ Easy to maintain and update
- ✅ Consistent behavior across projects

---

## Related Documentation

- **Plugin CLAUDE.md:** `aura-frog/CLAUDE.md`
- **Project Context Structure:** See `project:init` command
- **Plugin Installation:** `aura-frog/docs/PLUGIN_INSTALLATION.md`
- **Project Initialization:** `aura-frog/commands/project/init.md`

---

**Version:** 3.0.0
**Last Updated:** 2025-11-27
**Status:** Active architecture
**Major Change:** Removed project-level CLAUDE.md entirely - single plugin file only

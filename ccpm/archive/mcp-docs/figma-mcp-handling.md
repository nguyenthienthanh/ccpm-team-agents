# Figma MCP Handling Rule

**Purpose:** Ensure Figma links are processed via MCP, not direct HTTP requests

---

## 🚨 CRITICAL RULE

**When detecting Figma links, ALWAYS use MCP tools, NEVER fetch URLs directly.**

---

## ✅ Correct Behavior

### Step 1: Detect Figma Link

When user provides a Figma link:
```
https://www.figma.com/file/ABC123xyz/Design-Name
```

Extract the file ID: `ABC123xyz`

### Step 2: Check MCP Availability

1. List available MCP resources/tools
2. Look for Figma MCP server (usually named "figma")
3. Check for tools like:
   - `figma_file_get`
   - `figma_design_tokens_extract`
   - `figma_components_list`

### Step 3: Use MCP Tools

```markdown
✅ CORRECT:
- Use MCP tool: figma_file_get(fileId="ABC123xyz")
- Extract design tokens via MCP
- Get components via MCP
```

### Step 4: Fallback if MCP Not Available

If MCP is not configured or unavailable:
```markdown
⚠️ Figma MCP server not available.

Please provide:
1. Screenshots of the Figma design, OR
2. Configure Figma MCP (see docs/figma-mcp-integration.md)

I cannot access Figma URLs directly.
```

---

## ❌ Incorrect Behavior

**NEVER do these:**

1. ❌ Fetch Figma URL directly:
   ```
   curl https://www.figma.com/file/ABC123/Design
   ```

2. ❌ Use HTTP requests to Figma:
   ```
   fetch('https://www.figma.com/file/...')
   ```

3. ❌ Try to access Figma web pages:
   ```
   Opening https://www.figma.com/file/... in browser
   ```

**Why?**
- Direct URL access requires authentication
- Will result in 403 Forbidden errors
- Figma API requires proper token handling via MCP
- MCP handles authentication automatically

---

## 📋 Implementation Checklist

When processing Figma links:

- [ ] Extract file ID from URL
- [ ] Check MCP server availability
- [ ] Use MCP tools to fetch data
- [ ] If MCP unavailable, ask for screenshots
- [ ] Never attempt direct HTTP fetch
- [ ] Document MCP usage in workflow logs

---

## 🔗 References

- **Setup Guide:** `docs/figma-mcp-integration.md`
- **MCP Integration:** `docs/mcp-integration.md`
- **Architecture:** `docs/architecture/overview.md`

---

## 💡 Example Workflow

```
User: "Here's the design: https://www.figma.com/file/ABC123/Login-Screen"

Agent:
1. ✅ Detects Figma link
2. ✅ Extracts file ID: "ABC123"
3. ✅ Checks MCP tools available
4. ✅ Uses: mcp_figma_file_get(fileId="ABC123")
5. ✅ Extracts design tokens via MCP
6. ✅ Analyzes and includes in requirements

NOT:
❌ fetch('https://www.figma.com/file/ABC123/Login-Screen')
❌ curl https://www.figma.com/file/ABC123/Login-Screen
```

---

**This rule must be followed to prevent 403 errors and ensure proper Figma integration.**


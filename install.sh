#!/bin/bash

# CCPM Team Agents Installation Script
# Copies .claude directory to your project and sets up environment configuration

set -e

# Check bash version (associative arrays require bash 4+)
if [ "${BASH_VERSION%%.*}" -lt 4 ]; then
    echo "Error: This script requires bash 4.0 or higher"
    echo "Current version: $BASH_VERSION"
    echo "On macOS, install newer bash: brew install bash"
    exit 1
fi

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory (where this script is located)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_SOURCE="$SCRIPT_DIR/.claude"

echo -e "${BLUE}🚀 CCPM Team Agents Installation${NC}"
echo "======================================"
echo ""

# Check if .claude directory exists
if [ ! -d "$CLAUDE_SOURCE" ]; then
    echo -e "${RED}❌ Error: .claude directory not found in $SCRIPT_DIR${NC}"
    echo "Please run this script from the ccpm-team-agents repository root."
    exit 1
fi

# Get target project path
if [ -z "$1" ]; then
    read -p "Enter your project path (absolute or relative): " TARGET_PROJECT
else
    TARGET_PROJECT="$1"
fi

# Convert to absolute path
if [[ ! "$TARGET_PROJECT" = /* ]]; then
    TARGET_PROJECT="$(cd "$TARGET_PROJECT" && pwd)"
fi

# Check if target directory exists
if [ ! -d "$TARGET_PROJECT" ]; then
    echo -e "${RED}❌ Error: Target directory does not exist: $TARGET_PROJECT${NC}"
    exit 1
fi

TARGET_CLAUDE="$TARGET_PROJECT/.claude"

echo -e "${BLUE}Target project:${NC} $TARGET_PROJECT"
echo -e "${BLUE}Target .claude:${NC} $TARGET_CLAUDE"
echo ""

# Check if .claude already exists in target
if [ -d "$TARGET_CLAUDE" ]; then
    echo -e "${YELLOW}⚠️  Warning: .claude directory already exists in target project${NC}"
    read -p "Overwrite? (yes/no): " OVERWRITE
    if [ "$OVERWRITE" != "yes" ]; then
        echo "Installation cancelled."
        exit 0
    fi
    echo "Removing existing .claude directory..."
    rm -rf "$TARGET_CLAUDE"
fi

# Copy .claude directory
echo -e "${BLUE}Copying .claude directory...${NC}"
cp -r "$CLAUDE_SOURCE" "$TARGET_CLAUDE"
echo -e "${GREEN}✅ .claude directory copied${NC}"
echo ""

# Read .envrc.template to get environment variable keys
ENVRC_TEMPLATE="$TARGET_CLAUDE/.envrc.template"

if [ ! -f "$ENVRC_TEMPLATE" ]; then
    echo -e "${RED}❌ Error: .envrc.template not found${NC}"
    exit 1
fi

# Extract environment variable names from template
echo -e "${BLUE}📝 Environment Configuration${NC}"
echo "======================================"
echo "Please provide values for environment variables."
echo "Press Enter to skip optional variables (empty values)."
echo "You can configure integrations later by editing .claude/.envrc"
echo ""

# Initialize variables
declare -A ENV_VARS 2>/dev/null || {
    echo -e "${RED}❌ Error: Associative arrays not supported${NC}"
    echo "This script requires bash 4.0 or higher"
    echo "On macOS, install newer bash: brew install bash"
    exit 1
}

# Function to prompt for env var
prompt_env_var() {
    local var_name=$1
    local description=$2
    local is_secret=${3:-false}
    local default_value=${4:-}
    
    local prompt_text="$description"
    if [ -n "$default_value" ]; then
        prompt_text="$prompt_text [$default_value]"
    fi
    
    local value=""
    if [ "$is_secret" = true ]; then
        read -sp "$prompt_text: " value
        echo ""
    else
        read -p "$prompt_text: " value
    fi
    
    # Use default if empty
    if [ -z "$value" ] && [ -n "$default_value" ]; then
        value="$default_value"
    fi
    
    # Escape quotes in value
    value="${value//\"/\\\"}"
    
    ENV_VARS["$var_name"]="$value"
}

# Prompt for key environment variables
echo -e "${YELLOW}Project Configuration:${NC}"
prompt_env_var "PROJECT_NAME" "Project Name" false ""
prompt_env_var "PROJECT_ENV" "Project Environment" false "development"

echo ""
echo -e "${YELLOW}Jira Integration (optional - press Enter to skip):${NC}"
prompt_env_var "JIRA_URL" "Jira URL (e.g., https://company.atlassian.net)" false ""
prompt_env_var "JIRA_EMAIL" "Jira Email" false ""
prompt_env_var "JIRA_API_TOKEN" "Jira API Token" true ""
prompt_env_var "JIRA_PROJECT_KEY" "Jira Project Key" false ""

echo ""
echo -e "${YELLOW}Confluence Integration (optional - press Enter to skip):${NC}"
prompt_env_var "CONFLUENCE_URL" "Confluence URL" false ""
prompt_env_var "CONFLUENCE_EMAIL" "Confluence Email" false ""
prompt_env_var "CONFLUENCE_API_TOKEN" "Confluence API Token" true ""
prompt_env_var "CONFLUENCE_SPACE_KEY" "Confluence Space Key" false ""

echo ""
echo -e "${YELLOW}Slack Integration (optional - press Enter to skip):${NC}"
prompt_env_var "SLACK_BOT_TOKEN" "Slack Bot Token (xoxb-...)" true ""
prompt_env_var "SLACK_CHANNEL_ID" "Slack Channel ID" false ""
prompt_env_var "SLACK_WEBHOOK_URL" "Slack Webhook URL" false ""

echo ""
echo -e "${YELLOW}Figma Integration (optional - press Enter to skip):${NC}"
prompt_env_var "FIGMA_ACCESS_TOKEN" "Figma Access Token (figd_...)" true ""
prompt_env_var "FIGMA_FILE_KEY" "Figma File Key" false ""

echo ""
echo -e "${YELLOW}Git Configuration (optional):${NC}"
prompt_env_var "GIT_AUTHOR_NAME" "Git Author Name" false ""
prompt_env_var "GIT_AUTHOR_EMAIL" "Git Author Email" false ""

# Create .envrc file
ENVRC_FILE="$TARGET_CLAUDE/.envrc"
echo ""
echo -e "${BLUE}Creating .envrc file...${NC}"

# Generate .envrc from template
cat > "$ENVRC_FILE" << 'EOF'
# .claude/.envrc - CCPM Integration Configuration
# Auto-generated by install.sh
# Date: 
# DO NOT COMMIT THIS FILE

EOF

# Replace date
sed -i.bak "s/Date: /Date: $(date +%Y-%m-%d)/" "$ENVRC_FILE" 2>/dev/null || \
sed -i "s/Date: /Date: $(date +%Y-%m-%d)/" "$ENVRC_FILE"
rm -f "$ENVRC_FILE.bak" 2>/dev/null || true

# Append environment variables
# Use printf to avoid heredoc expansion issues
{
    echo ""
    echo "# ============================================"
    echo "# Project Configuration"
    echo "# ============================================"
    printf 'export PROJECT_NAME="%s"\n' "${ENV_VARS[PROJECT_NAME]}"
    printf 'export PROJECT_ENV="%s"\n' "${ENV_VARS[PROJECT_ENV]:-development}"
    
    echo ""
    echo "# ============================================"
    echo "# Jira Integration"
    echo "# ============================================"
    printf 'export JIRA_URL="%s"\n' "${ENV_VARS[JIRA_URL]}"
    printf 'export JIRA_EMAIL="%s"\n' "${ENV_VARS[JIRA_EMAIL]}"
    printf 'export JIRA_API_TOKEN="%s"\n' "${ENV_VARS[JIRA_API_TOKEN]}"
    printf 'export JIRA_PROJECT_KEY="%s"\n' "${ENV_VARS[JIRA_PROJECT_KEY]}"
    printf 'export JIRA_DEFAULT_ASSIGNEE="%s"\n' "${ENV_VARS[JIRA_DEFAULT_ASSIGNEE]}"
    printf 'export JIRA_DEFAULT_PRIORITY="%s"\n' "${ENV_VARS[JIRA_DEFAULT_PRIORITY]:-Medium}"
    printf 'export JIRA_BOARD_ID="%s"\n' "${ENV_VARS[JIRA_BOARD_ID]}"
    
    echo ""
    echo "# ============================================"
    echo "# Confluence Integration"
    echo "# ============================================"
    printf 'export CONFLUENCE_URL="%s"\n' "${ENV_VARS[CONFLUENCE_URL]}"
    printf 'export CONFLUENCE_EMAIL="%s"\n' "${ENV_VARS[CONFLUENCE_EMAIL]}"
    printf 'export CONFLUENCE_API_TOKEN="%s"\n' "${ENV_VARS[CONFLUENCE_API_TOKEN]}"
    printf 'export CONFLUENCE_SPACE_KEY="%s"\n' "${ENV_VARS[CONFLUENCE_SPACE_KEY]}"
    printf 'export CONFLUENCE_PARENT_PAGE_ID="%s"\n' "${ENV_VARS[CONFLUENCE_PARENT_PAGE_ID]}"
    printf 'export CONFLUENCE_DEFAULT_LABELS="%s"\n' "${ENV_VARS[CONFLUENCE_DEFAULT_LABELS]:-ccpm,generated,documentation}"
    
    echo ""
    echo "# ============================================"
    echo "# Slack Integration"
    echo "# ============================================"
    printf 'export SLACK_BOT_TOKEN="%s"\n' "${ENV_VARS[SLACK_BOT_TOKEN]}"
    printf 'export SLACK_CHANNEL_ID="%s"\n' "${ENV_VARS[SLACK_CHANNEL_ID]}"
    printf 'export SLACK_WEBHOOK_URL="%s"\n' "${ENV_VARS[SLACK_WEBHOOK_URL]}"
    printf 'export SLACK_MENTION_DEV="%s"\n' "${ENV_VARS[SLACK_MENTION_DEV]:-@developer-team}"
    printf 'export SLACK_MENTION_QA="%s"\n' "${ENV_VARS[SLACK_MENTION_QA]:-@qa-team}"
    printf 'export SLACK_MENTION_PM="%s"\n' "${ENV_VARS[SLACK_MENTION_PM]:-@pm-team}"
    
    echo ""
    echo "# ============================================"
    echo "# Figma Integration"
    echo "# ============================================"
    printf 'export FIGMA_ACCESS_TOKEN="%s"\n' "${ENV_VARS[FIGMA_ACCESS_TOKEN]}"
    printf 'export FIGMA_FILE_KEY="%s"\n' "${ENV_VARS[FIGMA_FILE_KEY]}"
    printf 'export FIGMA_TEAM_ID="%s"\n' "${ENV_VARS[FIGMA_TEAM_ID]}"
    printf 'export FIGMA_MCP_ENABLED="%s"\n' "${ENV_VARS[FIGMA_MCP_ENABLED]:-true}"
    
    echo ""
    echo "# ============================================"
    echo "# CCPM Configuration"
    echo "# ============================================"
    printf 'export CCPM_AUTO_APPROVE="%s"\n' "${ENV_VARS[CCPM_AUTO_APPROVE]:-true}"
    printf 'export CCPM_DEFAULT_COVERAGE="%s"\n' "${ENV_VARS[CCPM_DEFAULT_COVERAGE]:-80}"
    printf 'export CCPM_TDD_ENFORCE="%s"\n' "${ENV_VARS[CCPM_TDD_ENFORCE]:-true}"
    printf 'export CCPM_AUTO_NOTIFY="%s"\n' "${ENV_VARS[CCPM_AUTO_NOTIFY]:-true}"
    printf 'export CCPM_TOKEN_WARNING="%s"\n' "${ENV_VARS[CCPM_TOKEN_WARNING]:-150000}"
    
    echo ""
    echo "# ============================================"
    echo "# Optional: Git Configuration"
    echo "# ============================================"
    printf 'export GIT_AUTHOR_NAME="%s"\n' "${ENV_VARS[GIT_AUTHOR_NAME]}"
    printf 'export GIT_AUTHOR_EMAIL="%s"\n' "${ENV_VARS[GIT_AUTHOR_EMAIL]}"
} >> "$ENVRC_FILE"

echo -e "${GREEN}✅ .envrc file created${NC}"
echo ""

# Create settings.local.json from settings.example.json
SETTINGS_EXAMPLE="$TARGET_CLAUDE/settings.example.json"
SETTINGS_LOCAL="$TARGET_CLAUDE/settings.local.json"

if [ -f "$SETTINGS_EXAMPLE" ]; then
    echo -e "${BLUE}Creating settings.local.json...${NC}"
    cp "$SETTINGS_EXAMPLE" "$SETTINGS_LOCAL"
    echo -e "${GREEN}✅ settings.local.json created${NC}"
    echo ""
else
    echo -e "${YELLOW}⚠️  Warning: settings.example.json not found${NC}"
fi

# Summary
echo -e "${GREEN}======================================"
echo "✅ Installation Complete!"
echo "======================================${NC}"
echo ""
echo "CCPM Team Agents has been installed to:"
echo -e "  ${BLUE}$TARGET_CLAUDE${NC}"
echo ""
echo "Configuration files created:"
echo -e "  ✅ ${BLUE}$ENVRC_FILE${NC} (environment variables - git-ignored)"
echo -e "  ✅ ${BLUE}$SETTINGS_LOCAL${NC} (local settings - git-ignored)"
echo ""
echo "Next steps:"
echo "  1. Review and edit $ENVRC_FILE if needed"
echo "  2. Review and edit $SETTINGS_LOCAL if needed"
echo "  3. Start using CCPM: ${BLUE}workflow:start \"Your task\"${NC}"
echo ""
echo "📚 Documentation: $TARGET_CLAUDE/README.md"
echo ""


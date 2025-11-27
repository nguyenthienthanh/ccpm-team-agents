#!/bin/bash
# CCPM Version Sync Script
# Purpose: Synchronize version numbers across all configuration files
# Usage: ./scripts/sync-version.sh [VERSION]
# Example: ./scripts/sync-version.sh 5.1.0

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CCPM_DIR="$PROJECT_ROOT/ccpm"

# Version pattern
VERSION_PATTERN="[0-9]+\.[0-9]+\.[0-9]+"

# Files to update
declare -a FILES=(
  "$CCPM_DIR/CLAUDE.md"
  "$CCPM_DIR/README.md"
  "$CCPM_DIR/ccpm-config.yaml"
  "$CCPM_DIR/GET_STARTED.md"
  "$CCPM_DIR/TODO.md"
  "$PROJECT_ROOT/README.md"
)

print_header() {
  echo ""
  echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║${NC}  📦 CCPM Version Sync Script                           ${BLUE}║${NC}"
  echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
  echo ""
}

print_success() {
  echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
  echo -e "${RED}❌ $1${NC}"
}

print_info() {
  echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}⚠️  $1${NC}"
}

# Get current version from CLAUDE.md
get_current_version() {
  if [ -f "$CCPM_DIR/CLAUDE.md" ]; then
    grep -m 1 "Version:" "$CCPM_DIR/CLAUDE.md" | sed -E 's/.*Version:\*\* ([0-9]+\.[0-9]+\.[0-9]+(-[a-z]+)?).*/\1/'
  else
    echo "5.0.0-beta"
  fi
}

# Validate version format
validate_version() {
  local version=$1
  if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[a-z]+)?$ ]]; then
    print_error "Invalid version format: $version"
    print_info "Expected format: X.Y.Z or X.Y.Z-suffix (e.g., 5.0.0 or 5.0.0-beta)"
    exit 1
  fi
}

# Update version in specific file
update_file_version() {
  local file=$1
  local old_version=$2
  local new_version=$3

  if [ ! -f "$file" ]; then
    print_warning "File not found: $file (skipping)"
    return
  fi

  # Backup file
  cp "$file" "$file.bak"

  # Different patterns for different files
  case "$file" in
    *ccpm-config.yaml)
      # Update YAML version field
      sed -i '' "s/version: '[0-9.]*'/version: '$new_version'/" "$file"
      sed -i '' "s/# Version: [0-9.-]*/# Version: $new_version/" "$file"
      ;;
    *.md)
      # Update markdown version references
      sed -i '' "s/\*\*Version:\*\* [0-9.-]*[a-z]*/\*\*Version:\*\* $new_version/" "$file"
      sed -i '' "s/Version: [0-9.-]*[a-z]*/Version: $new_version/" "$file"
      sed -i '' "s/v[0-9]\.[0-9]\.[0-9](-[a-z]*)?/v$new_version/g" "$file"
      ;;
  esac

  # Check if file was actually modified
  if diff -q "$file" "$file.bak" > /dev/null; then
    print_warning "No changes made to $(basename "$file")"
    rm "$file.bak"
  else
    print_success "Updated $(basename "$file")"
    rm "$file.bak"
  fi
}

# Main execution
main() {
  print_header

  # Get target version
  if [ -n "$1" ]; then
    NEW_VERSION="$1"
    print_info "Target version: $NEW_VERSION"
  else
    CURRENT_VERSION=$(get_current_version)
    print_info "Current version: $CURRENT_VERSION"
    echo ""
    read -p "Enter new version (or press Enter to keep current): " NEW_VERSION

    if [ -z "$NEW_VERSION" ]; then
      NEW_VERSION="$CURRENT_VERSION"
      print_info "Keeping current version: $NEW_VERSION"
    fi
  fi

  # Validate version
  validate_version "$NEW_VERSION"

  echo ""
  print_info "Updating version to: $NEW_VERSION"
  echo ""

  # Get old version for comparison
  OLD_VERSION=$(get_current_version)

  # Update all files
  for file in "${FILES[@]}"; do
    update_file_version "$file" "$OLD_VERSION" "$NEW_VERSION"
  done

  echo ""
  print_success "Version sync complete!"
  echo ""
  print_info "Files updated:"
  for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
      echo "  - $(basename "$file")"
    fi
  done

  echo ""
  print_info "Next steps:"
  echo "  1. Review changes: git diff"
  echo "  2. Update CHANGELOG.md with new version"
  echo "  3. Commit changes: git commit -am \"chore: Bump version to $NEW_VERSION\""
  echo "  4. Tag release: git tag v$NEW_VERSION"
  echo ""
}

# Run main function
main "$@"

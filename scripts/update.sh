#!/bin/bash

# Global Rules Update Script for MacOS/Linux
# Repository: https://github.com/wowpeterhkg/Global-Rules-Windsurf-Dev

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULES_DIR="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Global Rules Update Script${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if we're in a git repository
if [ ! -d "$RULES_DIR/.git" ]; then
    echo -e "${RED}Error: Not a git repository.${NC}"
    echo "Please ensure you cloned the repository using git."
    exit 1
fi

cd "$RULES_DIR"

# Get current version
CURRENT_VERSION="unknown"
if [ -f "VERSION" ]; then
    CURRENT_VERSION=$(cat VERSION)
fi
echo -e "${YELLOW}Current version:${NC} $CURRENT_VERSION"

# Fetch latest changes
echo ""
echo -e "${BLUE}Checking for updates...${NC}"
git fetch origin main 2>/dev/null || git fetch origin master 2>/dev/null

# Check if there are updates
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main 2>/dev/null || git rev-parse origin/master 2>/dev/null)

if [ "$LOCAL" = "$REMOTE" ]; then
    echo -e "${GREEN}✓ You are already on the latest version.${NC}"
    echo ""
    exit 0
fi

# Show what's new
echo ""
echo -e "${YELLOW}Updates available:${NC}"
git log HEAD..origin/main --oneline 2>/dev/null || git log HEAD..origin/master --oneline 2>/dev/null
echo ""

# Confirm update
read -p "Do you want to update? (y/n): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Update cancelled.${NC}"
    exit 0
fi

# Backup user data
echo ""
echo -e "${BLUE}Backing up user data...${NC}"
BACKUP_DIR="$RULES_DIR/.backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

if [ -d "$RULES_DIR/.users" ]; then
    cp -r "$RULES_DIR/.users" "$BACKUP_DIR/"
    echo -e "${GREEN}✓ User profiles backed up${NC}"
fi

if [ -d "$RULES_DIR/.teams" ]; then
    cp -r "$RULES_DIR/.teams" "$BACKUP_DIR/"
    echo -e "${GREEN}✓ Team files backed up${NC}"
fi

# Check for local changes
if [ -n "$(git status --porcelain)" ]; then
    echo ""
    echo -e "${YELLOW}Warning: You have local changes.${NC}"
    echo "Stashing local changes..."
    git stash push -m "Auto-stash before update $(date +%Y%m%d_%H%M%S)"
    STASHED=true
else
    STASHED=false
fi

# Pull updates
echo ""
echo -e "${BLUE}Downloading updates...${NC}"
git pull origin main 2>/dev/null || git pull origin master 2>/dev/null

# Get new version
NEW_VERSION="unknown"
if [ -f "VERSION" ]; then
    NEW_VERSION=$(cat VERSION)
fi

# Restore stashed changes if any
if [ "$STASHED" = true ]; then
    echo ""
    echo -e "${BLUE}Restoring local changes...${NC}"
    git stash pop || echo -e "${YELLOW}Warning: Could not restore some local changes. Check git stash list.${NC}"
fi

# Show changelog if available
if [ -f "CHANGELOG.md" ]; then
    echo ""
    echo -e "${BLUE}Recent changes:${NC}"
    head -50 CHANGELOG.md
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Update Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "Updated from ${YELLOW}$CURRENT_VERSION${NC} to ${GREEN}$NEW_VERSION${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Restart Windsurf to load the updated rules"
echo "2. Review CHANGELOG.md for detailed changes"
echo ""
echo -e "Backup location: ${BLUE}$BACKUP_DIR${NC}"
echo ""

#!/usr/bin/env bash

# ============================================================================
# Quick Commit Script
# ============================================================================
# Helper script to quickly commit and push your Neovim configuration changes

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Quick Commit Helper Script        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo -e "${YELLOW}Error: Not in a git repository!${NC}"
    exit 1
fi

# Show current status
echo -e "${BLUE}Current changes:${NC}"
git status --short
echo ""

# Check if there are any changes
if [[ -z $(git status --porcelain) ]]; then
    echo -e "${GREEN}No changes to commit!${NC}"
    exit 0
fi

# Show diff summary
echo -e "${BLUE}Would you like to see detailed changes? (y/n)${NC}"
read -n 1 -r SHOW_DIFF
echo ""
if [[ $SHOW_DIFF =~ ^[Yy]$ ]]; then
    git diff
    echo ""
fi

# Ask for commit message
echo -e "${BLUE}Enter commit message:${NC}"
read -r COMMIT_MSG

# Validate commit message
if [[ -z "$COMMIT_MSG" ]]; then
    echo -e "${YELLOW}Commit message cannot be empty!${NC}"
    exit 1
fi

# Add all changes
echo -e "${BLUE}Adding all changes...${NC}"
git add .

# Show what will be committed
echo ""
echo -e "${BLUE}Files to be committed:${NC}"
git diff --staged --name-only
echo ""

# Confirm commit
echo -e "${BLUE}Proceed with commit? (y/n)${NC}"
read -n 1 -r CONFIRM
echo ""
if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Commit cancelled.${NC}"
    git reset HEAD .
    exit 0
fi

# Commit changes
echo -e "${BLUE}Committing changes...${NC}"
git commit -m "$COMMIT_MSG"
echo -e "${GREEN}✓ Changes committed successfully!${NC}"
echo ""

# Ask about pushing
echo -e "${BLUE}Push to remote repository? (y/n)${NC}"
read -n 1 -r PUSH
echo ""
if [[ $PUSH =~ ^[Yy]$ ]]; then
    BRANCH=$(git branch --show-current)
    echo -e "${BLUE}Pushing to origin/$BRANCH...${NC}"
    git push origin "$BRANCH"
    echo -e "${GREEN}✓ Changes pushed successfully!${NC}"
else
    echo -e "${YELLOW}Changes committed locally but not pushed.${NC}"
    echo -e "${YELLOW}Run 'git push' when ready to push.${NC}"
fi

echo ""
echo -e "${GREEN}Done! 🚀${NC}"

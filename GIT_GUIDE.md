# Git Commands Reference for Your Config

This file contains common Git commands you'll need to commit and manage your Neovim configuration.

## 📋 Basic Workflow

### 1. Check What Changed
```bash
cd ~/.config/nvim
git status
```

### 2. View Specific Changes
```bash
# See all changes
git diff

# See changes in a specific file
git diff lua/config/options.lua

# See staged changes
git diff --staged
```

### 3. Add Files to Commit
```bash
# Add all changes
git add .

# Add specific file
git add lua/plugins/init.lua

# Add multiple specific files
git add lua/config/options.lua lua/config/keymaps.lua

# Add all Lua files
git add "*.lua"
```

### 4. Commit Changes
```bash
# Commit with a message
git commit -m "Add telescope configuration"

# Commit with detailed message (opens editor)
git commit

# Add and commit in one command
git commit -am "Update keymaps"
```

### 5. Push to GitHub
```bash
# Push to main branch
git push origin main

# Push to current branch
git push
```

## 🔄 Common Scenarios

### Scenario 1: Added New Plugins
```bash
cd ~/.config/nvim
git status                               # Check changes
git add lua/plugins/                     # Add plugin configs
git commit -m "Add new plugins: X, Y, Z"
git push origin main
```

### Scenario 2: Modified Keymaps
```bash
cd ~/.config/nvim
git status                               # Check changes
git diff lua/config/keymaps.lua          # Review changes
git add lua/config/keymaps.lua
git commit -m "Update keymaps for better workflow"
git push origin main
```

### Scenario 3: Multiple File Changes
```bash
cd ~/.config/nvim
git status                               # See all changes
git add .                                # Add everything
git commit -m "Major config update: options, keymaps, and plugins"
git push origin main
```

### Scenario 4: Made a Mistake
```bash
# Undo changes before adding (unstaged)
git checkout -- lua/config/options.lua

# Undo changes after adding (staged)
git reset HEAD lua/config/options.lua
git checkout -- lua/config/options.lua

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes) - CAREFUL!
git reset --hard HEAD~1
```

## 📊 Viewing History

```bash
# View commit history
git log

# View compact history
git log --oneline

# View history with file changes
git log --stat

# View last 5 commits
git log -5

# View changes in last commit
git show
```

## 🌿 Working with Branches

```bash
# Create new branch for experimental changes
git checkout -b experimental

# Switch back to main
git checkout main

# List all branches
git branch

# Delete a branch
git branch -d experimental
```

## 🔍 Useful Commands

```bash
# See who changed what in a file
git blame lua/config/options.lua

# See all commits that changed a file
git log -- lua/plugins/init.lua

# Search commits for a word
git log --grep="telescope"

# Find when a bug was introduced
git bisect start
```

## 💡 Best Practices

### Good Commit Messages
```bash
# ❌ Bad
git commit -m "stuff"
git commit -m "updates"

# ✅ Good
git commit -m "Add telescope fuzzy finder with custom keybinds"
git commit -m "Fix treesitter configuration for Python"
git commit -m "Update LSP settings for better diagnostics"
```

### Commit Frequency
- Commit after completing a logical change
- Don't commit broken configurations
- Test your config before committing

### Before Pushing
```bash
# Always check what you're pushing
git status
git diff

# Test your config
nvim --headless +q  # Quick syntax check
```

## 🆘 Emergency Commands

```bash
# Stash current changes temporarily
git stash
git stash pop  # Restore stashed changes

# Discard ALL local changes (DANGEROUS!)
git reset --hard HEAD

# Pull latest changes from GitHub
git pull origin main

# Force push (use with caution!)
git push --force origin main
```

## 📝 Quick Reference Card

```bash
# Status and diff
git status              # What changed?
git diff               # Show changes
git log --oneline      # History

# Adding and committing
git add .              # Add all
git add <file>         # Add specific file
git commit -m "msg"    # Commit with message

# Pushing and pulling
git push               # Upload changes
git pull               # Download changes

# Undoing
git checkout -- <file> # Discard changes
git reset HEAD <file>  # Unstage
git reset --soft HEAD~1 # Undo last commit
```

## 🔗 More Resources

- [Official Git Documentation](https://git-scm.com/doc)
- [GitHub Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)
- [Interactive Git Tutorial](https://learngitbranching.js.org/)

---

**Remember**: Commit early, commit often, and always write meaningful commit messages! 🚀

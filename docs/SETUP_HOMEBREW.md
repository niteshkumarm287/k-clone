# 🍺 Homebrew Setup Guide for k-clone

## Two Options for Installation

### Option A: Simple (Current Setup)
Users install directly:
```bash
curl -o /usr/local/bin/k-clone https://raw.githubusercontent.com/niteshkumarm287/k-clone/main/k-clone.zsh
chmod +x /usr/local/bin/k-clone
```

### Option B: Full Homebrew Tap (Requires New Repo)

Create a new repository named `homebrew-k-clone` on GitHub, then:

## Quick Setup Steps

### 1. Create New Repository on GitHub
```bash
# Go to https://github.com/new
# Name: homebrew-k-clone
# Description: Homebrew tap for k-clone
# Public repository
```

### 2. Clone and Setup the Tap Repo
```bash
git clone https://github.com/niteshkumarm287/homebrew-k-clone.git
cd homebrew-k-clone
mkdir -p Formula
cp /path/to/k-clone/Formula/k-clone.rb Formula/
git add Formula/k-clone.rb
git commit -m "Add k-clone formula"
git push origin main
```

### 3. Users Can Now Install
```bash
brew tap niteshkumarm287/k-clone
brew install k-clone
```

Or one-line:
```bash
brew install niteshkumarm287/k-clone/k-clone
```

---

## Alternative: Skip Homebrew, Use Direct Install

Update your README with this simpler approach:

```bash
# Install
curl -o /usr/local/bin/k-clone https://raw.githubusercontent.com/niteshkumarm287/k-clone/main/k-clone.zsh
chmod +x /usr/local/bin/k-clone

# Uninstall
rm /usr/local/bin/k-clone
```

This avoids the Xcode/build issues and works immediately.

## Future Updates

When releasing new versions:

1. Update the script
2. Commit changes
3. Create new tag (e.g., `v1.1.0`)
4. Download new release tarball and get SHA256
5. Update `Formula/k-clone.rb` with new version and SHA256
6. Push changes

Users will get updates via: `brew upgrade k-clone`

## Troubleshooting

### Formula Audit
```bash
brew audit --strict --online Formula/k-clone.rb
```

### Formula Style Check
```bash
brew style Formula/k-clone.rb
```

### Test Installation from GitHub
```bash
brew install https://raw.githubusercontent.com/niteshkumarm287/k-clone/main/Formula/k-clone.rb
```

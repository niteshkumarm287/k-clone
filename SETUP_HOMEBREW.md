# 🍺 Homebrew Setup Guide for k-clone

## Quick Setup Steps

### 1. Commit and Push Current Changes
```bash
git add .
git commit -m "Setup Homebrew formula v1.0.0"
git push origin main
```

### 2. Create and Push a Version Tag
```bash
git tag v1.0.0
git push origin v1.0.0
```

### 3. Calculate the SHA256 for the Release
```bash
# Download the release tarball and get its SHA256
curl -L https://github.com/niteshkumarm287/k-clone/archive/refs/tags/v1.0.0.tar.gz | shasum -a 256
```

### 4. Update the Formula with Correct SHA256
- Open `Formula/k-clone.rb`
- Replace `PLACEHOLDER_SHA256` with the actual SHA256 from step 3
- Commit and push:
```bash
git add Formula/k-clone.rb
git commit -m "Update formula SHA256"
git push origin main
```

### 5. Test Installation Locally
```bash
brew install --build-from-source Formula/k-clone.rb
k-clone --help
brew uninstall k-clone
```

## Public Installation

Once setup is complete, users can install via:

### Option 1: Direct tap and install
```bash
brew tap niteshkumarm287/k-clone https://github.com/niteshkumarm287/k-clone
brew install k-clone
```

### Option 2: One-line install
```bash
brew install niteshkumarm287/k-clone/k-clone
```

## Repository Structure

Your repo serves as both:
- **Source code repository** (the script itself)
- **Homebrew tap** (contains the Formula directory)

This is a valid Homebrew tap setup. The repository name doesn't need to be `homebrew-*` for direct tap usage.

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

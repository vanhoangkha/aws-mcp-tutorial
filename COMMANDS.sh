#!/bin/bash

# Quick Push Commands for AWS MCP Tutorial
# Replace YOUR_USERNAME with your actual GitHub username

echo "🚀 AWS MCP Tutorial - GitHub Push Commands"
echo "=========================================="
echo ""

# Prompt for username
read -p "Enter your GitHub username: " GITHUB_USERNAME

if [ -z "$GITHUB_USERNAME" ]; then
    echo "❌ Username cannot be empty!"
    exit 1
fi

echo ""
echo "Repository URL: https://github.com/$GITHUB_USERNAME/aws-mcp-tutorial"
echo ""

# Change to project directory
cd /home/ubuntu/aws-mcp-tutorial || exit 1

# Check if remote already exists
if git remote | grep -q "origin"; then
    echo "⚠️  Remote 'origin' already exists. Removing..."
    git remote remove origin
fi

# Add remote
echo "📝 Adding remote origin..."
git remote add origin "https://github.com/$GITHUB_USERNAME/aws-mcp-tutorial.git"

# Verify remote
echo ""
echo "✓ Remote added:"
git remote -v
echo ""

# Push
echo "⬆️  Pushing to GitHub..."
echo "You will be asked for:"
echo "  Username: $GITHUB_USERNAME"
echo "  Password: [Your Personal Access Token]"
echo ""
echo "If you don't have a token, get one here:"
echo "https://github.com/settings/tokens"
echo ""

read -p "Press Enter to continue with push..."

git push -u origin main

# Check if push was successful
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Successfully pushed to GitHub!"
    echo ""
    echo "🎉 Your repository is now live at:"
    echo "   https://github.com/$GITHUB_USERNAME/aws-mcp-tutorial"
    echo ""
    echo "Next steps:"
    echo "  1. Visit the repository URL above"
    echo "  2. Add topics/tags in Settings"
    echo "  3. Share with the community!"
else
    echo ""
    echo "❌ Push failed!"
    echo ""
    echo "Common issues:"
    echo "  1. Authentication failed - Check your token"
    echo "  2. Repository doesn't exist - Create it first at https://github.com/new"
    echo "  3. Permission denied - Ensure token has 'repo' scope"
    echo ""
    echo "See PUSH_TO_GITHUB.md for detailed troubleshooting"
fi

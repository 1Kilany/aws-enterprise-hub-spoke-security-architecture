#!/bin/bash

echo ""
echo "======================================="
echo " AWS Enterprise Hub-Spoke GitHub Push"
echo "======================================="
echo ""

# Make sure we're inside a git repo
if [ ! -d ".git" ]; then
    echo "❌ This is not a Git repository."
    exit 1
fi

echo "Current remote:"
git remote -v

echo ""
echo "Pulling latest changes..."
git pull origin main

echo ""
echo "Repository status:"
git status

echo ""
echo "Adding all files..."
git add .

echo ""
read -p "Commit message (leave blank for automatic): " msg

if [ -z "$msg" ]; then
    msg="Update project - $(date '+%Y-%m-%d %H:%M:%S')"
fi

echo ""
echo "Creating commit..."
git commit -m "$msg"

echo ""
echo "Pushing..."
git push origin main

echo ""
echo "Latest commit:"
git log --oneline -1

echo ""
echo "======================================="
echo "Done!"
echo "======================================="
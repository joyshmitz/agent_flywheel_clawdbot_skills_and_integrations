#!/bin/bash
# Agent Flywheel Clawdbot Skills Installer
# Symlinks all skills to your Clawdbot workspace

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$SCRIPT_DIR/skills"

# Determine target directory
if [ -n "$1" ]; then
    SKILLS_DST="$1"
elif [ -d "$HOME/.clawdbot/skills" ]; then
    SKILLS_DST="$HOME/.clawdbot/skills"
elif [ -d "$HOME/clawd/skills" ]; then
    SKILLS_DST="$HOME/clawd/skills"
else
    SKILLS_DST="$HOME/.clawdbot/skills"
    mkdir -p "$SKILLS_DST"
fi

echo "Installing skills to: $SKILLS_DST"
echo ""

# Count skills
SKILL_COUNT=0

for skill_dir in "$SKILLS_SRC"/*/; do
    skill_name=$(basename "$skill_dir")
    target="$SKILLS_DST/$skill_name"

    if [ -L "$target" ]; then
        echo "  [skip] $skill_name (already linked)"
    elif [ -d "$target" ]; then
        echo "  [skip] $skill_name (directory exists)"
    else
        ln -sf "$skill_dir" "$target"
        echo "  [link] $skill_name"
        ((SKILL_COUNT++))
    fi
done

echo ""
echo "Installed $SKILL_COUNT new skills."
echo ""
echo "Next steps:"
echo "  1. Enable skills in your clawdbot.json:"
echo ""
echo '     "skills": {'
echo '       "entries": {'
for skill_dir in "$SKILLS_SRC"/*/; do
    skill_name=$(basename "$skill_dir")
    echo "         \"$skill_name\": { \"enabled\": true },"
done
echo '       }'
echo '     }'
echo ""
echo "  2. Restart your Clawdbot gateway"
echo ""

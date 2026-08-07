#!/bin/bash
# Sentinel Skills Installer for Claude Code (macOS/Linux)
# Symlinks every skill into the personal Claude Code skills directory so the
# /sentinel-* commands are available in every project. Because these are links,
# a later 'git pull' in this repository updates the installed skills instantly.

set -u

CLAUDE_SKILLS_DIR="$HOME/.claude/skills"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_SKILLS_DIR="$REPO_DIR/skills"

echo "Installing Sentinel skills into Claude Code..."

if [ ! -d "$SOURCE_SKILLS_DIR" ]; then
    echo "[ERROR] Source skills directory not found: $SOURCE_SKILLS_DIR"
    exit 1
fi

mkdir -p "$CLAUDE_SKILLS_DIR"

installed=0
failed=""

for skill_path in "$SOURCE_SKILLS_DIR"/*/; do
    [ -d "$skill_path" ] || continue
    skill_name="$(basename "$skill_path")"
    target_dir="$CLAUDE_SKILLS_DIR/$skill_name"

    echo "  -> $skill_name"

    rm -rf "$target_dir"
    ln -s "${skill_path%/}" "$target_dir" 2>/dev/null

    # Verify the skill is actually readable at its destination before counting it.
    if [ -f "$target_dir/SKILL.md" ]; then
        installed=$((installed + 1))
    else
        failed="$failed $skill_name"
    fi
done

echo ""
if [ -z "$failed" ] && [ "$installed" -gt 0 ]; then
    echo "[OK] $installed skill(s) linked into $CLAUDE_SKILLS_DIR"
    echo "     They are symlinks, so 'git pull' in this repo updates them automatically."
    echo "     Restart Claude Code, then try /sentinel-help"
    exit 0
else
    echo "[FAILED] $installed installed, failed:$failed"
    exit 1
fi

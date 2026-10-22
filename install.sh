#!/bin/bash
# Sentinel Skills Installer for Claude Code and Codex (macOS/Linux)
# Symlinks every skill into the personal Claude Code skills directory so the
# /sentinel-* commands are available in every project. Because these are links,
# a later 'git pull' in this repository updates the installed skills instantly.

set -eu

target=claude
skills_dir=""
while [ "$#" -gt 0 ]; do
    case "$1" in
        --target|--skills-dir)
            [ "$#" -ge 2 ] || { echo "[ERROR] Missing value for $1"; exit 1; }
            case "$1" in
                --target) target="$2" ;;
                --skills-dir) skills_dir="$2" ;;
            esac
            shift 2 ;;
        *) echo "[ERROR] Unknown argument: $1"; exit 1 ;;
    esac
done
case "$target" in
    claude) skills_dir="${skills_dir:-$HOME/.claude/skills}" ;;
    codex) skills_dir="${skills_dir:-$HOME/.agents/skills}" ;;
    *) echo "[ERROR] Target must be claude or codex"; exit 1 ;;
esac
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_SKILLS_DIR="$REPO_DIR/skills"

echo "Installing Sentinel skills for $target into $skills_dir..."

if [ ! -d "$SOURCE_SKILLS_DIR" ]; then
    echo "[ERROR] Source skills directory not found: $SOURCE_SKILLS_DIR"
    exit 1
fi

mkdir -p "$skills_dir"
skills_dir="$(cd "$skills_dir" && pwd -P)"

installed=0
failed=""

for skill_path in "$SOURCE_SKILLS_DIR"/*/; do
    [ -d "$skill_path" ] || continue
    skill_name="$(basename "$skill_path")"
    target_dir="$skills_dir/$skill_name"

    echo "  -> $skill_name"

    if [ ! -f "$skill_path/SKILL.md" ]; then
        echo "     [FAILED] Source SKILL.md missing"
        failed="$failed $skill_name"
        continue
    fi
    if [ -L "$target_dir" ] && [ -f "$target_dir/SKILL.md" ] &&
        [ "$(cd "$target_dir" && pwd -P)" = "$(cd "$skill_path" && pwd -P)" ]; then
        installed=$((installed + 1))
        continue
    fi
    if [ -e "$target_dir" ] || [ -L "$target_dir" ]; then
        echo "     [CONFLICT] Existing destination preserved: $target_dir"
        failed="$failed $skill_name"
        continue
    fi
    if ! ln -s "${skill_path%/}" "$target_dir"; then
        failed="$failed $skill_name"
        continue
    fi

    # Verify the skill is actually readable at its destination before counting it.
    if [ -f "$target_dir/SKILL.md" ]; then
        installed=$((installed + 1))
    else
        failed="$failed $skill_name"
    fi
done

echo ""
if [ -z "$failed" ] && [ "$installed" -gt 0 ]; then
    echo "[OK] $installed skill(s) linked into $skills_dir"
    echo "     They are symlinks, so 'git pull' in this repo updates them automatically."
    if [ "$target" = codex ]; then
        echo '     In Codex, invoke $sentinel-help. Restart if skills do not appear.'
    else
        echo '     Restart Claude Code, then try /sentinel-help'
    fi
    exit 0
else
    echo "[FAILED] $installed installed, failed:$failed"
    exit 1
fi

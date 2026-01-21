#!/bin/bash

# Installation script for methodology-skills
# Links skills to global Claude Code directory (~/.claude/skills/)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SOURCE="$SCRIPT_DIR/.claude/skills"
GLOBAL_SKILLS_DIR="$HOME/.claude/skills"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

install_skills() {
    echo "Installing methodology-skills to $GLOBAL_SKILLS_DIR"
    echo ""

    # Create global skills directory if it doesn't exist
    if [ ! -d "$GLOBAL_SKILLS_DIR" ]; then
        mkdir -p "$GLOBAL_SKILLS_DIR"
        print_success "Created $GLOBAL_SKILLS_DIR"
    fi

    # Get all skill directories
    for skill_path in "$SKILLS_SOURCE"/*/; do
        if [ -d "$skill_path" ]; then
            skill_name=$(basename "$skill_path")
            target_link="$GLOBAL_SKILLS_DIR/$skill_name"
            source_path="$SKILLS_SOURCE/$skill_name"

            if [ -L "$target_link" ]; then
                # Symlink exists, check if it points to our source
                current_target=$(readlink "$target_link")
                if [ "$current_target" = "$source_path" ]; then
                    print_warning "$skill_name: already linked"
                else
                    print_warning "$skill_name: symlink exists pointing to $current_target"
                    read -p "    Replace with new link? [y/N] " -n 1 -r
                    echo
                    if [[ $REPLY =~ ^[Yy]$ ]]; then
                        rm "$target_link"
                        ln -s "$source_path" "$target_link"
                        print_success "$skill_name: replaced"
                    else
                        print_warning "$skill_name: skipped"
                    fi
                fi
            elif [ -e "$target_link" ]; then
                # Regular file/directory exists
                print_error "$skill_name: file/directory already exists at $target_link"
                print_warning "    Remove it manually if you want to install this skill"
            else
                # Create new symlink
                ln -s "$source_path" "$target_link"
                print_success "$skill_name: linked"
            fi
        fi
    done

    echo ""
    echo "Installation complete!"
}

uninstall_skills() {
    echo "Uninstalling methodology-skills from $GLOBAL_SKILLS_DIR"
    echo ""

    for skill_path in "$SKILLS_SOURCE"/*/; do
        if [ -d "$skill_path" ]; then
            skill_name=$(basename "$skill_path")
            target_link="$GLOBAL_SKILLS_DIR/$skill_name"
            source_path="$SKILLS_SOURCE/$skill_name"

            if [ -L "$target_link" ]; then
                current_target=$(readlink "$target_link")
                if [ "$current_target" = "$source_path" ]; then
                    rm "$target_link"
                    print_success "$skill_name: unlinked"
                else
                    print_warning "$skill_name: symlink points elsewhere, skipped"
                fi
            elif [ -e "$target_link" ]; then
                print_warning "$skill_name: not a symlink, skipped"
            else
                print_warning "$skill_name: not installed"
            fi
        fi
    done

    echo ""
    echo "Uninstallation complete!"
}

list_skills() {
    echo "Available skills in this repository:"
    echo ""
    for skill_path in "$SKILLS_SOURCE"/*/; do
        if [ -d "$skill_path" ]; then
            skill_name=$(basename "$skill_path")
            target_link="$GLOBAL_SKILLS_DIR/$skill_name"

            if [ -L "$target_link" ]; then
                current_target=$(readlink "$target_link")
                if [ "$current_target" = "$SKILLS_SOURCE/$skill_name" ]; then
                    echo -e "  ${GREEN}●${NC} $skill_name (installed)"
                else
                    echo -e "  ${YELLOW}●${NC} $skill_name (linked elsewhere)"
                fi
            else
                echo -e "  ${RED}○${NC} $skill_name (not installed)"
            fi
        fi
    done
    echo ""
}

show_help() {
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install     Install (symlink) all skills to ~/.claude/skills/"
    echo "  uninstall   Remove symlinks for skills from this repository"
    echo "  list        List available skills and their installation status"
    echo "  help        Show this help message"
    echo ""
    echo "If no command is provided, 'install' is used by default."
}

# Main
case "${1:-install}" in
    install)
        install_skills
        ;;
    uninstall)
        uninstall_skills
        ;;
    list)
        list_skills
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac

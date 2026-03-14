#!/bin/bash

# AI Development Global Rules Installation Script
# This script installs the global rules and registers user identity

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
VERSION_FILE="$PROJECT_ROOT/VERSION"
USERS_DIR="$PROJECT_ROOT/.users"
TEAMS_DIR="$PROJECT_ROOT/.teams"

# Windsurf Global Rules paths (dynamic based on current user)
WINDSURF_MEMORIES_DIR="$HOME/.codeium/windsurf/memories"
WINDSURF_RULES_REF_DIR="$WINDSURF_MEMORIES_DIR/rules-reference"
WINDSURF_GLOBAL_RULES_FILE="$WINDSURF_MEMORIES_DIR/global_rules.md"

# Helper functions
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Create directories
create_directories() {
    print_header "Creating Directory Structure"
    
    mkdir -p "$USERS_DIR"
    mkdir -p "$TEAMS_DIR"
    mkdir -p "$PROJECT_ROOT/.windsurf/workflows"
    
    # Create Windsurf global rules directories
    mkdir -p "$WINDSURF_MEMORIES_DIR"
    mkdir -p "$WINDSURF_RULES_REF_DIR"
    
    print_success "Directory structure created"
}

# Install Windsurf Global Rules
install_windsurf_global_rules() {
    print_header "Installing Windsurf Global Rules"
    
    # Copy all rule files to rules-reference folder
    local rules_source_dir="$PROJECT_ROOT/rules"
    if [ -d "$rules_source_dir" ]; then
        cp "$rules_source_dir"/*.md "$WINDSURF_RULES_REF_DIR/" 2>/dev/null
        local rule_count=$(ls -1 "$WINDSURF_RULES_REF_DIR"/*.md 2>/dev/null | wc -l)
        print_success "Copied $rule_count rule files to rules-reference"
    else
        print_warning "Rules source directory not found: $rules_source_dir"
    fi
    
    # Create global_rules.md index file
    cat > "$WINDSURF_GLOBAL_RULES_FILE" << 'EOF'
# Global Development Rules

Follow these rules for ALL projects. For detailed guidance, read the individual rule files.

**Repository:** https://github.com/wowpeterhkg/Global-Rules-Windsurf-Dev

## Rule Index (00-21)

Read detailed rules from: `~/.codeium/windsurf/memories/rules-reference/`

| Rule | File | Summary |
|------|------|---------|
| 00 | `00-quality-over-speed.md` | Correct architecture over shortcuts |
| 01 | `01-single-source-truth.md` | One authoritative planning location |
| 02 | `02-team-workflow.md` | Team tracking + Solo Mode |
| 03 | `03-work-boundaries.md` | Before/During/After work checklists |
| 04 | `04-regression-protection.md` | Baseline before changes |
| 05 | `05-breaking-changes.md` | Clean breaks over compatibility hacks |
| 06 | `06-code-cleanliness.md` | No dead code, tracked TODOs |
| 07 | `07-ask-questions-early.md` | Never guess on major decisions |
| 08 | `08-quick-reference.md` | At-a-glance summary |
| 09 | `09-communication.md` | Clear, direct, actionable |
| 10 | `10-code-generation.md` | Runnable code with all deps |
| 11 | `11-security.md` | OWASP Top 10, AES-256, TLS 1.2+ |
| 12 | `12-error-handling.md` | Fail-secure, structured logging |
| 13 | `13-tool-usage.md` | Strategic tool selection |
| 14 | `14-architecture.md` | Truthseeker mindset, ADRs |
| 15 | `15-dependencies.md` | Well-maintained packages only |
| 16 | `16-code-review.md` | Security-focused reviews |
| 17 | `17-testing.md` | Minimal mocking, explicit sync |
| 18 | `18-development-workflow.md` | Versioning, changelog, CI/CD |
| 19 | `19-async-events.md` | Never time-based synchronization |
| 20 | `20-infrastructure.md` | Docker, databases, port selection |
| 21 | `21-documentation.md` | docs/ folder structure |

## Quick Reminders

**Before Starting:** Read SSOT, check handoff notes, understand objective

**Security:** Parameterized queries, validate inputs, no hardcoded secrets

**Infrastructure:** Docker, PostgreSQL/Redis/LevelDB, confirm ports

**Before Finishing:** Verify no regressions, update docs, create handoff notes
EOF
    
    print_success "Global rules index created at: $WINDSURF_GLOBAL_RULES_FILE"
    
    echo ""
    echo -e "${BLUE}Windsurf Global Rules installed to:${NC}"
    echo "  • Global rules: $WINDSURF_GLOBAL_RULES_FILE"
    echo "  • Rule files:   $WINDSURF_RULES_REF_DIR"
}

# Get current version
get_version() {
    if [ -f "$VERSION_FILE" ]; then
        cat "$VERSION_FILE"
    else
        echo "1.0.0"
    fi
}

# User registration
register_user() {
    print_header "User Identity Registration"
    
    echo "Please provide your identity information for team traceability:"
    echo
    
    # Get user information
    while true; do
        read -p "Full Name: " FULL_NAME
        if [ -n "$FULL_NAME" ] && [ ${#FULL_NAME} -ge 2 ]; then
            break
        else
            print_error "Please enter a valid full name (at least 2 characters)"
        fi
    done
    
    while true; do
        read -p "Email Address: " EMAIL
        if [[ "$EMAIL" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
            break
        else
            print_error "Please enter a valid email address"
        fi
    done
    
    read -p "Team/Department (optional): " TEAM_DEPT
    
    # Generate user ID prefix
    USER_ID_PREFIX=$(echo "$FULL_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]//g' | head -c 8)
    
    # Check if user ID already exists
    while [ -f "$USERS_DIR/USER_$USER_ID_PREFIX.md" ]; do
        print_warning "User ID '$USER_ID_PREFIX' already exists"
        read -p "Enter a unique user ID prefix (e.g., jsmith): " USER_ID_PREFIX
        if [ -z "$USER_ID_PREFIX" ]; then
            USER_ID_PREFIX=$(echo "$FULL_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]//g' | head -c 8)
        fi
    done
    
    # Create user file
    USER_FILE="$USERS_DIR/USER_$USER_ID_PREFIX.md"
    cat > "$USER_FILE" << EOF
# USER_$USER_ID_PREFIX

## User Identity
- **Full Name**: $FULL_NAME
- **Email**: $EMAIL
- **Team/Department**: ${TEAM_DEPT:-"Not specified"}
- **User ID Prefix**: $USER_ID_PREFIX
- **Registration Date**: $(date '+%Y-%m-%d %H:%M:%S')
- **Installation Version**: $(get_version)

## Team History
EOF
    
    print_success "User identity registered: $FULL_NAME ($USER_ID_PREFIX)"
    
    # Export for use in other functions
    export FULL_NAME EMAIL TEAM_DEPT USER_ID_PREFIX USER_FILE
}

# Update user registry
update_user_registry() {
    local registry_file="$USERS_DIR/user-registry.json"
    
    if [ ! -f "$registry_file" ]; then
        echo '{"users": []}' > "$registry_file"
    fi
    
    # Add user to registry (simple JSON manipulation)
    local temp_file=$(mktemp)
    python3 - << EOF
import json
import sys

registry_file = "$registry_file"
user_data = {
    "user_id_prefix": "$USER_ID_PREFIX",
    "full_name": "$FULL_NAME",
    "email": "$EMAIL",
    "team_dept": "$TEAM_DEPT",
    "registration_date": "$(date '+%Y-%m-%d %H:%M:%S')",
    "version": "$(get_version)"
}

with open(registry_file, 'r') as f:
    registry = json.load(f)

registry['users'].append(user_data)

with open(registry_file, 'w') as f:
    json.dump(registry, f, indent=2)
EOF
    
    print_success "User registry updated"
}

# Copy project files
copy_project_files() {
    print_header "Installing Project Files"
    
    # Copy .windsurfrules if it doesn't exist
    if [ ! -f "$PROJECT_ROOT/.windsurfrules" ]; then
        cp "$PROJECT_ROOT/templates/.windsurfrules" "$PROJECT_ROOT/.windsurfrules" 2>/dev/null || {
            # Create basic .windsurfrules if template doesn't exist
            cat > "$PROJECT_ROOT/.windsurfrules" << 'EOF'
# Project Rules

## First-Time Setup
This project uses the AI Development Global Rules framework.

## User Identity
Current user: USER_<user-id-prefix>
Run `/team-status` to see current team information.

## Core Rules
- Rule 0: Quality Over Speed
- Rule 1: Single Source of Truth
- Rule 2: Team Registration & Identity
- Rule 3: Before Starting Work
- Rule 4: Behavioral Regression Protection
- Rule 15: Security Standards

## Workflows
| Command | Description |
|---------|-------------|
| `/team-init` | Initialize new team |
| `/handoff` | Complete team handoff |
| `/baseline` | Setup regression tests |
| `/team-status` | Show current team info |
EOF
        }
        print_success ".windsurfrules installed"
    else
        print_warning ".windsurfrules already exists, skipping"
    fi
    
    # Install workflow files
    install_workflows
    
    print_success "Project files installed"
}

# Install workflow files
install_workflows() {
    local workflows_dir="$PROJECT_ROOT/.windsurf/workflows"
    
    # Team initialization workflow
    cat > "$workflows_dir/team-init.md" << 'EOF'
---
description: Initialize new team for current conversation
---

1. Check existing teams in `.teams/` directory
2. Find highest team number and assign new one
3. Create team file with user identity
4. Update user's team history
5. Return team ID and file location

Follow Rule 2 guidelines for team registration.
EOF
    
    # Team status workflow
    cat > "$workflows_dir/team-status.md" << 'EOF'
---
description: Show current team and user information
---

Display:
1. Current user identity from `.users/USER_<user-id-prefix>.md`
2. Current team information if active
3. Team history for current user
4. Available team numbers for next team

Use information from user registration and team files.
EOF
    
    # Handoff workflow
    cat > "$workflows_dir/handoff.md" << 'EOF'
---
description: Complete team handoff with proper documentation
---

Follow Rule 10 - Before Finishing checklist:
1. Update team file with final progress
2. Ensure project builds cleanly
3. Ensure all tests pass
4. Document remaining problems and next steps
5. Write comprehensive handoff notes

Complete all handoff checklist items before marking team as complete.
EOF
    
    print_success "Workflows installed"
}

# Create first team
create_first_team() {
    print_header "Creating Your First Team"
    
    read -p "Enter a brief description for your first team: " TEAM_SUMMARY
    if [ -z "$TEAM_SUMMARY" ]; then
        TEAM_SUMMARY="initial-setup"
    fi
    
    # Find next team number
    local next_team=1
    if [ -d "$TEAMS_DIR" ]; then
        next_team=$(find "$TEAMS_DIR" -name "TEAM_*.md" | sed 's/.*TEAM_\([0-9]*\).*/\1/' | sort -n | tail -1)
        if [ -n "$next_team" ]; then
            next_team=$((next_team + 1))
        else
            next_team=1
        fi
    fi
    
    local team_id=$(printf "TEAM_%03d" $next_team)
    local team_file="$TEAMS_DIR/${team_id}_${USER_ID_PREFIX}_${TEAM_SUMMARY}.md"
    
    # Create team file
    cat > "$team_file" << EOF
# ${team_id}_${USER_ID_PREFIX}_${TEAM_SUMMARY}

## Team Information
- **Team ID**: ${team_id}
- **User ID**: ${USER_ID_PREFIX}
- **User Full Name**: ${FULL_NAME}
- **User Email**: ${EMAIL}
- **Started**: $(date '+%Y-%m-%d %H:%M:%S')
- **Context**: ${TEAM_SUMMARY}
- **Members**: AI assistant, ${FULL_NAME} (${USER_ID_PREFIX})

## Progress Log
### $(date '+%Y-%m-%d %H:%M:%S') - Session Start
- **Objective**: Initial setup of AI Development Global Rules
- **Initial Assessment**: New installation, user registration complete
- **User Context**: ${FULL_NAME} from ${TEAM_DEPT:-"Not specified"}

### $(date '+%Y-%m-%d %H:%M:%S') - Installation Complete
- **Completed**: User registration, directory setup, project files installed
- **Next Steps**: Begin development following global rules framework
- **Blockers**: None identified

## Decisions Made
- **$(date '+%Y-%m-%d %H:%M:%S')**: User identity registered as ${USER_ID_PREFIX}
- **$(date '+%Y-%m-%d %H:%M:%S')**: First team ${team_id} created for ${TEAM_SUMMARY}

## Questions Raised
- None at this time

## Handoff Notes
- **Current State**: Installation complete, ready for development
- **Next Actions**: Follow Rule 3 pre-work checklist before starting
- **Important Context**: User is ${FULL_NAME}, contact at ${EMAIL}
EOF
    
    # Update user's team history
    echo "- **${team_id}** - $(date '+%Y-%m-%d %H:%M:%S') - ${TEAM_SUMMARY}" >> "$USER_FILE"
    
    print_success "First team created: ${team_id}"
    print_success "Team file: ${team_file}"
}

# Final setup
final_setup() {
    print_header "Installation Complete"
    
    echo
    print_success "🎉 AI Development Global Rules installed successfully!"
    echo
    echo "Installation Summary:"
    echo "  • User Identity: ${FULL_NAME} (${USER_ID_PREFIX})"
    echo "  • Email: ${EMAIL}"
    echo "  • Team: ${TEAM_DEPT:-"Not specified"}"
    echo "  • Version: $(get_version)"
    echo "  • First Team: Created"
    echo
    echo "Next Steps:"
    echo "  1. Review Rule 0 - Quality Over Speed"
    echo "  2. Complete Rule 3 pre-work checklist"
    echo "  3. Start development with team workflow"
    echo
    echo "Available Commands:"
    echo "  • /team-status - Show current team information"
    echo "  • /team-init - Create new team"
    echo "  • /handoff - Complete team handoff"
    echo
    print_success "Ready to build excellent software! 🚀"
}

# Main installation flow
main() {
    print_header "AI Development Global Rules Installation"
    echo "Version: $(get_version)"
    echo
    
    # Check if already installed
    if [ -f "$USERS_DIR/user-registry.json" ]; then
        print_warning "Global rules already installed"
        read -p "Do you want to re-register a new user? (y/N): " re_register
        if [[ ! "$re_register" =~ ^[Yy]$ ]]; then
            echo "Installation cancelled. Use /team-status to see current setup."
            exit 0
        fi
    fi
    
    # Installation steps
    create_directories
    install_windsurf_global_rules
    register_user
    update_user_registry
    copy_project_files
    create_first_team
    final_setup
}

# Run installation
main "$@"

#!/bin/bash

set -e

trap 'printf "%b\n" "${RED}❌ Setup failed at line ${LINENO}.${NC}"; exit 1' ERR

DRY_RUN=false

for arg in "$@"; do
    case "$arg" in
        --dry-run)
            DRY_RUN=true
            ;;
    esac
done

BLUE=$'\033[0;34m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
RED=$'\033[0;31m'
CYAN=$'\033[0;36m'
NC=$'\033[0m'

step_number=0
SLOW_STEP_THRESHOLD_SECONDS=30

supports_color() {
    [ -t 1 ] && [ -n "$TERM" ] && [ "$TERM" != "dumb" ]
}

colorize() {
    if supports_color; then
        printf '%b%s%b' "$1" "$2" "$NC"
    else
        printf '%s' "$2"
    fi
}

print_line() {
    printf '%b\n' "$1"
}

banner_line() {
    print_line "$(colorize "$1" "$2")"
}

step() {
    step_number=$((step_number + 1))
    print_line "${YELLOW}[${step_number}] $1${NC}"
}

step_finish() {
    local label="$1"
    local start_time="$2"
    local end_time
    local elapsed

    end_time=$(date +%s)
    elapsed=$((end_time - start_time))

    if [ "$elapsed" -ge "$SLOW_STEP_THRESHOLD_SECONDS" ]; then
        info "${label} finished in ${elapsed}s (slow)"
    else
        success "${label} finished in ${elapsed}s"
    fi
}

run_step() {
    local label="$1"
    shift
    local start_time

    step "$label"
    start_time=$(date +%s)
    if "$@"; then
        step_finish "$label" "$start_time"
    else
        error_exit "${label} failed"
    fi
}

success() {
    print_line "  ${GREEN}✓${NC} $1"
}

info() {
    print_line "  ${CYAN}•${NC} $1"
}

error_exit() {
    print_line "${RED}❌ $1${NC}"
    exit 1
}

slugify() {
    printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-'
}

to_project_slug() {
    printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-'
}

read_value() {
    local prompt="$1"
    local fallback="$2"
    local value

    printf '%b' "$prompt" >&2
    read -r value
    if [ -z "$value" ]; then
        value="$fallback"
    fi

    printf '%s' "$value"
}

update_package_json() {
    local file_path="$1"
    local app_name="$2"
    local description="$3"

    [ -f "$file_path" ] || error_exit "File not found: $file_path"

    if [ "$DRY_RUN" = true ]; then
        info "[dry-run] Would update ${file_path}"
        return 0
    fi

    # Use sed to replace the name and description fields
    sed -i.bak -E 's/("name"[[:space:]]*:[[:space:]]*")[^"]+/\1'"$app_name"'/' "$file_path"
    sed -i.bak -E 's/("description"[[:space:]]*:[[:space:]]*")[^"]*/\1'"$description"'/' "$file_path"
    rm -f "${file_path}.bak"
}

update_env_example() {
    local file_path="$1"
    local key="$2"
    local value="$3"

    [ -f "$file_path" ] || error_exit "File not found: $file_path"

    if [ "$DRY_RUN" = true ]; then
        info "[dry-run] Would update ${file_path} (${key})"
        return 0
    fi

    if ! grep -q "^${key}=" "$file_path"; then
        error_exit "Key not found in ${file_path}: ${key}"
    fi

    sed -i.bak -e "s/^${key}=.*/${key}=${value}/" "$file_path"
    rm -f "${file_path}.bak"
}

copy_env_file() {
    local source="$1"
    local target="$2"

    if [ "$DRY_RUN" = true ]; then
        info "[dry-run] Would copy ${source} to ${target}"
        return 0
    fi

    cp "$source" "$target"
}

update_index_html() {
    local file_path="$1"
    local app_name="$2"

    [ -f "$file_path" ] || error_exit "File not found: $file_path"

    if [ "$DRY_RUN" = true ]; then
        info "[dry-run] Would update ${file_path}"
        return 0
    fi

    sed -i.bak -E 's|<title>.*</title>|<title>'"$app_name"'</title>|' "$file_path"
    rm -f "${file_path}.bak"
}

generate_models_index() {
    local target_dir="$1"
    local target_file="${target_dir}/index.js"

    if [ "$DRY_RUN" = true ]; then
        info "[dry-run] Would generate ${target_file}"
        return 0
    fi

    mkdir -p "$target_dir"
    cat << 'EOF' > "$target_file"
import sequelize from '#config/db.config';
import { DataTypes } from 'sequelize';

import RoleModel from './role.js';
import UserModel from './user.js';
import CustomerModel from './customer.js';
import WorkflowStepModel from './workflowStep.js';
import DepositRequestModel from './depositRequest.js';
import WorkflowLogModel from './workflowLog.js';
import AttachmentModel from './attachment.js';
import CustomerSignatureModel from './customerSignature.js';
import AgreementModel from './agreement.js';

const db = {};

db.Role = RoleModel(sequelize, DataTypes);
db.User = UserModel(sequelize, DataTypes);
db.Customer = CustomerModel(sequelize, DataTypes);
db.WorkflowStep = WorkflowStepModel(sequelize, DataTypes);
db.DepositRequest = DepositRequestModel(sequelize, DataTypes);
db.WorkflowLog = WorkflowLogModel(sequelize, DataTypes);
db.Attachment = AttachmentModel(sequelize, DataTypes);
db.CustomerSignature = CustomerSignatureModel(sequelize, DataTypes);
db.Agreement = AgreementModel(sequelize, DataTypes);

Object.keys(db).forEach((modelName) => {
  if (db[modelName].associate) {
    db[modelName].associate(db);
  }
});

db.sequelize = sequelize;

export default db;
EOF
}

confirm_setup() {
    printf '%b' "${YELLOW}Do you want to start setup now? [y/N]: ${NC}"
    read -r CONFIRM

    if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
        print_line "${RED}❌ Setup cancelled${NC}"
        exit 1
    fi
}

confirm_git_init() {
    printf '%b' "${YELLOW}Auto initialize git repository at the end? [y/N]: ${NC}"
    read -r CONFIRM_GIT

    [[ "$CONFIRM_GIT" =~ ^[Yy]$ ]]
}

install_dependencies() {
    local folder="$1"
    local label="$2"

    if [ -d "$folder" ] && [ -f "$folder/package.json" ]; then
        if [ "$DRY_RUN" = true ]; then
            info "[dry-run] Would install ${label} dependencies in ${folder}"
            return 0
        fi

        info "Installing ${label} dependencies with npm..."
        if [ -f "$folder/package-lock.json" ]; then
            (cd "$folder" && npm ci --no-audit --no-fund --progress=false)
        else
            (cd "$folder" && npm install --no-audit --no-fund --progress=false)
        fi
    else
        info "Skipping ${label} dependencies, package.json not found"
    fi
}

prepare_git_repo() {
    if [ "$DRY_RUN" = true ]; then
        info "[dry-run] Would remove .git, run git init, git add ., and git commit"
        return 0
    fi

    if [ -d .git ]; then
        info "Removing existing .git directory"
        rm -rf .git
    fi

    info "Initializing fresh git repository"
    git init
    info "Adding project files"
    git add .
    info "Creating initial commit"
    git commit -m "init: setup and initialize new project"
    success "Git repository reinitialized and committed"
}

cleanup_template_files() {
    if [ "$DRY_RUN" = true ]; then
        info "[dry-run] Would remove all .gitKeep files and template docs"
        return 0
    fi

    local gitkeep_count
    gitkeep_count=$(find . -type f \( -iname ".gitkeep" -o -iname ".gitKeep" \) | wc -l | tr -d ' ')
    info "Removing ${gitkeep_count} .gitKeep files"
    find . -type f \( -iname ".gitkeep" -o -iname ".gitKeep" \) -delete

    for file in TEMPLATE_SUMMARY.md SETUP.md CUSTOMIZATION.md QUICK_START.md START_HERE.md; do
        if [ -f "$file" ]; then
            info "Removing ${file}"
            rm "$file"
            success "$file removed"
        fi
    done
}

banner_line "$BLUE" "╔═══════════════════════════════════════════════════╗"
banner_line "$BLUE" "║  🚀 Dagsap App - Project Setup Wizard  🚀         ║"
banner_line "$BLUE" "║  Bootstrap your new awesome project!             ║"
banner_line "$BLUE" "╚═══════════════════════════════════════════════════╝"

print_line "$(colorize "$CYAN" "📝 Let's set up your project!")"
print_line ""

confirm_setup

APP_NAME=$(read_value "${YELLOW}Enter your project name (e.g., MyAwesomeApp):${NC} " "MyApp")
APP_DESC=$(read_value "${YELLOW}Enter project description:${NC} " "A modern web application")
APP_SLUG=$(to_project_slug "$APP_NAME")

print_line ""
print_line "$(colorize "$CYAN" "✨ Project Settings:")"
print_line "  Name: ${GREEN}${APP_NAME}${NC}"
print_line "  Description: ${GREEN}${APP_DESC}${NC}"
print_line ""

if [ "$DRY_RUN" = true ]; then
    info "Running in dry-run mode"
fi

run_step "Updating server package.json" update_package_json "server/package.json" "${APP_SLUG}-backend" "${APP_DESC} - Backend API"
run_step "Updating client package.json" update_package_json "client/package.json" "${APP_SLUG}-frontend" "${APP_DESC} - Frontend UI"

run_step "Updating server .env.example" update_env_example "server/.env.example" "APP_NAME" "$APP_NAME"
run_step "Updating client .env.example" update_env_example "client/.env.example" "VITE_APP_NAME" "$APP_NAME"

run_step "Installing backend dependencies" install_dependencies "server" "backend"
run_step "Installing frontend dependencies" install_dependencies "client" "frontend"

run_step "Copying server env file" copy_env_file "server/.env.example" "server/.env"
run_step "Copying client env file" copy_env_file "client/.env.example" "client/.env"

run_step "Updating client index.html" update_index_html "client/index.html" "$APP_NAME"
run_step "Generating models index.js" generate_models_index "server/database/models"

run_step "Cleaning up template files" cleanup_template_files

if confirm_git_init; then
    run_step "Reinitializing git repository" prepare_git_repo
else
    info "Skipping git reinitialization"
fi

print_line ""
print_line "$(colorize "$BLUE" "═══════════════════════════════════════════════════")"
print_line "$(colorize "$GREEN" "✨ Setup Complete! Your project is ready! ✨")"
print_line "$(colorize "$BLUE" "═══════════════════════════════════════════════════")"
print_line ""
print_line "$(colorize "$CYAN" "📚 Next Steps:")"
print_line "  ${YELLOW}1.${NC} Configure your database in ${GREEN}server/.env${NC}"
print_line "  ${YELLOW}2.${NC} Run backend: ${GREEN}cd server && npm run dev${NC}"
print_line "  ${YELLOW}3.${NC} Run frontend: ${GREEN}cd client && npm run dev${NC}"
print_line "  ${YELLOW}4.${NC} Use the root README as the main entry point${NC}"
print_line ""
print_line "$(colorize "$CYAN" "🚀 Happy Coding!")"
print_line ""

printf '%b' "${YELLOW}Buka di VSCode? [y/N]: ${NC}"
read -r CONFIRM_VSCODE

if [[ "$CONFIRM_VSCODE" =~ ^[Yy]$ ]]; then
    info "Membuka VSCode..."
    code .
fi

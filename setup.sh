#!/bin/bash

set -e

trap 'printf "%b\n" "${RED}❌ Setup failed at line ${LINENO}.${NC}"; exit 1' ERR

BLUE=$'\033[0;34m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
RED=$'\033[0;31m'
CYAN=$'\033[0;36m'
NC=$'\033[0m'

step_number=0

print_line() {
    printf '%b\n' "$1"
}

step() {
    step_number=$((step_number + 1))
    print_line "${YELLOW}[${step_number}] $1${NC}"
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

    printf '%b' "$prompt"
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

    node - "$file_path" "$app_name" "$description" <<'NODE'
const fs = require('fs');

const filePath = process.argv[2];
const appName = process.argv[3];
const description = process.argv[4];
const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
data.name = appName;
data.description = description;
fs.writeFileSync(filePath, JSON.stringify(data, null, 2) + '\n');
NODE
}

update_env_example() {
    local file_path="$1"
    local key="$2"
    local value="$3"

    [ -f "$file_path" ] || error_exit "File not found: $file_path"

    node - "$file_path" "$key" "$value" <<'NODE'
const fs = require('fs');

const filePath = process.argv[2];
const key = process.argv[3];
const value = process.argv[4];
const content = fs.readFileSync(filePath, 'utf8');
const pattern = new RegExp(`^${key}=.*$`, 'm');

if (!pattern.test(content)) {
    throw new Error(`Key not found in ${filePath}: ${key}`);
}

fs.writeFileSync(filePath, content.replace(pattern, `${key}=${value}`));
NODE
}

copy_env_file() {
    local source="$1"
    local target="$2"

    cp "$source" "$target"
}

confirm_setup() {
    printf '%b' "${YELLOW}Are you want to setup now? [y/N]:${NC} "
    read -r CONFIRM

    if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
        print_line "${RED}❌ Setup cancelled${NC}"
        exit 1
    fi
}

install_dependencies() {
    local folder="$1"
    local label="$2"

    if [ -d "$folder" ] && [ -f "$folder/package.json" ]; then
        info "Installing ${label} dependencies..."
        (cd "$folder" && npm install)
        success "${label} dependencies installed"
    else
        info "Skipping ${label} dependencies, package.json not found"
    fi
}

prepare_git_repo() {
    step "Reinitializing git repository"

    if [ -d .git ]; then
        rm -rf .git
    fi

    git init
    git add .
    git commit -m "init: setup and initialize new project"
    success "Git repository reinitialized and committed"
}

cleanup_template_files() {
    step "Cleaning up template files"

    find . -type f \( -iname ".gitkeep" -o -iname ".gitKeep" \) -delete

    for file in TEMPLATE_SUMMARY.md SETUP.md CUSTOMIZATION.md QUICK_START.md START_HERE.md; do
        if [ -f "$file" ]; then
            rm "$file"
            success "$file removed"
        fi
    done
}

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════╗"
echo "║  🚀 Dagsap App - Project Setup Wizard  🚀         ║"
echo "║  Bootstrap your new awesome project!             ║"
echo "╚═══════════════════════════════════════════════════╝"
echo -e "${NC}"

print_line "${CYAN}📝 Let's set up your project!${NC}"
print_line ""

confirm_setup

APP_NAME=$(read_value "${YELLOW}Enter your project name (e.g., MyAwesomeApp):${NC} " "MyApp")
APP_DESC=$(read_value "${YELLOW}Enter project description:${NC} " "A modern web application")
APP_SLUG=$(to_project_slug "$APP_NAME")

print_line ""
print_line "${CYAN}✨ Project Settings:${NC}"
print_line "  Name: ${GREEN}${APP_NAME}${NC}"
print_line "  Description: ${GREEN}${APP_DESC}${NC}"
print_line ""

step "Updating package.json files"
update_package_json "server/package.json" "${APP_SLUG}-backend" "${APP_DESC} - Backend API"
success "server/package.json updated"
update_package_json "client/package.json" "${APP_SLUG}-frontend" "${APP_DESC} - Frontend UI"
success "client/package.json updated"

step "Updating environment examples"
update_env_example "server/.env.example" "APP_NAME" "$APP_NAME"
success "server/.env.example updated"
update_env_example "client/.env.example" "VITE_APP_NAME" "$APP_NAME"
success "client/.env.example updated"

step "Installing dependencies"
install_dependencies "server" "backend"
install_dependencies "client" "frontend"

step "Copying env.example to env"
copy_env_file "server/.env.example" "server/.env"
success "server/.env created"
copy_env_file "client/.env.example" "client/.env"
success "client/.env created"

cleanup_template_files

prepare_git_repo

print_line ""
print_line "${BLUE}═══════════════════════════════════════════════════${NC}"
print_line "${GREEN}✨ Setup Complete! Your project is ready! ✨${NC}"
print_line "${BLUE}═══════════════════════════════════════════════════${NC}"
print_line ""
print_line "${CYAN}📚 Next Steps:${NC}"
print_line "  ${YELLOW}1.${NC} Configure your database in ${GREEN}server/.env${NC}"
print_line "  ${YELLOW}2.${NC} Run backend: ${GREEN}cd server && npm run dev${NC}"
print_line "  ${YELLOW}3.${NC} Run frontend: ${GREEN}cd client && npm run dev${NC}"
print_line "  ${YELLOW}4.${NC} Use the root README as the main entry point${NC}"
print_line ""
print_line "${CYAN}🚀 Happy Coding!${NC}"

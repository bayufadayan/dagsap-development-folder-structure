#!/bin/bash

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

slugify() {
    printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-'
}

read_value() {
    local prompt="$1"
    local fallback="$2"
    local value

    read -r -p "$prompt" value
    if [ -z "$value" ]; then
        value="$fallback"
    fi

    printf '%s' "$value"
}

update_package_json() {
    local file_path="$1"
    local app_name="$2"
    local description="$3"

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

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════╗"
echo "║  🚀 Dagsap App - Project Setup Wizard  🚀         ║"
echo "║  Bootstrap your new awesome project!             ║"
echo "╚═══════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${CYAN}📝 Let's set up your project!${NC}"
echo

APP_NAME=$(read_value "${YELLOW}Enter your app name (e.g., MyAwesomeApp):${NC} " "MyApp")
APP_DESC=$(read_value "${YELLOW}Enter project description:${NC} " "A modern web application")
APP_SLUG=$(slugify "$APP_NAME")

echo
echo -e "${CYAN}✨ Project Settings:${NC}"
echo -e "  Name: ${GREEN}${APP_NAME}${NC}"
echo -e "  Description: ${GREEN}${APP_DESC}${NC}"
echo

read -r -p "${YELLOW}Continue? (y/n):${NC} " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo -e "${RED}❌ Setup cancelled${NC}"
    exit 1
fi

echo
echo -e "${CYAN}⚙️  Setting up your project...${NC}"
echo

echo -e "${YELLOW}→ Updating package.json files...${NC}"
if [ -f "server/package.json" ]; then
    update_package_json "server/package.json" "${APP_SLUG}-backend" "${APP_DESC} - Backend API"
    echo -e "  ${GREEN}✓${NC} server/package.json updated"
fi

if [ -f "client/package.json" ]; then
    update_package_json "client/package.json" "${APP_SLUG}-frontend" "${APP_DESC} - Frontend UI"
    echo -e "  ${GREEN}✓${NC} client/package.json updated"
fi

echo -e "${YELLOW}→ Creating environment files...${NC}"
if [ -f "server/.env.example" ] && [ ! -f "server/.env" ]; then
    cp server/.env.example server/.env
    echo -e "  ${GREEN}✓${NC} server/.env created from .env.example"
fi

if [ -f "client/.env.example" ] && [ ! -f "client/.env" ]; then
    cp client/.env.example client/.env
    echo -e "  ${GREEN}✓${NC} client/.env created from .env.example"
fi

echo
echo -e "${YELLOW}→ Installing dependencies...${NC}"
if [ -d "server" ] && [ -f "server/package.json" ]; then
    echo -e "  ${CYAN}Installing backend dependencies...${NC}"
    (cd server && npm install)
    echo -e "  ${GREEN}✓${NC} Backend dependencies installed"
fi

if [ -d "client" ] && [ -f "client/package.json" ]; then
    echo -e "  ${CYAN}Installing frontend dependencies...${NC}"
    (cd client && npm install)
    echo -e "  ${GREEN}✓${NC} Frontend dependencies installed"
fi

echo
echo -e "${YELLOW}→ Cleaning up template files...${NC}"
find . -name ".gitkeep" -delete
echo -e "  ${GREEN}✓${NC} .gitkeep files removed"

for file in TEMPLATE_SUMMARY.md SETUP.md CUSTOMIZATION.md QUICK_START.md START_HERE.md; do
    if [ -f "$file" ]; then
        rm "$file"
        echo -e "  ${GREEN}✓${NC} $file removed"
    fi
done

echo
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✨ Setup Complete! Your project is ready! ✨${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo
echo -e "${CYAN}📚 Next Steps:${NC}"
echo -e "  ${YELLOW}1.${NC} Configure your database in ${GREEN}server/.env${NC}"
echo -e "  ${YELLOW}2.${NC} Run backend: ${GREEN}cd server && npm run dev${NC}"
echo -e "  ${YELLOW}3.${NC} Run frontend: ${GREEN}cd client && npm run dev${NC}"
echo -e "  ${YELLOW}4.${NC} Use the root README as the main entry point${NC}"
echo
echo -e "${CYAN}🚀 Happy Coding!${NC}"

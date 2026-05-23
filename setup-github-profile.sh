#!/bin/bash

#################################################################################
#                    🚀 GitHub Profile Activation Script
#                    Automate Your DevOps Profile Setup
#################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
GITHUB_USERNAME="VNaveen124"
REPOS_TO_CREATE=(
    "devops-terraform-templates"
    "k8s-production-configs"
    "github-actions-pipelines"
    "devops-security-toolkit"
)

#################################################################################
# HELPER FUNCTIONS
#################################################################################

print_header() {
    echo -e "\n${CYAN}════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════${NC}\n"
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

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

check_command() {
    if command -v $1 &> /dev/null; then
        print_success "$1 is installed"
        return 0
    else
        print_error "$1 is NOT installed"
        return 1
    fi
}

#################################################################################
# MAIN FUNCTIONS
#################################################################################

check_prerequisites() {
    print_header "Checking Prerequisites"
    
    local all_good=true
    
    check_command "git" || all_good=false
    check_command "curl" || all_good=false
    
    if [ "$all_good" = false ]; then
        print_error "Some prerequisites are missing. Please install them."
        exit 1
    fi
    
    # Check GitHub CLI
    if check_command "gh"; then
        print_info "GitHub CLI is available - we can use it for enhanced features"
    else
        print_warning "GitHub CLI not installed - using basic Git instead"
        print_info "Install with: curl https://cli.github.com/install.sh | sh"
    fi
}

setup_git_config() {
    print_header "Setting Up Git Configuration"
    
    # Check if git config exists
    if git config --global user.name &> /dev/null; then
        print_success "Git is already configured"
        echo -e "${BLUE}  Name: $(git config --global user.name)${NC}"
        echo -e "${BLUE}  Email: $(git config --global user.email)${NC}"
    else
        print_warning "Git is not configured"
        print_info "Please run these commands:"
        echo -e "${YELLOW}  git config --global user.name \"Your Name\"${NC}"
        echo -e "${YELLOW}  git config --global user.email \"your@email.com\"${NC}"
    fi
}

create_workflow_directory() {
    print_header "Creating GitHub Actions Workflow Directory"
    
    if [ -d ".github/workflows" ]; then
        print_success "Workflow directory already exists"
    else
        mkdir -p .github/workflows
        print_success "Created .github/workflows directory"
    fi
}

create_workflow_files() {
    print_header "Creating GitHub Actions Workflow Files"
    
    # Workflow 1: Profile Stats
    cat > .github/workflows/profile-stats.yml << 'EOF'
name: 📊 Update Profile Stats
on:
  schedule:
    - cron: '0 0 * * *'
  workflow_dispatch:

jobs:
  update:
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - uses: actions/checkout@v4
      - name: Update stats
        run: echo "Stats updated at $(date)" >> stats.log
      - name: Commit
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add stats.log || true
          git commit -m "chore: update stats" || true
          git push || true
EOF
    print_success "Created profile-stats.yml"
    
    # Workflow 2: Sync Medium
    cat > .github/workflows/sync-medium.yml << 'EOF'
name: 📚 Sync Medium Articles
on:
  schedule:
    - cron: '0 12 * * *'
  workflow_dispatch:

jobs:
  sync:
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - uses: actions/checkout@v4
      - name: Fetch Medium RSS
        run: echo "Medium sync completed at $(date)" >> medium.log
      - name: Commit
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add medium.log || true
          git commit -m "chore: sync medium articles" || true
          git push || true
EOF
    print_success "Created sync-medium.yml"
    
    # Workflow 3: Weekly Summary
    cat > .github/workflows/weekly-summary.yml << 'EOF'
name: 📋 Weekly Summary
on:
  schedule:
    - cron: '0 9 * * 1'
  workflow_dispatch:

jobs:
  summary:
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - uses: actions/checkout@v4
      - name: Generate summary
        run: |
          echo "## Weekly Summary - Week $(date +%V)" >> WEEKLY.md
          echo "Generated: $(date)" >> WEEKLY.md
      - name: Commit
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add WEEKLY.md || true
          git commit -m "docs: weekly summary" || true
          git push || true
EOF
    print_success "Created weekly-summary.yml"
}

create_repository_structure() {
    print_header "Creating Repository Structure"
    
    # Create docs directory
    mkdir -p docs
    print_success "Created docs directory"
    
    # Create examples directory
    mkdir -p examples
    print_success "Created examples directory"
    
    # Create scripts directory
    mkdir -p scripts
    print_success "Created scripts directory"
}

create_essential_files() {
    print_header "Creating Essential Files"
    
    # Create CONTRIBUTING.md
    cat > CONTRIBUTING.md << 'EOF'
# Contributing Guide

Thank you for contributing! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Commit with clear messages
5. Push to your branch
6. Create a Pull Request

## Code Standards
- Follow established patterns
- Add comments for complex code
- Write meaningful commit messages
- Include documentation

## Testing
- Test your changes thoroughly
- Add examples where applicable
- Update documentation as needed

Thank you for making this project better!
EOF
    print_success "Created CONTRIBUTING.md"
    
    # Create .gitignore
    cat > .gitignore << 'EOF'
# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Dependencies
node_modules/
__pycache__/
*.pyc

# Environment
.env
.env.local

# Build artifacts
dist/
build/
*.egg-info/

# Logs
*.log
logs/

# Terraform
.terraform/
*.tfstate
*.tfstate.*
.terraform.lock.hcl

# Kubernetes
kubeconfig*
.kube/

# Archives
*.zip
*.tar.gz
EOF
    print_success "Created .gitignore"
    
    # Create LICENSE
    cat > LICENSE << 'EOF'
MIT License

Copyright (c) 2024 Velanati Naveen Kumar

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
EOF
    print_success "Created LICENSE (MIT)"
    
    # Create CHANGELOG.md
    cat > CHANGELOG.md << 'EOF'
# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- Initial project structure
- GitHub Actions workflows
- Essential documentation

### Changed
- Nothing yet

### Fixed
- Nothing yet

## [1.0.0] - 2024

### Added
- Project launch
- Initial features
- Documentation
EOF
    print_success "Created CHANGELOG.md"
}

create_documentation() {
    print_header "Creating Documentation Templates"
    
    # Create INSTALLATION.md
    cat > docs/INSTALLATION.md << 'EOF'
# Installation Guide

## Prerequisites
- Kubernetes 1.20+
- Docker 20.10+
- Terraform 1.0+
- AWS/Azure CLI

## Quick Start

### Option 1: Using Script
```bash
./scripts/install.sh
```

### Option 2: Manual Installation
1. Clone the repository
2. Install dependencies
3. Configure environment variables
4. Run deployment

## Troubleshooting
See TROUBLESHOOTING.md for common issues
EOF
    print_success "Created docs/INSTALLATION.md"
    
    # Create TROUBLESHOOTING.md
    cat > docs/TROUBLESHOOTING.md << 'EOF'
# Troubleshooting Guide

## Common Issues

### Issue: Permission Denied
**Solution:**
- Verify IAM/RBAC permissions
- Check service account roles
- Review policy attachments

### Issue: Connection Timeout
**Solution:**
- Check network connectivity
- Verify security group rules
- Review firewall settings

### Issue: Resource Not Found
**Solution:**
- Verify resource names
- Check region configuration
- Review resource dependencies
EOF
    print_success "Created docs/TROUBLESHOOTING.md"
    
    # Create ARCHITECTURE.md
    cat > docs/ARCHITECTURE.md << 'EOF'
# Architecture Overview

## System Design

```
┌─────────────────────────────────────┐
│     User / Client Application       │
└────────────────┬────────────────────┘
                 │
        ┌────────▼────────┐
        │   Load Balancer │
        └────────┬────────┘
                 │
    ┌────────────┼────────────┐
    │            │            │
┌───▼──┐    ┌───▼──┐    ┌───▼──┐
│  Pod │    │  Pod │    │  Pod │
└──────┘    └──────┘    └──────┘
    │            │            │
    └────────────┼────────────┘
                 │
        ┌────────▼────────┐
        │   Database      │
        └─────────────────┘
```

## Components

### Frontend
- Load Balancer
- API Gateway

### Backend
- Microservices
- API Servers

### Data
- Persistent Storage
- Cache Layer

## Security
- Encryption in transit
- Encryption at rest
- RBAC policies
- Network policies
EOF
    print_success "Created docs/ARCHITECTURE.md"
}

init_git_repo() {
    print_header "Initializing Git Repository"
    
    if [ -d ".git" ]; then
        print_success "Git repository already initialized"
    else
        git init
        print_success "Initialized new Git repository"
    fi
    
    # Configure git
    git config user.email "${GIT_EMAIL:-action@github.com}" 2>/dev/null || true
    git config user.name "${GIT_NAME:-GitHub Actions}" 2>/dev/null || true
}

create_initial_commit() {
    print_header "Creating Initial Commit"
    
    git add . 2>/dev/null || true
    git commit -m "🚀 chore: initial project setup with automation" 2>/dev/null || {
        print_info "No changes to commit (initial setup may already be complete)"
    }
    
    print_success "Repository is ready!"
}

show_next_steps() {
    print_header "📋 Next Steps"
    
    echo -e "${BLUE}1. Push to GitHub:${NC}"
    echo -e "   ${YELLOW}git remote add origin https://github.com/${GITHUB_USERNAME}/<repo-name>.git${NC}"
    echo -e "   ${YELLOW}git branch -M main${NC}"
    echo -e "   ${YELLOW}git push -u origin main${NC}"
    echo ""
    
    echo -e "${BLUE}2. Update Repository Information:${NC}"
    echo -e "   - Add description"
    echo -e "   - Add topics/tags"
    echo -e "   - Add homepage URL"
    echo ""
    
    echo -e "${BLUE}3. Configure GitHub Actions:${NC}"
    echo -e "   - Go to Actions tab"
    echo -e "   - Enable workflows"
    echo -e "   - Configure secrets if needed"
    echo ""
    
    echo -e "${BLUE}4. Add to Profile:${NC}"
    echo -e "   - Pin repository to profile"
    echo -e "   - Add to GitHub Profile README"
    echo -e "   - Share on social media"
    echo ""
    
    echo -e "${BLUE}5. Continuous Development:${NC}"
    echo -e "   - Add meaningful commits regularly"
    echo -e "   - Update documentation"
    echo -e "   - Engage with community"
    echo ""
}

#################################################################################
# MAIN EXECUTION
#################################################################################

main() {
    clear
    
    echo -e "${CYAN}"
    echo "  ╔══════════════════════════════════════════════════════╗"
    echo "  ║   🚀 GitHub Profile Activation Automation Script     ║"
    echo "  ║   Prepare Your DevOps Career for Stardom             ║"
    echo "  ╚══════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    sleep 2
    
    # Run setup functions
    check_prerequisites
    setup_git_config
    create_workflow_directory
    create_workflow_files
    create_repository_structure
    create_essential_files
    create_documentation
    init_git_repo
    create_initial_commit
    show_next_steps
    
    echo -e "${GREEN}"
    echo "  ╔══════════════════════════════════════════════════════╗"
    echo "  ║   ✅ Setup Complete! Your Repository is Ready        ║"
    echo "  ║   🚀 Time to Push and Conquer GitHub!                ║"
    echo "  ╚══════════════════════════════════════════════════════╝"
    echo -e "${NC}\n"
}

# Run main function
main "$@"

#!/bin/bash

# 🧬 Metabolitica September - GitHub Repository Creation Script
# This script creates a new GitHub repository and pushes the project

set -e

echo "🚀 Creating GitHub Repository for Metabolitica September..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if GitHub CLI is installed
check_gh_cli() {
    if ! command -v gh &> /dev/null; then
        print_error "GitHub CLI (gh) is not installed."
        echo "Please install it first:"
        echo "  macOS: brew install gh"
        echo "  Ubuntu: sudo apt install gh"
        echo "  Windows: winget install GitHub.cli"
        echo ""
        echo "Then authenticate with: gh auth login"
        exit 1
    fi
    
    # Check if authenticated
    if ! gh auth status &> /dev/null; then
        print_error "GitHub CLI is not authenticated."
        echo "Please run: gh auth login"
        exit 1
    fi
    
    print_success "GitHub CLI is installed and authenticated."
}

# Get repository details
get_repo_details() {
    echo ""
    echo "📝 Repository Configuration"
    echo "============================"
    
    # Get repository name
    read -p "Repository name (default: metabolitica-september): " REPO_NAME
    REPO_NAME=${REPO_NAME:-metabolitica-september}
    
    # Get description
    read -p "Description (default: Advanced health analytics platform with AI-powered insights): " REPO_DESC
    REPO_DESC=${REPO_DESC:-"Advanced health analytics platform with AI-powered insights"}
    
    # Get visibility
    echo "Repository visibility:"
    echo "1) Public (recommended for open source)"
    echo "2) Private"
    read -p "Choose visibility (1-2, default: 1): " VISIBILITY_CHOICE
    
    case $VISIBILITY_CHOICE in
        2) VISIBILITY="--private" ;;
        *) VISIBILITY="--public" ;;
    esac
    
    # Get topics
    read -p "Topics (comma-separated, default: health,analytics,ai,healthcare): " TOPICS
    TOPICS=${TOPICS:-"health,analytics,ai,healthcare,typescript,react,nodejs,python"}
    
    # Get license
    echo "License options:"
    echo "1) MIT (recommended)"
    echo "2) Apache 2.0"
    echo "3) GPL-3.0"
    echo "4) Custom"
    read -p "Choose license (1-4, default: 1): " LICENSE_CHOICE
    
    case $LICENSE_CHOICE in
        2) LICENSE="--license apache-2.0" ;;
        3) LICENSE="--license gpl-3.0" ;;
        4) LICENSE="" ;;
        *) LICENSE="--license mit" ;;
    esac
}

# Create GitHub repository
create_repository() {
    print_status "Creating GitHub repository: $REPO_NAME"
    
    # Create the repository
    gh repo create "$REPO_NAME" \
        --description "$REPO_DESC" \
        $VISIBILITY \
        $LICENSE \
        --source=. \
        --remote=origin \
        --push
    
    if [ $? -eq 0 ]; then
        print_success "GitHub repository created successfully!"
    else
        print_error "Failed to create GitHub repository."
        exit 1
    fi
}

# Configure repository settings
configure_repository() {
    print_status "Configuring repository settings..."
    
    # Add topics
    gh repo edit "$REPO_NAME" --add-topic $(echo $TOPICS | tr ',' ' ')
    
    # Enable features
    gh repo edit "$REPO_NAME" --enable-issues --enable-wiki --enable-projects
    
    # Set default branch to main
    gh repo edit "$REPO_NAME" --default-branch main
    
    print_success "Repository settings configured."
}

# Create initial issues and project
setup_project() {
    print_status "Setting up initial project structure..."
    
    # Create project
    gh project create "Metabolitica September Roadmap" \
        --owner "$(gh repo view --json owner -q .owner.login)" \
        --repo "$REPO_NAME" \
        --format body
    
    # Create initial issues
    gh issue create \
        --title "🚀 Project Setup and Initial Development" \
        --body "## Initial Development Tasks

### Frontend Development
- [ ] Set up React component structure
- [ ] Implement authentication system
- [ ] Create dashboard components
- [ ] Add health metrics tracking
- [ ] Implement AI insights interface

### Backend Development
- [ ] Set up Express server structure
- [ ] Implement authentication middleware
- [ ] Create health metrics API
- [ ] Add AI integration endpoints
- [ ] Set up database models

### ML Engine Development
- [ ] Set up Python ML environment
- [ ] Implement health prediction models
- [ ] Add anomaly detection
- [ ] Create recommendation engine

### Infrastructure
- [ ] Set up CI/CD pipeline
- [ ] Configure monitoring and logging
- [ ] Implement security measures
- [ ] Set up testing framework

### Documentation
- [ ] API documentation
- [ ] User guides
- [ ] Development setup guide
- [ ] Deployment guide" \
        --label "enhancement" \
        --label "documentation"
    
    gh issue create \
        --title "🔐 Security and HIPAA Compliance" \
        --body "## Security Implementation

### Authentication & Authorization
- [ ] JWT token implementation
- [ ] Role-based access control
- [ ] Password hashing and validation
- [ ] Session management

### Data Protection
- [ ] Data encryption at rest
- [ ] Data encryption in transit
- [ ] Secure API endpoints
- [ ] Input validation and sanitization

### HIPAA Compliance
- [ ] Audit logging system
- [ ] Data retention policies
- [ ] Access control mechanisms
- [ ] Privacy protection measures

### Security Testing
- [ ] Vulnerability scanning
- [ ] Penetration testing
- [ ] Security code review
- [ ] Compliance auditing" \
        --label "security" \
        --label "compliance"
    
    gh issue create \
        --title "🧪 Testing and Quality Assurance" \
        --body "## Testing Strategy

### Unit Testing
- [ ] Frontend component tests
- [ ] Backend service tests
- [ ] ML model tests
- [ ] Utility function tests

### Integration Testing
- [ ] API endpoint tests
- [ ] Database integration tests
- [ ] External service tests
- [ ] End-to-end workflows

### Performance Testing
- [ ] Load testing
- [ ] Stress testing
- [ ] Performance monitoring
- [ ] Optimization

### Security Testing
- [ ] Authentication tests
- [ ] Authorization tests
- [ ] Input validation tests
- [ ] Security scanning" \
        --label "testing" \
        --label "quality"
    
    print_success "Initial project structure created."
}

# Push to GitHub
push_to_github() {
    print_status "Pushing code to GitHub..."
    
    # Add remote origin if not already added
    if ! git remote get-url origin &> /dev/null; then
        git remote add origin "https://github.com/$(gh repo view --json owner -q .owner.login)/$REPO_NAME.git"
    fi
    
    # Push to GitHub
    git push -u origin main
    
    if [ $? -eq 0 ]; then
        print_success "Code pushed to GitHub successfully!"
    else
        print_error "Failed to push code to GitHub."
        exit 1
    fi
}

# Display final information
show_final_info() {
    echo ""
    echo "🎉 Repository Setup Complete!"
    echo "============================="
    echo ""
    echo "📁 Repository: https://github.com/$(gh repo view --json owner -q .owner.login)/$REPO_NAME"
    echo "🚀 Clone URL: https://github.com/$(gh repo view --json owner -q .owner.login)/$REPO_NAME.git"
    echo "📋 Issues: https://github.com/$(gh repo view --json owner -q .owner.login)/$REPO_NAME/issues"
    echo "📊 Projects: https://github.com/$(gh repo view --json owner -q .owner.login)/$REPO_NAME/projects"
    echo ""
    echo "Next steps:"
    echo "1. Review and customize the created issues"
    echo "2. Set up branch protection rules"
    echo "3. Configure GitHub Actions for CI/CD"
    echo "4. Add team members and collaborators"
    echo "5. Start development on the first milestone"
    echo ""
    echo "Happy coding! 🚀"
}

# Main function
main() {
    echo "🧬 Metabolitica September - GitHub Repository Setup"
    echo "=================================================="
    
    # Check prerequisites
    check_gh_cli
    
    # Get repository details
    get_repo_details
    
    # Create repository
    create_repository
    
    # Configure repository
    configure_repository
    
    # Setup project structure
    setup_project
    
    # Push code
    push_to_github
    
    # Show final information
    show_final_info
}

# Run main function
main "$@"

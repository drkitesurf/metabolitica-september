#!/bin/bash

# 🧬 Metabolitica September - Project Setup Script
# This script sets up the complete development environment

set -e

echo "🚀 Setting up Metabolitica September project..."

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

# Check if required tools are installed
check_requirements() {
    print_status "Checking system requirements..."
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed. Please install Node.js 18+ first."
        exit 1
    fi
    
    # Check npm
    if ! command -v npm &> /dev/null; then
        print_error "npm is not installed. Please install npm first."
        exit 1
    fi
    
    # Check Python
    if ! command -v python3 &> /dev/null; then
        print_warning "Python 3 is not installed. Some features may not work."
    fi
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        print_warning "Docker is not installed. Containerized development will not be available."
    fi
    
    # Check Git
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install Git first."
        exit 1
    fi
    
    print_success "System requirements check completed."
}

# Install root dependencies
install_root_deps() {
    print_status "Installing root dependencies..."
    npm install
    print_success "Root dependencies installed."
}

# Install frontend dependencies
install_frontend_deps() {
    print_status "Installing frontend dependencies..."
    cd frontend
    npm install
    cd ..
    print_success "Frontend dependencies installed."
}

# Install backend dependencies
install_backend_deps() {
    print_status "Installing backend dependencies..."
    cd backend
    npm install
    cd ..
    print_success "Backend dependencies installed."
}

# Install ML engine dependencies
install_ml_deps() {
    print_status "Installing ML engine dependencies..."
    if command -v python3 &> /dev/null; then
        cd ml-engine
        python3 -m pip install --upgrade pip
        python3 -m pip install -r requirements.txt
        cd ..
        print_success "ML engine dependencies installed."
    else
        print_warning "Skipping ML engine dependencies (Python not available)."
    fi
}

# Setup environment file
setup_env() {
    print_status "Setting up environment configuration..."
    if [ ! -f .env ]; then
        cp env.example .env
        print_success "Environment file created. Please edit .env with your configuration."
    else
        print_warning "Environment file already exists. Skipping."
    fi
}

# Setup Git repository
setup_git() {
    print_status "Setting up Git repository..."
    
    if [ ! -d .git ]; then
        git init
        git add .
        git commit -m "Initial commit: Metabolitica September project setup"
        print_success "Git repository initialized with initial commit."
    else
        print_warning "Git repository already exists. Skipping."
    fi
}

# Create necessary directories
create_directories() {
    print_status "Creating necessary directories..."
    
    # Create directories that might not exist yet
    mkdir -p frontend/src/{components,pages,context,hooks,utils,types,assets,styles}
    mkdir -p backend/src/{controllers,middleware,routes,services,models,utils,types,database}
    mkdir -p ml-engine/{src,models,data,tests}
    mkdir -p mobile/src/{components,screens,navigation,services,utils,types}
    mkdir -p workflows
    mkdir -p scripts
    mkdir -p tests/{e2e,integration,unit,fixtures}
    mkdir -p monitoring/{prometheus,grafana/provisioning/{dashboards,datasources}}
    
    print_success "Directory structure created."
}

# Setup development environment
setup_dev_env() {
    print_status "Setting up development environment..."
    
    # Create .env file if it doesn't exist
    setup_env
    
    # Install all dependencies
    install_root_deps
    install_frontend_deps
    install_backend_deps
    install_ml_deps
    
    print_success "Development environment setup completed."
}

# Main setup function
main() {
    echo "🧬 Welcome to Metabolitica September!"
    echo "======================================"
    
    # Check requirements
    check_requirements
    
    # Create directories
    create_directories
    
    # Setup development environment
    setup_dev_env
    
    # Setup Git
    setup_git
    
    echo ""
    echo "🎉 Setup completed successfully!"
    echo ""
    echo "Next steps:"
    echo "1. Edit .env file with your configuration"
    echo "2. Start development servers: npm run dev"
    echo "3. Open http://localhost:3000 in your browser"
    echo "4. Access API at http://localhost:3001"
    echo "5. Access ML engine at http://localhost:8000"
    echo ""
    echo "Happy coding! 🚀"
}

# Run main function
main "$@"

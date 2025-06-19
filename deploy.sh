#!/bin/bash

# MedusaJS B2C Starter Deployment Script
# This script helps automate the deployment process

set -e  # Exit on any error

echo "🚀 MedusaJS B2C Starter Deployment Script"
echo "=========================================="

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
check_dependencies() {
    print_status "Checking dependencies..."
    
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed. Please install Node.js 20+"
        exit 1
    fi
    
    if ! command -v pnpm &> /dev/null; then
        print_warning "pnpm is not installed. Installing pnpm..."
        npm install -g pnpm
    fi
    
    print_success "Dependencies check completed"
}

# Install project dependencies
install_dependencies() {
    print_status "Installing project dependencies..."
    pnpm install
    print_success "Dependencies installed"
}

# Setup environment files
setup_environment() {
    print_status "Setting up environment files..."
    
    # Backend environment
    if [ ! -f "backend/.env" ]; then
        print_warning "Backend .env file not found. Please create backend/.env with required variables."
        print_status "Required variables:"
        echo "  - DATABASE_URL"
        echo "  - REDIS_URL"
        echo "  - JWT_SECRET"
        echo "  - COOKIE_SECRET"
        echo "  - SANITY_API_TOKEN"
        echo "  - SANITY_PROJECT_ID"
        echo "  - S3_* variables"
        echo "  - STRIPE_API_KEY"
        echo ""
        read -p "Press Enter to continue after creating the .env file..."
    fi
    
    # Storefront environment
    if [ ! -f "storefront/.env.local" ]; then
        print_warning "Storefront .env.local file not found. Please create storefront/.env.local with required variables."
        print_status "Required variables:"
        echo "  - NEXT_PUBLIC_MEDUSA_BACKEND_URL"
        echo "  - NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY"
        echo "  - NEXT_PUBLIC_SANITY_PROJECT_ID"
        echo "  - NEXT_PUBLIC_SANITY_DATASET"
        echo "  - NEXT_PUBLIC_SANITY_API_VERSION"
        echo "  - SANITY_API_TOKEN"
        echo "  - NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY"
        echo ""
        read -p "Press Enter to continue after creating the .env.local file..."
    fi
    
    print_success "Environment setup completed"
}

# Build backend
build_backend() {
    print_status "Building backend..."
    cd backend
    pnpm run build
    cd ..
    print_success "Backend built successfully"
}

# Build storefront
build_storefront() {
    print_status "Building storefront..."
    cd storefront
    pnpm run build
    cd ..
    print_success "Storefront built successfully"
}

# Deploy to Vercel
deploy_vercel() {
    print_status "Deploying to Vercel..."
    
    if ! command -v vercel &> /dev/null; then
        print_warning "Vercel CLI not found. Installing..."
        npm install -g vercel
    fi
    
    # Deploy storefront
    cd storefront
    vercel --prod
    cd ..
    
    print_success "Deployed to Vercel"
}

# Deploy using Docker
deploy_docker() {
    print_status "Deploying using Docker..."
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    # Build and run with Docker Compose
    docker-compose up --build -d
    
    print_success "Deployed using Docker"
}

# Main deployment function
main() {
    echo ""
    print_status "Select deployment option:"
    echo "1) Local development setup"
    echo "2) Build for production"
    echo "3) Deploy to Vercel"
    echo "4) Deploy using Docker"
    echo "5) Full setup (dependencies + environment + build)"
    echo ""
    read -p "Enter your choice (1-5): " choice
    
    case $choice in
        1)
            check_dependencies
            install_dependencies
            setup_environment
            print_success "Local development setup completed!"
            print_status "Run 'pnpm dev' to start development servers"
            ;;
        2)
            check_dependencies
            install_dependencies
            build_backend
            build_storefront
            print_success "Production build completed!"
            ;;
        3)
            check_dependencies
            install_dependencies
            build_storefront
            deploy_vercel
            ;;
        4)
            deploy_docker
            ;;
        5)
            check_dependencies
            install_dependencies
            setup_environment
            build_backend
            build_storefront
            print_success "Full setup completed!"
            print_status "Your application is ready for deployment"
            ;;
        *)
            print_error "Invalid choice. Please run the script again."
            exit 1
            ;;
    esac
}

# Run main function
main 
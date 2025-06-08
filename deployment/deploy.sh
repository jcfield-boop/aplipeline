#!/bin/bash
# APLCICD v2.0 Production Deployment Script
# Automates deployment with validation and rollback capability

set -euo pipefail

# Configuration
DEPLOY_DIR="/opt/aplcicd"
BACKUP_DIR="/opt/aplcicd-backup-$(date +%Y%m%d-%H%M%S)"
LOG_FILE="/var/log/aplcicd-deploy.log"
HEALTH_CHECK_URL="http://localhost:8080/health"
HEALTH_CHECK_TIMEOUT=30

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

# Pre-deployment validation
validate_environment() {
    log "🔍 Validating deployment environment..."
    
    # Check required environment variables
    if [[ -z "${GITHUB_WEBHOOK_SECRET:-}" ]]; then
        error "GITHUB_WEBHOOK_SECRET environment variable not set"
        exit 1
    fi
    
    if [[ -z "${GITHUB_TOKEN:-}" ]]; then
        error "GITHUB_TOKEN environment variable not set"
        exit 1
    fi
    
    # Check Dyalog APL is available
    if ! command -v dyalog &> /dev/null; then
        error "Dyalog APL not found in PATH"
        exit 1
    fi
    
    # Check disk space (require at least 1GB free)
    available_space=$(df /opt --output=avail | tail -1)
    if [[ $available_space -lt 1048576 ]]; then
        error "Insufficient disk space. Need at least 1GB free in /opt"
        exit 1
    fi
    
    success "Environment validation passed"
}

# Configuration validation
validate_configuration() {
    log "⚙️ Validating configuration..."
    
    # Validate production configuration exists
    if [[ ! -f "config/production.json" ]]; then
        error "Production configuration not found: config/production.json"
        exit 1
    fi
    
    # Validate JSON syntax
    if ! python3 -m json.tool config/production.json > /dev/null; then
        error "Invalid JSON in production configuration"
        exit 1
    fi
    
    # Validate configuration using APL
    if ! dyalog -script validate_config.apl; then
        error "Configuration validation failed"
        exit 1
    fi
    
    success "Configuration validation passed"
}

# Run test suite
run_tests() {
    log "🧪 Running test suite..."
    
    # Run comprehensive test suite
    if ! dyalog -script run_tests.apl; then
        error "Test suite failed"
        exit 1
    fi
    
    success "All tests passed"
}

# Create backup of current deployment
create_backup() {
    log "💾 Creating backup of current deployment..."
    
    if [[ -d "$DEPLOY_DIR" ]]; then
        cp -r "$DEPLOY_DIR" "$BACKUP_DIR"
        log "Backup created: $BACKUP_DIR"
    else
        log "No existing deployment to backup"
    fi
}

# Deploy application
deploy_application() {
    log "🚀 Deploying APLCICD v2.0..."
    
    # Create deployment directory
    mkdir -p "$DEPLOY_DIR"
    
    # Copy application files
    cp -r src/* "$DEPLOY_DIR/"
    cp -r config/ "$DEPLOY_DIR/"
    cp -r monitoring/ "$DEPLOY_DIR/"
    
    # Set proper permissions
    chmod +x "$DEPLOY_DIR"/*.dyalog
    chown -R aplcicd:aplcicd "$DEPLOY_DIR"
    
    # Install systemd service
    if [[ -f "deployment/systemd/aplcicd.service" ]]; then
        cp deployment/systemd/aplcicd.service /etc/systemd/system/
        systemctl daemon-reload
    fi
    
    success "Application deployed"
}

# Start services
start_services() {
    log "🔄 Starting APLCICD services..."
    
    # Start main service
    systemctl enable aplcicd
    systemctl start aplcicd
    
    # Wait for service to be ready
    sleep 5
    
    success "Services started"
}

# Health check
health_check() {
    log "🏥 Performing health check..."
    
    local attempts=0
    local max_attempts=6
    
    while [[ $attempts -lt $max_attempts ]]; do
        if curl -f --max-time "$HEALTH_CHECK_TIMEOUT" "$HEALTH_CHECK_URL" &> /dev/null; then
            success "Health check passed"
            return 0
        fi
        
        attempts=$((attempts + 1))
        warning "Health check attempt $attempts/$max_attempts failed, retrying in 10 seconds..."
        sleep 10
    done
    
    error "Health check failed after $max_attempts attempts"
    return 1
}

# Rollback function
rollback() {
    error "Deployment failed, initiating rollback..."
    
    if [[ -d "$BACKUP_DIR" ]]; then
        log "🔄 Rolling back to previous version..."
        
        # Stop current services
        systemctl stop aplcicd || true
        
        # Restore backup
        rm -rf "$DEPLOY_DIR"
        mv "$BACKUP_DIR" "$DEPLOY_DIR"
        
        # Restart services
        systemctl start aplcicd
        
        # Wait and check health
        sleep 5
        if health_check; then
            success "Rollback completed successfully"
        else
            error "Rollback failed - manual intervention required"
            exit 1
        fi
    else
        error "No backup available for rollback"
        exit 1
    fi
}

# Main deployment flow
main() {
    log "🚀 Starting APLCICD v2.0 deployment..."
    
    # Pre-deployment checks
    validate_environment
    validate_configuration
    run_tests
    
    # Create backup
    create_backup
    
    # Deploy and start
    deploy_application
    start_services
    
    # Validate deployment
    if health_check; then
        success "✅ APLCICD v2.0 deployment completed successfully!"
        log "📊 Deployment metrics:"
        log "  - Backup location: $BACKUP_DIR"
        log "  - Health check: PASSED"
        log "  - Service status: $(systemctl is-active aplcicd)"
        
        # Clean up old backups (keep last 5)
        find /opt -name "aplcicd-backup-*" -type d | sort | head -n -5 | xargs rm -rf
        
    else
        # Health check failed - rollback
        rollback
        exit 1
    fi
}

# Handle errors
trap 'error "Deployment failed on line $LINENO"; rollback; exit 1' ERR

# Run deployment
main "$@"
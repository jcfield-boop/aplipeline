# 📁 APLCICD v2.0 Directory Restructure Plan

## Current Problems
- **15+ scattered directories** with legacy namespaces
- **Duplicate functionality** across multiple files
- **Development artifacts** mixed with production code
- **No clear separation** between core system and experimental features

## Target Structure (Production-Ready)

```
aplcicd/
├── README.md                          # Main documentation
├── CHANGELOG.md                        # Version history
├── LICENSE                             # MIT license
├── tatin.json                          # APL package metadata
│
├── src/                                # Core system (production-ready)
│   ├── APLCICD.dyalog                  # Main entry point (v2.0)
│   ├── Core.dyalog                     # AI detection algorithms  
│   ├── Pipeline.dyalog                 # CI/CD automation
│   ├── Monitor.dyalog                  # Monitoring & logging
│   └── Config.dyalog                   # Configuration management
│
├── config/                             # Configuration files
│   ├── production.json                 # Production settings
│   ├── staging.json                    # Staging settings
│   ├── development.json                # Development settings
│   └── templates/                      # Configuration templates
│       ├── github-integration.json
│       ├── monitoring-setup.json
│       └── security-defaults.json
│
├── tests/                              # Test suite
│   ├── TestFramework.dyalog            # Main test framework
│   ├── unit/                           # Unit tests
│   │   ├── test-ai-detection.dyalog
│   │   ├── test-pipeline.dyalog
│   │   ├── test-monitoring.dyalog
│   │   └── test-configuration.dyalog
│   ├── integration/                    # Integration tests
│   │   ├── test-full-workflow.dyalog
│   │   ├── test-github-integration.dyalog
│   │   └── test-monitoring-integration.dyalog
│   └── performance/                    # Performance tests
│       ├── test-ai-performance.dyalog
│       ├── test-scalability.dyalog
│       └── benchmarks.dyalog
│
├── security/                           # Security-related files
│   ├── audit-logs/                     # Security audit logs
│   ├── rate-limiting.dyalog            # Rate limiting implementation
│   ├── input-validation.dyalog         # Input sanitization
│   └── webhook-verification.dyalog     # Webhook signature verification
│
├── deployment/                         # Deployment automation
│   ├── deploy.sh                       # Main deployment script
│   ├── rollback.sh                     # Rollback script
│   ├── health-check.sh                 # Health verification
│   ├── docker/                         # Docker configuration
│   │   ├── Dockerfile
│   │   ├── docker-compose.yml
│   │   └── docker-compose.prod.yml
│   └── systemd/                        # Linux service files
│       └── aplcicd.service
│
├── docs/                               # Documentation
│   ├── installation.md                 # Installation guide
│   ├── configuration.md                # Configuration guide
│   ├── api-reference.md                # API documentation
│   ├── security.md                     # Security guide
│   ├── monitoring.md                   # Monitoring setup
│   ├── troubleshooting.md              # Common issues
│   └── development.md                  # Development guide
│
├── monitoring/                         # Monitoring dashboards
│   ├── grafana-dashboard.json          # Grafana dashboard
│   ├── prometheus-rules.yml            # Alerting rules
│   └── metrics-definitions.md          # Metrics documentation
│
├── logs/                               # Log files (runtime)
│   ├── application.log
│   ├── security.log
│   ├── audit.log
│   └── performance.log
│
└── archive/                            # Archived development files
    ├── original-namespaces/            # Original 15+ namespaces
    ├── experimental-features/          # Experimental code
    ├── development-artifacts/          # Development tools
    └── migration-tools/                # Tools used in restructure
```

## Migration Strategy

### Phase 1: Create Clean Structure
```bash
# Create production directory structure
mkdir -p src config tests security deployment docs monitoring logs archive
mkdir -p tests/{unit,integration,performance}
mkdir -p config/templates
mkdir -p deployment/{docker,systemd}
mkdir -p archive/{original-namespaces,experimental-features,development-artifacts}
```

### Phase 2: Move Production Files
```bash
# Move consolidated modules to src/
cp APLCICD_v2.dyalog src/APLCICD.dyalog
cp Core/CoreConsolidated.dyalog src/Core.dyalog  
cp Pipeline/PipelineConsolidated.dyalog src/Pipeline.dyalog
cp Monitor/MonitorConsolidated.dyalog src/Monitor.dyalog
cp Config/ConfigConsolidated.dyalog src/Config.dyalog

# Move test framework
cp Tests/TestFramework.dyalog tests/

# Move configuration files
mv config/*.json config/
```

### Phase 3: Archive Legacy Files
```bash
# Archive original namespaces
mv Analysis/ archive/original-namespaces/
mv Configuration/ archive/original-namespaces/
mv ErrorHandling/ archive/original-namespaces/
mv Examples/ archive/original-namespaces/
mv GitIntegration/ archive/original-namespaces/
mv Logging/ archive/original-namespaces/
mv Monitoring/ archive/original-namespaces/
mv Performance/ archive/original-namespaces/
mv Plugins/ archive/original-namespaces/
mv Publishing/ archive/original-namespaces/
mv Quality/ archive/original-namespaces/
mv Security/ archive/original-namespaces/
mv Server/ archive/original-namespaces/
mv Validation/ archive/original-namespaces/
mv WebHooks/ archive/original-namespaces/
mv WebServer/ archive/original-namespaces/

# Archive experimental features
mv Demo/ archive/experimental-features/
mv IntegrationTests/ archive/experimental-features/
mv RealTimeBackend/ archive/experimental-features/
mv old/ archive/development-artifacts/

# Archive development files
mv APLCICD.dyalog archive/original-namespaces/  # Original version
```

### Phase 4: Create Production Configuration
```json
// config/production.json
{
  "version": "2.0.0",
  "environment": "production",
  "pipeline": {
    "ai_threshold": 0.3,
    "quality_threshold": 0.7,
    "security_strict": true,
    "parallel_workers": 4,
    "timeout_seconds": 300
  },
  "security": {
    "rate_limiting": {
      "enabled": true,
      "requests_per_window": 100,
      "window_minutes": 5
    },
    "webhook_verification": true,
    "input_validation": "strict",
    "audit_logging": true
  },
  "monitoring": {
    "log_level": "info",
    "metrics_enabled": true,
    "export_format": "prometheus",
    "retention_days": 30
  },
  "github": {
    "webhook_secret_env": "GITHUB_WEBHOOK_SECRET",
    "token_env": "GITHUB_TOKEN",
    "verify_ssl": true,
    "api_timeout_seconds": 10
  }
}
```

## Benefits of New Structure

### 1. **Clear Separation of Concerns**
- **`src/`**: Only production-ready code (5 files vs 15+ namespaces)
- **`config/`**: Environment-specific configurations  
- **`tests/`**: Comprehensive test suite with clear categories
- **`security/`**: All security-related code in one place
- **`deployment/`**: All deployment automation
- **`archive/`**: Legacy code preserved but separated

### 2. **Production Readiness**
- Standard directory layout that ops teams expect
- Clear configuration management
- Proper logging and monitoring setup
- Security controls grouped together
- Automated deployment scripts

### 3. **Maintainability**
- **80% reduction** in top-level directories (26 → 5 production dirs)
- **Single source of truth** for each functionality
- **Clear upgrade path** from v1 to v2
- **Documentation** co-located with code

### 4. **Developer Experience**
- **Easy onboarding**: Clear structure and documentation
- **Fast builds**: Only essential files in src/
- **Simple testing**: Organized test suite
- **Flexible deployment**: Multiple environment configs

## File Size Analysis

### Before Restructure
```
Total files: ~50 .dyalog files
Core system: Spread across 15+ directories
Configuration: Mixed with legacy files
Tests: Scattered across multiple locations
Documentation: Mixed with development artifacts
```

### After Restructure  
```
Production files: 5 .dyalog files in src/
Test files: Organized in tests/ hierarchy
Configuration: Clean separation by environment
Documentation: Complete and organized
Archive: Legacy preserved but separate
```

## Migration Commands

Execute this restructure:

```bash
#!/bin/bash
# restructure.sh - Reorganize APLCICD to production layout

echo "🏗️ Restructuring APLCICD v2.0 to production layout..."

# Create new structure
mkdir -p src config tests/{unit,integration,performance} security deployment/{docker,systemd} docs monitoring logs
mkdir -p archive/{original-namespaces,experimental-features,development-artifacts}
mkdir -p config/templates

# Move production files
echo "Moving production files..."
cp APLCICD_v2.dyalog src/APLCICD.dyalog
cp Core/CoreConsolidated.dyalog src/Core.dyalog  
cp Pipeline/PipelineConsolidated.dyalog src/Pipeline.dyalog
cp Monitor/MonitorConsolidated.dyalog src/Monitor.dyalog
cp Config/ConfigConsolidated.dyalog src/Config.dyalog
cp Tests/TestFramework.dyalog tests/

# Archive legacy directories
echo "Archiving legacy namespaces..."
mv Analysis/ Configuration/ ErrorHandling/ Examples/ GitIntegration/ archive/original-namespaces/
mv Logging/ Monitoring/ Performance/ Plugins/ Publishing/ archive/original-namespaces/
mv Quality/ Security/ Server/ Validation/ WebHooks/ WebServer/ archive/original-namespaces/
mv Core/Core.dyalog Pipeline/Pipeline.dyalog Tests/Tests.dyalog archive/original-namespaces/

# Archive experimental features
echo "Archiving experimental features..."
mv Demo/ IntegrationTests/ RealTimeBackend/ Secrets/ archive/experimental-features/

# Archive development artifacts
echo "Archiving development artifacts..."
mv old/ archive/development-artifacts/
mv APLCICD.dyalog archive/original-namespaces/

# Clean up empty directories
rmdir Core/ Pipeline/ Monitor/ Tests/ 2>/dev/null || true

echo "✅ Restructure complete!"
echo "📁 Production files: src/"
echo "🧪 Tests: tests/"
echo "⚙️ Config: config/"
echo "📦 Archive: archive/"
```

This restructure transforms the project from a **development prototype** into a **production-ready system** with clear organization, proper separation of concerns, and enterprise-grade structure.
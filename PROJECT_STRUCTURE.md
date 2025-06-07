# APLCICD Project Structure

## 🏗️ Clean Directory Organization

### **Core APL Modules**
```
APLCICD.dyalog              # Main system entry point
Core/Core.dyalog            # Ultra-concise AI detection (18-char + enhanced)
Pipeline/Pipeline.dyalog    # CI/CD pipeline automation
Monitoring/Monitoring.dyalog # Enterprise monitoring & Grafana integration
Configuration/Configuration.dyalog # System configuration management
Secrets/Secrets.dyalog      # Secure credential management
```

### **Specialized Components**
```
Analysis/Analysis.dyalog    # Performance analysis & benchmarking
Security/Security.dyalog    # Security scanning & validation
Quality/Quality.dyalog      # Code quality assessment
Validation/Validation.dyalog # Syntax & style validation
ErrorHandling/ErrorHandling.dyalog # Error management
Performance/Performance.dyalog # Performance profiling
WebServer/WebServer.dyalog  # APL-native web server
Publishing/Publishing.dyalog # Package publishing & distribution
```

### **Development & Testing**
```
Demo/Demo.dyalog           # System demonstrations
Examples/Examples.dyalog   # Usage examples
Tests/Tests.dyalog         # Test suite
IntegrationTests/IntegrationTests.dyalog # Integration testing
Plugins/Plugins.dyalog     # Plugin architecture
Server/Server.dyalog       # Server components
```

### **Web Interfaces**
```
monitoring_dashboard.html  # 🌟 Main enterprise web interface
dashboard.html            # Project overview dashboard
grafana-dashboards/       # Grafana dashboard configurations
```

### **Configuration Files**
```
aplcicd_secrets.json      # 🔐 Secure credential storage
aplcicd.dcfg             # APL package configuration
tatin.json               # Tatin package manager config
docker-compose.yml       # Container orchestration
Dockerfile               # Container definition
aplcicd.sh               # Shell automation script
```

### **Documentation**
```
README.md                    # Main project documentation
COMPREHENSIVE_AI_DETECTION.md # AI detection system details
GRAFANA_INTEGRATION.md       # Grafana setup guide
GRAFANA_CLOUD_SETUP.md       # Cloud configuration
APL_THEORY.md               # APL theoretical foundations
VERSION_CONTROL.md          # Git integration strategy
INSTALLATION.md             # Setup instructions
RUN_REAL_DEMOS.md          # Demo execution guide
SELF_ANALYSIS.md           # System capabilities analysis
```

### **Archive Directory**
```
old/                     # Test scripts, experimental code, deprecated files
├── src/                 # Original source experiments
├── docs/                # Legacy documentation
├── tests/               # Old test files
└── *.apl               # Development and test scripts
```

## 🎯 Key Entry Points

### **Web Configuration**
- **Main Interface**: `monitoring_dashboard.html`
  - Repository secrets configuration
  - Grafana Cloud integration
  - Real-time monitoring
  - Enterprise triage queue
  - Performance analytics

### **APL Development**
- **Core System**: Load `APLCICD.dyalog` for full functionality
- **AI Detection**: `Core.Enhanced` for advanced detection
- **Monitoring**: `Monitoring.Initialize` for enterprise monitoring
- **Secrets**: `Secrets.LoadSecrets` for configuration management

### **Production Deployment**
- **Container**: Use `docker-compose.yml` for containerized deployment
- **Package**: Use `tatin.json` for APL package distribution
- **Scripts**: Use `aplcicd.sh` for automation

## ✅ Clean State Achieved

- ✅ All test scripts moved to `/old`
- ✅ Core functionality preserved
- ✅ Web interfaces functional
- ✅ Documentation organized
- ✅ Configuration system ready
- ✅ Secure credential management active
- ✅ Grafana integration prepared

## 🚀 Ready for Production Configuration

The project is now ready for:
1. Repository secret configuration via web interface
2. Grafana Cloud dashboard deployment
3. Enterprise CI/CD pipeline setup
4. Real-world usage and monitoring
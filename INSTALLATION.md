# APLCICD Installation Guide

## System Requirements

### Dyalog APL Version Compatibility
- **Dyalog 18.0+**: Core features supported
- **Dyalog 19.0+**: Full features including Isolates and enhanced performance
- **Unicode Edition**: Required for all installations
- **Operating Systems**: Windows, Linux, macOS

### Dependencies
- **HttpCommand** (≥5.0.0): HTTP communication
- **Conga** (≥3.0.0): Network connectivity
- **Git**: Version control integration
- **Docker**: Optional, for containerized deployment

## Installation Methods

### 1. Tatin Package Manager (Recommended)

The modern Dyalog standard for package management:

```apl
]TATIN.Install aplcicd
```

Or with specific version:
```apl
]TATIN.Install aplcicd@1.0.0
```

**Advantages:**
- Automatic dependency resolution
- Version management
- Easy updates
- Cross-platform compatibility

### 2. Docker Container

For production deployments and isolated environments:

```bash
# Pull and run latest version
docker run -p 8080:8080 dyalog/aplcicd:latest

# Run with custom configuration
docker run -p 8080:8080 -v /path/to/config:/app/config dyalog/aplcicd:latest

# Build from source
git clone https://github.com/aplforge/aplcicd
cd aplcicd
docker build -t aplcicd:custom .
docker run -p 8080:8080 aplcicd:custom
```

**Advantages:**
- Isolated environment
- Easy deployment
- Consistent runtime
- Built-in health checks

### 3. Source Installation

For development and customization:

```bash
# Clone repository
git clone https://github.com/aplforge/aplcicd
cd aplcicd

# Initialize APL workspace
dyalog APLCICD.dyalog -e "APLCICD.Initialize"

# Run validation
dyalog -script -e "APLCICD.ValidateInstallation"
```

**APL Commands:**
```apl
⎕FIX'file://APLCICD.dyalog'
APLCICD.Initialize
APLCICD.ValidateInstallation
```

### 4. Standalone Package

Download pre-built packages from releases:

```bash
# Download and extract
wget https://github.com/aplforge/aplcicd/releases/download/v1.0.0/aplcicd-1.0.0.zip
unzip aplcicd-1.0.0.zip
cd aplcicd-1.0.0

# Run directly
dyalog APLCICD.dyalog
```

## Version Compatibility Matrix

| Feature | APL 18.0 | APL 18.2 | APL 19.0+ | Notes |
|---------|----------|----------|-----------|-------|
| Core AI Detection | ✅ | ✅ | ✅ | Full compatibility |
| CI/CD Pipeline | ✅ | ✅ | ✅ | All versions |
| Syntax Validation | ✅ | ✅ | ✅ | Universal support |
| Security Scanning | ✅ | ✅ | ✅ | Pattern matching |
| Quality Analysis | ✅ | ✅ | ✅ | Array processing |
| Performance Profiling | ⚠️ | ✅ | ✅ | Limited in 18.0 |
| Isolates Support | ❌ | ⚠️ | ✅ | 19.0+ recommended |
| Web Server | ✅ | ✅ | ✅ | Conga required |
| Docker Support | ✅ | ✅ | ✅ | All versions |
| Tatin Integration | ❌ | ✅ | ✅ | 18.2+ only |

**Legend:**
- ✅ Full support
- ⚠️ Limited support  
- ❌ Not supported

## Configuration

### Environment Variables

```bash
# Set APL workspace location
export APLCICD_HOME=/path/to/aplcicd

# Configure web server port
export APLCICD_PORT=8080

# Set registry for publishing
export TATIN_REGISTRY=https://registry.tatin.dev
```

### APL Configuration

```apl
⍝ Configure APLCICD settings
config ← ⎕NS ''
config.quality_threshold ← 0.5
config.ai_threshold ← 0.3
config.security_strict ← 1
Configuration.SaveConfig config 'aplcicd.config'
```

## Verification

### Quick Test
```apl
APLCICD.Initialize
APLCICD.AI 'Generated using AI'  ⍝ Should return ≈0.8
APLCICD.AI 'Fix bug in login'    ⍝ Should return ≈0.1
```

### Full Validation
```apl
⍝ Run complete validation suite
APLCICD.ValidateInstallation
Pipeline.RunPipeline '*.dyalog'
IntegrationTests.RunAllTests
```

### Health Check (Docker)
```bash
# Container health check
docker exec <container_id> dyalog -script -e "APLCICD.HealthCheck"
```

## Troubleshooting

### Common Issues

**1. "Core.Detect not found"**
```apl
⍝ Ensure proper loading order
APLCICD.LoadComponents
Core.Initialize
```

**2. "Tatin not available"**
- Update to Dyalog 18.2+
- Install Tatin package manager separately

**3. "Conga connection failed"**
```apl
⍝ Check Conga installation
'Conga' ⎕CY 'conga'
```

**4. Docker build fails**
- Ensure APL source files have correct encoding
- Check .dockerignore excludes unnecessary files

### Performance Tuning

```apl
⍝ Optimize for large repositories
config.parallel_jobs ← ⌊0.5+2×⎕NCORES
config.memory_limit ← 1000000000  ⍝ 1GB
config.timeout ← 300  ⍝ 5 minutes

⍝ Enable caching
config.cache_enabled ← 1
config.cache_size ← 10000
```

## Integration Examples

### GitHub Actions
```yaml
name: APLCICD
on: [push, pull_request]
jobs:
  ci:
    runs-on: ubuntu-latest
    container: dyalog/aplcicd:latest
    steps:
      - uses: actions/checkout@v2
      - name: Run APLCICD
        run: dyalog -script -e "Pipeline.RunPipeline '*.dyalog'"
```

### GitLab CI
```yaml
aplcicd:
  image: dyalog/aplcicd:latest
  script:
    - dyalog -script -e "APLCICD.Initialize"
    - dyalog -script -e "Pipeline.RunPipeline '*.dyalog'"
  artifacts:
    reports:
      junit: test-results.xml
```

### Jenkins Pipeline
```groovy
pipeline {
    agent {
        docker {
            image 'dyalog/aplcicd:latest'
        }
    }
    stages {
        stage('APLCICD') {
            steps {
                sh 'dyalog -script -e "Pipeline.RunPipeline \'*.dyalog\'"'
            }
        }
    }
}
```

## Development Setup

### Local Development
```bash
# Clone and setup development environment
git clone https://github.com/aplforge/aplcicd
cd aplcicd

# Install development dependencies
]TATIN.Install HttpCommand Conga

# Setup APL-aware Git hooks
Publishing.VersionControl.InitializeRepository

# Start development server
dyalog -script -e "APLCICD.StartServer 8080"
```

### Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature-name`
3. Follow semantic commits: `Publishing.VersionControl.SemanticCommit 'feat' 'add new feature'`
4. Run tests: `IntegrationTests.RunAllTests`
5. Submit pull request

## Support

- **Documentation**: See README.md for detailed features
- **Issues**: Report bugs on GitHub issues
- **Community**: Dyalog APL forums
- **Commercial**: Contact APL development team

## License

MIT License - see LICENSE file for details.
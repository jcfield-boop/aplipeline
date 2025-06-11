# APLCICD Troubleshooting Guide

## Overview

This guide covers common issues, diagnostic procedures, and solutions for APLCICD v2.0. Use this guide to quickly identify and resolve problems in installation, configuration, and operation.

## Installation Issues

### Dyalog APL Detection Problems

#### Error: "Dyalog APL not found in standard locations"

**Symptoms:**
- APLCICD fails to start with APL detection error
- Manual APL path specification required

**Diagnosis:**
```bash
# Check if Dyalog APL is installed
which dyalog
ls /Applications/Dyalog-*/Contents/Resources/Dyalog/mapl
ls /opt/mdyalog/*/64/unicode/mapl

# Check environment variable
echo $DYALOG
```

**Solutions:**

1. **Set DYALOG environment variable:**
   ```bash
   export DYALOG="/path/to/your/dyalog/mapl"
   ./aplcicd status
   ```

2. **Install Dyalog APL in standard location:**
   ```bash
   # macOS: Install Dyalog to /Applications/
   # Linux: Install to /opt/mdyalog/
   ```

3. **Verify APL version compatibility:**
   ```apl
   ⎕SE.⎕VER
   ⍝ Should show 19.0 or later
   ```

#### Error: "Could not load workspace"

**Symptoms:**
- APL starts but cannot load APLCICD modules
- Namespace errors during initialization

**Diagnosis:**
```apl
⍝ Check workspace integrity
11 ⎕NINFO './src/APLCICD.dyalog'

⍝ Test basic APL functionality
⎕←'Hello World'

⍝ Check available memory
⎕WA
```

**Solutions:**

1. **Increase workspace size:**
   ```bash
   export APLCICD_WORKSPACE=512M
   ./aplcicd status
   ```

2. **Check file permissions:**
   ```bash
   ls -la src/
   chmod +r src/*.dyalog
   ```

3. **Rebuild workspace if corrupted:**
   ```bash
   # Clean restart
   ./aplcicd status --clean
   ```

### Dependency Issues

#### Error: "Conga not available"

**Symptoms:**
- Web server functionality unavailable
- HTTP operations fail

**Diagnosis:**
```apl
⍝ Check if Conga is loaded
9=⎕NC'DRC'

⍝ Try loading Conga manually
'DRC' ⎕CY 'conga'
```

**Solutions:**

1. **Install Conga via TATIN:**
   ```apl
   ]TATIN.InstallPackages conga
   ```

2. **Load Conga manually:**
   ```apl
   ⍝ Add to workspace
   'DRC' ⎕CY 'conga'
   ```

3. **Use fallback dashboard:**
   ```bash
   # Opens file-based dashboard instead
   ./aplcicd dashboard --fallback
   ```

## Runtime Issues

### Memory Management

#### High Memory Usage

**Symptoms:**
- Slow performance
- WS FULL errors
- System becomes unresponsive

**Diagnosis:**
```apl
⍝ Check workspace availability
⎕WA

⍝ Analyze memory usage by variable
)SYMBOLS
⎕SIZE 'variable_name'

⍝ Check system memory usage
RealMonitor.GetMetrics.memory_mb
```

**Solutions:**

1. **Clear unused variables:**
   ```apl
   ⎕EX 'large_variable'
   ⎕EX ⎕NL 2  ⍝ Clear all variables (use carefully)
   ```

2. **Increase workspace size:**
   ```bash
   export APLCICD_WORKSPACE=1024M
   ./aplcicd restart
   ```

3. **Enable garbage collection:**
   ```json
   {
     "system": {
       "gc_threshold": 500,
       "max_memory_mb": 512
     }
   }
   ```

4. **Monitor memory usage:**
   ```apl
   RealMonitor.StartMonitoring 30  ⍝ Monitor every 30 seconds
   ```

#### Memory Leaks

**Symptoms:**
- Gradually increasing memory usage
- Performance degradation over time

**Diagnosis:**
```apl
⍝ Profile memory usage over time
]PROFILE ON
⍝ Run problematic operation
]PROFILE OFF
]PROFILE REPORT

⍝ Check for circular references
)REFS variable_name
```

**Solutions:**

1. **Clear circular references:**
   ```apl
   ⍝ Break circular references manually
   object.reference ← ⍬
   ```

2. **Restart monitoring:**
   ```apl
   RealMonitor.StopMonitoring
   RealMonitor.StartMonitoring 60
   ```

3. **Reduce retention settings:**
   ```json
   {
     "monitoring": {
       "metrics_history": 100,
       "log_retention_days": 7
     }
   }
   ```

### Performance Issues

#### Slow Pipeline Execution

**Symptoms:**
- Pipeline taking longer than expected
- Timeout errors during processing

**Diagnosis:**
```bash
# Check system resources
top -p $(pgrep dyalog)
iostat -x 1 5

# Profile pipeline execution
./aplcicd benchmark
```

**APL Profiling:**
```apl
]PROFILE ON
files ← ⊃⎕NINFO⍠1⊢'src/*.dyalog'
result ← RealPipeline.RunPipeline files
]PROFILE OFF
]PROFILE REPORT
```

**Solutions:**

1. **Reduce parallel jobs:**
   ```json
   {
     "pipeline": {
       "max_parallel_jobs": 2
     }
   }
   ```

2. **Increase timeout:**
   ```json
   {
     "system": {
       "timeout_seconds": 600
     }
   }
   ```

3. **Optimize file processing:**
   ```apl
   ⍝ Process files in smaller batches
   batches ← 5 5⍴files
   results ← RealPipeline.RunPipeline¨batches
   ```

4. **Skip non-essential analysis:**
   ```json
   {
     "pipeline": {
       "performance_analysis": false,
       "security_strict": false
     }
   }
   ```

#### Dashboard Performance Issues

**Symptoms:**
- Slow dashboard loading
- Unresponsive web interface

**Diagnosis:**
```bash
# Check web server status
curl -I http://localhost:8081

# Monitor web server logs
tail -f logs/webserver.log
```

**Solutions:**

1. **Use HTMLRenderer dashboard:**
   ```bash
   ./aplcicd dashboard --renderer
   ```

2. **Reduce update frequency:**
   ```json
   {
     "monitoring": {
       "interval_seconds": 120
     }
   }
   ```

3. **Disable real-time features:**
   ```json
   {
     "webserver": {
       "real_time_updates": false
     }
   }
   ```

## Configuration Issues

### Invalid Configuration

#### Error: "Configuration validation failed"

**Symptoms:**
- System fails to start
- Configuration errors in logs

**Diagnosis:**
```bash
# Validate JSON syntax
jq . config/default.json

# Test configuration loading
./aplcicd status --validate-config
```

**Common Validation Errors:**

1. **Invalid JSON syntax:**
   ```bash
   # Fix JSON syntax errors
   jq . config/default.json
   # Error: parse error: Invalid numeric literal
   ```

2. **Missing required fields:**
   ```json
   {
     "security": {
       "hmac_secret": "required-field-missing"
     }
   }
   ```

3. **Invalid value ranges:**
   ```json
   {
     "pipeline": {
       "quality_threshold": 1.5  // Error: must be 0-1
     }
   }
   ```

**Solutions:**

1. **Reset to default configuration:**
   ```bash
   cp config/default.json.backup config/default.json
   ./aplcicd status
   ```

2. **Validate specific settings:**
   ```apl
   config ← Config.LoadConfig 'config/default.json'
   validation ← Config.ValidateConfiguration config
   ⎕←validation.errors
   ```

3. **Use environment variable overrides:**
   ```bash
   export APLCICD_CONFIG=config/minimal.json
   ./aplcicd status
   ```

### Environment Variable Issues

#### Error: "Environment variable override failed"

**Diagnosis:**
```bash
# Check environment variables
env | grep APLCICD

# Test variable expansion
echo $APLCICD_SECRET
```

**Solutions:**

1. **Set required environment variables:**
   ```bash
   export APLCICD_SECRET="your-secret-key"
   export APLCICD_LOG_LEVEL="DEBUG"
   ```

2. **Use configuration file instead:**
   ```json
   {
     "security": {
       "hmac_secret": "direct-config-value"
     }
   }
   ```

## Git Integration Issues

### Git Operations Failing

#### Error: "Git command failed"

**Symptoms:**
- Commit operations fail
- Repository status unavailable

**Diagnosis:**
```bash
# Check Git installation
git --version
which git

# Test Git configuration
git config --list
git status

# Check repository health
git fsck
```

**Solutions:**

1. **Configure Git user:**
   ```bash
   git config --global user.email "ci@example.com"
   git config --global user.name "APL CI"
   ```

2. **Fix repository issues:**
   ```bash
   # Reset repository state
   git reset --hard HEAD
   git clean -fd
   ```

3. **Disable Git integration temporarily:**
   ```json
   {
     "git": {
       "audit_logging": false,
       "auto_commit": false
     }
   }
   ```

#### Permission Issues

**Symptoms:**
- Cannot write to repository
- Git push/pull operations fail

**Diagnosis:**
```bash
# Check file permissions
ls -la .git/
ls -la .

# Test Git operations
git add .
git commit -m "test"
```

**Solutions:**

1. **Fix permissions:**
   ```bash
   chmod -R u+w .git/
   chown -R $USER .
   ```

2. **Configure SSH keys:**
   ```bash
   ssh-keygen -t rsa -b 4096
   ssh-add ~/.ssh/id_rsa
   ```

## Web Server Issues

### Port Conflicts

#### Error: "Port already in use"

**Symptoms:**
- Web server fails to start
- Dashboard inaccessible

**Diagnosis:**
```bash
# Check port usage
lsof -i :8081
netstat -tulpn | grep 8081

# Test alternative ports
curl localhost:8082
```

**Solutions:**

1. **Use different port:**
   ```json
   {
     "webserver": {
       "port": 8082
     }
   }
   ```

2. **Stop conflicting service:**
   ```bash
   # Kill process using port 8081
   sudo kill $(lsof -t -i:8081)
   ```

3. **Use HTMLRenderer instead:**
   ```bash
   ./aplcicd dashboard --renderer
   ```

### SSL/TLS Issues

#### Error: "SSL certificate invalid"

**Diagnosis:**
```bash
# Check certificate
openssl x509 -in cert.pem -text -noout

# Test SSL connection
openssl s_client -connect localhost:8081
```

**Solutions:**

1. **Disable SSL for development:**
   ```json
   {
     "webserver": {
       "ssl_enabled": false
     }
   }
   ```

2. **Generate self-signed certificate:**
   ```bash
   openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes
   ```

## Vibe Coding Issues

### Compression Problems

#### Error: "Compression failed"

**Symptoms:**
- Vibe compression returns empty results
- Decompression produces incorrect output

**Diagnosis:**
```apl
⍝ Test basic compression
original ← 'test ← {⎕IO ← 0}'
compressed ← Vibe.Compress original
decompressed ← Vibe.Decompress compressed

⍝ Check if original equals decompressed
original ≡ decompressed
```

**Solutions:**

1. **Use simpler compression level:**
   ```json
   {
     "vibe": {
       "compression_level": "minimal"
     }
   }
   ```

2. **Check glossary integrity:**
   ```apl
   glossary ← Vibe.GenerateGlossary
   ⎕←'Glossary entries: ',⍕≢glossary
   ```

3. **Reset compression mappings:**
   ```bash
   rm config/GLOSSARY.md
   ./aplcicd vibe "test code"  # Regenerates glossary
   ```

## Monitoring Issues

### Log File Problems

#### Error: "Cannot write to log file"

**Diagnosis:**
```bash
# Check log directory permissions
ls -la logs/
df -h logs/  # Check disk space

# Test log writing
echo "test" >> logs/test.log
```

**Solutions:**

1. **Fix permissions:**
   ```bash
   mkdir -p logs
   chmod 755 logs
   ```

2. **Change log directory:**
   ```bash
   export APLCICD_LOG_DIR=/tmp/aplcicd-logs
   ./aplcicd status
   ```

3. **Disable logging temporarily:**
   ```json
   {
     "monitoring": {
       "enabled": false
     }
   }
   ```

### Monitoring Data Issues

#### Error: "Metrics collection failed"

**Diagnosis:**
```apl
⍝ Test metrics collection
metrics ← RealMonitor.GetMetrics
⎕←'Metrics available: ',⍕≢⎕NL⍠1⊢metrics

⍝ Check monitoring status
status ← RealMonitor.GetStatus
⎕←'Monitoring active: ',⍕status.active
```

**Solutions:**

1. **Restart monitoring:**
   ```apl
   RealMonitor.StopMonitoring
   RealMonitor.StartMonitoring 60
   ```

2. **Reduce monitoring frequency:**
   ```json
   {
     "monitoring": {
       "interval_seconds": 300
     }
   }
   ```

## Diagnostic Commands

### System Health Check
```bash
# Comprehensive system check
./aplcicd status

# Detailed health information
./aplcicd demo --verbose
```

### APL Diagnostic Commands
```apl
⍝ System information
⎕SE.⎕VER
⎕WA
)SYMBOLS

⍝ Module status
health ← APLCICD.HealthCheck
⎕←'System status: ',health.status

⍝ Performance analysis
analysis ← SelfOptimizer.AnalyzeSystem
⎕←'Performance score: ',⍕analysis.performance_score
```

### Log Analysis
```bash
# Recent errors
grep -i error logs/*.log | tail -10

# Performance metrics
grep -i "slow\|timeout" logs/*.log

# Configuration issues
grep -i "config\|validation" logs/*.log
```

### Network Diagnostics
```bash
# Test web server
curl -v http://localhost:8081/api/status

# Check network connectivity
ping localhost
telnet localhost 8081
```

## Recovery Procedures

### Complete System Reset

**When to use:** System is completely unresponsive or corrupted

**Steps:**
1. **Stop all processes:**
   ```bash
   pkill -f dyalog
   pkill -f aplcicd
   ```

2. **Clean workspace:**
   ```bash
   rm -rf /tmp/aplcicd_*
   ```

3. **Reset configuration:**
   ```bash
   cp config/default.json.backup config/default.json
   ```

4. **Restart system:**
   ```bash
   ./aplcicd status
   ```

### Partial Recovery

**When to use:** Specific component failures

**Module-specific recovery:**
```apl
⍝ Reload specific module
⎕EX 'Vibe'
⎕FIX'file://src/vibe.dyalog'
Vibe.Initialize

⍝ Reset monitoring
RealMonitor.StopMonitoring
RealMonitor.StartMonitoring 60
```

### Backup and Restore

**Create backup:**
```bash
# Backup configuration
cp -r config/ config.backup/

# Backup logs
tar -czf logs_backup.tar.gz logs/

# Backup workspace
cp aplcicd.dws aplcicd.dws.backup
```

**Restore from backup:**
```bash
# Restore configuration
cp -r config.backup/ config/

# Restore logs
tar -xzf logs_backup.tar.gz

# Restore workspace
cp aplcicd.dws.backup aplcicd.dws
```

## Getting Additional Help

### Log Analysis Tools
```bash
# Structured log analysis
jq . logs/metrics_*.json | head -50

# Error pattern analysis
awk '/ERROR|FAIL/ {print NR ": " $0}' logs/aplcicd.log
```

### Performance Profiling
```apl
⍝ Enable detailed profiling
]PROFILE CLEAR
]PROFILE ON

⍝ Run problematic operation
problematic_function

]PROFILE OFF
]PROFILE SAVE 'performance_analysis'
]PROFILE REPORT
```

### Support Resources

1. **GitHub Issues**: Report bugs and feature requests
2. **APL Community Forums**: General APL and APLCICD discussions
3. **Documentation**: Complete API reference in `docs/API.md`
4. **Configuration Guide**: Detailed settings in `docs/CONFIGURATION.md`

### Creating Support Requests

**Include the following information:**

1. **System Information:**
   ```bash
   uname -a
   ./aplcicd status
   echo $DYALOG
   ```

2. **Error Details:**
   ```bash
   tail -50 logs/aplcicd.log
   ./aplcicd demo 2>&1 | tail -20
   ```

3. **Configuration:**
   ```bash
   cat config/default.json | jq .
   env | grep APLCICD
   ```

---

**Troubleshooting Guide Version**: 2.0.0  
**Last Updated**: Production Release  
**Compatibility**: APLCICD v2.0+
# APLCICD Configuration Guide

## Overview

This guide covers all configuration options for APLCICD v2.0, including system settings, pipeline parameters, security options, and environment variables.

## Configuration File Structure

APLCICD uses JSON-based configuration stored in `config/default.json`. The configuration is validated on startup and provides sensible defaults for all options.

### Default Configuration Location
```
config/
├── default.json    # Main configuration file
├── GLOSSARY.md     # Auto-generated vibe compression mappings
└── COMMENTS.archive # Archived code comments (when enabled)
```

## Core Configuration Sections

### System Configuration

```json
{
  "system": {
    "max_memory_mb": 512,
    "timeout_seconds": 300,
    "log_level": "INFO",
    "performance_threshold": 0.5,
    "gc_threshold": 1000
  }
}
```

#### System Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `max_memory_mb` | Number | 512 | Maximum memory usage in MB |
| `timeout_seconds` | Number | 300 | Operation timeout in seconds |
| `log_level` | String | "INFO" | Logging verbosity: DEBUG, INFO, WARN, ERROR |
| `performance_threshold` | Number | 0.5 | Minimum performance score for operations |
| `gc_threshold` | Number | 1000 | Garbage collection threshold |

#### Example: High-Performance Configuration
```json
{
  "system": {
    "max_memory_mb": 1024,
    "timeout_seconds": 600,
    "log_level": "WARN",
    "performance_threshold": 0.3,
    "gc_threshold": 2000
  }
}
```

### Pipeline Configuration

```json
{
  "pipeline": {
    "max_parallel_jobs": 4,
    "quality_threshold": 0.6,
    "security_strict": true,
    "syntax_check": true,
    "performance_analysis": true,
    "auto_commit": false
  }
}
```

#### Pipeline Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `max_parallel_jobs` | Number | 4 | Maximum concurrent pipeline jobs |
| `quality_threshold` | Number | 0.6 | Minimum code quality score (0-1) |
| `security_strict` | Boolean | true | Enable strict security validation |
| `syntax_check` | Boolean | true | Perform APL syntax validation |
| `performance_analysis` | Boolean | true | Include performance profiling |
| `auto_commit` | Boolean | false | Automatically commit successful builds |

#### Example: Development Configuration
```json
{
  "pipeline": {
    "max_parallel_jobs": 2,
    "quality_threshold": 0.4,
    "security_strict": false,
    "syntax_check": true,
    "performance_analysis": false,
    "auto_commit": false
  }
}
```

### Security Configuration

```json
{
  "security": {
    "hmac_secret": "configure-in-production",
    "rate_limit_requests": 100,
    "rate_limit_window": 3600,
    "input_validation": true,
    "timing_safe_comparison": true,
    "max_file_size_mb": 10
  }
}
```

#### Security Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `hmac_secret` | String | Required | HMAC secret for webhook validation |
| `rate_limit_requests` | Number | 100 | Maximum requests per window |
| `rate_limit_window` | Number | 3600 | Rate limiting window in seconds |
| `input_validation` | Boolean | true | Enable input sanitization |
| `timing_safe_comparison` | Boolean | true | Use timing-safe string comparison |
| `max_file_size_mb` | Number | 10 | Maximum file size for processing |

#### Example: High-Security Configuration
```json
{
  "security": {
    "hmac_secret": "${APLCICD_SECRET}",
    "rate_limit_requests": 50,
    "rate_limit_window": 1800,
    "input_validation": true,
    "timing_safe_comparison": true,
    "max_file_size_mb": 5
  }
}
```

### Vibe Coding Configuration

```json
{
  "vibe": {
    "enabled": true,
    "vibe_mode": true,
    "compression_level": "standard",
    "target_compression": 0.6,
    "auto_glossary": true,
    "runtime_mode": true,
    "edit_mode": false,
    "preserve_comments": true,
    "comment_archive": "config/COMMENTS.archive"
  }
}
```

#### Vibe Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `enabled` | Boolean | true | Enable vibe coding system |
| `vibe_mode` | Boolean | true | Activate compression mode |
| `compression_level` | String | "standard" | Compression level: minimal, standard, maximum |
| `target_compression` | Number | 0.6 | Target compression ratio (0-1) |
| `auto_glossary` | Boolean | true | Auto-generate glossary file |
| `runtime_mode` | Boolean | true | Enable runtime compression |
| `edit_mode` | Boolean | false | Enable edit-time compression |
| `preserve_comments` | Boolean | true | Archive comments when compressing |
| `comment_archive` | String | "config/COMMENTS.archive" | Comment archive file path |

#### Compression Levels

##### Minimal Compression
```json
{
  "vibe": {
    "compression_level": "minimal",
    "target_compression": 0.3
  }
}
```
- Function names compressed only
- Variables retain original names
- Comments preserved
- 20-30% compression ratio

##### Standard Compression
```json
{
  "vibe": {
    "compression_level": "standard",
    "target_compression": 0.6
  }
}
```
- Function and variable compression
- Common patterns compressed
- Selective comment removal
- 40-60% compression ratio

##### Maximum Compression
```json
{
  "vibe": {
    "compression_level": "maximum",
    "target_compression": 0.8
  }
}
```
- Aggressive symbol mapping
- All identifiers compressed
- Comments archived
- 60-80% compression ratio

### Git Integration Configuration

```json
{
  "git": {
    "auto_commit": false,
    "commit_template": "Automated improvement: {description}",
    "branch_protection": true,
    "audit_logging": true,
    "require_message": true,
    "sign_commits": false
  }
}
```

#### Git Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `auto_commit` | Boolean | false | Automatically commit improvements |
| `commit_template` | String | Template | Commit message template |
| `branch_protection` | Boolean | true | Protect main branches from auto-commits |
| `audit_logging` | Boolean | true | Log all Git operations |
| `require_message` | Boolean | true | Require commit messages |
| `sign_commits` | Boolean | false | GPG sign commits |

### Web Server Configuration

```json
{
  "webserver": {
    "port": 8081,
    "host": "localhost",
    "auto_start": true,
    "dashboard_enabled": true,
    "api_enabled": true,
    "cors_enabled": false,
    "ssl_enabled": false
  }
}
```

#### Web Server Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `port` | Number | 8081 | HTTP server port |
| `host` | String | "localhost" | Server bind address |
| `auto_start` | Boolean | true | Start server on dashboard launch |
| `dashboard_enabled` | Boolean | true | Enable dashboard interface |
| `api_enabled` | Boolean | true | Enable REST API endpoints |
| `cors_enabled` | Boolean | false | Enable CORS headers |
| `ssl_enabled` | Boolean | false | Enable HTTPS (requires certificates) |

### Monitoring Configuration

```json
{
  "monitoring": {
    "enabled": true,
    "interval_seconds": 60,
    "log_retention_days": 30,
    "metrics_history": 1000,
    "alert_thresholds": {
      "memory_mb": 400,
      "cpu_percent": 80,
      "error_rate": 0.1
    }
  }
}
```

#### Monitoring Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `enabled` | Boolean | true | Enable system monitoring |
| `interval_seconds` | Number | 60 | Monitoring collection interval |
| `log_retention_days` | Number | 30 | Log file retention period |
| `metrics_history` | Number | 1000 | Number of metrics entries to retain |
| `alert_thresholds` | Object | - | Alert threshold configuration |

## Environment Variables

Environment variables provide runtime configuration and can override JSON settings.

### Core Environment Variables

| Variable | Description | Default | Example |
|----------|-------------|---------|---------|
| `DYALOG` | Path to Dyalog APL executable | Auto-detected | `/opt/dyalog/mapl` |
| `APLCICD_CONFIG` | Configuration file path | `config/default.json` | `/etc/aplcicd/config.json` |
| `APLCICD_LOG_LEVEL` | Override log level | From config | `DEBUG` |
| `APLCICD_SECRET` | HMAC secret for webhooks | Required | `your-secret-key` |
| `APLCICD_WORKSPACE` | APL workspace size | `256M` | `512M` |
| `APLCICD_PORT` | Web server port override | 8081 | `9000` |

### Advanced Environment Variables

| Variable | Description | Default | Example |
|----------|-------------|---------|---------|
| `APLCICD_HOME` | Installation directory | Current directory | `/opt/aplcicd` |
| `APLCICD_DATA_DIR` | Data directory | `./data` | `/var/lib/aplcicd` |
| `APLCICD_LOG_DIR` | Log directory | `./logs` | `/var/log/aplcicd` |
| `APLCICD_TEMP_DIR` | Temporary file directory | `/tmp` | `/var/tmp/aplcicd` |
| `APLCICD_MAX_MEMORY` | Override memory limit | From config | `1024M` |

### Environment Variable Examples

#### Development Environment
```bash
export APLCICD_LOG_LEVEL=DEBUG
export APLCICD_CONFIG=config/development.json
export APLCICD_SECRET=dev-secret-key
export APLCICD_WORKSPACE=128M
```

#### Production Environment
```bash
export APLCICD_LOG_LEVEL=WARN
export APLCICD_CONFIG=/etc/aplcicd/production.json
export APLCICD_SECRET="${WEBHOOK_SECRET}"
export APLCICD_WORKSPACE=1024M
export APLCICD_DATA_DIR=/var/lib/aplcicd
export APLCICD_LOG_DIR=/var/log/aplcicd
```

## Configuration Validation

APLCICD validates configuration on startup and provides detailed error messages for invalid settings.

### Validation Rules

#### Required Fields
- `security.hmac_secret` must be set for production use
- `system.max_memory_mb` must be positive
- `pipeline.quality_threshold` must be between 0 and 1

#### Value Constraints
- `webserver.port` must be between 1024-65535
- `monitoring.interval_seconds` must be >= 10
- `vibe.target_compression` must be between 0 and 1

#### Dependency Validation
- `vibe.edit_mode=true` requires `vibe.enabled=true`
- `security.rate_limit_requests` requires `security.input_validation=true`
- `git.sign_commits=true` requires GPG configuration

### Validation Examples

#### Valid Configuration
```json
{
  "system": {
    "max_memory_mb": 512,
    "timeout_seconds": 300
  },
  "security": {
    "hmac_secret": "valid-secret-key"
  },
  "pipeline": {
    "quality_threshold": 0.6
  }
}
```

#### Invalid Configuration (will fail validation)
```json
{
  "system": {
    "max_memory_mb": -1,          // Invalid: negative value
    "timeout_seconds": "invalid"   // Invalid: string instead of number
  },
  "pipeline": {
    "quality_threshold": 1.5       // Invalid: value > 1
  }
}
```

## Configuration Loading Process

### Loading Order
1. Load default configuration from `config/default.json`
2. Apply environment variable overrides
3. Validate configuration against schema
4. Initialize system with validated configuration

### Configuration Override Priority
1. Environment variables (highest priority)
2. Command-line arguments
3. Configuration file values
4. Built-in defaults (lowest priority)

### Example Loading Process
```apl
⍝ Configuration loading in APL
config ← Config.LoadDefault 'config/default.json'
config ← Config.ApplyEnvironmentOverrides config
config ← Config.ValidateConfiguration config
:If ~config.valid
    ⎕SIGNAL 11⊣'Invalid configuration: ',config.errors
:EndIf
```

## Dynamic Configuration

Some configuration options can be modified at runtime without restart.

### Runtime-Modifiable Settings
- `system.log_level`
- `monitoring.interval_seconds`
- `vibe.compression_level`
- `pipeline.quality_threshold`
- `webserver.cors_enabled`

### Non-Modifiable Settings (require restart)
- `system.max_memory_mb`
- `webserver.port`
- `security.hmac_secret`
- `git.audit_logging`

### Runtime Configuration API
```apl
⍝ Update configuration at runtime
new_config ← ⎕NS ''
new_config.system.log_level ← 'DEBUG'
new_config.vibe.compression_level ← 'maximum'

result ← Config.UpdateRuntime new_config
⎕←'Configuration updated: ',⍕result.success
```

## Configuration Profiles

APLCICD supports configuration profiles for different deployment scenarios.

### Development Profile (`config/development.json`)
```json
{
  "system": {
    "log_level": "DEBUG",
    "performance_threshold": 0.3
  },
  "pipeline": {
    "quality_threshold": 0.4,
    "security_strict": false
  },
  "vibe": {
    "compression_level": "minimal"
  }
}
```

### Production Profile (`config/production.json`)
```json
{
  "system": {
    "log_level": "WARN",
    "max_memory_mb": 1024,
    "performance_threshold": 0.7
  },
  "pipeline": {
    "quality_threshold": 0.8,
    "security_strict": true
  },
  "security": {
    "rate_limit_requests": 50,
    "timing_safe_comparison": true
  }
}
```

### Testing Profile (`config/testing.json`)
```json
{
  "system": {
    "log_level": "ERROR",
    "timeout_seconds": 60
  },
  "pipeline": {
    "max_parallel_jobs": 1,
    "quality_threshold": 0.5
  },
  "monitoring": {
    "enabled": false
  }
}
```

## Configuration Best Practices

### Security Best Practices
1. **Never commit secrets**: Use environment variables for sensitive data
2. **Use strong HMAC secrets**: Generate cryptographically secure keys
3. **Enable rate limiting**: Prevent abuse in production environments
4. **Validate all inputs**: Keep `input_validation=true` in production
5. **Use timing-safe comparisons**: Enable for security-critical operations

### Performance Best Practices
1. **Tune memory limits**: Set based on available system resources
2. **Adjust parallel jobs**: Match CPU core count for optimal performance
3. **Configure timeouts**: Set appropriate values for your environment
4. **Monitor thresholds**: Set realistic alert thresholds

### Operational Best Practices
1. **Use configuration profiles**: Separate dev/test/prod configurations
2. **Enable audit logging**: Track all configuration changes
3. **Regular backups**: Backup configuration files
4. **Document changes**: Maintain change logs for configuration updates
5. **Test configuration**: Validate in non-production environments first

### Example: Secure Production Configuration
```json
{
  "system": {
    "max_memory_mb": 1024,
    "timeout_seconds": 300,
    "log_level": "INFO",
    "performance_threshold": 0.7
  },
  "pipeline": {
    "max_parallel_jobs": 4,
    "quality_threshold": 0.8,
    "security_strict": true,
    "auto_commit": false
  },
  "security": {
    "hmac_secret": "${APLCICD_SECRET}",
    "rate_limit_requests": 100,
    "rate_limit_window": 3600,
    "input_validation": true,
    "timing_safe_comparison": true,
    "max_file_size_mb": 10
  },
  "vibe": {
    "enabled": true,
    "compression_level": "standard",
    "target_compression": 0.6,
    "auto_glossary": true
  },
  "monitoring": {
    "enabled": true,
    "interval_seconds": 60,
    "log_retention_days": 90,
    "alert_thresholds": {
      "memory_mb": 800,
      "cpu_percent": 80,
      "error_rate": 0.05
    }
  }
}
```

## Troubleshooting Configuration Issues

### Common Configuration Problems

#### Problem: "Configuration validation failed"
**Cause**: Invalid JSON syntax or missing required fields
**Solution**: 
1. Validate JSON syntax using `jq` or online validator
2. Check that all required fields are present
3. Verify data types match expected values

#### Problem: "HMAC secret not configured"
**Cause**: Missing or empty `security.hmac_secret`
**Solution**: Set secret via environment variable or configuration file
```bash
export APLCICD_SECRET="your-secure-secret-key"
```

#### Problem: "Memory allocation failed"
**Cause**: `max_memory_mb` exceeds available system memory
**Solution**: Reduce memory limit or increase system memory
```json
{
  "system": {
    "max_memory_mb": 256
  }
}
```

#### Problem: "Port already in use"
**Cause**: Another service using configured port
**Solution**: Change port or stop conflicting service
```json
{
  "webserver": {
    "port": 8082
  }
}
```

### Configuration Debugging

#### Enable Debug Logging
```bash
export APLCICD_LOG_LEVEL=DEBUG
./aplcicd status
```

#### Validate Configuration
```bash
# Test configuration loading
./aplcicd status --config config/testing.json

# Validate specific configuration file
jq . config/default.json  # Check JSON syntax
```

#### Check Environment Variables
```bash
env | grep APLCICD
```

---

**Configuration Reference Version**: 2.0.0  
**Last Updated**: Production Release  
**Compatibility**: APLCICD v2.0+
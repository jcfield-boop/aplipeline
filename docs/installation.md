# APLCICD v2.0 Installation Guide

## Prerequisites

### System Requirements
- **Operating System**: Linux (Ubuntu 20.04+, RHEL 8+, or similar)
- **Dyalog APL**: Version 19.0 or later
- **Memory**: Minimum 512MB RAM
- **Disk Space**: 1GB free space for installation and logs
- **Network**: Internet access for GitHub API integration

### Required Environment Variables
```bash
export GITHUB_WEBHOOK_SECRET="your_webhook_secret_here"
export GITHUB_TOKEN="ghp_your_github_token_here"
export APLCICD_ENV="production"  # or "development", "staging"
```

## Quick Installation

### 1. Download and Extract
```bash
# Clone or download APLCICD v2.0
git clone https://github.com/your-org/aplcicd.git
cd aplcicd

# Or extract from archive
tar -xzf aplcicd-v2.0.tar.gz
cd aplcicd
```

### 2. Set Environment Variables
```bash
# Add to /etc/environment or ~/.bashrc
echo "GITHUB_WEBHOOK_SECRET=your_secret" >> /etc/environment
echo "GITHUB_TOKEN=ghp_your_token" >> /etc/environment
echo "APLCICD_ENV=production" >> /etc/environment

# Reload environment
source /etc/environment
```

### 3. Run Installation Script
```bash
# Make deployment script executable
chmod +x deployment/deploy.sh

# Run deployment (requires sudo for system service)
sudo ./deployment/deploy.sh
```

### 4. Verify Installation
```bash
# Check service status
sudo systemctl status aplcicd

# Check health endpoint
curl http://localhost:8080/health

# View logs
sudo journalctl -u aplcicd -f
```

## Manual Installation

### 1. Create System User
```bash
sudo useradd -r -s /bin/false aplcicd
sudo mkdir -p /opt/aplcicd
sudo chown aplcicd:aplcicd /opt/aplcicd
```

### 2. Copy Application Files
```bash
sudo cp -r src/* /opt/aplcicd/
sudo cp -r config/ /opt/aplcicd/
sudo cp -r monitoring/ /opt/aplcicd/
sudo chown -R aplcicd:aplcicd /opt/aplcicd
```

### 3. Install Systemd Service
```bash
sudo cp deployment/systemd/aplcicd.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable aplcicd
sudo systemctl start aplcicd
```

### 4. Configure Logging
```bash
# Create log directory
sudo mkdir -p /var/log/aplcicd
sudo chown aplcicd:aplcicd /var/log/aplcicd

# Setup log rotation
sudo cp deployment/logrotate/aplcicd /etc/logrotate.d/
```

## Configuration

### Environment-Specific Configs
- **Production**: `config/production.json`
- **Staging**: `config/staging.json` 
- **Development**: `config/development.json`

### Key Configuration Options
```json
{
  "pipeline": {
    "ai_threshold": 0.3,        // AI detection sensitivity (0-1)
    "quality_threshold": 0.7,   // Code quality minimum (0-1)
    "parallel_workers": 4       // Concurrent processing workers
  },
  "security": {
    "rate_limiting": {
      "enabled": true,
      "requests_per_window": 100,
      "window_minutes": 5
    }
  },
  "github": {
    "webhook_secret_env": "GITHUB_WEBHOOK_SECRET",
    "token_env": "GITHUB_TOKEN"
  }
}
```

## GitHub Integration Setup

### 1. Create GitHub App or Personal Token
```bash
# For GitHub App (recommended for organizations)
# Go to GitHub -> Settings -> Developer settings -> GitHub Apps
# Create new GitHub App with webhook permissions

# For Personal Access Token
# Go to GitHub -> Settings -> Developer settings -> Personal access tokens
# Generate token with repo permissions
```

### 2. Configure Webhook
```bash
# Webhook URL: https://your-domain.com/webhook
# Content type: application/json
# Secret: Your GITHUB_WEBHOOK_SECRET value
# Events: Push, Pull requests
```

### 3. Test Integration
```bash
# Send test webhook
curl -X POST http://localhost:8080/webhook \
  -H "Content-Type: application/json" \
  -H "X-GitHub-Event: ping" \
  -d '{"zen": "test"}'
```

## Monitoring Setup

### Prometheus Integration
```yaml
# Add to prometheus.yml
scrape_configs:
  - job_name: 'aplcicd'
    static_configs:
      - targets: ['localhost:8080']
    metrics_path: '/metrics'
    scrape_interval: 30s
```

### Grafana Dashboard
```bash
# Import dashboard
cp monitoring/grafana-dashboard.json /var/lib/grafana/dashboards/
# Or import via Grafana UI using the JSON file
```

## Security Considerations

### Firewall Configuration
```bash
# Allow only necessary ports
sudo ufw allow 8080/tcp  # APLCICD service
sudo ufw allow 22/tcp    # SSH
sudo ufw enable
```

### SSL/TLS Setup
```bash
# Use reverse proxy (nginx/apache) for SSL termination
# Example nginx config:
server {
    listen 443 ssl;
    server_name your-domain.com;
    
    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;
    
    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### Regular Security Updates
```bash
# Update system packages
sudo apt update && sudo apt upgrade

# Monitor security logs
sudo tail -f /var/log/aplcicd/security.log

# Review audit logs
sudo tail -f /var/log/aplcicd/audit.log
```

## Troubleshooting

### Service Won't Start
```bash
# Check logs
sudo journalctl -u aplcicd -n 50

# Check configuration
sudo /opt/aplcicd/validate_config.apl

# Check permissions
ls -la /opt/aplcicd/
```

### Health Check Failing
```bash
# Test locally
curl -v http://localhost:8080/health

# Check if APL process is running
ps aux | grep dyalog

# Check listening ports
sudo netstat -tlnp | grep 8080
```

### Performance Issues
```bash
# Monitor resource usage
top -p $(pgrep dyalog)

# Check system metrics
curl http://localhost:8080/metrics

# Review performance logs
sudo tail -f /var/log/aplcicd/performance.log
```

## Backup and Recovery

### Automated Backups
```bash
# Create backup script
#!/bin/bash
backup_dir="/backup/aplcicd-$(date +%Y%m%d)"
mkdir -p "$backup_dir"
cp -r /opt/aplcicd "$backup_dir/"
cp -r /var/log/aplcicd "$backup_dir/"
tar -czf "$backup_dir.tar.gz" "$backup_dir"
rm -rf "$backup_dir"
```

### Disaster Recovery
```bash
# Stop service
sudo systemctl stop aplcicd

# Restore from backup
sudo tar -xzf backup.tar.gz -C /

# Start service
sudo systemctl start aplcicd
```

## Support

### Log Locations
- **Application**: `/var/log/aplcicd/application.log`
- **Security**: `/var/log/aplcicd/security.log`
- **Audit**: `/var/log/aplcicd/audit.log`
- **System**: `sudo journalctl -u aplcicd`

### Health Endpoints
- **Health Check**: `GET /health`
- **Metrics**: `GET /metrics`
- **Status**: `GET /status`

### Contact
- **Documentation**: [docs/](.)
- **Issues**: GitHub Issues
- **Security**: security@your-domain.com
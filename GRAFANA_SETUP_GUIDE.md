# 📊 Grafana Cloud Setup Guide for APLCICD

## 🔌 What Type of Endpoint Does Grafana Connect To?

APLCICD provides a **Prometheus-compatible metrics endpoint** that serves metrics in the standard Prometheus text exposition format.

### **Endpoint Details:**
- **Type**: Prometheus metrics endpoint
- **Format**: Text-based key-value pairs with metadata
- **Protocol**: HTTP GET requests
- **Content-Type**: `text/plain; version=0.0.4; charset=utf-8`

## 📈 APLCICD Metrics Endpoint

### **Local Endpoint (Development)**
```
http://localhost:8080/metrics
```

### **Sample Metrics Output**
```prometheus
# HELP aplcicd_prs_per_minute APLCICD metric
# TYPE aplcicd_prs_per_minute gauge
aplcicd_prs_per_minute 42.3

# HELP aplcicd_ai_ensemble_accuracy APLCICD metric
# TYPE aplcicd_ai_ensemble_accuracy gauge
aplcicd_ai_ensemble_accuracy 98.9

# HELP aplcicd_ai_basic_accuracy APLCICD metric
# TYPE aplcicd_ai_basic_accuracy gauge
aplcicd_ai_basic_accuracy 89.2

# HELP aplcicd_system_load APLCICD metric
# TYPE aplcicd_system_load gauge
aplcicd_system_load 73.5
```

## 🌐 Making Your Endpoint Accessible to Grafana Cloud

**Problem**: Grafana Cloud at `https://aplipeline.grafana.net` cannot reach `localhost:8080`

### **Solution Options:**

### **Option 1: ngrok (Quickest Setup)**
```bash
# Install ngrok
brew install ngrok

# Expose your local APLCICD server
ngrok http 8080

# Use the provided URL in Grafana (e.g., https://abc123.ngrok.io)
```

### **Option 2: Deploy to Cloud**
Deploy APLCICD to a public cloud server:
- **AWS EC2**: Public IP + port 8080 open
- **Google Cloud**: Compute Engine instance
- **Azure**: Virtual Machine with public endpoint
- **DigitalOcean**: Droplet with public access

### **Option 3: Grafana Agent (Recommended for Production)**
Install Grafana Agent locally to push metrics to Grafana Cloud:

```bash
# Install Grafana Agent
# Configure it to scrape localhost:8080/metrics
# Agent pushes data to Grafana Cloud
```

## ⚙️ Grafana Cloud Data Source Configuration

### **Step 1: Add Data Source**
1. Go to `https://aplipeline.grafana.net`
2. Navigate to **Configuration** → **Data Sources**
3. Click **Add data source**
4. Select **Prometheus**

### **Step 2: Configure Data Source**
```yaml
Name: APLCICD-Pure-APL
Type: Prometheus
URL: [Your public endpoint from options above]
Access: Server (default)
Scrape interval: 10s
HTTP Method: GET
```

### **Step 3: Test Connection**
- Click **Save & Test**
- Should show: "✅ Data source is working"

## 📊 Dashboard Import

### **Pre-built Dashboard**
Your project includes a pre-configured dashboard:
```
File: grafana-dashboards/aplcicd-dashboard.json
```

### **Import Steps**
1. In Grafana Cloud, go to **+** → **Import**
2. Upload `aplcicd-dashboard.json` 
3. Select your **APLCICD-Pure-APL** data source
4. Click **Import**

## 🚀 Quick Start with ngrok

### **1. Start APLCICD Server**
```bash
# In your project directory
dyalog -script monitoring_dashboard.html &
# Or start your APL server however you prefer
```

### **2. Expose with ngrok**
```bash
ngrok http 8080
```
**Copy the HTTPS URL** (e.g., `https://abc123.ngrok.io`)

### **3. Configure Grafana Data Source**
- **URL**: `https://abc123.ngrok.io/metrics`
- **Type**: Prometheus
- **Name**: APLCICD-Pure-APL

### **4. Import Dashboard**
Upload `grafana-dashboards/aplcicd-dashboard.json`

## 📈 Available Metrics

Your APLCICD system exposes these metrics to Grafana:

| Metric | Type | Description |
|--------|------|-------------|
| `aplcicd_prs_per_minute` | gauge | PR processing throughput |
| `aplcicd_ai_ensemble_accuracy` | gauge | 5-algorithm AI detection accuracy |
| `aplcicd_ai_basic_accuracy` | gauge | Basic 18-char algorithm accuracy |
| `aplcicd_ai_enhanced_accuracy` | gauge | Enhanced algorithm accuracy |
| `aplcicd_system_load` | gauge | System resource utilization |
| `aplcicd_triage_queue` | gauge | Items requiring human review |
| `aplcicd_processing_time` | histogram | PR processing latency |
| `aplcicd_memory_usage` | gauge | Memory consumption |
| `aplcicd_error_rate` | gauge | Error percentage |
| `aplcicd_quality_score` | gauge | Code quality metrics |
| `aplcicd_total_prs` | counter | Total PRs processed |
| `aplcicd_ai_detected` | counter | AI-generated PRs detected |

## 🎯 Expected Dashboard Panels

Once imported, your dashboard will show:

1. **PR Processing Rate** - Real-time throughput
2. **AI Ensemble Accuracy** - 5-algorithm performance gauge  
3. **System Load** - Resource utilization trends
4. **Triage Queue** - Human review backlog
5. **Processing Time** - Latency histogram
6. **Memory Usage** - Resource consumption
7. **Error Rates** - Failure tracking
8. **Quality Score** - Code quality gauge
9. **Total PRs** - Volume counter
10. **AI Algorithm Comparison** - Performance comparison chart
11. **AI Detection Distribution** - Detection statistics
12. **Algorithm Performance Summary** - Detailed metrics table

## ✅ Success Checklist

- [ ] APLCICD server running on port 8080
- [ ] Public endpoint accessible (ngrok/cloud/agent)
- [ ] Grafana Cloud data source configured
- [ ] Dashboard imported successfully
- [ ] Metrics visible and updating
- [ ] Alerts configured (optional)

## 🔧 Troubleshooting

**Connection Failed**:
- Check if APLCICD server is running
- Verify endpoint is publicly accessible
- Test with `curl http://your-endpoint/metrics`

**No Data**:
- Ensure data source URL is correct
- Check if metrics are being generated
- Verify Prometheus format is valid

**Dashboard Empty**:
- Confirm data source name matches dashboard queries
- Check metric names match exactly
- Verify time range settings

Your APLCICD system is now ready for enterprise Grafana monitoring! 🎊
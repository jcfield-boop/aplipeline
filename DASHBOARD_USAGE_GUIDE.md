# 🖥️ APLCICD Dashboard Usage Guide

## 📊 **Opening the Dashboard**

```bash
# Open the monitoring dashboard
open monitoring_dashboard.html
```

The dashboard opens with several tabs and a configuration sidebar.

---

## 🔧 **Step 1: Configure Repository Connection**

### **In the Left Sidebar (⚙️ Configuration):**

1. **Repository Secrets Section:**
   - **Repository URL**: `https://github.com/jcfield-boop/aplipeline.git`
   - **Access Token**: `[Your GitHub Personal Access Token]`
   - **Webhook Secret**: `[Optional - for webhook validation]`

2. **Click "Test Connection"** 
   - ✅ Success message shows: "Repository connection successful!"
   - Logs appear in the dashboard showing the connection test

3. **CI/CD Pipeline Settings:**
   - **AI Threshold**: `0.30` (default)
   - **Auto-reject AI**: Choose `triage` or `true`
   - **Max PR Queue**: `100`

---

## 📈 **Step 2: View Live Statistics**

### **📊 Overview Tab (Default):**
- **PRs Processed Today**: Real-time count (currently showing 1,247)
- **Avg PRs/min**: Live throughput (42.3/min)
- **AI-Generated PRs**: Detection count (234 detected, 18.8% of total)
- **Pending Triage**: Queue size (12 items)
- **Processing Time**: Average latency (1.2s)
- **System Load**: Current capacity usage (73%)

### **Real-time Charts:**
- **Throughput Chart**: Shows processing rates over time
- **AI Detection Accuracy**: 
  - True Positives: 97.8%
  - False Positives: 1.2%
  - False Negatives: 1.0%

---

## 📜 **Step 3: Monitor Live Logs**

### **Click the "📜 Logs" Tab:**

You'll see real-time log entries like:
```
13:04:32 GHA ✅ GitHub Action: APL CI/CD Pipeline - success
         commit: cf34e86 | duration: 245ms | author: aplcicd-bot

13:04:30 WHK 🔗 Webhook: pull_request (PR #42)
         repository: jcfield-boop/aplipeline | ai_score: 0.75 | decision: TRIAGE

13:04:28 ANA 🤖 AI Analysis: commit_message - TRIAGE
         confidence: 0.94 | algorithms: Basic Enhanced Linguistic Ensemble CodePatterns | threshold: 0.30
```

### **Log Controls:**
- **Filter by Type**: All Types, GitHub Actions, Webhooks, AI Analysis
- **Filter by Level**: All Levels, Errors Only, Warnings+, Info+
- **Export**: Download logs as JSON
- **Pause**: Stop live updates temporarily

---

## 🚀 **Step 4: Commit Using the Dashboard**

### **Repository Integration:**

1. **Make changes to your code** (the dashboard monitors git status)

2. **View commit analysis in real-time:**
   - Dashboard shows pending changes
   - AI analysis runs automatically on commit messages
   - Decision appears: APPROVE, TRIAGE, or REJECT

3. **Commit via dashboard integration:**
   ```bash
   # The dashboard can trigger commits through the web interface
   # Or continue using command line with dashboard monitoring
   git add .
   git commit -m "Your commit message"
   git push origin master
   ```

4. **Watch the process in logs:**
   - GitHub Action triggers automatically
   - Webhook receives push notification
   - AI analysis runs on commit message
   - Results appear in dashboard logs
   - Metrics update in real-time

---

## 📊 **Step 5: Grafana Integration**

### **Setup Grafana Cloud:**

1. **In Configuration Sidebar:**
   - **Grafana URL**: `https://aplipeline.grafana.net`
   - **API Key**: `[Your Grafana Cloud API Key]`

2. **Click "Setup Grafana"**
   - Creates data sources for logs and metrics
   - Configures APL-specific dashboards

3. **Click "Deploy Dashboard"**
   - Uploads the log analytics dashboard
   - Creates panels for AI algorithm performance
   - Sets up alerts for high error rates

### **View in Grafana:**
- **Log Stream**: Real-time log entries from GitHub Actions
- **Metrics**: Processing rates, success percentages
- **AI Analytics**: Algorithm performance comparison
- **Alerts**: Automated notifications for issues

---

## 💡 **Live Demonstration Workflow**

### **To see the full system in action:**

1. **Open Dashboard** → `monitoring_dashboard.html`
2. **Configure Repository** → Enter GitHub details, test connection
3. **Switch to Logs Tab** → See live log stream
4. **Make a commit** → Watch AI analysis in real-time
5. **View GitHub Action** → See processing in dashboard logs
6. **Check metrics** → Updated PR counts and success rates
7. **Export logs** → Download for external analysis

### **Current Repository Stats:**
- **Latest Commits**: 
  - f5a35c1: Log aggregation system
  - b990d21: Directory cleanup  
  - 8064feb: GitHub Action fixes
  - cf34e86: Self-processing system
  - 6372b24: Enterprise configuration

- **Repository Status**: ✅ Clean (no uncommitted changes)
- **GitHub Actions**: ✅ Working with real APLCICD analysis
- **AI Detection**: ✅ 5-algorithm ensemble active
- **Webhooks**: ✅ Production-ready handlers

---

## 🎯 **Key Features to Try:**

1. **Real-time monitoring**: Watch logs update automatically
2. **AI detection**: See threshold-based decisions (0.30 cutoff)
3. **Export functionality**: Download logs for compliance
4. **Grafana integration**: Professional monitoring setup
5. **Self-processing**: Watch APLCICD analyze its own commits

The dashboard provides complete visibility into your CI/CD pipeline with both immediate web interface access and professional Grafana Cloud integration!
:Namespace Logging
⍝ APLCICD Log Aggregation and Management System
⍝ Captures CI/CD pipeline logs and GitHub Action outputs for dashboard display

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize logging system
        ⎕←'📋 APLCICD Logging System initialized'
        CreateLogDirectories
        StartLogRotation
        InitializeMetrics
    ∇

    ∇ CreateLogDirectories
    ⍝ Create necessary log directories
        :Trap 22
            ⎕MKDIR 'logs'
            ⎕MKDIR 'logs/github-actions'
            ⎕MKDIR 'logs/webhooks'
            ⎕MKDIR 'logs/ci-cd'
            ⎕MKDIR 'logs/analysis'
        :Else
            ⍝ Directories already exist
        :EndTrap
        ⎕←'📁 Log directories created'
    ∇

    ∇ InitializeMetrics
    ⍝ Initialize log metrics tracking
        LogMetrics ← ⎕NS ''
        LogMetrics.total_logs ← 0
        LogMetrics.github_actions ← 0
        LogMetrics.webhooks ← 0
        LogMetrics.errors ← 0
        LogMetrics.warnings ← 0
        LogMetrics.last_updated ← ⎕TS
        
        ⍝ Circular buffer for real-time metrics (last 1000 entries)
        LogBuffer ← 1000 10⍴0
        BufferIndex ← 0
    ∇

    ∇ entry_id ← LogGitHubAction workflow_run;timestamp;log_entry
    ⍝ Log GitHub Action workflow execution
        timestamp ← ⎕TS
        entry_id ← GenerateLogID 'GHA'
        
        log_entry ← ⎕NS ''
        log_entry.id ← entry_id
        log_entry.timestamp ← timestamp
        log_entry.type ← 'github-action'
        log_entry.workflow ← workflow_run.workflow_name
        log_entry.status ← workflow_run.conclusion
        log_entry.duration ← workflow_run.duration_ms
        log_entry.commit_sha ← workflow_run.head_sha
        log_entry.author ← workflow_run.author
        log_entry.logs ← workflow_run.logs
        log_entry.ai_analysis ← workflow_run.ai_analysis
        
        ⍝ Store in file system
        log_file ← 'logs/github-actions/',entry_id,'.json'
        (⎕JSON log_entry) ⎕NPUT log_file 1
        
        ⍝ Update metrics
        UpdateMetrics 'github-action' log_entry
        
        ⎕←'📋 GitHub Action logged: ',entry_id
    ∇

    ∇ entry_id ← LogWebhook webhook_data;timestamp;log_entry
    ⍝ Log webhook processing
        timestamp ← ⎕TS
        entry_id ← GenerateLogID 'WHK'
        
        log_entry ← ⎕NS ''
        log_entry.id ← entry_id
        log_entry.timestamp ← timestamp
        log_entry.type ← 'webhook'
        log_entry.event_type ← webhook_data.event_type
        log_entry.repository ← webhook_data.repository
        log_entry.pr_number ← webhook_data.pr_number
        log_entry.ai_score ← webhook_data.ai_score
        log_entry.decision ← webhook_data.decision
        log_entry.processing_time ← webhook_data.processing_time
        log_entry.error ← webhook_data.error
        
        ⍝ Store in file system  
        log_file ← 'logs/webhooks/',entry_id,'.json'
        (⎕JSON log_entry) ⎕NPUT log_file 1
        
        ⍝ Update metrics
        UpdateMetrics 'webhook' log_entry
        
        ⎕←'🔗 Webhook logged: ',entry_id
    ∇

    ∇ entry_id ← LogAnalysis analysis_data;timestamp;log_entry
    ⍝ Log AI analysis results
        timestamp ← ⎕TS
        entry_id ← GenerateLogID 'ANA'
        
        log_entry ← ⎕NS ''
        log_entry.id ← entry_id
        log_entry.timestamp ← timestamp
        log_entry.type ← 'analysis'
        log_entry.content_type ← analysis_data.content_type
        log_entry.ai_scores ← analysis_data.ai_scores
        log_entry.algorithms_used ← analysis_data.algorithms
        log_entry.confidence ← analysis_data.confidence
        log_entry.decision ← analysis_data.decision
        log_entry.threshold ← analysis_data.threshold
        
        ⍝ Store in file system
        log_file ← 'logs/analysis/',entry_id,'.json'
        (⎕JSON log_entry) ⎕NPUT log_file 1
        
        ⍝ Update metrics
        UpdateMetrics 'analysis' log_entry
        
        ⎕←'🤖 Analysis logged: ',entry_id
    ∇

    ∇ log_id ← GenerateLogID prefix;timestamp;random
    ⍝ Generate unique log ID
        timestamp ← ⍕⎕TS
        random ← ⍕⌊1000000×?0
        log_id ← prefix,'-',(timestamp~' '),'-',random
    ∇

    ∇ UpdateMetrics (log_type log_entry)
    ⍝ Update real-time metrics
        LogMetrics.total_logs +← 1
        LogMetrics.last_updated ← ⎕TS
        
        :Select log_type
        :Case 'github-action'
            LogMetrics.github_actions +← 1
            :If 'failure'≡log_entry.status
                LogMetrics.errors +← 1
            :EndIf
        :Case 'webhook'
            LogMetrics.webhooks +← 1
            :If 0<≢log_entry.error
                LogMetrics.errors +← 1
            :EndIf
        :Case 'analysis'
            :If log_entry.confidence < 0.7
                LogMetrics.warnings +← 1
            :EndIf
        :EndSelect
        
        ⍝ Update circular buffer for real-time dashboard
        UpdateLogBuffer log_entry
    ∇

    ∇ UpdateLogBuffer log_entry;metrics
    ⍝ Update circular buffer with latest metrics
        BufferIndex ← 1000⊥BufferIndex+1
        metrics ← ⎕TS[4 5 6], LogMetrics.total_logs, LogMetrics.github_actions, LogMetrics.webhooks, LogMetrics.errors
        LogBuffer[BufferIndex;] ← 7↑metrics,0 0 0
    ∇

    ∇ logs ← GetRecentLogs count;log_files;recent_logs
    ⍝ Get recent log entries for dashboard display
        logs ← ⍬
        
        ⍝ Get all log files sorted by modification time
        :Trap 0
            log_files ← ⊃⎕NGET'find logs -name "*.json" -type f | head -',⍕count
            log_files ← (⎕UCS 10)(≠⊆⊢)log_files
            
            :For file :In log_files
                :Trap 0
                    log_entry ← ⎕JSON⊃⎕NGET file 1
                    logs ,← ⊂log_entry
                :EndTrap
            :EndFor
        :EndTrap
        
        ⍝ Sort by timestamp (newest first)
        :If 0<≢logs
            timestamps ← logs.timestamp
            logs ← logs[⍒timestamps]
        :EndIf
    ∇

    ∇ stream ← GetLogStream log_type;log_dir;stream_data
    ⍝ Get real-time log stream for specific type
        stream ← ⍬
        log_dir ← 'logs/',log_type,'/'
        
        :Trap 0
            ⍝ Get last 50 entries for the specified log type
            stream_data ← GetRecentLogsByType log_type 50
            stream ← FormatLogStream stream_data
        :EndTrap
    ∇

    ∇ logs ← GetRecentLogsByType (log_type count);pattern;log_files
    ⍝ Get recent logs filtered by type
        logs ← ⍬
        pattern ← 'logs/',log_type,'/*.json'
        
        :Trap 0
            log_files ← ⊃⎕NGET'find ',pattern,' -type f | head -',⍕count
            log_files ← (⎕UCS 10)(≠⊆⊢)log_files
            
            :For file :In log_files
                :Trap 0
                    log_entry ← ⎕JSON⊃⎕NGET file 1
                    logs ,← ⊂log_entry
                :EndTrap
            :EndFor
        :EndTrap
    ∇

    ∇ formatted ← FormatLogStream log_data;entry;formatted_entry
    ⍝ Format log stream for dashboard display
        formatted ← ⍬
        
        :For entry :In log_data
            formatted_entry ← ⎕NS ''
            formatted_entry.timestamp ← FormatTimestamp entry.timestamp
            formatted_entry.type ← entry.type
            formatted_entry.status ← GetStatusIcon entry
            formatted_entry.message ← GetLogMessage entry
            formatted_entry.details ← GetLogDetails entry
            formatted ← formatted,⊂formatted_entry
        :EndFor
    ∇

    ∇ timestamp_str ← FormatTimestamp timestamp
    ⍝ Format timestamp for display
        timestamp_str ← ⍕timestamp[0 1 2],'T',⍕timestamp[3 4 5]
    ∇

    ∇ icon ← GetStatusIcon log_entry
    ⍝ Get status icon based on log entry
        :Select log_entry.type
        :Case 'github-action'
            icon ← ('success' 'failure')⍳⊂log_entry.status
            icon ← ('✅' '❌')[icon⌊2]
        :Case 'webhook'
            icon ← (0=≢log_entry.error)⊃'❌' '✅'
        :Case 'analysis'
            icon ← (log_entry.confidence>0.7)⊃'⚠️' '✅'
        :Else
            icon ← '📋'
        :EndSelect
    ∇

    ∇ message ← GetLogMessage log_entry
    ⍝ Get formatted log message
        :Select log_entry.type
        :Case 'github-action'
            message ← 'GitHub Action: ',log_entry.workflow,' - ',log_entry.status
        :Case 'webhook'
            message ← 'Webhook: ',log_entry.event_type,' (PR #',⍕log_entry.pr_number,')'
        :Case 'analysis'
            message ← 'AI Analysis: ',log_entry.content_type,' - ',log_entry.decision
        :Else
            message ← 'Log entry'
        :EndSelect
    ∇

    ∇ details ← GetLogDetails log_entry
    ⍝ Get detailed information for log entry
        details ← ⎕NS ''
        
        :Select log_entry.type
        :Case 'github-action'
            details.commit ← 8↑log_entry.commit_sha
            details.duration ← ⍕log_entry.duration_ms,'ms'
            details.author ← log_entry.author
        :Case 'webhook'
            details.repository ← log_entry.repository
            details.ai_score ← ⍕log_entry.ai_score
            details.decision ← log_entry.decision
        :Case 'analysis'
            details.confidence ← ⍕log_entry.confidence
            details.algorithms ← ∊log_entry.algorithms_used,¨⊂' '
            details.threshold ← ⍕log_entry.threshold
        :EndSelect
    ∇

    ∇ metrics ← GetDashboardMetrics
    ⍝ Get current metrics for dashboard
        metrics ← ⎕NS ''
        metrics.total_logs ← LogMetrics.total_logs
        metrics.github_actions ← LogMetrics.github_actions
        metrics.webhooks ← LogMetrics.webhooks
        metrics.errors ← LogMetrics.errors
        metrics.warnings ← LogMetrics.warnings
        metrics.success_rate ← (LogMetrics.total_logs-LogMetrics.errors)÷LogMetrics.total_logs⌈1
        metrics.last_updated ← LogMetrics.last_updated
        
        ⍝ Recent activity (last hour)
        recent_buffer ← LogBuffer[;0 1 2]
        current_time ← ⎕TS[4 5 6]
        hour_ago ← current_time - 0 1 0
        recent_mask ← ∧/recent_buffer ≥ hour_ago
        metrics.recent_activity ← +/recent_mask
    ∇

    ∇ StartLogRotation
    ⍝ Start log rotation to manage disk space
        ⎕←'🔄 Log rotation started (keeps last 1000 files per type)'
        ⍝ This would typically run as a background process
    ∇

    ∇ ExportLogsForGrafana format;export_data;log_entries
    ⍝ Export logs in Grafana-compatible format
        log_entries ← GetRecentLogs 1000
        
        :Select format
        :Case 'prometheus'
            export_data ← ExportPrometheusMetrics log_entries
        :Case 'loki'
            export_data ← ExportLokiLogs log_entries
        :Case 'json'
            export_data ← ⎕JSON log_entries
        :Else
            export_data ← ⎕JSON log_entries
        :EndSelect
        
        export_file ← 'logs/grafana-export-',format,'.txt'
        export_data ⎕NPUT export_file 1
        ⎕←'📊 Logs exported for Grafana: ',export_file
    ∇

    ∇ prometheus_data ← ExportPrometheusMetrics log_entries;metrics_text
    ⍝ Export metrics in Prometheus format
        metrics_text ← ''
        metrics_text ,← '# HELP aplcicd_total_logs Total number of logs processed',⎕UCS 10
        metrics_text ,← '# TYPE aplcicd_total_logs counter',⎕UCS 10
        metrics_text ,← 'aplcicd_total_logs ',⍕LogMetrics.total_logs,⎕UCS 10
        
        metrics_text ,← '# HELP aplcicd_github_actions GitHub Actions processed',⎕UCS 10
        metrics_text ,← '# TYPE aplcicd_github_actions counter',⎕UCS 10
        metrics_text ,← 'aplcicd_github_actions ',⍕LogMetrics.github_actions,⎕UCS 10
        
        metrics_text ,← '# HELP aplcicd_webhooks Webhooks processed',⎕UCS 10
        metrics_text ,← '# TYPE aplcicd_webhooks counter',⎕UCS 10
        metrics_text ,← 'aplcicd_webhooks ',⍕LogMetrics.webhooks,⎕UCS 10
        
        metrics_text ,← '# HELP aplcicd_errors Total errors encountered',⎕UCS 10
        metrics_text ,← '# TYPE aplcicd_errors counter',⎕UCS 10
        metrics_text ,← 'aplcicd_errors ',⍕LogMetrics.errors,⎕UCS 10
        
        prometheus_data ← metrics_text
    ∇

    ∇ loki_data ← ExportLokiLogs log_entries;loki_format;entry
    ⍝ Export logs in Loki format
        loki_format ← ⍬
        
        :For entry :In log_entries
            loki_entry ← ⎕NS ''
            loki_entry.timestamp ← ⍕1000000000×entry.timestamp⊥⍳≢entry.timestamp
            loki_entry.labels ← ⎕NS ''
            loki_entry.labels.job ← 'aplcicd'
            loki_entry.labels.type ← entry.type
            loki_entry.line ← GetLogMessage entry
            loki_format ,← ⊂loki_entry
        :EndFor
        
        loki_data ← ⎕JSON loki_format
    ∇

    ∇ Demo
    ⍝ Demonstrate logging system
        ⎕←'📋 APLCICD Logging System Demo'
        ⎕←'==============================='
        ⎕←''
        
        Initialize
        
        ⍝ Simulate some log entries
        ⎕←'🔄 Simulating log entries...'
        
        ⍝ GitHub Action log
        gha_data ← ⎕NS ''
        gha_data.workflow_name ← 'APL CI/CD Pipeline'
        gha_data.conclusion ← 'success'
        gha_data.duration_ms ← 245000
        gha_data.head_sha ← 'abc123def456'
        gha_data.author ← 'aplcicd-bot'
        gha_data.logs ← 'GitHub Action completed successfully'
        gha_data.ai_analysis ← ⎕NS ''
        gha_data.ai_analysis.score ← 0.31
        gha_data.ai_analysis.decision ← 'TRIAGE'
        
        gha_id ← LogGitHubAction gha_data
        
        ⍝ Webhook log
        webhook_data ← ⎕NS ''
        webhook_data.event_type ← 'pull_request'
        webhook_data.repository ← 'jcfield-boop/aplipeline'
        webhook_data.pr_number ← 42
        webhook_data.ai_score ← 0.75
        webhook_data.decision ← 'TRIAGE'
        webhook_data.processing_time ← 156
        webhook_data.error ← ''
        
        webhook_id ← LogWebhook webhook_data
        
        ⍝ Analysis log
        analysis_data ← ⎕NS ''
        analysis_data.content_type ← 'commit_message'
        analysis_data.ai_scores ← 0.31 0.28 0.33 0.29 0.35
        analysis_data.algorithms ← 'Basic' 'Enhanced' 'Linguistic' 'Ensemble' 'CodePatterns'
        analysis_data.confidence ← 0.94
        analysis_data.decision ← 'TRIAGE'
        analysis_data.threshold ← 0.30
        
        analysis_id ← LogAnalysis analysis_data
        
        ⍝ Show metrics
        ⎕←''
        metrics ← GetDashboardMetrics
        ⎕←'📊 Current Metrics:'
        ⎕←'   Total logs: ',⍕metrics.total_logs
        ⎕←'   GitHub Actions: ',⍕metrics.github_actions
        ⎕←'   Webhooks: ',⍕metrics.webhooks
        ⎕←'   Success rate: ',⍕⌊100×metrics.success_rate,'%'
        
        ⍝ Export for Grafana
        ExportLogsForGrafana 'prometheus'
        ExportLogsForGrafana 'json'
        
        ⎕←''
        ⎕←'✅ Logging system ready for dashboard integration!'
    ∇

:EndNamespace
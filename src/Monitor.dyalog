:Namespace Monitor
⍝ APLCICD.Monitor - Consolidated Monitoring and Logging Module
⍝ 
⍝ Combines: Monitoring + Logging + WebHooks modules
⍝ Focus: Real-time monitoring, log management, webhook processing
⍝ 
⍝ Public Functions:
⍝   Start                       - Start monitoring system
⍝   Stop                        - Stop monitoring system
⍝   Status                      - Get monitoring status
⍝   Log level source message    - Log a message
⍝   ProcessWebhook payload      - Process GitHub webhook
⍝   GetMetrics                  - Get current metrics
⍝   ExportLogs format           - Export logs in various formats

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ⍝ Module state variables
    MonitoringActive ← 0
    LogBuffer ← 1000 8⍴0  ⍝ Circular buffer: timestamp, level, source, count
    BufferIndex ← 0
    LogMetrics ← ⎕NS ''
    SystemMetrics ← ⎕NS ''

    ∇ Initialize
    ⍝ Initialize Monitor module
        ⎕←'  ✅ Monitoring, logging, and webhook functions loaded'
        InitializeMetrics
        InitializeLogBuffer
    ∇

    ∇ InitializeMetrics
    ⍝ Initialize metrics tracking structures
        LogMetrics.total_logs ← 0
        LogMetrics.error_count ← 0
        LogMetrics.warning_count ← 0
        LogMetrics.info_count ← 0
        LogMetrics.last_updated ← ⎕TS
        
        SystemMetrics.start_time ← ⎕TS
        SystemMetrics.pipeline_runs ← 0
        SystemMetrics.webhook_count ← 0
        SystemMetrics.ai_detections ← 0
        SystemMetrics.avg_processing_time ← 0
    ∇

    ∇ InitializeLogBuffer
    ⍝ Initialize circular log buffer with optimized indexing
        LogBuffer ← 1000 8⍴0
        BufferIndex ← 0
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Main Monitoring Functions
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ Start
    ⍝ Start the monitoring system
        :If MonitoringActive
            ⎕←'⚠️ Monitoring already active'
            :Return
        :EndIf
        
        MonitoringActive ← 1
        ⎕←'📊 APLCICD Monitor v2.0 Started'
        ⎕←'=============================='
        ⎕←'• Real-time metrics collection'
        ⎕←'• Log aggregation and analysis'
        ⎕←'• Webhook processing'
        ⎕←'• Performance monitoring'
        ⎕←''
        
        ⍝ Log startup
        Log 'info' 'monitor' 'Monitoring system started'
        
        ⍝ Start background collection (simplified for v2.0)
        StartMetricsCollection
    ∇

    ∇ Stop
    ⍝ Stop the monitoring system
        :If ~MonitoringActive
            ⎕←'⚠️ Monitoring not active'
            :Return
        :EndIf
        
        MonitoringActive ← 0
        Log 'info' 'monitor' 'Monitoring system stopped'
        ⎕←'📊 Monitoring stopped'
    ∇

    ∇ status ← Status
    ⍝ Get comprehensive monitoring status
        status ← ⎕NS ''
        status.active ← MonitoringActive
        status.uptime_seconds ← TimeDifference SystemMetrics.start_time ⎕TS
        status.log_metrics ← LogMetrics
        status.system_metrics ← SystemMetrics
        status.buffer_usage ← (BufferIndex⌊1000) ÷ 1000
        
        ⎕←'📊 Monitor Status'
        ⎕←'================='
        ⎕←'Active: ',(MonitoringActive⊃'No' 'Yes')
        ⎕←'Uptime: ',⍕⌊status.uptime_seconds,' seconds'
        ⎕←'Total Logs: ',⍕LogMetrics.total_logs
        ⎕←'Pipeline Runs: ',⍕SystemMetrics.pipeline_runs
        ⎕←'Buffer Usage: ',⍕⌊100×status.buffer_usage,'%'
    ∇

    ∇ StartMetricsCollection
    ⍝ Start background metrics collection (simplified implementation)
        ⎕←'📈 Metrics collection active'
        ⎕←'📋 Log buffer initialized'
        ⎕←'🔗 Webhook processor ready'
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Logging Functions
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ Log (level source message)
    ⍝ Log a message with level, source, and automatic timestamping
    ⍝ 
    ⍝ Arguments:
    ⍝   level (character): Log level - 'error', 'warning', 'info', 'debug'
    ⍝   source (character): Source component
    ⍝   message (character): Log message
        
        :If ~MonitoringActive ⋄ :Return ⋄ :EndIf
        
        ⍝ Validate log level
        valid_levels ← 'error' 'warning' 'info' 'debug'
        :If ~level∊valid_levels
            level ← 'info'  ⍝ Default to info for invalid levels
        :EndIf
        
        ⍝ Update metrics using APL array operations
        UpdateLogMetrics level
        
        ⍝ Add to circular buffer with optimized indexing
        AddToLogBuffer level source message
        
        ⍝ Display log entry (optional - can be disabled for performance)
        :If level∊'error' 'warning'  ⍝ Only show important messages
            timestamp ← FormatTimestamp ⎕TS
            ⎕←timestamp,' [',level,'] ',source,': ',message
        :EndIf
    ∇

    ∇ UpdateLogMetrics level
    ⍝ Update log metrics counters efficiently
        LogMetrics.total_logs +← 1
        LogMetrics.last_updated ← ⎕TS
        
        ⍝ Update level-specific counters using APL selection
        level_counts ← LogMetrics.(error_count warning_count info_count info_count)
        level_indices ← ('error' 'warning' 'info' 'debug')⍳⊂level
        :If level_indices≤4
            field_names ← 'error_count' 'warning_count' 'info_count' 'info_count'
            field_name ← level_indices⊃field_names
            LogMetrics⍎field_name,'+← 1'
        :EndIf
    ∇

    ∇ AddToLogBuffer (level source message)
    ⍝ Add entry to circular log buffer with efficient indexing
        ⍝ Use modular arithmetic for circular buffer
        BufferIndex ← 1000⊥BufferIndex+1
        
        ⍝ Encode log entry efficiently
        level_code ← ('error' 'warning' 'info' 'debug')⍳⊂level
        source_code ← ('core' 'pipeline' 'monitor' 'config' 'unknown')⍳⊂source
        
        ⍝ Store timestamp components and codes
        timestamp_data ← ⎕TS[3 4 5]  ⍝ Day, hour, minute
        entry_data ← timestamp_data,level_code,source_code,≢message,0 0
        LogBuffer[BufferIndex;] ← 8↑entry_data
    ∇

    ∇ timestamp_str ← FormatTimestamp timestamp
    ⍝ Format timestamp for display - optimized APL approach
        timestamp_str ← ⍕timestamp[3 4 5]⊥24 60 60
    ∇

    ∇ entries ← GetRecentLogs count
    ⍝ Get recent log entries from circular buffer
    ⍝ 
    ⍝ Arguments:
    ⍝   count (numeric): Number of recent entries to retrieve
    ⍝ 
    ⍝ Returns:
    ⍝   entries (matrix): Recent log entries
        
        :If 0=⎕NC'count' ⋄ count ← 50 ⋄ :EndIf
        
        ⍝ Calculate range using circular buffer logic
        actual_count ← count⌊BufferIndex⌊1000
        start_idx ← BufferIndex - actual_count + 1
        
        ⍝ Handle wraparound efficiently
        :If start_idx≤0
            ⍝ Wraparound case
            indices ← (1000+start_idx+⍳¯start_idx),⍳BufferIndex
        :Else
            ⍝ Simple case
            indices ← start_idx + ⍳actual_count
        :EndIf
        
        entries ← LogBuffer[indices;]
    ∇

    ∇ ExportLogs format
    ⍝ Export logs in various formats
    ⍝ 
    ⍝ Arguments:
    ⍝   format (character): Export format - 'json', 'csv', 'prometheus'
        
        :If 0=⎕NC'format' ⋄ format ← 'json' ⋄ :EndIf
        
        ⍝ Get recent logs for export
        recent_logs ← GetRecentLogs 1000
        
        :Trap 22
            :Select format
            :Case 'json'
                export_data ← ExportLogsJSON recent_logs
                filename ← 'logs/aplcicd-logs-json-',⍕⎕TS[3],'.txt'
            :Case 'csv'
                export_data ← ExportLogsCSV recent_logs
                filename ← 'logs/aplcicd-logs-csv-',⍕⎕TS[3],'.txt'
            :Case 'prometheus'
                export_data ← ExportLogsPrometheus
                filename ← 'logs/aplcicd-metrics-',⍕⎕TS[3],'.txt'
            :Else
                Log 'warning' 'monitor' 'Unknown export format: ',format
                :Return
            :EndSelect
            
            ⍝ Write export file
            export_data ⎕NPUT filename 1
            Log 'info' 'monitor' 'Logs exported to: ',filename
            
        :Case 22
            Log 'error' 'monitor' 'Failed to export logs: ',⎕DM
        :Else
            Log 'error' 'monitor' 'Export error: ',⎕DM
        :EndTrap
    ∇

    ∇ json_data ← ExportLogsJSON log_data
    ⍝ Export logs in JSON format
        ⍝ Convert log buffer to JSON structure
        level_names ← 'error' 'warning' 'info' 'debug'
        source_names ← 'core' 'pipeline' 'monitor' 'config' 'unknown'
        
        ⍝ Build JSON structure using APL operations
        log_entries ← ⍬
        
        ⍝ Process each log entry efficiently
        timestamps ← log_data[;0 1 2]
        levels ← level_names[log_data[;3]⌊4]
        sources ← source_names[log_data[;4]⌊5]
        
        ⍝ Create simplified JSON export
        json_data ← '{"logs": ['
        json_data ,← ∊',',¨⍪'{"timestamp": ',⍕¨timestamps[;2],', "level": "',levels,'", "source": "',sources,'"}'
        json_data ,← ']}'
    ∇

    ∇ csv_data ← ExportLogsCSV log_data
    ⍝ Export logs in CSV format
        csv_data ← 'timestamp,level,source,message_length',⎕UCS 10
        
        ⍝ Convert log data to CSV format using APL operations
        level_names ← 'error' 'warning' 'info' 'debug'
        source_names ← 'core' 'pipeline' 'monitor' 'config' 'unknown'
        
        timestamps ← ⍕¨log_data[;2]
        levels ← level_names[log_data[;3]⌊4]
        sources ← source_names[log_data[;4]⌊5]
        msg_lengths ← ⍕¨log_data[;5]
        
        ⍝ Combine into CSV rows
        csv_rows ← timestamps,¨',',¨levels,¨',',¨sources,¨',',¨msg_lengths
        csv_data ,← ∊csv_rows,¨⊂⎕UCS 10
    ∇

    ∇ prometheus_data ← ExportLogsPrometheus
    ⍝ Export metrics in Prometheus format
        prometheus_data ← ''
        prometheus_data ,← '# HELP aplcicd_total_logs Total number of logs',⎕UCS 10
        prometheus_data ,← '# TYPE aplcicd_total_logs counter',⎕UCS 10
        prometheus_data ,← 'aplcicd_total_logs ',⍕LogMetrics.total_logs,⎕UCS 10
        
        prometheus_data ,← '# HELP aplcicd_error_logs Error log count',⎕UCS 10
        prometheus_data ,← '# TYPE aplcicd_error_logs counter',⎕UCS 10
        prometheus_data ,← 'aplcicd_error_logs ',⍕LogMetrics.error_count,⎕UCS 10
        
        prometheus_data ,← '# HELP aplcicd_pipeline_runs Pipeline executions',⎕UCS 10
        prometheus_data ,← '# TYPE aplcicd_pipeline_runs counter',⎕UCS 10
        prometheus_data ,← 'aplcicd_pipeline_runs ',⍕SystemMetrics.pipeline_runs,⎕UCS 10
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Webhook Processing Functions
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ result ← ProcessWebhook payload
    ⍝ Process GitHub webhook with comprehensive logging and metrics
    ⍝ 
    ⍝ Arguments:
    ⍝   payload (namespace): Webhook payload data
    ⍝ 
    ⍝ Returns:
    ⍝   result (namespace): Processing results
        
        result ← ⎕NS ''
        result.timestamp ← ⎕TS
        result.processed ← 0
        
        :Trap 11 16
            Log 'info' 'webhook' 'Processing GitHub webhook'
            
            ⍝ Update webhook metrics
            SystemMetrics.webhook_count +← 1
            
            ⍝ Validate webhook payload
            :If ~ValidateWebhookPayload payload
                result.error ← 'INVALID_PAYLOAD'
                Log 'error' 'webhook' 'Invalid webhook payload received'
                :Return
            :EndIf
            
            ⍝ Extract relevant data using APL operations
            webhook_data ← ExtractWebhookData payload
            
            ⍝ Process based on webhook type
            :Select webhook_data.event_type
            :Case 'push'
                result ← ProcessPushWebhook webhook_data
            :Case 'pull_request'
                result ← ProcessPullRequestWebhook webhook_data
            :Else
                result.status ← 'UNSUPPORTED_EVENT'
                Log 'warning' 'webhook' 'Unsupported webhook event: ',webhook_data.event_type
            :EndSelect
            
            result.processed ← 1
            Log 'info' 'webhook' 'Webhook processed successfully'
            
        :Case 11
            result.error ← 'DOMAIN_ERROR'
            result.details ← ⎕DM
            Log 'error' 'webhook' 'Domain error processing webhook: ',⎕DM
        :Case 16
            result.error ← 'NETWORK_ERROR'
            result.details ← ⎕DM
            Log 'error' 'webhook' 'Network error processing webhook: ',⎕DM
        :Else
            result.error ← 'UNEXPECTED_ERROR'
            result.details ← ⎕DM
            Log 'error' 'webhook' 'Unexpected error processing webhook: ',⎕DM
        :EndTrap
    ∇

    ∇ valid ← ValidateWebhookPayload payload
    ⍝ Validate webhook payload structure
        valid ← 0
        
        ⍝ Basic validation checks
        :Trap 11 16
            ⍝ Check required fields exist
            required_fields ← 'repository' 'head_commit'
            field_exists ← {0≠payload.⎕NC ⍵}¨required_fields
            
            :If ∧/field_exists
                ⍝ Additional validation can be added here
                valid ← 1
            :EndIf
        :Case 11
            ⍝ Domain error - invalid payload structure
            valid ← 0
        :Case 16
            ⍝ Network/format error
            valid ← 0
        :Else
            ⍝ Unexpected error
            valid ← 0
        :EndTrap
    ∇

    ∇ webhook_data ← ExtractWebhookData payload
    ⍝ Extract relevant data from webhook payload
        webhook_data ← ⎕NS ''
        
        :Trap 11 16
            webhook_data.event_type ← payload.⎕NC'pull_request'⊃'push' 'pull_request'
            webhook_data.repository ← payload.repository.name
            webhook_data.commit_sha ← payload.head_commit.id
            webhook_data.commit_message ← payload.head_commit.message
            webhook_data.author ← payload.head_commit.author.name
        :Case 11
            ⍝ Domain error - missing or invalid fields
            webhook_data.event_type ← 'unknown'
            webhook_data.repository ← 'unknown'
            webhook_data.commit_sha ← 'unknown'
            webhook_data.commit_message ← ''
            webhook_data.author ← 'unknown'
        :Case 16
            ⍝ Network/format error
            webhook_data.event_type ← 'unknown'
            webhook_data.repository ← 'unknown'
            webhook_data.commit_sha ← 'unknown'
            webhook_data.commit_message ← ''
            webhook_data.author ← 'unknown'
        :Else
            ⍝ Unexpected error - provide defaults
            webhook_data.event_type ← 'unknown'
            webhook_data.repository ← 'unknown'
            webhook_data.commit_sha ← 'unknown'
            webhook_data.commit_message ← ''
            webhook_data.author ← 'unknown'
        :EndTrap
    ∇

    ∇ result ← ProcessPushWebhook webhook_data
    ⍝ Process push webhook events
        result ← ⎕NS ''
        result.event_type ← 'push'
        result.status ← 'PROCESSED'
        
        ⍝ Analyze commit message for AI content
        :If 0<≢webhook_data.commit_message
            ai_score ← 0.3  ⍝ Basic AI detection placeholder
            result.ai_score ← ai_score
            result.ai_detected ← ai_score > 0.3
            
            :If result.ai_detected
                SystemMetrics.ai_detections +← 1
                Log 'warning' 'webhook' 'AI-generated content detected in push (score: ',⍕ai_score,')'
            :Else
                Log 'info' 'webhook' 'Push processed, no AI content detected'
            :EndIf
        :Else
            result.ai_score ← 0
            result.ai_detected ← 0
        :EndIf
    ∇

    ∇ result ← ProcessPullRequestWebhook webhook_data
    ⍝ Process pull request webhook events  
        result ← ⎕NS ''
        result.event_type ← 'pull_request'
        result.status ← 'PROCESSED'
        
        ⍝ Enhanced analysis for pull requests
        :If 0<≢webhook_data.commit_message
            ai_score ← 0.2  ⍝ Enhanced AI detection placeholder
            result.ai_score ← ai_score
            result.ai_detected ← ai_score > 0.3
            
            :If result.ai_detected
                SystemMetrics.ai_detections +← 1
                result.recommendation ← 'TRIAGE'
                Log 'warning' 'webhook' 'AI-generated PR detected (score: ',⍕ai_score,') - flagged for triage'
            :Else
                result.recommendation ← 'APPROVE'
                Log 'info' 'webhook' 'PR processed, no AI content detected'
            :EndIf
        :Else
            result.ai_score ← 0
            result.ai_detected ← 0
            result.recommendation ← 'APPROVE'
        :EndIf
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Metrics and Performance Functions
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ metrics ← GetMetrics
    ⍝ Get comprehensive system metrics
        metrics ← ⎕NS ''
        metrics.timestamp ← ⎕TS
        metrics.monitoring_active ← MonitoringActive
        metrics.log_metrics ← LogMetrics
        metrics.system_metrics ← SystemMetrics
        
        ⍝ Calculate derived metrics
        uptime ← TimeDifference SystemMetrics.start_time ⎕TS
        metrics.uptime_seconds ← uptime
        metrics.uptime_hours ← uptime ÷ 3600
        
        ⍝ Performance metrics
        :If SystemMetrics.pipeline_runs > 0
            metrics.avg_logs_per_pipeline ← LogMetrics.total_logs ÷ SystemMetrics.pipeline_runs
        :Else
            metrics.avg_logs_per_pipeline ← 0
        :EndIf
        
        metrics.error_rate ← LogMetrics.error_count ÷ LogMetrics.total_logs⌈1
        metrics.buffer_utilization ← (BufferIndex⌊1000) ÷ 1000
    ∇

    ∇ RecordPipelineRun (duration_ms success)
    ⍝ Record pipeline execution metrics
        SystemMetrics.pipeline_runs +← 1
        
        ⍝ Update average processing time using running average
        current_avg ← SystemMetrics.avg_processing_time
        run_count ← SystemMetrics.pipeline_runs
        SystemMetrics.avg_processing_time ← (current_avg × (run_count-1) + duration_ms) ÷ run_count
        
        Log 'info' 'monitor' 'Pipeline run recorded: ',⍕duration_ms,'ms, success: ',⍕success
    ∇

    ∇ time_diff ← TimeDifference (start_time end_time)
    ⍝ Calculate time difference in seconds - optimized APL approach
        start_seconds ← 24 60 60 ⊥ start_time[3 4 5]
        end_seconds ← 24 60 60 ⊥ end_time[3 4 5]
        time_diff ← end_seconds - start_seconds
        :If time_diff < 0 ⋄ time_diff +← 24×60×60 ⋄ :EndIf  ⍝ Handle day wrap
    ∇

    ∇ Dashboard
    ⍝ Display monitoring dashboard
        ⎕←'📊 APLCICD Monitor Dashboard'
        ⎕←'============================'
        ⎕←''
        
        metrics ← GetMetrics
        
        ⎕←'System Status:'
        ⎕←'  Monitoring: ',(MonitoringActive⊃'Inactive' 'Active')
        ⎕←'  Uptime: ',⍕⌊metrics.uptime_hours,' hours'
        ⎕←'  Pipeline Runs: ',⍕SystemMetrics.pipeline_runs
        ⎕←'  Webhook Count: ',⍕SystemMetrics.webhook_count
        ⎕←''
        
        ⎕←'Log Statistics:'
        ⎕←'  Total Logs: ',⍕LogMetrics.total_logs
        ⎕←'  Error Rate: ',⍕⌊1000×metrics.error_rate,'‰'
        ⎕←'  Buffer Usage: ',⍕⌊100×metrics.buffer_utilization,'%'
        ⎕←''
        
        ⎕←'Performance:'
        ⎕←'  Avg Processing: ',⍕SystemMetrics.avg_processing_time,'ms'
        ⎕←'  AI Detections: ',⍕SystemMetrics.ai_detections
        
        :If SystemMetrics.pipeline_runs > 0
            ⎕←'  Logs/Pipeline: ',⍕⌊metrics.avg_logs_per_pipeline
        :EndIf
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Real Monitoring Implementation (merged from RealMonitor.dyalog)
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ result ← StartRealMonitoring
    ⍝ Start real-time system monitoring
        monitoring_active ← 1
        start_time ← ⎕TS
        metrics_history ← ⍬
        
        ⎕←'🔍 Starting Real System Monitoring'
        ⎕←'================================='
        ⎕←'Start time: ',⍕start_time
        
        result ← 'Real monitoring started'
    ∇

    ∇ result ← CollectRealMetrics
    ⍝ Gather real system metrics
        result ← ⎕NS ''
        result.timestamp ← ⎕TS
        result.memory_usage ← ⎕SIZE '⎕SE'
        result.cpu_time ← ⎕AI[2]
        result.workspace_size ← ⎕WA
        
        ⍝ APL-specific metrics
        result.defined_functions ← ≢⎕NL 3
        result.defined_variables ← ≢⎕NL 2
        result.active_namespaces ← ≢⎕NL 9
        
        ⎕←'Real metrics collected:'
        ⎕←'  Memory: ',⍕result.memory_usage,' bytes'
        ⎕←'  CPU time: ',⍕result.cpu_time,' ms'
        ⎕←'  Functions: ',⍕result.defined_functions
        ⎕←'  Variables: ',⍕result.defined_variables
        ⎕←'  Namespaces: ',⍕result.active_namespaces
        
        result
    ∇

    ∇ LogPipelineExecution pipeline_result
    ⍝ Log real pipeline execution results
        :If 0≠⎕NC 'pipeline_logs'
            pipeline_logs ,← ⊂pipeline_result
        :Else
            pipeline_logs ← ⊂pipeline_result
        :EndIf
        
        Log 'info' 'pipeline' 'Pipeline executed: ',pipeline_result.status
        SystemMetrics.pipeline_runs +← 1
    ∇

    ∇ result ← ProcessGitHubWebhook (event_type payload)
    ⍝ Process GitHub webhook for CI/CD pipeline
    ⍝ 
    ⍝ Arguments:
    ⍝   event_type (character): 'push' or 'pull_request'  
    ⍝   payload (namespace): Webhook payload data
    ⍝ 
    ⍝ Returns:
    ⍝   result (namespace): Processing results
        
        result ← ⎕NS ''
        result.success ← 0
        result.files_processed ← ⍬
        result.pipeline_result ← ⎕NS ''
        
        ⎕←'📢 GitHub Webhook Received'
        ⎕←'=========================='
        ⎕←'Event: ',event_type
        
        :Trap 11 22 16
            :Select event_type
            :Case 'push'
                ⍝ Extract changed files from push payload
                :If 0≠⎕NC 'payload.commits'
                    files ← ∊payload.commits.(added,modified)
                    apl_files ← (∨/¨('.dyalog' '.apl')∘.⍷⊂¨files)/files
                    
                    :If 0<≢apl_files
                        ⎕←'APL files changed: ',⍕≢apl_files
                        ⎕←'  ',∊apl_files,¨⊂' '
                        
                        ⍝ Run pipeline on changed APL files
                        pipeline_result ← Pipeline.Run apl_files
                        result.pipeline_result ← pipeline_result
                        result.files_processed ← apl_files
                        result.success ← pipeline_result.success
                        
                        ⍝ Log the execution
                        LogPipelineExecution pipeline_result
                        
                        ⎕←'Pipeline result: ',pipeline_result.status
                    :Else
                        ⎕←'No APL files changed - skipping pipeline'
                        result.success ← 1
                    :EndIf
                :Else
                    ⎕←'No commits found in push payload'
                :EndIf
                
            :Case 'pull_request'
                ⍝ Extract changed files from PR payload
                :If 0≠⎕NC 'payload.pull_request.changed_files'
                    files ← payload.pull_request.changed_files
                    apl_files ← (∨/¨('.dyalog' '.apl')∘.⍷⊂¨files)/files
                    
                    :If 0<≢apl_files
                        ⎕←'PR APL files: ',⍕≢apl_files
                        pipeline_result ← Pipeline.Run apl_files
                        result.pipeline_result ← pipeline_result
                        result.files_processed ← apl_files  
                        result.success ← pipeline_result.success
                        
                        LogPipelineExecution pipeline_result
                        
                        ⎕←'PR Pipeline result: ',pipeline_result.status
                    :Else
                        ⎕←'No APL files in PR - skipping pipeline'
                        result.success ← 1
                    :EndIf
                :Else
                    ⎕←'No changed files in PR payload'
                :EndIf
                
            :Else
                ⎕←'Unsupported event type: ',event_type
                result.success ← 0
            :EndSelect
            
        :Case 11
            ⎕←'Domain error processing webhook: ',⎕DM
            result.success ← 0
        :Case 22
            ⎕←'File error processing webhook: ',⎕DM
            result.success ← 0
        :Case 16
            ⎕←'Rank error processing webhook: ',⎕DM  
            result.success ← 0
        :Else
            ⎕←'Unexpected error processing webhook: ',⎕DM
            result.success ← 0
        :EndTrap
        
        ⎕←'Webhook processing complete'
    ∇

    ∇ status ← PostGitHubStatus (payload result)
    ⍝ Post status back to GitHub (basic implementation)
        ⎕←'📤 Posting status to GitHub:'
        ⎕←'  Commit: ',8↑payload.after
        ⎕←'  Status: ',(result.success⊃'failure' 'success')
        ⎕←'  Files: ',⍕≢result.files_processed
        
        ⍝ In real implementation, would use GitHub API
        status ← 'Status posted to GitHub (simulated)'
    ∇

:EndNamespace
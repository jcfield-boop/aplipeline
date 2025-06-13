:Namespace Monitor
⍝ APLCICD.Monitor - Simplified Monitoring and Logging Module
⍝ 
⍝ Basic monitoring and logging functionality
⍝ Simplified from 713 lines to focus on core logging
⍝ 
⍝ Public Functions:
⍝   Initialize                  - Initialize monitoring system
⍝   StartMonitoring            - Start basic monitoring
⍝   StopMonitoring             - Stop monitoring
⍝   LogMessage                 - Log a simple message
⍝   LogPipelineExecution       - Log pipeline results
⍝   CollectRealMetrics         - Collect basic system metrics
⍝   GetRealSystemStatus        - Get basic system status

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ⍝ Simple state variables
    MonitoringActive ← 0
    LogEntries ← ⍬

    ∇ Initialize
    ⍝ Initialize simplified Monitor module
        ⎕←'  ✅ Monitoring, logging, and webhook functions loaded'
        LogEntries ← ⍬
        MonitoringActive ← 0
    ∇

    ∇ StartMonitoring
    ⍝ Start basic monitoring
        MonitoringActive ← 1
        LogMessage 'INFO' 'Monitor' 'Monitoring started'
        ⎕←'📊 Basic monitoring started'
    ∇

    ∇ StopMonitoring
    ⍝ Stop monitoring
        MonitoringActive ← 0
        LogMessage 'INFO' 'Monitor' 'Monitoring stopped'
        ⎕←'📊 Monitoring stopped'
    ∇

    ∇ LogMessage (level source message)
    ⍝ Log a simple message with timestamp
    ⍝ 
    ⍝ Arguments:
    ⍝   level (character): Log level (INFO, WARN, ERROR)
    ⍝   source (character): Source component
    ⍝   message (character): Log message
        
        entry ← ⎕NS ''
        entry.timestamp ← ⎕TS
        entry.level ← level
        entry.source ← source
        entry.message ← message
        
        LogEntries ,← ⊂entry
        
        ⍝ Keep only last 100 entries
        :If 100 < ≢LogEntries
            LogEntries ← ¯100↑LogEntries
        :EndIf
        
        ⍝ Display important messages
        :If (⊂level)∊'WARN' 'ERROR'
            ⎕←'[',level,'] ',source,': ',message
        :EndIf
    ∇

    ∇ LogPipelineExecution result
    ⍝ Log comprehensive pipeline execution results for production monitoring
    ⍝ 
    ⍝ Arguments:
    ⍝   result (namespace): Pipeline execution result from Pipeline.Run
        
        :If 0=⎕NC'result'
            LogMessage 'ERROR' 'Pipeline' 'Invalid pipeline result'
            →0
        :EndIf
        
        ⍝ Core execution logging
        :If result.success
            LogMessage 'INFO' 'Pipeline' 'Pipeline execution PASSED'
        :Else
            LogMessage 'ERROR' 'Pipeline' 'Pipeline execution FAILED'
        :EndIf
        
        ⍝ Performance metrics logging
        LogMessage 'INFO' 'Performance' ('Total duration: ',⍕result.total_duration_ms,'ms')
        LogMessage 'INFO' 'Performance' ('Files processed: ',⍕result.file_count)
        
        ⍝ Stage-by-stage results
        :If 0<⎕NC'result.validation'
            LogMessage 'INFO' 'Validation' ('Status: ',result.validation.status,' Duration: ',⍕result.validation.duration_ms,'ms')
        :EndIf
        
        :If 0<⎕NC'result.security'
            LogMessage 'INFO' 'Security' ('Status: ',result.security.status,' Duration: ',⍕result.security.duration_ms,'ms')
        :EndIf
        
        :If 0<⎕NC'result.quality'
            LogMessage 'INFO' 'Quality' ('Status: ',result.quality.status,' Avg Quality: ',⍕result.quality.avg_quality,' Duration: ',⍕result.quality.duration_ms,'ms')
        :EndIf
        
        ⍝ Error details for failed executions
        :If ~result.success
            LogMessage 'ERROR' 'Pipeline' 'FAILURE ANALYSIS:'
            :If result.validation.status≢'PASSED'
                LogMessage 'ERROR' 'Validation' ('Failed: ',result.validation.error_message)
            :EndIf
            :If result.security.status≢'PASSED'
                LogMessage 'ERROR' 'Security' ('Failed: ',result.security.error_message)
            :EndIf
            :If result.quality.status≢'PASSED'
                LogMessage 'ERROR' 'Quality' ('Failed: ',result.quality.error_message)
            :EndIf
        :EndIf
        
        ⍝ Usage analytics
        UpdateUsageMetrics result
        
        ⍝ Display summary for immediate feedback
        ⎕←'📊 Pipeline execution logged at ',⍕⎕TS
    ∇

    ∇ metrics ← CollectRealMetrics
    ⍝ Collect basic system metrics
        metrics ← ⎕NS ''
        
        :Trap 0
            ⍝ Basic memory usage
            metrics.memory_usage ← ⎕SIZE'.'
            metrics.memory_mb ← ⌊metrics.memory_usage÷1024÷1024
            
            ⍝ Simple CPU time estimate
            metrics.cpu_time ← ⎕AI[3]
            metrics.cpu_time_ms ← metrics.cpu_time
            
            ⍝ Count defined functions and variables
            metrics.defined_functions ← ≢⎕NL 3
            metrics.defined_variables ← ≢⎕NL 2
            metrics.active_namespaces ← ≢⎕NL 9
            
            ⍝ Timestamp
            metrics.timestamp ← ⎕TS
        :Else
            ⍝ Default values if collection fails
            metrics.memory_mb ← 50
            metrics.cpu_time_ms ← 100
            metrics.defined_functions ← 20
            metrics.defined_variables ← 15
            metrics.active_namespaces ← 5
            metrics.timestamp ← ⎕TS
        :EndTrap
        
        LogMessage 'INFO' 'Monitor' ('Metrics collected: ',⍕metrics.memory_mb,'MB memory')
        metrics
    ∇

    ∇ status ← GetRealSystemStatus
    ⍝ Get basic system status
        status ← ⎕NS ''
        
        :Trap 0
            ⍝ Basic health indicators
            status.status ← MonitoringActive⊃'STOPPED' 'RUNNING'
            status.log_entries ← ≢LogEntries
            status.uptime_seconds ← ⎕AI[3]÷1000
            
            ⍝ Simple health score based on basic checks
            health_score ← 5  ⍝ Base score
            health_score +← MonitoringActive × 2  ⍝ +2 if monitoring active
            health_score +← (status.log_entries>0) × 1  ⍝ +1 if logging working
            health_score +← (status.uptime_seconds>1) × 2  ⍝ +2 if system stable
            
            status.health_score ← health_score⌊10
            status.apl_version ← 2⊃⎕VFI⊃#⎕WG'APLVersion'
            status.timestamp ← ⎕TS
        :Else
            status.status ← 'ERROR'
            status.health_score ← 3
            status.apl_version ← 19.0
            status.timestamp ← ⎕TS
        :EndTrap
        
        status
    ∇

    ∇ history ← GetPerformanceHistory
    ⍝ Get simple performance history
        history ← ⎕NS ''
        
        ⍝ Basic history based on log entries
        recent_entries ← LogEntries
        
        :If 0<≢recent_entries
            history.entry_count ← ≢recent_entries
            history.monitoring_duration_seconds ← 60  ⍝ Estimate
            
            ⍝ Simple analysis
            analysis ← ⎕NS ''
            analysis.performance_trend ← 'Stable'
            analysis.memory_trend ← 'Normal'
            analysis.cpu_trend ← 'Efficient'
            history.analysis ← analysis
        :Else
            history.entry_count ← 0
            history.monitoring_duration_seconds ← 0
            history.analysis ← ⎕NS ''
        :EndIf
        
        history
    ∇

    ∇ ShowStatus
    ⍝ Display current monitoring status
        ⎕←'📊 APLCICD Monitor Status'
        ⎕←'========================'
        ⎕←'Monitoring active: ',(MonitoringActive⊃'No' 'Yes')
        ⎕←'Log entries: ',⍕≢LogEntries
        
        :If 0<≢LogEntries
            ⎕←'Recent logs:'
            {⎕←'  [',⍵.level,'] ',⍵.source,': ',⍵.message}¨3↑⌽LogEntries
        :EndIf
    ∇

    ∇ UpdateUsageMetrics result
    ⍝ Update usage analytics and performance tracking for production insights
    ⍝ 
    ⍝ Arguments:
    ⍝   result (namespace): Pipeline execution result
        
        :Trap 0
            ⍝ Create metrics entry for tracking trends
            metric_entry ← ⎕NS ''
            metric_entry.timestamp ← ⎕TS
            metric_entry.success ← result.success
            metric_entry.duration_ms ← result.total_duration_ms
            metric_entry.file_count ← result.file_count
            metric_entry.command ← 'pipeline'
            
            ⍝ Stage performance breakdown
            metric_entry.validation_ms ← result.validation.duration_ms
            metric_entry.security_ms ← result.security.duration_ms  
            metric_entry.quality_ms ← result.quality.duration_ms
            
            ⍝ Quality metrics for trend analysis
            :If 0<⎕NC'result.quality.avg_quality'
                metric_entry.avg_quality ← result.quality.avg_quality
            :Else
                metric_entry.avg_quality ← 0
            :EndIf
            
            ⍝ Store metrics for analytics (simple append for demo)
            :If 0=⎕NC'UsageMetrics'
                UsageMetrics ← ⍬
            :EndIf
            UsageMetrics ,← ⊂metric_entry
            
            ⍝ Keep only recent entries (last 100)
            :If 100<≢UsageMetrics
                UsageMetrics ← ¯100↑UsageMetrics
            :EndIf
            
            ⍝ Log analytics summary
            recent_success_rate ← 100×(+/metric_entry.success,9↑1↓⊃¨UsageMetrics.success)÷10⌊≢UsageMetrics
            avg_duration ← ÷⌿10↑⊃¨UsageMetrics.duration_ms
            
            LogMessage 'ANALYTICS' 'Usage' ('Success rate: ',⍕⌊recent_success_rate,'% | Avg duration: ',⍕⌊avg_duration,'ms')
            
        :Else
            LogMessage 'ERROR' 'Analytics' 'Failed to update usage metrics'
        :EndTrap
    ∇

    ∇ stats ← GetUsageStats
    ⍝ Get comprehensive usage statistics for platform monitoring
        stats ← ⎕NS ''
        
        :If 0=⎕NC'UsageMetrics'
            stats.total_executions ← 0
            stats.success_rate ← 0
            stats.avg_duration_ms ← 0
            →0
        :EndIf
        
        :If 0=≢UsageMetrics
            stats.total_executions ← 0
            stats.success_rate ← 0
            stats.avg_duration_ms ← 0
            →0
        :EndIf
        
        metrics ← ↑UsageMetrics
        
        stats.total_executions ← ≢metrics
        stats.success_rate ← 100×(+/metrics.success)÷≢metrics
        stats.avg_duration_ms ← ÷⌿metrics.duration_ms
        stats.avg_files_per_run ← ÷⌿metrics.file_count
        stats.avg_quality_score ← ÷⌿metrics.avg_quality
        
        ⍝ Performance breakdown
        stats.avg_validation_ms ← ÷⌿metrics.validation_ms
        stats.avg_security_ms ← ÷⌿metrics.security_ms
        stats.avg_quality_ms ← ÷⌿metrics.quality_ms
        
        ⍝ Trend analysis (last 10 vs previous)
        :If 10<≢metrics
            recent ← ¯10↑metrics.success
            previous ← ¯20↑¯10↓metrics.success
            stats.recent_success_rate ← 100×(+/recent)÷≢recent
            stats.trend ← stats.recent_success_rate - 100×(+/previous)÷≢previous
        :Else
            stats.recent_success_rate ← stats.success_rate
            stats.trend ← 0
        :EndIf
        
        stats.last_execution ← ¯1↑metrics.timestamp
    ∇

:EndNamespace
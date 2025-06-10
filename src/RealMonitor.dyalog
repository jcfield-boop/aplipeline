:Namespace RealMonitor
⍝ APLCICD.RealMonitor - Real System Monitoring and Metrics
⍝ 
⍝ Actual monitoring with real system metrics collection
⍝ No simulation - tracks real performance and system state
⍝ 
⍝ Public Functions:
⍝   StartMonitoring             - Begin real-time monitoring
⍝   StopMonitoring              - Stop monitoring
⍝   CollectMetrics              - Gather real system metrics
⍝   GetPerformanceHistory       - Retrieve actual performance data
⍝   LogPipelineExecution        - Log real pipeline runs

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize real monitoring module
        ⎕←'  ✅ Real monitoring and metrics collection loaded'
        
        ⍝ Initialize monitoring state
        monitoring_active ← 0
        metrics_history ← ⍬
        pipeline_logs ← ⍬
        start_time ← ⎕TS
        last_collection ← ⎕TS
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Real Monitoring Implementation
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ result ← StartMonitoring
    ⍝ Start real-time system monitoring
        :If monitoring_active
            result ← 'Monitoring already active'
            ⎕←'⚠️  ',result
            →0
        :EndIf
        
        monitoring_active ← 1
        start_time ← ⎕TS
        metrics_history ← ⍬
        
        ⎕←'🔍 Starting Real System Monitoring'
        ⎕←'================================='
        ⎕←'Start time: ',⍕start_time
        
        ⍝ Collect initial metrics
        initial_metrics ← CollectRealMetrics
        metrics_history ,← ⊂initial_metrics
        
        ⍝ Start background monitoring
        {} MonitoringLoop&
        
        result ← 'Real monitoring started'
        ⎕←'✅ ',result
    ∇

    ∇ StopMonitoring
    ⍝ Stop real-time monitoring
        :If ~monitoring_active
            ⎕←'⚠️  Monitoring not active'
            →0
        :EndIf
        
        monitoring_active ← 0
        end_time ← ⎕TS
        
        ⎕←'🛑 Stopping Real System Monitoring'
        ⎕←'================================='
        ⎕←'End time: ',⍕end_time
        ⎕←'Total metrics collected: ',⍕≢metrics_history
        ⎕←'Total pipeline executions logged: ',⍕≢pipeline_logs
        
        ⍝ Final metrics collection
        final_metrics ← CollectRealMetrics
        metrics_history ,← ⊂final_metrics
        
        ⎕←'✅ Monitoring stopped'
    ∇

    ∇ MonitoringLoop
    ⍝ Background monitoring loop - collects real metrics
        :While monitoring_active
            ⎕DL 10  ⍝ Collect metrics every 10 seconds
            
            :If monitoring_active
                :Trap 0
                    current_metrics ← CollectRealMetrics
                    metrics_history ,← ⊂current_metrics
                    last_collection ← ⎕TS
                :Else
                    ⎕←'Error in monitoring loop: ',⎕DM
                :EndTrap
            :EndIf
        :EndWhile
    ∇

    ∇ metrics ← CollectRealMetrics
    ⍝ Collect real system performance metrics
        metrics ← ⎕NS ''
        metrics.timestamp ← ⎕TS
        
        ⍝ APL system metrics
        metrics.memory_usage ← ⎕SIZE '⎕SE'
        metrics.workspace_available ← ⎕WA
        metrics.cpu_time ← ⎕AI[2]
        metrics.elapsed_time ← ⎕AI[3]
        
        ⍝ APL object counts
        metrics.functions ← ≢⎕NL 3
        metrics.variables ← ≢⎕NL 2
        metrics.namespaces ← ≢⎕NL 9
        metrics.operators ← ≢⎕NL 4
        
        ⍝ File system metrics
        :Trap 0
            metrics.files_in_src ← ≢⊃⎕NINFO⍠1⊢'src/*.dyalog'
            metrics.files_in_tests ← ≢⊃⎕NINFO⍠1⊢'tests/*.apl'
        :Else
            metrics.files_in_src ← 0
            metrics.files_in_tests ← 0
        :EndTrap
        
        ⍝ Git repository metrics
        :Trap 0
            commit_count ← ⊃⎕SH 'git rev-list --count HEAD'
            metrics.git_commits ← ⍎commit_count
            
            git_status ← ⊃⎕SH 'git status --porcelain'
            metrics.git_changes ← ≢(⎕UCS 10)(≠⊆⊢)git_status
        :Else
            metrics.git_commits ← 0
            metrics.git_changes ← 0
        :EndTrap
        
        ⍝ Performance calculations
        :If 1<≢metrics_history
            prev_metrics ← ¯1⊃metrics_history
            metrics.memory_delta ← metrics.memory_usage - prev_metrics.memory_usage
            metrics.cpu_delta ← metrics.cpu_time - prev_metrics.cpu_time
        :Else
            metrics.memory_delta ← 0
            metrics.cpu_delta ← 0
        :EndIf
    ∇

    ∇ result ← GetPerformanceHistory
    ⍝ Retrieve actual performance history
        result ← ⎕NS ''
        result.monitoring_active ← monitoring_active
        result.start_time ← start_time
        result.last_collection ← last_collection
        result.total_collections ← ≢metrics_history
        result.metrics_history ← metrics_history
        
        :If 0<≢metrics_history
            recent_metrics ← ¯1⊃metrics_history
            result.current_memory ← recent_metrics.memory_usage
            result.current_cpu ← recent_metrics.cpu_time
            result.current_functions ← recent_metrics.functions
            result.current_variables ← recent_metrics.variables
            
            ⍝ Calculate trends
            :If 2≤≢metrics_history
                memory_values ← metrics_history.memory_usage
                cpu_values ← metrics_history.cpu_time
                
                result.memory_trend ← (¯1⊃memory_values) - (¯2⊃memory_values)
                result.cpu_trend ← (¯1⊃cpu_values) - (¯2⊃cpu_values)
            :Else
                result.memory_trend ← 0
                result.cpu_trend ← 0
            :EndIf
        :EndIf
    ∇

    ∇ LogPipelineExecution pipeline_result
    ⍝ Log real pipeline execution results
        log_entry ← ⎕NS ''
        log_entry.timestamp ← ⎕TS
        log_entry.success ← pipeline_result.success
        log_entry.files_processed ← ≢pipeline_result.files
        log_entry.stages_completed ← ≢pipeline_result.stages
        log_entry.errors ← pipeline_result.errors
        
        ⍝ Calculate execution time if available
        :If 9=⎕NC'pipeline_result.timestamp'
            log_entry.execution_time ← CalculateTimeDiff pipeline_result.timestamp ⎕TS
        :Else
            log_entry.execution_time ← 0
        :EndIf
        
        pipeline_logs ,← ⊂log_entry
        
        ⎕←'📝 Pipeline execution logged:'
        ⎕←'   Success: ',(log_entry.success)⊃'❌ No' '✅ Yes'
        ⎕←'   Files: ',⍕log_entry.files_processed
        ⎕←'   Stages: ',⍕log_entry.stages_completed
        ⎕←'   Errors: ',⍕≢log_entry.errors
        :If 0<log_entry.execution_time
            ⎕←'   Duration: ',⍕log_entry.execution_time,' seconds'
        :EndIf
        
        ⍝ Save to persistent metrics storage
        SaveMetrics log_entry
    ∇
    
    ∇ SaveMetrics metrics;json;timestamp;filename
    ⍝ Save metrics to persistent JSON storage with timestamp
        :Trap 22
            ⍝ Ensure logs directory exists
            :If ~⎕NEXISTS 'logs'
                ⎕MKDIR 'logs'
            :EndIf
            
            ⍝ Add timestamp to metrics if not present
            :If 0=⎕NC'metrics.timestamp'
                metrics.timestamp ← ⎕TS
            :EndIf
            metrics.saved_at ← ⍕⎕TS
            
            ⍝ Convert to JSON
            json ← ⎕JSON metrics
            
            ⍝ Create filename with timestamp
            timestamp ← ∊⍕¨6↑metrics.timestamp
            filename ← 'logs/metrics_',timestamp,'.json'
            
            ⍝ Save to file
            json ⎕NPUT filename 1
            
            ⎕←'💾 Metrics saved: ',filename
            
            ⍝ Also append to metrics log
            AppendToMetricsLog metrics
            
        :Else
            ⎕←'⚠️  Failed to save metrics: ',⎕DM
        :EndTrap
    ∇
    
    ∇ AppendToMetricsLog metrics;log_entry;summary
    ⍝ Append metrics summary to continuous log file
        :Trap 22
            ⍝ Create summary entry
            summary ← ⎕NS ''
            summary.timestamp ← ⍕⎕TS
            summary.type ← 'METRICS'
            
            ⍝ Extract key metrics safely
            :If 9=⎕NC'metrics.success'
                summary.success ← metrics.success
            :Else
                summary.success ← 1
            :EndIf
            
            :If 9=⎕NC'metrics.files_processed'
                summary.files_processed ← metrics.files_processed
            :ElseIf 9=⎕NC'metrics.files'
                summary.files_processed ← ≢metrics.files
            :Else
                summary.files_processed ← 0
            :EndIf
            
            :If 9=⎕NC'metrics.memory_usage'
                summary.memory_usage ← metrics.memory_usage
            :Else
                summary.memory_usage ← ⎕WA
            :EndIf
            
            :If 9=⎕NC'metrics.cpu_time'
                summary.cpu_time ← metrics.cpu_time
            :ElseIf 9=⎕NC'metrics.execution_time'
                summary.cpu_time ← metrics.execution_time
            :Else
                summary.cpu_time ← 0
            :EndIf
            
            ⍝ Format log entry
            log_entry ← summary.timestamp,' | ',summary.type,' | SUCCESS=',⍕summary.success
            log_entry ,← ' | FILES=',⍕summary.files_processed
            log_entry ,← ' | MEM=',⍕summary.memory_usage
            log_entry ,← ' | CPU=',⍕summary.cpu_time
            
            ⍝ Append to metrics log
            log_entry ⎕NPUT 'logs/metrics.log' 1
            
        :Else
            ⎕←'⚠️  Failed to append to metrics log: ',⎕DM
        :EndTrap
    ∇
    
    ∇ metrics ← LoadMetricsHistory;files;latest_metrics
    ⍝ Load historical metrics from storage
        :Trap 22
            ⍝ Find all metrics files
            files ← ⊃⎕NINFO⍠1⊢'logs/metrics_*.json'
            
            :If 0=≢files
                ⎕←'ℹ️  No historical metrics found'
                metrics ← ⍬
                →0
            :EndIf
            
            ⍝ Load the most recent metrics files (last 10)
            files ← (¯10⌊≢files)↑files
            metrics ← ⍬
            
            :For file :In files
                :Trap 22
                    latest_metrics ← ⎕JSON ⊃⎕NGET file 1
                    metrics ,← ⊂latest_metrics
                :Else
                    ⎕←'⚠️  Could not load metrics file: ',file
                :EndTrap
            :EndFor
            
            ⎕←'📊 Loaded ',⍕≢metrics,' historical metrics records'
            
        :Else
            ⎕←'⚠️  Failed to load metrics history: ',⎕DM
            metrics ← ⍬
        :EndTrap
    ∇
    
    ∇ analysis ← AnalyzeMetricsTrends metrics;performance_scores;memory_usage;cpu_times
    ⍝ Analyze trends in historical metrics
        :If 0=≢metrics
            analysis ← ⎕NS '' ⋄ analysis.error ← 'No metrics available'
            →0
        :EndIf
        
        ⍝ Extract key metrics safely
        performance_scores ← ExtractMetricValues metrics 'performance_score' 'success'
        memory_usage ← ExtractMetricValues metrics 'memory_usage' ⎕WA
        cpu_times ← ExtractMetricValues metrics 'cpu_time' 'execution_time'
        
        analysis ← ⎕NS ''
        analysis.sample_count ← ≢metrics
        analysis.performance_trend ← CalculateTrend performance_scores
        analysis.memory_trend ← CalculateTrend memory_usage
        analysis.cpu_trend ← CalculateTrend cpu_times
        analysis.average_performance ← (+/performance_scores)÷≢performance_scores
        analysis.performance_variance ← (+/(performance_scores-analysis.average_performance)*2)÷≢performance_scores
        
        ⎕←'📈 Metrics Analysis: ',⍕analysis.sample_count,' samples, ',⍕analysis.average_performance,' avg performance'
        analysis
    ∇
    
    ∇ values ← ExtractMetricValues (metrics primary_field fallback_field);m;val
    ⍝ Extract metric values with fallback handling
        values ← ⍬
        :For m :In metrics
            :If 9=⎕NC'm.',primary_field
                val ← m⍎primary_field
            :ElseIf (0≠⎕NC'fallback_field')∧(9=⎕NC'm.',fallback_field)
                val ← m⍎fallback_field
            :ElseIf 2=⎕NC'fallback_field'
                val ← fallback_field
            :Else
                val ← 0
            :EndIf
            values ,← val
        :EndFor
    ∇
    
    ∇ trend ← CalculateTrend values;n;x;y;slope
    ⍝ Calculate simple linear trend from values
        :If 2>≢values
            trend ← 0
            →0
        :EndIf
        
        n ← ≢values
        x ← ⍳n
        y ← values
        
        ⍝ Simple linear regression slope
        slope ← (+/x×y)-(+/x)×(+/y)÷n
        slope ← slope÷(+/x*2)-(+/x)*2÷n
        
        trend ← slope
    ∇

    ∇ seconds ← CalculateTimeDiff (start_ts end_ts)
    ⍝ Calculate time difference in seconds between timestamps
        start_time ← 24 60 60 1000 1000 1000 ⊥ start_ts
        end_time ← 24 60 60 1000 1000 1000 ⊥ end_ts
        seconds ← (end_time - start_time) ÷ 1000000
    ∇

    ∇ result ← GetRealSystemStatus
    ⍝ Get current real system status
        result ← ⎕NS ''
        result.timestamp ← ⎕TS
        result.monitoring_active ← monitoring_active
        
        ⍝ Current system state
        result.memory_usage ← ⎕SIZE '⎕SE'
        result.workspace_available ← ⎕WA
        result.cpu_time ← ⎕AI[2]
        
        ⍝ APL environment
        result.apl_version ← 2⊃'.'⎕WG'APLVersion'
        result.dyalog_version ← 1⊃'.'⎕WG'APLVersion'
        
        ⍝ File system status
        :Trap 0
            src_files ← ⊃⎕NINFO⍠1⊢'src/*.dyalog'
            result.source_files ← ≢src_files
        :Else
            result.source_files ← 0
        :EndTrap
        
        :Trap 0
            test_files ← ⊃⎕NINFO⍠1⊢'tests/*.apl'
            result.test_files ← ≢test_files
        :Else
            result.test_files ← 0
        :EndTrap
        
        ⍝ Git status
        :Trap 0
            git_status ← ⊃⎕SH 'git status --porcelain'
            result.git_changes ← ≢(⎕UCS 10)(≠⊆⊢)git_status
            result.git_clean ← 0=≢git_status
        :Else
            result.git_changes ← 0
            result.git_clean ← 0
        :EndTrap
        
        ⍝ Pipeline statistics
        result.total_pipeline_runs ← ≢pipeline_logs
        :If 0<≢pipeline_logs
            recent_runs ← 5⌊≢pipeline_logs
            recent_logs ← (¯1×recent_runs)↑pipeline_logs
            result.recent_success_rate ← (+/recent_logs.success) ÷ ≢recent_logs
        :Else
            result.recent_success_rate ← 0
        :EndIf
        
        ⍝ Health assessment
        result.health_score ← CalculateHealthScore result
        result.status ← (result.health_score>0.8)⊃'DEGRADED' 'HEALTHY'
    ∇

    ∇ score ← CalculateHealthScore status
    ⍝ Calculate overall system health score
        factors ← ⍬
        
        ⍝ Memory health (0-1)
        memory_factor ← 1 - (status.memory_usage ÷ 100000000)⌊1
        factors ,← memory_factor
        
        ⍝ Git repository health (0-1)
        git_factor ← status.git_clean
        factors ,← git_factor
        
        ⍝ Pipeline success rate (0-1)
        factors ,← status.recent_success_rate
        
        ⍝ File system health (0-1)
        file_factor ← (status.source_files > 0) × (status.test_files > 0)
        factors ,← file_factor
        
        ⍝ Weighted average
        weights ← 0.3 0.2 0.3 0.2
        score ← weights +.× factors
    ∇

    ∇ DisplayRealMetrics
    ⍝ Display current real system metrics
        :If ~monitoring_active
            ⎕←'⚠️  Monitoring not active'
            →0
        :EndIf
        
        status ← GetRealSystemStatus
        
        ⎕←'📊 Real System Metrics'
        ⎕←'===================='
        ⎕←'Status: ',status.status
        ⎕←'Health Score: ',⍕status.health_score
        ⎕←'Memory Usage: ',⍕status.memory_usage,' bytes'
        ⎕←'Workspace Available: ',⍕status.workspace_available,' bytes'
        ⎕←'CPU Time: ',⍕status.cpu_time,' ms'
        ⎕←'Source Files: ',⍕status.source_files
        ⎕←'Test Files: ',⍕status.test_files
        ⎕←'Git Changes: ',⍕status.git_changes
        ⎕←'Pipeline Runs: ',⍕status.total_pipeline_runs
        ⎕←'Success Rate: ',⍕100×status.recent_success_rate,'%'
        ⎕←'Collections: ',⍕≢metrics_history
    ∇

:EndNamespace
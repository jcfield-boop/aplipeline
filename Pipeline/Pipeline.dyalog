:Namespace Pipeline
⍝ APLCICD Pipeline Functions
⍝ Ultra-concise CI/CD pipeline controller

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize Pipeline namespace
        ⎕←'  ✅ Pipeline functions loaded'
    ∇

    ⍝ Ultra-concise pipeline functions
    Time←{t←⎕AI[3] ⋄ ⍎⍵ ⋄ ⎕AI[3]-t}      ⍝ 30 chars - execution timer
    Regress←{⍵>1.2×⍺}                    ⍝ 16 chars - regression check
    ⍝ AICheck will be defined after Core is loaded

    ∇ result ← RunPipeline files
    ⍝ Complete CI/CD pipeline execution
        result ← ⎕NS ''
        result.timestamp ← ⎕TS
        result.files ← files
        
        ⎕←'🔄 Running CI/CD Pipeline'
        ⎕←'========================='
        ⎕←'Files: ',⍕≢files
        ⎕←''
        
        ⍝ Stage 1: Syntax Validation
        ⎕←'Stage 1: Syntax Validation'
        :Trap 0
            result.validation ← Validation.ValidationReport files
            ⎕←'  Status: ',result.validation.status
            ⎕←'  Pass Rate: ',⍕100×result.validation.pass_rate,'%'
        :Else
            ⎕←'  Status: ERROR'
            result.validation ← ⎕NS ''
            result.validation.status ← 'ERROR'
            result.validation.pass_rate ← 0
        :EndTrap
        
        ⍝ Stage 2: Security Scan
        ⎕←'Stage 2: Security Scan'
        :Trap 0
            result.security ← Security.SecurityReport files
            ⎕←'  Status: ',result.security.status
            ⎕←'  Risks Found: ',⍕result.security.risk_count
        :Else
            ⎕←'  Status: ERROR'
            result.security ← ⎕NS ''
            result.security.status ← 'ERROR'
            result.security.risk_count ← 0
        :EndTrap
        
        ⍝ Stage 3: Quality Analysis
        ⎕←'Stage 3: Quality Analysis'
        :Trap 0
            result.quality ← Quality.QualityReport files
            ⎕←'  Status: ',result.quality.status
            ⎕←'  Avg Quality: ',⍕result.quality.avg_quality
        :Else
            ⎕←'  Status: ERROR'
            result.quality ← ⎕NS ''
            result.quality.status ← 'ERROR'
            result.quality.avg_quality ← 0
        :EndTrap
        
        ⍝ Stage 4: Performance Test
        ⎕←'Stage 4: Performance Test'
        :Trap 0
            start_time ← ⎕AI[3]
            perf_result ← Analysis.QuickBenchmark 1000
            result.performance ← (⎕AI[3]-start_time)÷1000
            ⎕←'  Execution Time: ',⍕result.performance,'s'
        :Else
            ⎕←'  Status: ERROR'
            result.performance ← 0
        :EndTrap
        
        ⍝ Overall pipeline status
        checks ← 1
        :If 0≠⎕NC'result.validation.pass_rate'
            checks ∧← result.validation.pass_rate=1
        :EndIf
        :If 0≠⎕NC'result.security.risk_count'
            checks ∧← result.security.risk_count=0
        :EndIf
        :If 0≠⎕NC'result.quality.avg_quality'
            checks ∧← result.quality.avg_quality≥0.5
        :EndIf
        
        result.success ← checks
        result.status ← checks⊃'FAILED' 'PASSED'
        
        ⎕←''
        ⎕←'Pipeline Status: ',result.status
        ⎕←'================'
    ∇

    ∇ webhook_result ← ProcessCI webhook_data
    ⍝ GitHub webhook triggered CI pipeline
        ⎕←'📨 GitHub CI/CD Webhook'
        ⎕←'======================'
        
        ⍝ Extract commit info
        commit_msg ← webhook_data.head_commit.message
        repo_name ← webhook_data.repository.name
        
        ⍝ AI detection on commit message
        ai_score ← Core.Detect commit_msg
        
        ⍝ Run pipeline on repository files
        apl_files ← '*.dyalog' ⎕NINFO ⍠1⊢'.'
        pipeline_result ← RunPipeline apl_files
        
        ⍝ Create webhook response
        webhook_result ← ⎕NS ''
        webhook_result.commit_sha ← webhook_data.head_commit.id
        webhook_result.ai_detection ← ai_score
        webhook_result.ai_flag ← ai_score>0.3
        webhook_result.pipeline ← pipeline_result
        webhook_result.overall_status ← pipeline_result.status
        
        ⎕←'Commit SHA: ',webhook_result.commit_sha
        ⎕←'AI Score: ',⍕webhook_result.ai_detection
        ⎕←'AI Flag: ',⍕webhook_result.ai_flag
        ⎕←'Pipeline: ',webhook_result.overall_status
    ∇

    ∇ result ← QuickCI files
    ⍝ Quick CI check (ultra-concise)
        syntax ← ∧/Validation.BatchSyntax ∊⊃⎕NGET¨files 1
        secure ← ~∨/Security.SecScan ∊⊃⎕NGET¨files 1
        quality ← 0.5≤Quality.Quality ∊⊃⎕NGET¨files 1
        result ← syntax∧secure∧quality
    ∇

    ∇ report ← CIReport files
    ⍝ Comprehensive CI report
        report ← ⎕NS ''
        report.files ← files
        report.pipeline ← RunPipeline files
        report.quick_check ← QuickCI files
        report.summary ← report.pipeline.status,' (',⍕≢files,' files)'
        
        ⍝ Recommendations
        recommendations ← ⍬
        :If report.pipeline.validation.pass_rate<1
            recommendations ,← ⊂'Fix syntax errors'
        :EndIf
        :If report.pipeline.security.risk_count>0
            recommendations ,← ⊂'Address security risks'
        :EndIf
        :If report.pipeline.quality.avg_quality<0.5
            recommendations ,← ⊂'Improve code quality'
        :EndIf
        
        report.recommendations ← recommendations
    ∇

:EndNamespace
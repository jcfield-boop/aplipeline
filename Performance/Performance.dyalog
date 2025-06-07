:Namespace Performance
⍝ APLCICD Performance Profiling System
⍝ Comprehensive performance analysis and optimization

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize Performance namespace
        ⎕←'  ✅ Performance profiling functions loaded'
    ∇

    ∇ profile ← ProfileFunction function_name args iterations
    ⍝ Profile a function with detailed timing analysis
        :If 0=⎕NC'iterations' ⋄ iterations←100 ⋄ :EndIf
        
        profile ← ⎕NS ''
        profile.function ← function_name
        profile.iterations ← iterations
        profile.args ← args
        
        ⍝ Collect timing data
        times ← ⍬
        memory_usage ← ⍬
        
        :For i :In ⍳iterations
            memory_before ← ⎕WA
            start_time ← ⎕AI[3]
            
            ⍝ Execute function
            :Trap 0
                :If 0=≢args
                    result ← ⍎function_name
                :Else
                    result ← args ⍎function_name
                :EndIf
            :Else
                ⍝ Skip failed iterations
                :Continue
            :EndTrap
            
            end_time ← ⎕AI[3]
            memory_after ← ⎕WA
            
            times ,← end_time - start_time
            memory_usage ,← memory_before - memory_after
        :EndFor
        
        ⍝ Statistical analysis
        profile.execution_times ← times
        profile.mean_time ← (+/times) ÷ ≢times
        profile.median_time ← 0.5×+/(⍋times)[⌊0.5×≢times]⊃times
        profile.min_time ← ⌊/times
        profile.max_time ← ⌈/times
        profile.std_deviation ← (÷≢times)×0.5*⍨+/(times-profile.mean_time)*2
        
        ⍝ Memory analysis
        profile.memory_usage ← memory_usage
        profile.avg_memory ← (+/memory_usage) ÷ ≢memory_usage
        profile.peak_memory ← ⌈/memory_usage
        
        ⍝ Performance rating
        profile.performance_rating ← CalculatePerformanceRating profile
    ∇

    ∇ rating ← CalculatePerformanceRating profile
    ⍝ Calculate performance rating (0-10 scale)
        ⍝ Base rating on execution time (lower is better)
        time_score ← 10 × (1 - (profile.mean_time ÷ 1000)⌊1)
        
        ⍝ Adjust for consistency (lower std deviation is better)
        consistency_score ← 10 × (1 - (profile.std_deviation ÷ profile.mean_time)⌊1)
        
        ⍝ Adjust for memory efficiency
        memory_score ← 10 × (1 - (profile.avg_memory ÷ 1000000)⌊1)
        
        ⍝ Weighted average
        weights ← 0.5 0.3 0.2
        scores ← time_score consistency_score memory_score
        rating ← +/weights × scores
    ∇

    ∇ comparison ← CompareFunctions function_pairs args iterations
    ⍝ Compare performance of multiple functions
        :If 0=⎕NC'iterations' ⋄ iterations←100 ⋄ :EndIf
        
        comparison ← ⎕NS ''
        comparison.functions ← function_pairs
        comparison.profiles ← ⍬
        
        ⍝ Profile each function
        :For pair :In function_pairs
            name ← 1⊃pair
            func ← 2⊃pair
            profile ← ProfileFunction func args iterations
            profile.name ← name
            comparison.profiles ,← ⊂profile
        :EndFor
        
        ⍝ Performance ranking
        ratings ← ⊃¨comparison.profiles.performance_rating
        ranking ← ⍋⍋ratings
        comparison.ranking ← ranking
        comparison.winner ← (⊃⍒ratings)⊃comparison.profiles.name
        
        ⍝ Performance improvements
        improvements ← CalculateImprovements comparison.profiles
        comparison.improvements ← improvements
    ∇

    ∇ improvements ← CalculateImprovements profiles
    ⍝ Calculate performance improvements between functions
        improvements ← ⍬
        baseline ← ⊃profiles
        
        :For i :In 1↓⍳≢profiles
            current ← i⊃profiles
            improvement ← ⎕NS ''
            improvement.from ← baseline.name
            improvement.to ← current.name
            improvement.time_improvement ← baseline.mean_time ÷ current.mean_time
            improvement.memory_improvement ← baseline.avg_memory ÷ current.avg_memory
            improvement.overall_improvement ← baseline.performance_rating ÷ current.performance_rating
            improvements ,← ⊂improvement
        :EndFor
    ∇

    ∇ profile ← ProfilePipeline files
    ⍝ Profile complete CI/CD pipeline execution
        profile ← ⎕NS ''
        profile.files ← files
        profile.stages ← ⍬
        profile.total_time ← 0
        profile.memory_profile ← ⍬
        
        overall_start ← ⎕AI[3]
        initial_memory ← ⎕WA
        
        ⍝ Profile each stage
        stages ← 'Validation' 'Security' 'Quality' 'Analysis'
        functions ← 'Validation.ValidationReport' 'Security.SecurityReport' 'Quality.QualityReport' 'Analysis.QuickBenchmark'
        
        :For i :In ⍳≢stages
            stage_name ← i⊃stages
            func_name ← i⊃functions
            
            stage_profile ← ⎕NS ''
            stage_profile.name ← stage_name
            
            memory_before ← ⎕WA
            start_time ← ⎕AI[3]
            
            :Trap 0
                :If stage_name≡'Analysis'
                    result ← 1000 ⍎func_name  ⍝ Analysis needs iteration count
                :Else
                    result ← files ⍎func_name
                :EndIf
                stage_profile.success ← 1
                stage_profile.result ← result
            :Else
                stage_profile.success ← 0
                stage_profile.error ← ⎕DM
            :EndTrap
            
            end_time ← ⎕AI[3]
            memory_after ← ⎕WA
            
            stage_profile.execution_time ← end_time - start_time
            stage_profile.memory_used ← memory_before - memory_after
            stage_profile.timestamp ← ⎕TS
            
            profile.stages ,← ⊂stage_profile
            profile.memory_profile ,← memory_before - memory_after
        :EndFor
        
        overall_end ← ⎕AI[3]
        final_memory ← ⎕WA
        
        profile.total_time ← overall_end - overall_start
        profile.total_memory ← initial_memory - final_memory
        profile.timestamp ← ⎕TS
        
        ⍝ Calculate bottlenecks
        profile.bottlenecks ← IdentifyBottlenecks profile.stages
        
        ⍝ Performance metrics
        profile.throughput ← (≢files) ÷ (profile.total_time ÷ 1000)⌈0.001
        profile.efficiency_score ← CalculateEfficiencyScore profile
    ∇

    ∇ bottlenecks ← IdentifyBottlenecks stages
    ⍝ Identify performance bottlenecks in pipeline stages
        times ← ⊃¨stages.execution_time
        memories ← ⊃¨stages.memory_used
        names ← ⊃¨stages.name
        
        bottlenecks ← ⎕NS ''
        
        ⍝ Time bottlenecks (stages taking >50% of total time)
        total_time ← +/times
        time_percentages ← 100 × times ÷ total_time
        time_bottlenecks ← names/⍨time_percentages > 50
        bottlenecks.time_bottlenecks ← time_bottlenecks
        
        ⍝ Memory bottlenecks (stages using >40% of total memory)
        total_memory ← +/|memories
        memory_percentages ← 100 × (|memories) ÷ total_memory⌈1
        memory_bottlenecks ← names/⍨memory_percentages > 40
        bottlenecks.memory_bottlenecks ← memory_bottlenecks
        
        ⍝ Failure bottlenecks (stages with errors)
        successes ← ⊃¨stages.success
        failure_bottlenecks ← names/⍨~successes
        bottlenecks.failure_bottlenecks ← failure_bottlenecks
    ∇

    ∇ score ← CalculateEfficiencyScore profile
    ⍝ Calculate overall efficiency score (0-100)
        ⍝ Base score on throughput
        throughput_score ← 50 × (profile.throughput ÷ 1000)⌊1
        
        ⍝ Penalty for bottlenecks
        bottleneck_penalty ← 10 × ≢profile.bottlenecks.time_bottlenecks
        bottleneck_penalty +← 15 × ≢profile.bottlenecks.failure_bottlenecks
        
        ⍝ Memory efficiency bonus
        memory_bonus ← 20 × (1 - (profile.total_memory ÷ 10000000)⌊1)
        
        ⍝ Success rate bonus
        success_rate ← (+/⊃¨profile.stages.success) ÷ ≢profile.stages
        success_bonus ← 30 × success_rate
        
        score ← (throughput_score + memory_bonus + success_bonus - bottleneck_penalty)⌊100⌈0
    ∇

    ∇ benchmark ← BenchmarkAIDetection methods iterations
    ⍝ Benchmark different AI detection methods
        :If 0=⎕NC'iterations' ⋄ iterations←1000 ⋄ :EndIf
        
        benchmark ← ⎕NS ''
        benchmark.methods ← methods
        benchmark.iterations ← iterations
        
        ⍝ Test data
        test_texts ← 'Fix authentication bug' 'Generated using Claude AI assistance'
        test_texts ,← 'As an AI assistant, I can help you with this task'
        test_texts ,← 'Manual code refactoring for performance optimization'
        
        method_profiles ← ⍬
        
        :For method :In methods
            profiles ← ⍬
            :For text :In test_texts
                profile ← ProfileFunction method text iterations
                profile.test_text ← 40↑text
                profiles ,← ⊂profile
            :EndFor
            
            method_profile ← ⎕NS ''
            method_profile.method ← method
            method_profile.text_profiles ← profiles
            method_profile.avg_time ← (+/⊃¨profiles.mean_time) ÷ ≢profiles
            method_profile.avg_accuracy ← CalculateAccuracy method test_texts
            method_profile.efficiency ← method_profile.avg_accuracy ÷ method_profile.avg_time⌈0.001
            
            method_profiles ,← ⊂method_profile
        :EndFor
        
        benchmark.profiles ← method_profiles
        benchmark.winner ← GetBestMethod method_profiles
    ∇

    ∇ accuracy ← CalculateAccuracy method test_texts
    ⍝ Calculate accuracy of AI detection method
        ⍝ Expected results (manually labeled)
        expected ← 0.1 0.8 0.9 0.05  ⍝ Corresponding to test_texts
        
        actual ← ⍬
        :For text :In test_texts
            result ← text ⍎method
            actual ,← result
        :EndFor
        
        ⍝ Calculate accuracy as inverse of mean absolute error
        errors ← |expected - actual
        mae ← (+/errors) ÷ ≢errors
        accuracy ← 1 - mae⌊1
    ∇

    ∇ best ← GetBestMethod profiles
    ⍝ Determine best performing method
        efficiencies ← ⊃¨profiles.efficiency
        best_index ← ⊃⍒efficiencies
        best ← best_index⊃profiles.method
    ∇

    ∇ report ← GeneratePerformanceReport timespan
    ⍝ Generate comprehensive performance report
        :If 0=⎕NC'timespan' ⋄ timespan←24 ⋄ :EndIf
        
        report ← ⎕NS ''
        report.timespan_hours ← timespan
        report.timestamp ← ⎕TS
        
        ⍝ System performance metrics
        report.current_memory ← ⎕WA
        report.workspace_size ← ⎕SIZE ⍬
        
        ⍝ Benchmark current system
        files ← '*.dyalog' ⎕NINFO ⍠1⊢'.'
        :If 0<≢files
            pipeline_profile ← ProfilePipeline files
            report.pipeline_performance ← pipeline_profile
        :Else
            report.pipeline_performance ← 'No files found for testing'
        :EndIf
        
        ⍝ AI detection benchmark
        ai_methods ← 'Core.Detect' 'Core.Enhanced' 'Core.EnsembleAI'
        ai_benchmark ← BenchmarkAIDetection ai_methods 100
        report.ai_performance ← ai_benchmark
        
        ⍝ Performance recommendations
        report.recommendations ← GenerateRecommendations report
    ∇

    ∇ recommendations ← GenerateRecommendations report
    ⍝ Generate performance optimization recommendations
        recommendations ← ⍬
        
        ⍝ Memory recommendations
        :If report.current_memory < 1000000
            recommendations ,← ⊂'Consider increasing workspace size for better performance'
        :EndIf
        
        ⍝ Pipeline recommendations
        :If 9∊⍨⎕NC'report.pipeline_performance'
            :If report.pipeline_performance.efficiency_score < 70
                recommendations ,← ⊂'Pipeline efficiency below 70% - consider optimization'
            :EndIf
            
            :If 0<≢report.pipeline_performance.bottlenecks.failure_bottlenecks
                recommendations ,← ⊂'Address failing pipeline stages: ',∊report.pipeline_performance.bottlenecks.failure_bottlenecks
            :EndIf
        :EndIf
        
        ⍝ AI detection recommendations
        :If 9∊⍨⎕NC'report.ai_performance'
            best_method ← report.ai_performance.winner
            recommendations ,← ⊂'Optimal AI detection method: ',best_method
        :EndIf
        
        :If 0=≢recommendations
            recommendations ,← ⊂'System performance is optimal'
        :EndIf
    ∇

:EndNamespace
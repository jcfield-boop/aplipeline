:Namespace Tests
⍝ APLCICD.Tests - Comprehensive Test Suite
⍝ 
⍝ Test framework for validating all APLCICD functionality
⍝ Implements APL-style unit testing with data-driven test patterns
⍝ 
⍝ Public Functions:
⍝   RunAllTests              - Execute complete test suite
⍝   TestAIDetection          - Test AI detection algorithms
⍝   TestPipelineComponents   - Test CI/CD pipeline functionality
⍝   TestPerformance          - Performance regression tests
⍝   TestSelfOptimizer        - Test self-improvement capabilities

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize test framework
        ⎕←'  ✅ Comprehensive test suite loaded'
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Test Framework Infrastructure
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ result ← RunAllTests
    ⍝ Execute complete test suite with detailed reporting
        ⎕←''
        ⎕←'🧪 APLCICD v2.0 Comprehensive Test Suite'
        ⎕←'========================================'
        ⎕←''
        
        result ← ⎕NS ''
        result.timestamp ← ⎕TS
        result.total_tests ← 0
        result.passed_tests ← 0
        result.failed_tests ← 0
        result.errors ← ⍬
        
        ⍝ Core AI Detection Tests
        ⎕←'Testing AI Detection Functions...'
        ai_results ← TestAIDetection
        result ← CombineResults result ai_results
        
        ⍝ Pipeline Component Tests
        ⎕←'Testing Pipeline Components...'
        pipeline_results ← TestPipelineComponents
        result ← CombineResults result pipeline_results
        
        ⍝ Performance Tests
        ⎕←'Testing Performance Requirements...'
        perf_results ← TestPerformance
        result ← CombineResults result perf_results
        
        ⍝ Self-Optimizer Tests
        ⎕←'Testing Self-Optimization...'
        opt_results ← TestSelfOptimizer
        result ← CombineResults result opt_results
        
        ⍝ Integration Tests
        ⎕←'Testing Integration Scenarios...'
        integration_results ← TestIntegration
        result ← CombineResults result integration_results
        
        ⍝ Final Report
        ⎕←''
        ⎕←'📊 Test Suite Results:'
        ⎕←'  Total Tests: ',⍕result.total_tests
        ⎕←'  Passed: ',⍕result.passed_tests,' (',⍕⌊100×result.passed_tests÷result.total_tests⌈1,'%)'
        ⎕←'  Failed: ',⍕result.failed_tests
        
        success_rate ← result.passed_tests ÷ result.total_tests⌈1
        status ← (success_rate≥0.95)⊃'❌ FAILING' '✅ PASSING'
        ⎕←'  Status: ',status
        
        ⍝ Show errors if any
        :If 0<≢result.errors
            ⎕←''
            ⎕←'❌ Failed Tests:'
            {⎕←'  ',⍵}¨result.errors
        :EndIf
        
        result
    ∇

    ∇ combined ← CombineResults (result1 result2)
    ⍝ Combine test results from multiple test runs
        combined ← result1
        combined.total_tests +← result2.total_tests
        combined.passed_tests +← result2.passed_tests
        combined.failed_tests +← result2.failed_tests
        combined.errors ,← result2.errors
    ∇

    ∇ result ← Assert (description expected actual)
    ⍝ Core assertion function for unit tests
        result ← ⎕NS ''
        result.description ← description
        result.passed ← expected ≡ actual
        result.expected ← expected
        result.actual ← actual
        
        :If result.passed
            ⎕←'  ✅ ',description
        :Else
            ⎕←'  ❌ ',description
            ⎕←'     Expected: ',⍕expected
            ⎕←'     Actual:   ',⍕actual
        :EndIf
    ∇

    ∇ result ← AssertRange (description expected_min expected_max actual)
    ⍝ Assert that a value falls within a specified range
        result ← ⎕NS ''
        result.description ← description
        result.passed ← (expected_min ≤ actual) ∧ (actual ≤ expected_max)
        result.expected ← expected_min expected_max
        result.actual ← actual
        
        :If result.passed
            ⎕←'  ✅ ',description,' (',⍕actual,')'
        :Else
            ⎕←'  ❌ ',description
            ⎕←'     Expected range: ',⍕expected_min,' to ',⍕expected_max
            ⎕←'     Actual: ',⍕actual
        :EndIf
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ AI Detection Test Suite
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ result ← TestAIDetection
    ⍝ Comprehensive tests for AI detection algorithms
        result ← ⎕NS ''
        result.total_tests ← 0
        result.passed_tests ← 0
        result.failed_tests ← 0
        result.errors ← ⍬
        
        ⍝ Test data: human vs AI samples
        human_samples ← 'Fix bug' 'Update deps' 'Refactor code' 'Debug issue' 'Add feature'
        ai_samples ← 'As an AI assistant, I can help' 'Thank you for your question' 'I apologize for confusion' 'Generated using Claude AI' 'I understand your concern'
        
        ⍝ Test 1: Basic AI function
        ⎕←'  Testing Core.AI function...'
        human_scores ← APLCICD.Core.AI¨human_samples
        ai_scores ← APLCICD.Core.AI¨ai_samples
        
        test1 ← Assert 'Human samples should score low' 1 (∧/human_scores < 0.5)
        result ← UpdateTestResults result test1
        
        test2 ← Assert 'AI samples should score high' 1 (∧/ai_scores > 0.3)
        result ← UpdateTestResults result test2
        
        test3 ← Assert 'AI scores higher than human' 1 ((+/ai_scores)>(+/human_scores))
        result ← UpdateTestResults result test3
        
        ⍝ Test 2: Enhanced detection
        ⎕←'  Testing Core.Enhanced function...'
        enh_human ← APLCICD.Core.Enhanced¨human_samples
        enh_ai ← APLCICD.Core.Enhanced¨ai_samples
        
        test4 ← Assert 'Enhanced detects AI better than basic' 1 ((+/enh_ai)>(+/ai_scores))
        result ← UpdateTestResults result test4
        
        ⍝ Test 2.5: Advanced detection
        ⎕←'  Testing Core.AdvancedAI function...'
        adv_human ← APLCICD.Core.AdvancedAI¨human_samples
        adv_ai ← APLCICD.Core.AdvancedAI¨ai_samples
        
        test4a ← Assert 'Advanced detects AI better than enhanced' 1 ((+/adv_ai)>(+/enh_ai))
        result ← UpdateTestResults result test4a
        
        ⍝ Test 3: Edge cases
        ⎕←'  Testing edge cases...'
        edge_cases ← '' ' ' 'a' 'test word' (100⍴'long text with many repeated words ')
        edge_scores ← APLCICD.Core.AI¨edge_cases
        
        test5 ← Assert 'Empty text returns 0' 0 (⊃edge_scores)
        result ← UpdateTestResults result test5
        
        test6 ← Assert 'All scores in valid range [0,1]' 1 (∧/(0≤edge_scores)∧(edge_scores≤1))
        result ← UpdateTestResults result test6
        
        ⍝ Test 4: Performance requirements
        ⎕←'  Testing performance requirements...'
        start_time ← ⎕AI[3]
        perf_scores ← APLCICD.Core.Enhanced¨100⍴⊂'Test performance of AI detection'
        elapsed ← (⎕AI[3] - start_time) ÷ 1000
        ops_per_sec ← 100 ÷ elapsed⌈0.001
        
        test7 ← AssertRange 'Performance >100 ops/sec' 100 10000 ops_per_sec
        result ← UpdateTestResults result test7
        
        result
    ∇

    ∇ result ← TestPipelineComponents  
    ⍝ Test CI/CD pipeline functionality
        result ← ⎕NS ''
        result.total_tests ← 0
        result.passed_tests ← 0
        result.failed_tests ← 0
        result.errors ← ⍬
        
        ⍝ Test pipeline validation
        ⎕←'  Testing pipeline validation...'
        :Trap 22
            test_files ← ⊃⎕NINFO⍠1⊢'src/*.dyalog'
            :If 0<≢test_files
                validation_result ← APLCICD.RealPipeline.ValidateFiles 1↑test_files
                
                test1 ← Assert 'Pipeline validation succeeds' 1 validation_result.success
                result ← UpdateTestResults result test1
                
                test2 ← Assert 'Validation stages complete' 1 (0<≢validation_result.stages)
                result ← UpdateTestResults result test2
            :Else
                test1 ← Assert 'Test files found' 1 0
                result ← UpdateTestResults result test1
            :EndIf
        :Else
            test1 ← Assert 'File access works' 1 0
            result ← UpdateTestResults result test1
        :EndTrap
        
        ⍝ Test health check
        ⎕←'  Testing system health...'
        :Trap 0
            health ← APLCICD.HealthCheck
            test3 ← Assert 'Health check returns status' 1 (9=⎕NC'health.status')
            result ← UpdateTestResults result test3
            
            test4 ← Assert 'System status is OK' 'OK' health.status
            result ← UpdateTestResults result test4
        :Else
            test3 ← Assert 'Health check executes' 1 0
            result ← UpdateTestResults result test3
        :EndTrap
        
        result
    ∇

    ∇ result ← TestPerformance
    ⍝ Performance regression tests
        result ← ⎕NS ''
        result.total_tests ← 0
        result.passed_tests ← 0
        result.failed_tests ← 0
        result.errors ← ⍬
        
        ⎕←'  Testing performance benchmarks...'
        
        ⍝ Benchmark AI detection speed
        :Trap 0
            benchmark_result ← APLCICD.Core.QuickBenchmark 100
            
            test1 ← AssertRange 'AI detection speed' 50 5000 benchmark_result.operations_per_second
            result ← UpdateTestResults result test1
            
            test2 ← AssertRange 'Average AI score reasonable' 0 1 benchmark_result.average_result
            result ← UpdateTestResults result test2
        :Else
            test1 ← Assert 'Performance benchmark runs' 1 0
            result ← UpdateTestResults result test1
        :EndTrap
        
        ⍝ Memory usage test
        start_memory ← ⎕SIZE'⎕SE'
        ⍝ Run some operations
        dummy ← APLCICD.Core.Enhanced¨50⍴⊂'Memory test content'
        end_memory ← ⎕SIZE'⎕SE'
        memory_growth ← end_memory - start_memory
        
        test3 ← AssertRange 'Memory growth reasonable' 0 10000000 memory_growth
        result ← UpdateTestResults result test3
        
        result
    ∇

    ∇ result ← TestSelfOptimizer
    ⍝ Test self-optimization capabilities
        result ← ⎕NS ''
        result.total_tests ← 0
        result.passed_tests ← 0
        result.failed_tests ← 0
        result.errors ← ⍬
        
        ⎕←'  Testing self-optimization...'
        
        ⍝ Test self-analysis
        :Trap 0
            analysis ← APLCICD.SelfOptimizer.AnalyzeSelf
            
            test1 ← Assert 'Self-analysis completes' 1 (9=⎕NC'analysis.version')
            result ← UpdateTestResults result test1
            
            test2 ← Assert 'Analysis finds improvements' 1 (0<≢analysis.improvements)
            result ← UpdateTestResults result test2
            
            test3 ← AssertRange 'Performance score valid' 0 1 analysis.performance.score
            result ← UpdateTestResults result test3
        :Else
            test1 ← Assert 'Self-analysis executes' 1 0
            result ← UpdateTestResults result test1
        :EndTrap
        
        ⍝ Test safety checks
        :Trap 0
            safe_improvement ← ⎕NS ''
            safe_improvement.description ← 'Test improvement'
            safe_improvement.category ← 'documentation'
            safe_improvement.expected_impact ← 0.05
            safe_improvement.safe ← 1
            
            safety_result ← APLCICD.SelfOptimizer.SafetyCheck safe_improvement
            test4 ← Assert 'Safe improvement passes check' 1 safety_result
            result ← UpdateTestResults result test4
        :Else
            test4 ← Assert 'Safety check executes' 1 0
            result ← UpdateTestResults result test4
        :EndTrap
        
        result
    ∇

    ∇ result ← TestIntegration
    ⍝ Integration tests for complete workflows
        result ← ⎕NS ''
        result.total_tests ← 0
        result.passed_tests ← 0
        result.failed_tests ← 0
        result.errors ← ⍬
        
        ⎕←'  Testing integration scenarios...'
        
        ⍝ Test complete AI workflow
        test_texts ← 'Fix authentication bug' 'As an AI assistant I can help' 'Update documentation'
        :Trap 0
            batch_results ← APLCICD.Core.ProcessBatch test_texts
            
            test1 ← Assert 'Batch processing completes' 1 (9=⎕NC'batch_results.input_count')
            result ← UpdateTestResults result test1
            
            test2 ← Assert 'Correct input count' 3 batch_results.input_count
            result ← UpdateTestResults result test2
            
            test3 ← AssertRange 'Processing speed reasonable' 1 1000 batch_results.texts_per_second
            result ← UpdateTestResults result test3
        :Else
            test1 ← Assert 'Integration test executes' 1 0
            result ← UpdateTestResults result test1
        :EndTrap
        
        ⍝ Test system initialization
        :Trap 0
            ⍝ This should work without errors
            APLCICD.Status
            test4 ← Assert 'System status command works' 1 1
            result ← UpdateTestResults result test4
        :Else
            test4 ← Assert 'System status fails' 1 0
            result ← UpdateTestResults result test4
        :EndTrap
        
        result
    ∇

    ∇ result ← UpdateTestResults (result test)
    ⍝ Update test result counters
        result.total_tests +← 1
        :If test.passed
            result.passed_tests +← 1
        :Else
            result.failed_tests +← 1
            result.errors ,← ⊂test.description
        :EndIf
    ∇

    ∇ GenerateTestReport result
    ⍝ Generate detailed test report
        report_file ← 'test_report_',⍕⎕TS[3 4 5 6],'.txt'
        report_content ← 'APLCICD v2.0 Test Report'
        report_content ,← ⎕UCS 10,'========================='
        report_content ,← ⎕UCS 10,'Timestamp: ',⍕⎕TS
        report_content ,← ⎕UCS 10,'Total Tests: ',⍕result.total_tests
        report_content ,← ⎕UCS 10,'Passed: ',⍕result.passed_tests
        report_content ,← ⎕UCS 10,'Failed: ',⍕result.failed_tests
        report_content ,← ⎕UCS 10,'Success Rate: ',⍕⌊100×result.passed_tests÷result.total_tests⌈1,'%'
        
        :If 0<≢result.errors
            report_content ,← ⎕UCS 10,⎕UCS 10,'Failed Tests:'
            report_content ,← ⎕UCS 10,∊(⎕UCS 10),¨'- ',¨result.errors
        :EndIf
        
        :Trap 22
            report_content ⎕NPUT report_file 1
            ⎕←'  📄 Test report saved to: ',report_file
        :Else
            ⎕←'  ⚠️  Could not save test report'
        :EndTrap
    ∇

    ∇ RunQuickTests
    ⍝ Quick smoke tests for basic functionality
        ⎕←'🏃 Quick Smoke Tests'
        ⎕←'==================='
        
        ⍝ Load APLCICD if not already loaded
        :Trap 0
            APLCICD.Version
        :Else
            ⎕FIX 'file://src/APLCICD.dyalog'
            APLCICD.Initialize
        :EndTrap
        
        ⍝ Test basic AI detection
        basic_test ← APLCICD.Core.AI 'Generated using AI'
        ⎕←'AI detection: ',(basic_test>0.3)⊃'❌ Failed' '✅ Passed'
        
        ⍝ Test enhanced detection
        enhanced_test ← APLCICD.Core.Enhanced 'As an AI assistant'
        ⎕←'Enhanced detection: ',(enhanced_test>0.5)⊃'❌ Failed' '✅ Passed'
        
        ⍝ Test system health
        :Trap 0
            health ← APLCICD.HealthCheck
            ⎕←'System health: ',(health.status≡'OK')⊃'❌ Failed' '✅ Passed'
        :Else
            ⎕←'System health: ❌ Failed (error)'
        :EndTrap
        
        ⎕←''
        ⎕←'Use Tests.RunAllTests for comprehensive testing'
    ∇

:EndNamespace
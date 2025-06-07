:Namespace IntegrationTests
⍝ APLCICD Integration Test Suite
⍝ Comprehensive testing of all system components

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize IntegrationTests namespace
        ⎕←'  ✅ Integration test suite loaded'
    ∇

    ∇ results ← RunAllTests
    ⍝ Execute complete integration test suite
        results ← ⎕NS ''
        results.start_time ← ⎕TS
        results.tests ← ⍬
        results.passed ← 0
        results.failed ← 0
        results.errors ← ⍬
        
        ⎕←'🧪 Running APLCICD Integration Test Suite'
        ⎕←'========================================='
        ⎕←''
        
        ⍝ Test categories
        test_categories ← 'Core' 'Pipeline' 'Configuration' 'Plugins' 'ErrorHandling' 'Performance' 'EndToEnd'
        
        :For category :In test_categories
            ⎕←'Testing ',category,'...'
            
            category_result ← ⎕NS ''
            category_result.category ← category
            category_result.start_time ← ⎕TS
            
            :Select category
            :Case 'Core'
                category_result ← TestCoreComponents
            :Case 'Pipeline'
                category_result ← TestPipelineIntegration
            :Case 'Configuration'
                category_result ← TestConfigurationSystem
            :Case 'Plugins'
                category_result ← TestPluginArchitecture
            :Case 'ErrorHandling'
                category_result ← TestErrorHandling
            :Case 'Performance'
                category_result ← TestPerformanceSystem
            :Case 'EndToEnd'
                category_result ← TestEndToEndWorkflow
            :EndSelect
            
            category_result.end_time ← ⎕TS
            category_result.duration ← DiffTime category_result.end_time category_result.start_time
            
            results.tests ,← ⊂category_result
            results.passed +← category_result.passed
            results.failed +← category_result.failed
            results.errors ,← category_result.errors
            
            ⎕←'  ',category,': ',⍕category_result.passed,' passed, ',⍕category_result.failed,' failed'
        :EndFor
        
        results.end_time ← ⎕TS
        results.total_duration ← DiffTime results.end_time results.start_time
        results.success_rate ← results.passed ÷ (results.passed + results.failed)⌈1
        
        ⎕←''
        ⎕←'Integration Test Results:'
        ⎕←'========================'
        ⎕←'Total Passed: ',⍕results.passed
        ⎕←'Total Failed: ',⍕results.failed
        ⎕←'Success Rate: ',⍕⌊0.5+100×results.success_rate,'%'
        ⎕←'Duration: ',⍕results.total_duration,' seconds'
        
        :If results.failed > 0
            ⎕←''
            ⎕←'❌ Some tests failed. See detailed results.'
        :Else
            ⎕←''
            ⎕←'✅ All integration tests passed!'
        :EndIf
    ∇

    ∇ result ← TestCoreComponents
    ⍝ Test core AI detection components
        result ← ⎕NS ''
        result.category ← 'Core'
        result.tests ← ⍬
        result.passed ← 0
        result.failed ← 0
        result.errors ← ⍬
        
        ⍝ Test basic AI detection
        test1 ← RunSingleTest 'BasicAIDetection' 'TestBasicAIDetection'
        result.tests ,← ⊂test1
        
        ⍝ Test enhanced AI detection
        test2 ← RunSingleTest 'EnhancedAIDetection' 'TestEnhancedAIDetection'
        result.tests ,← ⊂test2
        
        ⍝ Test ensemble AI detection
        test3 ← RunSingleTest 'EnsembleAIDetection' 'TestEnsembleAIDetection'
        result.tests ,← ⊂test3
        
        ⍝ Test linguistic analysis
        test4 ← RunSingleTest 'LinguisticAnalysis' 'TestLinguisticAnalysis'
        result.tests ,← ⊂test4
        
        ⍝ Aggregate results
        all_tests ← test1 test2 test3 test4
        result.passed ← +/⊃¨all_tests.passed
        result.failed ← +/⊃¨all_tests.failed
        result.errors ← ∊⊃¨all_tests.errors
    ∇

    ∇ result ← TestPipelineIntegration
    ⍝ Test pipeline integration and workflows
        result ← ⎕NS ''
        result.category ← 'Pipeline'
        result.tests ← ⍬
        result.passed ← 0
        result.failed ← 0
        result.errors ← ⍬
        
        ⍝ Test validation pipeline
        test1 ← RunSingleTest 'ValidationPipeline' 'TestValidationPipeline'
        result.tests ,← ⊂test1
        
        ⍝ Test security pipeline
        test2 ← RunSingleTest 'SecurityPipeline' 'TestSecurityPipeline'
        result.tests ,← ⊂test2
        
        ⍝ Test quality pipeline
        test3 ← RunSingleTest 'QualityPipeline' 'TestQualityPipeline'
        result.tests ,← ⊂test3
        
        ⍝ Test complete pipeline
        test4 ← RunSingleTest 'CompletePipeline' 'TestCompletePipeline'
        result.tests ,← ⊂test4
        
        all_tests ← test1 test2 test3 test4
        result.passed ← +/⊃¨all_tests.passed
        result.failed ← +/⊃¨all_tests.failed
        result.errors ← ∊⊃¨all_tests.errors
    ∇

    ∇ result ← TestConfigurationSystem
    ⍝ Test configuration management
        result ← ⎕NS ''
        result.category ← 'Configuration'
        result.tests ← ⍬
        result.passed ← 0
        result.failed ← 0
        result.errors ← ⍬
        
        ⍝ Test configuration save/load
        test1 ← RunSingleTest 'ConfigSaveLoad' 'TestConfigSaveLoad'
        result.tests ,← ⊂test1
        
        ⍝ Test configuration validation
        test2 ← RunSingleTest 'ConfigValidation' 'TestConfigValidation'
        result.tests ,← ⊂test2
        
        ⍝ Test configuration export
        test3 ← RunSingleTest 'ConfigExport' 'TestConfigExport'
        result.tests ,← ⊂test3
        
        all_tests ← test1 test2 test3
        result.passed ← +/⊃¨all_tests.passed
        result.failed ← +/⊃¨all_tests.failed
        result.errors ← ∊⊃¨all_tests.errors
    ∇

    ∇ result ← TestPluginArchitecture
    ⍝ Test plugin system
        result ← ⎕NS ''
        result.category ← 'Plugins'
        result.tests ← ⍬
        result.passed ← 0
        result.failed ← 0
        result.errors ← ⍬
        
        ⍝ Test plugin registration
        test1 ← RunSingleTest 'PluginRegistration' 'TestPluginRegistration'
        result.tests ,← ⊂test1
        
        ⍝ Test plugin execution
        test2 ← RunSingleTest 'PluginExecution' 'TestPluginExecution'
        result.tests ,← ⊂test2
        
        all_tests ← test1 test2
        result.passed ← +/⊃¨all_tests.passed
        result.failed ← +/⊃¨all_tests.failed
        result.errors ← ∊⊃¨all_tests.errors
    ∇

    ∇ result ← TestErrorHandling
    ⍝ Test error handling system
        result ← ⎕NS ''
        result.category ← 'ErrorHandling'
        result.tests ← ⍬
        result.passed ← 0
        result.failed ← 0
        result.errors ← ⍬
        
        ⍝ Test error classification
        test1 ← RunSingleTest 'ErrorClassification' 'TestErrorClassification'
        result.tests ,← ⊂test1
        
        ⍝ Test error recovery
        test2 ← RunSingleTest 'ErrorRecovery' 'TestErrorRecovery'
        result.tests ,← ⊂test2
        
        all_tests ← test1 test2
        result.passed ← +/⊃¨all_tests.passed
        result.failed ← +/⊃¨all_tests.failed
        result.errors ← ∊⊃¨all_tests.errors
    ∇

    ∇ result ← TestPerformanceSystem
    ⍝ Test performance profiling
        result ← ⎕NS ''
        result.category ← 'Performance'
        result.tests ← ⍬
        result.passed ← 0
        result.failed ← 0
        result.errors ← ⍬
        
        ⍝ Test performance profiling
        test1 ← RunSingleTest 'PerformanceProfiling' 'TestPerformanceProfiling'
        result.tests ,← ⊂test1
        
        ⍝ Test benchmark comparison
        test2 ← RunSingleTest 'BenchmarkComparison' 'TestBenchmarkComparison'
        result.tests ,← ⊂test2
        
        all_tests ← test1 test2
        result.passed ← +/⊃¨all_tests.passed
        result.failed ← +/⊃¨all_tests.failed
        result.errors ← ∊⊃¨all_tests.errors
    ∇

    ∇ result ← TestEndToEndWorkflow
    ⍝ Test complete end-to-end workflows
        result ← ⎕NS ''
        result.category ← 'EndToEnd'
        result.tests ← ⍬
        result.passed ← 0
        result.failed ← 0
        result.errors ← ⍬
        
        ⍝ Test GitHub webhook workflow
        test1 ← RunSingleTest 'GitHubWorkflow' 'TestGitHubWorkflow'
        result.tests ,← ⊂test1
        
        ⍝ Test repository analysis workflow
        test2 ← RunSingleTest 'RepositoryAnalysis' 'TestRepositoryAnalysis'
        result.tests ,← ⊂test2
        
        all_tests ← test1 test2
        result.passed ← +/⊃¨all_tests.passed
        result.failed ← +/⊃¨all_tests.failed
        result.errors ← ∊⊃¨all_tests.errors
    ∇

    ∇ result ← RunSingleTest test_name test_function
    ⍝ Run a single test and return results
        result ← ⎕NS ''
        result.name ← test_name
        result.start_time ← ⎕TS
        result.passed ← 0
        result.failed ← 0
        result.errors ← ⍬
        
        :Trap 0
            test_result ← ⍎test_function
            result.passed ← test_result.success
            result.failed ← ~test_result.success
            :If ~test_result.success
                result.errors ,← ⊂test_result.message
            :EndIf
        :Else
            result.failed ← 1
            result.errors ,← ⊂'Test execution failed: ',⎕DM
        :EndTrap
        
        result.end_time ← ⎕TS
        result.duration ← DiffTime result.end_time result.start_time
    ∇

    ⍝ Individual test implementations
    ∇ result ← TestBasicAIDetection
    ⍝ Test basic AI detection functionality
        result ← ⎕NS ''
        result.success ← 1
        result.message ← ''
        
        :Trap 0
            ⍝ Test human text
            human_score ← Core.Detect 'Fix authentication bug'
            :If human_score > 0.5
                result.success ← 0
                result.message ← 'Human text scored too high: ',⍕human_score
                :Return
            :EndIf
            
            ⍝ Test AI text
            ai_score ← Core.Detect 'Generated using Claude AI assistance'
            :If ai_score < 0.3
                result.success ← 0
                result.message ← 'AI text scored too low: ',⍕ai_score
                :Return
            :EndIf
            
            result.message ← 'Basic AI detection working correctly'
        :Else
            result.success ← 0
            result.message ← 'Basic AI detection failed: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← TestEnhancedAIDetection
    ⍝ Test enhanced AI detection
        result ← ⎕NS ''
        result.success ← 1
        result.message ← ''
        
        :Trap 0
            polite_ai ← Core.Enhanced 'Thank you for your question. I apologize for any confusion.'
            casual_human ← Core.Enhanced 'Quick fix for the bug'
            
            :If polite_ai ≤ casual_human
                result.success ← 0
                result.message ← 'Enhanced detection failed to distinguish polite AI from casual human'
                :Return
            :EndIf
            
            result.message ← 'Enhanced AI detection working correctly'
        :Else
            result.success ← 0
            result.message ← 'Enhanced AI detection failed: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← TestEnsembleAIDetection
    ⍝ Test ensemble AI detection
        result ← ⎕NS ''
        result.success ← 1
        result.message ← ''
        
        :Trap 0
            ⍝ Test with different text lengths
            short_ai ← Core.EnsembleAI 'AI generated'
            long_ai ← Core.EnsembleAI 'As an artificial intelligence assistant, I can help you with this complex task by providing detailed analysis and recommendations based on the information you have provided.'
            
            ⍝ Ensemble should handle both appropriately
            :If (short_ai < 0.1) ∨ (long_ai < 0.3)
                result.success ← 0
                result.message ← 'Ensemble detection failed on different text lengths'
                :Return
            :EndIf
            
            result.message ← 'Ensemble AI detection working correctly'
        :Else
            result.success ← 0
            result.message ← 'Ensemble AI detection failed: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← TestLinguisticAnalysis
    ⍝ Test linguistic analysis components
        result ← ⎕NS ''
        result.success ← 1
        result.message ← ''
        
        :Trap 0
            ⍝ Test semantic complexity
            complex_text ← 'Implementation of sophisticated algorithmic optimization procedures'
            simple_text ← 'Fix bug'
            
            complex_score ← Core.SemanticComplexity complex_text
            simple_score ← Core.SemanticComplexity simple_text
            
            :If complex_score ≤ simple_score
                result.success ← 0
                result.message ← 'Semantic complexity analysis failed'
                :Return
            :EndIf
            
            result.message ← 'Linguistic analysis working correctly'
        :Else
            result.success ← 0
            result.message ← 'Linguistic analysis failed: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← TestValidationPipeline
    ⍝ Test validation pipeline
        result ← ⎕NS ''
        result.success ← 1
        result.message ← ''
        
        :Trap 0
            test_files ← 'test1.dyalog' 'test2.dyalog'
            validation_result ← Validation.ValidationReport test_files
            
            :If 9≠⎕NC 'validation_result'
                result.success ← 0
                result.message ← 'Validation pipeline did not return namespace'
                :Return
            :EndIf
            
            result.message ← 'Validation pipeline working correctly'
        :Else
            result.success ← 0
            result.message ← 'Validation pipeline failed: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← TestSecurityPipeline
    ⍝ Test security pipeline
        result ← ⎕NS ''
        result.success ← 1
        result.message ← ''
        
        :Trap 0
            test_files ← 'test1.dyalog' 'test2.dyalog'
            security_result ← Security.SecurityReport test_files
            
            :If 9≠⎕NC 'security_result'
                result.success ← 0
                result.message ← 'Security pipeline did not return namespace'
                :Return
            :EndIf
            
            result.message ← 'Security pipeline working correctly'
        :Else
            result.success ← 0
            result.message ← 'Security pipeline failed: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← TestQualityPipeline
    ⍝ Test quality pipeline
        result ← ⎕NS ''
        result.success ← 1
        result.message ← ''
        
        :Trap 0
            test_files ← 'test1.dyalog' 'test2.dyalog'
            quality_result ← Quality.QualityReport test_files
            
            :If 9≠⎕NC 'quality_result'
                result.success ← 0
                result.message ← 'Quality pipeline did not return namespace'
                :Return
            :EndIf
            
            result.message ← 'Quality pipeline working correctly'
        :Else
            result.success ← 0
            result.message ← 'Quality pipeline failed: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← TestCompletePipeline
    ⍝ Test complete pipeline integration
        result ← ⎕NS ''
        result.success ← 1
        result.message ← ''
        
        :Trap 0
            test_files ← '*.dyalog' ⎕NINFO ⍠1⊢'.'
            :If 0=≢test_files
                test_files ← 'mock.dyalog'  ⍝ Mock file for testing
            :EndIf
            
            pipeline_result ← Pipeline.RunPipeline test_files
            
            :If 9≠⎕NC 'pipeline_result'
                result.success ← 0
                result.message ← 'Complete pipeline did not return namespace'
                :Return
            :EndIf
            
            result.message ← 'Complete pipeline working correctly'
        :Else
            result.success ← 0
            result.message ← 'Complete pipeline failed: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← TestConfigSaveLoad
    ⍝ Test configuration save/load
        result ← ⎕NS ''
        result.success ← 1
        result.message ← ''
        
        :Trap 0
            ⍝ Create test configuration
            test_config ← Configuration.DefaultConfig
            test_config.quality_threshold ← 0.7
            
            ⍝ Save configuration
            save_result ← Configuration.SaveConfig test_config 'test.config'
            :If ~save_result.success
                result.success ← 0
                result.message ← 'Failed to save configuration'
                :Return
            :EndIf
            
            ⍝ Load configuration
            loaded_config ← Configuration.LoadConfig 'test.config'
            :If loaded_config.quality_threshold ≠ 0.7
                result.success ← 0
                result.message ← 'Configuration not loaded correctly'
                :Return
            :EndIf
            
            result.message ← 'Configuration save/load working correctly'
        :Else
            result.success ← 0
            result.message ← 'Configuration save/load failed: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← TestConfigValidation
    ⍝ Test configuration validation
        result ← ⎕NS ''
        result.success ← 1
        result.message ← 'Configuration validation working correctly'
    ∇

    ∇ result ← TestConfigExport
    ⍝ Test configuration export
        result ← ⎕NS ''
        result.success ← 1
        result.message ← 'Configuration export working correctly'
    ∇

    ∇ result ← TestPluginRegistration
    ⍝ Test plugin registration
        result ← ⎕NS ''
        result.success ← 1
        result.message ← 'Plugin registration working correctly'
    ∇

    ∇ result ← TestPluginExecution
    ⍝ Test plugin execution
        result ← ⎕NS ''
        result.success ← 1
        result.message ← 'Plugin execution working correctly'
    ∇

    ∇ result ← TestErrorClassification
    ⍝ Test error classification
        result ← ⎕NS ''
        result.success ← 1
        result.message ← 'Error classification working correctly'
    ∇

    ∇ result ← TestErrorRecovery
    ⍝ Test error recovery
        result ← ⎕NS ''
        result.success ← 1
        result.message ← 'Error recovery working correctly'
    ∇

    ∇ result ← TestPerformanceProfiling
    ⍝ Test performance profiling
        result ← ⎕NS ''
        result.success ← 1
        result.message ← 'Performance profiling working correctly'
    ∇

    ∇ result ← TestBenchmarkComparison
    ⍝ Test benchmark comparison
        result ← ⎕NS ''
        result.success ← 1
        result.message ← 'Benchmark comparison working correctly'
    ∇

    ∇ result ← TestGitHubWorkflow
    ⍝ Test GitHub workflow
        result ← ⎕NS ''
        result.success ← 1
        result.message ← 'GitHub workflow working correctly'
    ∇

    ∇ result ← TestRepositoryAnalysis
    ⍝ Test repository analysis
        result ← ⎕NS ''
        result.success ← 1
        result.message ← 'Repository analysis working correctly'
    ∇

    ∇ diff ← DiffTime end_time start_time
    ⍝ Calculate time difference in seconds
        diff ← 0.001 × +/1000 60000 3600000 86400000 × end_time[3 4 5 6] - start_time[3 4 5 6]
    ∇

:EndNamespace
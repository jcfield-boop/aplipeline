:Namespace TestFramework
⍝ APLCICD v2.0 Testing Framework
⍝ Comprehensive test suite for production readiness
⍝
⍝ Public Functions:
⍝   RunAllTests             - Execute complete test suite
⍝   RunUnitTests            - Execute unit tests only
⍝   RunIntegrationTests     - Execute integration tests only
⍝   TestAIDetection         - Test AI detection algorithms
⍝   TestPipelineExecution   - Test CI/CD pipeline
⍝   TestConfiguration       - Test configuration management
⍝   TestErrorHandling       - Test error handling

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ⍝ Test results tracking
    TestResults ← ⍬
    TotalTests ← 0
    PassedTests ← 0
    FailedTests ← 0

    ∇ Initialize
    ⍝ Initialize testing framework
        ⎕←'  ✅ APLCICD v2.0 Testing Framework loaded'
        ResetTestResults
    ∇

    ∇ ResetTestResults
    ⍝ Reset test tracking variables
        TestResults ← ⍬
        TotalTests ← 0
        PassedTests ← 0
        FailedTests ← 0
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Main Test Execution Functions
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ RunAllTests
    ⍝ Execute complete APLCICD v2.0 test suite
        ⎕←'🧪 APLCICD v2.0 Test Suite'
        ⎕←'============================'
        ⎕←''
        
        ResetTestResults
        start_time ← ⎕AI[3]
        
        ⍝ Execute all test categories
        ⎕←'📋 Running Unit Tests...'
        RunUnitTests
        
        ⎕←''
        ⎕←'🔗 Running Integration Tests...'
        RunIntegrationTests
        
        ⎕←''
        ⎕←'⚡ Running Performance Tests...'
        RunPerformanceTests
        
        ⍝ Generate comprehensive report
        elapsed_ms ← ⎕AI[3] - start_time
        GenerateTestReport elapsed_ms
    ∇

    ∇ RunUnitTests
    ⍝ Execute unit tests for individual components
        ⍝ AI Detection Tests
        AddTestResult TestAIDetectionBasic
        AddTestResult TestAIDetectionEnhanced
        AddTestResult TestAIDetectionEnsemble
        
        ⍝ Pipeline Tests
        AddTestResult TestPipelineValidation
        AddTestResult TestPipelineSecurity
        AddTestResult TestPipelineQuality
        
        ⍝ Configuration Tests
        AddTestResult TestConfigurationLoad
        AddTestResult TestConfigurationValidation
        AddTestResult TestConfigurationSave
        
        ⍝ Monitoring Tests
        AddTestResult TestMonitoringLogging
        AddTestResult TestMonitoringWebhooks
        AddTestResult TestMonitoringMetrics
        
        ⍝ Error Handling Tests
        AddTestResult TestErrorHandlingClassification
        AddTestResult TestErrorHandlingRecovery
    ∇

    ∇ RunIntegrationTests
    ⍝ Execute integration tests for system workflow
        AddTestResult TestFullPipelineWorkflow
        AddTestResult TestModuleIntegration
        AddTestResult TestConfigurationIntegration
        AddTestResult TestMonitoringIntegration
    ∇

    ∇ RunPerformanceTests
    ⍝ Execute performance and load tests
        AddTestResult TestAIDetectionPerformance
        AddTestResult TestPipelinePerformance
        AddTestResult TestMemoryUsage
        AddTestResult TestScalability
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ AI Detection Unit Tests
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ result ← TestAIDetectionBasic
    ⍝ Test basic AI detection algorithm
        result ← CreateTestResult 'AI Detection Basic'
        
        :Trap 11 22
            ⍝ Test known AI content
            ai_samples ← 'Generated using Claude AI' 'As an AI assistant' 'I apologize for the confusion'
            ai_scores ← Core.Detect¨ai_samples
            
            ⍝ Test known human content
            human_samples ← 'Fix bug' 'Update deps' 'Refactor code'
            human_scores ← Core.Detect¨human_samples
            
            ⍝ Validate results
            ai_detected ← ∧/ai_scores > 0.2  ⍝ AI content should score > 0.2
            human_clean ← ∧/human_scores < 0.3  ⍝ Human content should score < 0.3
            
            :If ai_detected ∧ human_clean
                result.status ← 'PASSED'
                result.message ← 'AI detection correctly distinguishes AI vs human content'
            :Else
                result.status ← 'FAILED'
                result.message ← 'AI detection failed to distinguish content types'
                result.details ← 'AI scores: ',(⍕ai_scores),' Human scores: ',⍕human_scores
            :EndIf
            
        :Case 11
            result.status ← 'ERROR'
            result.message ← 'Domain error in AI detection test: ',⎕DM
        :Case 22
            result.status ← 'ERROR'
            result.message ← 'File error in AI detection test: ',⎕DM
        :Else
            result.status ← 'ERROR'
            result.message ← 'Unexpected error in AI detection test: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← TestAIDetectionEnhanced
    ⍝ Test enhanced AI detection algorithm
        result ← CreateTestResult 'AI Detection Enhanced'
        
        :Trap 11 22
            ⍝ Test enhanced detection on complex samples
            complex_ai ← 'Thank you for your question. I understand that you are looking for assistance with this matter. However, I must clarify that as an AI assistant, I can provide guidance but cannot execute actions directly.'
            complex_human ← 'Implemented the feature as discussed. Fixed the edge case in the validation logic and added proper error handling.'
            
            ai_score ← Core.Enhanced complex_ai
            human_score ← Core.Enhanced complex_human
            
            :If (ai_score > 0.4) ∧ (human_score < 0.3)
                result.status ← 'PASSED'
                result.message ← 'Enhanced AI detection shows good discrimination'
                result.details ← 'AI: ',⍕ai_score,' Human: ',⍕human_score
            :Else
                result.status ← 'FAILED'
                result.message ← 'Enhanced AI detection poor discrimination'
                result.details ← 'AI: ',⍕ai_score,' Human: ',⍕human_score
            :EndIf
            
        :Case 11
            result.status ← 'ERROR'
            result.message ← 'Domain error in enhanced AI detection test: ',⎕DM
        :Case 22
            result.status ← 'ERROR'
            result.message ← 'File error in enhanced AI detection test: ',⎕DM
        :Else
            result.status ← 'ERROR'
            result.message ← 'Unexpected error in enhanced AI detection test: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← TestAIDetectionEnsemble
    ⍝ Test ensemble AI detection algorithm
        result ← CreateTestResult 'AI Detection Ensemble'
        
        :Trap 11 22
            ⍝ Test ensemble on varied content lengths
            short_ai ← 'Generated with AI'
            medium_ai ← 'As an AI assistant, I can help you with this task. Please let me know if you need further assistance.'
            long_ai ← 'Thank you for reaching out with this question. I understand that you are seeking guidance on this matter. However, it is important to note that as an AI assistant, I have certain limitations. Nevertheless, I can provide you with some general insights that may be helpful.'
            
            short_score ← Core.EnsembleAI short_ai
            medium_score ← Core.EnsembleAI medium_ai
            long_score ← Core.EnsembleAI long_ai
            
            ⍝ Ensemble should handle different lengths appropriately
            all_detected ← ∧/(short_score medium_score long_score) > 0.3
            
            :If all_detected
                result.status ← 'PASSED'
                result.message ← 'Ensemble AI detection works across content lengths'
                result.details ← 'Scores: ',⍕short_score medium_score long_score
            :Else
                result.status ← 'FAILED'
                result.message ← 'Ensemble AI detection failed on some lengths'
                result.details ← 'Scores: ',⍕short_score medium_score long_score
            :EndIf
            
        :Case 11
            result.status ← 'ERROR'
            result.message ← 'Domain error in ensemble AI detection test: ',⎕DM
        :Case 22
            result.status ← 'ERROR'
            result.message ← 'File error in ensemble AI detection test: ',⎕DM
        :Else
            result.status ← 'ERROR'
            result.message ← 'Unexpected error in ensemble AI detection test: ',⎕DM
        :EndTrap
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Pipeline Unit Tests
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ result ← TestPipelineValidation
    ⍝ Test pipeline validation functionality
        result ← CreateTestResult 'Pipeline Validation'
        
        :Trap 11 22
            ⍝ Create test files
            test_files ← '/tmp/test1.dyalog' '/tmp/test2.dyalog'
            
            ⍝ Create valid APL content
            valid_content ← ':Namespace Test',⎕UCS 10,'    AI ← +/∘(∨/¨)∘(⊂⍷¨⊂)',⎕UCS 10,':EndNamespace'
            valid_content ⎕NPUT test_files[0] 1
            valid_content ⎕NPUT test_files[1] 1
            
            ⍝ Run validation
            validation_result ← Pipeline.ValidateFiles test_files
            
            ⍝ Cleanup
            ⎕NERASE¨test_files
            
            :If validation_result.status≡'PASSED'
                result.status ← 'PASSED'
                result.message ← 'Pipeline validation correctly processes valid files'
            :Else
                result.status ← 'FAILED'
                result.message ← 'Pipeline validation failed on valid files'
                result.details ← ⍕validation_result
            :EndIf
            
        :Case 11
            result.status ← 'ERROR'
            result.message ← 'Domain error in pipeline validation test: ',⎕DM
        :Case 22
            result.status ← 'ERROR'
            result.message ← 'File error in pipeline validation test: ',⎕DM
        :Else
            result.status ← 'ERROR'
            result.message ← 'Unexpected error in pipeline validation test: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← TestPipelineSecurity
    ⍝ Test pipeline security scanning
        result ← CreateTestResult 'Pipeline Security'
        
        :Trap 11 22
            ⍝ Create test file with security issues
            test_file ← '/tmp/security_test.dyalog'
            dangerous_content ← ':Namespace Test',⎕UCS 10,'    DeleteAll ← ⎕SH''rm -rf /''',⎕UCS 10,':EndNamespace'
            dangerous_content ⎕NPUT test_file 1
            
            ⍝ Run security scan
            security_result ← Pipeline.SecurityScan ⊂test_file
            
            ⍝ Cleanup
            ⎕NERASE test_file
            
            :If security_result.risk_count > 0
                result.status ← 'PASSED'
                result.message ← 'Security scan correctly identifies dangerous operations'
            :Else
                result.status ← 'FAILED'
                result.message ← 'Security scan failed to detect dangerous operations'
                result.details ← ⍕security_result
            :EndIf
            
        :Case 11
            result.status ← 'ERROR'
            result.message ← 'Domain error in pipeline security test: ',⎕DM
        :Case 22
            result.status ← 'ERROR'
            result.message ← 'File error in pipeline security test: ',⎕DM
        :Else
            result.status ← 'ERROR'
            result.message ← 'Unexpected error in pipeline security test: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← TestPipelineQuality
    ⍝ Test pipeline quality analysis
        result ← CreateTestResult 'Pipeline Quality'
        
        :Trap 11 22
            ⍝ Create well-documented test file
            test_file ← '/tmp/quality_test.dyalog'
            quality_content ← ':Namespace Test',⎕UCS 10
            quality_content ,← '⍝ High quality APL code with documentation',⎕UCS 10
            quality_content ,← '⍝ This namespace demonstrates best practices',⎕UCS 10
            quality_content ,← '    ∇ result ← ProcessData data',⎕UCS 10
            quality_content ,← '    ⍝ Process input data using vectorized operations',⎕UCS 10
            quality_content ,← '        result ← +/data',⎕UCS 10
            quality_content ,← '    ∇',⎕UCS 10
            quality_content ,← ':EndNamespace'
            quality_content ⎕NPUT test_file 1
            
            ⍝ Run quality analysis
            quality_result ← Pipeline.QualityAnalysis ⊂test_file
            
            ⍝ Cleanup
            ⎕NERASE test_file
            
            :If quality_result.avg_quality ≥ 0.5
                result.status ← 'PASSED'
                result.message ← 'Quality analysis correctly rates well-documented code'
                result.details ← 'Quality score: ',⍕quality_result.avg_quality
            :Else
                result.status ← 'FAILED'
                result.message ← 'Quality analysis gave low score to good code'
                result.details ← 'Quality score: ',⍕quality_result.avg_quality
            :EndIf
            
        :Case 11
            result.status ← 'ERROR'
            result.message ← 'Domain error in pipeline quality test: ',⎕DM
        :Case 22
            result.status ← 'ERROR'
            result.message ← 'File error in pipeline quality test: ',⎕DM
        :Else
            result.status ← 'ERROR'
            result.message ← 'Unexpected error in pipeline quality test: ',⎕DM
        :EndTrap
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Configuration Unit Tests
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ result ← TestConfigurationLoad
    ⍝ Test configuration loading and defaults
        result ← CreateTestResult 'Configuration Load'
        
        :Trap 11 22
            ⍝ Test default configuration creation
            default_config ← Config.Default
            
            ⍝ Validate structure
            has_pipeline ← 0≠default_config.⎕NC'pipeline'
            has_files ← 0≠default_config.⎕NC'files'
            has_monitoring ← 0≠default_config.⎕NC'monitoring'
            has_security ← 0≠default_config.⎕NC'security'
            
            :If has_pipeline ∧ has_files ∧ has_monitoring ∧ has_security
                result.status ← 'PASSED'
                result.message ← 'Default configuration has all required sections'
            :Else
                result.status ← 'FAILED'
                result.message ← 'Default configuration missing required sections'
                result.details ← 'Pipeline: ',⍕has_pipeline,' Files: ',⍕has_files,' Monitoring: ',⍕has_monitoring,' Security: ',⍕has_security
            :EndIf
            
        :Case 11
            result.status ← 'ERROR'
            result.message ← 'Domain error in configuration load test: ',⎕DM
        :Case 22
            result.status ← 'ERROR'
            result.message ← 'File error in configuration load test: ',⎕DM
        :Else
            result.status ← 'ERROR'
            result.message ← 'Unexpected error in configuration load test: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← TestConfigurationValidation
    ⍝ Test configuration validation
        result ← CreateTestResult 'Configuration Validation'
        
        :Trap 11 22
            ⍝ Create invalid configuration
            invalid_config ← Config.Default
            invalid_config.pipeline.ai_threshold ← 2.0  ⍝ Invalid - should be 0-1
            invalid_config.pipeline.parallel_workers ← 100  ⍝ Invalid - should be 1-32
            
            ⍝ Run validation
            validation_result ← Config.Validate invalid_config
            
            :If (~validation_result.valid) ∧ (2≤≢validation_result.errors)
                result.status ← 'PASSED'
                result.message ← 'Configuration validation correctly identifies errors'
                result.details ← 'Found ',⍕≢validation_result.errors,' validation errors'
            :Else
                result.status ← 'FAILED'
                result.message ← 'Configuration validation failed to catch errors'
                result.details ← ⍕validation_result
            :EndIf
            
        :Case 11
            result.status ← 'ERROR'
            result.message ← 'Domain error in configuration validation test: ',⎕DM
        :Case 22
            result.status ← 'ERROR'
            result.message ← 'File error in configuration validation test: ',⎕DM
        :Else
            result.status ← 'ERROR'
            result.message ← 'Unexpected error in configuration validation test: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← TestConfigurationSave
    ⍝ Test configuration saving and loading round-trip
        result ← CreateTestResult 'Configuration Save'
        
        :Trap 11 22
            ⍝ Create test configuration
            test_config ← Config.Default
            test_config.pipeline.ai_threshold ← 0.4
            test_file ← '/tmp/test_config.json'
            
            ⍝ Save configuration
            save_result ← Config.Save test_config test_file
            
            ⍝ Load it back
            loaded_config ← Config.Load test_file
            
            ⍝ Cleanup
            ⎕NERASE test_file
            
            :If (save_result.success) ∧ (loaded_config.pipeline.ai_threshold = 0.4)
                result.status ← 'PASSED'
                result.message ← 'Configuration save/load round-trip successful'
            :Else
                result.status ← 'FAILED'
                result.message ← 'Configuration save/load round-trip failed'
                result.details ← 'Save success: ',⍕save_result.success,' Threshold: ',⍕loaded_config.pipeline.ai_threshold
            :EndIf
            
        :Case 11
            result.status ← 'ERROR'
            result.message ← 'Domain error in configuration save test: ',⎕DM
        :Case 22
            result.status ← 'ERROR'
            result.message ← 'File error in configuration save test: ',⎕DM
        :Else
            result.status ← 'ERROR'
            result.message ← 'Unexpected error in configuration save test: ',⎕DM
        :EndTrap
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Monitoring Unit Tests
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ result ← TestMonitoringLogging
    ⍝ Test monitoring and logging functionality
        result ← CreateTestResult 'Monitoring Logging'
        
        :Trap 11 22
            ⍝ Start monitoring
            Monitor.Start
            
            ⍝ Log some test messages
            Monitor.Log 'info' 'test' 'Test info message'
            Monitor.Log 'warning' 'test' 'Test warning message'
            Monitor.Log 'error' 'test' 'Test error message'
            
            ⍝ Get recent logs
            recent_logs ← Monitor.GetRecentLogs 10
            
            ⍝ Check if logs were captured
            :If 0<≢recent_logs
                result.status ← 'PASSED'
                result.message ← 'Monitoring system correctly captures log messages'
                result.details ← 'Captured ',⍕≢recent_logs,' log entries'
            :Else
                result.status ← 'FAILED'
                result.message ← 'Monitoring system failed to capture log messages'
            :EndIf
            
        :Case 11
            result.status ← 'ERROR'
            result.message ← 'Domain error in monitoring logging test: ',⎕DM
        :Case 22
            result.status ← 'ERROR'
            result.message ← 'File error in monitoring logging test: ',⎕DM
        :Else
            result.status ← 'ERROR'
            result.message ← 'Unexpected error in monitoring logging test: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← TestMonitoringWebhooks
    ⍝ Test webhook processing functionality
        result ← CreateTestResult 'Monitoring Webhooks'
        
        :Trap 11 22
            ⍝ Create mock webhook payload
            webhook_payload ← ⎕NS ''
            webhook_payload.repository ← ⎕NS ('name' 'test-repo')
            webhook_payload.head_commit ← ⎕NS ''
            webhook_payload.head_commit.id ← 'abc123'
            webhook_payload.head_commit.message ← 'Generated using Claude AI assistant'
            webhook_payload.head_commit.author ← ⎕NS ('name' 'testuser')
            
            ⍝ Process webhook
            webhook_result ← Monitor.ProcessWebhook webhook_payload
            
            :If webhook_result.processed ∧ webhook_result.ai_detected
                result.status ← 'PASSED'
                result.message ← 'Webhook processing correctly detects AI content'
                result.details ← 'AI score: ',⍕webhook_result.ai_score
            :Else
                result.status ← 'FAILED'
                result.message ← 'Webhook processing failed'
                result.details ← ⍕webhook_result
            :EndIf
            
        :Case 11
            result.status ← 'ERROR'
            result.message ← 'Domain error in monitoring webhooks test: ',⎕DM
        :Case 22
            result.status ← 'ERROR'
            result.message ← 'File error in monitoring webhooks test: ',⎕DM
        :Else
            result.status ← 'ERROR'
            result.message ← 'Unexpected error in monitoring webhooks test: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← TestMonitoringMetrics
    ⍝ Test metrics collection functionality
        result ← CreateTestResult 'Monitoring Metrics'
        
        :Trap 11 22
            ⍝ Get system metrics
            metrics ← Monitor.GetMetrics
            
            ⍝ Validate metrics structure
            has_timestamp ← 0≠metrics.⎕NC'timestamp'
            has_log_metrics ← 0≠metrics.⎕NC'log_metrics'
            has_system_metrics ← 0≠metrics.⎕NC'system_metrics'
            has_uptime ← 0≠metrics.⎕NC'uptime_seconds'
            
            :If has_timestamp ∧ has_log_metrics ∧ has_system_metrics ∧ has_uptime
                result.status ← 'PASSED'
                result.message ← 'Metrics collection provides complete data structure'
            :Else
                result.status ← 'FAILED'
                result.message ← 'Metrics collection missing required fields'
                result.details ← 'Timestamp: ',⍕has_timestamp,' LogMetrics: ',⍕has_log_metrics,' SystemMetrics: ',⍕has_system_metrics,' Uptime: ',⍕has_uptime
            :EndIf
            
        :Case 11
            result.status ← 'ERROR'
            result.message ← 'Domain error in monitoring metrics test: ',⎕DM
        :Case 22
            result.status ← 'ERROR'
            result.message ← 'File error in monitoring metrics test: ',⎕DM
        :Else
            result.status ← 'ERROR'
            result.message ← 'Unexpected error in monitoring metrics test: ',⎕DM
        :EndTrap
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Error Handling Unit Tests
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ result ← TestErrorHandlingClassification
    ⍝ Test error classification functionality
        result ← CreateTestResult 'Error Handling Classification'
        
        :Trap 11 22
            ⍝ Create test error info
            error_info ← ⎕NS ''
            error_info.error_number ← 11
            error_info.message ← 'Domain error in test'
            
            ⍝ Test error handling
            handling_result ← Config.HandleError error_info
            
            :If handling_result.handled ∧ (handling_result.error_type≡'DOMAIN_ERROR')
                result.status ← 'PASSED'
                result.message ← 'Error handling correctly classifies domain errors'
            :Else
                result.status ← 'FAILED'
                result.message ← 'Error handling failed to classify error correctly'
                result.details ← ⍕handling_result
            :EndIf
            
        :Case 11
            result.status ← 'ERROR'
            result.message ← 'Domain error in error handling classification test: ',⎕DM
        :Case 22
            result.status ← 'ERROR'
            result.message ← 'File error in error handling classification test: ',⎕DM
        :Else
            result.status ← 'ERROR'
            result.message ← 'Unexpected error in error handling classification test: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← TestErrorHandlingRecovery
    ⍝ Test error recovery functionality
        result ← CreateTestResult 'Error Handling Recovery'
        
        :Trap 11 22
            ⍝ Test configuration error recovery
            error_info ← ⎕NS ''
            error_info.error_number ← 22
            error_info.message ← 'File not found'
            
            ⍝ Test error handling with recovery
            handling_result ← Config.HandleError error_info
            
            :If handling_result.handled ∧ handling_result.recovery_success
                result.status ← 'PASSED'
                result.message ← 'Error handling includes recovery actions'
                result.details ← 'Recovery actions: ',⍕≢handling_result.recovery_actions
            :Else
                result.status ← 'FAILED'
                result.message ← 'Error handling failed to provide recovery'
                result.details ← ⍕handling_result
            :EndIf
            
        :Case 11
            result.status ← 'ERROR'
            result.message ← 'Domain error in error handling recovery test: ',⎕DM
        :Case 22
            result.status ← 'ERROR'
            result.message ← 'File error in error handling recovery test: ',⎕DM
        :Else
            result.status ← 'ERROR'
            result.message ← 'Unexpected error in error handling recovery test: ',⎕DM
        :EndTrap
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Integration Tests
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ result ← TestFullPipelineWorkflow
    ⍝ Test complete end-to-end pipeline workflow
        result ← CreateTestResult 'Full Pipeline Workflow'
        
        :Trap 11 22
            ⍝ Create test files
            test_files ← '/tmp/workflow1.dyalog' '/tmp/workflow2.dyalog'
            
            ⍝ Create valid APL content
            content1 ← ':Namespace Workflow1',⎕UCS 10,'    ProcessData ← {+/⍵}',⎕UCS 10,':EndNamespace'
            content2 ← ':Namespace Workflow2',⎕UCS 10,'    ⍝ Human written code',⎕UCS 10,'    AI ← +/∘(∨/¨)∘(⊂⍷¨⊂)',⎕UCS 10,':EndNamespace'
            content1 ⎕NPUT test_files[0] 1
            content2 ⎕NPUT test_files[1] 1
            
            ⍝ Run complete pipeline
            pipeline_result ← Pipeline.Run test_files
            
            ⍝ Cleanup
            ⎕NERASE¨test_files
            
            ⍝ Validate results
            validation_passed ← pipeline_result.validation.status≡'PASSED'
            security_passed ← pipeline_result.security.status≡'PASSED'
            quality_passed ← pipeline_result.quality.status≡'PASSED'
            
            :If validation_passed ∧ security_passed ∧ quality_passed
                result.status ← 'PASSED'
                result.message ← 'Full pipeline workflow executes successfully'
                result.details ← 'Duration: ',⍕pipeline_result.total_duration_ms,'ms'
            :Else
                result.status ← 'FAILED'
                result.message ← 'Full pipeline workflow failed'
                result.details ← 'Validation: ',⍕validation_passed,' Security: ',⍕security_passed,' Quality: ',⍕quality_passed
            :EndIf
            
        :Case 11
            result.status ← 'ERROR'
            result.message ← 'Domain error in full pipeline workflow test: ',⎕DM
        :Case 22
            result.status ← 'ERROR'
            result.message ← 'File error in full pipeline workflow test: ',⎕DM
        :Else
            result.status ← 'ERROR'
            result.message ← 'Unexpected error in full pipeline workflow test: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← TestModuleIntegration
    ⍝ Test module integration and communication
        result ← CreateTestResult 'Module Integration'
        
        :Trap 11 22
            ⍝ Test AI detection from pipeline
            ai_text ← 'Generated using Claude AI'
            ai_score ← Core.AI ai_text
            
            ⍝ Test configuration access from monitor
            config ← Config.Default
            Monitor.Log 'info' 'test' 'Integration test message'
            
            ⍝ Validate cross-module functionality
            ai_works ← (0≤ai_score≤1)
            config_works ← 0≠config.⎕NC'pipeline'
            
            :If ai_works ∧ config_works
                result.status ← 'PASSED'
                result.message ← 'Modules integrate and communicate correctly'
            :Else
                result.status ← 'FAILED'
                result.message ← 'Module integration failed'
                result.details ← 'AI works: ',⍕ai_works,' Config works: ',⍕config_works
            :EndIf
            
        :Case 11
            result.status ← 'ERROR'
            result.message ← 'Domain error in module integration test: ',⎕DM
        :Case 22
            result.status ← 'ERROR'
            result.message ← 'File error in module integration test: ',⎕DM
        :Else
            result.status ← 'ERROR'
            result.message ← 'Unexpected error in module integration test: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← TestConfigurationIntegration
    ⍝ Test configuration integration across modules
        result ← CreateTestResult 'Configuration Integration'
        
        :Trap 11 22
            ⍝ Load configuration
            config ← Config.Load 'nonexistent-file.json'  ⍝ Should create defaults
            
            ⍝ Test configuration test functionality
            test_result ← Config.TestConfiguration config
            
            :If test_result.success
                result.status ← 'PASSED'
                result.message ← 'Configuration integration works across modules'
                result.details ← 'Tests passed: ',⍕test_result.tests_passed
            :Else
                result.status ← 'FAILED'
                result.message ← 'Configuration integration failed'
                result.details ← ⍕test_result
            :EndIf
            
        :Case 11
            result.status ← 'ERROR'
            result.message ← 'Domain error in configuration integration test: ',⎕DM
        :Case 22
            result.status ← 'ERROR'
            result.message ← 'File error in configuration integration test: ',⎕DM
        :Else
            result.status ← 'ERROR'
            result.message ← 'Unexpected error in configuration integration test: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← TestMonitoringIntegration
    ⍝ Test monitoring integration with other modules
        result ← CreateTestResult 'Monitoring Integration'
        
        :Trap 11 22
            ⍝ Test monitoring with pipeline execution
            test_file ← '/tmp/monitor_integration.dyalog'
            content ← ':Namespace MonitorTest',⎕UCS 10,'    Test ← 1',⎕UCS 10,':EndNamespace'
            content ⎕NPUT test_file 1
            
            ⍝ Run pipeline with monitoring
            Monitor.Start
            validation_result ← Pipeline.ValidateFiles ⊂test_file
            
            ⍝ Check if monitoring captured pipeline activity
            metrics ← Monitor.GetMetrics
            
            ⍝ Cleanup
            ⎕NERASE test_file
            
            :If metrics.log_metrics.total_logs > 0
                result.status ← 'PASSED'
                result.message ← 'Monitoring integration captures pipeline activity'
                result.details ← 'Log entries: ',⍕metrics.log_metrics.total_logs
            :Else
                result.status ← 'FAILED'
                result.message ← 'Monitoring integration failed to capture activity'
            :EndIf
            
        :Case 11
            result.status ← 'ERROR'
            result.message ← 'Domain error in monitoring integration test: ',⎕DM
        :Case 22
            result.status ← 'ERROR'
            result.message ← 'File error in monitoring integration test: ',⎕DM
        :Else
            result.status ← 'ERROR'
            result.message ← 'Unexpected error in monitoring integration test: ',⎕DM
        :EndTrap
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Performance Tests
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ result ← TestAIDetectionPerformance
    ⍝ Test AI detection performance benchmarks
        result ← CreateTestResult 'AI Detection Performance'
        
        :Trap 11 22
            ⍝ Run performance benchmark
            perf_result ← Core.QuickBenchmark 500
            
            ⍝ Validate performance (should handle >100 ops/sec)
            :If perf_result.operations_per_second ≥ 100
                result.status ← 'PASSED'
                result.message ← 'AI detection meets performance requirements'
                result.details ← ⍕⌊perf_result.operations_per_second,' ops/sec'
            :Else
                result.status ← 'FAILED'
                result.message ← 'AI detection performance below threshold'
                result.details ← ⍕⌊perf_result.operations_per_second,' ops/sec (need >100)'
            :EndIf
            
        :Case 11
            result.status ← 'ERROR'
            result.message ← 'Domain error in AI detection performance test: ',⎕DM
        :Case 22
            result.status ← 'ERROR'
            result.message ← 'File error in AI detection performance test: ',⎕DM
        :Else
            result.status ← 'ERROR'
            result.message ← 'Unexpected error in AI detection performance test: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← TestPipelinePerformance
    ⍝ Test pipeline execution performance
        result ← CreateTestResult 'Pipeline Performance'
        
        :Trap 11 22
            ⍝ Create test files
            test_files ← '/tmp/perf1.dyalog' '/tmp/perf2.dyalog' '/tmp/perf3.dyalog'
            content ← ':Namespace PerfTest',⎕UCS 10,'    Test ← 1',⎕UCS 10,':EndNamespace'
            content ⎕NPUT¨test_files
            
            ⍝ Time pipeline execution
            start_time ← ⎕AI[3]
            pipeline_result ← Pipeline.Run test_files
            elapsed_ms ← ⎕AI[3] - start_time
            
            ⍝ Cleanup
            ⎕NERASE¨test_files
            
            ⍝ Validate performance (should complete in <5000ms for 3 files)
            :If elapsed_ms ≤ 5000
                result.status ← 'PASSED'
                result.message ← 'Pipeline performance meets requirements'
                result.details ← ⍕elapsed_ms,'ms for 3 files'
            :Else
                result.status ← 'FAILED'
                result.message ← 'Pipeline performance too slow'
                result.details ← ⍕elapsed_ms,'ms (need <5000ms)'
            :EndIf
            
        :Case 11
            result.status ← 'ERROR'
            result.message ← 'Domain error in pipeline performance test: ',⎕DM
        :Case 22
            result.status ← 'ERROR'
            result.message ← 'File error in pipeline performance test: ',⎕DM
        :Else
            result.status ← 'ERROR'
            result.message ← 'Unexpected error in pipeline performance test: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← TestMemoryUsage
    ⍝ Test system memory usage
        result ← CreateTestResult 'Memory Usage'
        
        :Trap 11 22
            ⍝ Get initial workspace size
            initial_ws ← ⎕SIZE
            
            ⍝ Process multiple files
            test_files ← ('/tmp/mem_test',⍕⍵,'.dyalog')¨⍳10
            content ← ':Namespace MemTest',⎕UCS 10,'    Data ← ⍳1000',⎕UCS 10,':EndNamespace'
            content ⎕NPUT¨test_files
            
            ⍝ Run pipeline on all files
            pipeline_result ← Pipeline.Run test_files
            
            ⍝ Check workspace size
            final_ws ← ⎕SIZE
            memory_increase ← final_ws - initial_ws
            
            ⍝ Cleanup
            ⎕NERASE¨test_files
            
            ⍝ Validate memory usage (increase should be reasonable)
            :If memory_increase ≤ 100000  ⍝ Less than 100KB increase
                result.status ← 'PASSED'
                result.message ← 'Memory usage within acceptable limits'
                result.details ← 'Memory increase: ',⍕memory_increase,' bytes'
            :Else
                result.status ← 'WARNING'
                result.message ← 'Memory usage higher than expected'
                result.details ← 'Memory increase: ',⍕memory_increase,' bytes'
            :EndIf
            
        :Case 11
            result.status ← 'ERROR'
            result.message ← 'Domain error in memory usage test: ',⎕DM
        :Case 22
            result.status ← 'ERROR'
            result.message ← 'File error in memory usage test: ',⎕DM
        :Else
            result.status ← 'ERROR'
            result.message ← 'Unexpected error in memory usage test: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← TestScalability
    ⍝ Test system scalability with increasing load
        result ← CreateTestResult 'Scalability'
        
        :Trap 11 22
            ⍝ Test AI detection with batch processing
            test_texts ← ('Test message ',⍕⍵)¨⍳100
            
            ⍝ Time batch processing
            start_time ← ⎕AI[3]
            batch_results ← Core.ProcessBatch test_texts
            elapsed_ms ← ⎕AI[3] - start_time
            
            ⍝ Calculate throughput
            throughput ← (≢test_texts) ÷ (elapsed_ms÷1000)⌈0.001
            
            ⍝ Validate scalability (should handle >50 texts/sec)
            :If throughput ≥ 50
                result.status ← 'PASSED'
                result.message ← 'System scales well with increased load'
                result.details ← ⍕⌊throughput,' texts/sec'
            :Else
                result.status ← 'FAILED'
                result.message ← 'System scalability below threshold'
                result.details ← ⍕⌊throughput,' texts/sec (need >50)'
            :EndIf
            
        :Case 11
            result.status ← 'ERROR'
            result.message ← 'Domain error in scalability test: ',⎕DM
        :Case 22
            result.status ← 'ERROR'
            result.message ← 'File error in scalability test: ',⎕DM
        :Else
            result.status ← 'ERROR'
            result.message ← 'Unexpected error in scalability test: ',⎕DM
        :EndTrap
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Test Infrastructure Functions
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ test_result ← CreateTestResult test_name
    ⍝ Create standardized test result structure
        test_result ← ⎕NS ''
        test_result.name ← test_name
        test_result.timestamp ← ⎕TS
        test_result.status ← 'UNKNOWN'
        test_result.message ← ''
        test_result.details ← ''
    ∇

    ∇ AddTestResult test_result
    ⍝ Add test result to tracking and update counters
        TestResults ,← ⊂test_result
        TotalTests +← 1
        
        :Select test_result.status
        :Case 'PASSED'
            PassedTests +← 1
            ⎕←'  ✅ ',test_result.name,': ',test_result.message
        :Case 'FAILED'
            FailedTests +← 1
            ⎕←'  ❌ ',test_result.name,': ',test_result.message
            :If 0<≢test_result.details
                ⎕←'     Details: ',test_result.details
            :EndIf
        :Case 'WARNING'
            ⎕←'  ⚠️ ',test_result.name,': ',test_result.message
            :If 0<≢test_result.details
                ⎕←'     Details: ',test_result.details
            :EndIf
        :Case 'ERROR'
            FailedTests +← 1
            ⎕←'  🔥 ',test_result.name,': ',test_result.message
        :Else
            FailedTests +← 1
            ⎕←'  ❓ ',test_result.name,': Unknown result'
        :EndSelect
    ∇

    ∇ GenerateTestReport elapsed_ms
    ⍝ Generate comprehensive test report
        ⎕←''
        ⎕←'📊 APLCICD v2.0 Test Results'
        ⎕←'============================'
        ⎕←''
        ⎕←'Overall Statistics:'
        ⎕←'  Total Tests: ',⍕TotalTests
        ⎕←'  Passed: ',⍕PassedTests,' (',⍕⌊100×PassedTests÷TotalTests⌈1,'%)'
        ⎕←'  Failed: ',⍕FailedTests,' (',⍕⌊100×FailedTests÷TotalTests⌈1,'%)'
        ⎕←'  Success Rate: ',⍕⌊100×PassedTests÷TotalTests⌈1,'%'
        ⎕←'  Execution Time: ',⍕⌊elapsed_ms÷1000,'.',⍕3↑1000⊥elapsed_ms,' seconds'
        ⎕←''
        
        ⍝ Categorize results
        passed_tests ← (⊂'PASSED')≡¨(⊂'status')⊃¨TestResults
        failed_tests ← (⊂'FAILED')≡¨(⊂'status')⊃¨TestResults
        error_tests ← (⊂'ERROR')≡¨(⊂'status')⊃¨TestResults
        
        :If 0<+/failed_tests
            ⎕←'❌ Failed Tests:'
            failed_names ← (⊂'name')⊃¨failed_tests/TestResults
            ⎕←'  ',⍪failed_names
            ⎕←''
        :EndIf
        
        :If 0<+/error_tests
            ⎕←'🔥 Error Tests:'
            error_names ← (⊂'name')⊃¨error_tests/TestResults
            ⎕←'  ',⍪error_names
            ⎕←''
        :EndIf
        
        ⍝ Overall assessment
        success_rate ← PassedTests÷TotalTests⌈1
        :If success_rate ≥ 0.95
            ⎕←'🎯 EXCELLENT: System passes 95%+ of tests and is production ready!'
        :ElseIf success_rate ≥ 0.85
            ⎕←'✅ GOOD: System passes 85%+ of tests with minor issues to address'
        :ElseIf success_rate ≥ 0.70
            ⎕←'⚠️ ACCEPTABLE: System passes 70%+ of tests but needs improvement'
        :Else
            ⎕←'❌ CRITICAL: System fails too many tests and requires significant work'
        :EndIf
        
        ⎕←''
        ⎕←'Test coverage: Unit Tests, Integration Tests, Performance Tests'
        ⎕←'Framework: APLCICD v2.0 Native Testing Framework'
    ∇

:EndNamespace
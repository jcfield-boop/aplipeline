:Namespace Tests
⍝ APLCICD Test Suite
⍝ Unit and integration tests

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize Tests namespace
        ⎕←'  ✅ Test functions loaded'
    ∇

    ∇ result ← RunAll
    ⍝ Run complete test suite
        ⎕←'🧪 APLCICD Test Suite'
        ⎕←'===================='
        ⎕←''
        
        failures ← 0
        failures +← TestAIDetection
        failures +← TestPerformance
        failures +← TestServer
        failures +← TestIntegration
        
        ⎕←''
        :If failures = 0
            ⎕←'✅ All tests passed!'
            result ← 1
        :Else
            ⎕←'❌ ',⍕failures,' test(s) failed'
            result ← 0
        :EndIf
    ∇

    ∇ failures ← TestAIDetection
    ⍝ Test AI detection functions
        ⎕←'Testing AI Detection...'
        failures ← 0
        
        ⍝ Test basic detection
        human_text ← 'Fix authentication bug'
        ai_text ← 'Generated using Claude AI'
        
        human_score ← Core.Detect human_text
        ai_score ← Core.Detect ai_text
        
        :If ai_score ≤ human_score
            ⎕←'  ❌ AI detection failed: AI score should be higher'
            failures +← 1
        :Else
            ⎕←'  ✅ Basic AI detection works'
        :EndIf
        
        ⍝ Test enhanced detection
        enhanced_human ← Core.Enhanced human_text
        enhanced_ai ← Core.Enhanced ai_text
        
        :If enhanced_ai ≤ enhanced_human
            ⎕←'  ❌ Enhanced detection failed'
            failures +← 1
        :Else
            ⎕←'  ✅ Enhanced AI detection works'
        :EndIf
    ∇

    ∇ failures ← TestPerformance  
    ⍝ Test performance functions
        ⎕←'Testing Performance...'
        failures ← 0
        
        ⍝ Test benchmark runs without error
        :Trap 0
            rate ← Analysis.QuickBenchmark 100
            :If rate > 0
                ⎕←'  ✅ Performance benchmark works'
            :Else
                ⎕←'  ❌ Invalid performance rate'
                failures +← 1
            :EndIf
        :Else
            ⎕←'  ❌ Performance benchmark failed'
            failures +← 1
        :EndTrap
    ∇

    ∇ failures ← TestServer
    ⍝ Test server functions
        ⎕←'Testing Server...'
        failures ← 0
        
        ⍝ Test webhook processing
        :Trap 0
            result ← Server.ProcessWebhook 'test_payload'
            :If (⊃result.⎕NL 2)∊⊂'ai_score'
                ⎕←'  ✅ Webhook processing works'
            :Else
                ⎕←'  ❌ Webhook result incomplete'
                failures +← 1
            :EndIf
        :Else
            ⎕←'  ❌ Server test failed'
            failures +← 1
        :EndTrap
    ∇

    ∇ failures ← TestIntegration
    ⍝ Test integration between components
        ⎕←'Testing Integration...'
        failures ← 0
        
        ⍝ Test workflow: text → detection → classification
        test_texts ← 'Human code' 'AI-generated code'
        
        :Trap 0
            scores ← Core.ProcessBatch test_texts
            sorted ← Core.SortByAI test_texts
            
            :If (≢scores) = (≢test_texts)
                ⎕←'  ✅ Batch processing works'
            :Else
                ⎕←'  ❌ Batch processing failed'
                failures +← 1
            :EndIf
            
            :If (≢sorted) = (≢test_texts)
                ⎕←'  ✅ Sorting works'
            :Else
                ⎕←'  ❌ Sorting failed'
                failures +← 1
            :EndIf
        :Else
            ⎕←'  ❌ Integration test failed'
            failures +← 1
        :EndTrap
    ∇

    ∇ BenchmarkTests
    ⍝ Performance benchmark for tests
        ⎕←'⏱️ Test Performance Benchmark'
        ⎕←'============================'
        
        start ← ⎕AI[3]
        result ← RunAll
        elapsed ← (⎕AI[3]-start)÷1000
        
        ⎕←'Test suite completed in ',⍕elapsed,' seconds'
        ⎕←'Result: ',(result)⊃'FAILED' 'PASSED'
    ∇

:EndNamespace
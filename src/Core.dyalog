:Namespace Core
⍝ APLCICD.Core - Legacy Module (Superseded by vibe.dyalog)
⍝ 
⍝ Focus: Basic utilities and legacy functions
⍝ Note: Main functionality moved to vibe.dyalog for LLM co-creation optimization
⍝ 
⍝ Public Functions:
⍝   Initialize                 - Module initialization
⍝   BenchmarkPerformance n     - Performance benchmarking utilities

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize Core module (legacy)
        ⎕←'  ✅ Core legacy utilities loaded (main functionality in vibe.dyalog)'
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Legacy Functions (Moved to vibe.dyalog)
    ⍝ ═══════════════════════════════════════════════════════════════
    
    ∇ LegacyNote
    ⍝ AI detection functionality has been removed
    ⍝ Focus shifted to vibe coding for LLM co-creation optimization
    ⍝ See vibe.dyalog for ultra-concise compression features
        ⎕←'ℹ️  AI detection removed - see vibe.dyalog for LLM co-creation features'
    ∇


    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Performance Analysis and Benchmarking
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ BenchmarkPerformance iterations
    ⍝ Basic performance benchmark utilities
    ⍝ 
    ⍝ Arguments:
    ⍝   iterations (numeric): Number of test iterations
        
        :If 0=⎕NC'iterations' ⋄ iterations ← 1000 ⋄ :EndIf
        
        ⎕←'🚀 Basic Performance Benchmark'
        ⎕←'=============================='
        ⎕←'Iterations: ',⍕iterations
        ⎕←''
        
        ⍝ Test basic APL operations
        start ← ⎕AI[3]
        results ← (+/⍳¨iterations⍴100)
        elapsed ← (⎕AI[3]-start)÷1000
        
        ⎕←'APL Array Operations:'
        ⎕←'   Time: ',⍕elapsed,' seconds'
        ⎕←'   Ops/sec: ',⍕⌊iterations÷elapsed⌈0.001
        ⎕←'   Note: Main functionality moved to vibe.dyalog'
    ∇

    ∇ result ← QuickBenchmark n
    ⍝ Quick performance test for basic operations
        :If 0=⎕NC'n' ⋄ n ← 100 ⋄ :EndIf
        
        start_time ← ⎕AI[3]
        
        ⍝ Run n iterations of basic APL operations
        results ← +/⍳¨n⍴1000
        
        elapsed ← (⎕AI[3]-start_time)÷1000
        ops_per_sec ← n÷elapsed⌈0.001
        
        result ← ⎕NS ''
        result.iterations ← n
        result.elapsed_seconds ← elapsed
        result.operations_per_second ← ops_per_sec
        
        ⎕←'Quick Benchmark: ',⍕⌊ops_per_sec,' ops/sec (',⍕n,' iterations)'
        ⎕←'Note: Main performance features in vibe.dyalog'
    ∇

:EndNamespace
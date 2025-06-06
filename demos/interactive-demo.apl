⍝ Load dependencies
]load apl-ci-core.apl
]load json-interface.apl
]load demo-data.apl
]load visualizer.apl

∇ RunDemo;prs;results;start;elapsed;batch_size;batches;i;batch
    ⎕IO ← 0
    ⎕← 'APL CI/CD Demo - AI Code Processing System'
    ⎕← 'Dyalog APL Forge Contest Entry'
    ⎕← ''
    
    ⍝ Generate demo PRs
    ⎕← 'Generating 100 AI pull requests...'
    prs ← GenerateDemoPRs 100
    ⎕DL 1
    
    ⍝ Show initial state
    ShowPipelineProgress 0 100
    ⎕DL 0.5
    
    ⍝ Process in batches with visualization
    start ← ⎕AI[3]
    batch_size ← 10
    batches ← batch_size÷⍨≢prs
    results ← ⍬
    
    :For i :In ⍳batches
        batch ← (i×batch_size)+⍳batch_size
        ShowPipelineProgress ((i+1)×batch_size) 100
        results ,← #.APLCI.BatchProcess batch⊃¨prs
        ⎕DL 0.2
    :EndFor
    
    elapsed ← (⎕AI[3]-start)÷1000
    
    ⍝ Show final results
    ⎕← ''
    ShowBatchResults ↑results
    ShowPatternAnalysis prs
    ComparePerformance
    
    ⎕← ''
    ⎕← 'Total processing time: ',(2⍕elapsed),' seconds'
    ⎕← 'Average per PR: ',(4⍕1000×elapsed÷≢prs),' ms'
    ⎕← ''
    ⎕← 50⍴'─'
∇

∇ RunPipelineExample;config;pr;result
    ⎕← 'Single Pipeline Example:'
    ⎕← ''
    
    ⍝ Create sample PR
    pr ← ⊃GenerateDemoPRs 1
    
    ⍝ Create pipeline config
    config ← ⎕NS ''
    config.steps ← 'lint' 'ai-review' 'test' 'build'
    config.pr ← pr
    
    ⍝ Run pipeline
    result ← #.APLCI.Pipeline config
    
    ⍝ Show results
    ⎕← 'Pipeline completed for PR: ',pr.id
    ⎕← 'Lint passed: ',⍕result.lint_passed
    ⎕← 'AI Score: ',2⍕result.ai_score
    ⎕← 'Tests passed: ',⍕result.tests_passed
    ⎕← 'Build success: ',⍕result.build_success
∇

⍝ Run the demo when loaded
RunDemo
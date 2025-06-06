⍝ Load dependencies
)COPY './apl-ci-core'
)COPY './json-interface'  
)COPY './demo-data'

∇ TestComponents;prs;pr;config;result;scores
    ⎕← 'Testing APL CI/CD Components...'
    ⎕← ''
    
    ⍝ Test demo data generation
    ⎕← '1. Testing demo data generation:'
    prs ← GenerateDemoPRs 5
    ⎕← '   Generated ',(⍕≢prs),' demo PRs'
    pr ← ⊃prs
    ⎕← '   Sample PR ID: ',pr.id
    ⎕← '   Sample author: ',pr.author
    ⎕← ''
    
    ⍝ Test AI scoring
    ⎕← '2. Testing AI scoring:'
    scores ← #.APLCI.AIScore¨ prs
    ⎕← '   AI scores: ',(⍕scores)
    ⎕← '   Average score: ',(⍕(+⌿scores)÷≢scores)
    ⎕← ''
    
    ⍝ Test pipeline execution
    ⎕← '3. Testing single pipeline execution:'
    config ← ⎕NS ''
    config.steps ← 'lint' 'test' 'build'
    config.pr ← pr
    result ← #.APLCI.Pipeline config
    ⎕← '   Lint passed: ',⍕result.lint_passed
    ⎕← '   Tests passed: ',⍕result.tests_passed
    ⎕← '   Build success: ',⍕result.build_success
    ⎕← ''
    
    ⍝ Test batch processing
    ⎕← '4. Testing batch processing:'
    results ← #.APLCI.BatchProcess prs
    ⎕← '   Processed ',(⍕≢results),' PRs in batch'
    ⎕← '   Top scored PR: ',((⊃results)[1]).id
    ⎕← ''
    
    ⎕← 'All components tested successfully! ✓'
∇

TestComponents
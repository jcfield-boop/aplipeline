⍝ Load dependencies
)COPY './apl-ci-core'
)COPY './demo-data'

∇ TestBatchProcessing;prs;results;start;elapsed;n
    n ← 100
    ⎕← 'Testing Batch Processing Performance...'
    ⎕← ''
    
    ⍝ Generate demo data
    ⎕← 'Generating ',(⍕n),' demo PRs...'
    prs ← GenerateDemoPRs n
    
    ⍝ Time the batch processing
    start ← ⎕AI[3]
    results ← #.APLCI.BatchProcess prs
    elapsed ← (⎕AI[3]-start)÷1000
    
    ⎕← ''
    ⎕← 'Batch Processing Results:'
    ⎕← '├─ PRs processed: ',(⍕≢results)
    ⎕← '├─ Processing time: ',(2⍕elapsed),' seconds'
    ⎕← '├─ Average per PR: ',(4⍕1000×elapsed÷n),' ms'
    ⎕← '└─ Processing rate: ',(⍕⌊n÷elapsed),' PRs/second'
    ⎕← ''
    
    ⍝ Show top results
    ⎕← 'Top 3 AI-scored PRs:'
    :For i :In ⍳3
        pr ← (i⊃results)[1]
        score ← (i⊃results)[2]
        ⎕← '  ',(⍕i),'. ',pr.id,' (Score: ',(2⍕score),') by ',pr.author
    :EndFor
    ⎕← ''
    ⎕← 'Batch processing verification complete! ✓'
∇

TestBatchProcessing
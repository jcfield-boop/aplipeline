:Namespace Examples
⍝ APLCICD Usage Examples
⍝ Practical examples and tutorials

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize Examples namespace
        ⎕←'  ✅ Example functions loaded'
    ∇

    ∇ Basic
    ⍝ Basic usage examples
        ⎕←'📚 Basic APLCICD Examples'
        ⎕←'========================'
        ⎕←''
        
        ⎕←'1. Simple AI Detection:'
        ⎕←'   text ← "Generated using Claude AI"'
        ⎕←'   score ← Core.Detect text'
        text ← 'Generated using Claude AI'
        score ← Core.Detect text
        ⎕←'   Result: ',⍕score
        ⎕←''
        
        ⎕←'2. Batch Processing:'
        ⎕←'   texts ← "Fix bug" "AI assistance" "Manual work"'
        ⎕←'   scores ← Core.ProcessBatch texts'
        texts ← 'Fix bug' 'AI assistance' 'Manual work'
        scores ← Core.ProcessBatch texts
        ⎕←'   Results: ',⍕scores
        ⎕←''
        
        ⎕←'3. Enhanced Detection:'
        ⎕←'   enhanced ← Core.Enhanced "Thank you for your question"'
        enhanced ← Core.Enhanced 'Thank you for your question'
        ⎕←'   Result: ',⍕enhanced
    ∇

    ∇ Advanced
    ⍝ Advanced usage examples
        ⎕←'🎓 Advanced APLCICD Examples'
        ⎕←'==========================='
        ⎕←''
        
        ⎕←'1. Performance Analysis:'
        ⎕←'   Analysis.DetailedBenchmark 5000'
        rate ← Analysis.DetailedBenchmark 5000
        ⎕←''
        
        ⎕←'2. Statistical Analysis:'
        ⎕←'   Analysis.ShowStatistics sample_texts'
        sample_texts ← 'Human code' 'AI generated' 'Mixed content'
        Analysis.ShowStatistics sample_texts
        ⎕←''
        
        ⎕←'3. Server Integration:'
        ⎕←'   Server.StartDemo 8080'
        Server.StartDemo 8080
    ∇

    ∇ WorkflowExample
    ⍝ Complete workflow example
        ⎕←'🔄 Complete Workflow Example'
        ⎕←'=========================='
        ⎕←''
        
        ⎕←'Scenario: Processing GitHub pull requests'
        ⎕←''
        
        ⍝ Sample PR data
        prs ← ⍬
        prs ,← ⊂'Fix authentication bug in login system'
        prs ,← ⊂'Generated code using AI assistance for new feature'
        prs ,← ⊂'Refactor database queries for better performance'
        prs ,← ⊂'AI-generated tests with comprehensive coverage'
        
        ⎕←'Step 1: Analyze all PRs'
        scores ← Core.ProcessBatch prs
        
        ⎕←'Step 2: Classify results'
        :For i :In ⍳≢prs
            pr ← (i-1)⊃prs
            score ← (i-1)⊃scores
            classification ← (score>0.3)⊃'Human' 'AI-Generated'
            ⎕←'  PR: "',(40↑pr),'" → ',classification,' (',⍕score,')'
        :EndFor
        
        ⎕←''
        ⎕←'Step 3: Sort by AI probability'
        sorted ← Core.SortByAI prs
        ⎕←'Sorted PRs (low to high AI probability):'
        :For pr :In sorted
            ⎕←'  ',pr
        :EndFor
        
        ⎕←''
        ⎕←'Step 4: Performance metrics'
        ⎕←'Processed ',⍕≢prs,' PRs instantly'
        ⎕←'APL vectorization advantage demonstrated'
    ∇

    ∇ CustomizationExample
    ⍝ Show how to customize detection
        ⎕←'🔧 Customization Example'
        ⎕←'======================='
        ⎕←''
        
        ⎕←'Custom detection function:'
        ⎕←'MyAI ← {keywords ← "custom" "patterns" ⋄ (+/∘(∨/¨)∘(⊂⍷¨⊂)) ⍵ keywords}'
        
        ⍝ Define custom function
        MyAI ← {keywords ← 'custom' 'patterns' ⋄ (+/∘(∨/¨)∘(⊂⍷¨⊂)) ⍵ keywords}
        
        test_text ← 'This has custom patterns in the text'
        result ← MyAI test_text
        
        ⎕←'Test: "',test_text,'"'
        ⎕←'Custom result: ',⍕result
        ⎕←''
        ⎕←'Demonstrate APL''s flexibility for domain-specific needs'
    ∇

    ∇ IntegrationExample
    ⍝ Integration with external systems
        ⎕←'🔗 Integration Example'
        ⎕←'===================='
        ⎕←''
        
        ⎕←'GitHub Webhook Processing:'
        ⎕←''
        
        ⍝ Simulate webhook data
        webhook_data ← ⎕NS ''
        webhook_data.action ← 'opened'
        webhook_data.pull_request ← ⎕NS ''
        webhook_data.pull_request.title ← 'Add AI-powered feature'
        webhook_data.pull_request.body ← 'Generated using Claude AI assistance'
        
        ⎕←'1. Receive webhook'
        ⎕←'   Action: ',webhook_data.action
        ⎕←'   Title: ',webhook_data.pull_request.title
        ⎕←''
        
        ⎕←'2. Process with APL'
        result ← Server.ProcessWebhook webhook_data
        ⎕←''
        
        ⎕←'3. Take action based on result'
        :If result.ai_score > 0.5
            ⎕←'   → Flag for AI review'
            ⎕←'   → Add "ai-generated" label'
        :Else
            ⎕←'   → Standard review process'
        :EndIf
    ∇

    ∇ Help
    ⍝ Help and documentation
        ⎕←'❓ APLCICD Examples Help'
        ⎕←'======================'
        ⎕←''
        ⎕←'Available examples:'
        ⎕←'  Examples.Basic            - Basic usage patterns'
        ⎕←'  Examples.Advanced         - Advanced features'
        ⎕←'  Examples.WorkflowExample  - Complete workflow'
        ⎕←'  Examples.CustomizationExample - Customization'
        ⎕←'  Examples.IntegrationExample   - External integration'
        ⎕←''
        ⎕←'Quick start:'
        ⎕←'  1. APLCICD.Initialize'
        ⎕←'  2. Examples.Basic'
        ⎕←'  3. Demo.Contest'
        ⎕←''
        ⎕←'For more help: APLCICD.Help'
    ∇

:EndNamespace
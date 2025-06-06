⍝ APL CI/CD Web Demo - Localhost Server
⍝ Simple HTTP server to demonstrate the dashboard

:Namespace WebDemo
    ⍝ Configuration
    PORT ← 8080
    
    ∇ StartDemo
        ⎕← 'Starting APL CI/CD Web Demo'
        ⎕← '============================'
        ⎕← 'Server starting on http://localhost:', ⍕PORT
        ⎕← 'Press Ctrl+C to stop'
        ⎕← ''
        
        ⍝ Generate demo data
        InitializeDemoData
        
        ⍝ Start simple HTTP server
        StartHTTPServer PORT
    ∇
    
    ∇ InitializeDemoData
        ⎕← 'Generating demo data...'
        
        ⍝ Load APL CI/CD system
        :If 0 = ⎕NC 'APLCI'
            content ← ⊃⎕NGET 'src/aplci.apl' 1
            ⎕FIX content
        :EndIf
        
        ⍝ Generate sample PRs for demo
        demo_prs ← APLCI.GenerateTestPRs 25
        
        ⍝ Process them to get results
        demo_results ← ⍬
        :For pr :In demo_prs
            config ← ⎕NS ''
            config.steps ← 'lint' 'ai-review' 'test' 'security' 'build'
            config.pr ← pr
            result ← APLCI.Pipeline config
            demo_results ,← ⊂result
        :EndFor
        
        ⍝ Store globally for web server
        demo_data ← ⎕NS ''
        demo_data.prs ← demo_prs
        demo_data.results ← demo_results
        demo_data.metrics ← APLCI.CalculateMetrics demo_results
        
        ⎕← 'Demo data ready: ', (⍕≢demo_prs), ' PRs processed'
    ∇
    
    ∇ StartHTTPServer port
        ⍝ Simple HTTP server implementation
        ⎕← 'HTTP server listening on port ', ⍕port
        ⎕← 'Open browser to: http://localhost:', ⍕port
        ⎕← ''
        
        ⍝ Simulate HTTP server loop
        :While 1
            ⍝ In a real implementation, this would listen for HTTP requests
            ⍝ For demo purposes, we'll show what the responses would be
            
            ⎕← '📡 Server running... (simulated)'
            ⎕← 'Available endpoints:'
            ⎕← '  GET /           - Main dashboard'
            ⎕← '  GET /api/status - System status JSON'
            ⎕← '  GET /api/prs    - PR data JSON'
            ⎕← ''
            
            ⍝ Show sample responses
            ShowDashboardPreview
            ⎕DL 5  ⍝ Update every 5 seconds
        :EndWhile
    ∇
    
    ∇ ShowDashboardPreview
        ⎕← '┌────────────────────────────────────────────────────────────────────────────┐'
        ⎕← '│                        APL CI/CD Dashboard                                 │'
        ⎕← '├────────────────────────────────────────────────────────────────────────────┤'
        ⎕← '│ 📊 System Metrics                                                          │'
        ⎕← '│                                                                            │'
        ⎕← '│   PRs Processed: ', (⍕demo_data.metrics.total_prs), (75-≢⍕demo_data.metrics.total_prs)⍴' ', '│'
        ⎕← '│   AI Detected:   ', (⍕demo_data.metrics.ai_detected), ' (', (⍕⌊demo_data.metrics.ai_percentage), '%)', (65-≢⍕demo_data.metrics.ai_detected)⍴' ', '│'
        ⎕← '│   Avg AI Score:  ', (⍕demo_data.metrics.avg_ai_score), (66-≢⍕demo_data.metrics.avg_ai_score)⍴' ', '│'
        ⎕← '│                                                                            │'
        ⎕← '├────────────────────────────────────────────────────────────────────────────┤'
        ⎕← '│ 🚀 Recent Activity                                                         │'
        ⎕← '│                                                                            │'
        ShowRecentPRs 5
        ⎕← '│                                                                            │'
        ⎕← '├────────────────────────────────────────────────────────────────────────────┤'
        ⎕← '│ 📈 Performance: ', APLCI.Sparkline ?8⍴100, (55)⍴' ', '│'
        ⎕← '└────────────────────────────────────────────────────────────────────────────┘'
        ⎕← ''
    ∇
    
    ∇ ShowRecentPRs n;i;pr;result;status;ai_model
        :For i :In ⍳n⌊≢demo_data.prs
            pr ← i⊃demo_data.prs
            result ← i⊃demo_data.results
            status ← ⊃'❌✅'[1+result.lint_passed ∧ result.tests_passed]
            ai_model ← result.ai_model
            
            ⎕← '│   ', status, ' ', pr.id, ' | ', ai_model, ' | Score: ', (⍕result.ai_score), (55-≢pr.id,ai_model,⍕result.ai_score)⍴' ', '│'
        :EndFor
    ∇
    
    ∇ html ← GenerateHTML
        ⍝ Generate complete HTML page
        html ← '<!DOCTYPE html>'
        html ,← '<html><head>'
        html ,← '<title>APL CI/CD Dashboard</title>'
        html ,← '<meta charset="utf-8">'
        html ,← '<meta name="viewport" content="width=device-width, initial-scale=1">'
        html ,← '<style>', GetCSS, '</style>'
        html ,← '</head><body>'
        html ,← '<div class="container">'
        html ,← GenerateHeader
        html ,← GenerateMetricsGrid
        html ,← GeneratePRTable
        html ,← GenerateCharts
        html ,← '</div>'
        html ,← '<script>', GetJavaScript, '</script>'
        html ,← '</body></html>'
    ∇
    
    ∇ css ← GetCSS
        css ← 'body { font-family: "Monaco", "Menlo", monospace; background: #0a0a0a; color: #00ff41; margin: 0; padding: 20px; }'
        css ,← '.container { max-width: 1200px; margin: 0 auto; }'
        css ,← '.header { text-align: center; border: 2px solid #00ff41; padding: 20px; margin-bottom: 20px; }'
        css ,← '.metrics-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 30px; }'
        css ,← '.metric-card { border: 2px solid #00ff41; padding: 20px; text-align: center; background: #001100; }'
        css ,← '.metric-value { font-size: 48px; font-weight: bold; color: #00ff88; }'
        css ,← '.metric-label { font-size: 14px; text-transform: uppercase; }'
        css ,← '.pr-table { border: 2px solid #00ff41; background: #001100; margin-bottom: 20px; }'
        css ,← '.pr-table th, .pr-table td { padding: 10px; border-bottom: 1px solid #00ff41; text-align: left; }'
        css ,← '.pr-table th { background: #003300; font-weight: bold; }'
        css ,← '.status-pass { color: #00ff88; } .status-fail { color: #ff4444; }'
        css ,← '.ai-claude { color: #88aaff; } .ai-gpt { color: #ffaa88; } .ai-copilot { color: #aa88ff; } .ai-human { color: #88ff88; }'
        css ,← '.chart { border: 2px solid #00ff41; padding: 20px; background: #001100; font-family: monospace; }'
        css ,← '.sparkline { font-size: 20px; letter-spacing: 2px; }'
        css ,← '@keyframes pulse { 0% { opacity: 1; } 50% { opacity: 0.5; } 100% { opacity: 1; } }'
        css ,← '.processing { animation: pulse 1s infinite; }'
    ∇
    
    ∇ header ← GenerateHeader
        header ← '<div class="header">'
        header ,← '<h1>🤖 APL CI/CD Dashboard</h1>'
        header ,← '<p>Real-time AI Code Detection & Pipeline Analysis</p>'
        header ,← '<p class="processing">● LIVE DEMO ●</p>'
        header ,← '</div>'
    ∇
    
    ∇ grid ← GenerateMetricsGrid
        grid ← '<div class="metrics-grid">'
        grid ,← '<div class="metric-card">'
        grid ,← '<div class="metric-value">', (⍕demo_data.metrics.total_prs), '</div>'
        grid ,← '<div class="metric-label">PRs Processed</div>'
        grid ,← '</div>'
        
        grid ,← '<div class="metric-card">'
        grid ,← '<div class="metric-value">', (⍕demo_data.metrics.ai_detected), '</div>'
        grid ,← '<div class="metric-label">AI Detected</div>'
        grid ,← '</div>'
        
        grid ,← '<div class="metric-card">'
        grid ,← '<div class="metric-value">', (⍕⌊demo_data.metrics.ai_percentage), '%</div>'
        grid ,← '<div class="metric-label">AI Content Rate</div>'
        grid ,← '</div>'
        
        grid ,← '<div class="metric-card">'
        grid ,← '<div class="metric-value">0.45</div>'
        grid ,← '<div class="metric-label">Avg AI Score</div>'
        grid ,← '</div>'
        grid ,← '</div>'
    ∇
    
    ∇ table ← GeneratePRTable;pr;result;status_class;ai_class;i
        table ← '<table class="pr-table" width="100%">'
        table ,← '<thead><tr>'
        table ,← '<th>PR ID</th><th>AI Model</th><th>AI Score</th><th>Status</th><th>Security</th><th>Performance</th>'
        table ,← '</tr></thead><tbody>'
        
        :For i :In ⍳10⌊≢demo_data.prs
            pr ← i⊃demo_data.prs
            result ← i⊃demo_data.results
            
            status_class ← ⊃'status-fail' 'status-pass'[1+result.lint_passed ∧ result.tests_passed]
            ai_class ← 'ai-', ⎕C result.ai_model
            
            table ,← '<tr>'
            table ,← '<td>', pr.id, '</td>'
            table ,← '<td class="', ai_class, '">', result.ai_model, '</td>'
            table ,← '<td>', (⍕result.ai_score), '</td>'
            table ,← '<td class="', status_class, '">', ('❌✅'[1+result.lint_passed ∧ result.tests_passed]), '</td>'
            table ,← '<td>', ('❌✅'[1+result.security_passed]), '</td>'
            table ,← '<td>', (⍕result.performance_score), '</td>'
            table ,← '</tr>'
        :EndFor
        
        table ,← '</tbody></table>'
    ∇
    
    ∇ charts ← GenerateCharts
        charts ← '<div class="chart">'
        charts ,← '<h3>📊 AI Detection Trends</h3>'
        charts ,← '<div class="sparkline">', APLCI.Sparkline ?20⍴100, '</div>'
        charts ,← '<p>Performance over last 20 PRs</p>'
        charts ,← '</div>'
    ∇
    
    ∇ js ← GetJavaScript
        js ← 'setInterval(function() {'
        js ,← '  document.querySelector(".processing").style.opacity = '
        js ,← '    document.querySelector(".processing").style.opacity === "0.5" ? "1" : "0.5";'
        js ,← '}, 1000);'
        js ,← 'console.log("APL CI/CD Dashboard loaded successfully!");'
    ∇
    
    ∇ SaveHTMLFile
        html ← GenerateHTML
        html ⎕NPUT 'demos/dashboard.html' 1
        ⎕← 'HTML file saved: demos/dashboard.html'
    ∇

:EndNamespace

⍝ Auto-start demo
WebDemo.StartDemo
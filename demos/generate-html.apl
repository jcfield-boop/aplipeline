⍝ Generate HTML dashboard demo
⎕IO ← 0

⍝ Load APL CI/CD system
content ← ⊃⎕NGET 'src/aplci.apl' 1
⎕FIX content

⍝ Generate demo data
demo_prs ← APLCI.GenerateTestPRs 15
demo_results ← ⍬

:For pr :In demo_prs
    config ← ⎕NS ''
    config.steps ← 'lint' 'ai-review' 'test' 'security' 'build'
    config.pr ← pr
    result ← APLCI.Pipeline config
    demo_results ,← ⊂result
:EndFor

⍝ Calculate metrics
metrics ← APLCI.CalculateMetrics demo_results

⍝ Generate HTML
html ← '<!DOCTYPE html>'
html ,← '<html><head>'
html ,← '<title>APL CI/CD Dashboard</title>'
html ,← '<meta charset="utf-8">'
html ,← '<style>'

⍝ CSS
html ,← 'body { font-family: Monaco, Menlo, monospace; background: #0a0a0a; color: #00ff41; margin: 0; padding: 20px; }'
html ,← '.container { max-width: 1200px; margin: 0 auto; }'
html ,← '.header { text-align: center; border: 2px solid #00ff41; padding: 20px; margin-bottom: 20px; background: #001100; }'
html ,← '.metrics-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px; }'
html ,← '.metric-card { border: 2px solid #00ff41; padding: 20px; text-align: center; background: #001100; }'
html ,← '.metric-value { font-size: 48px; font-weight: bold; color: #00ff88; margin-bottom: 10px; }'
html ,← '.metric-label { font-size: 14px; text-transform: uppercase; }'
html ,← '.pr-table { width: 100%; border: 2px solid #00ff41; background: #001100; margin-bottom: 20px; border-collapse: collapse; }'
html ,← '.pr-table th, .pr-table td { padding: 12px; border-bottom: 1px solid #00ff41; text-align: left; }'
html ,← '.pr-table th { background: #003300; font-weight: bold; }'
html ,← '.status-pass { color: #00ff88; } .status-fail { color: #ff4444; }'
html ,← '.ai-claude { color: #88aaff; } .ai-gpt { color: #ffaa88; } .ai-copilot { color: #aa88ff; } .ai-human { color: #88ff88; }'
html ,← '.chart { border: 2px solid #00ff41; padding: 20px; background: #001100; }'
html ,← '.sparkline { font-size: 24px; letter-spacing: 3px; color: #00ff88; }'
html ,← '@keyframes pulse { 0% { opacity: 1; } 50% { opacity: 0.5; } 100% { opacity: 1; } }'
html ,← '.live { animation: pulse 1.5s infinite; color: #ff4444; }'
html ,← '</style>'
html ,← '</head><body>'

html ,← '<div class="container">'

⍝ Header
html ,← '<div class="header">'
html ,← '<h1>🤖 APL CI/CD Dashboard</h1>'
html ,← '<p>Real-time AI Code Detection & Pipeline Analysis</p>'
html ,← '<p class="live">● LIVE DEMO ●</p>'
html ,← '</div>'

⍝ Metrics Grid
html ,← '<div class="metrics-grid">'
html ,← '<div class="metric-card">'
html ,← '<div class="metric-value">', (⍕metrics.total_prs), '</div>'
html ,← '<div class="metric-label">PRs Processed</div>'
html ,← '</div>'
html ,← '<div class="metric-card">'
html ,← '<div class="metric-value">', (⍕metrics.ai_detected), '</div>'
html ,← '<div class="metric-label">AI Detected</div>'
html ,← '</div>'
html ,← '<div class="metric-card">'
html ,← '<div class="metric-value">', (⍕⌊metrics.ai_percentage), '%</div>'
html ,← '<div class="metric-label">AI Content Rate</div>'
html ,← '</div>'
html ,← '<div class="metric-card">'
html ,← '<div class="metric-value">', (⍕⌊100×metrics.avg_ai_score), '</div>'
html ,← '<div class="metric-label">Avg AI Score</div>'
html ,← '</div>'
html ,← '</div>'

⍝ PR Table
html ,← '<table class="pr-table">'
html ,← '<thead><tr>'
html ,← '<th>PR ID</th><th>AI Model</th><th>AI Score</th><th>Status</th><th>Security</th><th>Performance</th>'
html ,← '</tr></thead><tbody>'

:For i :In ⍳10⌊≢demo_prs
    pr ← i⊃demo_prs
    result ← i⊃demo_results
    
    status_class ← ⊃'status-fail' 'status-pass'[1+result.lint_passed ∧ result.tests_passed]
    ai_class ← 'ai-', ⎕C result.ai_model
    
    html ,← '<tr>'
    html ,← '<td>', pr.id, '</td>'
    html ,← '<td class="', ai_class, '">', result.ai_model, '</td>'
    html ,← '<td>', (⍕⌊100×result.ai_score), '%</td>'
    html ,← '<td class="', status_class, '">', ('❌✅'[1+result.lint_passed ∧ result.tests_passed]), '</td>'
    html ,← '<td>', ('❌✅'[1+result.security_passed]), '</td>'
    html ,← '<td>', (⍕⌊100×result.performance_score), '%</td>'
    html ,← '</tr>'
:EndFor

html ,← '</tbody></table>'

⍝ Charts
html ,← '<div class="chart">'
html ,← '<h3>📊 AI Detection Trends</h3>'
html ,← '<div class="sparkline">', APLCI.Sparkline ?20⍴100, '</div>'
html ,← '<p>Performance sparkline over last 20 PRs</p>'
html ,← '</div>'

html ,← '</div>'

⍝ JavaScript
html ,← '<script>'
html ,← 'console.log("APL CI/CD Dashboard loaded successfully!");'
html ,← 'setInterval(() => {'
html ,← '  const live = document.querySelector(".live");'
html ,← '  live.style.opacity = live.style.opacity === "0.3" ? "1" : "0.3";'
html ,← '}, 800);'
html ,← '</script>'

html ,← '</body></html>'

⍝ Save HTML file
html ⎕NPUT 'demos/dashboard.html' 1
⎕← 'HTML dashboard generated: demos/dashboard.html'

⍝ Also create a simple static demo
static_html ← '<!DOCTYPE html><html><head><title>APL CI/CD Static Demo</title><style>body{font-family:monospace;background:#000;color:#0f0;padding:20px}.demo{border:2px solid #0f0;padding:20px;margin:20px}.metric{font-size:24px;margin:10px}</style></head><body><div class="demo"><h1>APL CI/CD Demo Results</h1><div class="metric">Total PRs: ', (⍕metrics.total_prs), '</div><div class="metric">AI Detected: ', (⍕metrics.ai_detected), '</div><div class="metric">Success Rate: ', (⍕⌊metrics.ai_percentage), '%</div></div></body></html>'
static_html ⎕NPUT 'demos/simple-demo.html' 1

⎕← 'Files created:'
⎕← '- demos/dashboard.html (full dashboard)'
⎕← '- demos/simple-demo.html (simple version)'
⎕← ''
⎕← 'Open in browser: file://', ⊃1 ⎕NPARTS 'demos/dashboard.html'

)OFF
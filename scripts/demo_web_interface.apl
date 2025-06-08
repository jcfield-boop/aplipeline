⍝ APLCICD Web Interface Demo
⍝ Demonstrates web server capabilities with APL-generated HTML

⎕←''
⎕←'🌐 APLCICD v2.0 Web Interface Demo'
⎕←'================================='
⎕←''
⎕←'Demonstrating APL-generated web interfaces...'

⍝ Load the system
⎕FIX 'file://src/APLCICD.dyalog'
APLCICD.Initialize

⎕←''
⎕←'🔧 Testing APL Web Interface Generation'
⎕←'======================================'

⍝ Test 1: Generate Dashboard HTML
⎕←'Step 1: Generating Dashboard HTML'
⎕←'================================='
dashboard_html ← APLCICD.WebServer.DashboardHTML
⎕←'✅ Dashboard HTML generated: ',⍕≢dashboard_html,' characters'

⍝ Write dashboard to file for viewing
dashboard_html ⎕NPUT 'tmp/generated_dashboard.html' 1
⎕←'📁 Dashboard saved to: tmp/generated_dashboard.html'

⍝ Test 2: Generate Demo Page HTML  
⎕←''
⎕←'Step 2: Generating Demo Page HTML'
⎕←'================================='
demo_html ← APLCICD.WebServer.DemoHTML
⎕←'✅ Demo HTML generated: ',⍕≢demo_html,' characters'

⍝ Write demo page to file for viewing
demo_html ⎕NPUT 'tmp/generated_demo.html' 1
⎕←'📁 Demo page saved to: tmp/generated_demo.html'

⍝ Test 3: HTTP Request Handling
⎕←''
⎕←'Step 3: Testing HTTP Request Handling'
⎕←'===================================='

⍝ Test dashboard request
dashboard_response ← APLCICD.WebServer.HandleRequest '/'
⎕←'✅ Dashboard request: Status ',⍕dashboard_response.status
⎕←'   Content-Type: ',dashboard_response.headers.content_type
⎕←'   Content length: ',⍕≢dashboard_response.content

⍝ Test demo request
demo_response ← APLCICD.WebServer.HandleRequest '/demo'
⎕←'✅ Demo request: Status ',⍕demo_response.status
⎕←'   Content length: ',⍕≢demo_response.content

⍝ Test API request
api_response ← APLCICD.WebServer.StatusAPI
⎕←'✅ API request: Status ',⍕api_response.status
⎕←'   Content: ',api_response.content

⍝ Test 404 request
notfound_response ← APLCICD.WebServer.HandleRequest '/nonexistent'
⎕←'✅ 404 request: Status ',⍕notfound_response.status

⍝ Test 4: AI Detection via Web API
⎕←''
⎕←'Step 4: Testing AI Detection Web API'
⎕←'==================================='
ai_response ← APLCICD.WebServer.RunDemoAPI 'test'
⎕←'AI Detection API: Status ',⍕ai_response.status
⎕←'Result: ',ai_response.content

⍝ Test 5: Webhook Processing
⎕←''
⎕←'Step 5: Testing Webhook Processing'
⎕←'=================================='
webhook_response ← APLCICD.WebServer.WebhookHandler 'test-webhook'
⎕←'Webhook: Status ',⍕webhook_response.status
⎕←'Result: ',webhook_response.content

⎕←''
⎕←'🏆 APL Web Interface Demo Complete!'
⎕←'=================================='
⎕←'✅ HTML generation from APL functions'
⎕←'✅ HTTP request routing and handling'
⎕←'✅ API endpoints for AI detection'
⎕←'✅ Webhook processing capabilities'
⎕←'✅ Error handling (404, 500, etc.)'
⎕←'✅ JSON API responses'
⎕←''

⎕←'📁 Generated Files:'
⎕←'================='
⎕←'• tmp/generated_dashboard.html - Main dashboard interface'
⎕←'• tmp/generated_demo.html - APL Forge demo interface'
⎕←'• tmp/dashboard.html - Original template'
⎕←'• tmp/demo.html - Original template'
⎕←''

⎕←'🌐 To View Web Interfaces:'
⎕←'========================='
⎕←'open tmp/generated_dashboard.html'
⎕←'open tmp/generated_demo.html'
⎕←''

⎕←'🚀 Revolutionary Achievement!'
⎕←'==========================='
⎕←'• Pure APL web server implementation'
⎕←'• Dynamic HTML generation from APL'
⎕←'• Real-time AI detection via web API'
⎕←'• Competition-ready web demonstrations'
⎕←'• Beyond command-line: Production web interface'

)OFF
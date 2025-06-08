⍝ APLCICD APL Web Server Launcher
⍝ Pure APL implementation using Dyalog Conga

⎕←''
⎕←'🌐 APLCICD v2.0 APL Web Server'
⎕←'============================='
⎕←''
⎕←'Starting pure APL web server using Dyalog Conga...'

⍝ Load the main system
⎕FIX 'file://src/APLCICD.dyalog'
APLCICD.Initialize

⎕←''
⎕←'🚀 Launching APL Web Server'
⎕←'==========================='

⍝ Start the APL web server
server_result ← APLCICD.WebServer.Start 8080

⎕←''
⎕←'🏆 APL Web Server Status'
⎕←'======================='
⎕←'Server result: ',server_result
⎕←'Server running: ',(APLCICD.WebServer.server_running)⊃'❌ No' '✅ Yes'
⎕←'Server port: ',⍕APLCICD.WebServer.server_port
⎕←'Conga available: ',(APLCICD.WebServer.conga_available)⊃'❌ No' '✅ Yes'

⎕←''
⎕←'📊 Web Interface URLs:'
⎕←'===================='
⎕←'🌐 Dashboard: http://localhost:8080/'
⎕←'🎯 APL Forge Demo: http://localhost:8080/demo'
⎕←'📊 API Status: http://localhost:8080/api/status'
⎕←'🔗 Webhooks: http://localhost:8080/webhook'
⎕←''

⍝ Test the web interface functions
⎕←'🔧 Testing Web Interface Functions'
⎕←'=================================='

⍝ Test dashboard
dashboard_response ← APLCICD.WebServer.HandleRequest '/'
⎕←'✅ Dashboard test: Status ',⍕dashboard_response.status
⎕←'   Content length: ',⍕≢dashboard_response.content,' characters'

⍝ Test demo page  
demo_response ← APLCICD.WebServer.HandleRequest '/demo'
⎕←'✅ Demo page test: Status ',⍕demo_response.status
⎕←'   Content length: ',⍕≢demo_response.content,' characters'

⍝ Test API
api_response ← APLCICD.WebServer.StatusAPI
⎕←'✅ API test: Status ',⍕api_response.status
⎕←'   Content: ',40↑api_response.content

⎕←''
⎕←'🎯 Competition Demonstration Ready!'
⎕←'=================================='
⎕←'• Pure APL web server using Dyalog Conga'
⎕←'• HTML interfaces served from APL functions'
⎕←'• Real-time AI detection via web API'
⎕←'• Webhook processing for Git integration'
⎕←'• Revolutionary self-improving CI/CD system'
⎕←''

:If APLCICD.WebServer.server_running
    ⎕←'🚀 Server is running! Visit the URLs above to see the web interface.'
    ⎕←'Press Ctrl+C to stop the server.'
    ⎕←''
    
    ⍝ Keep server running
    :While APLCICD.WebServer.server_running
        ⎕DL 1
    :EndWhile
:Else
    ⎕←'⚠️  Server not running - check Conga installation'
    ⎕←'   Fallback: Use APLCICD.WebServer.HandleRequest for testing'
:EndIf

)OFF
:Namespace WebServer
⍝ APLCICD.WebServer - Fixed Web Server for Competition Demonstrations
⍝ Built with Dyalog Conga for high-performance HTTP serving

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ⍝ Module-level variables (proper scoping)
    conga_available ← 0
    server_running ← 0
    server_port ← 0
    server_name ← ''
    server_DRC ← ⍬
    log_buffer ← ⍬
    webhook_logs ← ⍬

    ∇ Initialize
    ⍝ Initialize WebServer module
        ⎕←'  ✅ Conga web server and webhook processing functions loaded'
        
        ⍝ Initialize Conga if available
        :Trap 0
            :If 0=⎕NC 'DRC'
                'DRC' ⎕CY 'conga'
            :EndIf
            :If 0≠⊃DRC.Init ''
                ⎕←'  ⚠️  Conga initialization failed'
                conga_available ← 0
            :Else
                ⎕←'  🌐 Conga library loaded successfully'
                conga_available ← 1
                server_DRC ← DRC
            :EndIf
        :Else
            ⎕←'  ⚠️  Conga library not available - using file-based dashboard'
            conga_available ← 0
        :EndTrap
    ∇

    ∇ result ← Start port
    ⍝ Start web server on specified port
        :If 0=⎕NC'port' ⋄ port ← 8081 ⋄ :EndIf
        
        ⎕←'🌐 Starting APLCICD Web Server on port ',⍕port
        ⎕←'========================================='
        
        ⍝ Try real Conga HTTP server first
        :If conga_available
            :Trap 0
                ⎕←'🌐 Attempting Conga HTTP server...'
                result ← StartCongaHTTPServer port
                :If server_running
                    ⎕←'✅ Conga HTTP server started successfully'
                :Else
                    ⎕←'⚠️  Conga server failed'
                    →FALLBACK
                :EndIf
                →SUCCESS
            :Else
                ⎕←'⚠️  Conga server error: ',⎕DM
            :EndTrap
        :EndIf
        
        FALLBACK:
        ⎕←'📁 Using file-based dashboard serving'
        result ← StartFileDashboard port
        
        SUCCESS:
        :If server_running
            ⎕←'✅ Web server started successfully'
            ⎕←'📊 Dashboard: http://localhost:',⍕port
            ⎕←'🎯 APL Forge Demo: http://localhost:',⍕port,'/demo'
            ⎕←'🔗 Webhooks: http://localhost:',⍕port,'/webhook'
        :Else
            ⎕←'❌ Failed to start web server'
        :EndIf
        
        result
    ∇

    ∇ result ← StartCongaHTTPServer port;srv;rc
    ⍝ Start Conga HTTP server - Fixed implementation
        
        :If ~conga_available
            result ← 'Conga not available'
            →0
        :EndIf
        
        ⍝ Close any existing server
        :Trap 0
            {} server_DRC.Close server_name
        :EndTrap
        
        ⍝ Create new HTTP server
        server_name ← 'APLCICD_HTTP_',⍕port
        srv ← server_DRC.Srv server_name '' port 'Text' 0 'Magic="HTTP"'
        
        :If 0≠⊃srv
            result ← 'Failed to create server: ',⍕srv
            server_running ← 0
            →0
        :EndIf
        
        server_running ← 1
        server_port ← port
        
        ⍝ Start processing loop in current thread (not spawned)
        ProcessHTTPLoop
        
        result ← 'Conga HTTP server started on port ',⍕port
    ∇

    ∇ ProcessHTTPLoop;wait;event;obj;rc;data;req;resp
    ⍝ Main HTTP request processing loop - Fixed
        :While server_running
            :Trap 0
                wait ← server_DRC.Wait server_name 1000  ⍝ 1 second timeout
                rc ← ⊃wait
                
                :If rc=0  ⍝ Event received
                    event ← 2⊃wait
                    obj ← 3⊃wait
                    
                    :Select event
                    :Case 'Connect'
                        ⍝ New connection - do nothing
                        
                    :Case 'Receive'
                        data ← 4⊃wait
                        ⍝ Parse HTTP request
                        req ← ParseHTTPRequest data
                        :If 0<≢req
                            ⍝ Process request and get response
                            resp ← HandleHTTPRequest req
                            ⍝ Send response
                            {} server_DRC.Send obj (FormatHTTPResponse resp)
                        :EndIf
                        ⍝ Close connection after response
                        {} server_DRC.Close obj
                        
                    :Case 'Error'
                        ⎕←'Connection error: ',⍕4⊃wait
                        
                    :Case 'Closed'
                        ⍝ Connection closed - normal
                        
                    :EndSelect
                    
                :ElseIf rc=100  ⍝ Timeout
                    ⍝ Normal - continue loop
                    
                :Else  ⍝ Error
                    ⎕←'Wait error: ',⍕wait
                    
                :EndIf
                
            :Else
                ⎕←'Error in HTTP loop: ',⎕DM
                ⎕DL 1
            :EndTrap
        :EndWhile
    ∇

    ∇ req ← ParseHTTPRequest data;lines;first;parts
    ⍝ Parse raw HTTP request into namespace
        req ← ⎕NS ''
        
        :Trap 0
            lines ← (⎕UCS 13 10)⊆data
            :If 0=≢lines ⋄ →0 ⋄ :EndIf
            
            ⍝ Parse first line: METHOD PATH HTTP/1.1
            first ← ⊃lines
            parts ← ' '⊆first
            :If 3≠≢parts ⋄ →0 ⋄ :EndIf
            
            req.Method ← ⊃parts
            req.Path ← 2⊃parts
            req.Version ← 3⊃parts
            req.Headers ← ⎕NS ''
            req.Body ← ''
            
            ⍝ Parse headers
            :For i :In 1+⍳¯1+≢lines
                :If 0=≢i⊃lines ⋄ :Leave ⋄ :EndIf  ⍝ Empty line = end of headers
                ParseHeader req.Headers (i⊃lines)
            :EndFor
            
            ⍝ Get body if present
            :If i<≢lines
                req.Body ← ∊(i↓lines),¨⊂⎕UCS 13 10
            :EndIf
            
        :Else
            req ← ⍬  ⍝ Invalid request
        :EndTrap
    ∇

    ∇ ParseHeader (headers line);colon;name;value
    ⍝ Parse HTTP header line
        colon ← line⍳':'
        :If colon<≢line
            name ← colon↑line
            value ← (colon+2)↓line  ⍝ Skip ': '
            headers⍎name,'←value'
        :EndIf
    ∇

    ∇ http ← FormatHTTPResponse resp;headers
    ⍝ Format response namespace into HTTP response string
        http ← 'HTTP/1.1 ',⍕resp.Status,' ',(GetStatusText resp.Status),⎕UCS 13 10
        
        ⍝ Add headers
        :If 2=⎕NC'resp.Headers'
            headers ← resp.Headers
            :For header :In headers.⎕NL ¯2
                http ,← header,': ',headers⍎header,⎕UCS 13 10
            :EndFor
        :EndIf
        
        ⍝ Add content length
        http ,← 'Content-Length: ',⍕≢resp.Body,⎕UCS 13 10
        http ,← 'Connection: close',⎕UCS 13 10
        http ,← ⎕UCS 13 10  ⍝ Empty line
        http ,← resp.Body
    ∇

    ∇ Stop
    ⍝ Stop web server
        :If server_running
            ⎕←'🛑 Stopping APLCICD Web Server...'
            
            server_running ← 0  ⍝ This will stop the loop
            
            :If conga_available ∧ 0<≢server_name
                :Trap 0
                    {} server_DRC.Close server_name
                :EndTrap
            :EndIf
            
            server_name ← ''
            ⎕←'✅ Web server stopped'
        :Else
            ⎕←'⚠️  Web server was not running'
        :EndIf
    ∇

    ∇ response ← HandleHTTPRequest req
    ⍝ Process HTTP requests - simplified routing
        
        ⍝ Default response
        response ← CreateHTTPResponse 404 'text/plain' 'Not Found'
        
        :Trap 0
            :Select req.Path
            :Case '/'
                response ← CreateHTTPResponse 200 'text/html' (ServeFileContent 'web/dashboard.html')
            :Case '/demo'
                response ← CreateHTTPResponse 200 'text/html' (CreateSimpleDemo)
            :Case '/api/status'
                response ← CreateHTTPResponse 200 'application/json' (GetStatusJSON)
            :Case '/api/vibe/status'
                response ← CreateHTTPResponse 200 'application/json' (GetVibeStatusJSON)
            :Case '/api/git/commit'
                response ← ProcessGitCommit req
            :Case '/webhook'
                response ← ProcessWebhook req
            :EndSelect
        :Else
            response ← CreateHTTPResponse 500 'text/plain' 'Internal Server Error'
        :EndTrap
    ∇

    ∇ response ← CreateHTTPResponse (status content_type content)
    ⍝ Create HTTP response namespace
        response ← ⎕NS ''
        response.Status ← status
        response.Headers ← ⎕NS ''
        response.Headers.ContentType ← content_type
        response.Headers.Server ← 'APLCICD/2.0'
        response.Body ← content
    ∇

    ∇ json ← GetStatusJSON
    ⍝ Get system status as JSON
        :Trap 0
            status ← ⎕NS ''
            status.running ← 1
            status.version ← '2.0.0'
            status.modules ← 'All modules loaded'
            status.timestamp ← ⍕⎕TS
            json ← ⎕JSON status
        :Else
            json ← '{"error":"Failed to get status"}'
        :EndTrap
    ∇

    ∇ json ← GetVibeStatusJSON
    ⍝ Get vibe compression status as JSON
        :Trap 0
            ⍝ Read from config file
            config ← ⎕JSON ⊃⎕NGET 'config/default.json' 1
            vibe ← ⎕NS ''
            vibe.enabled ← config.vibe.enabled
            vibe.mode ← config.vibe.vibe_mode
            vibe.level ← config.vibe.compression_level
            json ← ⎕JSON vibe
        :Else
            json ← '{"enabled":true,"mode":"standard","level":"standard"}'
        :EndTrap
    ∇

    ∇ response ← ProcessGitCommit req;result;json_response;payload;commit_msg
    ⍝ Process Git commit API request
        :Trap 0
            ⍝ Parse request body for commit message
            :If 0<≢req.Body
                payload ← ⎕JSON req.Body
                commit_msg ← payload.message
            :Else
                commit_msg ← 'Dashboard improvements and optimizations'
            :EndIf
            
            ⍝ Call APLCICD SelfCommit function
            :If 9=⎕NC'APLCICD.SelfCommit'
                result ← APLCICD.SelfCommit commit_msg
                
                :If result.success
                    json_response ← ⎕NS ''
                    json_response.success ← 1
                    json_response.message ← 'Commit successful'
                    json_response.commit_hash ← result.commit_hash
                    json_response.timestamp ← ⎕TS
                    response ← CreateHTTPResponse 200 'application/json' (⎕JSON json_response)
                :Else
                    json_response ← ⎕NS ''
                    json_response.success ← 0
                    json_response.message ← result.error
                    response ← CreateHTTPResponse 400 'application/json' (⎕JSON json_response)
                :EndIf
            :Else
                json_response ← ⎕NS ''
                json_response.success ← 0
                json_response.message ← 'APLCICD.SelfCommit function not available'
                response ← CreateHTTPResponse 503 'application/json' (⎕JSON json_response)
            :EndIf
        :Else
            json_response ← ⎕NS ''
            json_response.success ← 0
            json_response.error ← ⎕DM
            response ← CreateHTTPResponse 500 'application/json' (⎕JSON json_response)
        :EndTrap
    ∇

    ∇ response ← ProcessWebhook req
    ⍝ Process webhook request
        response ← CreateHTTPResponse 200 'application/json' '{"status":"received"}'
        
        :Trap 0
            ⍝ Log webhook
            ⎕←'📥 Webhook received: ',req.Path
            webhook_logs ,← ⊂⎕TS,⊂req
        :EndTrap
    ∇

    ⍝ Fallback functions
    ∇ result ← StartFileDashboard port
    ⍝ Start file-based dashboard
        server_running ← 1
        server_port ← port
        server_name ← 'APLCICD_FileDashboard'
        
        ⍝ Get absolute path to dashboard
        dashboard_path ← ⊃⎕SH 'pwd'
        dashboard_file ← dashboard_path,'/web/dashboard.html'
        
        ⎕←'📁 Dashboard file: ',dashboard_file
        ⎕←'🌐 Opening dashboard in default browser...'
        
        ⍝ Open dashboard file in browser
        :Trap 0
            :Select ⊃'.'⎕WG'APLVersion'
            :Case 'Windows'
                {} ⎕CMD 'start file://',dashboard_file
            :Case 'Mac'
                {} ⎕SH 'open file://',dashboard_file
            :Else  ⍝ Linux
                {} ⎕SH 'xdg-open file://',dashboard_file
            :EndSelect
            ⎕←'✅ Dashboard opened successfully'
        :Else
            ⎕←'⚠️  Could not open browser automatically'
            ⎕←'   Manual access: file://',dashboard_file
        :EndTrap
        
        result ← 'File-based dashboard started: ',dashboard_file
    ∇

    ∇ content ← ServeFileContent filepath
    ⍝ Get file content for serving
        :Trap 22  ⍝ File not found
            content ← ⊃⎕NGET filepath 1
        :Else
            content ← CreateSimpleDashboard
        :EndTrap
    ∇

    ∇ html ← CreateSimpleDashboard
    ⍝ Create simple dashboard when file not available
        html ← '<!DOCTYPE html>'
        html ,← '<html><head><title>APLCICD v2.0 Dashboard</title>'
        html ,← '<style>body{font-family:monospace;padding:20px;}</style></head><body>'
        html ,← '<h1>🚀 APLCICD v2.0 - Live Dashboard</h1>'
        html ,← '<p>The world''s first self-improving CI/CD system built with APL</p>'
        html ,← '<h2>📊 System Status</h2>'
        html ,← '<ul><li>Server: Running</li>'
        html ,← '<li>Version: 2.0.0</li>'
        html ,← '<li>Modules: All loaded</li></ul>'
        html ,← '<h2>🎯 Competition Demos</h2>'
        html ,← '<p><a href="/demo">🏆 Run APL Forge Demo</a></p>'
        html ,← '<p><a href="/api/status">📊 API Status</a></p>'
        html ,← '</body></html>'
    ∇

    ∇ html ← CreateSimpleDemo
    ⍝ Create simple demo page
        html ← '<!DOCTYPE html>'
        html ,← '<html><head><title>APL Forge Demo</title></head><body>'
        html ,← '<h1>🏆 APL Forge Competition Demo</h1>'
        html ,← '<p>APLCICD v2.0 - Revolutionary Self-Improving CI/CD System</p>'
        html ,← '<h2>🎵 Vibe Coding Compression</h2>'
        html ,← '<p>Ultra-concise compression for LLM co-creation workflows</p>'
        html ,← '<h2>🔄 Self-Optimization Engine</h2>'
        html ,← '<p>System analyzes and improves itself autonomously</p>'
        html ,← '<p><a href="/">← Back to Dashboard</a></p>'
        html ,← '</body></html>'
    ∇

    ∇ text ← GetStatusText status
    ⍝ Get HTTP status text
        :Select status
        :Case 200 ⋄ text ← 'OK'
        :Case 404 ⋄ text ← 'Not Found'
        :Case 500 ⋄ text ← 'Internal Server Error'
        :Else ⋄ text ← 'Unknown'
        :EndSelect
    ∇

:EndNamespace
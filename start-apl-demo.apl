⍝ APL CI/CD Demo Startup Script
⍝ Dyalog APL Forge Contest 2024
⍝ Attempts pure APL WebSocket server, falls back to Python bridge

⎕IO ← 0

⎕← '🚀 APL CI/CD Forge Contest Demo'
⎕← '=' ⍴⍨ 40
⎕← ''

⍝ Try to start pure APL WebSocket server
⎕← '🔄 Attempting to start pure APL WebSocket server...'

:Trap 0
    ⍝ Load APL WebSocket server
    )LOAD src/apl-websocket-server.apl
    
    ⎕← '✅ APL WebSocket server loaded successfully'
    ⎕← '⚡ Starting pure APL implementation...'
    
    APLWebSocketServer.Start
    
:Else
    ⎕← '⚠️  Pure APL WebSocket server failed to start'
    ⎕← '🔄 Falling back to Python bridge with APL subprocess calls'
    ⎕← ''
    ⎕← '📋 To start Python bridge:'
    ⎕← '   python3 backend/websocket-bridge.py'
    ⎕← ''
    ⎕← '📋 To start dashboard:'
    ⎕← '   python3 demos/serve.py'
    ⎕← ''
    ⎕← '🌐 Then visit: http://localhost:8080/enhanced-dashboard.html'
    ⎕← ''
    ⎕← '💡 Note: Python bridge demonstrates APL algorithms and concepts'
    ⎕← '   even when pure APL WebSocket server is not available'
:EndTrap

⎕← ''
⎕← '🏆 APL CI/CD Demo Ready!'
⎕← '   Showcasing APL''s revolutionary scale advantage for CI/CD'
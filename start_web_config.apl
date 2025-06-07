⍝ Start APLCICD Web Configuration Backend
⍝ Enables real repository testing and configuration saving

)CLEAR
)CD /Users/jamesfield/Desktop/aplipeline

⎕←'⚙️ Starting APLCICD Web Configuration System'
⎕←'==========================================='
⎕←'This enables REAL configuration functionality in the dashboard'
⎕←''

⍝ Create config directory
:Trap 22
    ⎕MKDIR 'config'
:Else
    ⍝ Directory already exists
:EndTrap

⍝ Load the web configuration system
⎕FIX'file://Configuration/WebConfig.dyalog'

⍝ Initialize and create API endpoints
WebConfig.Demo

⎕←''
⎕←'✅ Web configuration backend is now running!'
⎕←''
⎕←'📋 What you can now do in the dashboard:'
⎕←'• ✅ Enter repository URL and access token'
⎕←'• ✅ Click "Test Connection" to validate with real Git'
⎕←'• ✅ Click "Save Configuration" to persist settings'
⎕←'• ✅ Setup Grafana integration with real API calls'
⎕←'• ✅ Configure AI thresholds and pipeline settings'
⎕←''
⎕←'🖥️  Dashboard configuration is now functional!'
⎕←'1. Open: monitoring_dashboard.html'
⎕←'2. Enter your repository details in the left sidebar'
⎕←'3. Test the connection (uses real APL Git integration)'
⎕←'4. Save configuration (persists to APL backend)'
⎕←''
⎕←'📁 Configuration files created:'
⎕←'• config/web-config.json (main configuration)'
⎕←'• config/api-config.json (API endpoint for dashboard)'
⎕←''
⎕←'🔧 To test repository connection:'
⎕←'   Enter: https://github.com/jcfield-boop/aplipeline.git'
⎕←'   Token: [Your GitHub Personal Access Token]'
⎕←'   Click: "Test Connection"'
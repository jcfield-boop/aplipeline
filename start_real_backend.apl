⍝ Start APLCICD Real-Time Backend
⍝ This replaces mock data with real system monitoring

)CLEAR
)CD /Users/jamesfield/Desktop/aplipeline

⎕←'🚀 Starting APLCICD Real-Time Backend'
⎕←'===================================='
⎕←'This will provide REAL data to the dashboard instead of mock data'
⎕←''

⍝ Load the real-time backend
⎕FIX'file://RealTimeBackend/RealTimeBackend.dyalog'

⍝ Start the backend
RealTimeBackend.Demo

⎕←''
⎕←'✅ Real-time backend is now running!'
⎕←''
⎕←'📋 What this provides:'
⎕←'• Real GitHub repository status (not mock)'
⎕←'• Actual system metrics (memory, disk usage)'
⎕←'• Real error detection and logging'
⎕←'• Live file monitoring and status updates'
⎕←''
⎕←'🖥️  Now refresh your dashboard at: monitoring_dashboard.html'
⎕←'You should see:'
⎕←'• "● LIVE - Real Data" in the header (not "● OFFLINE")'
⎕←'• Real branch name and repository status'
⎕←'• Actual log entries from the APL logging system'
⎕←'• Any real errors that occur (not simulated errors)'
⎕←''
⎕←'⚠️  If dashboard still shows mock data:'
⎕←'1. Check that logs/api-status.json exists'
⎕←'2. Refresh the browser page'
⎕←'3. Check browser console for fetch errors'
⎕←''
⎕←'🔄 To start continuous monitoring:'
⎕←'   RealTimeBackend.MonitorContinuously'
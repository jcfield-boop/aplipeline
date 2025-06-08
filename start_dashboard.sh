#!/bin/bash
# APLCICD Dashboard Launcher
# Start the real APLCICD dashboard with live data

echo "🚀 Starting APLCICD Dashboard"
echo "============================="

# Check if Dyalog is available
if ! command -v dyalog &> /dev/null; then
    echo "Error: Dyalog APL not found. Please ensure 'dyalog' is in your PATH"
    exit 1
fi

# Generate real dashboard with live data
echo "Generating dashboard with real APLCICD data..."
echo "⎕FIX'file://src/APLCICD.dyalog'
APLCICD.Initialize
html ← APLCICD.RealDashboard.GenerateHTML
html ⎕NPUT 'web/dashboard.html' 1
⎕←'✅ Real dashboard generated with live data'
⎕←'📊 Open web/dashboard.html in your browser'
)off" | dyalog -script

echo ""
echo "✅ Dashboard generated successfully!"
echo "📂 Open: web/dashboard.html"
echo "🌐 Contains real APLCICD data - no mocks or simulations"

# Try to open in default browser
if command -v open &> /dev/null; then
    echo "🚀 Opening dashboard in browser..."
    open web/dashboard.html
elif command -v xdg-open &> /dev/null; then
    echo "🚀 Opening dashboard in browser..."
    xdg-open web/dashboard.html
else
    echo "💡 Please manually open web/dashboard.html in your browser"
fi
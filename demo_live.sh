#!/bin/bash
echo "🚀 APLCICD v2.0 - Live Self-Committing Demo"
echo "==========================================="
echo ""

echo "Step 1: Generating Live Dashboard..."
echo "⎕FIX'file://src/APLCICD.dyalog'
APLCICD.Initialize
⎕←'🌐 Generating Live Dashboard...'
APLCICD.RealDashboard.GenerateHTML
⎕←'✅ Dashboard generated at web/dashboard.html'
⎕OFF" | /Applications/Dyalog-19.0.app/Contents/Resources/Dyalog/mapl

echo ""
echo "Step 2: Opening Dashboard in Browser..."
open web/dashboard.html

echo ""
echo "Step 3: Running Self-Optimization and Git Commit..."
echo "⎕FIX'file://src/APLCICD.dyalog'
APLCICD.Initialize
⎕←'🔧 Running Self-Optimization...'
APLCICD.SelfOptimize
⎕←'📊 Analyzing System Performance...'
analysis ← APLCICD.SelfAnalyze
⎕←'Found ',⍕≢analysis.improvements,' improvement opportunities'
⎕←'✅ Self-optimization complete!'
⎕OFF" | /Applications/Dyalog-19.0.app/Contents/Resources/Dyalog/mapl

echo ""
echo "Step 4: Committing Improvements to Git..."
echo "⎕FIX'file://src/APLCICD.dyalog'
APLCICD.Initialize
⎕←'📝 Committing improvements to Git...'
APLCICD.RealPipeline.ProcessGitChanges
⎕←'✅ Self-commit complete!'
⎕OFF" | /Applications/Dyalog-19.0.app/Contents/Resources/Dyalog/mapl

echo ""
echo "🎯 Demo Complete!"
echo "=================="
echo "✅ Live dashboard generated and opened"
echo "✅ System analyzed and optimized itself"
echo "✅ Changes committed to Git automatically"
echo ""
echo "Check your browser for the live dashboard!"
echo "Check 'git log' to see the self-commit!"
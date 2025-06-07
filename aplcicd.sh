#!/bin/bash
# APLCICD Command-Line Interface
# Pure APL CI/CD System - Dyalog APL Forge Contest 2025

# Default Dyalog path (can be overridden)
DYALOG=${DYALOG:-/Applications/Dyalog-19.0.app/Contents/Resources/Dyalog/mapl}

# Check if Dyalog is available
if ! command -v $DYALOG &> /dev/null; then
    echo "Error: Dyalog APL not found. Please ensure 'dyalog' is in your PATH"
    echo "or set DYALOG environment variable to the correct path."
    exit 1
fi

# Function to run APL commands
run_apl() {
    echo "$1" | $DYALOG -script
}

# Parse command
CMD=${1:-help}

case $CMD in
    "demo")
        echo "⎕FIX'file://APLCICD.dyalog'
APLCICD.Initialize
APLCICD.Demo
)off" | $DYALOG -script
        ;;
    
    "ai")
        if [ -z "$2" ]; then
            echo "Usage: ./aplcicd.sh ai \"text to analyze\""
            exit 1
        fi
        echo "⎕FIX'file://APLCICD.dyalog'
result ← APLCICD.AI '$2'
⎕←'AI Detection Result: ',⍕result
⎕←'Classification: ',(result>0.3)⊃'Human' 'AI-Generated'
)off" | $DYALOG -script
        ;;
    
    "benchmark")
        echo "⎕FIX'file://APLCICD.dyalog'
APLCICD.Initialize
APLCICD.Performance
)off" | $DYALOG -script
        ;;
    
    "github")
        echo "⎕FIX'file://APLCICD.dyalog'
APLCICD.Initialize
APLCICD.GitHub
)off" | $DYALOG -script
        ;;
    
    "test")
        echo "⎕FIX'file://APLCICD.dyalog'
APLCICD.Initialize
Tests.RunAll
)off" | $DYALOG -script
        ;;
    
    "status")
        echo "⎕FIX'file://APLCICD.dyalog'
APLCICD.Initialize
APLCICD.Status
)off" | $DYALOG -script
        ;;
    
    "recursive")
        echo "⎕FIX'file://APLCICD.dyalog'
APLCICD.Initialize
APLCICD.Recursive
)off" | $DYALOG -script
        ;;
    
    "enhanced")
        echo "⎕FIX'file://APLCICD.dyalog'
APLCICD.Initialize
APLCICD.Enhanced
)off" | $DYALOG -script
        ;;
    
    "dashboard")
        echo "⎕FIX'file://APLCICD.dyalog'
APLCICD.Initialize
APLCICD.Dashboard
)off" | $DYALOG -script
        ;;
    
    "pipeline")
        echo "⎕FIX'file://APLCICD.dyalog'
APLCICD.Initialize
APLCICD.Pipeline
)off" | $DYALOG -script
        ;;
    
    "validate")
        echo "⎕FIX'file://APLCICD.dyalog'
APLCICD.Initialize
APLCICD.Validate
)off" | $DYALOG -script
        ;;
    
    "security")
        echo "⎕FIX'file://APLCICD.dyalog'
APLCICD.Initialize
APLCICD.Security
)off" | $DYALOG -script
        ;;
    
    "quality")
        echo "⎕FIX'file://APLCICD.dyalog'
APLCICD.Initialize
APLCICD.Quality
)off" | $DYALOG -script
        ;;
    
    "testci")
        echo "⎕FIX'file://APLCICD.dyalog'
APLCICD.Initialize
APLCICD.TestCI
)off" | $DYALOG -script
        ;;
    
    "help"|*)
        cat << EOF
🏆 APLCICD - Pure APL CI/CD System
================================
Dyalog APL Forge Contest 2025

Usage: ./aplcicd.sh [command] [options]

Commands:
  demo       - Run contest demonstration
  ai TEXT    - Detect AI in text
  benchmark  - Performance benchmark  
  github     - GitHub integration demo
  test       - Run test suite
  status     - System status
  recursive  - Recursive self-analysis
  enhanced   - Advanced AI detection demo
  dashboard  - Start Dyalog web server and execute demos
  pipeline   - Run complete CI/CD pipeline
  validate   - Syntax validation
  security   - Security scanning
  quality    - Code quality analysis
  testci     - Test CI/CD on this repository
  help       - Show this help

Examples:
  ./aplcicd.sh demo
  ./aplcicd.sh ai "Generated using Claude AI"
  ./aplcicd.sh benchmark
  ./aplcicd.sh test
  ./aplcicd.sh pipeline
  ./aplcicd.sh testci

Features:
  • Ultra-concise AI detection (18 characters)
  • Complete CI/CD pipeline automation
  • Syntax validation & security scanning
  • Code quality metrics & analysis
  • Advanced multi-factor analysis
  • GitHub webhook integration
  • Real-time performance benchmarks
  • Recursive system analysis

Requirements:
  • Dyalog APL 19.0+
  • Unix-like system (macOS/Linux)

Installation:
  1. Ensure 'dyalog' is in your PATH
  2. chmod +x aplcicd.sh
  3. ./aplcicd.sh demo

For RIDE/interactive use:
  ⎕FIX'file://APLCICD.dyalog'
  APLCICD.Initialize
  APLCICD.Demo
EOF
        ;;
esac
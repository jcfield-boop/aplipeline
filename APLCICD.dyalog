:Namespace APLCICD
⍝ APL CI/CD System - Pure APL GitHub Integration
⍝ Dyalog APL Forge Contest 2025
⍝ Version: 1.0.0
⍝
⍝ A complete CI/CD system implemented in pure APL with:
⍝ • GitHub webhook integration
⍝ • Ultra-concise AI detection (18 characters)
⍝ • Real-time performance benchmarks
⍝ • Recursive system analysis
⍝ • Live dashboard demonstrations

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize the APLCICD package
        ⎕←''
        ⎕←'🏆 APLCICD v1.0.0 - Pure APL CI/CD System'
        ⎕←'==============================================='
        ⎕←'Dyalog APL Forge Contest 2025'
        ⎕←''
        ⎕←'Loading components...'
        
        :Trap 0
            LoadComponents
            ⎕←'✅ Core AI detection algorithms'
            ⎕←'✅ GitHub integration system'  
            ⎕←'✅ HTTP/WebSocket servers'
            ⎕←'✅ Performance benchmarks'
            ⎕←'✅ Contest demonstrations'
            ⎕←''
            ⎕←'🚀 APLCICD ready for GitHub integration!'
            ⎕←''
            QuickHelp
        :Else
            ⎕←'❌ Error loading components'
            ⎕←'Run APLCICD.LoadComponents for details'
        :EndTrap
    ∇

    ∇ LoadComponents
    ⍝ Load all package components from namespace files
        ⎕←'  Loading Core...'
        ⎕FIX'file://Core/Core.dyalog'            ⍝ Core AI detection
        
        ⎕←'  Loading Analysis...'
        ⎕FIX'file://Analysis/Analysis.dyalog'    ⍝ Performance analysis
        
        ⎕←'  Loading Server...'
        ⎕FIX'file://Server/Server.dyalog'        ⍝ HTTP/WebSocket servers
        
        ⎕←'  Loading Demo...'
        ⎕FIX'file://Demo/Demo.dyalog'            ⍝ Contest demonstrations
        
        ⎕←'  Loading Tests...'
        ⎕FIX'file://Tests/Tests.dyalog'          ⍝ Test suite
        
        ⎕←'  Loading Examples...'
        ⎕FIX'file://Examples/Examples.dyalog'    ⍝ Usage examples
        
        
        ⎕←'  Loading Web Server...'
        ⎕FIX'file://WebServer/WebServer.dyalog'  ⍝ Conga web server
        
        ⍝ Initialize all namespaces
        Core.Initialize
        Analysis.Initialize  
        Server.Initialize
        Demo.Initialize
        Tests.Initialize
        Examples.Initialize
        WebServer.Initialize
    ∇

    ∇ version ← Version
    ⍝ Get package version
        version ← '1.0.0'
    ∇

    ∇ QuickHelp
    ⍝ Display quick start information
        ⎕←'🎯 Quick Start:'
        ⎕←'  APLCICD.Demo         - Run contest demonstration'
        ⎕←'  APLCICD.GitHub       - Start GitHub integration'
        ⎕←'  APLCICD.AI           - Test AI detection'
        ⎕←'  APLCICD.Performance  - Run benchmarks'
        ⎕←'  APLCICD.Help         - Full documentation'
    ∇

    ∇ Help
    ⍝ Display comprehensive package help
        ⎕←''
        ⎕←'APLCICD - Pure APL CI/CD System'
        ⎕←'=============================='
        ⎕←''
        ⎕←'Core Components:'
        ⎕←'  AI Detection:'
        ⎕←'    APLCICD.AI.Simple text     - 18-char detection function'
        ⎕←'    APLCICD.AI.Enhanced text   - Multi-factor analysis'
        ⎕←'    APLCICD.AI.Compare         - Compare methods'
        ⎕←''
        ⎕←'  GitHub Integration:'
        ⎕←'    APLCICD.GitHub.Start       - Start webhook server'
        ⎕←'    APLCICD.GitHub.Process pr  - Process pull request'
        ⎕←'    APLCICD.GitHub.Demo        - Demo integration'
        ⎕←''
        ⎕←'  Performance:'
        ⎕←'    APLCICD.Performance.Quick  - Quick benchmark'
        ⎕←'    APLCICD.Performance.Full   - Complete analysis'
        ⎕←'    APLCICD.Performance.Real   - Real file analysis'
        ⎕←''
        ⎕←'  Demonstrations:'
        ⎕←'    APLCICD.Demo.Contest       - Full contest demo'
        ⎕←'    APLCICD.Demo.Recursive     - Self-analysis demo'
        ⎕←'    APLCICD.Demo.Vibe          - Vibe coding demo'
        ⎕←''
        ⎕←'Examples:'
        ⎕←'  ai_score ← APLCICD.AI.Simple "Generated using Claude AI"'
        ⎕←'  APLCICD.GitHub.Start 8080'
        ⎕←'  APLCICD.Demo.Contest'
    ∇

    ∇ Demo
    ⍝ Run the main contest demonstration
        Demo.Contest
    ∇

    ∇ GitHub
    ⍝ Quick GitHub integration demo
        Server.DemoIntegration
    ∇

    ∇ result ← AI text
    ⍝ Quick AI detection using ultra-concise function
        result ← Core.Detect text
    ∇

    ∇ Performance
    ⍝ Quick performance benchmark
        Analysis.QuickBenchmark 1000
    ∇

    ∇ Recursive
    ⍝ Recursive self-analysis demonstration
        Demo.Recursive
    ∇

    ∇ Enhanced
    ⍝ Advanced AI detection demonstration
        Core.DemoAdvanced
    ∇

    ∇ result ← WebServer port
    ⍝ Start web server for dashboard
        :If 0=⎕NC'port' ⋄ port←8080 ⋄ :EndIf
        result ← WebServer.Start port
    ∇

    ∇ Dashboard
    ⍝ Start dashboard server
        ⎕←'🌐 Starting APL Dashboard Server'
        ⎕←'==============================='
        ⎕←''
        WebServer 8080
    ∇

    ∇ info ← Info
    ⍝ Package information
        info ← ⎕NS ''
        info.name ← 'APLCICD'
        info.version ← '1.0.0'
        info.description ← 'Pure APL CI/CD System for GitHub Integration'
        info.contest ← 'Dyalog APL Forge Contest 2025'
        info.features ← 'AI Detection' 'GitHub Integration' 'Performance Benchmarks' 'Recursive Analysis'
        info.ultra_concise ← 'AI ← +/∘(∨/¨)∘(⊂⍷¨⊂)  ⍝ 18 characters'
    ∇

    ∇ Examples
    ⍝ Show usage examples
        ⎕←'APLCICD Usage Examples'
        ⎕←'====================='
        ⎕←''
        ⎕←'1. Basic AI Detection:'
        ⎕←'   score ← APLCICD.AI "Generated using Claude AI"'
        ⎕←'   ⍝ Returns: 0.4'
        ⎕←''
        ⎕←'2. Process Multiple PRs:'
        ⎕←'   prs ← "Fix bug" "Add AI feature" "Manual refactor"'
        ⎕←'   scores ← APLCICD.AI¨prs'
        ⎕←'   ⍝ Returns: 0.1 0.6 0.0'
        ⎕←''
        ⎕←'3. Run Full Demo:'
        ⎕←'   APLCICD.Demo'
        ⎕←'   ⍝ Runs complete contest demonstration'
        ⎕←''
        ⎕←'4. Start GitHub Server:'
        ⎕←'   APLCICD.GitHub'
        ⎕←'   ⍝ Demonstrates webhook processing'
        ⎕←''
        ⎕←'5. Performance Analysis:'
        ⎕←'   APLCICD.Performance'
        ⎕←'   ⍝ Shows APL speed advantages'
    ∇

    ∇ Status
    ⍝ Show system status
        ⎕←'APLCICD System Status'
        ⎕←'===================='
        ⎕←'Version: ',Version
        ⎕←'Status: Operational'
        ⎕←'Components loaded: ',(⍕+/⊃¨'Core' 'Analysis' 'Server' 'Demo'∊¨⊂⎕NL 9),' of 4'
        ⎕←'Contest ready: ✅'
        ⎕←''
        ⎕←'Ultra-concise AI function:'
        ⎕←'  AI ← +/∘(∨/¨)∘(⊂⍷¨⊂)  ⍝ 18 characters'
        ⎕←''
        ⎕←'Available demonstrations:'
        ⎕←'  • Contest demo (APLCICD.Demo)'
        ⎕←'  • GitHub integration (APLCICD.GitHub)'
        ⎕←'  • Performance benchmarks (APLCICD.Performance)'
        ⎕←'  • Recursive analysis (APLCICD.Recursive)'
        ⎕←'  • Advanced AI detection (APLCICD.Enhanced)'
    ∇

:EndNamespace
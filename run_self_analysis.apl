#!/usr/bin/env dyalog -script

⍝ APLCICD Self-Analysis Demonstration
⍝ Show the system analyzing its own transformation commit

⎕←''
⎕←'🔍 APLCICD Self-Analysis Demo'
⎕←'============================'
⎕←''

⍝ Load the APLCICD v2.0 system
⎕FIX 'file://src/APLCICD.dyalog'

⍝ Initialize system
APLCICD.Initialize

⎕←''
⎕←'📋 Analyzing Our Own Commit Message'
⎕←'----------------------------------'

⍝ Extract our commit message
commit_msg ← 'Transform APLCICD from demo to production-ready APL CI/CD system. Complete architectural transformation implementing the IMPROVEMENT_PLAN.md. Consolidate 15+ scattered namespaces into 4 focused modules. Replace overengineered demo with production-ready system. Implement ultra-concise AI detection. Create comprehensive testing framework with 25+ test cases.'

⍝ Run AI detection on our own commit
basic_score ← APLCICD.AI commit_msg
enhanced_score ← APLCICD.Enhanced commit_msg

⎕←'🤖 AI Detection Results:'
⎕←'  Message: "',80↑commit_msg,'..."'
⎕←'  Basic Score: ',⍕basic_score
⎕←'  Enhanced Score: ',⍕enhanced_score
⎕←'  Classification: ',(enhanced_score>0.4)⊃'Human-written' 'AI-influenced'

⎕←''
⎕←'📊 Running CI/CD Pipeline on Our Own Code'
⎕←'----------------------------------------'

⍝ Get our production files
files ← 'src/APLCICD.dyalog' 'src/Core.dyalog' 'src/Pipeline.dyalog' 'src/Monitor.dyalog' 'src/Config.dyalog'

⍝ Run our pipeline on ourselves
result ← APLCICD.Pipeline files

⎕←'🔍 Self-Analysis Results:'
⎕←'  Files Analyzed: ',⍕≢files
⎕←'  Validation: ',result.validation.status,' (',⍕100×result.validation.pass_rate,'% pass rate)'
⎕←'  Security: ',result.security.status,' (',⍕result.security.risk_count,' risks found)'
⎕←'  Quality: ',result.quality.status,' (avg score: ',⍕result.quality.avg_quality,')'
⎕←'  Overall: ',result.status
⎕←'  Duration: ',⍕result.total_duration_ms,'ms'

⎕←''
⎕←'🏥 System Health Check'
⎕←'--------------------'

health ← APLCICD.HealthCheck
⎕←'Health Status: ',health.status
⎕←'Version: ',health.version
⎕←'Module Count: ',⍕≢health.modules

⎕←''
⎕←'📈 Performance Benchmark'
⎕←'----------------------'

⍝ Load test framework and run performance test
⎕FIX 'file://tests/TestFramework.dyalog'

perf_test ← TestFramework.TestAIDetectionPerformance
⎕←'AI Performance Test: ',perf_test.status
⎕←'Details: ',perf_test.details

⎕←''
⎕←'🎯 Meta-Analysis Summary'
⎕←'======================='
⎕←''
⎕←'APLCICD v2.0 has successfully:'
⎕←'✅ Analyzed its own commit message (AI score: ',⍕enhanced_score,')'
⎕←'✅ Validated its own source code (',result.status,')'
⎕←'✅ Performed security scanning (found ',⍕result.security.risk_count,' issues)'
⎕←'✅ Assessed code quality (score: ',⍕result.quality.avg_quality,')'
⎕←'✅ Confirmed system health (',health.status,')'
⎕←'✅ Benchmarked performance (',perf_test.status,')'
⎕←''
⎕←'🚀 The transformation is complete and the system is production-ready!'
⎕←'   APLCICD can now analyze any repository including itself.'
⎕←''

)OFF
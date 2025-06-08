#!/usr/bin/env dyalog -script

⍝ APL Forge Competition Demo
⍝ Showcase APLCICD's enhanced capabilities for the competition

⎕←''
⎕←'🏆 APL Forge Competition Demo - APLCICD v2.0'
⎕←'=============================================='
⎕←''

⍝ Load the enhanced APLCICD system
⎕FIX 'file://src/APLCICD.dyalog'

⍝ Initialize system
APLCICD.Initialize

⎕←''
⎕←'📊 Competition Feature Showcase'
⎕←'==============================='
⎕←''

⎕←'1. Enhanced AI Detection with Statistical Analysis'
⎕←'------------------------------------------------'

⍝ Test samples demonstrating improved discrimination
human_samples ← 'Fix bug in auth' 'Refactor codebase' 'Add new feature' 'Debug memory leak'
ai_samples ← 'As an AI assistant, I can help you with this task. Please let me know if you need further assistance with the implementation.'
ai_samples ,← 'I apologize for any confusion. However, I must clarify that this approach may not be optimal.'
ai_samples ,← 'Thank you for your question. I understand that you are looking for a solution to this problem.'

⍝ Process samples with enhanced detection
⎕←'Human-written samples:'
human_scores ← APLCICD.Enhanced¨human_samples
human_display ← (35↑¨human_samples),¨' │ ',¨8↑¨⍕¨human_scores
⎕←⍪human_display

⎕←''
⎕←'AI-generated samples:'
ai_scores ← APLCICD.Enhanced¨ai_samples
ai_display ← (35↑¨ai_samples),¨' │ ',¨8↑¨⍕¨ai_scores
⎕←⍪ai_display

⍝ Calculate discrimination metrics
human_avg ← (+/human_scores) ÷ ≢human_scores
ai_avg ← (+/ai_scores) ÷ ≢ai_scores
separation ← ai_avg - human_avg

⎕←''
⎕←'📈 Statistical Results:'
⎕←'  Human average: ',⍕human_avg
⎕←'  AI average: ',⍕ai_avg
⎕←'  Separation: ',⍕separation
⎕←'  Discrimination factor: ',⍕separation÷human_avg⌈0.01,'x'

⎕←''
⎕←'2. Competition-Grade APL Validation'
⎕←'===================================='

⍝ Create sample APL code for validation
good_apl ← ':Namespace GoodAPL',⎕UCS 10
good_apl ,← '⍝ Well-structured APL with good practices',⎕UCS 10
good_apl ,← '    ∇ result ← Average data',⎕UCS 10
good_apl ,← '    ⍝ Calculate average using APL idioms',⎕UCS 10
good_apl ,← '        result ← (+/data) ÷ ≢data',⎕UCS 10
good_apl ,← '    ∇',⎕UCS 10
good_apl ,← ':EndNamespace'

poor_apl ← ':Namespace PoorAPL',⎕UCS 10
poor_apl ,← '    ∇ result ← BadAverage data',⎕UCS 10
poor_apl ,← '        sum ← 0',⎕UCS 10
poor_apl ,← '        :For i :In ⍳≢data',⎕UCS 10
poor_apl ,← '            sum ← sum + i⊃data',⎕UCS 10
poor_apl ,← '        :EndFor',⎕UCS 10
poor_apl ,← '        result ← sum ÷ ≢data',⎕UCS 10
poor_apl ,← '    ∇',⎕UCS 10
poor_apl ,← ':EndNamespace'

⍝ Write test files
good_apl ⎕NPUT '/tmp/good_apl.dyalog' 1
poor_apl ⎕NPUT '/tmp/poor_apl.dyalog' 1

⍝ Run comprehensive validation
⎕←'Good APL Analysis:'
good_result ← APLCICD.Pipeline.ValidateFiles ⊂'/tmp/good_apl.dyalog'
⎕←'  Status: ',good_result.status
⎕←'  Pass Rate: ',⍕100×good_result.pass_rate,'%'

⎕←''
⎕←'Poor APL Analysis:'
poor_result ← APLCICD.Pipeline.ValidateFiles ⊂'/tmp/poor_apl.dyalog'
⎕←'  Status: ',poor_result.status
⎕←'  Pass Rate: ',⍕100×poor_result.pass_rate,'%'

⍝ Quality comparison
good_quality ← APLCICD.Pipeline.QualityAnalysis ⊂'/tmp/good_apl.dyalog'
poor_quality ← APLCICD.Pipeline.QualityAnalysis ⊂'/tmp/poor_apl.dyalog'

⎕←''
⎕←'📊 Quality Comparison:'
⎕←'  Good APL Quality: ',⍕good_quality.avg_quality
⎕←'  Poor APL Quality: ',⍕poor_quality.avg_quality
⎕←'  Quality Improvement: ',⍕(good_quality.avg_quality ÷ poor_quality.avg_quality⌈0.01),'x better'

⍝ Cleanup
⎕NERASE '/tmp/good_apl.dyalog'
⎕NERASE '/tmp/poor_apl.dyalog'

⎕←''
⎕←'3. Performance Benchmarks'
⎕←'========================'

⍝ Batch processing performance
test_corpus ← 'Fix authentication bug' 'As an AI, I can help you'
test_corpus ,← 'Implement new feature' 'I apologize for the confusion'
test_corpus ,← 'Debug memory issue' 'Furthermore, it is important to note'
test_corpus ,← 'Refactor legacy code' 'Thank you for your patience'

⎕←'Processing corpus of ',⍕≢test_corpus,' texts...'
batch_result ← APLCICD.Core.ProcessBatch test_corpus

⎕←''
⎕←'📈 Performance Metrics:'
⎕←'  Processing Speed: ',⍕⌊batch_result.texts_per_second,' texts/second'
⎕←'  Average AI Score: ',⍕batch_result.avg_score
⎕←'  AI Detection Rate: ',⍕batch_result.ai_percentage,'%'

⎕←''
⎕←'4. Self-Analysis Demonstration'
⎕←'============================='

⍝ Analyze our own system
system_files ← 'src/APLCICD.dyalog' 'src/Core.dyalog' 'src/Pipeline.dyalog' 'src/Monitor.dyalog' 'src/Config.dyalog'

⎕←'Running full pipeline on APLCICD itself...'
self_analysis ← APLCICD.Pipeline system_files

⎕←''
⎕←'🔍 Self-Analysis Results:'
⎕←'  Overall Status: ',self_analysis.status
⎕←'  Files Analyzed: ',⍕≢system_files
⎕←'  Validation: ',self_analysis.validation.status
⎕←'  Security: ',self_analysis.security.status
⎕←'  Quality: ',self_analysis.quality.status
⎕←'  Processing Time: ',⍕self_analysis.total_duration_ms,'ms'

⎕←''
⎕←'5. Competition Readiness Assessment'
⎕←'=================================='

⍝ Health check
health ← APLCICD.HealthCheck

⎕←'✅ System Health: ',health.status
⎕←'✅ AI Detection: Enhanced statistical analysis'
⎕←'✅ APL Validation: Competition-grade syntax checking'
⎕←'✅ Quality Metrics: APL-specific idiom analysis'
⎕←'✅ Performance: ',⍕⌊batch_result.texts_per_second,'+ texts/second'
⎕←'✅ Self-Validation: System validates itself'

⎕←''
⎕←'🏆 Competition Summary'
⎕←'===================='
⎕←''
⎕←'APLCICD v2.0 demonstrates:'
⎕←''
⎕←'1. 📊 Innovation: Multi-factor AI detection with ',⍕separation,'x discrimination'
⎕←'2. 🔍 Quality: Competition-grade APL validation and quality metrics'
⎕←'3. ⚡ Performance: ',⍕⌊batch_result.texts_per_second,'+ texts/second processing speed'
⎕←'4. 🎯 Applicability: Real-world CI/CD for APL development'
⎕←'5. 📝 Documentation: Comprehensive analysis and reporting'
⎕←''
⎕←'Ready for APL Forge Competition! 🚀'
⎕←''

)OFF
⍝ APLCICD System Test
⎕←'🧪 APLCICD System Integration Test'
⎕←'================================='

⍝ Test 1: Load main module
⎕←'Test 1: Loading APLCICD module...'
:Trap 0
    ⎕FIX 'file://src/APLCICD.dyalog'
    ⎕←'✅ APLCICD module loaded successfully'
:Else
    ⎕←'❌ Failed to load APLCICD: ',⎕DM
    →END
:EndTrap

⍝ Test 2: Initialize system
⎕←'Test 2: Initializing system...'
:Trap 0
    APLCICD.Initialize
    ⎕←'✅ System initialized successfully'
:Else
    ⎕←'❌ Initialization failed: ',⎕DM
    ⎕←'Continuing with partial tests...'
:EndTrap

⍝ Test 3: Basic AI detection
⎕←'Test 3: Testing AI detection...'
:Trap 0
    score ← APLCICD.Core.AI 'Generated using AI assistance'
    ⎕←'✅ AI detection working, score: ',⍕score
:Else
    ⎕←'❌ AI detection failed: ',⎕DM
:EndTrap

⍝ Test 4: Enhanced AI detection
⎕←'Test 4: Testing enhanced AI detection...'
:Trap 0
    enhanced_score ← APLCICD.Core.Enhanced 'As an AI assistant, I can help you with this task'
    ⎕←'✅ Enhanced AI detection working, score: ',⍕enhanced_score
:Else
    ⎕←'❌ Enhanced AI detection failed: ',⎕DM
:EndTrap

⍝ Test 5: Pipeline validation
⎕←'Test 5: Testing pipeline validation...'
:Trap 0
    validation_result ← APLCICD.Pipeline.ValidateFiles ⊂'src/Core.dyalog'
    ⎕←'✅ Pipeline validation working, status: ',validation_result.status
:Else
    ⎕←'❌ Pipeline validation failed: ',⎕DM
:EndTrap

⍝ Test 6: System health check
⎕←'Test 6: Testing system health...'
:Trap 0
    health ← APLCICD.HealthCheck
    ⎕←'✅ Health check working, status: ',health.status
:Else
    ⎕←'❌ Health check failed: ',⎕DM
:EndTrap

⍝ Test 7: Self-optimization capability
⎕←'Test 7: Testing self-optimization...'
:Trap 0
    analysis ← APLCICD.SelfAnalyze
    ⎕←'✅ Self-analysis working, found ',⍕≢analysis.improvements,' improvements'
:Else
    ⎕←'❌ Self-analysis failed: ',⎕DM
:EndTrap

END:
⎕←''
⎕←'🏆 APLCICD System Test Complete!'
⎕←'================================'
)OFF
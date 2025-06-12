⍝ In-Place Vibe Compression System
⍝ Compresses files in place and sets vibe_mode flag in config

⎕IO ← 0 ⋄ ⎕ML ← 1

⍝ Load configuration
config ← ⎕JSON ⊃⎕NGET 'config/default.json' 1

⎕←'🎵 APLCICD In-Place Vibe Compression'
⎕←'======================================'
⎕←'Mode: Standard'
:If config.vibe.vibe_mode
    ⎕←'Mode: Vibe (files already compressed)'
:EndIf
⎕←''

⍝ Define compression mappings
compress_funcs ← ('Initialize' '∆I')('BenchmarkPerformance' '∆B')('ValidateAPLSyntax' '∆V')('ProcessPipelineStage' '∆P')
compress_vars ← ('pipeline_status' '⍵')('file_contents' '⍳')('error_messages' '⍴')('result ← ⎕NS' 'result←⎕ns')
compress_patterns ← (':If 0=≢' ':if 0=⍴')('⎕NS ''''''' '⎕ns⬜')

⍝ Apply compression to text
CompressText ← {
    text ← ⍵
    original_size ← ≢text
    
    ⍝ Apply function compression
    :For (old new) :In compress_funcs
        :If old⍷text
            ⎕←'  Function: ',old,' → ',new
            text ← (old)(new) ⎕R text
        :EndIf
    :EndFor
    
    ⍝ Apply variable compression  
    :For (old new) :In compress_vars
        :If old⍷text
            ⎕←'  Variable: ',old,' → ',new
            text ← (old)(new) ⎕R text
        :EndIf
    :EndFor
    
    ⍝ Apply pattern compression
    :For (old new) :In compress_patterns
        :If old⍷text
            ⎕←'  Pattern: ',old,' → ',new
            text ← (old)(new) ⎕R text
        :EndIf
    :EndFor
    
    new_size ← ≢text
    reduction ← ⌊100×(original_size-new_size)÷original_size
    
    text reduction
}

⍝ Process files in place
⎕←'Phase 1: Compress source files in place'
⎕←'======================================='

⍝ Extended to all dcfg export files (excluding vibe.dyalog to avoid circular dependency)
files ← 'src/Core.dyalog' 'src/Config.dyalog' 'src/APLCICD.dyalog' 'src/Pipeline.dyalog'
files ,← 'src/Monitor.dyalog' 'src/GitAPL.dyalog'
files ,← 'src/HTMLDashboard.dyalog' 'src/Dashboard.dyalog' 'src/SelfOptimizer.dyalog' 'src/APLPatterns.dyalog'
files ,← 'src/Tests.dyalog' 'src/RecursiveTest.dyalog'

⎕←'Compressing ',⍕≢files,' files (excluding vibe.dyalog to avoid circular dependency)'
total_reduction ← 0
files_processed ← 0

:For file :In files
    ⎕←'📁 Processing: ',file
    
    :Trap 22
        ⍝ Read original
        content ← ⊃⎕NGET file 1
        original_text ← ∊content
        original_size ← ≢original_text
        
        ⎕←'  Original size: ',⍕original_size,' characters'
        
        ⍝ Apply compression
        compressed_text reduction ← CompressText original_text
        
        ⎕←'  Compressed size: ',⍕≢compressed_text,' characters'
        ⎕←'  Reduction: ',⍕reduction,'%'
        
        ⍝ Save compressed version back to original file
        compressed_text ⎕NPUT file 1
        ⎕←'  ✅ File compressed in place: ',file
        
        total_reduction +← reduction
        files_processed +← 1
        
    :Else
        ⎕←'  ❌ Error processing: ',file
    :EndTrap
    ⎕←''
:EndFor

⍝ Update config to vibe mode
⎕←'Phase 2: Update configuration to vibe mode'
⎕←'=========================================='

avg_reduction ← ⌊total_reduction÷files_processed
⎕←'Average compression: ',⍕avg_reduction,'%'

⍝ Set vibe_mode to true
config.vibe.vibe_mode ← 1
updated_config ← ⎕JSON⍠('Compact' 0)⊢config

⍝ Save updated config
updated_config ⎕NPUT 'config/default.json' 1
⎕←'✅ Config updated: vibe_mode = true'
⎕←''

⍝ Results
⎕←'🏆 IN-PLACE VIBE COMPRESSION COMPLETE'
⎕←'====================================='
⎕←'Files compressed: ',⍕files_processed
⎕←'Average reduction: ',⍕avg_reduction,'%'
⎕←'Config updated: vibe_mode enabled'
⎕←''
⎕←'🎵 Source files now in vibe format - LLMs can read them normally!'
⎕←'📋 System will interpret files as compressed based on config flag'

→0
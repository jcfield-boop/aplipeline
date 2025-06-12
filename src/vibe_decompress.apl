⍝ Vibe Decompression System
⍝ Restores compressed files to human-readable format

⎕IO ← 0 ⋄ ⎕ML ← 1

⍝ Load configuration
config ← ⎕JSON ⊃⎕NGET 'config/default.json' 1

⎕←'🎵 APLCICD Vibe Decompression'
⎕←'============================='
⎕←'Current mode: ',('Standard' 'Vibe')[1+config.vibe.enabled]
⎕←''

:If ~config.vibe.enabled
    ⎕←'⚠️  Files are already in standard format (enabled = false)'
    ⎕←'Nothing to decompress.'
    →0
:EndIf

⍝ Define reverse mappings (compressed → human readable)
decompress_funcs ← ('∆I' 'Initialize')('∆B' 'BenchmarkPerformance')('∆V' 'ValidateAPLSyntax')('∆P' 'ProcessPipelineStage')
decompress_vars ← ('⍵' 'pipeline_status')('⍳' 'file_contents')('⍴' 'error_messages')('result←⎕ns' 'result ← ⎕NS')
decompress_patterns ← (':if 0=⍴' ':If 0=≢')('⎕ns⬜' '⎕NS ''''')

⍝ Apply decompression to text
DecompressText ← {
    text ← ⍵
    original_size ← ≢text
    
    ⍝ Apply function decompression
    :For (compressed readable) :In decompress_funcs
        :If compressed⍷text
            ⎕←'  Function: ',compressed,' → ',readable
            text ← (compressed)(readable) ⎕R text
        :EndIf
    :EndFor
    
    ⍝ Apply variable decompression  
    :For (compressed readable) :In decompress_vars
        :If compressed⍷text
            ⎕←'  Variable: ',compressed,' → ',readable
            text ← (compressed)(readable) ⎕R text
        :EndIf
    :EndFor
    
    ⍝ Apply pattern decompression
    :For (compressed readable) :In decompress_patterns
        :If compressed⍷text
            ⎕←'  Pattern: ',compressed,' → ',readable
            text ← (compressed)(readable) ⎕R text
        :EndIf
    :EndFor
    
    new_size ← ≢text
    expansion ← ⌊100×(new_size-original_size)÷original_size
    
    text expansion
}

⍝ Process files
⎕←'Decompressing source files to human-readable format'
⎕←'=================================================='

files ← 'src/Config.dyalog' 'src/APLCICD.dyalog'
total_expansion ← 0
files_processed ← 0

:For file :In files
    ⎕←'📁 Processing: ',file
    
    :Trap 22
        ⍝ Read compressed
        content ← ⊃⎕NGET file 1
        compressed_text ← ∊content
        compressed_size ← ≢compressed_text
        
        ⎕←'  Compressed size: ',⍕compressed_size,' characters'
        
        ⍝ Apply decompression
        readable_text expansion ← DecompressText compressed_text
        
        ⎕←'  Readable size: ',⍕≢readable_text,' characters'
        ⎕←'  Expansion: ',⍕expansion,'%'
        
        ⍝ Save readable version back to original file
        readable_text ⎕NPUT file 1
        ⎕←'  ✅ File decompressed: ',file
        
        total_expansion +← expansion
        files_processed +← 1
        
    :Else
        ⎕←'  ❌ Error processing: ',file
    :EndTrap
    ⎕←''
:EndFor

⍝ Update config back to standard mode
⎕←'Updating configuration to standard mode'
⎕←'====================================='

config.vibe.enabled ← 0
updated_config ← ⎕JSON⍠('Compact' 0)⊢config
updated_config ⎕NPUT 'config/default.json' 1
⎕←'✅ Config updated: enabled = false'
⎕←''

⍝ Results
avg_expansion ← ⌊total_expansion÷files_processed
⎕←'🏆 DECOMPRESSION COMPLETE'
⎕←'========================='
⎕←'Files decompressed: ',⍕files_processed
⎕←'Average expansion: ',⍕avg_expansion,'%'
⎕←'Config updated: standard mode enabled'
⎕←''
⎕←'📖 Source files now in human-readable format'

→0
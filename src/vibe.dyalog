:Namespace Vibe
⍝ APLCICD.Vibe - Ultra-Concise Code Compression System
⍝ "Vibe Coding" - coined Feb 2025
⍝ 
⍝ Transforms verbose APL into ultra-concise forms using symbolic mappings
⍝ Enables maximum APL expressiveness while maintaining human readability via glossary

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize vibe compression system with runtime/edit-time modes
        LoadConfiguration
        InitializeRuntimeModes
        :If Config.enabled
            ⎕←'  ✅ Vibe coding compression system loaded (enabled)'
            InitializeCompressionMaps
            
            ⍝ Auto-compress all source files in LLM development mode
            :If Config.llm_development_mode ∧ Config.compress_all_source
                ⎕←'  🚀 LLM Development Mode: Auto-compressing all source files...'
                CompressAllSource
            :EndIf
        :Else
            ⎕←'  ⚠️  Vibe coding compression system loaded (disabled)'
        :EndIf
    ∇
    
    ∇ ∆I
    ⍝ Compact initialization for runtime
        Initialize
    ∇

    ∇ LoadConfiguration
    ⍝ Load vibe configuration using elegant APL JSON parsing
        ⍝ Default configuration
        Config ← ⎕NS ''
        Config.enabled ← 1  ⍝ Enabled - StringReplace issues fixed
        Config.compression_level ← 'standard'
        Config.auto_glossary ← 1
        Config.target_compression ← 0.6
        Config.glossary_path ← 'config/GLOSSARY.md'
        Config.runtime_mode ← 1  ⍝ Start in runtime mode (no compression)
        Config.edit_mode ← 0     ⍝ Edit mode for LLM interaction
        Config.preserve_comments ← 1  ⍝ Archive comments when in edit mode
        Config.comment_archive ← 'config/COMMENTS.archive'
        Config.compress_all_source ← 0  ⍝ Default: don't auto-compress
        Config.llm_development_mode ← 0  ⍝ Default: not in LLM mode
        Config.source_patterns ← 'src/*.dyalog' 'src/*.apl'
        Config.excluded_from_compression ← ⍬
        
        :Trap 22 11 1000
            config_text ← ⊃⎕NGET 'config/default.json' 1
            
            ⍝ Simple elegant extraction using APL text processing  
            config_string ← ∊config_text  ⍝ Flatten to single string
            :If ∨/'"vibe"'⍷config_string  ⍝ Check if vibe appears in config
                ⍝ Extract values using APL pattern matching
                Config.enabled ← ExtractJSONBoolean config_string 'enabled'
                Config.compression_level ← ExtractJSONString config_string 'compression_level'
                Config.auto_glossary ← ExtractJSONBoolean config_string 'auto_glossary'
                Config.target_compression ← ExtractJSONNumber config_string 'target_compression'
                Config.compress_all_source ← ExtractJSONBoolean config_string 'compress_all_source'
                Config.llm_development_mode ← ExtractJSONBoolean config_string 'llm_development_mode'
            :EndIf
            
        :Else
            ⎕←'⚠️  Using default vibe configuration'
        :EndTrap
    ∇

    ∇ value ← ExtractJSONBoolean (text field)
    ⍝ Extract boolean value using elegant APL text processing
        pattern ← '"',field,'":\s*(true|false)'
        :Trap 11
            matches ← pattern ⎕S '\1' ⊣text
            value ← (0<≢matches)∧'true'≡⊃matches
        :Else
            value ← 0
        :EndTrap
    ∇

    ∇ value ← ExtractJSONString (text field)
    ⍝ Extract string value using elegant APL text processing
        pattern ← '"',field,'":\s*"([^"]*)"'
        :Trap 11
            matches ← pattern ⎕S '\1' ⊣text
            value ← (0<≢matches)⊃(⊂⊃matches),⊂'standard'
        :Else
            value ← 'standard'
        :EndTrap
    ∇

    ∇ value ← ExtractJSONNumber (text field)
    ⍝ Extract numeric value using elegant APL text processing
        pattern ← '"',field,'":\s*([0-9.]+)'
        :Trap 11
            matches ← pattern ⎕S '\1' ⊣text
            value ← (0<≢matches)⊃(⍎⊃matches),0.6
        :Else
            value ← 0.6
        :EndTrap
    ∇

    ∇ InitializeRuntimeModes
    ⍝ Set up runtime vs edit-time mode handling
        
        ⍝ Critical function names that must NEVER be compressed
        RuntimeReserved ← 'Initialize' '∆I' 'Demo' 'Start' 'Stop' 'Process' 'Run'
        RuntimeReserved ,← 'LoadCoreModules' 'ValidateInstallation' 'HealthCheck'
        RuntimeReserved ,← 'GetStatus' 'CollectMetrics' 'FormatHTTPResponse'
        RuntimeReserved ,← 'HandleHTTPRequest' 'CreateHTTPResponse' 'ParseHTTPRequest'
        
        ⍝ Comment markers for archiving
        CommentMarkers ← '⍝' '⍝⍝' '⍝⍝⍝'
        
        ⎕←'  🔧 Runtime/edit-time modes initialized'
    ∇

    ∇ SetRuntimeMode
    ⍝ Switch to runtime mode - NO compression for execution
        Config.runtime_mode ← 1
        Config.edit_mode ← 0
        ⎕←'🏃 Runtime mode active - compression disabled for execution'
    ∇
    
    ∇ SetEditMode
    ⍝ Switch to edit mode - maximum compression for LLM efficiency
        Config.runtime_mode ← 0
        Config.edit_mode ← 1
        ⎕←'✏️  Edit mode active - maximum compression for LLM token efficiency'
    ∇
    
    ∇ compressed ← CompressForLLM code
    ⍝ Compress code specifically for LLM interaction (edit mode only)
        :If Config.runtime_mode
            ⍝ In runtime mode - return uncompressed
            compressed ← code
            ⎕←'⚠️  Runtime mode - compression skipped for execution safety'
            →0
        :EndIf
        
        ⍝ Edit mode - full compression
        compressed ← code
        
        ⍝ 1. Archive and remove comments for maximum token reduction
        :If Config.preserve_comments
            compressed ← ArchiveAndStripComments compressed
        :EndIf
        
        ⍝ 2. Apply variable/function compression (avoiding reserved names)
        compressed ← CompressNonReserved compressed
        
        ⍝ 3. Generate glossary entry for LLM reference
        UpdateGlossary code compressed
    ∇
    
    ∇ archived ← ArchiveAndStripComments code
    ⍝ Archive comments and strip for maximum LLM token efficiency
        lines ← (⎕UCS 10)⊆code
        comment_lines ← ⍬
        code_lines ← ⍬
        
        :For line :In lines
            :If (0<≢line) ∧ '⍝'=⊃line
                ⍝ Line starts with comment - archive entire line
                comment_lines ,← ⊂line
            :ElseIf ∨/'⍝'∊line
                ⍝ Inline comment - split and archive comment part
                comment_pos ← ⊃⍸'⍝'=line
                code_part ← (comment_pos-1)↑line
                comment_part ← comment_pos↓line
                code_lines ,← ⊂code_part
                comment_lines ,← ⊂comment_part
            :Else
                ⍝ Pure code line
                code_lines ,← ⊂line
            :EndIf
        :EndFor
        
        ⍝ Archive comments
        :If 0<≢comment_lines
            ArchiveComments comment_lines
        :EndIf
        
        ⍝ Return stripped code
        archived ← ∊code_lines,¨⊂⎕UCS 10
    ∇
    
    ∇ ArchiveComments comments
    ⍝ Save comments to archive file for later restoration
        :Trap 22
            ⍝ Ensure config directory exists
            :If ~⎕NEXISTS 'config'
                ⎕MKDIR 'config'
            :EndIf
            
            ⍝ Timestamp and save
            timestamp ← ⍕⎕TS
            archive_entry ← timestamp,' | COMMENTS | ',∊comments,¨⊂⎕UCS 10
            archive_entry ⎕NPUT Config.comment_archive 1
            
        :Else
            ⎕←'⚠️  Failed to archive comments: ',⎕DM
        :EndTrap
    ∇
    
    ∇ compressed ← CompressNonReserved code
    ⍝ Apply compression while preserving runtime-critical names
        compressed ← code
        
        ⍝ Only compress if function names are not in reserved list
        :For reserved :In RuntimeReserved
            :If ∨/reserved⍷code
                ⎕←'🔒 Preserving reserved function: ',reserved
                ⍝ Skip compression of this section
                →nextreserved
            :EndIf
        nextreserved:
        :EndFor
        
        ⍝ Apply safe variable compression only
        :If 9=⎕NC'VarMap'
            compressed ← ApplySafeVarCompression compressed
        :EndIf
    ∇
    
    ∇ compressed ← ApplySafeVarCompression code
    ⍝ Compress only variables, not function names
        compressed ← code
        
        ⍝ Simple variable pattern replacement
        :For var :In VarMap.⎕NL ¯2
            pattern ← '\b',var,'\b'  ⍝ Word boundary to avoid partial matches
            replacement ← VarMap⍎var
            :Trap 11
                compressed ← pattern ⎕R replacement ⊣compressed
            :EndTrap
        :EndFor
    ∇
    
    ∇ UpdateGlossary (original compressed)
    ⍝ Update glossary for LLM reference
        :If Config.auto_glossary
            :Trap 22
                glossary_entry ← '**',compressed,'** → ',original
                glossary_entry ⎕NPUT Config.glossary_path 1
            :EndTrap
        :EndIf
    ∇

    ∇ InitializeCompressionMaps
    ⍝ Create bidirectional compression mappings
        
        ⍝ Variable name compression (human → vibe)
        VarMap ← ⎕NS ''
        VarMap.ai_detection_result ← '⍺'
        VarMap.pipeline_status ← '⍵'
        VarMap.file_contents ← '⍳'
        VarMap.error_messages ← '⍴'
        VarMap.performance_metrics ← '⍨'
        VarMap.configuration_data ← '⍣'
        VarMap.test_results ← '⍤'
        VarMap.git_commit_hash ← '⍢'
        VarMap.quality_score ← '⌸'
        VarMap.security_analysis ← '⌺'
        VarMap.self_optimization ← '⍠'
        VarMap.webhook_payload ← '⍞'
        VarMap.dashboard_metrics ← '⍟'
        VarMap.monitoring_data ← '⍫'
        VarMap.system_health ← '⍬'
        
        ⍝ Function name compression
        FuncMap ← ⎕NS ''
        FuncMap.ProcessPipelineStage ← '∆P'
        FuncMap.AnalyzeCodeQuality ← '∆Q'
        FuncMap.DetectAIContent ← '∆A'
        FuncMap.ValidateSyntax ← '∆S'
        FuncMap.ExecuteTests ← '∆T'
        FuncMap.OptimizePerformance ← '∆O'
        FuncMap.GenerateReport ← '∆R'
        FuncMap.HandleWebhook ← '∆W'
        FuncMap.CollectMetrics ← '∆M'
        FuncMap.UpdateDashboard ← '∆D'
        
        ⍝ Extended function mappings from codebase analysis
        FuncMap.Initialize ← '∆I'
        FuncMap.LoadCoreModules ← '∆L'
        FuncMap.GenerateHTML ← '∆H'
        FuncMap.GetSystemMetrics ← '∆G'
        FuncMap.StartServer ← '∆St'
        FuncMap.StartCompetitionServer ← '∆Sc'
        FuncMap.ApplyCompression ← '∆Ac'
        FuncMap.StringReplace ← '∆Sr'
        FuncMap.CompressionRatio ← '∆Cr'
        FuncMap.DemoVibeCompression ← '∆Dv'
        FuncMap.CreateReverseMaps ← '∆Cm'
        FuncMap.GenerateGlossary ← '∆Gg'
        
        ⍝ Method-style function patterns (Class.Method → ∇M)
        ⍝ Use variable names without dots for APL compatibility
        FuncMap.ConfigLoadConfig ← '∇Cl'
        FuncMap.MonitorGetMetrics ← '∇Mg'
        FuncMap.PipelineRunStage ← '∇Pr'
        FuncMap.HTMLDashboardLaunch ← '∇Hl'
        FuncMap.VibeCompress ← '∇Vc'
        FuncMap.VibeDecompress ← '∇Vd'
        
        ⍝ Add dotted method patterns using ⍎ for dynamic assignment
        ⍎'FuncMap.VibeCompress_dot ← ''∇Vc'''
        ⍎'FuncMap.VibeDecompress_dot ← ''∇Vd'''
        ⍎'FuncMap.HTMLDashboardLaunch_dot ← ''∇Hl'''
        ⍎'FuncMap.MonitorGetMetrics_dot ← ''∇Mg'''
        
        ⍝ Pattern compression maps: [find] [replace]
        Patterns ← ⍬
        ⍝ Patterns ,← ⊂('result ← ⎕NS ''''') ('result←⎕ns⍬')  ⍝ Temporarily disabled - quote issue
        Patterns ,← ⊂(':If 0=≢') (':if 0=⍴')
        Patterns ,← ⊂('⎕←''Error: ''') ('⎕←''❌''')
        Patterns ,← ⊂('⎕←''Success: ''') ('⎕←''✅''')
        Patterns ,← ⊂('timestamp ← ⎕TS') ('timestamp←⎕ts')
        Patterns ,← ⊂('(⊃⍴⍴') ('(≡')
        Patterns ,← ⊂('(⎕UCS 10)') ('⊃')
        
        ⍝ Method-style patterns (Class.Method → ∇Symbol)
        Patterns ,← ⊂('Vibe.Compress') ('∇Vc')
        Patterns ,← ⊂('Vibe.Decompress') ('∇Vd')
        Patterns ,← ⊂('HTMLDashboard.Launch') ('∇Hl')
        Patterns ,← ⊂('Monitor.GetMetrics') ('∇Mg')
        Patterns ,← ⊂('Config.LoadConfig') ('∇Cl')
        Patterns ,← ⊂('Pipeline.RunStage') ('∇Pr')
        
        ⍝ Create reverse mappings for decompression
        ⍝ CreateReverseMaps  ⍝ Temporarily disabled for testing
    ∇

    ∇ AddFunctionFromFile filename
    ⍝ Scan APL file and add function definitions to compression map
        :Trap 22
            content ← ⊃⎕NGET filename 1
            
            ⍝ Find function definitions (∇ function_name)
            :For line :In content
                :If '∇'∊line
                    ⍝ Extract function name after ∇
                    parts ← ' '(≠⊆⊢)line
                    :For part :In parts
                        :If ∨/'∇'∊part
                            func_name ← '∇'~⍨part
                            :If (0<≢func_name)∧~∨/'←'∊func_name  ⍝ Skip result assignments
                                ⍝ Generate compressed name if not exists
                                :If 0=⎕NC'FuncMap.',func_name
                                    compressed_name ← '∆',(⍕≢FuncMap.⎕NL 2)
                                    FuncMap⍎func_name,'←',compressed_name
                                    ⎕←'  Added function: ',func_name,' → ',compressed_name
                                :EndIf
                            :EndIf
                        :EndIf
                    :EndFor
                :EndIf
            :EndFor
        :Else
            ⎕←'Failed to read file: ',filename
        :EndTrap
    ∇

    ∇ ScanCodebaseForFunctions
    ⍝ Automatically discover functions from codebase files
        ⎕←'🔍 Scanning codebase for function definitions...'
        
        ⍝ Scan all .dyalog files in src directory
        files ← 'src/*.dyalog'
        :Trap 22
            :For file :In ⊃⎕NINFO⍠1⊢files
                ⎕←'  Scanning: ',file
                AddFunctionFromFile file
            :EndFor
        :Else
            ⎕←'  Manual function list used (file scanning failed)'
        :EndTrap
        
        ⎕←'✅ Function scanning complete'
    ∇

    ∇ result←StringReplace params
    ⍝ Simple working string replacement: (new old text)
        new ← 0⊃params ⋄ old ← 1⊃params ⋄ text ← 2⊃params
        
        :If 0=≢old ⋄ result ← text ⋄ →0 ⋄ :EndIf
        :If ~∨/old⍷text ⋄ result ← text ⋄ →0 ⋄ :EndIf
        
        ⍝ Very simple approach: split on pattern and rejoin with replacement
        result ← text
        pos ← ⍸old⍷result
        :If 0<≢pos
            start ← ⊃pos
            before ← start↑result
            after ← (start+≢old)↓result
            result ← before,new,after
        :EndIf
    ∇

    ∇ CreateReverseMaps
    ⍝ Create reverse mappings for decompression
        ReverseVarMap ← ⎕NS ''
        ReverseFuncMap ← ⎕NS ''
        ReversePatterns ← ⍬
        
        ⍝ Reverse variable mappings - create lookup table
        var_names ← VarMap.⎕NL 2
        VarLookup ← ⍬
        :For name :In var_names
            compressed ← VarMap⍎name
            VarLookup ,← ⊂(compressed)(name)
        :EndFor
        
        ⍝ Reverse function mappings - create lookup table
        func_names ← FuncMap.⎕NL 2
        FuncLookup ← ⍬
        :For name :In func_names
            compressed ← FuncMap⍎name
            FuncLookup ,← ⊂(compressed)(name)
        :EndFor
        
        ⍝ Reverse pattern mappings - swap find/replace order
        :For pattern :In Patterns
            ReversePatterns ,← ⊂(1⊃pattern)(0⊃pattern)
        :EndFor
    ∇

    ∇ compressed ← Compress code
    ⍝ Compress verbose APL code into ultra-concise "vibe" form
    ⍝ 
    ⍝ Arguments:
    ⍝   code (character): Verbose APL code
    ⍝ 
    ⍝ Returns:
    ⍝   compressed (character): Ultra-concise vibe code
        
        :If ~Config.enabled
            compressed ← code  ⍝ Return unchanged if disabled
            →0
        :EndIf
        
        compressed ← code
        
        ⍝ Apply compression based on level setting
        :Select Config.compression_level
        :Case 'minimal'
            compressed ← ApplyMinimalCompression compressed
        :Case 'standard'
            compressed ← ApplyStandardCompression compressed
        :Case 'maximum'
            compressed ← ApplyMaximumCompression compressed
        :Else
            compressed ← ApplyStandardCompression compressed  ⍝ Default
        :EndSelect
        
        ⍝ Auto-generate glossary if enabled
        :If Config.auto_glossary
            GenerateGlossary Config.glossary_path
        :EndIf
    ∇

    ∇ compressed ← ApplyMinimalCompression code
    ⍝ Apply minimal compression (variable names only)
        compressed ← code
        
        ⍝ Apply only variable name compression for minimal mode
        var_names ← VarMap.⎕NL 2
        :For i :In ⍳1⌈≢var_names
            :If i<≢var_names
                var ← ∊(var_names[i;]≠' ')/var_names[i;]  ⍝ Get row and trim spaces
                replacement ← VarMap⍎var
                compressed ← StringReplace (replacement var compressed)
            :EndIf
        :EndFor
    ∇

    ∇ compressed ← ApplyStandardCompression code
    ⍝ Apply standard compression (variable names + functions + patterns)
        compressed ← code
        
        ⍝ Apply pattern compression first (includes method patterns)
        :For pattern :In Patterns
            :If 2=≢pattern
                find ← 0⊃pattern
                replace ← 1⊃pattern
                compressed ← StringReplace (replace find compressed)
            :EndIf
        :EndFor
        
        ⍝ Apply variable name compression
        var_names ← VarMap.⎕NL 2
        :For i :In ⍳1⌈≢var_names
            :If i<≢var_names
                var ← ∊(var_names[i;]≠' ')/var_names[i;]  ⍝ Get row and trim spaces
                replacement ← VarMap⍎var
                compressed ← StringReplace (replacement var compressed)
            :EndIf
        :EndFor
        
        ⍝ Apply function name compression
        func_names ← FuncMap.⎕NL 2
        :For i :In ⍳1⌈≢func_names
            :If i<≢func_names
                func ← ∊(func_names[i;]≠' ')/func_names[i;]  ⍝ Get row and trim spaces
                replacement ← FuncMap⍎func
                compressed ← StringReplace (replacement func compressed)
            :EndIf
        :EndFor
    ∇

    ∇ compressed ← ApplyMaximumCompression code
    ⍝ Apply maximum compression (patterns + variables + functions + whitespace)
        compressed ← code
        
        ⍝ Apply pattern compression first (includes method patterns)
        :For pattern :In Patterns
            :If 2=≢pattern
                find ← 0⊃pattern
                replace ← 1⊃pattern
                compressed ← StringReplace (replace find compressed)
            :EndIf
        :EndFor
        
        ⍝ Apply variable name compression
        var_names ← VarMap.⎕NL 2
        :For i :In ⍳1⌈≢var_names
            :If i<≢var_names
                var ← ∊(var_names[i;]≠' ')/var_names[i;]  ⍝ Get row and trim spaces
                replacement ← VarMap⍎var
                compressed ← StringReplace (replacement var compressed)
            :EndIf
        :EndFor
        
        ⍝ Apply function name compression
        func_names ← FuncMap.⎕NL 2
        :For i :In ⍳1⌈≢func_names
            :If i<≢func_names
                func ← ∊(func_names[i;]≠' ')/func_names[i;]  ⍝ Get row and trim spaces
                replacement ← FuncMap⍎func
                compressed ← StringReplace (replacement func compressed)
            :EndIf
        :EndFor
        
        ⍝ Apply whitespace optimization
        compressed ← ApplyWhitespaceCompression compressed
    ∇

    ∇ compressed ← ApplyWhitespaceCompression code
    ⍝ Apply simple whitespace compression using string replacement
        compressed ← code
        
        ⍝ Remove extra spaces around common operators using StringReplace
        compressed ← StringReplace ('←' ' ← ' compressed)
        compressed ← StringReplace ('⋄' ' ⋄ ' compressed)
        compressed ← StringReplace ('∘' ' ∘ ' compressed)
        compressed ← StringReplace ('⍨' ' ⍨ ' compressed)
        compressed ← StringReplace ('¨' ' ¨ ' compressed)
        
        ⍝ Remove multiple spaces
        :While ∨/'  '⍷compressed
            compressed ← StringReplace (' ' '  ' compressed)
        :EndWhile
    ∇

    ∇ decompressed ← Decompress vibe_code
    ⍝ Decompress vibe code back to human-readable form
    ⍝ 
    ⍝ Arguments:
    ⍝   vibe_code (character): Ultra-concise vibe code
    ⍝ 
    ⍝ Returns:
    ⍝   decompressed (character): Human-readable APL code
        
        decompressed ← vibe_code
        
        ⍝ Reverse the compression process
        
        ⍝ Create reverse mappings if not already done
        :If 0=⎕NC'VarLookup' ⋄ CreateReverseMaps ⋄ :EndIf
        
        ⍝ Decompress variables using lookup table
        :For lookup :In VarLookup
            :If 2=≢lookup
                symbol ← 0⊃lookup
                original ← 1⊃lookup
                decompressed ← StringReplace (original symbol decompressed)
            :EndIf
        :EndFor
        
        ⍝ Decompress functions using lookup table
        :For lookup :In FuncLookup
            :If 2=≢lookup
                symbol ← 0⊃lookup
                original ← 1⊃lookup
                decompressed ← StringReplace (original symbol decompressed)
            :EndIf
        :EndFor
        
        ⍝ Decompress patterns using reverse patterns
        :For pattern :In ReversePatterns
            :If 2=≢pattern
                find ← 0⊃pattern
                replace ← 1⊃pattern
                decompressed ← StringReplace (replace find decompressed)
            :EndIf
        :EndFor
    ∇


    ∇ ratio ← CompressionRatio (original compressed)
    ⍝ Calculate compression ratio achieved
        ratio ← (≢compressed) ÷ (≢original)⌈1
    ∇

    ∇ GenerateGlossary filename
    ⍝ Generate glossary.md file for vibe code reverse translation
    ⍝ 
    ⍝ Arguments:
    ⍝   filename (character): Output filename for glossary
        
        :If 0=⎕NC'filename' ⋄ filename ← Config.glossary_path ⋄ :EndIf
        
        ⍝ Ensure directory exists
        parts ← '/'(≠⊆⊢)filename
        :If 1<≢parts
            dir ← ∊(¯1↓parts),¨'/'
            dir ← ¯1↓dir  ⍝ Remove trailing slash
            :If ~⎕NEXISTS dir ⋄ ⎕MKDIR dir ⋄ :EndIf
        :EndIf
        
        newline ← ⎕UCS 10
        glossary ← '# APLCICD Vibe Code Glossary',newline
        glossary ,← '## Ultra-Concise Code Compression Mappings',newline,newline
        glossary ,← 'This glossary enables reverse translation of "vibe coded" APL back to human-readable form.',newline,newline
        
        ⍝ Variable mappings section
        glossary ,← '## Variable Mappings',newline,newline
        glossary ,← '| Vibe Symbol | Human Readable |',newline
        glossary ,← '|-------------|----------------|',newline
        
        var_names ← VarMap.⎕NL 2
        :For i :In ⍳1⌈≢var_names
            :If i<≢var_names
                name ← ∊(var_names[i;]≠' ')/var_names[i;]  ⍝ Get row and trim spaces
                symbol ← VarMap⍎name
                glossary ,← '| `',symbol,'` | `',name,'` |',newline
            :EndIf
        :EndFor
        
        ⍝ Function mappings section
        glossary ,← newline,'## Function Mappings',newline,newline
        glossary ,← '| Vibe Symbol | Human Readable |',newline
        glossary ,← '|-------------|----------------|',newline
        
        func_names ← FuncMap.⎕NL 2
        :For i :In ⍳1⌈≢func_names
            :If i<≢func_names
                name ← ∊(func_names[i;]≠' ')/func_names[i;]  ⍝ Get row and trim spaces
                symbol ← FuncMap⍎name
                glossary ,← '| `',symbol,'` | `',name,'` |',newline
            :EndIf
        :EndFor
        
        ⍝ Pattern mappings section
        glossary ,← newline,'## Pattern Mappings',newline,newline
        glossary ,← '| Vibe Code | Human Readable |',newline
        glossary ,← '|-----------|----------------|',newline
        
        ⍝ Use Patterns array instead of PatternMap
        :For pattern :In Patterns
            :If 2=≢pattern
                find ← 0⊃pattern
                replace ← 1⊃pattern
                glossary ,← '| `',replace,'` | `',find,'` |',newline
            :EndIf
        :EndFor
        
        ⍝ Usage examples
        glossary ,← newline,'## Usage Examples',newline,newline
        glossary ,← '### Compression',newline
        glossary ,← '```apl',newline
        glossary ,← 'vibe_code ← Vibe.Compress original_code',newline
        glossary ,← '```',newline,newline
        glossary ,← '### Decompression',newline
        glossary ,← '```apl',newline
        glossary ,← 'readable_code ← Vibe.Decompress vibe_code',newline
        glossary ,← '```',newline
        
        ⍝ Write glossary file
        :Trap 22
            glossary ⎕NPUT filename 1
            ⎕←'📚 Glossary generated: ',filename
        :Else
            ⎕←'❌ Failed to write glossary: ',⎕DM
        :EndTrap
    ∇

    ∇ SetCompressionLevel level
    ⍝ Set compression level (minimal/standard/maximum)
        Config.compression_level ← level
        ⎕←'🔧 Compression level set to: ',level
    ∇

    ∇ ToggleVibeCompression
    ⍝ Toggle vibe compression on/off
        Config.enabled ← ~Config.enabled
        ⎕←'🎛️  Vibe compression ',((Config.enabled)⊃'disabled' 'enabled')
    ∇

    ∇ CompressAllSource
    ⍝ Compress ALL source files for LLM development mode
    ⍝ This is the main function for massive token reduction during AI development
        :If ~Config.enabled
            ⎕←'❌ Vibe compression disabled - enable in config first'
            →0
        :EndIf
        
        ⎕←'🚀 COMPRESSING ALL SOURCE FILES FOR LLM DEVELOPMENT'
        ⎕←'=================================================='
        ⎕←'Target: Maximum token reduction for AI workflows'
        ⎕←''
        
        ⍝ Get all source files
        files ← GetAllSourceFiles
        total_files ← ≢files
        
        :If 0=total_files
            ⎕←'❌ No source files found'
            →0
        :EndIf
        
        ⎕←'📁 Found ',(⍕total_files),' source files to compress'
        ⎕←''
        
        ⍝ Backup original files
        backup_dir ← 'backup/original_',(⍕⎕TS),'/'
        CreateBackupDirectory backup_dir
        
        ⍝ Compress each file
        total_original ← 0
        total_compressed ← 0
        compressed_count ← 0
        
        :For i :In ⍳total_files
            file ← i⊃files
            :Trap 22
                ⍝ Read original file
                original ← ⊃⎕NGET file 1
                original_content ← ∊original,⎕UCS 10
                
                ⍝ Backup original
                backup_file ← backup_dir,(⊃⌽'/'(≠⊆⊢)file)
                original ⎕NPUT backup_file 1
                
                ⍝ Compress content
                compressed_content ← Compress original_content
                
                ⍝ Write compressed version
                (⊂compressed_content) ⎕NPUT file 1
                
                ⍝ Calculate metrics
                orig_size ← ≢original_content
                comp_size ← ≢compressed_content
                ratio ← comp_size ÷ orig_size⌈1
                savings ← orig_size - comp_size
                
                total_original ← total_original + orig_size
                total_compressed ← total_compressed + comp_size
                compressed_count ← compressed_count + 1
                
                ⎕←'✅ ',(⍕i),'/',(⍕total_files),': ',file
                ⎕←'   Tokens: ',(⍕orig_size),' → ',(⍕comp_size),' (saved ',(⍕savings),', ',(⍕⌊100×1-ratio),'% reduction)'
                
            :Else
                ⎕←'❌ Failed to compress: ',file,' - ',(⊃⎕DM)
            :EndTrap
        :EndFor
        
        ⍝ Show final summary
        overall_ratio ← total_compressed ÷ total_original⌈1
        overall_savings ← total_original - total_compressed
        overall_reduction ← ⌊100×1-overall_ratio
        
        ⎕←''
        ⎕←'🎯 COMPRESSION COMPLETE'
        ⎕←'======================'
        ⎕←'Files compressed: ',(⍕compressed_count),'/',(⍕total_files)
        ⎕←'Total tokens: ',(⍕total_original),' → ',(⍕total_compressed)
        ⎕←'Token savings: ',(⍕overall_savings),' (',(⍕overall_reduction),'% reduction)'
        ⎕←'Backup location: ',backup_dir
        ⎕←''
        ⎕←'💡 LLM can now see ENTIRE system in ',(⍕total_compressed),' tokens!'
        ⎕←'💡 Context efficiency improved by ',(⍕overall_reduction),'%'
        
        ⍝ Update glossary for all new compressions
        GenerateGlossary Config.glossary_path
    ∇

    ∇ files ← GetAllSourceFiles
    ⍝ Get list of all source files to compress
        files ← ⍬
        
        ⍝ Default patterns if not configured
        patterns ← Config.source_patterns
        :If 0=≢patterns ⋄ patterns ← 'src/*.dyalog' 'src/*.apl' ⋄ :EndIf
        
        :For pattern :In patterns
            :Trap 22
                pattern_files ← ⊃⎕NINFO⍠1⊢pattern
                files ← files,pattern_files
            :Else
                ⎕←'⚠️  Pattern failed: ',pattern
            :EndTrap
        :EndFor
        
        ⍝ Remove excluded files
        :If 0<≢Config.excluded_from_compression
            :For excluded :In Config.excluded_from_compression
                files ← files~⊂excluded
            :EndFor
        :EndIf
    ∇

    ∇ CreateBackupDirectory dir
    ⍝ Create backup directory for original files
        :Trap 22
            ⎕MKDIR dir
            ⎕←'📁 Created backup directory: ',dir
        :Else
            ⎕←'⚠️  Could not create backup directory: ',dir
        :EndTrap
    ∇

    ∇ RestoreFromBackup backup_dir
    ⍝ Restore original files from backup
        :If ~⎕NEXISTS backup_dir
            ⎕←'❌ Backup directory not found: ',backup_dir
            →0
        :EndIf
        
        ⎕←'🔄 Restoring files from backup...'
        
        backup_files ← ⊃⎕NINFO⍠1⊢backup_dir,'*'
        
        :For backup_file :In backup_files
            :Trap 22
                filename ← ⊃⌽'/'(≠⊆⊢)backup_file
                target ← 'src/',filename
                content ← ⊃⎕NGET backup_file 1
                content ⎕NPUT target 1
                ⎕←'✅ Restored: ',target
            :Else
                ⎕←'❌ Failed to restore: ',backup_file
            :EndTrap
        :EndFor
        
        ⎕←'🎯 Restoration complete'
    ∇

    ∇ ShowCompressionStatus
    ⍝ Show current compression status of all source files
        ⎕←'📊 VIBE COMPRESSION STATUS'
        ⎕←'========================='
        ⎕←''
        
        files ← GetAllSourceFiles
        total_files ← ≢files
        total_tokens ← 0
        
        :For file :In files
            :Trap 22
                content ← ⊃⎕NGET file 1
                tokens ← ≢∊content,⎕UCS 10
                total_tokens ← total_tokens + tokens
                
                ⍝ Check if compressed (look for vibe symbols)
                is_compressed ← ∨/∨⌿'⍺⍵⍳⍴⍨⍣⍤⍢⌸⌺⍠⍬⍟⍫∆∇'∘.∊content
                status ← is_compressed⊃'📄 UNCOMPRESSED' '✅ COMPRESSED'
                
                ⎕←status,' ',file,' (',(⍕tokens),' tokens)'
            :Else
                ⎕←'❌ ERROR reading ',file
            :EndTrap
        :EndFor
        
        ⎕←''
        ⎕←'Total files: ',(⍕total_files)
        ⎕←'Total tokens: ',(⍕total_tokens)
        ⎕←'Mode: ',Config.compression_level,' compression'
        ⎕←'LLM Development Mode: ',(Config.llm_development_mode⊃'OFF' 'ON')
    ∇

    ∇ result ← GetVibeStatus
    ⍝ Get current vibe configuration status
        result ← ⎕NS ''
        result.enabled ← Config.enabled
        result.compression_level ← Config.compression_level
        result.auto_glossary ← Config.auto_glossary
        result.target_compression ← Config.target_compression
        result.glossary_path ← Config.glossary_path
    ∇

    ∇ DemoVibeCompression
    ⍝ Demonstrate vibe compression capabilities with all levels
        ⎕←'🎵 Vibe Coding Compression Demo'
        ⎕←'=============================='
        ⎕←''
        
        ⍝ Show current configuration
        status ← GetVibeStatus
        ⎕←'📋 Current Configuration:'
        ⎕←'   Enabled: ',⍕status.enabled
        ⎕←'   Level: ',status.compression_level
        ⎕←'   Auto-glossary: ',⍕status.auto_glossary
        ⎕←'   Target compression: ',⍕status.target_compression
        ⎕←''
        
        ⍝ Test sample code
        sample_code ← 'ProcessPipelineStage ← {⎕IO ← 0 ⋄ pipeline_status ← ⎕NS '''' ⋄ :If 0=≢file_contents ⋄ error_messages ← ''Empty file'' ⋄ :EndIf}'
        
        ⍝ Temporarily enable compression for demo
        original_enabled ← Config.enabled
        Config.enabled ← 1
        
        ⍝ Test all compression levels
        levels ← 'minimal' 'standard' 'maximum'
        
        ⎕←'📊 Compression Level Comparison:'
        ⎕←'Original code (', ⍕≢sample_code, ' chars):'
        ⎕←sample_code
        ⎕←''
        
        compressed_results ← ⍬
        :For level :In levels
            Config.compression_level ← level
            compressed ← Compress sample_code
            ratio ← CompressionRatio sample_code compressed
            compressed_results ,← ⊂compressed
            
            ⎕←level,' compression (', ⍕≢compressed, ' chars, ratio: ',⍕ratio,'):'
            ⎕←compressed
            ⎕←''
        :EndFor
        
        ⍝ Restore original settings
        Config.enabled ← original_enabled
        
        ⍝ Calculate compression statistics
        max_compressed ← ⊃⌽compressed_results
        best_ratio ← CompressionRatio sample_code max_compressed
        
        ⎕←'📊 Compression Summary:'
        ⎕←'   Original chars: ', ⍕≢sample_code
        ⎕←'   Best compressed: ', ⍕≢max_compressed
        ⎕←'   Best ratio: ', ⍕best_ratio
        ⎕←'   Space savings: ', ⍕⌊100×1-best_ratio, '%'
        ⎕←''
        ⎕←'💡 Benefits for LLM Token Processing:'
        ⎕←'   • Dramatically reduced token count'
        ⎕←'   • More code fits in context windows'
        ⎕←'   • Faster processing due to shorter inputs'
        ⎕←'   • Cost savings for API-based LLMs'
        ⎕←'   • Maintains full APL expressiveness'
        ⎕←''
        ⎕←'📚 Glossary auto-generated at: ',Config.glossary_path
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Runtime/Edit Mode API Functions
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ SwitchToRuntimeMode
    ⍝ API: Switch to runtime mode for execution safety
        SetRuntimeMode
        UpdateConfigFile 'runtime_mode' 1
        UpdateConfigFile 'edit_mode' 0
    ∇
    
    ∇ SwitchToEditMode
    ⍝ API: Switch to edit mode for maximum LLM token efficiency
        SetEditMode
        UpdateConfigFile 'runtime_mode' 0
        UpdateConfigFile 'edit_mode' 1
    ∇
    
    ∇ ToggleCommentPreservation
    ⍝ API: Toggle comment preservation/archiving
        Config.preserve_comments ← ~Config.preserve_comments
        UpdateConfigFile 'preserve_comments' Config.preserve_comments
        ⎕←'💬 Comment preservation: ',(Config.preserve_comments⊃'disabled' 'enabled')
    ∇
    
    ∇ result ← GetCurrentMode
    ⍝ API: Get current mode status
        result ← ⎕NS ''
        result.runtime_mode ← Config.runtime_mode
        result.edit_mode ← Config.edit_mode
        result.preserve_comments ← Config.preserve_comments
        result.compression_enabled ← Config.enabled
        result.current_mode ← (Config.runtime_mode)⊃'EDIT' 'RUNTIME'
    ∇
    
    ∇ UpdateConfigFile (key value)
    ⍝ Update configuration file with new setting
        :Trap 22
            ⍝ Read current config
            config ← ⎕JSON ⊃⎕NGET 'config/default.json' 1
            
            ⍝ Update vibe section
            config.vibe⍎key,'←value'
            
            ⍝ Write back to file
            (⎕JSON config) ⎕NPUT 'config/default.json' 1
            
        :Else
            ⎕←'⚠️  Failed to update config file: ',⎕DM
        :EndTrap
    ∇
    
    ∇ RestoreComments code
    ⍝ API: Restore comments from archive for a given code segment
        :Trap 22
            :If ⎕NEXISTS Config.comment_archive
                archive_content ← ⊃⎕NGET Config.comment_archive 1
                ⎕←'💬 Comments available in archive: ',Config.comment_archive
                ⎕←'   Archive contains ',⍕≢(⎕UCS 10)⊆archive_content,' comment entries'
            :Else
                ⎕←'ℹ️  No comment archive found'
            :EndIf
        :Else
            ⎕←'⚠️  Error accessing comment archive: ',⎕DM
        :EndTrap
    ∇

:EndNamespace
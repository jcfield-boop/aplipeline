:Namespace Plugins
⍝ APLCICD Plugin Architecture
⍝ Extensible system for custom validators and processors

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize Plugins namespace
        ⎕←'  ✅ Plugin architecture loaded'
        ⍝ Initialize plugin registry
        Registry ← ⎕NS ''
        Registry.validators ← ⍬
        Registry.processors ← ⍬
        Registry.analyzers ← ⍬
        Registry.hooks ← ⍬
    ∇

    ∇ result ← RegisterPlugin plugin_info
    ⍝ Register a new plugin with the system
        result ← ⎕NS ''
        result.success ← 0
        
        ⍝ Validate plugin information
        required_fields ← 'name' 'type' 'version' 'function'
        :If ~∧/required_fields∊plugin_info.⎕NL 2
            result.error ← 'Missing required fields: ',∊required_fields~plugin_info.⎕NL 2
            :Return
        :EndIf
        
        ⍝ Validate plugin type
        valid_types ← 'validator' 'processor' 'analyzer' 'hook'
        :If ~plugin_info.type∊valid_types
            result.error ← 'Invalid plugin type. Must be one of: ',∊valid_types
            :Return
        :EndIf
        
        ⍝ Check if plugin already exists
        :If IsPluginRegistered plugin_info.name
            result.error ← 'Plugin already registered: ',plugin_info.name
            :Return
        :EndIf
        
        ⍝ Add plugin to appropriate registry
        plugin_entry ← ⎕NS ''
        plugin_entry.name ← plugin_info.name
        plugin_entry.type ← plugin_info.type
        plugin_entry.version ← plugin_info.version
        plugin_entry.function ← plugin_info.function
        plugin_entry.description ← plugin_info.description
        plugin_entry.enabled ← 1
        plugin_entry.registered ← ⎕TS
        
        :Select plugin_info.type
        :Case 'validator'
            Registry.validators ,← ⊂plugin_entry
        :Case 'processor'
            Registry.processors ,← ⊂plugin_entry
        :Case 'analyzer'
            Registry.analyzers ,← ⊂plugin_entry
        :Case 'hook'
            Registry.hooks ,← ⊂plugin_entry
        :EndSelect
        
        result.success ← 1
        result.message ← 'Plugin registered successfully: ',plugin_info.name
    ∇

    ∇ exists ← IsPluginRegistered name
    ⍝ Check if a plugin is already registered
        all_plugins ← Registry.validators,Registry.processors,Registry.analyzers,Registry.hooks
        plugin_names ← ⊃¨all_plugins.name
        exists ← name∊plugin_names
    ∇

    ∇ plugins ← ListPlugins type
    ⍝ List plugins of specified type (or all if not specified)
        :If 0=⎕NC'type'
            plugins ← Registry.validators,Registry.processors,Registry.analyzers,Registry.hooks
        :Else
            :Select type
            :Case 'validator'
                plugins ← Registry.validators
            :Case 'processor'
                plugins ← Registry.processors
            :Case 'analyzer'
                plugins ← Registry.analyzers
            :Case 'hook'
                plugins ← Registry.hooks
            :Else
                plugins ← ⍬
            :EndSelect
        :EndIf
    ∇

    ∇ results ← RunValidatorPlugins data
    ⍝ Execute all enabled validator plugins
        results ← ⍬
        validators ← ListPlugins 'validator'
        enabled_validators ← validators/⍨⊃¨validators.enabled
        
        :For validator :In enabled_validators
            :Trap 0
                plugin_result ← data ⍎validator.function
                
                result_entry ← ⎕NS ''
                result_entry.plugin ← validator.name
                result_entry.success ← 1
                result_entry.result ← plugin_result
                result_entry.timestamp ← ⎕TS
                
                results ,← ⊂result_entry
            :Else
                error_entry ← ⎕NS ''
                error_entry.plugin ← validator.name
                error_entry.success ← 0
                error_entry.error ← ⎕DM
                error_entry.timestamp ← ⎕TS
                
                results ,← ⊂error_entry
            :EndTrap
        :EndFor
    ∇

    ∇ results ← RunProcessorPlugins data
    ⍝ Execute all enabled processor plugins in sequence
        results ← data  ⍝ Start with original data
        processors ← ListPlugins 'processor'
        enabled_processors ← processors/⍨⊃¨processors.enabled
        
        :For processor :In enabled_processors
            :Trap 0
                results ← results ⍎processor.function
            :Else
                ⍝ Log error but continue with unmodified data
                ⎕←'Processor plugin failed: ',processor.name,' - ',⎕DM
            :EndTrap
        :EndFor
    ∇

    ∇ results ← RunAnalyzerPlugins data
    ⍝ Execute all enabled analyzer plugins
        results ← ⍬
        analyzers ← ListPlugins 'analyzer'
        enabled_analyzers ← analyzers/⍨⊃¨analyzers.enabled
        
        :For analyzer :In enabled_analyzers
            :Trap 0
                analysis_result ← data ⍎analyzer.function
                
                result_entry ← ⎕NS ''
                result_entry.plugin ← analyzer.name
                result_entry.success ← 1
                result_entry.analysis ← analysis_result
                result_entry.timestamp ← ⎕TS
                
                results ,← ⊂result_entry
            :Else
                error_entry ← ⎕NS ''
                error_entry.plugin ← analyzer.name
                error_entry.success ← 0
                error_entry.error ← ⎕DM
                error_entry.timestamp ← ⎕TS
                
                results ,← ⊂error_entry
            :EndTrap
        :EndFor
    ∇

    ∇ ExecuteHooks hook_point data
    ⍝ Execute hooks at specified hook points
        hooks ← ListPlugins 'hook'
        enabled_hooks ← hooks/⍨⊃¨hooks.enabled
        relevant_hooks ← enabled_hooks/⍨hook_point∊¨enabled_hooks.hook_point
        
        :For hook :In relevant_hooks
            :Trap 0
                data ⍎hook.function
            :Else
                ⍝ Log hook failure but continue
                ⎕←'Hook failed: ',hook.name,' at ',hook_point,' - ',⎕DM
            :EndTrap
        :EndFor
    ∇

    ∇ result ← EnablePlugin name
    ⍝ Enable a registered plugin
        result ← ⎕NS ''
        result.success ← 0
        
        :If ~IsPluginRegistered name
            result.error ← 'Plugin not found: ',name
            :Return
        :EndIf
        
        ⍝ Find and enable plugin
        all_plugins ← Registry.validators,Registry.processors,Registry.analyzers,Registry.hooks
        plugin_index ← ⊃⍸name∊⊃¨all_plugins.name
        
        :If 0<≢plugin_index
            (plugin_index⊃all_plugins).enabled ← 1
            result.success ← 1
            result.message ← 'Plugin enabled: ',name
        :Else
            result.error ← 'Failed to enable plugin: ',name
        :EndIf
    ∇

    ∇ result ← DisablePlugin name
    ⍝ Disable a registered plugin
        result ← ⎕NS ''
        result.success ← 0
        
        :If ~IsPluginRegistered name
            result.error ← 'Plugin not found: ',name
            :Return
        :EndIf
        
        ⍝ Find and disable plugin
        all_plugins ← Registry.validators,Registry.processors,Registry.analyzers,Registry.hooks
        plugin_index ← ⊃⍸name∊⊃¨all_plugins.name
        
        :If 0<≢plugin_index
            (plugin_index⊃all_plugins).enabled ← 0
            result.success ← 1
            result.message ← 'Plugin disabled: ',name
        :Else
            result.error ← 'Failed to disable plugin: ',name
        :EndIf
    ∇

    ∇ result ← UnregisterPlugin name
    ⍝ Completely remove a plugin from the registry
        result ← ⎕NS ''
        result.success ← 0
        
        :If ~IsPluginRegistered name
            result.error ← 'Plugin not found: ',name
            :Return
        :EndIf
        
        ⍝ Remove from appropriate registry
        :If name∊⊃¨Registry.validators.name
            Registry.validators ← Registry.validators/⍨name≢⊃¨Registry.validators.name
        :ElseIf name∊⊃¨Registry.processors.name
            Registry.processors ← Registry.processors/⍨name≢⊃¨Registry.processors.name
        :ElseIf name∊⊃¨Registry.analyzers.name
            Registry.analyzers ← Registry.analyzers/⍨name≢⊃¨Registry.analyzers.name
        :ElseIf name∊⊃¨Registry.hooks.name
            Registry.hooks ← Registry.hooks/⍨name≢⊃¨Registry.hooks.name
        :EndIf
        
        result.success ← 1
        result.message ← 'Plugin unregistered: ',name
    ∇

    ∇ CreateSamplePlugins
    ⍝ Create sample plugins to demonstrate the architecture
        
        ⍝ Sample Validator Plugin
        validator_info ← ⎕NS ''
        validator_info.name ← 'APLStyleValidator'
        validator_info.type ← 'validator'
        validator_info.version ← '1.0.0'
        validator_info.function ← 'SampleAPLStyleValidator'
        validator_info.description ← 'Validates APL code style conventions'
        
        RegisterPlugin validator_info
        
        ⍝ Sample Processor Plugin  
        processor_info ← ⎕NS ''
        processor_info.name ← 'CommentProcessor'
        processor_info.type ← 'processor'
        processor_info.version ← '1.0.0'
        processor_info.function ← 'SampleCommentProcessor'
        processor_info.description ← 'Processes and enhances code comments'
        
        RegisterPlugin processor_info
        
        ⍝ Sample Analyzer Plugin
        analyzer_info ← ⎕NS ''
        analyzer_info.name ← 'ComplexityAnalyzer'
        analyzer_info.type ← 'analyzer'
        analyzer_info.version ← '1.0.0'
        analyzer_info.function ← 'SampleComplexityAnalyzer'
        analyzer_info.description ← 'Analyzes code complexity metrics'
        
        RegisterPlugin analyzer_info
    ∇

    ∇ result ← SampleAPLStyleValidator code
    ⍝ Sample validator plugin for APL style
        result ← ⎕NS ''
        result.valid ← 1
        result.issues ← ⍬
        
        ⍝ Check for consistent indentation
        lines ← ⊃,/code
        indents ← ≢¨(⊃' ')∘⊃¨lines
        :If 1<≢∪indents/⍨indents>0
            result.issues ,← ⊂'Inconsistent indentation detected'
        :EndIf
        
        ⍝ Check for proper commenting
        comment_ratio ← (+/'⍝'∊¨lines) ÷ ≢lines
        :If comment_ratio < 0.2
            result.issues ,← ⊂'Low comment ratio (< 20%)'
        :EndIf
        
        result.valid ← 0=≢result.issues
        result.score ← (1-≢result.issues÷10)⌊1⌈0
    ∇

    ∇ processed ← SampleCommentProcessor code
    ⍝ Sample processor plugin for comment enhancement
        processed ← code
        
        ⍝ Add function header comments if missing
        :For i :In ⍳≢processed
            line ← i⊃processed
            :If '∇'∊line
                :If (i=0)∨(~'⍝'∊(i-1)⊃processed)
                    header ← '⍝ Function: ',∊line/⍨line≠'∇'
                    processed ← (i-1)↑processed,(⊂header),i↓processed
                :EndIf
            :EndIf
        :EndFor
    ∇

    ∇ analysis ← SampleComplexityAnalyzer code
    ⍝ Sample analyzer plugin for complexity analysis
        analysis ← ⎕NS ''
        
        ⍝ Count operators and functions
        all_text ← ∊code
        operators ← '¨⍨/\⌿⍀.∘⍣⍠⌸@⌺⍸'
        primitives ← '+-×÷*⍟⌹○!?∊⍷∪∩~∨∧⍱⍲⍴,⍪⌽⊖⍉↑↓⊂⊃⌷⍋⍒⊤⊥⍕⍎⊆'
        
        analysis.operator_count ← +/operators∊all_text
        analysis.primitive_count ← +/primitives∊all_text
        analysis.total_chars ← ≢all_text
        analysis.operator_density ← analysis.operator_count ÷ analysis.total_chars⌈1
        analysis.primitive_density ← analysis.primitive_count ÷ analysis.total_chars⌈1
        
        ⍝ Complexity score (higher = more complex)
        analysis.complexity_score ← analysis.operator_density + analysis.primitive_density
        
        ⍝ Complexity classification
        :If analysis.complexity_score < 0.1
            analysis.complexity_level ← 'Simple'
        :ElseIf analysis.complexity_score < 0.3
            analysis.complexity_level ← 'Moderate'
        :Else
            analysis.complexity_level ← 'Complex'
        :EndIf
    ∇

    ∇ status ← PluginStatus
    ⍝ Get comprehensive plugin system status
        status ← ⎕NS ''
        status.timestamp ← ⎕TS
        
        ⍝ Count plugins by type
        status.validator_count ← ≢Registry.validators
        status.processor_count ← ≢Registry.processors
        status.analyzer_count ← ≢Registry.analyzers
        status.hook_count ← ≢Registry.hooks
        status.total_plugins ← status.validator_count + status.processor_count + status.analyzer_count + status.hook_count
        
        ⍝ Count enabled plugins
        all_plugins ← Registry.validators,Registry.processors,Registry.analyzers,Registry.hooks
        status.enabled_count ← +/⊃¨all_plugins.enabled
        status.disabled_count ← status.total_plugins - status.enabled_count
        
        ⍝ Plugin health check
        status.health_status ← (status.enabled_count > 0)⊃'No active plugins' 'Operational'
    ∇

:EndNamespace
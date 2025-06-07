:Namespace Configuration
⍝ APLCICD Configuration Management
⍝ Persistent configuration with save/load capabilities

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize Configuration namespace
        ⎕←'  ✅ Configuration functions loaded'
    ∇

    ∇ config ← DefaultConfig
    ⍝ Create default configuration
        config ← ⎕NS ''
        
        ⍝ Pipeline settings
        config.quality_threshold ← 0.5
        config.ai_detection_threshold ← 0.3
        config.security_strict ← 1
        config.syntax_required ← 1
        
        ⍝ File patterns
        config.include_patterns ← '*.dyalog' '*.apl'
        config.exclude_patterns ← '*.tmp' '*.bak' '*.log'
        
        ⍝ GitHub integration
        config.auto_reject_ai ← 0
        config.require_tests ← 1
        config.quality_gate ← 0.5
        
        ⍝ Performance settings
        config.benchmark_iterations ← 1000
        config.enable_profiling ← 1
        config.cache_results ← 1
        
        ⍝ Error handling
        config.error_tolerance ← 'medium'
        config.continue_on_error ← 1
        config.log_errors ← 1
        
        ⍝ System settings
        config.workspace_size ← 64000000
        config.output_format ← 'detailed'
        config.timezone ← 'UTC'
        
        ⍝ Metadata
        config.version ← '1.0.0'
        config.created ← ⎕TS
        config.modified ← ⎕TS
    ∇

    ∇ result ← SaveConfig config filename
    ⍝ Save configuration to file
        :If 0=⎕NC'filename' ⋄ filename←'aplcicd.config' ⋄ :EndIf
        
        result ← ⎕NS ''
        result.success ← 0
        result.filename ← filename
        result.timestamp ← ⎕TS
        
        ⍝ Update modification time
        config.modified ← ⎕TS
        
        :Trap 0
            ⍝ Convert to JSON-like format for APL
            config_text ← FormatConfigText config
            config_text ⎕NPUT filename 1
            result.success ← 1
            result.message ← 'Configuration saved successfully'
        :Else
            result.success ← 0
            result.error ← ⎕EN ⎕DM
            result.message ← 'Failed to save configuration: ',⎕DM
        :EndTrap
    ∇

    ∇ config ← LoadConfig filename
    ⍝ Load configuration from file
        :If 0=⎕NC'filename' ⋄ filename←'aplcicd.config' ⋄ :EndIf
        
        :Trap 22  ⍝ FILE_ERROR
            config_text ← ⊃⎕NGET filename 1
            config ← ParseConfigText config_text
            ⍝ Validate loaded configuration
            config ← ValidateConfig config
        :Else
            ⍝ Return default configuration if file not found
            config ← DefaultConfig
            ⍝ Automatically save default configuration
            SaveConfig config filename
        :EndTrap
    ∇

    ∇ config_text ← FormatConfigText config
    ⍝ Format configuration as text for saving
        config_text ← ⍬
        config_text ,← ⊂'⍝ APLCICD Configuration File'
        config_text ,← ⊂'⍝ Generated: ',⍕⎕TS
        config_text ,← ⊂''
        
        ⍝ Format each field
        fields ← config.⎕NL 2 9  ⍝ Variables and namespaces
        :For field :In fields
            value ← config⍎field
            :If 2=⍴⍴value  ⍝ Matrix
                config_text ,← ⊂field,' ← ',⍕value
            :ElseIf 1=⍴⍴value  ⍝ Vector
                :If ∧/' '≠⊃value  ⍝ Character vector
                    config_text ,← ⊂field,' ← ''',value,''''
                :Else  ⍝ Numeric or mixed vector
                    config_text ,← ⊂field,' ← ',⍕value
                :EndIf
            :Else  ⍝ Scalar
                :If 0=⊃⍴value  ⍝ Character scalar/string
                    config_text ,← ⊂field,' ← ''',value,''''
                :Else  ⍝ Numeric scalar
                    config_text ,← ⊂field,' ← ',⍕value
                :EndIf
            :EndIf
        :EndFor
    ∇

    ∇ config ← ParseConfigText config_text
    ⍝ Parse configuration text back to namespace
        config ← ⎕NS ''
        
        ⍝ Filter out comments and empty lines
        valid_lines ← config_text/⍨~∨/¨('⍝'∊¨config_text)∨(0=≢¨config_text)
        
        :For line :In valid_lines
            :If '←'∊line
                parts ← '←'(≠⊆⊢)line
                :If 2=≢parts
                    field ← ∊⊃parts/⍨~' '∊¨parts  ⍝ Remove spaces
                    value_text ← ∊1↓parts/⍨~' '∊¨parts
                    
                    ⍝ Parse value
                    :Trap 0
                        :If ''''∊value_text  ⍝ String value
                            value ← 1↓¯1↓value_text  ⍝ Remove quotes
                        :Else  ⍝ Numeric value
                            value ← ⍎value_text
                        :EndIf
                        config⍎field,'←value'
                    :Else
                        ⍝ Skip invalid lines
                    :EndTrap
                :EndIf
            :EndIf
        :EndFor
        
        ⍝ If parsing failed, return default
        :If 0=≢config.⎕NL 2 9
            config ← DefaultConfig
        :EndIf
    ∇

    ∇ config ← ValidateConfig config
    ⍝ Validate configuration values and fix invalid ones
        default ← DefaultConfig
        
        ⍝ Validate thresholds (must be 0-1)
        :If (0>config.quality_threshold)∨(config.quality_threshold>1)
            config.quality_threshold ← default.quality_threshold
        :EndIf
        
        :If (0>config.ai_detection_threshold)∨(config.ai_detection_threshold>1)
            config.ai_detection_threshold ← default.ai_detection_threshold
        :EndIf
        
        ⍝ Validate boolean flags
        :If ~config.security_strict∊0 1
            config.security_strict ← default.security_strict
        :EndIf
        
        :If ~config.syntax_required∊0 1
            config.syntax_required ← default.syntax_required
        :EndIf
        
        ⍝ Validate workspace size (minimum 1MB)
        :If config.workspace_size < 1000000
            config.workspace_size ← default.workspace_size
        :EndIf
        
        ⍝ Validate benchmark iterations (minimum 10)
        :If config.benchmark_iterations < 10
            config.benchmark_iterations ← default.benchmark_iterations
        :EndIf
        
        ⍝ Validate error tolerance
        :If ~config.error_tolerance∊'low' 'medium' 'high'
            config.error_tolerance ← default.error_tolerance
        :EndIf
        
        ⍝ Ensure required fields exist
        required_fields ← 'quality_threshold' 'ai_detection_threshold' 'security_strict'
        :For field :In required_fields
            :If 0=config.⎕NC field
                config⍎field,'←default⍎field'
            :EndIf
        :EndFor
    ∇

    ∇ config ← MergeConfigs base overlay
    ⍝ Merge two configurations (overlay takes precedence)
        config ← base
        
        overlay_fields ← overlay.⎕NL 2 9
        :For field :In overlay_fields
            config⍎field,'←overlay⍎field'
        :EndFor
        
        ⍝ Update modification time
        config.modified ← ⎕TS
    ∇

    ∇ result ← ExportConfig config format filename
    ⍝ Export configuration in various formats
        :If 0=⎕NC'format' ⋄ format←'apl' ⋄ :EndIf
        :If 0=⎕NC'filename' ⋄ filename←'aplcicd_export.',format ⋄ :EndIf
        
        result ← ⎕NS ''
        result.success ← 0
        result.format ← format
        result.filename ← filename
        
        :Select format
        :Case 'apl'
            export_text ← FormatConfigText config
            
        :Case 'json'
            export_text ← FormatConfigJSON config
            
        :Case 'env'
            export_text ← FormatConfigEnv config
            
        :Else
            result.error ← 'Unsupported format: ',format
            :Return
        :EndSelect
        
        :Trap 0
            export_text ⎕NPUT filename 1
            result.success ← 1
            result.message ← 'Configuration exported successfully'
        :Else
            result.error ← 'Export failed: ',⎕DM
        :EndTrap
    ∇

    ∇ json_text ← FormatConfigJSON config
    ⍝ Format configuration as JSON-like text
        json_text ← ⊂'{'
        fields ← config.⎕NL 2
        
        :For i :In ⍳≢fields
            field ← i⊃fields
            value ← config⍎field
            
            :If 1=≢⍴value  ⍝ String
                line ← '  "',field,'": "',value,'"'
            :Else  ⍝ Number
                line ← '  "',field,'": ',⍕value
            :EndIf
            
            :If i<≢fields
                line ,← ','
            :EndIf
            
            json_text ,← ⊂line
        :EndFor
        
        json_text ,← ⊂'}'
    ∇

    ∇ env_text ← FormatConfigEnv config
    ⍝ Format configuration as environment variables
        env_text ← ⍬
        fields ← config.⎕NL 2
        
        :For field :In fields
            value ← config⍎field
            env_name ← 'APLCICD_',⎕C field
            env_text ,← ⊂env_name,'=',⍕value
        :EndFor
    ∇

    ∇ config ← LoadEnvironmentConfig
    ⍝ Load configuration from environment variables
        config ← DefaultConfig
        
        ⍝ Environment variable mappings
        env_mappings ← 2 2⍴'APLCICD_QUALITY_THRESHOLD' 'quality_threshold' 'APLCICD_AI_THRESHOLD' 'ai_detection_threshold'
        env_mappings ⍪← 'APLCICD_SECURITY_STRICT' 'security_strict'
        env_mappings ⍪← 'APLCICD_WORKSPACE_SIZE' 'workspace_size'
        
        :For mapping :In ↓env_mappings
            env_var ← ⊃mapping
            config_field ← 1⊃mapping
            
            ⍝ Try to get environment variable (simplified for APL)
            ⍝ In real implementation, would use system call
            ⍝ env_value ← GetEnvironmentVariable env_var
            ⍝ :If env_value≢''
            ⍝     config⍎config_field,'←ParseValue env_value'
            ⍝ :EndIf
        :EndFor
    ∇

    ∇ configs ← ListConfigurations directory
    ⍝ List available configuration files
        :If 0=⎕NC'directory' ⋄ directory←'.' ⋄ :EndIf
        
        ⍝ Find configuration files
        config_files ← '*.config' ⎕NINFO ⍠1⊢directory
        
        configs ← ⍬
        :For file :In config_files
            config_info ← ⎕NS ''
            config_info.filename ← file
            config_info.size ← ⊃⎕NINFO file
            config_info.modified ← 1⊃⎕NINFO file
            
            ⍝ Try to load and get basic info
            :Trap 0
                temp_config ← LoadConfig file
                config_info.version ← temp_config.version
                config_info.valid ← 1
            :Else
                config_info.version ← 'Unknown'
                config_info.valid ← 0
            :EndTrap
            
            configs ,← ⊂config_info
        :EndFor
    ∇

    ∇ result ← CreateConfigTemplate name
    ⍝ Create a configuration template with comments
        :If 0=⎕NC'name' ⋄ name←'template' ⋄ :EndIf
        
        template ← ⍬
        template ,← ⊂'⍝ APLCICD Configuration Template'
        template ,← ⊂'⍝ Copy and modify this template for your needs'
        template ,← ⊂''
        template ,← ⊂'⍝ Quality threshold (0.0-1.0): minimum code quality score'
        template ,← ⊂'quality_threshold ← 0.5'
        template ,← ⊂''
        template ,← ⊂'⍝ AI detection threshold (0.0-1.0): sensitivity for AI detection'
        template ,← ⊂'ai_detection_threshold ← 0.3'
        template ,← ⊂''
        template ,← ⊂'⍝ Security scanning (0/1): enable strict security scanning'
        template ,← ⊂'security_strict ← 1'
        template ,← ⊂''
        template ,← ⊂'⍝ File patterns (text vectors): files to include/exclude'
        template ,← ⊂'include_patterns ← ''*.dyalog'' ''*.apl'''
        template ,← ⊂'exclude_patterns ← ''*.tmp'' ''*.bak'''
        
        filename ← name,'.config.template'
        
        result ← ⎕NS ''
        :Trap 0
            template ⎕NPUT filename 1
            result.success ← 1
            result.filename ← filename
            result.message ← 'Template created successfully'
        :Else
            result.success ← 0
            result.error ← ⎕DM
        :EndTrap
    ∇

:EndNamespace
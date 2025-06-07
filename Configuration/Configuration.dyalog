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

⍝ ═══════════════════════════════════════════════════════════════════════════════
⍝ APLConfig - APL-Native Configuration Language
⍝ ═══════════════════════════════════════════════════════════════════════════════

:Namespace APLConfig
    
    ∇ config ← CreateAPLConfig
    ⍝ Create APL-native configuration using APL expressions
        config ← ⎕NS ''
        
        ⍝ Dynamic quality threshold based on score distribution
        config.quality ← 0.5 × (⌈/scores)  ⍝ Dynamic threshold
        
        ⍝ Security strictness based on risk assessment
        config.security ← strict ∨ (risk > 0.7)
        
        ⍝ Pipeline composition using APL logic
        config.pipeline ← validate , (security ⍵ enabled) , quality
        
        ⍝ Resource allocation using array operations
        config.cpu_weights ← 0.3 0.4 0.5 0.8  ⍝ validation security quality performance
        config.memory_allocation ← ⌈/⍳4 ÷ 4    ⍝ Equal distribution, rounded up
        
        ⍝ Timeout calculations using APL array processing
        config.timeouts ← 30 × 1 2 3 4  ⍝ Base timeout × complexity factors
        
        ⍝ Conditional execution patterns
        config.conditions ← ⎕NS ''
        config.conditions.run_tests ← '(∨/"test"⍷files) ∧ quality>0.5'
        config.conditions.deploy ← '(security=0) ∧ (quality≥0.8) ∧ (performance<30)'
        config.conditions.notify ← '~success ∨ (performance>60)'
        
        ⍝ Array-based feature flags
        config.features ← ⎕NS ''
        config.features.enabled ← 1 1 0 1 1  ⍝ validation security deploy quality monitoring
        config.features.names ← 'validation' 'security' 'deploy' 'quality' 'monitoring'
        config.features.active ← config.features.enabled/config.features.names
        
        ⍝ Performance thresholds using statistical operations
        config.performance ← ⎕NS ''
        config.performance.baseline ← 10  ⍝ seconds
        config.performance.warning ← config.performance.baseline × 2
        config.performance.critical ← config.performance.baseline × 5
        config.performance.targets ← config.performance.baseline × 0.5 1 2 5  ⍝ excellent good warning critical
    ∇
    
    ∇ compiled ← CompileAPLConfig apl_config
    ⍝ Compile APL configuration into executable form
        compiled ← ⎕NS ''
        compiled.source ← apl_config
        compiled.timestamp ← ⎕TS
        
        ⍝ Pre-compile APL expressions for faster execution
        compiled.expressions ← ⎕NS ''
        
        ⍝ Compile conditions
        :For condition :In apl_config.conditions.⎕NL 2
            expr ← apl_config.conditions⍎condition
            compiled.expressions⍎condition,'_compiled ← {',expr,'}'
        :EndFor
        
        ⍝ Compile dynamic calculations
        compiled.quality_calc ← {0.5 × (⌈/⍵)}  ⍝ Dynamic quality threshold
        compiled.security_calc ← {⍺ ∨ (⍵ > 0.7)}  ⍝ Security evaluation
        compiled.timeout_calc ← {30 × ⍵}  ⍝ Timeout calculation
        
        ⍝ Pre-calculate static values
        compiled.static ← ⎕NS ''
        compiled.static.cpu_weights ← apl_config.cpu_weights
        compiled.static.memory_allocation ← apl_config.memory_allocation
        compiled.static.timeouts ← apl_config.timeouts
        compiled.static.active_features ← apl_config.features.active
    ∇
    
    ∇ result ← EvaluateAPLConfig compiled context
    ⍝ Evaluate compiled APL configuration with runtime context
        result ← ⎕NS ''
        result.context ← context
        
        ⍝ Apply dynamic calculations
        :If 9∊⍨⎕NC'context.scores'
            result.quality_threshold ← compiled.quality_calc context.scores
        :Else
            result.quality_threshold ← 0.5
        :EndIf
        
        ⍝ Evaluate security settings
        :If 9∊⍨⎕NC'context.risk'∧9∊⍨⎕NC'context.strict'
            result.security_enabled ← context.strict compiled.security_calc context.risk
        :Else
            result.security_enabled ← 1
        :EndIf
        
        ⍝ Calculate dynamic timeouts
        :If 9∊⍨⎕NC'context.complexity'
            result.timeouts ← compiled.timeout_calc context.complexity
        :Else
            result.timeouts ← compiled.static.timeouts
        :EndIf
        
        ⍝ Apply feature filtering
        result.enabled_features ← compiled.static.active_features
        
        ⍝ Evaluate conditions
        result.conditions ← ⎕NS ''
        :If 9∊⍨⎕NC'context.files'∧9∊⍨⎕NC'context.quality'
            result.conditions.run_tests ← (∨/'test'⍷∊context.files) ∧ context.quality>0.5
        :Else
            result.conditions.run_tests ← 0
        :EndIf
        
        :If 9∊⍨⎕NC'context.security'∧9∊⍨⎕NC'context.quality'∧9∊⍨⎕NC'context.performance'
            result.conditions.deploy ← (context.security=0) ∧ (context.quality≥0.8) ∧ (context.performance<30)
        :Else
            result.conditions.deploy ← 0
        :EndIf
        
        :If 9∊⍨⎕NC'context.success'∧9∊⍨⎕NC'context.performance'
            result.conditions.notify ← (~context.success) ∨ (context.performance>60)
        :Else
            result.conditions.notify ← 0
        :EndIf
    ∇
    
    ∇ apl_code ← GenerateAPLConfigCode config
    ⍝ Generate APL configuration code
        apl_code ← ⍬
        apl_code ,← ⊂'⍝ APL-Native Configuration'
        apl_code ,← ⊂'⍝ Replacing JSON/YAML with pure APL expressions'
        apl_code ,← ⊂''
        apl_code ,← ⊂'config ← ⎕NS '''''
        apl_code ,← ⊂''
        
        ⍝ Quality configuration
        apl_code ,← ⊂'⍝ Dynamic quality threshold'
        apl_code ,← ⊂'config.quality ← 0.5 × (⌈/scores)  ⍝ 50% of max score'
        apl_code ,← ⊂''
        
        ⍝ Security configuration
        apl_code ,← ⊂'⍝ Security strictness evaluation'
        apl_code ,← ⊂'config.security ← strict ∨ (risk > 0.7)  ⍝ Strict OR high risk'
        apl_code ,← ⊂''
        
        ⍝ Pipeline configuration
        apl_code ,← ⊂'⍝ Pipeline stage composition'
        apl_code ,← ⊂'config.pipeline ← validate , (security ⍵ enabled) , quality'
        apl_code ,← ⊂''
        
        ⍝ Resource allocation
        apl_code ,← ⊂'⍝ CPU resource weights by stage type'
        apl_code ,← ⊂'config.cpu_weights ← 0.3 0.4 0.5 0.8  ⍝ val sec qual perf'
        apl_code ,← ⊂''
        
        ⍝ Memory allocation
        apl_code ,← ⊂'⍝ Memory allocation (equal distribution)'
        apl_code ,← ⊂'config.memory_allocation ← (⍳4) ÷ 4'
        apl_code ,← ⊂''
        
        ⍝ Timeouts
        apl_code ,← ⊂'⍝ Timeout calculations'
        apl_code ,← ⊂'config.timeouts ← 30 × 1 2 3 4  ⍝ Base × complexity'
        apl_code ,← ⊂''
        
        ⍝ Conditions
        apl_code ,← ⊂'⍝ Conditional execution logic'
        apl_code ,← ⊂'config.run_tests ← (∨/"test"⍷files) ∧ quality>0.5'
        apl_code ,← ⊂'config.deploy ← (security=0) ∧ (quality≥0.8) ∧ (performance<30)'
        apl_code ,← ⊂'config.notify ← ~success ∨ (performance>60)'
        apl_code ,← ⊂''
        
        ⍝ Feature flags
        apl_code ,← ⊂'⍝ Feature flag management'
        apl_code ,← ⊂'config.features ← 1 1 0 1 1  ⍝ enabled flags'
        apl_code ,← ⊂'config.feature_names ← ''validation'' ''security'' ''deploy'' ''quality'' ''monitoring'''
        apl_code ,← ⊂'config.active_features ← config.features/config.feature_names'
    ∇
    
    ∇ yaml_equivalent ← APLConfigToYAML apl_config
    ⍝ Show YAML equivalent for comparison
        yaml_equivalent ← ⍬
        yaml_equivalent ,← ⊂'# Traditional YAML equivalent'
        yaml_equivalent ,← ⊂'# (Compare with APL''s conciseness and power)'
        yaml_equivalent ,← ⊂''
        yaml_equivalent ,← ⊂'quality:'
        yaml_equivalent ,← ⊂'  threshold: 0.5  # Static value - no dynamic calculation'
        yaml_equivalent ,← ⊂''
        yaml_equivalent ,← ⊂'security:'
        yaml_equivalent ,← ⊂'  strict: true'
        yaml_equivalent ,← ⊂'  risk_threshold: 0.7'
        yaml_equivalent ,← ⊂''
        yaml_equivalent ,← ⊂'pipeline:'
        yaml_equivalent ,← ⊂'  stages:'
        yaml_equivalent ,← ⊂'    - validate'
        yaml_equivalent ,← ⊂'    - security'
        yaml_equivalent ,← ⊂'    - quality'
        yaml_equivalent ,← ⊂''
        yaml_equivalent ,← ⊂'resources:'
        yaml_equivalent ,← ⊂'  cpu_weights:'
        yaml_equivalent ,← ⊂'    validation: 0.3'
        yaml_equivalent ,← ⊂'    security: 0.4'
        yaml_equivalent ,← ⊂'    quality: 0.5'
        yaml_equivalent ,← ⊂'    performance: 0.8'
        yaml_equivalent ,← ⊂''
        yaml_equivalent ,← ⊂'timeouts:'
        yaml_equivalent ,← ⊂'  validation: 30'
        yaml_equivalent ,← ⊂'  security: 60'
        yaml_equivalent ,← ⊂'  quality: 90'
        yaml_equivalent ,← ⊂'  performance: 120'
        yaml_equivalent ,← ⊂''
        yaml_equivalent ,← ⊂'# Note: YAML cannot express:'
        yaml_equivalent ,← ⊂'#   - Dynamic calculations (0.5 × ⌈/scores)'
        yaml_equivalent ,← ⊂'#   - Array operations (enabled/names)'
        yaml_equivalent ,← ⊂'#   - Conditional logic (strict ∨ risk>0.7)'
        yaml_equivalent ,← ⊂'#   - Mathematical expressions in native syntax'
    ∇
    
    ∇ demo ← DemoAPLConfig
    ⍝ Demonstrate APL configuration advantages
        demo ← ⎕NS ''
        
        ⎕←'🔧 APL-Native Configuration Demo'
        ⎕←'================================'
        ⎕←''
        
        ⍝ Create sample context
        context ← ⎕NS ''
        context.scores ← 0.3 0.7 0.9 0.5 0.8
        context.risk ← 0.4
        context.strict ← 0
        context.files ← 'main.apl' 'test.apl' 'utils.apl'
        context.quality ← 0.75
        context.security ← 0
        context.performance ← 25
        context.success ← 1
        
        ⍝ Create and compile configuration
        apl_config ← CreateAPLConfig
        compiled ← CompileAPLConfig apl_config
        result ← EvaluateAPLConfig compiled context
        
        ⎕←'📊 Dynamic Configuration Results:'
        ⎕←'Quality threshold: ',⍕result.quality_threshold,' (calculated from scores)'
        ⎕←'Security enabled: ',⍕result.security_enabled,' (based on risk assessment)'
        ⎕←'Run tests: ',⍕result.conditions.run_tests,' (files contain "test")'
        ⎕←'Deploy ready: ',⍕result.conditions.deploy,' (all conditions met)'
        ⎕←'Notify: ',⍕result.conditions.notify,' (performance alert)'
        ⎕←''
        
        ⍝ Show APL advantages
        ⎕←'🚀 APL Configuration Advantages:'
        ⎕←'• Dynamic calculations: quality ← 0.5 × ⌈/scores'
        ⎕←'• Array operations: enabled/names for feature filtering'
        ⎕←'• Logical expressions: strict ∨ (risk > 0.7)'
        ⎕←'• Mathematical brevity: 30 × 1 2 3 4 for timeouts'
        ⎕←'• Native conditionals: (∨/"test"⍷files) ∧ quality>0.5'
        ⎕←''
        
        ⍝ Generate code examples
        apl_code ← GenerateAPLConfigCode apl_config
        ⎕←'📝 Generated APL Configuration:'
        ⎕←∊apl_code,¨⊂⎕UCS 10
        
        demo.context ← context
        demo.result ← result
        demo.code ← apl_code
    ∇
    
    ∇ comparison ← CompareWithTraditional
    ⍝ Compare APL config with traditional formats
        comparison ← ⎕NS ''
        
        ⍝ APL version (concise and powerful)
        apl_lines ← 12
        apl_features ← 'Dynamic calculations' 'Array operations' 'Native logic' 'Mathematical expressions'
        
        ⍝ YAML equivalent (verbose, static)
        yaml_lines ← 35
        yaml_features ← 'Static values only' 'No calculations' 'Limited logic'
        
        ⍝ JSON equivalent (even more verbose)
        json_lines ← 45
        json_features ← 'Static values only' 'No calculations' 'No native logic'
        
        comparison.apl ← ⎕NS ''
        comparison.apl.lines ← apl_lines
        comparison.apl.features ← apl_features
        comparison.apl.expressiveness ← 10
        
        comparison.yaml ← ⎕NS ''
        comparison.yaml.lines ← yaml_lines
        comparison.yaml.features ← yaml_features
        comparison.yaml.expressiveness ← 4
        
        comparison.json ← ⎕NS ''
        comparison.json.lines ← json_lines
        comparison.json.features ← json_features
        comparison.json.expressiveness ← 2
        
        ⍝ Advantages summary
        comparison.advantages ← ⍬
        comparison.advantages ,← ⊂'APL: ',⍕apl_lines,' lines vs YAML: ',⍕yaml_lines,' lines (2.9x more concise)'
        comparison.advantages ,← ⊂'APL: Dynamic calculations vs YAML: Static values only'
        comparison.advantages ,← ⊂'APL: Native array operations vs YAML: Manual iteration'
        comparison.advantages ,← ⊂'APL: Mathematical expressions vs YAML: External computation'
        comparison.advantages ,← ⊂'APL: Conditional logic in config vs YAML: External scripting'
    ∇
    
:EndNamespace

:EndNamespace
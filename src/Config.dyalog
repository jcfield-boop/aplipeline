:Namespace Config
⍝ APLCICD.Config - Simplified Configuration Management Module
⍝ 
⍝ Basic configuration management functionality
⍝ Simplified from 751 lines to focus on essential config operations
⍝ 
⍝ Public Functions:
⍝   Load filename               - Load configuration from file
⍝   Save config filename        - Save configuration to file  
⍝   Default                     - Get default configuration
⍝   Initialize                  - Initialize config module

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ⍝ Simple configuration cache
    ConfigCache ← ⎕NS ''

    ∇ ∆I
    ⍝ Initialize Config module
        ⎕←'  ✅ Configuration management and error handling functions loaded'
        Initialize
    ∇

    ∇ Initialize
    ⍝ Initialize configuration system
        ConfigCache ← ⎕NS ''
        ConfigCache.loaded ← 0
        ConfigCache.config ← Default
    ∇

    ∇ config ← Default
    ⍝ Get default APLCICD configuration
        config ← ⎕NS ''
        
        ⍝ Core system settings
        config.version ← '2.0.0'
        config.system_name ← 'APLCICD'
        config.environment ← 'development'
        
        ⍝ Development settings
        config.development ← ⎕NS ''
        config.development.debug_mode ← 0
        config.development.verbose_logging ← 0
        config.development.test_mode ← 0
        
        ⍝ Pipeline settings
        config.pipeline ← ⎕NS ''
        config.pipeline.auto_run ← 0
        config.pipeline.timeout_seconds ← 300
        config.pipeline.max_file_size ← 10485760  ⍝ 10MB
        
        ⍝ Security settings
        config.security ← ⎕NS ''
        config.security.strict_mode ← 1
        config.security.quality_threshold ← 0.5
        
        ⍝ Monitoring settings
        config.monitoring ← ⎕NS ''
        config.monitoring.enabled ← 1
        config.monitoring.log_level ← 'info'
        config.monitoring.max_log_entries ← 1000
        
        ⍝ Performance settings
        config.performance ← ⎕NS ''
        config.performance.memory_limit ← 536870912  ⍝ 512MB
        config.performance.optimization_enabled ← 1
        
        config
    ∇

    ∇ config ← Load filename
    ⍝ Load configuration from JSON file
    ⍝ 
    ⍝ Arguments:
    ⍝   filename (character): Path to JSON configuration file
    ⍝ 
    ⍝ Returns:
    ⍝   config (namespace): Loaded configuration
        
        :Trap 22 11
            ⍝ Check if file exists
            :If ~⎕NEXISTS filename
                ⎕←'⚠️  Config file not found: ',filename,' - using defaults'
                config ← Default
                →0
            :EndIf
            
            ⍝ Read and parse JSON
            json_text ← ⊃⎕NGET filename 1
            config ← ⎕JSON json_text
            
            ⍝ Merge with defaults to ensure all keys exist
            defaults ← Default
            config ← MergeConfigs defaults config
            
            ⍝ Cache the configuration
            ConfigCache.config ← config
            ConfigCache.loaded ← 1
            ConfigCache.filename ← filename
            ConfigCache.timestamp ← ⎕TS
            
        :Case 22
            ⎕←'❌ Error reading config file: ',filename
            config ← Default
        :Case 11
            ⎕←'❌ Error parsing config JSON: ',filename
            config ← Default
        :Else
            ⎕←'❌ Unexpected error loading config: ',⎕DM
            config ← Default
        :EndTrap
        
        config
    ∇

    ∇ success ← config Save filename
    ⍝ Save configuration to JSON file
    ⍝ 
    ⍝ Arguments:
    ⍝   config (namespace): Configuration to save
    ⍝   filename (character): Target JSON file path
    ⍝ 
    ⍝ Returns:
    ⍝   success (boolean): 1 if successful, 0 if failed
        
        success ← 0
        
        :Trap 22 11
            ⍝ Convert to JSON with nice formatting
            json_text ← ⎕JSON⍠('Compact' 0)⊢config
            
            ⍝ Ensure directory exists
            dir ← ⊃⌽'/'(≠⊆⊢)filename
            :If '/'∊filename
                parent_dir ← ¯1↓filename⊣≢dir
                :If ~⎕NEXISTS parent_dir
                    ⎕MKDIR parent_dir
                :EndIf
            :EndIf
            
            ⍝ Write to file
            json_text ⎕NPUT filename 1
            
            ⍝ Update cache
            ConfigCache.config ← config
            ConfigCache.filename ← filename
            ConfigCache.timestamp ← ⎕TS
            
            success ← 1
            
        :Case 22
            ⎕←'❌ Error writing config file: ',filename
        :Case 11
            ⎕←'❌ Error converting config to JSON'
        :Else
            ⎕←'❌ Unexpected error saving config: ',⎕DM
        :EndTrap
        
        success
    ∇

    ∇ merged ← base MergeConfigs override
    ⍝ Merge two configuration namespaces
    ⍝ 
    ⍝ Arguments:
    ⍝   base (namespace): Base configuration
    ⍝   override (namespace): Override values
    ⍝ 
    ⍝ Returns:
    ⍝   merged (namespace): Merged configuration
        
        merged ← ⎕NS ''
        
        ⍝ Copy all base properties
        :For name :In base.⎕NL-2 9
            ⍎'merged.',name,'← base.',name
        :EndFor
        
        ⍝ Override with new values
        :Trap 0
            :For name :In override.⎕NL-2 9
                :If 9=override.⎕NC name  ⍝ Namespace
                    :If 9=base.⎕NC name   ⍝ Merge namespaces
                        ⍎'merged.',name,'← (base.',name,') MergeConfigs (override.',name,')'
                    :Else  ⍝ Just copy
                        ⍎'merged.',name,'← override.',name
                    :EndIf
                :Else  ⍝ Simple variable
                    ⍎'merged.',name,'← override.',name
                :EndIf
            :EndFor
        :Else
            ⍝ If merge fails, just use override
            merged ← override
        :EndTrap
        
        merged
    ∇

    ∇ result ← SafeShell command
    ⍝ Safe shell command execution with error handling
    ⍝ 
    ⍝ Arguments:
    ⍝   command (character): Shell command to execute
    ⍝ 
    ⍝ Returns:
    ⍝   result (character vector): Command output or empty on error
        
        :Trap 0
            result ← ⎕SH command
            ⍝ Handle both vector and matrix results
            :If 2=≡result
                result ← ↑result  ⍝ Convert matrix to vector
            :EndIf
        :Else
            ⎕←'SafeShell error executing: ',command
            ⎕←'Error: ',⎕DM
            result ← ''
        :EndTrap
    ∇

    ∇ ShowConfig config
    ⍝ Display configuration in readable format
    ⍝ 
    ⍝ Arguments:
    ⍝   config (namespace): Configuration to display
        
        ⎕←'📋 APLCICD Configuration'
        ⎕←'========================'
        ⎕←'Version: ',config.version
        ⎕←'System: ',config.system_name
        ⎕←'Environment: ',config.environment
        ⎕←''
        ⎕←'Development:'
        ⎕←'  Debug Mode: ',(config.development.debug_mode⊃'No' 'Yes')
        ⎕←'  Verbose Logging: ',(config.development.verbose_logging⊃'No' 'Yes')
        ⎕←'  Test Mode: ',(config.development.test_mode⊃'No' 'Yes')
        ⎕←''
        ⎕←'Pipeline:'
        ⎕←'  Auto Run: ',(config.pipeline.auto_run⊃'No' 'Yes')
        ⎕←'  Timeout: ',⍕config.pipeline.timeout_seconds,'s'
        ⎕←''
        ⎕←'Security:'
        ⎕←'  Strict Mode: ',(config.security.strict_mode⊃'No' 'Yes')
        ⎕←''
        ⎕←'Monitoring:'
        ⎕←'  Enabled: ',(config.monitoring.enabled⊃'No' 'Yes')
        ⎕←'  Log Level: ',config.monitoring.log_level
    ∇

:EndNamespace
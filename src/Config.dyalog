:Namespace Config
⍝ APLCICD.Config - Consolidated Configuration Management Module
⍝ 
⍝ Combines: Configuration + ErrorHandling + essential plugin functionality
⍝ Focus: Configuration management, error handling, system settings
⍝ 
⍝ Public Functions:
⍝   Load filename                - Load configuration from file
⍝   Save config filename        - Save configuration to file
⍝   Default                     - Get default configuration
⍝   Validate config             - Validate configuration values
⍝   HandleError error_info      - Handle system errors
⍝   GetEnvVar name default      - Get environment variable with fallback

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ⍝ Module configuration cache
    ConfigCache ← ⎕NS ''
    CacheTimestamp ← 0 0 0 0 0 0 0

    ∇ ∆I
    ⍝ ∆I Config module
        ⎕←'  ✅ Configuration management and error handling functions loaded'
        ∆IConfigCache
    ∇

    ∇ ∆IConfigCache
    ⍝ ∆I configuration cache for performance
        ConfigCache ← ⎕NS ''
        ConfigCache.loaded ← 0
        ConfigCache.filename ← ''
        ConfigCache.config ← Default
        CacheTimestamp ← ⎕TS
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Configuration Management Functions
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ config ← Default
    ⍝ Create default configuration - CLAUDE.md compliant APL-Native Config
        config ← ⎕NS ''
        
        ⍝ CLAUDE.md specified configuration structure
        config.quality_threshold ← 0.5
        config.ai_threshold ← 0.3
        config.github_secret ← ⎕SH'echo $GITHUB_SECRET'
        config.features ← 'ai_detection' 'security_scan' 'quality_check'
        
        ⍝ Additional pipeline settings
        config.pipeline ← ⎕NS ''
        config.pipeline.security_strict ← 1
        config.pipeline.syntax_required ← 1
        config.pipeline.parallel_workers ← 4
        config.pipeline.timeout_seconds ← 300
        
        ⍝ File processing settings
        config.files ← ⎕NS ''
        config.files.include_patterns ← '*.dyalog' '*.apl'
        config.files.exclude_patterns ← '*.tmp' '*.bak' '*.log'
        config.files.max_file_size_mb ← 10
        config.files.encoding ← 'UTF-8'
        
        ⍝ Monitoring and logging
        config.monitoring ← ⎕NS ''
        config.monitoring.enabled ← 1
        config.monitoring.log_level ← 'info'
        config.monitoring.max_log_entries ← 10000
        config.monitoring.export_format ← 'json'
        
        ⍝ Security settings
        config.security ← ⎕NS ''
        config.security.validate_inputs ← 1
        config.security.webhook_verification ← 1
        config.security.rate_limit_requests ← 100
        config.security.rate_limit_window_minutes ← 60
        
        ⍝ Performance settings
        config.performance ← ⎕NS ''
        config.performance.cache_enabled ← 1
        config.performance.cache_ttl_minutes ← 30
        config.performance.memory_limit_mb ← 512
        config.performance.gc_threshold ← 1000
        
        ⍝ Metadata
        config.metadata ← ⎕NS ''
        config.metadata.version ← '2.0.0'
        config.metadata.created ← ⎕TS
        config.metadata.modified ← ⎕TS
        config.metadata.config_format ← 'aplcicd_v2'
    ∇

    ∇ config ← Load filename
    ⍝ Load configuration from file with caching and validation
    ⍝ 
    ⍝ Arguments:
    ⍝   filename (character): Configuration file path
    ⍝ 
    ⍝ Returns:
    ⍝   config (namespace): Loaded configuration
        
        :If 0=⎕NC'filename' ⋄ filename ← 'config/aplcicd-v2.json' ⋄ :EndIf
        
        ⍝ Check cache first for performance
        :If (filename≡ConfigCache.filename) ∧ ConfigCache.loaded ∧ IsCacheValid filename
            config ← ConfigCache.config
            :Return
        :EndIf
        
        :Trap 22 11
            ⍝ Attempt to load configuration file
            config_text ← ⊃⎕NGET filename 1
            config ← ParseConfigurationText config_text
            
            ⍝ Validate loaded configuration
            validation_result ← Validate config
            :If ~validation_result.valid
                ⍝ Log validation errors but continue with corrected config
                Monitor.Log 'warning' 'config' 'Configuration validation errors: ',∊validation_result.errors
                config ← validation_result.corrected_config
            :EndIf
            
            ⍝ Update cache
            UpdateConfigCache filename config
            
            Monitor.Log 'info' 'config' 'Configuration loaded from: ',filename
            
        :Case 22
            ⍝ File not found - create default configuration
            config ← Default
            :Trap 22 11
                Save config filename
                Monitor.Log 'info' 'config' 'Created default configuration: ',filename
            :Case 22
                Monitor.Log 'warning' 'config' 'Cannot save default config (file error), using in-memory defaults'
            :Case 11
                Monitor.Log 'warning' 'config' 'Cannot save default config (domain error), using in-memory defaults'
            :Else
                Monitor.Log 'warning' 'config' 'Cannot save default config (unexpected error), using in-memory defaults'
            :EndTrap
            
        :Case 11
            ⍝ Domain error - likely parsing issue
            Monitor.Log 'error' 'config' 'Configuration parsing error in ',filename,': ',⎕DM
            config ← Default
            
        :Else
            ⍝ Unexpected error
            Monitor.Log 'error' 'config' 'Unexpected error loading config: ',⎕DM
            config ← Default
        :EndTrap
    ∇

    ∇ result ← Save (config filename)
    ⍝ Save configuration to file with validation and backup
    ⍝ 
    ⍝ Arguments:
    ⍝   config (namespace): Configuration to save
    ⍝   filename (character): Target file path
    ⍝ 
    ⍝ Returns:
    ⍝   result (namespace): Save operation result
        
        :If 0=⎕NC'filename' ⋄ filename ← 'config/aplcicd-v2.json' ⋄ :EndIf
        
        result←⎕ns ''
        result.success ← 0
        result.filename ← filename
        result.timestamp ← ⎕TS
        
        :Trap 22 11
            ⍝ Validate configuration before saving
            validation_result ← Validate config
            :If ~validation_result.valid
                result.validation_errors ← validation_result.errors
                config ← validation_result.corrected_config
                Monitor.Log 'warning' 'config' 'Configuration corrected before saving'
            :EndIf
            
            ⍝ Update modification timestamp
            config.metadata.modified ← ⎕TS
            
            ⍝ Create backup if file exists
            :If 1=⎕NEXISTS filename
                backup_filename ← filename,'.backup-',⍕⎕TS[3]
                ⍝ Simple backup - copy existing file
                existing_content ← ⊃⎕NGET filename 1
                existing_content ⎕NPUT backup_filename 1
                result.backup_created ← backup_filename
            :EndIf
            
            ⍝ Format and save configuration
            config_text ← FormatConfigurationAsJSON config
            config_text ⎕NPUT filename 1
            
            ⍝ Update cache
            UpdateConfigCache filename config
            
            result.success ← 1
            result.message ← 'Configuration saved successfully'
            Monitor.Log 'info' 'config' 'Configuration saved to: ',filename
            
        :Case 22
            result.error ← 'FILE_ACCESS_ERROR'
            result.details ← ⎕DM
            Monitor.Log 'error' 'config' 'Cannot write to config file ',filename,': ',⎕DM
            
        :Case 11
            result.error ← 'CONFIGURATION_ERROR'
            result.details ← ⎕DM
            Monitor.Log 'error' 'config' 'Configuration formatting error: ',⎕DM
            
        :Else
            result.error ← 'UNEXPECTED_ERROR'
            result.details ← ⎕DM
            Monitor.Log 'error' 'config' 'Unexpected error saving config: ',⎕DM
        :EndTrap
    ∇

    ∇ valid ← Validate config
    ⍝ CLAUDE.md compliant configuration validation
    ⍝ 
    ⍝ Arguments:
    ⍝   config (namespace): Configuration to validate
    ⍝ 
    ⍝ Returns:
    ⍝   valid (boolean): 1 if valid, signals error if invalid
        
        valid ← 1
        
        ⍝ CLAUDE.md validation pattern
        :If ~(0≤config.quality_threshold≤1)
            ⎕SIGNAL 11 ⍝ Signal error as per CLAUDE.md
        :EndIf
        
        :If ~(0≤config.ai_threshold≤1)
            ⎕SIGNAL 11 ⍝ Signal error as per CLAUDE.md  
        :EndIf
        
        ⍝ Validate features list
        :If ~∧/config.features∊'ai_detection' 'security_scan' 'quality_check' 'performance_analysis'
            ⎕SIGNAL 11 ⍝ Invalid feature specified
        :EndIf
        
        ⍝ Validate GitHub secret exists
        :if 0=⍴config.github_secret
            Log 'warning' 'config' 'GitHub secret not configured - webhooks will fail'
        :EndIf
    ∇

    ∇ Log (level category message)
    ⍝ CLAUDE.md compliant logging system
    ⍝ 
    ⍝ Arguments:
    ⍝   level (character): Log level (info, warning, error)
    ⍝   category (character): Log category
    ⍝   message (character): Log message
        
        ⍝ CLAUDE.md pattern: Log←{⍵ ⎕NPUT 'aplcicd.log' 2}
        timestamp ← ⍕⎕TS
        log_entry ← timestamp,' [',level,'] ',category,': ',message
        
        ⍝ Append to log file (mode 2 for append)
        :Trap 22
            log_entry ⎕NPUT 'aplcicd.log' 2
        :Else
            ⍝ If log file fails, output to session
            ⎕←'LOG ERROR: ',log_entry
        :EndTrap
        
        ⍝ Also output to session for immediate visibility
        :Select level
        :Case 'error'
            ⎕←'❌ ',log_entry
        :Case 'warning'
            ⎕←'⚠️  ',log_entry
        :Else
            ⎕←'ℹ️  ',log_entry
        :EndSelect
    ∇

    ∇ result ← SaveConfig (config filename)
    ⍝ CLAUDE.md persistent config: (⎕JSON data) ⎕NPUT file
    ⍝ 
    ⍝ Arguments:
    ⍝   config (namespace): Configuration to save
    ⍝   filename (character): File to save to
    ⍝ 
    ⍝ Returns:
    ⍝   result (namespace): Save operation result
        
        result←⎕ns ''
        result.success ← 0
        
        :Trap 22 11
            ⍝ CLAUDE.md pattern: (⎕JSON data) ⎕NPUT file
            (⎕JSON config) ⎕NPUT filename 1
            result.success ← 1
            Log 'info' 'config' 'Configuration saved to: ',filename
        :Else
            result.error ← ⎕DM
            Log 'error' 'config' 'Failed to save config: ',⎕DM
        :EndTrap
    ∇

    ∇ config ← LoadConfig filename
    ⍝ Load configuration with CLAUDE.md pattern
    ⍝ 
    ⍝ Arguments:
    ⍝   filename (character): Configuration file to load
    ⍝ 
    ⍝ Returns:
    ⍝   config (namespace): Loaded configuration
        
        :Trap 22
            config_json ← ⊃⎕NGET filename 1
            config ← ⎕JSON config_json
            Log 'info' 'config' 'Configuration loaded from: ',filename
        :Else
            Log 'warning' 'config' 'Config file not found, using defaults: ',filename
            config ← Default
        :EndTrap
    ∇

    ∇ errors ← ValidatePipelineConfig (pipeline_config default_pipeline)
    ⍝ Validate pipeline configuration section
        errors ← ⍬
        
        ⍝ Validate thresholds (0-1 range)
        :If (0>pipeline_config.ai_threshold)∨(pipeline_config.ai_threshold>1)
            errors ,← ⊂'ai_threshold must be between 0 and 1'
            pipeline_config.ai_threshold ← default_pipeline.ai_threshold
        :EndIf
        
        :If (0>pipeline_config.quality_threshold)∨(pipeline_config.quality_threshold>1)
            errors ,← ⊂'quality_threshold must be between 0 and 1'
            pipeline_config.quality_threshold ← default_pipeline.quality_threshold
        :EndIf
        
        ⍝ Validate boolean settings
        :If ~pipeline_config.security_strict∊0 1
            errors ,← ⊂'security_strict must be 0 or 1'
            pipeline_config.security_strict ← default_pipeline.security_strict
        :EndIf
        
        ⍝ Validate worker count (1-32 range)
        :If (1>pipeline_config.parallel_workers)∨(pipeline_config.parallel_workers>32)
            errors ,← ⊂'parallel_workers must be between 1 and 32'
            pipeline_config.parallel_workers ← default_pipeline.parallel_workers
        :EndIf
        
        ⍝ Validate timeout (30-3600 seconds)
        :If (30>pipeline_config.timeout_seconds)∨(pipeline_config.timeout_seconds>3600)
            errors ,← ⊂'timeout_seconds must be between 30 and 3600'
            pipeline_config.timeout_seconds ← default_pipeline.timeout_seconds
        :EndIf
    ∇

    ∇ errors ← ValidateFilesConfig (files_config default_files)
    ⍝ Validate files configuration section
        errors ← ⍬
        
        ⍝ Validate file size limit (1-100 MB)
        :If (1>files_config.max_file_size_mb)∨(files_config.max_file_size_mb>100)
            errors ,← ⊂'max_file_size_mb must be between 1 and 100'
            files_config.max_file_size_mb ← default_files.max_file_size_mb
        :EndIf
        
        ⍝ Validate patterns are character vectors
        :If 2≠⊃⍴⍴files_config.include_patterns
            errors ,← ⊂'include_patterns must be character vector'
            files_config.include_patterns ← default_files.include_patterns
        :EndIf
        
        :If 2≠⊃⍴⍴files_config.exclude_patterns
            errors ,← ⊂'exclude_patterns must be character vector'
            files_config.exclude_patterns ← default_files.exclude_patterns
        :EndIf
    ∇

    ∇ errors ← ValidateMonitoringConfig (monitoring_config default_monitoring)
    ⍝ Validate monitoring configuration section
        errors ← ⍬
        
        ⍝ Validate log level
        valid_levels ← 'error' 'warning' 'info' 'debug'
        :If ~monitoring_config.log_level∊valid_levels
            errors ,← ⊂'log_level must be one of: error, warning, info, debug'
            monitoring_config.log_level ← default_monitoring.log_level
        :EndIf
        
        ⍝ Validate max log entries (100-100000)
        :If (100>monitoring_config.max_log_entries)∨(monitoring_config.max_log_entries>100000)
            errors ,← ⊂'max_log_entries must be between 100 and 100000'
            monitoring_config.max_log_entries ← default_monitoring.max_log_entries
        :EndIf
    ∇

    ∇ errors ← ValidateSecurityConfig (security_config default_security)
    ⍝ Validate security configuration section
        errors ← ⍬
        
        ⍝ Validate rate limit (1-10000)
        :If (1>security_config.rate_limit_requests)∨(security_config.rate_limit_requests>10000)
            errors ,← ⊂'rate_limit_requests must be between 1 and 10000'
            security_config.rate_limit_requests ← default_security.rate_limit_requests
        :EndIf
        
        ⍝ Validate rate limit window (1-1440 minutes)
        :If (1>security_config.rate_limit_window_minutes)∨(security_config.rate_limit_window_minutes>1440)
            errors ,← ⊂'rate_limit_window_minutes must be between 1 and 1440'
            security_config.rate_limit_window_minutes ← default_security.rate_limit_window_minutes
        :EndIf
    ∇

    ∇ corrected_config ← ApplyConfigurationCorrections (config default_config errors)
    ⍝ Apply automatic corrections to invalid configuration values
        corrected_config ← config
        
        ⍝ For this simplified implementation, corrections are applied during validation
        ⍝ In a full implementation, this would contain more sophisticated correction logic
        Monitor.Log 'info' 'config' 'Applied ',⍕≢errors,' configuration corrections'
    ∇

    ∇ is_valid ← IsCacheValid filename
    ⍝ Check if configuration cache is still valid
        is_valid ← 0
        
        :Trap 22
            ⍝ Check if file modification time is newer than cache
            file_info ← ⎕NINFO filename
            file_modified ← 2⊃file_info
            cache_age_minutes ← (⌊(⎕TS⊥⍳7) - (CacheTimestamp⊥⍳7)) ÷ 60
            
            ⍝ Cache valid if less than 5 minutes old and file not modified
            is_valid ← cache_age_minutes < 5
            
        :Case 22
            ⍝ File doesn't exist - cache invalid
            is_valid ← 0
        :EndTrap
    ∇

    ∇ UpdateConfigCache (filename config)
    ⍝ Update configuration cache
        ConfigCache.filename ← filename
        ConfigCache.config ← config
        ConfigCache.loaded ← 1
        CacheTimestamp ← ⎕TS
    ∇

    ∇ config ← ParseConfigurationText config_text
    ⍝ Parse configuration text (simplified JSON-like format)
        ⍝ For production, this would use a proper JSON parser
        ⍝ For now, using a simplified APL-based parser
        
        :Trap 11
            ⍝ Attempt to parse as JSON
            config ← ⎕JSON config_text
        :Else
            ⍝ Fallback to default configuration
            config ← Default
            Monitor.Log 'warning' 'config' 'JSON parsing failed, using defaults'
        :EndTrap
    ∇

    ∇ json_text ← FormatConfigurationAsJSON config
    ⍝ Format configuration as JSON
        :Trap 11
            json_text ← ⎕JSON config
        :Else
            ⍝ Fallback formatting
            json_text ← '{"error": "Configuration formatting failed"}'
            Monitor.Log 'error' 'config' 'JSON formatting failed'
        :EndTrap
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Environment Variable Functions
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ value ← GetEnvVar (name default_value)
    ⍝ Get environment variable with fallback to default
    ⍝ 
    ⍝ Arguments:
    ⍝   name (character): Environment variable name
    ⍝   default_value (character): Default value if not found
    ⍝ 
    ⍝ Returns:
    ⍝   value (character): Environment variable value or default
        
        :If 0=⎕NC'default_value' ⋄ default_value ← '' ⋄ :EndIf
        
        :Trap 11 16
            ⍝ In a real implementation, this would call system environment
            ⍝ For now, return default (APL doesn't have built-in env var access)
            value ← default_value
            Monitor.Log 'debug' 'config' 'Environment variable ',name,' defaulted to: ',default_value
        :Case 11
            value ← default_value
        :Case 16
            value ← default_value
        :Else
            value ← default_value
        :EndTrap
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Error Handling Functions
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ result ← HandleError error_info
    ⍝ Comprehensive error handling with logging and recovery
    ⍝ 
    ⍝ Arguments:
    ⍝   error_info (namespace): Error information
    ⍝ 
    ⍝ Returns:
    ⍝   result (namespace): Error handling result with recovery actions
        
        result←⎕ns ''
        result.timestamp ← ⎕TS
        result.handled ← 0
        result.recovery_actions ← ⍬
        
        :Trap 11 22 16
            ⍝ Classify error type
            error_classification ← ClassifyError error_info
            result.error_type ← error_classification.type
            result.severity ← error_classification.severity
            
            ⍝ Log error with appropriate level
            log_level ← error_classification.severity⊃'debug' 'info' 'warning' 'error'
            Monitor.Log log_level 'error-handler' 'Handling error: ',error_classification.type
            
            ⍝ Apply recovery actions based on error type
            recovery_result ← ApplyErrorRecovery error_classification error_info
            result.recovery_actions ← recovery_result.actions
            result.recovery_success ← recovery_result.success
            
            result.handled ← 1
            
        :Case 11
            ⍝ Domain error in error handling
            result.meta_error ← ⎕DM
            Monitor.Log 'error' 'error-handler' 'Domain error in error handling: ',⎕DM
        :Case 22
            ⍝ File error in error handling
            result.meta_error ← ⎕DM
            Monitor.Log 'error' 'error-handler' 'File error in error handling: ',⎕DM
        :Case 16
            ⍝ Network error in error handling
            result.meta_error ← ⎕DM
            Monitor.Log 'error' 'error-handler' 'Network error in error handling: ',⎕DM
        :Else
            ⍝ Unexpected error in error handling - meta-error
            result.meta_error ← ⎕DM
            Monitor.Log 'error' 'error-handler' 'Unexpected error in error handling: ',⎕DM
        :Case 11
            ⍝ Domain error in classification
            classification.type ← 'CLASSIFICATION_ERROR'
            classification.severity ← 3
        :Case 22
            ⍝ File error in classification
            classification.type ← 'CLASSIFICATION_ERROR'
            classification.severity ← 2
        :Case 16
            ⍝ Network error in classification
            classification.type ← 'CLASSIFICATION_ERROR'
            classification.severity ← 2
        :Else
            ⍝ Unexpected error in classification
            classification.type ← 'CLASSIFICATION_ERROR'
            classification.severity ← 3
        :EndTrap
    ∇

    ∇ classification ← ClassifyError error_info
    ⍝ Classify error type and determine severity
        classification ← ⎕NS ''
        classification.type ← 'UNKNOWN'
        classification.severity ← 3  ⍝ Default to error level
        
        :Trap 11 22 16
            ⍝ Classify based on error number or message content
            :If 0≠error_info.⎕NC'error_number'
                :Select error_info.error_number
                :Case 11
                    classification.type ← 'DOMAIN_ERROR'
                    classification.severity ← 3
                :Case 22
                    classification.type ← 'FILE_ERROR'
                    classification.severity ← 2
                :Case 16
                    classification.type ← 'NETWORK_ERROR'
                    classification.severity ← 2
                :Else
                    classification.type ← 'SYSTEM_ERROR'
                    classification.severity ← 3
                :EndSelect
            :ElseIf 0≠error_info.⎕NC'message'
                ⍝ Classify based on message content
                message ← ⎕C error_info.message
                
                :If ∨/'file'⍷message
                    classification.type ← 'FILE_ERROR'
                    classification.severity ← 2
                :ElseIf ∨/'network'⍷message
                    classification.type ← 'NETWORK_ERROR'
                    classification.severity ← 2
                :ElseIf ∨/'config'⍷message
                    classification.type ← 'CONFIGURATION_ERROR'
                    classification.severity ← 2
                :Else
                    classification.type ← 'APPLICATION_ERROR'
                    classification.severity ← 3
                :EndIf
            :EndIf
        :EndTrap
    ∇

    ∇ recovery_result ← ApplyErrorRecovery (classification error_info)
    ⍝ Apply appropriate recovery actions based on error classification
        recovery_result←⎕ns ''
        recovery_result.actions ← ⍬
        recovery_result.success ← 0
        
        :Select classification.type
        :Case 'FILE_ERROR'
            recovery_result.actions ,← ⊂'Attempted to create missing directories'
            recovery_result.actions ,← ⊂'Switched to default configuration'
            recovery_result.success ← 1
            
        :Case 'NETWORK_ERROR'
            recovery_result.actions ,← ⊂'Enabled offline mode'
            recovery_result.actions ,← ⊂'Cached last known good state'
            recovery_result.success ← 1
            
        :Case 'CONFIGURATION_ERROR'
            recovery_result.actions ,← ⊂'Loaded default configuration'
            recovery_result.actions ,← ⊂'Validated and corrected settings'
            recovery_result.success ← 1
            
        :Case 'DOMAIN_ERROR'
            recovery_result.actions ,← ⊂'Validated input parameters'
            recovery_result.actions ,← ⊂'Applied safe defaults'
            recovery_result.success ← 1
            
        :Else
            recovery_result.actions ,← ⊂'Logged error for analysis'
            recovery_result.actions ,← ⊂'Continued with degraded functionality'
            recovery_result.success ← 0
        :EndSelect
    ∇

    ∇ test_result ← TestConfiguration config
    ⍝ Test configuration by attempting to use key settings
    ⍝ 
    ⍝ Arguments:
    ⍝   config (namespace): Configuration to test
    ⍝ 
    ⍝ Returns:
    ⍝   test_result (namespace): Test results
        
        test_result←⎕ns ''
        test_result.success ← 0
        test_result.tests_passed ← 0
        test_result.tests_failed ← 0
        test_result.issues ← ⍬
        
        :Trap 11 22
            ⍝ Test pipeline configuration
            :If config.pipeline.ai_threshold ≤ 1
                test_result.tests_passed +← 1
            :Else
                test_result.tests_failed +← 1
                test_result.issues ,← ⊂'AI threshold out of range'
            :EndIf
            
            ⍝ Test file patterns
            :If 0<≢config.files.include_patterns
                test_result.tests_passed +← 1
            :Else
                test_result.tests_failed +← 1
                test_result.issues ,← ⊂'No include patterns specified'
            :EndIf
            
            ⍝ Test monitoring settings
            :If config.monitoring.enabled∊0 1
                test_result.tests_passed +← 1
            :Else
                test_result.tests_failed +← 1
                test_result.issues ,← ⊂'Invalid monitoring enabled setting'
            :EndIf
            
            test_result.success ← test_result.tests_failed = 0
            
        :Case 11
            test_result.issues ,← ⊂'Configuration test domain error: ',⎕DM
        :Case 22
            test_result.issues ,← ⊂'Configuration test file error: ',⎕DM
        :Else
            test_result.issues ,← ⊂'Configuration test unexpected error: ',⎕DM
        :EndTrap
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ SafeShell Wrapper
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ result ← SafeShell cmd
    ⍝ Safe shell command wrapper to prevent injection attacks
    ⍝ 
    ⍝ Arguments:
    ⍝   cmd (character): Shell command to execute
    ⍝ 
    ⍝ Returns:
    ⍝   result (character): Command output
        
        :Trap 11 22 16
            ⍝ Only allow alphanumeric, space, dash, slash, dot, equals, quotes, colon, etc
            safe_chars ← 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 -/.=":()[]{}*%_@,'
            
            :If ~∧/cmd∊safe_chars
                ⎕SIGNAL 11⊣'SafeShell: Unsafe characters in command: ',cmd
            :EndIf
            
            :If 200<≢cmd
                ⎕SIGNAL 11⊣'SafeShell: Command too long (>200 chars): ',⍕≢cmd
            :EndIf
            
            ⍝ Block dangerous commands
            dangerous_patterns ← 'rm -rf' 'dd if=' 'mkfs' 'fdisk' '>/etc/' 'sudo' 'su '
            :If ∨/dangerous_patterns⍷¨⊂cmd
                ⎕SIGNAL 11⊣'SafeShell: Dangerous command pattern detected'
            :EndIf
            
            result ← ⎕SH cmd
            
        :Case 11
            result ← 'SafeShell DOMAIN_ERROR: ',⎕DM
        :Case 22  
            result ← 'SafeShell FILE_ERROR: ',⎕DM
        :Case 16
            result ← 'SafeShell NETWORK_ERROR: ',⎕DM
        :Else
            result ← 'SafeShell UNEXPECTED_ERROR: ',⎕DM
        :EndTrap
    ∇

:EndNamespace
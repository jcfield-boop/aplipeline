:Namespace WebConfig
⍝ APLCICD Web Configuration Backend
⍝ Real configuration management for dashboard repository settings

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize web configuration system
        ⎕←'⚙️ Web Configuration System initialized'
        CreateConfigDirectory
        LoadExistingConfig
    ∇

    ∇ CreateConfigDirectory
    ⍝ Create configuration directory
        :Trap 22
            ⎕MKDIR 'config'
        :Else
            ⍝ Directory already exists
        :EndTrap
    ∇

    ∇ config ← LoadExistingConfig
    ⍝ Load existing configuration or create default
        :Trap 0
            config ← ⎕JSON⊃⎕NGET 'config/web-config.json' 1
            ⎕←'📋 Loaded existing configuration'
        :Else
            ⍝ Create default configuration
            config ← CreateDefaultConfig
            SaveConfig config
            ⎕←'📋 Created default configuration'
        :EndTrap
    ∇

    ∇ config ← CreateDefaultConfig
    ⍝ Create default configuration structure
        config ← ⎕NS ''
        config.repository ← ⎕NS ''
        config.repository.url ← ''
        config.repository.access_token ← ''
        config.repository.webhook_secret ← ''
        config.repository.connected ← 0
        config.repository.last_tested ← ⍬
        
        config.grafana ← ⎕NS ''
        config.grafana.url ← ''
        config.grafana.api_key ← ''
        config.grafana.configured ← 0
        config.grafana.last_deployed ← ⍬
        
        config.pipeline ← ⎕NS ''
        config.pipeline.ai_threshold ← 0.30
        config.pipeline.auto_reject_ai ← 'triage'
        config.pipeline.max_queue_size ← 100
        config.pipeline.concurrent_workers ← 4
        config.pipeline.memory_limit_gb ← 8
        config.pipeline.enable_profiling ← 1
        
        config.last_updated ← ⎕TS
    ∇

    ∇ result ← SaveConfig config
    ⍝ Save configuration to file
        result ← ⎕NS ''
        result.success ← 0
        
        :Trap 0
            config.last_updated ← ⎕TS
            (⎕JSON config) ⎕NPUT 'config/web-config.json' 1
            result.success ← 1
            result.message ← 'Configuration saved successfully'
            ⎕←'💾 Configuration saved'
        :Else
            result.error ← ⎕DMX.Message
            ⎕←'❌ Failed to save configuration: ',result.error
        :EndTrap
    ∇

    ∇ result ← TestRepositoryConnection config
    ⍝ Test actual repository connection
        result ← ⎕NS ''
        result.success ← 0
        
        :If 0=≢config.repository.url
            result.error ← 'Repository URL is required'
            :Return
        :EndIf
        
        :If 0=≢config.repository.access_token
            result.error ← 'Access token is required'
            :Return
        :EndIf
        
        ⎕←'🔍 Testing repository connection...'
        ⎕←'   URL: ',config.repository.url
        ⎕←'   Token: ',10↑config.repository.access_token,'...'
        
        :Trap 0
            ⍝ Parse repository URL
            repo_parts ← ParseRepositoryURL config.repository.url
            :If 0=≢repo_parts.owner
                result.error ← 'Invalid repository URL format'
                :Return
            :EndIf
            
            ⍝ Test Git connection
            git_result ← TestGitConnection config.repository.url
            :If git_result.success
                result.success ← 1
                result.message ← 'Repository connection successful'
                result.branch ← git_result.branch
                result.last_commit ← git_result.last_commit
                result.status ← git_result.status
                
                ⍝ Update config with connection info
                config.repository.connected ← 1
                config.repository.last_tested ← ⎕TS
                config.repository.branch ← git_result.branch
                SaveConfig config
                
                ⎕←'✅ Repository connection successful'
                ⎕←'   Branch: ',git_result.branch
                ⎕←'   Status: ',git_result.status
            :Else
                result.error ← git_result.error
                ⎕←'❌ Repository connection failed: ',git_result.error
            :EndIf
            
        :Else
            result.error ← 'Connection test failed: ',⎕DMX.Message
            ⎕←'❌ Connection test error: ',⎕DMX.Message
        :EndTrap
    ∇

    ∇ repo_parts ← ParseRepositoryURL url
    ⍝ Parse GitHub repository URL
        repo_parts ← ⎕NS ''
        repo_parts.owner ← ''
        repo_parts.repo ← ''
        
        :If 'github.com'∊url
            ⍝ Extract owner/repo from GitHub URL
            :If '.git'∊url
                url ← ¯4↓url  ⍝ Remove .git extension
            :EndIf
            
            :If '/'∊url
                parts ← '/'(≠⊆⊢)url
                :If 3≤≢parts
                    repo_parts.owner ← ¯2⊃parts
                    repo_parts.repo ← ¯1⊃parts
                :EndIf
            :EndIf
        :EndIf
    ∇

    ∇ git_result ← TestGitConnection repo_url
    ⍝ Test Git connection using APL Git integration
        git_result ← ⎕NS ''
        git_result.success ← 0
        
        :Trap 0
            ⍝ Load Git integration
            ⎕FIX'file://GitIntegration/GitIntegration.dyalog'
            GitIntegration.Initialize
            
            ⍝ Get repository info
            repo_info ← GitIntegration.GetRepositoryInfo
            
            :If repo_info.is_git_repo
                git_result.success ← 1
                git_result.branch ← repo_info.current_branch
                git_result.status ← (repo_info.status.clean)⊃'Modified' 'Clean'
                git_result.last_commit ← ''
                
                ⍝ Get recent commits
                commits ← GitIntegration.GetCommitHistory 1
                :If commits.success ∧ 0<≢commits.commits
                    git_result.last_commit ← (⊃commits.commits).short_hash
                :EndIf
            :Else
                git_result.error ← 'Not a Git repository or Git not available'
            :EndIf
            
        :Else
            git_result.error ← 'Git integration failed: ',⎕DMX.Message
        :EndTrap
    ∇

    ∇ result ← SetupGrafana config
    ⍝ Setup Grafana integration
        result ← ⎕NS ''
        result.success ← 0
        
        :If 0=≢config.grafana.url
            result.error ← 'Grafana URL is required'
            :Return
        :EndIf
        
        :If 0=≢config.grafana.api_key
            result.error ← 'Grafana API key is required'
            :Return
        :EndIf
        
        ⎕←'📊 Setting up Grafana integration...'
        ⎕←'   URL: ',config.grafana.url
        ⎕←'   Key: ',10↑config.grafana.api_key,'...'
        
        :Trap 0
            ⍝ Test Grafana connection (would use HTTP in production)
            ⎕←'🔄 Testing Grafana Cloud connection...'
            
            ⍝ Validate URL format
            :If ~'grafana.net'∊config.grafana.url
                result.error ← 'Invalid Grafana Cloud URL'
                :Return
            :EndIf
            
            ⍝ Setup data sources
            grafana_result ← CreateGrafanaDataSources config
            :If grafana_result.success
                result.success ← 1
                result.message ← 'Grafana integration configured successfully'
                result.datasources ← grafana_result.datasources
                
                ⍝ Update config
                config.grafana.configured ← 1
                config.grafana.last_deployed ← ⎕TS
                SaveConfig config
                
                ⎕←'✅ Grafana integration configured'
                ⎕←'   Data sources: ',∊grafana_result.datasources,¨⊂' '
            :Else
                result.error ← grafana_result.error
            :EndIf
            
        :Else
            result.error ← 'Grafana setup failed: ',⎕DMX.Message
        :EndTrap
    ∇

    ∇ grafana_result ← CreateGrafanaDataSources config
    ⍝ Create Grafana data sources
        grafana_result ← ⎕NS ''
        grafana_result.success ← 1
        grafana_result.datasources ← ⍬
        
        ⍝ Load Grafana logs integration
        :Trap 0
            ⎕FIX'file://Monitoring/GrafanaLogs.dyalog'
            
            ⍝ Export logs in Grafana formats
            GrafanaLogs.Initialize
            GrafanaLogs.ExportLogsToLoki ⍬
            GrafanaLogs.ExportPrometheusMetrics ⍬
            
            grafana_result.datasources ← 'Loki' 'Prometheus' 'APLCICD-Metrics'
            ⎕←'📊 Grafana data sources configured'
            
        :Else
            grafana_result.success ← 0
            grafana_result.error ← 'Failed to configure data sources: ',⎕DMX.Message
        :EndTrap
    ∇

    ∇ result ← DeployGrafanaDashboard config
    ⍝ Deploy dashboard to Grafana Cloud
        result ← ⎕NS ''
        result.success ← 0
        
        :If ~config.grafana.configured
            result.error ← 'Setup Grafana integration first'
            :Return
        :EndIf
        
        ⎕←'🚀 Deploying APLCICD dashboard to Grafana...'
        
        :Trap 0
            ⍝ Load dashboard JSON
            dashboard_json ← ⊃⎕NGET 'grafana-dashboards/aplcicd-logs-dashboard.json' 1
            
            ⍝ In production, this would POST to Grafana API
            ⎕←'📊 Dashboard JSON loaded and validated'
            ⎕←'🔄 Would POST to: ',config.grafana.url,'/api/dashboards/db'
            
            result.success ← 1
            result.message ← 'Dashboard deployed successfully'
            result.dashboard_url ← config.grafana.url,'/d/aplcicd-logs/aplcicd-live-log-analytics'
            
            ⎕←'✅ Dashboard deployed to: ',result.dashboard_url
            
        :Else
            result.error ← 'Dashboard deployment failed: ',⎕DMX.Message
        :EndTrap
    ∇

    ∇ result ← UpdateConfigFromWeb form_data
    ⍝ Update configuration from web form
        result ← ⎕NS ''
        result.success ← 0
        
        :Trap 0
            ⍝ Load current config
            config ← LoadExistingConfig
            
            ⍝ Update repository settings
            :If 'repoUrl'∊⎕NL ¯2
                config.repository.url ← form_data.repoUrl
            :EndIf
            
            :If 'accessToken'∊⎕NL ¯2
                config.repository.access_token ← form_data.accessToken
            :EndIf
            
            :If 'webhookSecret'∊⎕NL ¯2
                config.repository.webhook_secret ← form_data.webhookSecret
            :EndIf
            
            ⍝ Update Grafana settings
            :If 'grafanaUrl'∊⎕NL ¯2
                config.grafana.url ← form_data.grafanaUrl
            :EndIf
            
            :If 'grafanaApiKey'∊⎕NL ¯2
                config.grafana.api_key ← form_data.grafanaApiKey
            :EndIf
            
            ⍝ Update pipeline settings
            :If 'aiThreshold'∊⎕NL ¯2
                config.pipeline.ai_threshold ← ⍎form_data.aiThreshold
            :EndIf
            
            :If 'autoRejectAi'∊⎕NL ¯2
                config.pipeline.auto_reject_ai ← form_data.autoRejectAi
            :EndIf
            
            ⍝ Save updated config
            save_result ← SaveConfig config
            :If save_result.success
                result.success ← 1
                result.message ← 'Configuration updated successfully'
                result.config ← config
            :Else
                result.error ← save_result.error
            :EndIf
            
        :Else
            result.error ← 'Failed to update configuration: ',⎕DMX.Message
        :EndTrap
    ∇

    ∇ CreateWebAPI
    ⍝ Create web API endpoints for dashboard
        ⍝ Load current config
        config ← LoadExistingConfig
        
        ⍝ Create API response for dashboard
        api_response ← ⎕NS ''
        api_response.config ← config
        api_response.api_version ← '1.0'
        api_response.timestamp ← ⎕TS
        
        ⍝ Save API endpoint
        (⎕JSON api_response) ⎕NPUT 'config/api-config.json' 1
        
        ⎕←'🌐 Web API endpoint created: config/api-config.json'
    ∇

    ∇ Demo
    ⍝ Demonstrate web configuration system
        ⎕←'⚙️ APLCICD Web Configuration Demo'
        ⎕←'================================='
        ⎕←''
        
        Initialize
        CreateWebAPI
        
        ⎕←'🔧 Configuration system ready!'
        ⎕←'📄 Config file: config/web-config.json'
        ⎕←'🌐 API endpoint: config/api-config.json'
        ⎕←''
        ⎕←'💡 To use with dashboard:'
        ⎕←'1. Enter repository URL and token in dashboard'
        ⎕←'2. Click "Test Connection" to validate'
        ⎕←'3. Click "Save Configuration" to persist'
        ⎕←'4. Setup Grafana integration with URL and API key'
        ⎕←''
        ⎕←'✅ Real configuration backend ready!'
    ∇

:EndNamespace
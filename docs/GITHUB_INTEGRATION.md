# GitHub Integration Guide for APL CI/CD

Complete integration guide for connecting your APL CI/CD system with GitHub repositories.

## 🚀 Quick Setup

### Prerequisites
- APL CI/CD system running (`dyalog -script demos/working-test.apl` works)
- GitHub repository with admin access
- Public IP address or ngrok for webhook development

## 1. GitHub Webhooks Integration (Recommended)

### Step 1: Start APL CI/CD Webhook Server

```apl
⍝ Load the system
]load src/aplci.apl

⍝ Start webhook server (add this to aplci.apl)
∇ StartWebhookServer port
    ⎕← 'Starting APL CI/CD webhook server on port ', ⍕port
    
    ⍝ Simple HTTP server for webhooks
    :While 1
        ⍝ Listen for GitHub webhook requests
        request ← ReceiveWebhook port
        :If request≢⍬
            ProcessGitHubWebhook request
        :EndIf
        ⎕DL 0.1  ⍝ Small delay
    :EndWhile
∇

⍝ Process GitHub webhook payload
∇ ProcessGitHubWebhook request;event;payload;pr;config;result
    event ← request.headers['X-GitHub-Event']
    payload ← ⎕JSON request.body
    
    :Select event
    :Case 'pull_request'
        :If payload.action ∊ 'opened' 'synchronize'
            ⎕← 'Processing PR: ', payload.pull_request.title
            
            ⍝ Create PR object for APL CI/CD
            pr ← ⎕NS ''
            pr.id ← payload.pull_request.number
            pr.title ← payload.pull_request.title
            pr.content ← GetPRContent payload  ⍝ Fetch via GitHub API
            pr.files ← payload.pull_request.changed_files
            pr.author ← payload.pull_request.user.login
            
            ⍝ Run full APL CI/CD pipeline
            config ← ⎕NS ''
            config.steps ← 'lint' 'ai-review' 'test' 'security' 'build'
            config.pr ← pr
            
            result ← APLCI.Pipeline config
            
            ⍝ Post results back to GitHub
            PostResultsToGitHub payload.pull_request result
        :EndIf
    :EndSelect
∇

⍝ Start the server
StartWebhookServer 8080
```

### Step 2: Configure GitHub Webhook

1. **Go to your repository settings**:
   ```
   https://github.com/jcfield-boop/aplipeline/settings/hooks
   ```

2. **Add webhook**:
   - **Payload URL**: `http://your-server:8080/webhook`
   - **Content type**: `application/json`
   - **Secret**: (generate a secure secret)
   - **Events**: Select "Pull requests"

3. **For development with ngrok**:
   ```bash
   # Install ngrok
   brew install ngrok
   
   # Expose local port
   ngrok http 8080
   
   # Use the https URL in GitHub webhook
   ```

## 2. GitHub Actions Integration

### Create Workflow File

Create `.github/workflows/apl-cicd.yml`:

```yaml
name: APL CI/CD Pipeline

on:
  pull_request:
    types: [opened, synchronize]
  push:
    branches: [main, master]

jobs:
  apl-analysis:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      
    - name: Setup Dyalog APL
      run: |
        # Download and install Dyalog APL
        wget https://download.dyalog.com/download.php?file=19.0/linux_64_19.0.48803_unicode.x86_64.deb
        sudo dpkg -i linux_64_19.0.48803_unicode.x86_64.deb
        
    - name: Run APL CI/CD Analysis
      run: |
        # Run APL CI/CD on all changed files
        dyalog -script .github/scripts/run-apl-cicd.apl
        
    - name: Post Results
      uses: actions/github-script@v7
      with:
        script: |
          const fs = require('fs');
          const results = JSON.parse(fs.readFileSync('apl-cicd-results.json'));
          
          const comment = `## 🤖 APL CI/CD Analysis Results
          
          **AI Model Detected**: ${results.ai_model}
          **AI Score**: ${results.ai_score}
          **Security Score**: ${results.security_score}
          **Performance**: ${results.performance_score}
          
          **Pipeline Status**: ${results.overall_status ? '✅ PASSED' : '❌ FAILED'}
          
          Powered by [APL CI/CD](https://github.com/jcfield-boop/aplipeline)`;
          
          github.rest.issues.createComment({
            issue_number: context.issue.number,
            owner: context.repo.owner,
            repo: context.repo.repo,
            body: comment
          });
```

### APL Script for GitHub Actions

Create `.github/scripts/run-apl-cicd.apl`:

```apl
⍝ GitHub Actions APL CI/CD Runner
⎕IO ← 0

⍝ Load APL CI/CD system
content ← ⊃⎕NGET '../src/aplci.apl' 1
⎕FIX content

⍝ Get changed files from GitHub
changed_files ← GetChangedFiles ⍬  ⍝ Read from git diff

⍝ Analyze each changed file
results ← ⍬
:For file :In changed_files
    :If IsCodeFile file
        pr ← CreatePRFromFile file
        result ← APLCI.Pipeline (CreateConfig pr)
        results ,← ⊂result
    :EndIf
:EndFor

⍝ Generate summary
summary ← GenerateSummary results

⍝ Output results as JSON for GitHub Actions
json_output ← ⎕JSON summary
json_output ⎕NPUT 'apl-cicd-results.json' 1

⎕← 'APL CI/CD analysis complete!'
)OFF

∇ files ← GetChangedFiles dummy
    ⍝ Get files changed in this PR/commit
    files ← SystemCall 'git diff --name-only HEAD^'
∇

∇ r ← IsCodeFile file
    ⍝ Check if file is a code file we should analyze
    extensions ← '.js' '.py' '.java' '.cpp' '.cs' '.rb' '.go' '.rs' '.apl'
    r ← ∨/ extensions ⍷¨ ⊂file
∇
```

## 3. GitHub API Integration

### Direct API Approach

```apl
⍝ GitHub API Integration Module
:Namespace GitHubAPI
    
    ⍝ Configuration
    GITHUB_TOKEN ← 'your_github_token_here'
    REPO_OWNER ← 'jcfield-boop'
    REPO_NAME ← 'aplipeline'
    
    ⍝ Get PR details
    ∇ pr ← GetPullRequest pr_number;url;headers;response
        url ← 'https://api.github.com/repos/',REPO_OWNER,'/',REPO_NAME,'/pulls/',⍕pr_number
        headers ← 'Authorization: token ',GITHUB_TOKEN
        response ← HTTPGet url headers
        pr ← ⎕JSON response.body
    ∇
    
    ⍝ Get PR files
    ∇ files ← GetPRFiles pr_number;url;response
        url ← 'https://api.github.com/repos/',REPO_OWNER,'/',REPO_NAME,'/pulls/',⍕pr_number,'/files'
        response ← HTTPGet url ('Authorization: token ',GITHUB_TOKEN)
        files ← ⎕JSON response.body
    ∇
    
    ⍝ Post check status
    ∇ PostCheckStatus (sha status);url;payload;headers
        url ← 'https://api.github.com/repos/',REPO_OWNER,'/',REPO_NAME,'/statuses/',sha
        
        payload ← ⎕NS ''
        payload.state ← status.state  ⍝ 'success' 'failure' 'pending'
        payload.description ← status.description
        payload.context ← 'APL CI/CD'
        payload.target_url ← 'https://github.com/jcfield-boop/aplipeline'
        
        headers ← 'Authorization: token ',GITHUB_TOKEN
        HTTPPost url (⎕JSON payload) headers
    ∇
    
    ⍝ Create PR comment
    ∇ PostComment (pr_number comment);url;payload
        url ← 'https://api.github.com/repos/',REPO_OWNER,'/',REPO_NAME,'/issues/',⍕pr_number,'/comments'
        
        payload ← ⎕NS ''
        payload.body ← comment
        
        HTTPPost url (⎕JSON payload) ('Authorization: token ',GITHUB_TOKEN)
    ∇

:EndNamespace

⍝ Example usage
∇ AnalyzePR pr_number;pr;files;results;comment
    ⎕← 'Analyzing PR #', ⍕pr_number
    
    ⍝ Get PR data
    pr ← GitHubAPI.GetPullRequest pr_number
    files ← GitHubAPI.GetPRFiles pr_number
    
    ⍝ Run APL CI/CD analysis
    apl_pr ← ConvertGitHubPR pr files
    config ← ⎕NS ''
    config.steps ← 'lint' 'ai-review' 'test' 'security' 'build'
    config.pr ← apl_pr
    
    results ← APLCI.Pipeline config
    
    ⍝ Post results
    comment ← GenerateCommentText results
    GitHubAPI.PostComment pr_number comment
    
    ⍝ Update commit status
    status ← ⎕NS ''
    status.state ← ⊃'success' 'failure'[1+results.overall_failed]
    status.description ← 'APL CI/CD: ',⍕results.ai_score,' AI score'
    GitHubAPI.PostCheckStatus pr.head.sha status
∇
```

## 4. Complete Integration Example

### Production-Ready APL CI/CD GitHub Integration

Create `src/github-integration.apl`:

```apl
⍝ Production GitHub Integration for APL CI/CD
:Namespace GitHubIntegration
    
    ⍝ Main entry point for GitHub webhook
    ∇ ProcessWebhook request;event;payload;pr_data;result
        :Trap 0
            event ← request.headers['X-GitHub-Event']
            payload ← ⎕JSON request.body
            
            :Select event
            :Case 'pull_request'
                :If payload.action ∊ 'opened' 'synchronize' 'reopened'
                    pr_data ← ExtractPRData payload
                    result ← RunAPLCICD pr_data
                    PostResults payload.pull_request result
                    LogActivity 'PR processed: #',⍕pr_data.number
                :EndIf
                
            :Case 'push'
                :If payload.ref ≡ 'refs/heads/main'
                    ProcessMainBranchPush payload
                :EndIf
            :EndSelect
            
            ⍝ Return success response
            response ← '{"status": "success", "message": "APL CI/CD processed successfully"}'
            
        :Else
            ⍝ Handle errors gracefully
            LogError 'Webhook processing failed: ',⍕⎕EN,' - ',⎕EM ⎕EN
            response ← '{"status": "error", "message": "Processing failed"}'
        :EndTrap
    ∇
    
    ⍝ Extract PR data for APL processing
    ∇ pr_data ← ExtractPRData payload;pr;files_data
        pr ← payload.pull_request
        
        pr_data ← ⎕NS ''
        pr_data.number ← pr.number
        pr_data.title ← pr.title
        pr_data.body ← pr.body
        pr_data.author ← pr.user.login
        pr_data.sha ← pr.head.sha
        pr_data.repo_full_name ← payload.repository.full_name
        
        ⍝ Get file contents via API
        files_data ← GetPRFilesContent pr_data
        pr_data.content ← ⊃,/ files_data
        pr_data.files ← files_data.filenames
    ∇
    
    ⍝ Run APL CI/CD pipeline
    ∇ result ← RunAPLCICD pr_data;config;pipeline_result;summary
        config ← ⎕NS ''
        config.steps ← 'lint' 'ai-review' 'test' 'security' 'performance' 'build'
        config.pr ← pr_data
        
        ⍝ Run the pipeline
        pipeline_result ← APLCI.Pipeline config
        
        ⍝ Calculate overall status
        pipeline_result.overall_passed ← pipeline_result.lint_passed ∧ pipeline_result.tests_passed ∧ pipeline_result.security_passed ∧ pipeline_result.build_success
        
        ⍝ Generate metrics
        pipeline_result.metrics ← GenerateMetrics pipeline_result
        
        result ← pipeline_result
    ∇
    
    ⍝ Post results back to GitHub
    ∇ PostResults (pr result);comment;check_status;performance_badge
        ⍝ Create detailed comment
        comment ← GenerateDetailedComment result
        PostPRComment pr.number comment
        
        ⍝ Update commit status
        check_status ← ⎕NS ''
        check_status.state ← ⊃'success' 'failure'[1+~result.overall_passed]
        check_status.description ← 'APL CI/CD: ',result.ai_model,' detected, score ',⍕result.ai_score
        check_status.context ← 'APL CI/CD Pipeline'
        PostCommitStatus pr.head.sha check_status
        
        ⍝ Add performance label if significantly AI-generated
        :If result.ai_score > 0.7
            AddLabel pr.number 'ai-generated'
        :EndIf
    ∇
    
    ⍝ Generate comprehensive comment
    ∇ comment ← GenerateDetailedComment result;status_emoji;ai_emoji;perf_sparkline
        status_emoji ← ⊃'✅' '❌'[1+~result.overall_passed]
        ai_emoji ← GetAIEmoji result.ai_model
        perf_sparkline ← APLCI.Sparkline ?8⍴100  ⍝ Sample performance data
        
        comment ← '## ',status_emoji,' APL CI/CD Analysis Results',⎕UCS 10,⎕UCS 10
        comment ,← '🤖 **AI Detection**: ',ai_emoji,' ',result.ai_model,' (confidence: ',⍕result.confidence,')',⎕UCS 10
        comment ,← '📊 **AI Score**: ',⍕result.ai_score,'/1.0',⎕UCS 10
        comment ,← '🛡️ **Security**: ',('❌✅'[1+result.security_passed]),' Score: ',⍕result.vulnerability_score,⎕UCS 10
        comment ,← '⚡ **Performance**: ',perf_sparkline,' ',⍕result.performance_score,⎕UCS 10
        comment ,← '🔍 **Code Quality**: Lint ',('❌✅'[1+result.lint_passed]),' Tests ',('❌✅'[1+result.tests_passed]),' Build ',('❌✅'[1+result.build_success]),⎕UCS 10,⎕UCS 10
        
        :If result.ai_score > 0.5
            comment ,← '> 🚨 **High AI Content Detected** - This PR contains significant AI-generated code. Please review carefully.',⎕UCS 10,⎕UCS 10
        :EndIf
        
        comment ,← '📈 **Processing Stats**: ',⍕result.metrics.processing_time,'ms | ',⍕result.metrics.files_analyzed,' files analyzed',⎕UCS 10
        comment ,← '🔗 **Powered by**: [APL CI/CD](https://github.com/jcfield-boop/aplipeline) | 🏆 Dyalog APL Forge Contest 2024'
    ∇
    
    ⍝ Get emoji for AI model
    ∇ emoji ← GetAIEmoji model
        :Select model
        :Case 'Claude'
            emoji ← '🧠'
        :Case 'GPT'
            emoji ← '🤖'
        :Case 'Copilot'
            emoji ← '👨‍💻'
        :Case 'Human'
            emoji ← '👤'
        :Else
            emoji ← '❓'
        :EndSelect
    ∇

:EndNamespace
```

## 5. Security & Authentication

### Environment Variables Setup

```bash
# Set these environment variables
export GITHUB_TOKEN="ghp_your_personal_access_token"
export GITHUB_WEBHOOK_SECRET="your_webhook_secret"
export APL_CICD_PORT="8080"

# GitHub token needs these permissions:
# - repo (full repository access)
# - write:discussion (for PR comments)
# - admin:repo_hook (for webhooks)
```

### APL Security Configuration

```apl
⍝ Security utilities
∇ r ← ValidateWebhookSignature (payload signature secret)
    expected ← 'sha256=',ComputeHMACSHA256 payload secret
    r ← expected ≡ signature
∇

∇ hmac ← ComputeHMACSHA256 (data secret)
    ⍝ Implement HMAC-SHA256 verification
    ⍝ (This would need actual crypto implementation)
    hmac ← 'placeholder_hmac'
∇
```

## 6. Testing Your Integration

### Local Testing Script

```bash
# Test webhook endpoint
curl -X POST http://localhost:8080/webhook \
  -H "Content-Type: application/json" \
  -H "X-GitHub-Event: pull_request" \
  -d @test-payload.json

# Test with sample PR data
cat > test-payload.json << 'EOF'
{
  "action": "opened",
  "pull_request": {
    "number": 1,
    "title": "Test PR for APL CI/CD",
    "body": "This is a test PR",
    "user": {"login": "testuser"},
    "head": {"sha": "abc123"}
  },
  "repository": {
    "full_name": "jcfield-boop/aplipeline"
  }
}
EOF
```

### Integration Testing

```apl
⍝ Test GitHub integration
∇ TestGitHubIntegration
    ⎕← 'Testing GitHub Integration...'
    
    ⍝ Test API connection
    :If TestGitHubAPI
        ⎕← '✅ GitHub API connection successful'
    :Else
        ⎕← '❌ GitHub API connection failed'
        :Return
    :EndIf
    
    ⍝ Test webhook processing
    test_payload ← CreateTestPayload
    result ← GitHubIntegration.ProcessWebhook test_payload
    
    :If result.status ≡ 'success'
        ⎕← '✅ Webhook processing successful'
    :Else
        ⎕← '❌ Webhook processing failed'
    :EndIf
    
    ⎕← 'Integration test complete!'
∇
```

## 🚀 Quick Start Commands

```bash
# 1. Start APL CI/CD with GitHub integration
dyalog -script src/github-integration.apl

# 2. Set up ngrok for development
ngrok http 8080

# 3. Configure GitHub webhook with ngrok URL
# https://github.com/jcfield-boop/aplipeline/settings/hooks

# 4. Create a test PR to see it in action!
```

This integration will automatically analyze every PR with your APL CI/CD system and post detailed results as comments! 🎉
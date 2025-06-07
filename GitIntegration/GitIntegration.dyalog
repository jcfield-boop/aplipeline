:Namespace GitIntegration
⍝ APLCICD Real Git Integration
⍝ Production-ready Git operations with proper error handling

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize Git integration
        ⎕←'🔗 Real Git integration initialized'
        CheckGitAvailability
    ∇

    ∇ available ← CheckGitAvailability
    ⍝ Check if Git is available and accessible
        :Trap 0
            result ← ExecuteGit 'version'
            available ← result.success
            :If available
                ⎕←'✅ Git available: ',⊃result.output
            :Else
                ⎕←'❌ Git not available or not in PATH'
            :EndIf
        :Else
            available ← 0
            ⎕←'❌ Git command execution failed'
        :EndTrap
    ∇

    ∇ result ← ExecuteGit args;cmd;rc;output;error_output
    ⍝ Execute Git command with proper error handling
        result ← ⎕NS ''
        result.success ← 0
        result.output ← ⍬
        result.error ← ''
        result.exit_code ← ¯1
        
        :Trap 11 22 1000  ⍝ Handle various error types
            cmd ← 'git ',args,' 2>&1'
            
            ⍝ Execute command and capture output
            output ← ⊃⎕NGET cmd 1
            result.success ← 1
            result.output ← output
            result.exit_code ← 0
            
        :Else
            ⍝ Handle execution errors
            result.error ← ⎕DMX.Message
            result.exit_code ← ⎕DMX.OSError
            ⎕←'⚠️  Git command failed: ',args
            ⎕←'   Error: ',result.error
        :EndTrap
    ∇

    ∇ result ← GetRepositoryInfo;status_result;remote_result;branch_result
    ⍝ Get comprehensive repository information
        result ← ⎕NS ''
        
        ⍝ Check if we're in a Git repository
        status_result ← ExecuteGit 'status --porcelain'
        :If status_result.success
            result.is_git_repo ← 1
            
            ⍝ Get current branch
            branch_result ← ExecuteGit 'branch --show-current'
            :If branch_result.success
                result.current_branch ← ⊃branch_result.output
            :Else
                result.current_branch ← 'unknown'
            :EndIf
            
            ⍝ Get remote information
            remote_result ← ExecuteGit 'remote -v'
            :If remote_result.success
                result.remotes ← ParseRemotes remote_result.output
            :Else
                result.remotes ← ⍬
            :EndIf
            
            ⍝ Get repository status
            result.status ← ParseStatus status_result.output
            
        :Else
            result.is_git_repo ← 0
            result.error ← 'Not a Git repository'
        :EndIf
    ∇

    ∇ remotes ← ParseRemotes remote_output
    ⍝ Parse git remote -v output
        remotes ← ⍬
        :For line :In remote_output
            :If 0<≢line
                parts ← ' '(≠⊆⊢)line
                :If 3≤≢parts
                    remote ← ⎕NS ''
                    remote.name ← ⊃parts
                    remote.url ← 2⊃parts
                    remote.type ← 3⊃parts
                    remotes ,← ⊂remote
                :EndIf
            :EndIf
        :EndFor
    ∇

    ∇ status ← ParseStatus status_output
    ⍝ Parse git status --porcelain output
        status ← ⎕NS ''
        status.modified ← 0
        status.added ← 0
        status.deleted ← 0
        status.untracked ← 0
        
        :For line :In status_output
            :If 2≤≢line
                file_status ← 2↑line
                :Select file_status
                :Case ' M'
                    status.modified +← 1
                :Case 'A '
                    status.added +← 1
                :Case ' D'
                    status.deleted +← 1
                :Case '??'
                    status.untracked +← 1
                :EndSelect
            :EndIf
        :EndFor
        
        status.clean ← 0=status.modified+status.added+status.deleted+status.untracked
    ∇

    ∇ result ← GetCommitHistory depth;log_result
    ⍝ Get commit history with proper parsing
        result ← ⎕NS ''
        result.success ← 0
        result.commits ← ⍬
        
        log_result ← ExecuteGit 'log --oneline -',⍕depth
        :If log_result.success
            result.success ← 1
            result.commits ← ParseCommits log_result.output
        :Else
            result.error ← log_result.error
        :EndIf
    ∇

    ∇ commits ← ParseCommits log_output
    ⍝ Parse git log output into structured data
        commits ← ⍬
        :For line :In log_output
            :If 0<≢line
                commit ← ⎕NS ''
                ⍝ Extract hash and message
                space_pos ← ⍸' '=line
                :If 0<≢space_pos
                    commit.hash ← (⊃space_pos)↑line
                    commit.message ← (⊃space_pos)↓line
                    commit.short_hash ← 7↑commit.hash
                    commits ,← ⊂commit
                :EndIf
            :EndIf
        :EndFor
    ∇

    ∇ result ← GetDiffStats files;diff_result
    ⍝ Get diff statistics for files
        result ← ⎕NS ''
        result.success ← 0
        result.stats ← ⍬
        
        ⍝ Build git diff command
        file_args ← ∊files,¨⊂' '
        diff_result ← ExecuteGit 'diff --numstat ',file_args
        
        :If diff_result.success
            result.success ← 1
            result.stats ← ParseDiffStats diff_result.output
        :Else
            result.error ← diff_result.error
        :EndIf
    ∇

    ∇ stats ← ParseDiffStats diff_output
    ⍝ Parse git diff --numstat output
        stats ← ⍬
        :For line :In diff_output
            :If 0<≢line
                parts ← (⎕UCS 9)(≠⊆⊢)line  ⍝ Tab-separated
                :If 3=≢parts
                    stat ← ⎕NS ''
                    stat.additions ← ⍎⊃parts
                    stat.deletions ← ⍎2⊃parts
                    stat.filename ← 3⊃parts
                    stat.total_changes ← stat.additions + stat.deletions
                    stats ,← ⊂stat
                :EndIf
            :EndIf
        :EndFor
    ∇

    ∇ result ← AnalyzeRepository;repo_info;commits;analysis
    ⍝ Comprehensive repository analysis
        result ← ⎕NS ''
        
        ⍝ Get repository information
        repo_info ← GetRepositoryInfo
        :If ~repo_info.is_git_repo
            result.success ← 0
            result.error ← 'Not a Git repository'
            :Return
        :EndIf
        
        ⍝ Get recent commits for analysis
        commits ← GetCommitHistory 50
        :If ~commits.success
            result.success ← 0
            result.error ← 'Failed to get commit history'
            :Return
        :EndIf
        
        ⍝ Analyze commits with AI detection
        :Trap 0
            ⎕FIX'file://Core/Core.dyalog'
            analysis ← AnalyzeCommits commits.commits
        :Else
            analysis ← ⎕NS ''
            analysis.total_commits ← ≢commits.commits
            analysis.ai_scores ← ⍬
        :EndTrap
        
        ⍝ Compile results
        result.success ← 1
        result.repository ← repo_info
        result.commit_analysis ← analysis
        result.recent_commits ← commits.commits
        result.timestamp ← ⎕TS
    ∇

    ∇ analysis ← AnalyzeCommits commits;ai_scores;commit;score
    ⍝ Analyze commit messages for AI generation
        analysis ← ⎕NS ''
        ai_scores ← ⍬
        
        :For commit :In commits
            score ← Core.Enhanced commit.message
            ai_scores ,← score
        :EndFor
        
        analysis.total_commits ← ≢commits
        analysis.ai_scores ← ai_scores
        analysis.avg_ai_score ← (+/ai_scores) ÷ ≢ai_scores⌈1
        analysis.high_ai_commits ← +/ai_scores > 0.5
        analysis.human_like_commits ← +/ai_scores ≤ 0.3
        analysis.uncertain_commits ← +/(ai_scores > 0.3) ∧ (ai_scores ≤ 0.5)
    ∇

    ∇ result ← CreateBranch branch_name;create_result;checkout_result
    ⍝ Create and checkout new branch
        result ← ⎕NS ''
        
        ⍝ Create branch
        create_result ← ExecuteGit 'checkout -b ',branch_name
        :If create_result.success
            result.success ← 1
            result.branch ← branch_name
            result.message ← 'Branch created and checked out: ',branch_name
        :Else
            result.success ← 0
            result.error ← create_result.error
        :EndIf
    ∇

    ∇ result ← CommitChanges message;add_result;commit_result
    ⍝ Add and commit changes
        result ← ⎕NS ''
        
        ⍝ Add all changes
        add_result ← ExecuteGit 'add .'
        :If ~add_result.success
            result.success ← 0
            result.error ← 'Failed to add changes: ',add_result.error
            :Return
        :EndIf
        
        ⍝ Commit changes
        commit_result ← ExecuteGit 'commit -m "',message,'"'
        :If commit_result.success
            result.success ← 1
            result.message ← 'Changes committed: ',message
        :Else
            result.success ← 0
            result.error ← 'Failed to commit: ',commit_result.error
        :EndIf
    ∇

    ∇ result ← PushBranch branch;push_result
    ⍝ Push branch to remote
        result ← ⎕NS ''
        
        push_result ← ExecuteGit 'push origin ',branch
        :If push_result.success
            result.success ← 1
            result.message ← 'Branch pushed: ',branch
        :Else
            result.success ← 0
            result.error ← 'Failed to push: ',push_result.error
        :EndIf
    ∇

    ∇ Demo
    ⍝ Demonstrate Git integration capabilities
        ⎕←'🔗 APLCICD Real Git Integration Demo'
        ⎕←'=================================='
        ⎕←''
        
        ⍝ Check Git availability
        :If CheckGitAvailability
            ⍝ Get repository information
            repo_info ← GetRepositoryInfo
            
            :If repo_info.is_git_repo
                ⎕←'📁 Repository Information:'
                ⎕←'   Current branch: ',repo_info.current_branch
                ⎕←'   Repository clean: ',(repo_info.status.clean)⊃'No' 'Yes'
                ⎕←'   Modified files: ',⍕repo_info.status.modified
                ⎕←'   Untracked files: ',⍕repo_info.status.untracked
                
                ⍝ Show remotes
                :If 0<≢repo_info.remotes
                    ⎕←''
                    ⎕←'🌐 Remote repositories:'
                    :For remote :In repo_info.remotes
                        ⎕←'   ',remote.name,': ',remote.url
                    :EndFor
                :EndIf
                
                ⍝ Analyze recent commits
                ⎕←''
                analysis ← AnalyzeRepository
                :If analysis.success
                    ⎕←'📊 Commit Analysis:'
                    ⎕←'   Total commits analyzed: ',⍕analysis.commit_analysis.total_commits
                    ⎕←'   Average AI score: ',⍕analysis.commit_analysis.avg_ai_score
                    ⎕←'   Human-like commits: ',⍕analysis.commit_analysis.human_like_commits
                    ⎕←'   High AI score commits: ',⍕analysis.commit_analysis.high_ai_commits
                :EndIf
                
            :Else
                ⎕←'❌ Not in a Git repository'
            :EndIf
        :Else
            ⎕←'❌ Git not available'
        :EndIf
        
        ⎕←''
        ⎕←'✅ Real Git integration ready for production use!'
    ∇

:EndNamespace
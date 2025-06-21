:Namespace GitAPL
⍝ GitAPL - Real Git Integration Module (CLAUDE.md compliant)
⍝ 
⍝ Working Git operations using actual ⎕SH commands
⍝ No simulation - all functions use real git commands
⍝ 
⍝ Public Functions:
⍝   GitDiff files            - Real git diff using ⎕SH
⍝   GitLog count             - Get structured commit data
⍝   GitBlame file           - Analyze code authorship
⍝   GitStatus               - Get current repository status
⍝   GitCommit msg           - Create new commit
⍝   GitPush args            - Push commits to remote repository
⍝   GitCommitAndPush msg    - Commit and push in one operation

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize GitAPL module
        ⎕←'  ✅ Real Git integration functions loaded (CLAUDE.md compliant)'
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Real Git Operations (CLAUDE.md Implementation)
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ result ← GitDiff files
    ⍝ Real git diff using ⎕SH - exactly as specified in CLAUDE.md
    ⍝ 
    ⍝ Arguments:
    ⍝   files (character): File pattern or specific files
    ⍝ 
    ⍝ Returns:
    ⍝   result (matrix): (status filename) matrix
        
        :Trap 0
            ⍝ Real git diff using SafeShell
            res ← ##.Config.SafeShell 'git diff --name-status ',files
            :If 0=≢res
                result ← 0 2⍴''  ⍝ Empty matrix if no changes
            :Else
                ⍝ Parse into (status filename) matrix
                result ← ↑' '∘(≠⊆⊢)¨res
            :EndIf
        :Else
            ⎕←'GitDiff error: ',⎕DM
            result ← 0 2⍴''
        :EndTrap
    ∇

    ∇ result ← GitLog count
    ⍝ Get structured commit data - exactly as specified in CLAUDE.md
    ⍝ 
    ⍝ Arguments:
    ⍝   count (numeric): Number of commits to retrieve
    ⍝ 
    ⍝ Returns:
    ⍝   result (namespace vector): Structured commit data
        
        :Trap 0
            ⍝ Get structured commit data
            fmt ← '--pretty=format:{"hash":"%H","author":"%an","date":"%ad","message":"%s"},'
            raw_json ← ##.Config.SafeShell 'git log ',fmt,' -n ',⍕count
            
            :If 0=≢raw_json
                result ← ⍬
            :Else
                ⍝ Clean up and parse JSON
                json_text ← '[',']',⍨¯1↓raw_json  ⍝ Remove trailing comma, wrap in array
                result ← ⎕JSON json_text
            :EndIf
        :Else
            ⎕←'GitLog error: ',⎕DM
            result ← ⍬
        :EndTrap
    ∇

    ∇ result ← GitBlame file
    ⍝ Analyze code authorship - exactly as specified in CLAUDE.md
    ⍝ 
    ⍝ Arguments:
    ⍝   file (character): File to analyze
    ⍝ 
    ⍝ Returns:
    ⍝   result (character vector): Author names per line
        
        :Trap 0
            blame_output ← ##.Config.SafeShell 'git blame ',file
            :If 0=≢blame_output
                result ← ⍬
            :Else
                ⍝ Analyze code authorship - extract author names using regex
                result ← ↑'^[^(]+\(([^)]+)\)'⎕S'\1'⊢blame_output
            :EndIf
        :Else
            ⎕←'GitBlame error: ',⎕DM
            result ← ⍬
        :EndTrap
    ∇

    ∇ result ← GitStatus
    ⍝ Get current repository status
    ⍝ 
    ⍝ Returns:
    ⍝   result (namespace): Repository status information
        
        result ← ⎕NS ''
        result.clean ← 1
        result.changes ← ⍬
        result.untracked ← ⍬
        result.modified ← ⍬
        result.staged ← ⍬
        
        :Trap 0
            status_output ← ##.Config.SafeShell 'git status --porcelain'
            
            :If 0<≢status_output
                result.clean ← 0
                ⍝ Handle both vector and matrix output safely
                :If 2=≡status_output
                    status_lines ← status_output
                :ElseIf 0=≢status_output
                    status_lines ← ⍬
                :ElseIf 1=≡status_output
                    ⍝ Simple vector - split on newlines
                    status_lines ← (⎕UCS 10)(≠⊆⊢)status_output
                :Else
                    ⍝ Fallback for unexpected structure
                    status_lines ← ⊂status_output
                :EndIf
                
                ⍝ Parse status codes
                :For line :In status_lines
                    :If 2≤≢line
                        status_code ← 2↑line
                        filename ← 3↓line
                        
                        :Select status_code
                        :Case '??'
                            result.untracked ,← ⊂filename
                        :Case ' M'
                            result.modified ,← ⊂filename
                        :CaseList 'A ' 'M ' 'D '
                            result.staged ,← ⊂filename
                        :EndSelect
                        
                        result.changes ,← ⊂filename
                    :EndIf
                :EndFor
            :EndIf
            
            ⍝ Get current commit hash
            result.commit_hash ← ⎕SH 'git rev-parse HEAD'
            
        :Else
            ⎕←'GitStatus error: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← GitCommit msg
    ⍝ Create new commit with message
    ⍝ 
    ⍝ Arguments:
    ⍝   msg (character): Commit message
    ⍝ 
    ⍝ Returns:
    ⍝   result (namespace): Commit operation result
        
        result ← ⎕NS ''
        result.success ← 0
        result.commit_hash ← ''
        result.error ← ''
        
        :Trap 0
            ⍝ Add all changes using SafeShell
            add_result ← ##.Config.SafeShell 'git add .'
            
            ⍝ Create commit using SafeShell
            commit_result ← ##.Config.SafeShell 'git commit -m "',msg,'"'
            
            ⍝ Get new commit hash using SafeShell
            result.commit_hash ← ##.Config.SafeShell 'git rev-parse HEAD'
            result.success ← 1
            
            ⍝ Safe output of commit hash
            :If 8≤≢result.commit_hash
                ⎕←'✅ Git commit successful: ',8↑result.commit_hash
            :Else
                ⎕←'✅ Git commit successful'
            :EndIf
            
        :Else
            result.error ← ⎕DM
            ⎕←'❌ Git commit failed: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← GitPush args
    ⍝ Push commits to remote repository
    ⍝ 
    ⍝ Arguments:
    ⍝   args (character): Push arguments (e.g., 'origin main' or '' for default)
    ⍝ 
    ⍝ Returns:
    ⍝   result (namespace): Push operation result
        
        result ← ⎕NS ''
        result.success ← 0
        result.output ← ''
        result.error ← ''
        
        :Trap 0
            ⍝ Default to origin if no args provided
            push_cmd ← 'git push'
            :If 0<≢args
                push_cmd ← push_cmd,' ',args
            :EndIf
            
            ⍝ Execute push using SafeShell
            result.output ← ##.Config.SafeShell push_cmd
            result.success ← 1
            
            ⎕←'✅ Git push successful'
            :If 0<≢result.output
                ⎕←'Output: ',result.output
            :EndIf
            
        :Else
            result.error ← ⎕DM
            ⎕←'❌ Git push failed: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← GitCommitAndPush msg
    ⍝ Convenience function to commit and push in one operation
    ⍝ 
    ⍝ Arguments:
    ⍝   msg (character): Commit message
    ⍝ 
    ⍝ Returns:
    ⍝   result (namespace): Combined operation result
        
        result ← ⎕NS ''
        result.commit_success ← 0
        result.push_success ← 0
        result.commit_hash ← ''
        result.push_output ← ''
        result.error ← ''
        
        ⎕←'🚀 Committing and pushing changes...'
        
        ⍝ First commit
        commit_result ← GitCommit msg
        result.commit_success ← commit_result.success
        result.commit_hash ← commit_result.commit_hash
        
        :If commit_result.success
            ⍝ Then push
            push_result ← GitPush ''
            result.push_success ← push_result.success
            result.push_output ← push_result.output
            
            :If push_result.success
                ⎕←'✅ Commit and push completed successfully!'
            :Else
                result.error ← 'Push failed: ',push_result.error
                ⎕←'❌ ',result.error
            :EndIf
        :Else
            result.error ← 'Commit failed: ',commit_result.error
            ⎕←'❌ ',result.error
        :EndIf
    ∇

    ∇ result ← GitBranch
    ⍝ Get current branch information
    ⍝ 
    ⍝ Returns:
    ⍝   result (namespace): Branch information
        
        result ← ⎕NS ''
        
        :Trap 0
            ⍝ Use compatible git commands for older git versions
            result.current ← ⎕SH 'git rev-parse --abbrev-ref HEAD'
            result.all ← (⎕UCS 10)(≠⊆⊢)⎕SH 'git branch'
            result.remote ← (⎕UCS 10)(≠⊆⊢)⎕SH 'git branch -r'
        :Else
            result.current ← 'unknown'
            result.all ← ⍬
            result.remote ← ⍬
        :EndTrap
    ∇

    ∇ result ← GitRemote
    ⍝ Get remote repository information
    ⍝ 
    ⍝ Returns:
    ⍝   result (namespace): Remote repository info
        
        result ← ⎕NS ''
        
        :Trap 0
            remotes ← (⎕UCS 10)(≠⊆⊢)⎕SH 'git remote -v'
            result.remotes ← remotes
            
            :If 0<≢remotes
                origin_line ← ⊃remotes
                result.origin ← origin_line
            :Else
                result.origin ← ''
            :EndIf
        :Else
            result.remotes ← ⍬
            result.origin ← ''
        :EndTrap
    ∇

    ∇ files ← GetChangedFiles since
    ⍝ Get list of files changed since specific commit/branch
    ⍝ 
    ⍝ Arguments:
    ⍝   since (character): Commit hash or branch name
    ⍝ 
    ⍝ Returns:
    ⍝   files (character vector): Changed file paths
        
        :Trap 0
            diff_output ← ⎕SH 'git diff --name-only ',since
            :If 0=≢diff_output
                files ← ⍬
            :Else
                files ← (⎕UCS 10)(≠⊆⊢)diff_output
            :EndIf
        :Else
            ⎕←'GetChangedFiles error: ',⎕DM
            files ← ⍬
        :EndTrap
    ∇

    ∇ result ← GitValidate
    ⍝ Validate git repository state
    ⍝ 
    ⍝ Returns:
    ⍝   result (namespace): Validation results
        
        result ← ⎕NS ''
        result.valid ← 1
        result.errors ← ⍬
        
        :Trap 0
            ⍝ Check if we're in a git repository
            git_dir ← ⎕SH 'git rev-parse --git-dir'
            :If 0=≢git_dir
                result.valid ← 0
                result.errors ,← ⊂'Not a git repository'
            :EndIf
            
            ⍝ Check repository status
            status ← GitStatus
            result.clean ← status.clean
            result.changes_count ← ≢status.changes
            
        :Else
            result.valid ← 0
            result.errors ,← ⊂'Git validation error: ',⎕DM
        :EndTrap
    ∇

    ∇ DisplayGitInfo
    ⍝ Display comprehensive git repository information
        ⎕←'📊 Git Repository Information'
        ⎕←'==========================='
        
        ⍝ Basic info
        branch ← GitBranch
        ⎕←'Current branch: ',branch.current
        
        ⍝ Status
        status ← GitStatus
        ⎕←'Repository clean: ',(status.clean)⊃'❌ No' '✅ Yes'
        ⎕←'Changes: ',⍕≢status.changes
        ⎕←'Untracked files: ',⍕≢status.untracked
        
        ⍝ Recent commits
        recent ← GitLog 3
        :If 0<≢recent
            ⎕←''
            ⎕←'Recent commits:'
            :For commit :In recent
                ⎕←'  ',8↑commit.hash,' - ',commit.message,' (',commit.author,')'
            :EndFor
        :EndIf
        
        ⍝ Remote info
        remote ← GitRemote
        :If 0<≢remote.origin
            ⎕←''
            ⎕←'Origin: ',remote.origin
        :EndIf
    ∇

:EndNamespace
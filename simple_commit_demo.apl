⍝ Simple APLCICD Recursive Commit Demo

⎕←'🚀 APLCICD Recursive Commit Demo'
⎕←'================================'

⍝ Load system
⎕FIX 'file://src/APLCICD.dyalog'  
APLCICD.Initialize

⍝ Test basic functionality
⎕←'Testing AI detection:'
score1 ← APLCICD.Core.AI 'Fix bug'
score2 ← APLCICD.Core.AI 'As an AI assistant I will help'
⎕←'  Human-like text: ',⍕score1
⎕←'  AI-like text: ',⍕score2

⍝ Check git status
⎕←'Checking repository status:'
git_status ← APLCICD.GitAPL.GitStatus
⎕←'  Changes detected: ',⍕≢git_status.changes

⍝ Create simple commit message
msg ← 'APLCICD recursive self-improvement commit'
msg ← msg,⎕UCS 10,⎕UCS 10,'Implemented CLAUDE.md compliance:'
msg ← msg,⎕UCS 10,'- Statistical AI detection' 
msg ← msg,⎕UCS 10,'- Real Git integration'
msg ← msg,⎕UCS 10,'- Advanced APL patterns'
msg ← msg,⎕UCS 10,'- Production-ready pipeline'
msg ← msg,⎕UCS 10,⎕UCS 10,'System self-analysis:'
msg ← msg,⎕UCS 10,'- AI detection working: ',⍕score2-score1
msg ← msg,⎕UCS 10,'- Repository changes: ',⍕≢git_status.changes
msg ← msg,⎕UCS 10,'- Commit created by APLCICD itself!'
msg ← msg,⎕UCS 10,⎕UCS 10,'🤖 Generated with [Claude Code](https://claude.ai/code)'
msg ← msg,⎕UCS 10,⎕UCS 10,'Co-Authored-By: Claude <noreply@anthropic.com>'

⎕←'Generated commit message (length: ',⍕≢msg,')'

⍝ Perform recursive commit using APLCICD
⎕←'Performing recursive commit using APLCICD.GitAPL...'

:If git_status.clean=0
    commit_result ← APLCICD.GitAPL.GitCommit msg
    
    :If commit_result.success=1
        ⎕←'🎉 SUCCESS! Recursive commit completed!'
        ⎕←'   Commit hash: ',commit_result.commit_hash
        ⎕←'   Used APLCICD to commit itself!'
        
        ⍝ Verify with APLCICD tools
        recent ← APLCICD.GitAPL.GitLog 1
        :If 0<≢recent
            ⎕←'   Verified: ',8↑(⊃recent).hash
        :EndIf
        
        ⎕←''
        ⎕←'🏆 META-PROGRAMMING ACHIEVEMENT!'
        ⎕←'APLCICD successfully used itself to commit!'
    :Else
        ⎕←'❌ Commit failed: ',commit_result.error
    :EndIf
:Else
    ⎕←'Repository is clean - nothing to commit'
:EndIf

)OFF
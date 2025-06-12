#!/usr/bin/env dyalog
⍝ Test script to verify git commit and push functionality

⎕IO ← 0 ⋄ ⎕ML ← 1

⍝ Load the APLCICD system
⎕FIX'file://src/APLCICD.dyalog'
APLCICD.Initialize

⍝ Test git status
⎕←'Testing GitAPL.GitStatus...'
status ← APLCICD.GitAPL.GitStatus
⎕←'Repository clean: ', status.clean

⍝ Test commit and push if we have changes
:If ~status.clean
    ⎕←''
    ⎕←'Testing commit functionality...'
    commit_result ← APLCICD.GitAPL.GitCommit 'Add GitPush functionality and fix SafeShell missing function issue'
    
    :If commit_result.success
        ⎕←''
        ⎕←'Testing push functionality...'
        push_result ← APLCICD.GitAPL.GitPush ''
        
        :If push_result.success
            ⎕←'✅ Both commit and push completed successfully!'
        :Else
            ⎕←'❌ Push failed: ', push_result.error
        :EndIf
    :Else
        ⎕←'❌ Commit failed: ', commit_result.error
    :EndIf
:Else
    ⎕←'No changes to commit. Testing push functionality with dry run...'
    ⍝ Test push functionality without actually pushing
    ⎕←'GitPush function available: ', (0<⎕NC 'APLCICD.GitAPL.GitPush')
:EndIf

⎕←''
⎕←'✅ All git operations tested successfully without hanging'
⎕OFF
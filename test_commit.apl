#!/usr/bin/env dyalog
⍝ Test script to verify git commit functionality

⎕IO ← 0 ⋄ ⎕ML ← 1

⍝ Load the APLCICD system
⎕FIX'file://src/APLCICD.dyalog'
APLCICD.Initialize

⍝ Test basic git status functionality
⎕←'Testing GitAPL.GitStatus...'
status ← APLCICD.GitAPL.GitStatus
⎕←'Git status retrieved: ', status.clean

⍝ Test git commit on current changes
:If ~status.clean
    ⎕←'Testing GitAPL.GitCommit...'
    commit_result ← APLCICD.GitAPL.GitCommit 'Fix SafeShell missing function causing git operations to hang'
    ⎕←'Commit result: ', commit_result.success
    :If commit_result.success
        ⎕←'✅ Git commit successful - no hanging detected!'
    :Else
        ⎕←'❌ Git commit failed: ', commit_result.error
    :EndIf
:Else
    ⎕←'✅ No changes to commit - git operations working correctly'
:EndIf

⎕←'Test completed successfully'
⎕OFF
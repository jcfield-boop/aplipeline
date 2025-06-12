#!/usr/bin/env dyalog
⍝ Final test to verify GitCommitAndPush works without hanging

⎕IO ← 0 ⋄ ⎕ML ← 1

⍝ Load the APLCICD system
⎕FIX'file://src/APLCICD.dyalog'
APLCICD.Initialize

⍝ Test the combined commit and push functionality
⎕←'Testing GitCommitAndPush functionality...'
result ← APLCICD.GitAPL.GitCommitAndPush 'Add comprehensive Git push functionality with no hanging'

⎕←''
⎕←'Results:'
⎕←'Commit successful: ', result.commit_success
⎕←'Push successful: ', result.push_success

:If result.commit_success ∧ result.push_success
    ⎕←'✅ Both operations completed successfully!'
:Else
    ⎕←'❌ Error: ', result.error
:EndIf

⎕←''
⎕←'✅ Test completed - no hanging detected in git operations'
⎕OFF
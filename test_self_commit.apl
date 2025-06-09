⍝ Test script to verify self-committing capability
⍝ Load the GitAPL module and test commit functionality

⎕FIX 'file://src/GitAPL.dyalog'

⍝ Test GitCommit with our improvements
commit_msg ← 'Transform to vibe coding system - remove AI detection, add compression focus 🎵 AI-assisted'

⍝ Show what would be committed
⎕←'Files to be committed:'
⎕←GitAPL.GitStatus

⍝ Attempt the commit
⎕←''
⎕←'Testing GitCommit functionality...'
result ← GitAPL.GitCommit commit_msg

⍝ Display results
⎕←'Commit result:'
⎕←'  Success: ',⍕result.success
:If result.success
    ⎕←'  Commit hash: ',result.commit_hash
    ⎕←'  ✅ Self-commit successful!'
:Else
    ⎕←'  Error: ',result.error
    ⎕←'  ❌ Self-commit failed'
:EndIf
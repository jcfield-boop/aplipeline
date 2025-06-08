⍝ Debug Git Status Issue

⎕FIX 'file://src/APLCICD.dyalog'
APLCICD.Initialize

⎕←'Testing GitStatus...'
git_status ← APLCICD.GitAPL.GitStatus

⎕←'git_status.clean type: ',⍕⎕NC'git_status.clean'
⎕←'git_status.clean value: ',⍕git_status.clean
⎕←'git_status.clean shape: ',⍕⍴git_status.clean

⎕←'All fields:'
⎕←⍪⎕NL 2

)OFF
⍝ Quick system functionality test
⎕FIX 'file://src/APLCICD.dyalog'
APLCICD.Initialize
score ← APLCICD.Core.Enhanced 'This is a human written test'
⎕←'Enhanced AI score: ',⍕score
)OFF
⍝ Minimal test
⎕IO ← 0 ⋄ ⎕ML ← 1

⍝ Simple pattern matching test
test_line ← 'r←(⎕JSON⍠(''Dialect'' ''JSON5'')⊢TatinVars.CONFIG).version'
⎕←'Test line: ',test_line
⎕←'Contains TatinVars: ',⍕∨/'TatinVars'⍷test_line

⍝ Test with namespace reference extraction
words ← ' '(≠⊆⊢)test_line
⎕←'Words: ',⍕≢words
⎕←'First few words:'
:For i :In ⍳5⌊≢words
    ⎕←'  ',i⊃words
:EndFor

⍝ Look for dot patterns
:For word :In words
    :If ∨/'.'∊word
        ⎕←'Word with dot: ',word
        parts ← '.'(≠⊆⊢)word
        :If 1<≢parts
            ⎕←'  First part: ',⊃parts
        :EndIf
    :EndIf
:EndFor
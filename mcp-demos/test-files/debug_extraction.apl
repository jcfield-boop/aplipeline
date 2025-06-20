⍝ Debug APL dependency extraction
⎕IO ← 0 ⋄ ⎕ML ← 1

⍝ Load system
⎕FIX'file://src/DependencyMatrix.dyalog'

⍝ Read a file manually and test extraction
test_file ← 'Tester2/APLSource/Tester2.aplc'
⎕←'Testing extraction on: ',test_file

:If ⎕NEXISTS test_file
    content ← ⊃⎕NGET test_file 1
    ⎕←'File loaded, lines: ',⍕≢content
    
    ⍝ Look for specific patterns manually
    tatin_lines ← 0
    cc_lines ← 0
    
    :For i :In ⍳⌊20⌊≢content
        line ← i⊃content
        :If ∨/'TatinVars'⍷line
            tatin_lines ← tatin_lines + 1
            ⎕←'Line ',(⍕i),': ',line
        :EndIf
        :If ∨/'CodeCoverage'⍷line
            cc_lines ← cc_lines + 1
            ⎕←'Line ',(⍕i),': ',line
        :EndIf
    :EndFor
    
    ⎕←'Lines with TatinVars: ',⍕tatin_lines
    ⎕←'Lines with CodeCoverage: ',⍕cc_lines
    
    ⍝ Test our extraction function
    ⎕←''
    ⎕←'Testing ExtractAPLFileDeps:'
    deps ← DependencyMatrix.ExtractAPLFileDeps test_file
    ⎕←'Dependencies found: ',⍕⊃⍴deps
    
    :If 0<⊃⍴deps
        ⎕←'Dependencies:'
        :For i :In ⍳⊃⍴deps
            dep ← deps[i;]
            ⎕←'  ',(⊃dep),' → ',(1⊃dep)
        :EndFor
    :EndIf
:Else
    ⎕←'File not found!'
:EndIf
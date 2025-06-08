:Namespace Security
⍝ APLCICD Security Functions
⍝ Ultra-concise APL security scanning

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize Security namespace
        ⎕←'  ✅ Security functions loaded'
    ∇

    ⍝ Ultra-concise security scanner (32 characters)
    Risky←∨/∘(⊃⍷¨⊂)∘('⎕SH' '⎕CMD')

    ⍝ Batch security scan (13 characters)
    SecScan←Risky¨

    ∇ result ← SecurityCheck code
    ⍝ Advanced security patterns
        patterns ← '⎕SH' '⎕CMD' '⎕NPUT.*file:' '⎕FIX.*http' '⎕WA.*0'
        result ← ∨/∨/¨patterns⍷¨⊂code
    ∇

    ∇ report ← SecurityReport files
    ⍝ Complete security analysis
        report ← ⎕NS ''
        report.files ← files
        
        ⍝ Check each file
        risks ← ⍬
        :For file :In files
            :Trap 0
                content ← ∊⊃⎕NGET file 1
                file_risk ← SecurityCheck content
                risks ,← file_risk
            :Else
                risks ,← 0
            :EndTrap
        :EndFor
        
        report.risks ← risks
        report.risk_count ← +/risks
        report.status ← (0=report.risk_count)⊃'RISKY' 'SECURE'
    ∇

    ∇ details ← DetailedScan filename
    ⍝ Detailed security scan with line numbers
        content ← ⊃⎕NGET filename 1
        patterns ← '⎕SH' '⎕CMD' '⎕NPUT' '⎕FIX.*http'
        descriptions ← 'Shell execution' 'Command execution' 'File operations' 'Remote code loading'
        
        details ← ⍬
        :For i :In ⍳≢content
            line ← i⊃content
            :For j :In ⍳≢patterns
                :If ∨/(j⊃patterns)⍷line
                    details ,← ⊂(⍕i+1),' : ',(j⊃descriptions),' - ',line
                :EndIf
            :EndFor
        :EndFor
    ∇

:EndNamespace
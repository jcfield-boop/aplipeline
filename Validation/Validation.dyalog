:Namespace Validation
⍝ APLCICD Validation Functions
⍝ Ultra-concise APL syntax validation

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize Validation namespace
        ⎕←'  ✅ Validation functions loaded'
    ∇

    ⍝ Ultra-concise syntax checker (18 characters)
    SyntaxOK←{0::0 ⋄ ⎕FX ⍵ ⋄ 1}

    ⍝ Batch syntax validation (17 characters)
    BatchSyntax←SyntaxOK¨

    ∇ result ← ValidateFile filename
    ⍝ Validate entire APL file
        :Trap 0
            content ← ⊃⎕NGET filename 1
            result ← ∧/BatchSyntax content
        :Else
            result ← 0
        :EndTrap
    ∇

    ∇ report ← ValidationReport files
    ⍝ Complete validation report
        report ← ⎕NS ''
        report.files ← files
        report.results ← ValidateFile¨files
        report.pass_rate ← (+/report.results)÷≢files
        report.status ← (report.pass_rate=1)⊃'FAILED' 'PASSED'
    ∇

:EndNamespace
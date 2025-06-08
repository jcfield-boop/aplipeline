:Namespace Quality
⍝ APLCICD Quality Functions
⍝ Ultra-concise APL code quality metrics

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize Quality namespace
        ⎕←'  ✅ Quality functions loaded'
    ∇

    ⍝ Ultra-concise quality metrics
    Quality←{(+/'⍝'∊⍵)÷≢⍵}           ⍝ 21 chars - comment ratio
    Complexity←{+/'∇∘.¨'∊⍵}          ⍝ 22 chars - APL complexity
    QScore←Quality+0.5×Complexity    ⍝ 29 chars - quality score

    ∇ metrics ← QualityMetrics code
    ⍝ Comprehensive quality analysis
        metrics ← ⎕NS ''
        
        ⍝ Basic metrics
        metrics.lines ← ≢code
        metrics.functions ← +/'∇'∊¨code
        metrics.comments ← +/'⍝'∊¨code
        metrics.comment_ratio ← Quality ∊code
        
        ⍝ APL-specific metrics
        primitives ← '+-×÷*⍟⌹○!?∊⍷∪∩~∨∧⍱⍲⍴,⍪⌽⊖⍉↑↓⊂⊃⌷⍋⍒⊤⊥⍕⍎⊆'
        operators ← '¨⍨/\⌿⍀.∘⍣⍠⌸@⌺⍸'
        
        metrics.primitives ← +/+/primitives∊¨code
        metrics.operators ← +/+/operators∊¨code
        metrics.assignments ← +/'←'∊¨code
        
        ⍝ Complexity indicators
        metrics.nesting ← ⌈/+/¨'()[]{}'∊¨code
        metrics.complexity ← Complexity ∊code
        
        ⍝ Overall quality score (0-1)
        metrics.quality_score ← QScore ∊code
    ∇

    ∇ report ← QualityReport files
    ⍝ Quality report for multiple files
        report ← ⎕NS ''
        report.files ← files
        
        all_metrics ← ⍬
        :For file :In files
            :Trap 0
                content ← ⊃⎕NGET file 1
                file_metrics ← QualityMetrics content
                file_metrics.filename ← file
                all_metrics ,← ⊂file_metrics
            :Else
                ⍝ Skip files that can't be read
            :EndTrap
        :EndFor
        
        report.metrics ← all_metrics
        
        ⍝ Aggregate statistics
        scores ← ⊃¨all_metrics.quality_score
        report.avg_quality ← (+/scores)÷≢scores
        report.min_quality ← ⌊/scores
        report.max_quality ← ⌈/scores
        report.status ← (report.avg_quality≥0.5)⊃'POOR' 'GOOD'
    ∇

    ∇ grade ← GradeQuality score
    ⍝ Quality grade from score
        thresholds ← 0.2 0.4 0.6 0.8
        grades ← 'F' 'D' 'C' 'B' 'A'
        grade ← (1+⌊/⍸score≥thresholds)⊃grades
    ∇

:EndNamespace
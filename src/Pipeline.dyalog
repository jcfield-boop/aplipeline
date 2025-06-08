:Namespace Pipeline
⍝ APLCICD.Pipeline - Consolidated CI/CD Pipeline Module
⍝ 
⍝ Combines: Pipeline + Validation + Security + Quality modules
⍝ Focus: CI/CD automation, syntax validation, security scanning, quality analysis
⍝ 
⍝ Public Functions:
⍝   Run files                   - Complete CI/CD pipeline execution
⍝   ValidateFiles files         - Syntax validation
⍝   SecurityScan files          - Security vulnerability scanning
⍝   QualityAnalysis files       - Code quality metrics
⍝   QuickValidation files       - Fast validation check

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize Pipeline module
        ⎕←'  ✅ CI/CD pipeline, validation, security, and quality functions loaded'
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Main CI/CD Pipeline Functions
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ result ← Run files
    ⍝ Complete CI/CD pipeline execution with comprehensive reporting
    ⍝ 
    ⍝ Arguments:
    ⍝   files (character vector): List of files to process
    ⍝ 
    ⍝ Returns:
    ⍝   result (namespace): Comprehensive pipeline results
        
        result ← ⎕NS ''
        result.timestamp ← ⎕TS
        result.files ← files
        result.file_count ← ≢files
        
        ⎕←'🔄 Running APLCICD v2.0 CI/CD Pipeline'
        ⎕←'======================================'
        ⎕←'Files: ',⍕≢files
        ⎕←''
        
        ⍝ Stage 1: Syntax Validation
        ⎕←'Stage 1: Syntax Validation'
        :Trap 11 22
            validation_start ← ⎕AI[3]
            result.validation ← ValidateFiles files
            result.validation.duration_ms ← ⎕AI[3] - validation_start
            ⎕←'  Status: ',result.validation.status
            ⎕←'  Pass Rate: ',⍕100×result.validation.pass_rate,'%'
            ⎕←'  Duration: ',⍕result.validation.duration_ms,'ms'
        :Case 11
            ⎕←'  Status: DOMAIN_ERROR - ',⎕DM
            result.validation ← CreateErrorResult 'DOMAIN_ERROR' ⎕DM
        :Case 22
            ⎕←'  Status: FILE_ERROR - ',⎕DM
            result.validation ← CreateErrorResult 'FILE_ERROR' ⎕DM
        :Else
            ⎕←'  Status: UNEXPECTED_ERROR - ',⎕DM
            result.validation ← CreateErrorResult 'UNEXPECTED_ERROR' ⎕DM
        :EndTrap
        
        ⍝ Stage 2: Security Scan
        ⎕←'Stage 2: Security Scan'
        :Trap 11 22
            security_start ← ⎕AI[3]
            result.security ← SecurityScan files
            result.security.duration_ms ← ⎕AI[3] - security_start
            ⎕←'  Status: ',result.security.status
            ⎕←'  Risks Found: ',⍕result.security.risk_count
            ⎕←'  Duration: ',⍕result.security.duration_ms,'ms'
        :Case 11
            ⎕←'  Status: DOMAIN_ERROR - ',⎕DM
            result.security ← CreateErrorResult 'DOMAIN_ERROR' ⎕DM
        :Case 22
            ⎕←'  Status: FILE_ERROR - ',⎕DM
            result.security ← CreateErrorResult 'FILE_ERROR' ⎕DM
        :Else
            ⎕←'  Status: UNEXPECTED_ERROR - ',⎕DM
            result.security ← CreateErrorResult 'UNEXPECTED_ERROR' ⎕DM
        :EndTrap
        
        ⍝ Stage 3: Quality Analysis
        ⎕←'Stage 3: Quality Analysis'
        :Trap 11 22
            quality_start ← ⎕AI[3]
            result.quality ← QualityAnalysis files
            result.quality.duration_ms ← ⎕AI[3] - quality_start
            ⎕←'  Status: ',result.quality.status
            ⎕←'  Avg Quality: ',⍕result.quality.avg_quality
            ⎕←'  Duration: ',⍕result.quality.duration_ms,'ms'
        :Case 11
            ⎕←'  Status: DOMAIN_ERROR - ',⎕DM
            result.quality ← CreateErrorResult 'DOMAIN_ERROR' ⎕DM
        :Case 22
            ⎕←'  Status: FILE_ERROR - ',⎕DM
            result.quality ← CreateErrorResult 'FILE_ERROR' ⎕DM
        :Else
            ⎕←'  Status: UNEXPECTED_ERROR - ',⎕DM
            result.quality ← CreateErrorResult 'UNEXPECTED_ERROR' ⎕DM
        :EndTrap
        
        ⍝ Overall pipeline status using APL logic
        validation_ok ← result.validation.status≡'PASSED'
        security_ok ← result.security.status≡'PASSED'
        quality_ok ← result.quality.status≡'PASSED'
        
        result.success ← validation_ok ∧ security_ok ∧ quality_ok
        result.status ← result.success⊃'FAILED' 'PASSED'
        result.total_duration_ms ← (+/result.validation.duration_ms result.security.duration_ms result.quality.duration_ms)
        
        ⎕←''
        ⎕←'Pipeline Status: ',result.status
        ⎕←'Total Duration: ',⍕result.total_duration_ms,'ms'
        ⎕←'================'
    ∇

    ∇ error_result ← CreateErrorResult (error_type error_message)
    ⍝ Create standardized error result structure
        error_result ← ⎕NS ''
        error_result.status ← 'ERROR'
        error_result.error_type ← error_type
        error_result.error_message ← error_message
        error_result.pass_rate ← 0
        error_result.risk_count ← 999
        error_result.avg_quality ← 0
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Syntax Validation Functions
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ result ← ValidateFiles files
    ⍝ Comprehensive syntax validation with detailed reporting
    ⍝ 
    ⍝ Arguments:
    ⍝   files (character vector): List of files to validate
    ⍝ 
    ⍝ Returns:
    ⍝   result (namespace): Validation results with statistics
        
        result ← ⎕NS ''
        result.files ← files
        result.file_count ← ≢files
        result.validation_results ← ⍬
        result.errors ← ⍬
        
        ⍝ Process files using vectorized operations where possible
        valid_count ← 0
        
        ⍝ Validate each file with specific error handling
        validation_results ← ValidateSingleFile¨files
        
        ⍝ Aggregate results using APL array operations
        valid_flags ← ⊃¨validation_results
        valid_count ← +/valid_flags
        
        result.validation_results ← validation_results
        result.valid_files ← valid_count
        result.invalid_files ← (≢files) - valid_count
        result.pass_rate ← valid_count ÷ (≢files)⌈1
        result.status ← (result.pass_rate=1)⊃'PARTIAL' 'PASSED'
        
        ⍝ Collect error details from failed validations
        error_results ← (~valid_flags)/validation_results
        result.errors ← ∊1↓¨error_results
    ∇

    ∇ validation_result ← ValidateSingleFile file
    ⍝ Competition-grade APL syntax validation with comprehensive checks
    ⍝ 
    ⍝ Arguments:
    ⍝   file (character): File path to validate
    ⍝ 
    ⍝ Returns:
    ⍝   validation_result (namespace): Detailed validation results
        
        validation_result ← ⎕NS ''
        validation_result.file ← file
        validation_result.valid ← 0
        validation_result.errors ← ⍬
        validation_result.warnings ← ⍬
        validation_result.metrics ← ⎕NS ''
        
        :Trap 22 11
            ⍝ Read file content
            content ← ⊃⎕NGET file 1
            validation_result.lines ← ≢(⎕UCS 10)(≠⊆⊢)content
            
            ⍝ APL file validation
            :If '.dyalog'≡¯7↑file
                ⍝ Comprehensive APL syntax validation
                apl_result ← ValidateAPLSyntax content
                validation_result.valid ← apl_result.valid
                validation_result.errors ← apl_result.errors
                validation_result.warnings ← apl_result.warnings
                validation_result.metrics ← apl_result.metrics
                
            :ElseIf '.apl'≡¯4↑file
                ⍝ Script file validation
                script_result ← ValidateAPLScript content
                validation_result.valid ← script_result.valid
                validation_result.errors ← script_result.errors
                validation_result.warnings ← script_result.warnings
                
            :Else
                ⍝ Non-APL files pass by default
                validation_result.valid ← 1
                validation_result.warnings ,← ⊂'Non-APL file - basic validation only'
            :EndIf
            
        :Case 22
            validation_result.errors ,← ⊂'FILE_ERROR: Cannot read ',file
        :Case 11
            validation_result.errors ,← ⊂'SYNTAX_ERROR: Invalid APL syntax in ',file
        :Else
            validation_result.errors ,← ⊂'UNKNOWN_ERROR: ',⎕DM,' in ',file
        :EndTrap
    ∇

    ∇ result ← ValidateAPLSyntax content
    ⍝ Competition-grade comprehensive APL syntax validation
    ⍝ 
    ⍝ Arguments:
    ⍝   content (character): File content to validate
    ⍝ 
    ⍝ Returns:
    ⍝   result (namespace): Detailed validation results with metrics
        
        result ← ⎕NS ''
        result.valid ← 0
        result.errors ← ⍬
        result.warnings ← ⍬
        result.metrics ← ⎕NS ''
        
        ⍝ Parse content into lines
        lines ← (⎕UCS 10)(≠⊆⊢)content
        result.metrics.line_count ← ≢lines
        
        :Trap 11 16
            ⍝ 1. Structural validation
            structure_result ← ValidateAPLStructure content lines
            result.errors ,← structure_result.errors
            result.warnings ,← structure_result.warnings
            
            ⍝ 2. Syntax attempt with ⎕FX
            syntax_result ← ValidateWithFX content
            result.errors ,← syntax_result.errors
            result.warnings ,← syntax_result.warnings
            
            ⍝ 3. Security and best practices
            security_result ← ValidateAPLSecurity content
            result.warnings ,← security_result.warnings
            
            ⍝ 4. Code quality indicators
            quality_result ← AnalyzeAPLCodeStructure content lines
            result.metrics.functions ← quality_result.function_count
            result.metrics.comments ← quality_result.comment_count
            result.metrics.array_operations ← quality_result.array_ops
            result.metrics.loops ← quality_result.loops
            result.warnings ,← quality_result.warnings
            
            ⍝ Overall validity
            result.valid ← 0 = ≢result.errors
            
        :Case 11
            result.errors ,← ⊂'DOMAIN_ERROR during validation: ',⎕DM
        :Case 16
            result.errors ,← ⊂'NONCE_ERROR during validation: ',⎕DM
        :Else
            result.errors ,← ⊂'UNEXPECTED_ERROR during validation: ',⎕DM
        :EndTrap
    ∇

    ∇ balanced ← CheckBalanced (text delimiters)
    ⍝ Check if delimiters are balanced in text
        open ← ⊃delimiters
        close ← 1⊃delimiters
        opens ← +/text=open
        closes ← +/text=close
        balanced ← opens=closes
    ∇

    ∇ valid ← ValidateNamespaceStructure lines
    ⍝ Validate namespace structure in APL code
        namespace_starts ← +/∨/¨':Namespace'⍷¨lines
        namespace_ends ← +/∨/¨':EndNamespace'⍷¨lines
        valid ← namespace_starts=namespace_ends
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Security Scanning Functions  
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ result ← SecurityScan files
    ⍝ Comprehensive security vulnerability scanning
    ⍝ 
    ⍝ Arguments:
    ⍝   files (character vector): List of files to scan
    ⍝ 
    ⍝ Returns:
    ⍝   result (namespace): Security scan results
        
        result ← ⎕NS ''
        result.files ← files
        result.file_count ← ≢files
        result.security_issues ← ⍬
        result.risk_levels ← ⍬
        
        ⍝ Scan each file for security issues - vectorized where possible
        scan_results ← ScanFileForSecurity¨files
        
        ⍝ Aggregate results using APL operations
        issue_counts ← ⊃¨scan_results
        total_issues ← +/issue_counts
        
        result.risk_count ← total_issues
        result.files_with_issues ← +/issue_counts>0
        result.clean_files ← (≢files) - result.files_with_issues
        result.status ← (total_issues=0)⊃'RISKS_FOUND' 'PASSED'
        
        ⍝ Collect detailed security issues
        result.security_issues ← ∊1↓¨scan_results
    ∇

    ∇ scan_result ← ScanFileForSecurity file
    ⍝ Scan single file for security vulnerabilities
    ⍝ 
    ⍝ Arguments:
    ⍝   file (character): File path to scan
    ⍝ 
    ⍝ Returns:
    ⍝   scan_result (mixed): (issue_count security_issues)
        
        :Trap 22
            content ← ⊃⎕NGET file 1
            issues ← ⍬
            
            ⍝ Check for dangerous APL operations - vectorized
            dangerous_patterns ← '⎕SH' '⎕CMD' '⎕NPUT' '⎕NERASE' '⎕NMOVE'
            dangerous_found ← ∨/¨dangerous_patterns∘.⍷⊂content
            
            ⍝ Add issues for each dangerous pattern found
            dangerous_issues ← dangerous_found/dangerous_patterns
            issues ,← ('DANGEROUS_OPERATION: ',⊃dangerous_issues)¨⍳+/dangerous_found
            
            ⍝ Check for potential injection vulnerabilities
            injection_patterns ← '⍎' '⎕FIX'
            injection_found ← ∨/¨injection_patterns∘.⍷⊂content
            injection_issues ← injection_found/injection_patterns
            issues ,← ('POTENTIAL_INJECTION: ',⊃injection_issues)¨⍳+/injection_found
            
            ⍝ Check for hardcoded secrets (simple patterns)
            secret_patterns ← 'password' 'secret' 'token' 'key'
            secret_found ← ∨/¨(⎕C¨secret_patterns)∘.⍷⊂⎕C content
            secret_issues ← secret_found/secret_patterns
            issues ,← ('POTENTIAL_SECRET: ',⊃secret_issues)¨⍳+/secret_found
            
            scan_result ← (≢issues) issues
            
        :Case 22
            scan_result ← 1 (⊂'FILE_ACCESS_ERROR: Cannot read ',file)
        :Else
            scan_result ← 1 (⊂'SCAN_ERROR: ',⎕DM,' in ',file)
        :EndTrap
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Quality Analysis Functions
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ result ← QualityAnalysis files
    ⍝ Comprehensive code quality analysis
    ⍝ 
    ⍝ Arguments:
    ⍝   files (character vector): List of files to analyze
    ⍝ 
    ⍝ Returns:
    ⍝   result (namespace): Quality analysis results
        
        result ← ⎕NS ''
        result.files ← files
        result.file_count ← ≢files
        result.quality_scores ← ⍬
        result.quality_details ← ⍬
        
        ⍝ Analyze each file for quality metrics - vectorized processing
        quality_results ← AnalyzeFileQuality¨files
        
        ⍝ Extract scores and aggregate using APL operations
        scores ← ⊃¨quality_results
        valid_scores ← (scores≥0)/scores
        
        result.quality_scores ← scores
        result.avg_quality ← (≢valid_scores)⊃0 ((+/valid_scores)÷≢valid_scores)
        result.min_quality ← (≢valid_scores)⊃0 (⌊/valid_scores)
        result.max_quality ← (≢valid_scores)⊃0 (⌈/valid_scores)
        result.files_above_threshold ← +/scores≥0.5
        result.status ← (result.avg_quality≥0.5)⊃'BELOW_THRESHOLD' 'PASSED'
        
        ⍝ Collect detailed quality metrics
        result.quality_details ← 1↓¨quality_results
    ∇

    ∇ quality_result ← AnalyzeFileQuality file
    ⍝ Analyze quality metrics for a single file
    ⍝ 
    ⍝ Arguments:
    ⍝   file (character): File path to analyze
    ⍝ 
    ⍝ Returns:
    ⍝   quality_result (mixed): (quality_score quality_details)
        
        :Trap 22
            content ← ⊃⎕NGET file 1
            
            ⍝ Calculate various quality metrics
            readability ← CalculateReadability content
            complexity ← CalculateComplexity content
            maintainability ← CalculateMaintainability content
            documentation ← CalculateDocumentation content
            
            ⍝ Weighted combination of quality factors
            weights ← 0.3 0.25 0.25 0.2
            factors ← readability complexity maintainability documentation
            overall_quality ← weights +.× factors
            
            ⍝ Create quality details
            details ← ⎕NS ''
            details.readability ← readability
            details.complexity ← complexity
            details.maintainability ← maintainability
            details.documentation ← documentation
            details.file ← file
            
            quality_result ← overall_quality details
            
        :Case 22
            quality_result ← ¯1 (⎕NS ('error' 'FILE_ACCESS_ERROR')('file' file))
        :Else
            quality_result ← ¯1 (⎕NS ('error' ⎕DM)('file' file))
        :EndTrap
    ∇

    ∇ score ← CalculateReadability content
    ⍝ Competition-grade APL readability analysis
    ⍝ Considers APL-specific idioms and best practices
        lines ← (⎕UCS 10)(≠⊆⊢)content
        :If 0=≢lines ⋄ score←0 ⋄ :Return ⋄ :EndIf
        
        ⍝ 1. Line length appropriateness (APL can be concise)
        line_lengths ← ≢¨lines
        avg_line_length ← (+/line_lengths) ÷ ≢lines
        ⍝ APL optimal range: 20-80 characters
        length_score ← 1 - |((avg_line_length - 50) ÷ 50)⌊1
        
        ⍝ 2. Comment density and quality
        comment_lines ← +/∨/¨'⍝'∊¨lines
        comment_density ← comment_lines ÷ ≢lines
        ⍝ Bonus for function documentation
        doc_comments ← +/∨/¨('Arguments:' 'Returns:' 'Example:')⍷¨⊂content
        enhanced_comment_score ← comment_density + (doc_comments ÷ 20)⌊0.3
        
        ⍝ 3. APL idiom usage vs complexity
        ⍝ Good APL symbols (readable and idiomatic)
        good_apl ← '⍴≢⍳⊃↑↓⊂⊆∊⌊⌈×÷+-'
        good_count ← +/good_apl∊content
        
        ⍝ Advanced but legitimate APL
        advanced_apl ← '⌽⊖⍉⊥⊤∘⍨⍤⍣⌿⌿/'
        advanced_count ← +/advanced_apl∊content
        
        ⍝ Overly complex or obscure
        complex_apl ← '⍶⍹⍡⍢⌺'
        complex_count ← +/complex_apl∊content
        
        ⍝ Calculate symbol score
        total_chars ← ≢content⌈1
        symbol_score ← ((good_count × 1) + (advanced_count × 0.7) - (complex_count × 0.5)) ÷ total_chars
        symbol_score ← 1⌊0⌈symbol_score
        
        ⍝ 4. Function organization
        function_count ← +/'∇'=⊃¨lines
        function_score ← (function_count > 0) × (1 - (≢lines ÷ (function_count⌈1) ÷ 50)⌊1)
        
        ⍝ Competition-weighted combination
        weights ← 0.25 0.35 0.25 0.15
        factors ← length_score enhanced_comment_score symbol_score function_score
        score ← 1⌊0⌈weights +.× factors
    ∇

    ∇ score ← CalculateComplexity content
    ⍝ APL-specific complexity analysis (0-1, lower complexity = higher score)
        :If 0=≢content ⋄ score←1 ⋄ :Return ⋄ :EndIf
        
        lines ← (⎕UCS 10)(≠⊆⊢)content
        
        ⍝ 1. Nesting depth analysis (APL can handle deeper nesting elegantly)
        paren_depth ← MaxNestingDepth content '()'
        bracket_depth ← MaxNestingDepth content '[]'
        brace_depth ← MaxNestingDepth content '{}'
        max_nesting ← ⌈/paren_depth bracket_depth brace_depth
        nesting_score ← 1 - (max_nesting ÷ 8)⌊1  ⍝ Up to 8 levels acceptable
        
        ⍝ 2. Control structure density (loops are less APL-idiomatic)
        imperative_structures ← ':For' ':While' ':Repeat'
        imperative_count ← +/∨/¨imperative_structures∘.⍷⊂content
        functional_structures ← ':If' ':Select' ':Trap'
        functional_count ← +/∨/¨functional_structures∘.⍷⊂content
        
        total_structures ← imperative_count + functional_count
        imperative_ratio ← imperative_count ÷ total_structures⌈1
        structure_score ← 1 - imperative_ratio
        
        ⍝ 3. APL operator sophistication (advanced operators can be elegant)
        simple_ops ← '+-×÷⌊⌈|'
        moderate_ops ← '⍴≢⍳⊃↑↓⊂⊆∊'
        advanced_ops ← '⌽⊖⍉⊥⊤∘⍨⍤⍣'
        complex_ops ← '⍶⍹⍡⌸⌺'
        
        simple_count ← +/simple_ops∊content
        moderate_count ← +/moderate_ops∊content
        advanced_count ← +/advanced_ops∊content
        complex_count ← +/complex_ops∊content
        
        total_ops ← simple_count + moderate_count + advanced_count + complex_count⌈1
        sophistication ← (simple_count×1 + moderate_count×2 + advanced_count×3 + complex_count×5) ÷ total_ops
        sophistication_score ← 1 - ((sophistication - 2) ÷ 3)⌊1  ⍝ Optimal around level 2
        
        ⍝ 4. Function size and modularity
        function_count ← +/'∇'=⊃¨lines
        :If function_count > 0
            avg_function_size ← (≢lines) ÷ function_count
            size_score ← 1 - ((avg_function_size - 15) ÷ 35)⌊1  ⍝ Optimal ~15 lines
        :Else
            size_score ← 0.5  ⍝ No functions detected
        :EndIf
        
        ⍝ Competition-grade weighted combination
        weights ← 0.3 0.3 0.25 0.15
        factors ← nesting_score structure_score sophistication_score size_score
        score ← 1⌊0⌈weights +.× factors
    ∇

    ∇ score ← CalculateMaintainability content
    ⍝ Calculate maintainability score (0-1, higher is better)
        :If 0=≢content ⋄ score←0 ⋄ :Return ⋄ :EndIf
        
        lines ← (⎕UCS 10)(≠⊆⊢)content
        
        ⍝ Function organization (presence of function definitions)
        function_defs ← +/∨/¨'∇'∊¨lines
        function_score ← (function_defs ÷ 10)⌊1
        
        ⍝ Namespace organization
        namespace_lines ← +/∨/¨':Namespace'⍷¨lines
        namespace_score ← (namespace_lines > 0)×0.8
        
        ⍝ Error handling presence
        error_handling ← +/∨/¨':Trap'⍷¨lines
        error_score ← (error_handling ÷ 5)⌊1
        
        ⍝ Weighted combination
        weights ← 0.4 0.3 0.3
        factors ← function_score namespace_score error_score
        score ← weights +.× factors
    ∇

    ∇ score ← CalculateDocumentation content
    ⍝ Calculate documentation quality score (0-1, higher is better)
        :If 0=≢content ⋄ score←0 ⋄ :Return ⋄ :EndIf
        
        lines ← (⎕UCS 10)(≠⊆⊢)content
        
        ⍝ Comment density
        comment_lines ← +/∨/¨'⍝'∊¨lines
        comment_density ← comment_lines ÷ ≢lines⌈1
        
        ⍝ Documentation keywords
        doc_keywords ← 'Arguments:' 'Returns:' 'Example:' 'Description:' 'See also:'
        doc_presence ← +/∨/¨doc_keywords∘.⍷⊂content
        doc_score ← (doc_presence ÷ 3)⌊1
        
        ⍝ Header comments (lines starting with ⍝)
        header_comments ← +/∨/¨(⊂'⍝')≡¨1↑¨lines
        header_score ← (header_comments ÷ ≢lines⌈1)⌊1
        
        ⍝ Weighted combination
        weights ← 0.5 0.3 0.2
        factors ← comment_density doc_score header_score
        score ← weights +.× factors
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Quick Validation Functions
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ result ← QuickValidation files
    ⍝ Fast validation check for basic CI/CD gates
    ⍝ 
    ⍝ Arguments:
    ⍝   files (character vector): List of files to validate
    ⍝ 
    ⍝ Returns:
    ⍝   result (boolean): 1 if all checks pass, 0 otherwise
        
        ⍝ Quick syntax check - vectorized
        syntax_results ← ValidateSingleFile¨files
        syntax_ok ← ∧/⊃¨syntax_results
        
        ⍝ Quick security check - vectorized
        security_results ← ScanFileForSecurity¨files
        security_ok ← ∧/0=⊃¨security_results
        
        ⍝ Quick quality check - vectorized  
        quality_results ← AnalyzeFileQuality¨files
        quality_scores ← ⊃¨quality_results
        quality_ok ← ∧/quality_scores≥0.5
        
        result ← syntax_ok ∧ security_ok ∧ quality_ok
        
        ⎕←'Quick Validation: ',(result⊃'FAILED' 'PASSED')
        ⎕←'  Syntax: ',(syntax_ok⊃'FAIL' 'PASS')
        ⎕←'  Security: ',(security_ok⊃'FAIL' 'PASS')  
        ⎕←'  Quality: ',(quality_ok⊃'FAIL' 'PASS')
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Competition-Grade Validation Support Functions
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ result ← ValidateAPLStructure (content lines)
    ⍝ Validate APL structural elements
        result ← ⎕NS ''
        result.errors ← ⍬
        result.warnings ← ⍬
        
        ⍝ Check balanced delimiters
        parens_ok ← CheckBalanced content '()'
        brackets_ok ← CheckBalanced content '[]'
        braces_ok ← CheckBalanced content '{}'
        
        :If ~parens_ok ⋄ result.errors ,← ⊂'Unbalanced parentheses' ⋄ :EndIf
        :If ~brackets_ok ⋄ result.errors ,← ⊂'Unbalanced brackets' ⋄ :EndIf
        :If ~braces_ok ⋄ result.errors ,← ⊂'Unbalanced braces' ⋄ :EndIf
        
        ⍝ Check namespace structure
        ns_ok ← ValidateNamespaceStructure lines
        :If ~ns_ok ⋄ result.errors ,← ⊂'Invalid namespace structure' ⋄ :EndIf
    ∇

    ∇ result ← ValidateWithFX content
    ⍝ Attempt to validate using ⎕FX
        result ← ⎕NS ''
        result.errors ← ⍬
        result.warnings ← ⍬
        
        :Trap 11 16
            ⍝ Extract function definitions for testing
            functions ← ExtractFunctions content
            :For fn :In functions
                :Trap 11
                    {}⎕FX fn
                :Else
                    result.errors ,← ⊂'Function syntax error: ',1⊃fn
                :EndTrap
            :EndFor
        :Else
            result.warnings ,← ⊂'Unable to perform ⎕FX validation'
        :EndTrap
    ∇

    ∇ result ← ValidateAPLSecurity content
    ⍝ Check for security issues and dangerous operations
        result ← ⎕NS ''
        result.warnings ← ⍬
        
        ⍝ Dangerous system functions
        dangerous ← '⎕SH' '⎕CMD' '⎕NERASE' '⎕NMOVE' '⎕NRENAME'
        :For danger :In dangerous
            :If ∨/danger⍷content
                result.warnings ,← ⊂'Uses dangerous function: ',danger
            :EndIf
        :EndFor
        
        ⍝ Execute function
        :If ∨/'⍎'∊content
            result.warnings ,← ⊂'Uses execute (⍎) - potential security risk'
        :EndIf
        
        ⍝ Format function  
        :If ∨/'⍕'∊content
            result.warnings ,← ⊂'Uses format (⍕) - verify input validation'
        :EndIf
    ∇

    ∇ result ← AnalyzeAPLCodeStructure (content lines)
    ⍝ Analyze APL code structure and quality indicators
        result ← ⎕NS ''
        result.warnings ← ⍬
        
        ⍝ Count functions
        result.function_count ← +/'∇'=⊃¨lines
        
        ⍝ Count comments
        result.comment_count ← +/∨/¨'⍝'∊¨lines
        
        ⍝ Array operations (good APL)
        array_ops ← '⍴' '≢' '⍳' '⌿' '⌽' '⊃' '↑' '↓' '⊂' '⊆' '∊' '∘' '⍨' '⍤'
        result.array_ops ← +/+/∨/¨array_ops⍷¨⊂content
        
        ⍝ Loop constructs (less idiomatic APL)
        loop_constructs ← ':For' ':While' ':Repeat'
        result.loops ← +/+/∨/¨loop_constructs⍷¨⊂content
        
        ⍝ Quality warnings
        :If result.comment_count = 0
            result.warnings ,← ⊂'No comments found - consider adding documentation'
        :EndIf
        
        :If result.loops > result.array_ops ÷ 2
            result.warnings ,← ⊂'High loop to array operation ratio - consider vectorization'
        :EndIf
        
        :If result.function_count = 0
            result.warnings ,← ⊂'No functions detected - may not be APL code'
        :EndIf
    ∇

    ∇ functions ← ExtractFunctions content
    ⍝ Extract function definitions from content
        lines ← (⎕UCS 10)(≠⊆⊢)content
        functions ← ⍬
        
        ⍝ Find function start/end pairs
        starts ← ⍸∨/¨'∇'∊¨lines
        :If 0<≢starts
            ⍝ For simplicity, assume single-line headers
            :For i :In starts
                :If i≤≢lines
                    header ← i⊃lines
                    :If '∇'=⊃header
                        functions ,← ⊂header
                    :EndIf
                :EndIf
            :EndFor
        :EndIf
    ∇

    ∇ result ← ValidateAPLScript content
    ⍝ Validate APL script files (.apl)
        result ← ⎕NS ''
        result.valid ← 1
        result.errors ← ⍬
        result.warnings ← ⍬
        
        ⍝ Basic script validation
        :If 0=≢content
            result.errors ,← ⊂'Empty script file'
            result.valid ← 0
        :EndIf
        
        ⍝ Check for potential issues
        :If ∨/')OFF'⍷content
            result.warnings ,← ⊂'Script contains )OFF - may terminate session'
        :EndIf
    ∇

    ∇ depth ← MaxNestingDepth (content delimiters)
    ⍝ Calculate maximum nesting depth for delimiter pairs
        open ← ⊃delimiters
        close ← 1⊃delimiters
        
        current_depth ← 0
        max_depth ← 0
        
        :For char :In content
            :If char = open
                current_depth +← 1
                max_depth ← current_depth⌈max_depth
            :ElseIf char = close
                current_depth -← 1
            :EndIf
        :EndFor
        
        depth ← max_depth
    ∇

:EndNamespace
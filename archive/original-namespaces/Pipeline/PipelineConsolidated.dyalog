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
    ⍝ Validate syntax of a single APL file
    ⍝ 
    ⍝ Arguments:
    ⍝   file (character): File path to validate
    ⍝ 
    ⍝ Returns:
    ⍝   validation_result (mixed): (success_flag error_message)
        
        :Trap 22 11
            ⍝ Read file content
            content ← ⊃⎕NGET file 1
            
            ⍝ Simple syntax validation for APL files
            :If '.dyalog'≡¯7↑file
                ⍝ Check for basic APL syntax issues
                syntax_ok ← ValidateAPLSyntax content
                validation_result ← syntax_ok ''
            :Else
                ⍝ Non-APL files pass by default
                validation_result ← 1 ''
            :EndIf
            
        :Case 22
            validation_result ← 0 ('FILE_ERROR: Cannot read ',file)
        :Case 11
            validation_result ← 0 ('SYNTAX_ERROR: Invalid APL syntax in ',file)
        :Else
            validation_result ← 0 ('UNKNOWN_ERROR: ',⎕DM,' in ',file)
        :EndTrap
    ∇

    ∇ is_valid ← ValidateAPLSyntax content
    ⍝ Basic APL syntax validation
    ⍝ 
    ⍝ Arguments:
    ⍝   content (character): File content to validate
    ⍝ 
    ⍝ Returns:
    ⍝   is_valid (boolean): 1 if syntax appears valid, 0 otherwise
        
        ⍝ Basic checks for APL syntax
        lines ← (⎕UCS 10)(≠⊆⊢)content
        
        ⍝ Check for balanced parentheses, brackets, etc.
        parens_balanced ← CheckBalanced content '()'
        brackets_balanced ← CheckBalanced content '[]'
        braces_balanced ← CheckBalanced content '{}'
        
        ⍝ Check for proper namespace structure if present
        namespace_ok ← ValidateNamespaceStructure lines
        
        is_valid ← parens_balanced ∧ brackets_balanced ∧ braces_balanced ∧ namespace_ok
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
    ⍝ Calculate readability score (0-1, higher is better)
        lines ← (⎕UCS 10)(≠⊆⊢)content
        :If 0=≢lines ⋄ score←0 ⋄ :Return ⋄ :EndIf
        
        ⍝ Average line length (shorter lines are more readable)
        avg_line_length ← (+/≢¨lines) ÷ ≢lines
        length_score ← 1 - (avg_line_length ÷ 100)⌊1
        
        ⍝ Comment density (more comments = more readable)
        comment_lines ← +/∨/¨'⍝'∊¨lines
        comment_density ← comment_lines ÷ ≢lines
        
        ⍝ Complexity indicators (fewer complex symbols = more readable)
        complex_symbols ← '⌽⊖⍉∊⊥⊤∇⍺⍵⍶⍹⍨⍤⍣⍡'
        complexity_density ← (+/complex_symbols∊content) ÷ ≢content⌈1
        complexity_score ← 1 - complexity_density⌊1
        
        ⍝ Weighted combination
        weights ← 0.4 0.3 0.3
        factors ← length_score comment_density complexity_score
        score ← weights +.× factors
    ∇

    ∇ score ← CalculateComplexity content
    ⍝ Calculate complexity score (0-1, lower complexity = higher score)
        :If 0=≢content ⋄ score←1 ⋄ :Return ⋄ :EndIf
        
        ⍝ Nesting depth (count nested structures)
        nesting_chars ← '()[]{}⍺⍵∇⎕'
        nesting_density ← (+/nesting_chars∊content) ÷ ≢content
        
        ⍝ Control structure complexity
        control_structures ← ':If' ':For' ':While' ':Select' ':Trap'
        control_count ← +/∨/¨control_structures∘.⍷⊂content
        control_density ← control_count ÷ 20  ⍝ Normalize
        
        ⍝ APL operator complexity
        complex_operators ← '∘⌸∘.⍨⍤⍣'
        operator_density ← (+/complex_operators∊content) ÷ ≢content⌈1
        
        ⍝ Inverse scoring (lower complexity = higher score)
        weights ← 0.4 0.3 0.3
        complexities ← nesting_density control_density operator_density
        score ← 1 - (weights +.× complexities)⌊1
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

:EndNamespace
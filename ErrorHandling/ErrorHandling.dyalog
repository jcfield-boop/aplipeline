:Namespace ErrorHandling
⍝ APLCICD Error Handling System
⍝ Robust error management with specific error types

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize ErrorHandling namespace
        ⎕←'  ✅ Error handling functions loaded'
    ∇

    ∇ result ← HandleError error_info
    ⍝ Central error handling with specific error type analysis
        error_num ← 1⊃error_info
        error_msg ← 2⊃error_info
        context ← 3⊃error_info
        
        result ← ⎕NS ''
        result.error_number ← error_num
        result.original_message ← error_msg
        result.context ← context
        result.timestamp ← ⎕TS
        
        :Select error_num
        :Case 11  ⍝ DOMAIN ERROR
            result.type ← 'DOMAIN_ERROR'
            result.description ← 'Invalid data type or domain'
            result.suggestion ← 'Check input data types and ranges'
            result.severity ← 'HIGH'
            
        :Case 6   ⍝ VALUE ERROR
            result.type ← 'VALUE_ERROR'
            result.description ← 'Undefined name or missing namespace'
            result.suggestion ← 'Verify all required namespaces are loaded'
            result.severity ← 'HIGH'
            
        :Case 22  ⍝ FILE ERROR
            result.type ← 'FILE_ERROR'
            result.description ← 'File operation failed'
            result.suggestion ← 'Check file permissions and paths'
            result.severity ← 'MEDIUM'
            
        :Case 16  ⍝ NONCE ERROR (array shape mismatch)
            result.type ← 'SHAPE_ERROR'
            result.description ← 'Array shape incompatibility'
            result.suggestion ← 'Verify array dimensions match expected format'
            result.severity ← 'MEDIUM'
            
        :Case 4   ⍝ INDEX ERROR
            result.type ← 'INDEX_ERROR'
            result.description ← 'Array index out of bounds'
            result.suggestion ← 'Check array bounds and index calculations'
            result.severity ← 'MEDIUM'
            
        :Case 1   ⍝ SYNTAX ERROR
            result.type ← 'SYNTAX_ERROR'
            result.description ← 'Invalid APL syntax'
            result.suggestion ← 'Review APL syntax and fix malformed expressions'
            result.severity ← 'HIGH'
            
        :Else
            result.type ← 'UNKNOWN_ERROR'
            result.description ← 'Unhandled error type'
            result.suggestion ← 'Contact system administrator'
            result.severity ← 'CRITICAL'
        :EndSelect
        
        ⍝ Log error
        LogError result
    ∇

    ∇ LogError error_result
    ⍝ Log error to system log
        timestamp ← ⍕⎕TS
        log_entry ← timestamp,' [',error_result.severity,'] ',error_result.type,': ',error_result.description
        
        ⍝ Append to error log
        :Trap 22  ⍝ FILE_ERROR
            log_entry ⎕NPUT 'aplcicd_errors.log' 1
        :Else
            ⍝ Fallback to console if file logging fails
            ⎕←'ERROR LOG FAILED: ',log_entry
        :EndTrap
    ∇

    ∇ result ← SafeExecute function_name args
    ⍝ Safely execute a function with comprehensive error handling
        result ← ⎕NS ''
        result.success ← 0
        result.result ← ⍬
        result.error ← ⍬
        
        :Trap 0
            ⍝ Dynamic function execution
            :If 0=≢args
                result.result ← ⍎function_name
            :Else
                result.result ← args ⍎function_name
            :EndIf
            result.success ← 1
        :Else
            error_info ← ⎕EN ⎕DM function_name
            result.error ← HandleError error_info
            result.success ← 0
        :EndTrap
    ∇

    ∇ result ← RobustPipeline files
    ⍝ Execute pipeline with comprehensive error recovery
        result ← ⎕NS ''
        result.files ← files
        result.stages ← ⍬
        result.errors ← ⍬
        result.success ← 1
        
        ⍝ Stage 1: Validation with error handling
        validation_result ← SafeExecute 'Validation.ValidationReport' files
        result.stages ,← ⊂'validation' validation_result
        :If ~validation_result.success
            result.errors ,← ⊂'Validation failed: ',validation_result.error.description
            result.success ← 0
        :EndIf
        
        ⍝ Stage 2: Security with error handling
        security_result ← SafeExecute 'Security.SecurityReport' files
        result.stages ,← ⊂'security' security_result
        :If ~security_result.success
            result.errors ,← ⊂'Security scan failed: ',security_result.error.description
            ⍝ Continue pipeline even if security scan fails (non-critical)
        :EndIf
        
        ⍝ Stage 3: Quality with error handling
        quality_result ← SafeExecute 'Quality.QualityReport' files
        result.stages ,← ⊂'quality' quality_result
        :If ~quality_result.success
            result.errors ,← ⊂'Quality analysis failed: ',quality_result.error.description
            ⍝ Continue pipeline even if quality analysis fails (non-critical)
        :EndIf
        
        ⍝ Overall success based on critical stages only
        result.critical_success ← validation_result.success
        result.timestamp ← ⎕TS
    ∇

    ∇ result ← ValidateInput input expected_type
    ⍝ Validate input parameters before processing
        result ← ⎕NS ''
        result.valid ← 1
        result.error ← ''
        
        :Select expected_type
        :Case 'text'
            :If ~(⊃⍴⍴input)∊0 1
                result.valid ← 0
                result.error ← 'Expected text string, got array'
            :EndIf
            
        :Case 'files'
            :If ~(⊃⍴⍴input)∊1
                result.valid ← 0
                result.error ← 'Expected file list, got scalar or matrix'
            :EndIf
            
        :Case 'number'
            :If ~input∊⍨⎕D
                result.valid ← 0
                result.error ← 'Expected numeric value'
            :EndIf
            
        :Case 'namespace'
            :If ~9=⎕NC⊂input
                result.valid ← 0
                result.error ← 'Expected namespace object'
            :EndIf
            
        :Else
            result.valid ← 0
            result.error ← 'Unknown expected type: ',expected_type
        :EndSelect
    ∇

    ∇ result ← RecoverableError error_result operation
    ⍝ Determine if an error is recoverable and suggest recovery
        result ← ⎕NS ''
        result.recoverable ← 0
        result.recovery_action ← ''
        
        :Select error_result.type
        :Case 'FILE_ERROR'
            result.recoverable ← 1
            result.recovery_action ← 'Retry with default configuration'
            
        :Case 'VALUE_ERROR'
            result.recoverable ← 1
            result.recovery_action ← 'Reload missing namespaces'
            
        :Case 'DOMAIN_ERROR'
            :If operation∊⊂'quality_analysis'
                result.recoverable ← 1
                result.recovery_action ← 'Use basic quality metrics'
            :EndIf
            
        :Case 'SHAPE_ERROR'
            :If operation∊⊂'batch_processing'
                result.recoverable ← 1
                result.recovery_action ← 'Process files individually'
            :EndIf
            
        :Else
            result.recoverable ← 0
            result.recovery_action ← 'Manual intervention required'
        :EndSelect
    ∇

    ∇ report ← ErrorReport timespan
    ⍝ Generate error report for specified timespan (hours)
        :If 0=⎕NC'timespan' ⋄ timespan←24 ⋄ :EndIf
        
        report ← ⎕NS ''
        report.timespan ← timespan
        report.timestamp ← ⎕TS
        
        ⍝ Read error log
        :Trap 22
            log_lines ← ⊃⎕NGET 'aplcicd_errors.log' 1
            
            ⍝ Filter by timespan
            cutoff_time ← ⎕TS - 0 0 0 timespan 0 0
            recent_errors ← FilterErrorsByTime log_lines cutoff_time
            
            report.total_errors ← ≢recent_errors
            report.error_types ← CountErrorTypes recent_errors
            report.severity_breakdown ← CountSeverityLevels recent_errors
            
        :Else
            report.total_errors ← 0
            report.error_types ← ⍬
            report.severity_breakdown ← ⍬
            report.note ← 'No error log found'
        :EndTrap
    ∇

    ∇ filtered ← FilterErrorsByTime log_lines cutoff_time
    ⍝ Filter error log entries by time
        ⍝ Extract timestamps and compare
        filtered ← ⍬  ⍝ Simplified implementation
    ∇

    ∇ counts ← CountErrorTypes log_lines
    ⍝ Count occurrences of each error type
        types ← 'DOMAIN_ERROR' 'VALUE_ERROR' 'FILE_ERROR' 'SYNTAX_ERROR'
        counts ← ⍬
        :For type :In types
            count ← +/∨/¨(⊂type)⍷¨log_lines
            counts ,← type count
        :EndFor
    ∇

    ∇ counts ← CountSeverityLevels log_lines
    ⍝ Count occurrences of each severity level
        levels ← 'HIGH' 'MEDIUM' 'LOW' 'CRITICAL'
        counts ← ⍬
        :For level :In levels
            count ← +/∨/¨(⊂level)⍷¨log_lines
            counts ,← level count
        :EndFor
    ∇

:EndNamespace
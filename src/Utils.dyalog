:Namespace Utils
⍝ APLCICD.Utils - Shared Utility Functions
⍝ 
⍝ Consolidates commonly used functions across modules
⍝ Reduces code duplication and improves maintainability
⍝ 
⍝ Public Functions:
⍝   CalculateExecutionTime start_time    - Standard timing calculation
⍝   ValidateNumericRange value min max   - Numeric validation
⍝   SafeFileAccess filepath              - Secure file operations
⍝   FormatTimestamp timestamp            - Consistent time formatting

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize utility functions module
        ⎕←'  🔧 Shared utility functions loaded'
    ∇

    ∇ duration ← CalculateExecutionTime start_time
    ⍝ Standard execution time calculation used across all modules
    ⍝ 
    ⍝ Arguments:
    ⍝   start_time (timestamp): Start time from ⎕TS
    ⍝ 
    ⍝ Returns:
    ⍝   duration (numeric): Duration in milliseconds
        end_time ← ⎕TS
        duration ← 24 60 60 1000⊥end_time[3 4 5 6] - start_time[3 4 5 6]
    ∇

    ∇ valid ← value ValidateNumericRange (min max)
    ⍝ Validate numeric value is within specified range
    ⍝ 
    ⍝ Arguments:
    ⍝   value (numeric): Value to validate
    ⍝   min (numeric): Minimum allowed value
    ⍝   max (numeric): Maximum allowed value
    ⍝ 
    ⍝ Returns:
    ⍝   valid (boolean): 1 if valid, 0 if invalid
        valid ← (min ≤ value) ∧ (value ≤ max)
    ∇

    ∇ result ← SafeFileAccess filepath
    ⍝ Safe file access with comprehensive error handling
    ⍝ 
    ⍝ Arguments:
    ⍝   filepath (character): Path to file
    ⍝ 
    ⍝ Returns:
    ⍝   result (namespace): Contains success flag and content or error
        result ← ⎕NS ''
        result.success ← 0
        result.content ← ''
        result.error ← ''
        
        :Trap 22 11
            ⍝ Basic security checks
            :If 0=≢filepath
                result.error ← 'Empty filepath provided'
                →0
            :EndIf
            
            ⍝ Check for path traversal
            :If ∨/'..'⍷filepath
                result.error ← 'Path traversal detected'
                →0
            :EndIf
            
            ⍝ Check file exists
            :If ~⎕NEXISTS filepath
                result.error ← 'File does not exist'
                →0
            :EndIf
            
            ⍝ Read file
            result.content ← ⊃⎕NGET filepath 1
            result.success ← 1
            
        :Case 22
            result.error ← 'File access error'
        :Case 11
            result.error ← 'Domain error in file processing'
        :Else
            result.error ← 'Unexpected error: ',⎕DM
        :EndTrap
    ∇

    ∇ formatted ← FormatTimestamp timestamp
    ⍝ Format timestamp consistently across modules
    ⍝ 
    ⍝ Arguments:
    ⍝   timestamp (numeric vector): ⎕TS format timestamp
    ⍝ 
    ⍝ Returns:
    ⍝   formatted (character): Human-readable timestamp
        :If 0=≢timestamp
            formatted ← 'Invalid timestamp'
            →0
        :EndIf
        
        :Trap 11
            year month day hour min sec ← 6↑timestamp
            formatted ← (⍕year),'-',(2⍕month),'-',(2⍕day),' ',(2⍕hour),':',(2⍕min),':',(2⍕sec)
        :Else
            formatted ← 'Timestamp format error'
        :EndTrap
    ∇

    ∇ result ← ValidateAPLIdentifier name
    ⍝ Validate APL identifier naming conventions
    ⍝ 
    ⍝ Arguments:
    ⍝   name (character): Proposed identifier name
    ⍝ 
    ⍝ Returns:
    ⍝   result (namespace): Contains valid flag and error message
        result ← ⎕NS ''
        result.valid ← 0
        result.error ← ''
        
        :If 0=≢name
            result.error ← 'Empty identifier'
            →0
        :EndIf
        
        ⍝ Check first character is alphabetic
        :If ~(⊃name)∊⎕A,⎕C
            result.error ← 'Identifier must start with letter'
            →0
        :EndIf
        
        ⍝ Check remaining characters are alphanumeric or underscore
        valid_chars ← ⎕A,⎕C,⎕D,'_'
        :If ~∧/name∊valid_chars
            result.error ← 'Identifier contains invalid characters'
            →0
        :EndIf
        
        ⍝ Check length is reasonable
        :If 50<≢name
            result.error ← 'Identifier too long (max 50 characters)'
            →0
        :EndIf
        
        result.valid ← 1
    ∇

    ∇ stats ← CalculateBasicStats values
    ⍝ Calculate basic statistics for numeric arrays
    ⍝ 
    ⍝ Arguments:
    ⍝   values (numeric vector): Values to analyze
    ⍝ 
    ⍝ Returns:
    ⍝   stats (namespace): Contains mean, min, max, count
        stats ← ⎕NS ''
        
        :If 0=≢values
            stats.count ← 0
            stats.mean ← 0
            stats.min ← 0
            stats.max ← 0
            →0
        :EndIf
        
        :Trap 11
            stats.count ← ≢values
            stats.mean ← (+/values)÷≢values
            stats.min ← ⌊/values
            stats.max ← ⌈/values
            stats.sum ← +/values
        :Else
            ⍝ Default values on error
            stats.count ← ≢values
            stats.mean ← 0
            stats.min ← 0
            stats.max ← 0
            stats.sum ← 0
        :EndTrap
    ∇

:EndNamespace
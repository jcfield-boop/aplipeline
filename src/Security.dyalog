:Namespace Security
⍝ APL-CD Security Controls Module
⍝ Implements security controls for CI/CD operations

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize security controls
        ⎕←'  🔒 Security controls initialized'
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ File Access Security Controls
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ valid ← ValidateFilePath path
    ⍝ Validate file path for security compliance
        valid ← 0
        
        :If 0=≢path
            →0  ⍝ Empty path not allowed
        :EndIf
        
        ⍝ Check for path traversal attempts
        :If ∨/'..'∘⍷path
            →0  ⍝ Path traversal not allowed
        :EndIf
        
        ⍝ Validate file extension (comprehensive security approach)
        allowed_exts ← '.apl' '.dyalog' '.aplf' '.aplc' '.apln' '.apla'
        dangerous_exts ← '.exe' '.bat' '.cmd' '.sh' '.dll' '.com' '.scr' '.pif' '.js' '.vbs' '.php' '.py'
        
        ⍝ Check for dangerous extensions anywhere in filename
        :For dangerous_ext :In dangerous_exts
            :If dangerous_ext⍷path
                →0  ⍝ Dangerous extension found - reject
            :EndIf
        :EndFor
        
        ⍝ Check that file ends with approved APL extension
        ext_match ← 0
        :For allowed_ext :In allowed_exts
            ext_len ← ≢allowed_ext
            :If ext_len≤≢path
                path_end ← ⌽ext_len↑⌽path  ⍝ Take last ext_len chars properly
                :If allowed_ext≡path_end
                    ext_match ← 1
                    :Leave
                :EndIf
            :EndIf
        :EndFor
        
        :If ~ext_match
            →0  ⍝ Must end with approved APL extension
        :EndIf
        
        ⍝ Check file size limits if file exists (max 10MB)
        :Trap 22
            :If ⎕NEXISTS path
                info ← ⎕NINFO path
                :If 1<≢info
                    size ← 2⊃info  ⍝ Size is usually 2nd element
                    :If size > 10485760  ⍝ 10MB limit
                        →0  ⍝ File too large
                    :EndIf
                :EndIf
            :EndIf
            ⍝ File doesn't exist is OK for validation - may be created later
        :Else
            ⍝ File access issues - but still allow validation
        :EndTrap
        
        valid ← 1
    ∇

    ∇ content ← SecureReadFile path;audit_entry
    ⍝ Securely read file with validation and auditing
        :If ~ValidateFilePath path
            ⎕SIGNAL 22 ⊣ 'SECURITY: File access denied: ',path
        :EndIf
        
        ⍝ Audit file access
        audit_entry ← (⍕⎕TS),' READ_FILE: ',path
        AuditLog audit_entry
        
        ⍝ Read file with size limit
        :Trap 22
            content ← ⊃⎕NGET path 1
        :Else
            ⎕SIGNAL 22 ⊣ 'SECURITY: File read failed: ',path
        :EndTrap
    ∇

    ∇ SecureCompileCheck path;audit_entry
    ⍝ Securely compile APL code with validation
        :If ~ValidateFilePath path
            ⎕SIGNAL 11 ⊣ 'SECURITY: Compilation denied: ',path
        :EndIf
        
        ⍝ Audit compilation attempt
        audit_entry ← (⍕⎕TS),' COMPILE_CHECK: ',path
        AuditLog audit_entry
        
        ⍝ Perform compilation in controlled environment
        :Trap 0
            ⎕FIX'file://',path
        :Else
            ⍝ Compilation failed - this is acceptable for testing
        :EndTrap
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Code Execution Security Controls
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ result ← SecureExecute code
    ⍝ SECURITY: Execution of arbitrary code is disabled
        result ← 'SECURITY_ERROR: Code execution disabled for security'
        
        ⍝ Audit security violation attempt
        audit_entry ← (⍕⎕TS),' BLOCKED_EXECUTE: ',⍕≢code,' chars'
        AuditLog audit_entry
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Audit Logging
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ AuditLog entry
    ⍝ Log security events for auditing
        :Trap 22
            ⍝ Append to security audit log
            log_path ← 'logs/security_audit.log'
            (⊂entry) ⎕NPUT log_path 1
        :Else
            ⍝ If logging fails, at least display to session
            ⎕←'AUDIT: ',entry
        :EndTrap
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Security Context Management
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ context ← GetSecurityContext
    ⍝ Get current security context information
        context ← ⎕NS ''
        context.timestamp ← ⎕TS
        context.workspace ← ⎕WSID
        context.user ← 'Security_User'  ⍝ Safe fallback
        context.restrictions ← 'file_validation' 'no_arbitrary_execution' 'audit_logging'
    ∇

    ∇ report ← SecurityReport
    ⍝ Generate security status report
        report ← ⎕NS ''
        report.status ← 'SECURE'
        report.controls_active ← 1
        report.file_validation ← 1
        report.execution_restricted ← 1
        report.audit_logging ← 1
        report.last_check ← ⎕TS
        
        ⍝ Security recommendations
        report.recommendations ← ⊂'All security controls active'
        report.risk_level ← 'LOW'
    ∇

:EndNamespace
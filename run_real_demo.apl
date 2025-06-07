#!/usr/bin/env dyalog
⍝ Real APL Demo Execution Script
⍝ This script runs real APLCICD functions and outputs JSON for web consumption

⍝ Initialize system
⎕FIX'file://APLCICD.dyalog'
APLCICD.Initialize

⍝ Get current directory files
files ← '*.dyalog' ⎕NINFO ⍠1⊢'.'

∇ RunPipelineDemo
⍝ Execute real pipeline and format output
    ⎕←'{"demo":"pipeline","status":"running"}'
    
    :Trap 0
        result ← Pipeline.RunPipeline files
        
        ⎕←'{'
        ⎕←'"demo":"pipeline",'
        ⎕←'"status":"',result.status,'",'
        ⎕←'"files_count":',⍕≢files,','
        ⎕←'"validation_status":"',result.validation.status,'",'
        ⎕←'"validation_pass_rate":',⍕⌊0.5+100×result.validation.pass_rate,','
        ⎕←'"security_status":"',result.security.status,'",'
        ⎕←'"security_risks":',⍕result.security.risk_count,','
        ⎕←'"quality_status":"',result.quality.status,'",'
        ⎕←'"quality_avg":',⍕⌊0.5+100×result.quality.avg_quality,','
        ⎕←'"performance_time":',⍕⌊0.5+1000×result.performance
        ⎕←'}'
    :Else
        ⎕←'{"demo":"pipeline","status":"error","message":"',⎕DM,'"}'
    :EndTrap
∇

∇ RunValidationDemo
⍝ Execute real validation
    :Trap 0
        result ← Validation.ValidationReport files
        
        ⎕←'{'
        ⎕←'"demo":"validation",'
        ⎕←'"files_count":',⍕≢files,','
        ⎕←'"status":"',result.status,'",'
        ⎕←'"pass_rate":',⍕⌊0.5+100×result.pass_rate,','
        ⎕←'"failed_files":',⍕≢result.failed_files
        ⎕←'}'
    :Else
        ⎕←'{"demo":"validation","status":"error","message":"',⎕DM,'"}'
    :EndTrap
∇

∇ RunSecurityDemo
⍝ Execute real security scan
    :Trap 0
        result ← Security.SecurityReport files
        
        ⎕←'{'
        ⎕←'"demo":"security",'
        ⎕←'"files_count":',⍕≢files,','
        ⎕←'"status":"',result.status,'",'
        ⎕←'"total_risks":',⍕result.total_risks,','
        ⎕←'"high_risks":',⍕+/result.risk_levels≡¨⊂'HIGH'
        ⎕←'}'
    :Else
        ⎕←'{"demo":"security","status":"error","message":"',⎕DM,'"}'
    :EndTrap
∇

∇ RunQualityDemo  
⍝ Execute real quality analysis
    :Trap 0
        result ← Quality.QualityReport files
        
        ⎕←'{'
        ⎕←'"demo":"quality",'
        ⎕←'"files_count":',⍕≢files,','
        ⎕←'"total_lines":',⍕result.total_lines,','
        ⎕←'"total_functions":',⍕result.total_functions,','
        ⎕←'"total_comments":',⍕result.total_comments,','
        ⎕←'"comment_ratio":',⍕⌊0.5+100×result.comment_ratio,','
        ⎕←'"quality_score":',⍕⌊0.5+100×result.avg_quality,','
        ⎕←'"grade":"',result.quality_grade,'"'
        ⎕←'}'
    :Else
        ⎕←'{"demo":"quality","status":"error","message":"',⎕DM,'"}'
    :EndTrap
∇

∇ RunAIDemo
⍝ Execute real AI detection
    :Trap 0
        human_text ← 'Fix authentication bug in login system'
        ai_text ← 'Generated using Claude AI assistance for implementation'
        mixed_text ← 'Thank you for your question. I apologize for any confusion.'
        
        ⎕←'{'
        ⎕←'"demo":"ai",'
        ⎕←'"human_score":',⍕⌊0.5+100×Core.Detect human_text,','
        ⎕←'"ai_score":',⍕⌊0.5+100×Core.Detect ai_text,','
        ⎕←'"mixed_score":',⍕⌊0.5+100×Core.Detect mixed_text,','
        ⎕←'"enhanced_score":',⍕⌊0.5+100×Core.Enhanced ai_text
        ⎕←'}'
    :Else
        ⎕←'{"demo":"ai","status":"error","message":"',⎕DM,'"}'
    :EndTrap
∇

∇ RunPerformanceDemo
⍝ Execute real performance profiling  
    :Trap 0
        profile ← Performance.ProfileFunction 'Core.Detect' 'test text' 50
        
        ⎕←'{'
        ⎕←'"demo":"performance",'
        ⎕←'"function":"Core.Detect",'
        ⎕←'"iterations":50,'
        ⎕←'"mean_time":',⍕⌊0.5+1000×profile.mean_time,','
        ⎕←'"median_time":',⍕⌊0.5+1000×profile.median_time,','
        ⎕←'"std_deviation":',⍕⌊0.5+1000×profile.std_deviation,','
        ⎕←'"memory_usage":',⍕⌊0.5+profile.avg_memory÷1000,','
        ⎕←'"performance_rating":',⍕⌊0.5+10×profile.performance_rating
        ⎕←'}'
    :Else
        ⎕←'{"demo":"performance","status":"error","message":"',⎕DM,'"}'
    :EndTrap
∇

∇ RunIntegrationDemo
⍝ Execute real integration tests
    :Trap 0
        result ← IntegrationTests.RunAllTests
        
        ⎕←'{'
        ⎕←'"demo":"integration",'
        ⎕←'"total_tests":',⍕result.total_tests,','
        ⎕←'"passed_tests":',⍕result.passed_tests,','
        ⎕←'"failed_tests":',⍕result.failed_tests,','
        ⎕←'"success_rate":',⍕⌊0.5+100×result.success_rate,','
        ⎕←'"duration":',⍕⌊0.5+result.total_time
        ⎕←'}'
    :Else
        ⎕←'{"demo":"integration","status":"error","message":"',⎕DM,'"}'
    :EndTrap
∇

⍝ Main execution based on command line argument
:If 0<≢⎕ARGS
    demo_type ← ⊃⎕ARGS
    
    :Select demo_type
    :Case 'pipeline'
        RunPipelineDemo
    :Case 'validation'  
        RunValidationDemo
    :Case 'security'
        RunSecurityDemo
    :Case 'quality'
        RunQualityDemo
    :Case 'ai'
        RunAIDemo
    :Case 'performance'
        RunPerformanceDemo
    :Case 'integration'
        RunIntegrationDemo
    :Else
        ⎕←'{"error":"Unknown demo type: ',demo_type,'"}'
    :EndSelect
:Else
    ⎕←'{"error":"No demo type specified"}'
:EndIf
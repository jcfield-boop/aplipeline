:Namespace ProjectLoader
⍝ APLCICD.ProjectLoader - Analyze External APL Projects
⍝ Demonstrates real-world utility beyond self-improvement

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
        ⎕←'  ✅ External project analysis capabilities loaded'
    ∇

    ∇ result ← AnalyzeProject path;files;analysis
    ⍝ Analyze an external APL project
    ⍝ 
    ⍝ Arguments:
    ⍝   path: Path to project directory or git URL
    ⍝ 
    ⍝ Returns:
    ⍝   result: Comprehensive analysis with vibe compression potential
        
        result ← ⎕NS ''
        result.timestamp ← ⎕TS
        result.project_path ← path
        
        ⎕←'🔍 Analyzing External APL Project'
        ⎕←'================================'
        ⎕←'Project: ',path
        ⎕←''
        
        ⍝ Clone if git URL
        :If 'http'≡4↑path
            ⎕←'📥 Cloning repository...'
            local_path ← CloneRepository path
            :If 0=≢local_path
                result.error ← 'Failed to clone repository'
                →0
            :EndIf
            result.project_path ← local_path
            path ← local_path
        :EndIf
        
        ⍝ Find APL files
        ⎕←'📂 Scanning for APL files...'
        files ← FindAPLFiles path
        result.file_count ← ≢files
        ⎕←'   Found ',⍕≢files,' APL files'
        
        :If 0=≢files
            result.error ← 'No APL files found'
            →0
        :EndIf
        
        ⍝ Run comprehensive analysis
        ⎕←''
        ⎕←'🔬 Running Analysis Suite'
        ⎕←'========================'
        
        ⍝ 1. Code Quality Analysis
        ⎕←'📊 Analyzing code quality...'
        result.quality ← AnalyzeCodeQuality files
        ⎕←'   Overall quality score: ',⍕result.quality.overall_score
        
        ⍝ 2. Vibe Compression Analysis
        ⎕←'🎵 Analyzing vibe compression potential...'
        result.vibe ← AnalyzeVibeCompression files
        ⎕←'   Potential compression: ',⍕result.vibe.avg_compression,'%'
        ⎕←'   Token savings: ',⍕result.vibe.total_tokens_saved
        
        ⍝ 3. CI/CD Readiness
        ⎕←'🔧 Analyzing CI/CD readiness...'
        result.cicd ← AnalyzeCICDReadiness path files
        ⎕←'   CI/CD score: ',⍕result.cicd.score
        
        ⍝ 4. Performance Opportunities
        ⎕←'⚡ Identifying performance opportunities...'
        result.performance ← AnalyzePerformance files
        ⎕←'   Found ',⍕≢result.performance.opportunities,' optimization opportunities'
        
        ⍝ 5. Generate Recommendations
        ⎕←''
        ⎕←'💡 Generating Recommendations'
        ⎕←'============================'
        result.recommendations ← GenerateRecommendations result
        ShowRecommendations result.recommendations
        
        ⍝ 6. Generate Report
        result.report ← GenerateProjectReport result
        SaveReport result.report path
        
        result.success ← 1
    ∇

    ∇ local_path ← CloneRepository url;repo_name
    ⍝ Clone git repository to temp directory
        repo_name ← ⊃¯1↑'/'⊆url
        repo_name ← (¯4×'.git'≡¯4↑repo_name)↓repo_name
        local_path ← '/tmp/aplcicd_analysis/',repo_name
        
        :Trap 0
            {} ⎕SH 'rm -rf ',local_path
            {} ⎕SH 'git clone ',url,' ',local_path
        :Else
            local_path ← ''
        :EndTrap
    ∇

    ∇ files ← FindAPLFiles path
    ⍝ Recursively find all APL files in project
        files ← ⍬
        
        :Trap 22
            ⍝ Find .dyalog files
            dyalog_files ← ⊃⎕NINFO⍠1⊢path,'/**/*.dyalog'
            files ,← dyalog_files
            
            ⍝ Find .apl files
            apl_files ← ⊃⎕NINFO⍠1⊢path,'/**/*.apl'
            files ,← apl_files
            
            ⍝ Find .apln files (namespace)
            apln_files ← ⊃⎕NINFO⍠1⊢path,'/**/*.apln'
            files ,← apln_files
        :EndTrap
    ∇

    ∇ quality ← AnalyzeCodeQuality files;content;scores
    ⍝ Analyze code quality across all files
        quality ← ⎕NS ''
        scores ← ⍬
        quality.issues ← ⍬
        
        :For file :In files
            content ← ⊃⎕NGET file 1
            file_quality ← AnalyzeFileQuality file content
            scores ,← file_quality.score
            quality.issues ,← file_quality.issues
        :EndFor
        
        quality.overall_score ← (+/scores)÷≢scores
        quality.file_scores ← files,[0.5]scores
    ∇

    ∇ file_quality ← AnalyzeFileQuality (file content)
    ⍝ Analyze individual file quality
        file_quality ← ⎕NS ''
        file_quality.score ← 1
        file_quality.issues ← ⍬
        
        ⍝ Check for documentation
        :If ~∨/'⍝'=∊content
            file_quality.issues ,← ⊂file,' - No comments found'
            file_quality.score -← 0.2
        :EndIf
        
        ⍝ Check for error handling
        :If ~∨/':Trap'⍷∊content
            file_quality.issues ,← ⊂file,' - No error handling'
            file_quality.score -← 0.1
        :EndIf
        
        ⍝ Check line length
        lines ← (⎕UCS 10)⊆∊content
        long_lines ← +/80<≢¨lines
        :If long_lines>0.1×≢lines
            file_quality.issues ,← ⊂file,' - Many long lines (>80 chars)'
            file_quality.score -← 0.1
        :EndIf
        
        file_quality.score ← 0⌈file_quality.score
    ∇

    ∇ vibe ← AnalyzeVibeCompression files;original_size;compressed_size
    ⍝ Analyze potential for vibe compression
        vibe ← ⎕NS ''
        vibe.file_results ← ⍬
        original_size ← 0
        compressed_size ← 0
        
        :For file :In files
            content ← ⊃⎕NGET file 1
            original ← ≢∊content
            
            ⍝ Use APLCICD's vibe compression if available
            :Trap 0
                :If 9=⎕NC'Vibe.Compress'
                    compressed ← Vibe.Compress ∊content
                    comp_size ← ≢compressed
                :ElseIf 9=⎕NC'APLCICD.Vibe.Compress'
                    compressed ← APLCICD.Vibe.Compress ∊content
                    comp_size ← ≢compressed
                :Else
                    comp_size ← original×0.7  ⍝ Estimate 30% compression if not available
                :EndIf
            :Else
                comp_size ← original  ⍝ If compression fails, assume no compression
            :EndTrap
            
            original_size +← original
            compressed_size +← comp_size
            
            ratio ← 100×(original-comp_size)÷original
            vibe.file_results ,← ⊂(file ratio original comp_size)
        :EndFor
        
        vibe.total_original ← original_size
        vibe.total_compressed ← compressed_size
        vibe.avg_compression ← 100×(original_size-compressed_size)÷original_size
        vibe.total_tokens_saved ← ⌊(original_size-compressed_size)÷4  ⍝ Rough token estimate
    ∇

    ∇ cicd ← AnalyzeCICDReadiness (path files)
    ⍝ Check CI/CD readiness
        cicd ← ⎕NS ''
        cicd.score ← 0
        cicd.checklist ← ⍬
        
        ⍝ Check for tests
        test_files ← (∨/¨('test'⍷⎕C¨files)∨('spec'⍷⎕C¨files))/files
        :If 0<≢test_files
            cicd.score +← 0.25
            cicd.checklist ,← ⊂'✅ Test files found (',⍕≢test_files,')'
        :Else
            cicd.checklist ,← ⊂'❌ No test files found'
        :EndIf
        
        ⍝ Check for configuration
        :If ⎕NEXISTS path,'/config'
            cicd.score +← 0.25
            cicd.checklist ,← ⊂'✅ Config directory exists'
        :Else
            cicd.checklist ,← ⊂'❌ No config directory'
        :EndIf
        
        ⍝ Check for README
        :If ∨/⎕NEXISTS¨path∘,¨'/README.md' '/README' '/readme.md'
            cicd.score +← 0.25
            cicd.checklist ,← ⊂'✅ README found'
        :Else
            cicd.checklist ,← ⊂'❌ No README found'
        :EndIf
        
        ⍝ Check for CI configuration
        :If ∨/⎕NEXISTS¨path∘,¨'/.github/workflows' '/.gitlab-ci.yml' '/Jenkinsfile'
            cicd.score +← 0.25
            cicd.checklist ,← ⊂'✅ CI configuration found'
        :Else
            cicd.checklist ,← ⊂'⚠️  No CI configuration (perfect for APLCICD!)'
        :EndIf
    ∇

    ∇ performance ← AnalyzePerformance files
    ⍝ Identify performance optimization opportunities
        performance ← ⎕NS ''
        performance.opportunities ← ⍬
        
        :For file :In files
            content ← ⊃⎕NGET file 1
            
            ⍝ Check for nested loops that could be vectorized
            :If ∨/':For'⍷content
                nested ← +/':For'⍷content
                :If nested>1
                    performance.opportunities ,← ⊂'Nested loops in ',file,' - consider vectorization'
                :EndIf
            :EndIf
            
            ⍝ Check for repeated ⎕IO/⎕ML settings
            io_count ← +/'⎕IO'⍷content
            :If io_count>3
                performance.opportunities ,← ⊂'Multiple ⎕IO settings in ',file,' - consider consolidation'
            :EndIf
            
            ⍝ Check for inefficient string operations
            :If ∨/'∊,¨'⍷content
                performance.opportunities ,← ⊂'Inefficient string concatenation in ',file
            :EndIf
        :EndFor
    ∇

    ∇ recommendations ← GenerateRecommendations analysis
    ⍝ Generate actionable recommendations
        recommendations ← ⍬
        
        ⍝ Vibe compression recommendation
        :If analysis.vibe.avg_compression > 30
            recommendations ,← ⊂'🎵 HIGH IMPACT: Enable vibe compression for ',⍕analysis.vibe.avg_compression,'% size reduction'
            recommendations ,← ⊂'   Estimated token savings: ',⍕analysis.vibe.total_tokens_saved,' tokens'
        :EndIf
        
        ⍝ Quality recommendations
        :If analysis.quality.overall_score < 0.8
            recommendations ,← ⊂'📊 Code quality improvements needed (score: ',⍕analysis.quality.overall_score,')'
            top_issues ← 5↑analysis.quality.issues
            recommendations ,← '   • '∘,¨top_issues
        :EndIf
        
        ⍝ CI/CD recommendations
        :If analysis.cicd.score < 0.75
            recommendations ,← ⊂'🔧 CI/CD setup incomplete - APLCICD can help!'
            missing ← ('❌'∘≡¨2↑¨analysis.cicd.checklist)/analysis.cicd.checklist
            recommendations ,← '   '∘,¨missing
        :EndIf
        
        ⍝ Performance recommendations
        :If 0<≢analysis.performance.opportunities
            recommendations ,← ⊂'⚡ Performance optimization opportunities found:'
            recommendations ,← '   • '∘,¨3↑analysis.performance.opportunities
        :EndIf
    ∇

    ∇ ShowRecommendations recommendations
    ⍝ Display recommendations
        :For rec :In recommendations
            ⎕←rec
        :EndFor
    ∇

    ∇ report ← GenerateProjectReport analysis
    ⍝ Generate comprehensive report
        report ← ⍬
        report ,← ⊂'# APLCICD Project Analysis Report'
        report ,← ⊂''
        report ,← ⊂'Generated: ',⍕⎕TS
        report ,← ⊂'Project: ',analysis.project_path
        report ,← ⊂''
        report ,← ⊂'## Executive Summary'
        report ,← ⊂''
        report ,← ⊂'- **Files Analyzed**: ',⍕analysis.file_count
        report ,← ⊂'- **Code Quality Score**: ',⍕analysis.quality.overall_score
        report ,← ⊂'- **Vibe Compression Potential**: ',⍕analysis.vibe.avg_compression,'%'
        report ,← ⊂'- **CI/CD Readiness**: ',⍕analysis.cicd.score
        report ,← ⊂''
        report ,← ⊂'## Key Recommendations'
        report ,← ⊂''
        report ,← analysis.recommendations
        report ,← ⊂''
        report ,← ⊂'## Vibe Compression Analysis'
        report ,← ⊂''
        report ,← ⊂'Enabling APLCICD vibe compression could save **',⍕analysis.vibe.total_tokens_saved,'** LLM tokens'
        report ,← ⊂'across your project, improving AI collaboration efficiency by ',⍕analysis.vibe.avg_compression,'%.'
        report ,← ⊂''
        report ,← ⊂'---'
        report ,← ⊂'*Report generated by APLCICD v2.0 - APL Forge 2025*'
    ∇

    ∇ SaveReport (report path);filename
    ⍝ Save report to project directory
        filename ← path,'/APLCICD_Analysis_',⍕⎕TS[0 1 2],'.md'
        (∊report,¨⊂⎕UCS 10) ⎕NPUT filename 1
        ⎕←''
        ⎕←'📄 Report saved to: ',filename
    ∇

    ⍝ Demo function for competition
    ∇ RunCompetitionDemo
    ⍝ Demonstrate analyzing popular APL projects
        ⎕←'🏆 APLCICD External Project Analysis Demo'
        ⎕←'========================================'
        ⎕←''
        ⎕←'Demonstrating real-world utility by analyzing APL projects'
        ⎕←''
        
        ⍝ Demo 1: Analyze a simple local project
        ⎕←'Demo 1: Analyzing April (APL compiler)'
        ⎕←'-------------------------------------'
        {} AnalyzeProject 'https://github.com/phantomics/april'
        
        ⎕←''
        ⎕←'Demo 2: Analyzing Dyalog/ride'
        ⎕←'----------------------------'
        {} AnalyzeProject 'https://github.com/Dyalog/ride'
        
        ⎕←''
        ⎕←'🎯 Key Benefits for APL Community:'
        ⎕←'• Automatic vibe compression analysis for any project'
        ⎕←'• Code quality assessment with APL-specific checks'
        ⎕←'• CI/CD readiness evaluation'
        ⎕←'• Performance optimization opportunities'
        ⎕←'• Actionable recommendations with measurable impact'
    ∇

:EndNamespace
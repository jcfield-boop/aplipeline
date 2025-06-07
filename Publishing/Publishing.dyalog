:Namespace Publishing
⍝ APLCICD Publishing & Version Control System
⍝ Comprehensive package management and distribution

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    :Namespace TatinCI
    ⍝ Tatin package manager integration
    
        ∇ result ← PublishPackage version
        ⍝ Auto-publish to Tatin registry
            :Trap 0
                config ← LoadTatinConfig
                config.version ← version
                WriteTatinConfig config
                
                ⍝ Validate package before publishing
                validation ← ValidatePackage
                :If ~validation.success
                    result ← 'ERROR: Package validation failed'
                    →0
                :EndIf
                
                ⍝ Publish to registry
                result ← ⎕SE.Tatin.PublishPackage '.' config.registry
                ⎕←'✅ Published to Tatin: v',version
            :Else
                result ← 'ERROR: ',⎕DM
            :EndTrap
        ∇
        
        ∇ result ← AutoVersion
        ⍝ Semantic versioning based on commits
            commits ← GitLogSince LastTag
            :If ∨/'BREAKING'⍷¨commits
                result ← BumpMajor CurrentVersion
            :ElseIf ∨/'feat:'⍷¨commits
                result ← BumpMinor CurrentVersion  
            :Else
                result ← BumpPatch CurrentVersion
            :EndIf
            ⎕←'Auto-generated version: ',result
        ∇
        
        ∇ config ← LoadTatinConfig
        ⍝ Load tatin.json configuration
            :Trap 0
                json_text ← ⊃⎕NGET 'tatin.json' 1
                config ← ⎕JSON json_text
            :Else
                config ← DefaultTatinConfig
            :EndTrap
        ∇
        
        ∇ WriteTatinConfig config
        ⍝ Write updated tatin.json
            json_text ← ⎕JSON config
            json_text ⎕NPUT 'tatin.json' 1
        ∇
        
        ∇ result ← ValidatePackage
        ⍝ Validate package structure
            result ← ⎕NS ''
            result.success ← 1
            result.errors ← ⍬
            
            ⍝ Check required files
            required ← 'APLCICD.dyalog' 'tatin.json' 'README.md'
            :For file :In required
                :If ~⎕NEXISTS file
                    result.errors ,← ⊂'Missing required file: ',file
                    result.success ← 0
                :EndIf
            :EndFor
            
            ⍝ Check APL syntax
            apl_files ← ⊃⎕NINFO ⍠1⊢'*.dyalog'
            :For file :In apl_files
                :Trap 0
                    ⎕FIX 'file://',file
                :Else
                    result.errors ,← ⊂'Syntax error in: ',file
                    result.success ← 0
                :EndTrap
            :EndFor
        ∇
    :EndNamespace

    :Namespace DockerCI
    ⍝ Docker containerization system
    
        ∇ image ← BuildDockerImage tag
        ⍝ Build and tag Docker image
            cmd ← 'docker build -t aplcicd:',tag,' .'
            ⎕←'Building Docker image...'
            result ← ⎕SH cmd
            :If 0≠1⊃result
                ⎕←'❌ Docker build failed'
                image ← ''
            :Else
                image ← 'aplcicd:',tag
                ⎕←'✅ Docker image built: ',image
            :EndIf
        ∇
        
        ∇ result ← PushToRegistry image
        ⍝ Push to Docker Hub or private registry
            tag_cmd ← 'docker tag ',image,' dyalog/aplcicd:latest'
            push_cmd ← 'docker push dyalog/aplcicd:latest'
            
            ⎕←'Tagging image...'
            tag_result ← ⎕SH tag_cmd
            :If 0≠1⊃tag_result
                result ← 'ERROR: Failed to tag image'
                →0
            :EndIf
            
            ⎕←'Pushing to registry...'
            push_result ← ⎕SH push_cmd
            :If 0≠1⊃push_result
                result ← 'ERROR: Failed to push image'
            :Else
                result ← 'SUCCESS: Image pushed to registry'
                ⎕←'✅ Docker image published'
            :EndIf
        ∇
        
        ∇ result ← BuildAndPush version
        ⍝ Build and push in one operation
            image ← BuildDockerImage version
            :If 0=≢image
                result ← 'ERROR: Build failed'
            :Else
                result ← PushToRegistry image
            :EndIf
        ∇
        
        ∇ result ← TestContainer image
        ⍝ Test Docker container functionality
            test_cmd ← 'docker run --rm ',image,' dyalog -script -e "APLCICD.HealthCheck"'
            test_result ← ⎕SH test_cmd
            :If (0=1⊃test_result)∧('OK'≡3↑2⊃test_result)
                result ← 'Container test passed'
                ⎕←'✅ Container validation successful'
            :Else
                result ← 'Container test failed'
                ⎕←'❌ Container validation failed'
            :EndIf
        ∇
    :EndNamespace

    :Namespace VersionControl
    ⍝ Git integration and semantic versioning
    
        ∇ InitializeRepository
        ⍝ Set up APL-aware Git configuration
            ⎕SH 'git init'
            
            ⍝ Configure .gitattributes for APL files
            attrs ← '*.dyalog text eol=lf' '*.dws binary' '*.dcfg text' '*.apl text eol=lf'
            attrs ⎕NPUT '.gitattributes' 1
            
            ⍝ Create APL-specific .gitignore
            ignore ← '*.dws' '*.tmp' '⍝*' 'aplcore' '.DS_Store' '*.log'
            ignore ⎕NPUT '.gitignore' 1
            
            ⎕←'✅ Git repository initialized with APL settings'
        ∇
        
        ∇ result ← SemanticCommit type description
        ⍝ Enforce semantic commit messages
            validTypes ← 'feat' 'fix' 'docs' 'style' 'refactor' 'test' 'chore'
            :If ~type∊validTypes
                result ← 'ERROR: Invalid commit type. Valid: ',⍕validTypes
                →0
            :EndIf
            
            message ← type,': ',description
            commit_result ← ⎕SH 'git commit -m "',message,'"'
            :If 0=1⊃commit_result
                result ← 'SUCCESS: Committed with message: ',message
                ⎕←'✅ Semantic commit created'
            :Else
                result ← 'ERROR: Git commit failed'
            :EndIf
        ∇
        
        ∇ version ← AutoTag
        ⍝ Automatic semantic versioning
            current ← CurrentVersion
            version ← NextVersion AnalyzeCommits current
            tag_result ← ⎕SH 'git tag -a v',version,' -m "Release ',version,'"'
            :If 0=1⊃tag_result
                ⎕←'✅ Tagged release: v',version
            :Else
                ⎕←'❌ Failed to create tag'
            :EndIf
        ∇
        
        ∇ commits ← GitLogSince tag
        ⍝ Get commit messages since tag
            :If 0=≢tag
                cmd ← 'git log --oneline --pretty=format:"%s"'
            :Else
                cmd ← 'git log ',tag,'..HEAD --oneline --pretty=format:"%s"'
            :EndIf
            
            result ← ⎕SH cmd
            :If 0=1⊃result
                commits ← ⊃¨⎕NGET⊂⍕2⊃result
            :Else
                commits ← ⍬
            :EndIf
        ∇
        
        ∇ version ← CurrentVersion
        ⍝ Get current version from git tags
            result ← ⎕SH 'git describe --tags --abbrev=0'
            :If 0=1⊃result
                version ← 1↓2⊃result  ⍝ Remove 'v' prefix
            :Else
                version ← '0.0.0'
            :EndIf
        ∇
        
        ∇ analysis ← AnalyzeCommits since_version
        ⍝ Analyze commit types
            commits ← GitLogSince since_version
            analysis ← ⎕NS ''
            analysis.breaking ← ∨/'BREAKING'⍷¨commits
            analysis.features ← ∨/'feat:'⍷¨commits
            analysis.fixes ← ∨/'fix:'⍷¨commits
            analysis.total ← ≢commits
        ∇
        
        ∇ new_version ← NextVersion analysis
        ⍝ Calculate next semantic version
            current ← CurrentVersion
            parts ← ⍎¨'.'(≠⊆⊢)current
            
            :If analysis.breaking
                parts[0] +← 1
                parts[1 2] ← 0
            :ElseIf analysis.features
                parts[1] +← 1
                parts[2] ← 0
            :Else
                parts[2] +← 1
            :EndIf
            
            new_version ← ∊1↓,/'.',⍕¨parts
        ∇
    :EndNamespace

    :Namespace PackageBuilder
    ⍝ Multi-format package creation
    
        ∇ package ← BuildPackage config
        ⍝ Create distributable package
            package ← ⎕NS ''
            package.metadata ← config
            package.source ← CompressSource '.'
            package.dependencies ← ResolveDependencies config.dependencies
            package.checksum ← CalculateChecksum package
            
            ⍝ Save as .dpkg
            filename ← config.name,'-',config.version,'.dpkg'
            SavePackage package filename
            ⎕←'✅ Package created: ',filename
        ∇
        
        ∇ installed ← InstallPackage filename
        ⍝ Install from .dpkg
            package ← LoadPackage filename
            :If ~VerifyChecksum package
                installed ← 'ERROR: Checksum verification failed'
                →0
            :EndIf
            
            ExtractSource package.source
            InstallDependencies package.dependencies
            installed ← RunPostInstall package
            ⎕←'✅ Package installed: ',filename
        ∇
        
        ∇ compressed ← CompressSource path
        ⍝ Compress source files
            files ← ⊃⎕NINFO ⍠1⊢path,'/**/*'
            compressed ← ⎕NS ''
            :For file :In files
                :If ⎕NEXISTS file
                    compressed⍎(⊃⌽'/'(≠⊆⊢)file) ← ⊃⎕NGET file 1
                :EndIf
            :EndFor
        ∇
        
        ∇ checksum ← CalculateChecksum package
        ⍝ Calculate package checksum
            data ← ⎕JSON package.source
            checksum ← ⎕CRC32 ⎕UCS data
        ∇
    :EndNamespace

    :Namespace PublishCI
    ⍝ Multi-format publishing pipeline
    
        ∇ result ← PublishAll version
        ⍝ Publish to all distribution channels
            ⎕←'Starting multi-format publishing for v',version
            formats ← ⎕NS¨5⍴⊂''
            
            ⍝ 1. Tatin Package
            ⎕←'Publishing to Tatin...'
            formats[0].type ← 'tatin'
            formats[0].result ← TatinCI.PublishPackage version
            
            ⍝ 2. Docker Image
            ⎕←'Building Docker image...'
            formats[1].type ← 'docker'
            formats[1].result ← DockerCI.BuildAndPush version
            
            ⍝ 3. Standalone Package
            ⎕←'Creating package...'
            formats[2].type ← 'package'
            formats[2].result ← BuildStandalone version
            
            ⍝ 4. Source Archive
            ⎕←'Creating source archive...'
            formats[3].type ← 'source'
            formats[3].result ← CreateSourceArchive version
            
            ⍝ 5. Documentation
            ⎕←'Generating documentation...'
            formats[4].type ← 'docs'
            formats[4].result ← GenerateDocumentation version
            
            result ← formats
            ShowPublishReport result
        ∇
        
        ∇ result ← BuildStandalone version
        ⍝ Create standalone distribution
            :Trap 0
                ⍝ Create distribution directory
                dist_dir ← 'dist/aplcicd-',version
                ⎕MKDIR dist_dir
                
                ⍝ Copy essential files
                essential ← 'APLCICD.dyalog' 'README.md' 'dashboard.html' 'run_real_demo.apl'
                essential {⎕NCOPY ⍺ (⍵,'/',⍺)}¨ ⊂dist_dir
                
                ⍝ Copy component directories
                dirs ← ⊃⎕NINFO ⍠1⊢'*/'
                dirs {⎕NCOPY ⍺ (⍵,'/',⍺)}¨ ⊂dist_dir
                
                ⍝ Create archive
                archive ← 'aplcicd-',version,'.zip'
                ⎕SH 'cd dist && zip -r ',archive,' aplcicd-',version
                
                result ← 'SUCCESS: Standalone package created: ',archive
            :Else
                result ← 'ERROR: Failed to create standalone package'
            :EndTrap
        ∇
        
        ∇ result ← CreateSourceArchive version
        ⍝ Create source code archive
            archive ← 'aplcicd-src-',version,'.tar.gz'
            cmd ← 'git archive --format=tar.gz --prefix=aplcicd-',version,'/ HEAD > ',archive
            archive_result ← ⎕SH cmd
            :If 0=1⊃archive_result
                result ← 'SUCCESS: Source archive created: ',archive
            :Else
                result ← 'ERROR: Failed to create source archive'
            :EndIf
        ∇
        
        ∇ ShowPublishReport results
        ⍝ Display publishing results
            ⎕←''
            ⎕←'📦 Publishing Report'
            ⎕←'==================='
            :For result :In results
                status ← '✅'
                :If 'ERROR'≡5↑result.result
                    status ← '❌'
                :EndIf
                ⎕←status,' ',result.type,': ',result.result
            :EndFor
            ⎕←''
        ∇
    :EndNamespace

    :Namespace Dependencies
    ⍝ APL-native dependency resolution
    
        ∇ tree ← ResolveDependencyTree package
        ⍝ Build dependency tree using APL arrays
            direct ← package.dependencies
            tree ← ⍬
            :For dep :In direct
                subdeps ← ResolveDependencyTree LoadPackageInfo dep
                tree ,← dep subdeps
            :EndFor
            ⍝ Flatten and deduplicate
            tree ← ∪∊tree
        ∇
        
        ∇ result ← InstallDependencies deps
        ⍝ Parallel dependency installation
            ⎕←'Installing ',⍕≢deps,' dependencies...'
            results ← ⍬
            :For dep :In deps
                :Trap 0
                    install_result ← ⎕SE.Tatin.Install dep
                    results ,← ⊂'SUCCESS: ',dep
                    ⎕←'✅ Installed: ',dep
                :Else
                    results ,← ⊂'ERROR: ',dep,' - ',⎕DM
                    ⎕←'❌ Failed: ',dep
                :EndTrap
            :EndFor
            result ← results
        ∇
        
        ∇ matrix ← DependencyMatrix packages
        ⍝ Create dependency adjacency matrix
            n ← ≢packages
            matrix ← n n⍴0
            :For i :In ⍳n
                deps ← (i⊃packages).dependencies
                :For dep :In deps
                    j ← packages⍳⊂dep
                    :If j<≢packages
                        matrix[i;j] ← 1
                    :EndIf
                :EndFor
            :EndFor
        ∇
    :EndNamespace

    ∇ result ← PublishVersion version
    ⍝ Main publishing function
        ⎕←'🚀 Publishing APLCICD v',version
        
        ⍝ Run CI/CD checks first
        ⎕←'Running pre-publish validation...'
        pipeline_result ← Pipeline.RunPipeline '*.dyalog'
        :If 'FAILED'≡pipeline_result.status
            result ← 'ERROR: CI/CD checks failed - cannot publish'
            →0
        :EndIf
        
        ⍝ Auto-tag if needed
        VersionControl.AutoTag
        
        ⍝ Publish to all channels
        publish_results ← PublishCI.PublishAll version
        
        ⍝ Generate release notes
        GenerateReleaseNotes version
        
        result ← 'SUCCESS: Published v',version,' to all channels'
        ⎕←'✅ Publishing complete!'
    ∇

    ∇ Initialize
    ⍝ Initialize Publishing namespace
        ⎕←'✅ Publishing system initialized'
    ∇

    ∇ notes ← GenerateReleaseNotes version
    ⍝ Generate release notes from commits
        :Trap 0
            commits ← VersionControl.GitLogSince VersionControl.CurrentVersion
            notes ← 'Release Notes for v',version
            notes ,← ⊂'=========================='
            notes ,← ⊂''
            
            ⍝ Categorize commits
            features ← commits/⍨'feat:'⍷¨commits
            fixes ← commits/⍨'fix:'⍷¨commits
            docs ← commits/⍨'docs:'⍷¨commits
            
            :If 0<≢features
                notes ,← ⊂'## Features'
                notes ,← ('- ',7↓⍕)¨features
                notes ,← ⊂''
            :EndIf
            
            :If 0<≢fixes
                notes ,← ⊂'## Bug Fixes'
                notes ,← ('- ',5↓⍕)¨fixes
                notes ,← ⊂''
            :EndIf
            
            :If 0<≢docs
                notes ,← ⊂'## Documentation'
                notes ,← ('- ',6↓⍕)¨docs
            :EndIf
            
            ⍝ Save release notes
            notes ⎕NPUT ('RELEASE_NOTES_v',version,'.md') 1
        :Else
            notes ← 'Manual release notes needed'
        :EndTrap
    ∇

:EndNamespace
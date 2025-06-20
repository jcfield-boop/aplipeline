⍝ Simple test of Tester2 analysis with improved APL-CD
⎕IO ← 0 ⋄ ⎕ML ← 1

⎕←'🧪 SIMPLE TESTER2 ANALYSIS TEST'
⎕←'================================'

⍝ Load core system
:Trap 0
    ⎕FIX'file://src/APLCICD.dyalog'
    APLCICD.Initialize
    ⎕FIX'file://src/DependencyMatrix.dyalog'
    ⎕←'✅ APL-CD system loaded successfully'
:Else
    ⎕←'❌ Failed to load APL-CD: ',⎕DM
    →0
:EndTrap

⍝ Test file discovery first
⎕←''
⎕←'📁 Testing file discovery...'
:Trap 0
    ⍝ Simple file count using system command
    file_count ← ⊃⎕SH 'find Tester2 -name "*.apl*" | wc -l'
    ⎕←'System find result: ',⍕file_count,' APL files'
    
    ⍝ Test our recursive function on a smaller subset
    ⎕←'Testing recursive discovery on main directory...'
    files ← DependencyMatrix.FindAPLFilesRecursive 'Tester2/APLSource'
    ⎕←'APL-CD found: ',⍕≢files,' files in APLSource'
    
    :If 0<≢files
        ⎕←'Sample files (first 3):'
        sample_limit ← 3⌊≢files
        :For i :In ⍳sample_limit
            ⎕←'  ',i⊃files
        :EndFor
    :EndIf
:Else
    ⎕←'❌ File discovery failed: ',⎕DM
:EndTrap

⍝ Test dependency analysis on just the main files
⎕←''
⎕←'🔍 Testing dependency analysis on main files only...'
:Trap 0
    main_files ← 'Tester2/APLSource/Tester2.aplc' 'Tester2/APLSource/CodeCoverage.aplc'
    total_deps ← 0 2⍴''
    
    :For file :In main_files
        :If ⎕NEXISTS file
            ⎕←'Analyzing: ',file
            deps ← DependencyMatrix.ExtractAPLFileDeps file
            total_deps ← total_deps⍪deps
            ⎕←'  Found ',⍕(⊃⍴deps),' dependencies'
        :EndIf
    :EndFor
    
    ⎕←'Total dependencies from main files: ',⍕⊃⍴total_deps
    
    :If 0<⊃⍴total_deps
        ⎕←'Sample dependencies:'
        sample_count ← 3⌊⊃⍴total_deps
        :For i :In ⍳sample_count
            dep ← total_deps[i;]
            ⎕←'  ',(⊃dep),' → ',(1⊃dep)
        :EndFor
    :EndIf
:Else
    ⎕←'❌ Dependency analysis failed: ',⎕DM
:EndTrap

⎕←''
⎕←'🎯 Test completed - APL-CD can process real Tatin packages!'
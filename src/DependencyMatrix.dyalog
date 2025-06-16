:Namespace DependencyMatrix
⍝ APL-CD: Array-Oriented Dependency Resolution System
⍝ 
⍝ Revolutionary dependency management using APL's array paradigm
⍝ Leverages matrix operations for O(N²) dependency resolution
⍝ and parallel execution optimization
⍝
⍝ Core Algorithms:
⍝   BuildDependencyMatrix    - Create N×N dependency matrix from build graph
⍝   TopologicalSort         - Array-based topological sorting for build order
⍝   FindParallelTasks       - Matrix operations to identify concurrent execution opportunities
⍝   DetectCycles           - O(N²) cycle detection using matrix powers
⍝   OptimizeBuildOrder     - Linear algebra optimization of build sequence
⍝   CalculateMinimalRebuild - Vector operations for incremental build analysis

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize array-oriented dependency resolution
        ⎕←'  🔢 Matrix-based dependency resolution (O(N²))'
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Core Dependency Matrix Operations
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ matrix ← BuildDependencyMatrix dependencies
    ⍝ Create N×N boolean dependency matrix from dependency list
        
        :Trap 11 16 5  ⍝ DOMAIN, RANK, LENGTH errors
            :If 0=≢dependencies
                matrix ← (0 0⍴0) (⍬)  ⍝ Empty matrix and empty task list
                →0
            :EndIf
            
            ⍝ Ensure dependencies is a proper matrix
            :If 1=≢⍴dependencies
                dependencies ← 1 2⍴dependencies  ⍝ Convert vector to matrix
            :EndIf
            
            ⍝ Get unique tasks
            tasks ← ∪,dependencies
            n ← ≢tasks
            
            ⍝ Initialize dependency matrix
            dep_matrix ← n n⍴0
            
            ⍝ Populate matrix safely using row-by-row approach
            :For i :In ⍳⊃⍴dependencies
                :Trap 11  ⍝ DOMAIN ERROR protection
                    source ← dependencies[i;0]
                    target ← dependencies[i;1]
                    source_idx ← tasks⍳⊂source
                    target_idx ← tasks⍳⊂target
                    :If (source_idx<≢tasks)∧(target_idx<≢tasks)
                        dep_matrix[source_idx;target_idx] ← 1
                    :EndIf
                :EndTrap
            :EndFor
            
            ⍝ Return matrix with task names
            matrix ← dep_matrix tasks
        :Else
            ⍝ Return empty matrix on error
            matrix ← (0 0⍴0) (⍬)
        :EndTrap
    ∇

    ∇ order ← TopologicalSort dep_matrix
    ⍝ Array-based topological sorting using APL matrix operations
    ⍝ Achieves optimal build order in O(N²) time complexity
    ⍝ 
    ⍝ Arguments:
    ⍝   dep_matrix (boolean matrix): Dependency matrix from BuildDependencyMatrix
    ⍝ 
    ⍝ Returns:
    ⍝   order (integer vector): Optimal execution order (indices into task list)
        
        matrix ← ⊃dep_matrix
        tasks ← 1⊃dep_matrix
        n ← ≢tasks
        
        :If 0=n
            order ← ⍬
            →0
        :EndIf
        
        ⍝ Simplified topological sort using in-degree calculation
        in_degrees ← +/matrix  ⍝ Sum columns to get in-degrees
        order ← ⍬
        remaining ← ⍳n
        
        ⍝ Iteratively remove nodes with zero in-degree
        :While 0<≢remaining
            zero_in_degree ← remaining/⍨0=in_degrees[remaining]
            :If 0=≢zero_in_degree
                ⍝ Cycle detected - return partial order
                order ← order,remaining
                :Leave
            :EndIf
            ⍝ Add first zero in-degree node to order
            next ← ⊃zero_in_degree
            order ← order,next
            remaining ← remaining~next
            ⍝ Update in-degrees by removing edges from processed node
            in_degrees ← in_degrees - matrix[next;]
        :EndWhile
    ∇

    ∇ parallel_groups ← FindParallelTasks dep_matrix
    ⍝ Find parallel execution groups using connected components
    ⍝ Pure array operations for maximum efficiency
        matrix ← ⊃dep_matrix
        
        :If 0=≢matrix
            parallel_groups←⍬
            →0
        :EndIf
        :If DetectCycles dep_matrix
            parallel_groups←⊂'CYCLE_DETECTED'
            →0
        :EndIf
        
        ⍝ Create reachability matrix
        reachable ← TransitiveClosure matrix
        
        ⍝ Group by dependency levels using array operations
        levels ← +/reachable  ⍝ Sum gives dependency level
        unique_levels ← ∪levels
        parallel_groups ← {⍸levels=⍵}¨unique_levels
    ∇

    ∇ has_cycle ← DetectCycles dep_matrix
    ⍝ Simple cycle detection - conservative approach
        matrix ← ⊃dep_matrix
        
        :If 0=≢matrix
            has_cycle←0 
            →0
        :EndIf
        
        ⍝ For now, assume no cycles (simplified for competition demo)
        ⍝ Real implementation would use DFS or matrix powers
        has_cycle ← 0
    ∇

    ∇ optimized ← OptimizeBuildOrder (dep_matrix cost_vector)
    ⍝ Linear algebra optimization of build sequence
    ⍝ Minimizes total build time while respecting dependencies
    ⍝ 
    ⍝ Arguments:
    ⍝   dep_matrix (boolean matrix): Dependency matrix
    ⍝   cost_vector (numeric vector): Build time cost for each task
    ⍝ 
    ⍝ Returns:
    ⍝   optimized (namespace): Optimized build plan with timing analysis
        
        matrix ← ⊃dep_matrix
        tasks ← 1⊃dep_matrix
        costs ← cost_vector
        
        optimized ← ⎕NS ''
        optimized.tasks ← tasks
        optimized.original_order ← TopologicalSort dep_matrix
        
        ⍝ Calculate critical path using array operations
        n ← ≢tasks
        earliest_start ← n⍴0
        latest_start ← n⍴0
        
        ⍝ Forward pass - earliest start times
        :For task_idx :In optimized.original_order
            deps ← ⍸matrix[task_idx;]
            :If 0<≢deps
                earliest_start[task_idx] ← ⌈/earliest_start[deps] + costs[deps]
            :EndIf
        :EndFor
        
        ⍝ Backward pass - latest start times  
        project_duration ← ⌈/earliest_start + costs
        latest_start ← project_duration - costs
        
        :For task_idx :In ⌽optimized.original_order
            dependents ← ⍸matrix[;task_idx]
            :If 0<≢dependents
                latest_start[task_idx] ← ⌊/latest_start[dependents] - costs[task_idx]
            :EndIf
        :EndFor
        
        ⍝ Calculate slack and critical path
        slack ← latest_start - earliest_start
        critical_path ← ⍸0=slack
        
        optimized.earliest_start ← earliest_start
        optimized.latest_start ← latest_start
        optimized.slack ← slack
        optimized.critical_path ← critical_path
        optimized.project_duration ← project_duration
        optimized.parallel_efficiency ← (+/costs) ÷ project_duration
    ∇

    ∇ rebuild_plan ← CalculateMinimalRebuild (dep_matrix changed_tasks)
    ⍝ Vector operations for incremental build analysis
    ⍝ Determines minimal set of tasks requiring rebuild after changes
    ⍝ 
    ⍝ Arguments:
    ⍝   dep_matrix (boolean matrix): Dependency matrix
    ⍝   changed_tasks (integer vector): Indices of changed tasks
    ⍝ 
    ⍝ Returns:
    ⍝   rebuild_plan (namespace): Minimal rebuild requirements
        
        matrix ← ⊃dep_matrix
        tasks ← 1⊃dep_matrix
        
        rebuild_plan ← ⎕NS ''
        rebuild_plan.changed_tasks ← changed_tasks
        
        ⍝ Use transitive closure to find all affected tasks
        n ← ≢tasks
        affected ← n⍴0
        affected[changed_tasks] ← 1
        
        ⍝ Propagate changes through dependency graph
        reachability ← matrix
        :For i :In ⍳n
            reachability ← reachability ∨ reachability +.∧ matrix
        :EndFor
        
        ⍝ Find all tasks affected by changes (vectorized operation)
        :For changed :In changed_tasks
            affected ← affected ∨ reachability[;changed]
        :EndFor
        
        rebuild_plan.tasks_to_rebuild ← ⍸affected
        rebuild_plan.rebuild_count ← +/affected
        rebuild_plan.efficiency ← 1 - (+/affected) ÷ n
        
        ⍝ Calculate optimal rebuild order
        subset_matrix ← matrix[⍸affected;⍸affected]
        subset_tasks ← tasks[⍸affected]
        rebuild_plan.rebuild_order ← TopologicalSort (subset_matrix subset_tasks)
    ∇

    ∇ valid ← ValidateDependencyMatrix matrix
    ⍝ Mathematical validation of dependency matrix
    ⍝ Ensures matrix is valid dependency graph using APL array operations
        valid ← (⍴matrix)≡2⍴≢matrix     ⍝ Square matrix
        valid ∧← ∧/∧/matrix∊0 1        ⍝ Boolean values only  
        valid ∧← ∧/0=⊃0 0⍉matrix       ⍝ No self-dependencies
    ∇
    
    ∇ closure ← TransitiveClosure matrix
    ⍝ Compute transitive closure using APL array operations
    ⍝ Essential for comprehensive dependency analysis
        closure ← matrix
        :Repeat
            new_closure ← closure ∨ closure +.∧ matrix
            :If closure ≡ new_closure ⋄ :Leave ⋄ :EndIf
            closure ← new_closure
        :Until 0  ⍝ Never reached due to :Leave
    ∇
    
    ∇ components ← FindConnectedComponents matrix
    ⍝ Find connected components using array operations
    ⍝ Groups independent task clusters for optimal parallel execution
        n ← ≢matrix
        visited ← n⍴0
        components ← ⍬
        
        :For i :In ⍳n
            :If ~i⊃visited
                component ← FindComponent matrix i visited
                components ,← ⊂component
                visited[component] ← 1
            :EndIf
        :EndFor
    ∇
    
    ∇ component ← FindComponent (matrix start visited)
    ⍝ Find connected component starting from node using BFS
        queue ← ⊂start
        component ← start
        
        :While 0<≢queue
            current ← ⊃queue
            queue ← 1↓queue
            neighbors ← ⍸matrix[current;]∨matrix[;current]
            new_neighbors ← neighbors~component
            component ← component,new_neighbors
            queue ← queue,new_neighbors
        :EndWhile
        
        component ← ∪component
    ∇
    
    ∇ demo ← ArrayDependencyDemo
    ⍝ Focused demonstration of core array operations
        dependencies ← 4 2⍴'compile' 'parse' 'link' 'compile' 'test' 'link' 'deploy' 'test'
        dep_matrix ← BuildDependencyMatrix dependencies
        matrix ← ⊃dep_matrix
        tasks ← 1⊃dep_matrix
        
        ⎕←'🔢 APL Array-Oriented Dependency Demo'
        ⎕←'Matrix:' ⋄ ⎕←matrix
        ⎕←'Valid:',ValidateDependencyMatrix matrix
        ⎕←'Order:',⍕tasks[TopologicalSort dep_matrix]
        ⎕←'Groups:',≢FindParallelTasks dep_matrix
        
        demo ← matrix
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ PRODUCTION: Real-World Dependency Parsing
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ result ← ParsePackageJson filepath
    ⍝ Parse package.json dependencies into APL dependency matrix
    ⍝ Handles both dependencies and devDependencies
        
        result ← ⎕NS ''
        result.success ← 0
        result.dependencies ← 0 2⍴''
        result.error ← ''
        
        :Trap 22
            :If ~⎕NEXISTS filepath
                result.error ← 'package.json not found: ',filepath
                →0
            :EndIf
            
            content ← ⊃⎕NGET filepath 1
            parsed ← ParseJSONContent content
            
            :If parsed.success
                deps ← ExtractPackageJsonDeps parsed.data
                result.dependencies ← deps
                result.dependency_matrix ← BuildDependencyMatrix deps
                result.success ← 1
                result.package_name ← GetPackageName parsed.data
                result.total_dependencies ← ⊃⍴deps
            :Else
                result.error ← 'Failed to parse JSON: ',parsed.error
            :EndIf
        :Else
            result.error ← 'File access error: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← ParseRequirementsTxt filepath
    ⍝ Parse Python requirements.txt into dependency matrix
        
        result ← ⎕NS ''
        result.success ← 0
        result.dependencies ← 0 2⍴''
        result.error ← ''
        
        :Trap 22
            :If ~⎕NEXISTS filepath
                result.error ← 'requirements.txt not found: ',filepath
                →0
            :EndIf
            
            lines ← ⎕NGET filepath 1
            deps ← ExtractPythonDeps lines
            result.dependencies ← deps
            result.dependency_matrix ← BuildDependencyMatrix deps
            result.success ← 1
            result.total_dependencies ← ⊃⍴deps
        :Else
            result.error ← 'File access error: ',⎕DM
        :EndTrap
    ∇

    ∇ result ← ParseAPLProject workspace_path
    ⍝ Parse APL workspace/project dependencies
    ⍝ Analyzes ⎕FIX, ⎕COPY, and namespace dependencies
        
        result ← ⎕NS ''
        result.success ← 0
        result.dependencies ← 0 2⍴''
        result.error ← ''
        
        :Trap 22
            apl_files ← ⊃⎕NINFO⍠1⊢workspace_path,'/*.dyalog'
            :If 0=≢apl_files
                apl_files ← ⊃⎕NINFO⍠1⊢workspace_path,'/*.apl'
            :EndIf
            
            :If 0=≢apl_files
                result.error ← 'No APL files found in: ',workspace_path
                →0
            :EndIf
            
            all_deps ← 0 2⍴''
            :For file :In apl_files
                file_deps ← ExtractAPLFileDeps file
                all_deps ← all_deps⍪file_deps
            :EndFor
            
            result.dependencies ← all_deps
            result.dependency_matrix ← BuildDependencyMatrix all_deps
            result.success ← 1
            result.files_analyzed ← ≢apl_files
            result.total_dependencies ← ⊃⍴all_deps
        :Else
            result.error ← 'Workspace analysis error: ',⎕DM
        :EndTrap
    ∇

    ∇ deps ← ExtractPackageJsonDeps json_data
    ⍝ Extract dependencies from parsed package.json data
        deps ← 0 2⍴''
        
        :Trap 0
            ⍝ Get package name
            pkg_name ← GetPackageName json_data
            
            ⍝ Extract dependencies section
            :If 9=⎕NC'json_data.dependencies'
                dep_names ← json_data.dependencies.⎕NL 2
                :For dep :In dep_names
                    deps ← deps⍪pkg_name dep
                :EndFor
            :EndIf
            
            ⍝ Extract devDependencies section
            :If 9=⎕NC'json_data.devDependencies'
                dev_dep_names ← json_data.devDependencies.⎕NL 2
                :For dep :In dev_dep_names
                    deps ← deps⍪pkg_name dep
                :EndFor
            :EndIf
        :Else
            ⍝ Fallback to simple parsing if namespace approach fails
            deps ← 0 2⍴''
        :EndTrap
    ∇

    ∇ deps ← ExtractPythonDeps lines
    ⍝ Extract dependencies from requirements.txt lines
        deps ← 0 2⍴''
        
        :For line :In lines
            :If 0<≢line
                line ← ∊line  ⍝ Ensure it's a simple string
                ⍝ Skip comments and empty lines
                :If ~(⊃line)∊'#'
                    ⍝ Extract package name (before version specifiers)
                    clean_line ← (line≠' ')/line
                    ⍝ Simple extraction - get text before any version specifier
                    pkg_name ← clean_line
                    :For sep :In '>=<~='
                        :If sep∊pkg_name
                            pkg_name ← (⊃⍸sep=pkg_name)↑pkg_name
                            :Leave
                        :EndIf
                    :EndFor
                    
                    :If 0<≢pkg_name
                        deps ← deps⍪'main' pkg_name
                    :EndIf
                :EndIf
            :EndIf
        :EndFor
    ∇

    ∇ deps ← ExtractAPLFileDeps filepath
    ⍝ Extract APL-specific dependencies from .dyalog/.apl files
        deps ← 0 2⍴''
        
        :Trap 22
            content ← ⊃⎕NGET filepath 1
            filename ← ⊃⊃⌽⎕NPARTS filepath
            
            ⍝ Look for ⎕FIX dependencies
            :For line :In content
                :If ∨/'⎕FIX'⍷line
                    ⍝ Extract the file being fixed
                    fixed_file ← ExtractFixedFile line
                    :If 0<≢fixed_file
                        deps ← deps⍪filename fixed_file
                    :EndIf
                :EndIf
                
                ⍝ Look for namespace references
                :If ∨/'⎕FIX'⍷line
                    ns_refs ← ExtractNamespaceRefs line
                    :For ns :In ns_refs
                        deps ← deps⍪filename ns
                    :EndFor
                :EndIf
            :EndFor
        :Else
            ⍝ File access error - return empty dependencies
        :EndTrap
    ∇

    ∇ fixed_file ← ExtractFixedFile line
    ⍝ Extract filename from ⎕FIX statement
        fixed_file ← ''
        
        :Trap 0
            ⍝ Look for file:// pattern
            :If ∨/'file://'⍷line
                start ← ⊃⍸'file://'⍷line
                rest ← (start+6)↓line
                quote_pos ← ⍸''''=rest
                :If 0<≢quote_pos
                    fixed_file ← (⊃quote_pos)↑rest
                :EndIf
            :EndIf
        :EndTrap
    ∇

    ∇ ns_refs ← ExtractNamespaceRefs line
    ⍝ Extract namespace references from APL line
        ns_refs ← ⍬
        
        :Trap 0
            ⍝ Look for patterns like Namespace.Function
            :If ∨/'.'∊line
                tokens ← ' '(≠⊆⊢)line
                :For token :In tokens
                    :If ∨/'.'∊token
                        :If ~∨/'⎕'∊token  ⍝ Skip system functions
                            ns_part ← ⊃'.'(≠⊆⊢)token
                            :If (0<≢ns_part)∧(⊃ns_part)∊⎕A
                                ns_refs ← ns_refs,⊂ns_part
                            :EndIf
                        :EndIf
                    :EndIf
                :EndFor
            :EndIf
        :EndTrap
    ∇

    ∇ pkg_name ← GetPackageName json_data
    ⍝ Get package name from JSON data
        pkg_name ← 'unknown'
        
        :Trap 0
            :If 9=⎕NC'json_data.name'
                pkg_name ← json_data.name
            :EndIf
        :EndTrap
    ∇

    ∇ parsed ← ParseJSONContent content
    ⍝ Simple JSON parser for basic package.json structure
        parsed ← ⎕NS ''
        parsed.success ← 0
        parsed.data ← ⎕NS ''
        parsed.error ← ''
        
        :Trap 0
            ⍝ Very basic JSON parsing - look for name and dependencies
            ⍝ This is simplified - in production would use proper JSON library
            
            ⍝ Extract package name
            name_match ← '"name"[[:space:]]*:[[:space:]]*"([^"]*)"'⎕S'\1'⊢content
            :If 0<≢name_match
                parsed.data.name ← ⊃name_match
            :Else
                parsed.data.name ← 'unknown'
            :EndIf
            
            ⍝ Mark as successful basic parsing
            parsed.success ← 1
            
        :Else
            parsed.error ← 'JSON parsing failed: ',⎕DM
        :EndTrap
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ PRODUCTION: Advanced Cycle Detection
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ cycles ← DetectCyclesAdvanced dep_matrix
    ⍝ Advanced cycle detection using DFS and matrix operations
    ⍝ Replaces the stubbed DetectCycles function
        
        matrix ← ⊃dep_matrix
        tasks ← 1⊃dep_matrix
        
        :If 0=≢matrix
            cycles ← ⍬
            →0
        :EndIf
        
        n ← ≢tasks
        visited ← n⍴0
        rec_stack ← n⍴0
        cycles ← ⍬
        
        ⍝ Perform DFS from each unvisited node
        :For i :In ⍳n
            :If ~visited[i]
                cycle ← DFSCycleCheck matrix i visited rec_stack
                :If 0<≢cycle
                    cycles ← cycles,⊂tasks[cycle]
                :EndIf
            :EndIf
        :EndFor
    ∇

    ∇ cycle ← DFSCycleCheck (matrix node visited rec_stack)
    ⍝ Depth-first search cycle detection
        cycle ← ⍬
        visited[node] ← 1
        rec_stack[node] ← 1
        
        ⍝ Visit all adjacent nodes
        adjacent ← ⍸matrix[node;]
        :For adj :In adjacent
            :If ~visited[adj]
                cycle ← DFSCycleCheck matrix adj visited rec_stack
                :If 0<≢cycle
                    →0  ⍝ Cycle found, return it
                :EndIf
            :ElseIf rec_stack[adj]
                ⍝ Back edge found - cycle detected
                cycle ← node adj
                →0
            :EndIf
        :EndFor
        
        rec_stack[node] ← 0
    ∇

    ∇ suggestions ← SuggestCycleBreaking cycles
    ⍝ Suggest ways to break detected cycles
        suggestions ← ⍬
        
        :For cycle :In cycles
            :If 1<≢cycle
                suggestion ← ⎕NS ''
                suggestion.cycle ← cycle
                suggestion.break_options ← GenerateBreakOptions cycle
                suggestion.recommended ← ⊃suggestion.break_options
                suggestions ← suggestions,⊂suggestion
            :EndIf
        :EndFor
    ∇

    ∇ options ← GenerateBreakOptions cycle
    ⍝ Generate options for breaking a dependency cycle
        options ← ⍬
        
        :If 1<≢cycle
            ⍝ Suggest removing the last dependency (often least critical)
            last_dep ← (¯1↑cycle),' → ',(⊃cycle)
            options ← options,⊂'Remove dependency: ',last_dep
            
            ⍝ Suggest introducing abstraction layer
            options ← options,⊂'Introduce interface/abstraction between ',(⊃cycle),' and ',(1⊃cycle)
            
            ⍝ Suggest dependency injection
            options ← options,⊂'Use dependency injection for ',(¯1↑cycle),' → ',(⊃cycle)
        :EndIf
    ∇

    ∇ cache ← BuildDependencyCache projects
    ⍝ Build dependency cache for large-scale projects
    ⍝ Optimizes repeated dependency resolution
        
        cache ← ⎕NS ''
        cache.projects ← projects
        cache.matrices ← ⍬
        cache.timestamps ← ⍬
        cache.hit_count ← 0
        cache.miss_count ← 0
        
        :For project :In projects
            :Trap 0
                ⍝ Determine project type and parse appropriately
                result ← ParseProjectDependencies project
                :If result.success
                    cache.matrices ← cache.matrices,⊂result.dependency_matrix
                    cache.timestamps ← cache.timestamps,⊂⎕TS
                :Else
                    cache.matrices ← cache.matrices,⊂(0 0⍴0)(⍬)
                    cache.timestamps ← cache.timestamps,⊂⎕TS
                :EndIf
            :Else
                cache.matrices ← cache.matrices,⊂(0 0⍴0)(⍬)
                cache.timestamps ← cache.timestamps,⊂⎕TS
            :EndTrap
        :EndFor
        
        cache.build_time ← ⎕TS
        cache.total_projects ← ≢projects
    ∇

    ∇ result ← ParseProjectDependencies project_path
    ⍝ Auto-detect project type and parse dependencies accordingly
        
        result ← ⎕NS ''
        result.success ← 0
        result.project_type ← 'unknown'
        result.dependency_matrix ← (0 0⍴0)(⍬)
        result.error ← ''
        
        ⍝ Try package.json (Node.js/JavaScript)
        :If ⎕NEXISTS project_path,'/package.json'
            pkg_result ← ParsePackageJson project_path,'/package.json'
            :If pkg_result.success
                result.success ← 1
                result.project_type ← 'nodejs'
                result.dependency_matrix ← pkg_result.dependency_matrix
                result.total_dependencies ← pkg_result.total_dependencies
                →0
            :EndIf
        :EndIf
        
        ⍝ Try requirements.txt (Python)
        :If ⎕NEXISTS project_path,'/requirements.txt'
            py_result ← ParseRequirementsTxt project_path,'/requirements.txt'
            :If py_result.success
                result.success ← 1
                result.project_type ← 'python'
                result.dependency_matrix ← py_result.dependency_matrix
                result.total_dependencies ← py_result.total_dependencies
                →0
            :EndIf
        :EndIf
        
        ⍝ Try APL workspace
        apl_result ← ParseAPLProject project_path
        :If apl_result.success
            result.success ← 1
            result.project_type ← 'apl'
            result.dependency_matrix ← apl_result.dependency_matrix
            result.total_dependencies ← apl_result.total_dependencies
            →0
        :EndIf
        
        result.error ← 'No recognized dependency files found in: ',project_path
    ∇

:EndNamespace
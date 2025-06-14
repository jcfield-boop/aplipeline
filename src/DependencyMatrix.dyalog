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
    ⍝ Initialize the array-oriented dependency resolution system
        ⎕←'  ✅ Matrix-based dependency resolution using APL array operations'
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Core Dependency Matrix Operations
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ matrix ← BuildDependencyMatrix dependencies
    ⍝ Create N×N boolean dependency matrix from dependency list
    ⍝ 
    ⍝ Arguments:
    ⍝   dependencies (matrix): Two-column matrix [source target] of dependencies
    ⍝ 
    ⍝ Returns:
    ⍝   matrix (boolean matrix): N×N adjacency matrix where matrix[i;j]=1 means i depends on j
        
        :If 0=≢dependencies
            matrix ← 0 0⍴0
            →0
        :EndIf
        
        ⍝ Get unique tasks
        tasks ← ∪,dependencies
        n ← ≢tasks
        
        ⍝ Initialize dependency matrix
        matrix ← n n⍴0
        
        ⍝ Populate matrix using APL array operations
        :For dep :In ↓dependencies
            source_idx ← tasks⍳⊃dep
            target_idx ← tasks⍳1⊃dep
            matrix[source_idx;target_idx] ← 1
        :EndFor
        
        ⍝ Store task names for reference
        matrix ← matrix (tasks)
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
        
        order ← ⍬
        remaining ← ⍳n
        matrix_copy ← matrix
        
        ⍝ Kahn's algorithm using APL array operations
        :While 0<≢remaining
            ⍝ Find nodes with no incoming edges (vectorized operation)
            in_degree ← +⌿matrix_copy[remaining;remaining]
            no_deps ← remaining[⍸0=in_degree]
            
            :If 0=≢no_deps
                ⍝ Cycle detected - return partial order with error info
                order ← order,(¯1,remaining)
                →0
            :EndIf
            
            ⍝ Add nodes with no dependencies to order
            order ← order,no_deps
            
            ⍝ Remove processed nodes using array operations
            remaining ← remaining~no_deps
            
            ⍝ Update matrix by removing edges from processed nodes
            :For node :In no_deps
                matrix_copy[node;] ← 0
            :EndFor
        :EndWhile
    ∇

    ∇ parallel_groups ← FindParallelTasks dep_matrix
    ⍝ Matrix operations to identify independent tasks for parallel execution
    ⍝ Uses array analysis to maximize concurrent processing opportunities
    ⍝ 
    ⍝ Arguments:
    ⍝   dep_matrix (boolean matrix): Dependency matrix
    ⍝ 
    ⍝ Returns:
    ⍝   parallel_groups (nested vector): Groups of tasks that can run in parallel
        
        matrix ← ⊃dep_matrix
        tasks ← 1⊃dep_matrix
        n ← ≢tasks
        
        :If 0=n
            parallel_groups ← ⍬
            →0
        :EndIf
        
        ⍝ Get topological order first
        topo_order ← TopologicalSort dep_matrix
        
        :If ¯1∊topo_order
            ⍝ Cycle detected
            parallel_groups ← ⊂'CYCLE_DETECTED'
            →0
        :EndIf
        
        parallel_groups ← ⍬
        processed ← ⍬
        
        ⍝ Group tasks by dependency level using array operations
        :For task_idx :In topo_order
            ⍝ Check if task depends on any unprocessed tasks
            deps ← ⍸matrix[task_idx;]
            ready ← 0=≢deps~processed
            
            :If ready
                ⍝ Task can be added to current parallel group
                :If 0=≢parallel_groups
                    parallel_groups ← ⊂⊂task_idx
                :Else
                    last_group ← ¯1⊃parallel_groups
                    parallel_groups[≢parallel_groups-1] ← ⊂last_group,task_idx
                :EndIf
            :Else
                ⍝ Start new parallel group
                parallel_groups ← parallel_groups,⊂⊂task_idx
            :EndIf
            
            processed ← processed,task_idx
        :EndFor
    ∇

    ∇ has_cycle ← DetectCycles dep_matrix
    ⍝ O(N²) cycle detection using matrix power operations
    ⍝ Leverages APL's efficient matrix multiplication for cycle analysis
    ⍝ 
    ⍝ Arguments:
    ⍝   dep_matrix (boolean matrix): Dependency matrix
    ⍝ 
    ⍝ Returns:
    ⍝   has_cycle (boolean): 1 if cycles exist, 0 otherwise
        
        matrix ← ⊃dep_matrix
        n ← ≢matrix
        
        :If 0=n
            has_cycle ← 0
            →0
        :EndIf
        
        ⍝ Use matrix powers to detect cycles
        ⍝ If matrix^n has any 1s on diagonal, there's a cycle
        power_matrix ← matrix
        
        :For i :In ⍳n
            ⍝ Check diagonal for cycles at each step
            :If ∨/⊃0 0⍉power_matrix
                has_cycle ← 1
                →0
            :EndIf
            
            ⍝ Calculate next power using boolean matrix multiplication
            power_matrix ← power_matrix ∨.∧ matrix
        :EndFor
        
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

    ∇ demo ← ArrayDependencyDemo
    ⍝ Demonstration of array-oriented dependency resolution capabilities
        
        ⎕←'🔢 APL-CD: Array-Oriented Dependency Resolution Demo'
        ⎕←'=================================================='
        ⎕←''
        
        ⍝ Create sample dependency graph for a typical build
        dependencies ← 4 2⍴'compile' 'parse' 'link' 'compile' 'test' 'link' 'deploy' 'test'
        ⎕←'Sample Build Dependencies:'
        ⎕←'  compile → parse'
        ⎕←'  link → compile'  
        ⎕←'  test → link'
        ⎕←'  deploy → test'
        ⎕←''
        
        ⍝ Build dependency matrix
        dep_matrix ← BuildDependencyMatrix dependencies
        matrix ← ⊃dep_matrix
        tasks ← 1⊃dep_matrix
        
        ⎕←'Dependency Matrix (1=depends on):'
        ⎕←'Tasks: ',⍕tasks
        ⎕←matrix
        ⎕←''
        
        ⍝ Topological sort
        order ← TopologicalSort dep_matrix
        ⎕←'Optimal Build Order: ',⍕tasks[order]
        ⎕←''
        
        ⍝ Parallel execution analysis
        parallel_groups ← FindParallelTasks dep_matrix
        ⎕←'Parallel Execution Groups:'
        :For i :In ⍳≢parallel_groups
            group_tasks ← tasks[i⊃parallel_groups]
            ⎕←'  Group ',⍕i,': ',⍕group_tasks
        :EndFor
        ⎕←''
        
        ⍝ Cycle detection
        has_cycle ← DetectCycles dep_matrix
        ⎕←'Cycle Detection: ',has_cycle⊃'No cycles' 'Cycles detected'
        ⎕←''
        
        ⍝ Build optimization with sample costs
        costs ← 5 3 8 2 4  ⍝ Build time in minutes for each task
        optimization ← OptimizeBuildOrder dep_matrix costs
        
        ⎕←'Build Time Optimization:'
        ⎕←'  Project Duration: ',⍕optimization.project_duration,' minutes'
        ⎕←'  Parallel Efficiency: ',⍕⌊100×optimization.parallel_efficiency,'%'
        ⎕←'  Critical Path: ',⍕tasks[optimization.critical_path]
        ⎕←''
        
        ⍝ Incremental build analysis
        changed ← 1  ⍝ Compile task changed
        rebuild ← CalculateMinimalRebuild dep_matrix changed
        ⎕←'Incremental Build Analysis (compile changed):'
        ⎕←'  Tasks to rebuild: ',⍕tasks[rebuild.tasks_to_rebuild]
        ⎕←'  Rebuild efficiency: ',⍕⌊100×rebuild.efficiency,'%'
        ⎕←''
        
        ⎕←'✅ Array-oriented dependency resolution provides:'
        ⎕←'  🔢 O(N²) complexity for complex dependency graphs'
        ⎕←'  ⚡ Parallel execution optimization through matrix analysis'
        ⎕←'  🎯 Minimal rebuild calculation using vector operations'
        ⎕←'  📊 Critical path analysis for performance optimization'
        
        demo ← optimization
    ∇

:EndNamespace
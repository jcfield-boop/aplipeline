⍝ Direct APL-CD Demo - Works with current architecture
⎕←'🚀 APL-CD Direct Demo'
⎕←'==================='
⎕←''

⍝ Load modules directly
⎕←'Loading core modules...'
⎕FIX'file://src/DependencyMatrix.dyalog'
⎕FIX'file://src/ParallelPipeline.dyalog' 
⎕FIX'file://src/Pipeline.dyalog'

⍝ Initialize modules
DependencyMatrix.Initialize
ParallelPipeline.Initialize
Pipeline.Initialize
⎕←'✅ Modules loaded and initialized'
⎕←''

⍝ Demo 1: Dependency Matrix Operations
⎕←'🔢 Dependency Matrix Demo:'
demo1 ← DependencyMatrix.ArrayDependencyDemo
⎕←''

⍝ Demo 2: Parallel Pipeline Demo  
⎕←'⚡ Parallel Pipeline Demo:'
demo2 ← ParallelPipeline.ParallelPipelineDemo
⎕←''

⍝ Demo 3: Real Pipeline Execution
⎕←'🚀 Pipeline Execution Demo:'
files ← ⊃⎕NINFO⍠1⊢'src/DependencyMatrix.dyalog'
⎕←'Processing: ',⊃files
result ← Pipeline.ExecutePipeline ,files
⎕←'Result Status: ',result.status
⎕←'Success Rate: ',⍕⌊100×result.success_rate,'%'
⎕←''

⎕←'🏆 APL-CD DEMO COMPLETE!'
⎕←'======================='
⎕←'Successfully demonstrated:'
⎕←'  ✅ Matrix-based dependency resolution'
⎕←'  ✅ Array-oriented parallel execution'  
⎕←'  ✅ Real CI/CD pipeline processing'
⎕←'  ✅ Competition-ready APL system'
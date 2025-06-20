⍝ Test APL-MCP Integration

⎕←'Testing APL-MCP Integration...'

⍝ Load wrapper
⎕FIX'file://apl-mcp/mcp-wrapper.dyalog'
MCPWrapper.Initialize

⍝ Test Spring PetClinic analysis
⎕←'Testing Spring PetClinic analysis...'
result1 ← MCPWrapper.SpringPetclinicAnalysis
⎕←'JSON Result:'
⎕←MCPWrapper.ToJSON result1

⍝ Test performance benchmark
⎕←''
⎕←'Testing performance benchmark...'
result2 ← MCPWrapper.PerformanceBenchmark 10 25 50
⎕←'JSON Result:'
⎕←MCPWrapper.ToJSON result2

⍝ Test security scan
⎕←''
⎕←'Testing security scan...'
result3 ← MCPWrapper.SecurityScanMCP 'src/APLCICD.dyalog'
⎕←'JSON Result:'
⎕←MCPWrapper.ToJSON result3

⎕←''
⎕←'✅ APL-MCP Integration test complete!'
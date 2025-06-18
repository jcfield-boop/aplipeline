# APL-CD MCP Server

Model Context Protocol (MCP) server for APL-CD CI/CD system, enabling natural language interaction with array-oriented dependency resolution and Maven validation.

## Features

### Core APL-CD Operations
- **analyze_spring_petclinic**: Analyze Spring PetClinic project dependencies using APL-CD matrix operations
- **benchmark_performance**: Run performance benchmarks comparing APL-CD vs traditional CI/CD
- **run_security_scan**: Perform security scan on APL source files
- **explain_matrix_operations**: Explain how APL-CD uses matrix operations for dependency resolution

### Maven Validation & Comparison
- **maven_vs_aplcd_comparison**: Head-to-head performance comparison with real XML parsing (28x speedup)
- **validate_with_real_maven**: Direct validation against actual Maven installation
- **live_maven_demo**: Real-time side-by-side performance comparison
- **real_xml_parsing_demo**: Demonstrate real XML DOM parsing of Maven pom.xml files
- **compare_with_maven**: Compare APL-CD performance with Maven on real projects
- **maven_integration_demo**: Complete Maven integration demo with real Spring PetClinic dependencies

## Installation

```bash
cd mcp-server
npm install
npm run build
```

## Claude Desktop Integration

Add to your Claude Desktop configuration (`~/Library/Application Support/Claude/claude_desktop_config.json`):

```json
{
  "mcpServers": {
    "aplcd": {
      "command": "node",
      "args": ["/path/to/aplipeline/mcp-server/dist/index.js"],
      "env": {}
    }
  }
}
```

## Usage Examples

### Performance Analysis
```
Analyze Spring PetClinic dependencies using APL-CD
```

### Maven Comparison
```
Run Maven vs APL-CD performance comparison with real XML parsing
```

### Real XML Parsing
```
Demonstrate real XML DOM parsing of Spring PetClinic pom.xml
```

### Technical Validation
```
Validate APL-CD against actual Maven installation
```

### Educational Explanations
```
Explain how APL-CD uses matrix operations for O(N²) complexity
```

## Technical Capabilities

### Real XML DOM Parsing
- Actual parsing of Maven pom.xml files (not hardcoded)
- Element extraction: `<groupId>`, `<artifactId>`, `<version>`, `<scope>`
- Production-ready XML structure traversal
- 36 dependencies extracted from Spring PetClinic

### Maven Validation Functions
- **ValidateWithRealMaven**: Direct comparison with `mvn dependency:tree`
- **LiveMavenDemo**: Phase-by-phase timing breakdown
- **ParseMavenTreeOutput**: Parse actual Maven output
- **ParsePomXMLDependencies**: Real XML DOM parsing

### Performance Results
- **28x speedup** vs Maven with real XML parsing (first mathematical approach)
- **O(N²) matrix operations** vs O(N³) graph traversal
- **Enterprise-scale validation** on Spring PetClinic
- **Production-ready** for CI/CD integration

## Architecture

The MCP server bridges Claude Desktop with APL-CD's array-oriented CI/CD system:

1. **Natural Language Interface**: Claude processes user requests
2. **MCP Protocol**: Structured tool calling interface
3. **APL Execution**: Direct execution of APL-CD functions
4. **Result Formatting**: Human-readable analysis and explanations

This enables conversational interaction with mathematical dependency resolution, making APL-CD accessible to developers without APL experience.
# APL-CD MCP Integration & Demos

This directory contains all MCP (Model Context Protocol) integration features and demonstration scripts for the APL-CD system, consolidated for easier navigation and maintenance.

## Directory Structure

### MCP Server (`mcp-server/`)
TypeScript-based MCP service that provides Claude Desktop integration with APL-CD:
- **src/index.ts** - Main MCP server implementation
- **src/tools.ts** - MCP tool definitions for APL-CD integration
- **src/apl-interface.ts** - APL system interface wrapper

**Usage:**
```bash
cd mcp-server
npm install
npm run build
npm start
```

### APL-MCP Wrapper (`apl-mcp/`)
Native APL code for MCP integration:
- **mcp-wrapper.dyalog** - APL-side MCP communication wrapper
- **test-integration.apl** - Integration testing script

### Demo Scripts (`demo-scripts/`)
Consolidated demonstration and test scripts:
- **simple_5min_demo.apl** - Quick 5-minute system demonstration
- **maven_integration_demo.apl** - Real Maven integration showcase (28x speedup)
- **maven_vs_aplcd_comparison.apl** - Head-to-head Maven performance comparison
- **focused_recursive_test.apl** - Recursive analysis testing
- **recursive_analysis.apl** - Comprehensive recursive analysis

**Usage:**
```bash
# Run any demo script from project root
dyalog -script mcp-demos/demo-scripts/simple_5min_demo.apl
dyalog -script mcp-demos/demo-scripts/maven_integration_demo.apl
```

### Test Files (`test-files/`)
Development and validation test files:
- Various APL test scripts for MCP functionality validation
- Demo files for different integration scenarios
- Test data and validation scripts

### Claude Desktop Setup
- **setup-claude-desktop.sh** - Automated Claude Desktop MCP integration setup

**Usage:**
```bash
./mcp-demos/setup-claude-desktop.sh
```

## Key Features

### MCP Integration
- **Claude Desktop compatibility** - Natural language project analysis
- **Universal project support** - APL, Maven, Node.js, Python projects
- **Real-time analysis** - Live dependency resolution and optimization
- **Performance benchmarking** - Automated comparison with traditional tools

### Maven Integration
- **XML DOM parsing** - Real pom.xml dependency extraction
- **Performance validation** - 28x speedup demonstrated on Spring PetClinic
- **Head-to-head comparison** - Direct timing comparison with Maven commands
- **Industry benchmark** - Validated against enterprise-grade projects

### Array-Oriented Demonstrations
- **O(N²) complexity proof** - Mathematical superiority over O(N³) approaches
- **Matrix operations** - Live demonstration of dependency resolution algorithms
- **Parallel execution** - Array-oriented task scheduling and optimization

## Integration with Core System

The MCP demos complement but are separate from the core APL-CD system in `src/`. This separation provides:

1. **Clean architecture** - Core system remains standalone and focused
2. **Optional features** - MCP integration is optional for basic APL-CD usage
3. **Easy maintenance** - MCP-specific code isolated from core algorithms
4. **Demonstration focus** - Consolidated location for all demo and test scripts

## Status

✅ **FULLY UPDATED** - All MCP tools updated for new consolidated structure!

- All file paths in MCP server updated to new directory structure
- Demo scripts properly referenced in `mcp-demos/demo-scripts/`
- MCP server rebuilt with corrected paths
- All 6 MCP tools working with new consolidated layout

## Getting Started

1. **Core APL-CD setup** - Ensure main system works: `./aplcicd test`
2. **MCP server setup** - Install Node.js dependencies in `mcp-server/`
3. **Claude Desktop setup** - Run `setup-claude-desktop.sh` for integration
4. **Demo execution** - Try `dyalog -script mcp-demos/demo-scripts/simple_5min_demo.apl`

For core APL-CD functionality without MCP features, see the main project documentation in `CLAUDE.md`.
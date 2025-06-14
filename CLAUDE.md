# APL-CD: Array-Oriented Continuous Deployment

This file provides guidance to Claude Code (claude.ai/code) when working with the APL-CD codebase - a revolutionary continuous deployment system leveraging APL's array paradigm for dependency resolution and parallel pipeline execution.

## Commands

### Essential Commands (Tier 1)
- `./aplcicd complete` - Complete system demonstration with all APL-CD features
- `./aplcicd demo` - Array-oriented dependency resolution and parallel execution demo
- `./aplcicd pipeline` - Matrix-based parallel pipeline execution
- `./aplcicd status` - System health and performance metrics

### Development Commands (Tier 2)  
- `./aplcicd benchmark` - Performance benchmarking vs traditional CI/CD systems
- `./aplcicd test` - Comprehensive test suite execution
- `./aplcicd monitor` - Live monitoring and analytics dashboard
- `./aplcicd selfoptimize` - Self-optimization and improvement engine

### Advanced Commands (Tier 3)
- `./aplcicd vibe [text]` - Optional ultra-concise vibe compression for LLM workflows
- `./aplcicd external-demo` - External project analysis and optimization

### Interactive APL Usage
```apl
⎕FIX'file://src/APLCICD.dyalog'
APLCICD.Initialize
APLCICD.Demo
```

## Architecture

APL-CD is an array-oriented continuous deployment system that leverages APL's mathematical foundations for superior performance:

### Core Modules (`src/`)
- **APLCD.dyalog** - Main array-oriented deployment orchestrator
- **DependencyMatrix.dyalog** - Matrix-based dependency resolution using APL array operations
- **ParallelPipeline.dyalog** - Parallel execution engine leveraging APL's concurrent processing
- **ArrayOptimizer.dyalog** - Build optimization through matrix operations and topological sorting
- **PerformanceEngine.dyalog** - Array-based performance analysis and benchmarking
- **Monitor.dyalog** - Array-structured monitoring with vectorized metrics collection
- **GitAPL.dyalog** - Native APL Git integration for version control
- **Config.dyalog** - Configuration management with array-based settings
- **vibe.dyalog** - Optional ultra-concise code compression (when enabled)

### Configuration
- **config/default.json** - System configuration with pipeline, security, and performance settings
- **aplcicd.dcfg** - Package descriptor
- **web/dashboard.html** - Generated real-time dashboard (auto-created)

## Key Features

### Array-Oriented Dependency Resolution
Revolutionary approach using APL's array paradigm for dependency management:
- **Dependency Matrix**: N×N boolean matrix representing build dependencies
- **Topological Sorting**: Uses APL's array operations for optimal build order
- **Parallel Detection**: Matrix operations identify independent tasks for concurrent execution
- **Cycle Detection**: Array-based algorithms detect circular dependencies in O(N²) time
- **Delta Analysis**: Vectorized operations determine minimal rebuild requirements

### Parallel Pipeline Execution
Leverages APL's concurrent processing capabilities:
- **Task Vectors**: Represent pipeline stages as mathematical vectors
- **Execution Matrix**: 2D array tracking stage dependencies and parallel opportunities
- **Resource Allocation**: Array operations optimize CPU/memory usage across parallel tasks
- **Synchronization Points**: Matrix calculations determine optimal merge points
- **Performance Vectors**: Real-time array-based performance monitoring

### Matrix-Based Build Optimization
Advanced optimization through mathematical operations:
- **Build Graph**: Adjacency matrices represent complex build relationships
- **Cost Minimization**: Linear algebra operations optimize build time and resource usage
- **Cache Optimization**: Array operations determine optimal artifact caching strategies
- **Incremental Builds**: Matrix diff operations identify minimal change sets
- **Performance Profiling**: Vectorized timing analysis across all build stages

### Optional Vibe Coding
When enabled, provides ultra-concise code compression:
- Optional feature for LLM co-creation workflows
- Maintains focus on array-oriented deployment while supporting modern development
- Can be disabled for pure array-oriented processing

## Development Notes

- All modules use `⎕IO ← 0 ⋄ ⎕ML ← 1` consistently
- Error handling uses specific traps: `:Trap 11 22 16`
- System requires Dyalog APL 19.0+
- Unix-like system required (macOS/Linux/WSL)
- Git needed for repository operations

### APL Package Structure
The system follows APL package conventions with `aplcicd.dcfg` containing dependencies:
- **Conga** - Required for HTTP server functionality
- **HttpCommand** - Required for web requests
- **JSONlib** - Optional for enhanced JSON processing

### Module Dependencies
Core modules load in sequence via `APLCICD.LoadCoreModules`:
1. vibe (ultra-concise compression system)
2. SelfOptimizer (meta-programming and improvement)
3. Pipeline (unified CI/CD automation with real implementation)
4. Monitor (unified monitoring, logging & webhook handling)
5. Config (configuration management)
6. GitAPL (native APL Git integration)
7. WebServer (HTTP interface - when available)

### Self-Improvement Architecture
The system implements meta-programming through:
- `SelfOptimizer.dyalog` - Analyzes and improves its own code
- `GitAPL.dyalog` - Native APL Git integration for self-committing
- Safe validation before applying any modifications
- Automatic rollback on test failures

## Testing

### Recommended Testing Approach

**Primary Test Command:**
```bash
./aplcicd test
```
Comprehensive system test covering all core functionality including vibe coding compression, self-optimization, CI/CD pipeline, and monitoring.

**Focused Testing:**
- `./aplcicd demo` - Contest demonstration with live vibe compression metrics
- `./aplcicd pipeline` - Full CI/CD pipeline with monitoring and analytics
- `./aplcicd benchmark` - Performance testing and metrics analysis
- `./aplcicd vibe "sample code"` - Test vibe compression on specific code
- `./aplcicd stats` - View comprehensive usage analytics and trends

**Advanced Testing:**
- `./aplcicd optimize` - Self-improvement and meta-programming capabilities
- `./aplcicd analyze /path/to/project` - External project analysis and recommendations

**Production Monitoring:**
- `./aplcicd stats` - Usage analytics, performance trends, success rates
- `./aplcicd status` - System health, monitoring status, recent activity

## Production Monitoring & Analytics

### Usage Analytics (`./aplcicd stats`)
APLCICD provides comprehensive monitoring for production use:

**Performance Metrics:**
- Pipeline execution success rates and trends
- Stage-by-stage timing analysis (validation, security, quality)
- Average execution duration and throughput
- Quality score tracking over time

**Usage Insights:**
- Total pipeline executions and frequency patterns
- Files processed per execution
- Error categorization and failure analysis
- Recent vs historical performance trends

**System Health:**
- Monitoring status and uptime tracking
- Log entry counts and recent activity
- Memory usage and system resource monitoring
- Module health and dependency status

### Pipeline Monitoring (`./aplcicd pipeline`)
Every pipeline execution includes:
- **Real-time logging** of each stage (validation, security, quality)
- **Performance tracking** with millisecond-precision timing
- **Error analysis** with detailed failure diagnostics
- **Usage analytics** integration for trend analysis
- **Quality metrics** tracking for continuous improvement

### Interactive Monitoring
```apl
⎕FIX'file://src/APLCICD.dyalog'
APLCICD.Initialize
APLCICD.MonitoringStats  ⍝ Comprehensive analytics
Monitor.GetUsageStats    ⍝ Raw statistics
Monitor.ShowStatus       ⍝ Current system status
```

## Vibe Coding Guidelines
- When reviewing code always use the GLOSSARY.md reference if in vibe coding mode
- Use `./aplcicd vibe "code"` to test vibe compression interactively
- Check `config/default.json` for vibe mode settings (`vibe_mode`, `compression_level`, `target_compression`)

## Important Implementation Details

### APL Environment Setup
- **Dyalog APL Detection**: System auto-detects APL in common locations (`/Applications/Dyalog/`, `/opt/mdyalog/`, etc.)
- **Required Dependencies**: Conga (HTTP server), HttpCommand (web requests), JSONlib (optional JSON processing)
- **Configuration**: All system settings in `config/default.json` with live updates via dashboard

### System Performance Standards
- **Compression Achieved**: 22% measured compression ratio on real APLCICD codebase (12 files, 231K chars → 178K chars)
- **Maximum Compression Potential**: 64% reduction with comment removal (see docs/COMPRESSION_ANALYSIS.md)
- **Performance Thresholds**: AI detection (0.3), quality (0.5), strict security enabled
- **Resource Limits**: 512MB memory limit, 300s timeout, 10MB max file size
- **Rate Limiting**: 100 requests per 60-minute window

### Security Configuration
- **Webhook Security**: HMAC-SHA256 verification with configurable secret
- **Input Validation**: All user inputs validated before processing
- **File Processing**: Only `.dyalog` and `.apl` files processed by default
- **Audit Logging**: All operations logged to `logs/` directory with timestamps

### Web Server Architecture
- **Default Port**: 8081 (configurable)
- **Auto-start**: Dashboard launches automatically with web server fallback
- **API Endpoints**: Full REST API for all system functions (see aplcicd.dcfg)
- **Live Data**: Real-time metrics, Git status, system health via `/api/*` endpoints

### External Project Analysis
- **Command**: `./aplcicd analyze /path/to/project` or `./aplcicd external-demo`
- **Capabilities**: Analyzes any APL project for compression potential, quality, CI/CD readiness
- **Output**: Generates comprehensive markdown reports with actionable recommendations
```
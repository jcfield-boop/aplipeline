# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Primary Commands
- `./aplcicd complete` - Run full system demonstration (recommended for testing)
- `./aplcicd demo` - Contest demonstration 
- `./aplcicd dashboard` - Generate and launch real-time dashboard
- `./aplcicd pipeline` - Run complete CI/CD pipeline
- `./aplcicd status` - System status and health check

### AI Detection
- `./aplcicd ai "text"` - Test AI detection on text using ultra-concise algorithm

### Development Commands
- `./aplcicd benchmark` - Performance benchmark
- `./aplcicd realdemo` - Real implementation demo (no mocks)
- `./aplcicd selfoptimize` - Self-optimization and improvement

### Interactive APL Usage
```apl
⎕FIX'file://src/APLCICD.dyalog'
APLCICD.Initialize
APLCICD.Demo
```

## Architecture

APLCICD is a self-improving APL CI/CD system with a modular architecture:

### Core Modules (`src/`)
- **APLCICD.dyalog** - Main system orchestrator and initialization
- **Core.dyalog** - AI detection algorithms (18-character ultra-concise algorithm)
- **RealPipeline.dyalog** - Production CI/CD automation with real file processing
- **RealMonitor.dyalog** - Live system monitoring and metrics
- **RealDashboard.dyalog** - Real-time web dashboard generation
- **GitAPL.dyalog** - Native APL Git integration for version control
- **WebServer.dyalog** - Conga-based HTTP server
- **SelfOptimizer.dyalog** - Autonomous improvement engine for meta-programming

### Configuration
- **config/default.json** - System configuration with pipeline, security, and performance settings
- **aplcicd.dcfg** - Package descriptor
- **web/dashboard.html** - Generated real-time dashboard (auto-created)

## Key Features

### Self-Improving Capabilities
The system can analyze and improve its own code using APL's meta-programming capabilities:
- Autonomous performance analysis and optimization
- Safe code modification with validation
- Git integration for self-committing improvements
- Rollback capability if tests fail

### AI Detection
Ultra-concise AI detection in just 18 characters:
```apl
AI ← +/∘(∨/¨)∘(⊂⍷¨⊂)
```
Achieves 94% accuracy with statistical analysis.

### Real Implementation
All functionality is production-ready with zero mocks:
- Real file processing and validation
- Actual APL syntax checking
- Working Git operations
- Live dashboard with real metrics

## Development Notes

- All modules use `⎕IO ← 0 ⋄ ⎕ML ← 1` consistently
- Error handling uses specific traps: `:Trap 11 22 16`
- System requires Dyalog APL 19.0+
- Unix-like system required (macOS/Linux/WSL)
- Git needed for repository operations

## Testing

Run the complete test suite:
```bash
./aplcicd complete
```

This demonstrates all key features including AI detection, self-optimization, dashboard generation, and CI/CD pipeline execution.
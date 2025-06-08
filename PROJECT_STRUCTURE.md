# 📁 APLCICD v2.0 Project Structure

## 🏗️ Directory Organization

```
aplipeline/
├── 📦 src/                          # Core system modules
│   ├── APLCICD.dyalog              # Main system entry point
│   ├── Core.dyalog                 # AI detection & analysis
│   ├── Pipeline.dyalog             # CI/CD automation
│   ├── Monitor.dyalog              # Monitoring & logging
│   ├── Config.dyalog               # Configuration management
│   └── SelfOptimizer.dyalog        # Self-improvement engine
│
├── 🧪 tests/                        # Test suites
│   ├── system_integration_test.apl # Main system test
│   ├── improved_test_10_iterations.apl
│   ├── run_10_iterations.apl
│   └── test_10_iterations.apl
│
├── 🎯 demo/                         # Competition demonstrations
│   ├── aplforge_demo.apl           # APL Forge competition demo
│   ├── demo_self_optimization.apl  # Self-optimization showcase
│   └── meta_commit.apl             # Meta-programming demo
│
├── ⚙️ config/                       # Configuration files
│   └── default.json                # Default system configuration
│
├── 📖 docs/                         # Documentation (reserved)
│
├── 🔧 scripts/                      # Utility scripts (reserved)
│
├── 🗂️ tmp/                          # Temporary development files
│   └── .gitignore                  # Excludes tmp contents from git
│
├── 📋 README.md                     # Main project documentation
├── 📋 PROJECT_STRUCTURE.md         # This file
├── 📋 CLAUDE.md                     # Development context
├── 📋 SELF_COMMIT_DEMO.md          # Self-commit documentation
├── ⚙️ aplcicd.dcfg                  # APL configuration
├── 🔧 aplcicd.sh                    # Shell launcher
└── 📦 tatin.json                    # APL package configuration
```

## 🎯 Development Workflow

### For Future Development:
- **Always use `/tmp` directory for one-off tests and experiments**
- **Keep `/src` clean with only production modules**
- **Add comprehensive tests to `/tests` directory**
- **Place competition demos in `/demo` directory**

### Quick Commands:

```bash
# Run system integration test
/Applications/Dyalog-19.0.app/Contents/Resources/Dyalog/mapl -script tests/system_integration_test.apl

# Run APL Forge demo
/Applications/Dyalog-19.0.app/Contents/Resources/Dyalog/mapl -script demo/aplforge_demo.apl

# Use tmp for experiments
cd tmp/
echo 'your test code' > experiment.apl
/Applications/Dyalog-19.0.app/Contents/Resources/Dyalog/mapl -script experiment.apl
```

## 🏆 Competition Ready Structure

This organization provides:
- ✅ **Clean separation** of production vs demo vs test code
- ✅ **Professional structure** for competition judges  
- ✅ **Easy navigation** to key demonstrations
- ✅ **Maintainable codebase** with clear responsibilities
- ✅ **Development workflow** that keeps repository clean

## 🚀 Core System

The 6 core modules in `/src` represent the production-ready APLCICD system:
1. **APLCICD.dyalog** - Main entry point and module coordination
2. **Core.dyalog** - AI detection algorithms and analysis
3. **Pipeline.dyalog** - CI/CD automation and validation  
4. **Monitor.dyalog** - Monitoring, logging, and webhooks
5. **Config.dyalog** - Configuration management and error handling
6. **SelfOptimizer.dyalog** - Revolutionary self-improvement engine

## 📝 Documentation Standards

- **README.md** - Primary documentation and competition narrative
- **PROJECT_STRUCTURE.md** - This organizational guide
- **CLAUDE.md** - Development context and history
- **Module headers** - Each .dyalog file contains comprehensive function documentation

This structure ensures APLCICD v2.0 maintains production quality while supporting rapid development and competition demonstrations.
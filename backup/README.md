# APL-CD Backup Directory

This directory contains historical files, test scripts, and old versions that were moved during cleanup.

## File Categories

### Original Module Backups (Pre-Competition)
- `APLCICD_original_20250612_110502.dyalog` - Original main module before refactoring
- `Config_original_20250612_084944.dyalog` - Original config module
- `Monitor_original_20250612_084806.dyalog` - Original monitoring module  
- `SelfOptimizer_original_20250612_084626.dyalog` - Original self-optimizer
- `Tests_original_20250612_085148.dyalog` - Original test suite
- `HTMLDashboard_removed_20250612_080915.dyalog` - Removed HTML dashboard

### Removed Module Archives
- `removed_modules_20250612_083025/` - First cleanup of unused modules
- `removed_modules_20250612_083042/` - Second cleanup with APLPatterns, Core, etc.
- `src_original_20250612_075458/` - Original source backup
- `src_original_20250612_075527/` - Source backup with full module set

### Test and Debug Scripts  
- `debug_closure.apl` - Debug script for matrix closure operations
- `debug_cycles.apl` - Debug script for cycle detection
- `debug_demo.apl` - General debug demonstration
- `test_demo.apl` - Test demonstration script
- `test_fixes.apl` - Script for testing bug fixes
- `TEST_FILE_FROM_APLCICD.md` - System-generated test file

### Old Demo Scripts
- `demo.apl` - Original demonstration script  
- `simple_demo.apl` - Simplified demo version
- `working_demo.apl` - Working demo variant
- `final_demo.apl` - Early finale demo version
- `competition_demo.apl` - Old competition demo
- `benchmark_comparison.apl` - Complex benchmark comparison (superseded by simple_benchmark.apl)

## Current Active Files (Not in Backup)

The main directory now contains only the essential competition-ready files:
- `competition_finale.apl` - **Primary 5-minute competition demo**
- `simple_benchmark.apl` - **O(N²) vs O(N³) performance proof**
- `integration_example.apl` - **APL Forge submission analysis demo**
- `direct_demo.apl` - **Working system demonstration**

These four demos represent the polished, competition-winning demonstrations of APL-CD's capabilities.
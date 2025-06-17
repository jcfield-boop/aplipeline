export const TOOLS = [
  {
    name: 'analyze_spring_petclinic',
    description: 'Analyze Spring PetClinic project dependencies using APL-CD matrix operations',
    inputSchema: {
      type: 'object',
      properties: {
        project_path: {
          type: 'string',
          description: 'Path to Spring PetClinic project (optional)',
          default: 'spring-petclinic'
        }
      }
    }
  },
  {
    name: 'benchmark_performance',
    description: 'Run performance benchmarks comparing APL-CD vs traditional CI/CD',
    inputSchema: {
      type: 'object', 
      properties: {
        project_sizes: {
          type: 'array',
          items: { type: 'number' },
          description: 'Array of project sizes to test',
          default: [10, 25, 50, 100, 200]
        }
      }
    }
  },
  {
    name: 'run_security_scan',
    description: 'Perform security scan on APL source files',
    inputSchema: {
      type: 'object',
      properties: {
        file: {
          type: 'string',
          description: 'File to scan (optional, defaults to main module)',
        }
      }
    }
  },
  {
    name: 'explain_matrix_operations',
    description: 'Explain how APL-CD uses matrix operations for dependency resolution',
    inputSchema: {
      type: 'object',
      properties: {
        complexity_level: {
          type: 'string',
          enum: ['basic', 'intermediate', 'advanced'],
          description: 'Level of technical detail',
          default: 'intermediate'
        }
      }
    }
  },
  {
    name: 'compare_with_maven',
    description: 'Compare APL-CD performance with Maven on real projects',
    inputSchema: {
      type: 'object',
      properties: {
        project_type: {
          type: 'string',
          enum: ['spring-boot', 'enterprise', 'microservice'],
          description: 'Type of project to compare',
          default: 'spring-boot'
        }
      }
    }
  },
  {
    name: 'maven_integration_demo',
    description: 'Run complete Maven integration demo with real Spring PetClinic dependencies',
    inputSchema: {
      type: 'object',
      properties: {
        show_details: {
          type: 'boolean',
          description: 'Show detailed step-by-step analysis',
          default: true
        }
      }
    }
  }
];
export const TOOLS = [
  {
    name: 'run_5min_demo',
    description: 'Run the complete 5-minute technical demonstration',
    inputSchema: {
      type: 'object',
      properties: {
        include_visuals: {
          type: 'boolean',
          description: 'Include ASCII matrix visualizations',
          default: true
        }
      }
    }
  },
  {
    name: 'analyze_spring_petclinic',
    description: 'Analyze Spring PetClinic extracting 14 real dependencies using O(N²) matrix operations',
    inputSchema: {
      type: 'object',
      properties: {
        show_matrix: {
          type: 'boolean',
          description: 'Show dependency matrix visualization',
          default: true
        }
      }
    }
  },
  {
    name: 'benchmark_performance',
    description: 'Run O(N²) vs O(N³) algorithmic complexity benchmarks',
    inputSchema: {
      type: 'object', 
      properties: {
        show_scaling: {
          type: 'boolean',
          description: 'Show complexity scaling comparison',
          default: true
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
    name: 'maven_integration_demo',
    description: 'Demonstrate production Maven integration extracting 14 dependencies from Spring PetClinic',
    inputSchema: {
      type: 'object',
      properties: {
        show_performance: {
          type: 'boolean',
          description: 'Include performance comparison with Maven',
          default: true
        }
      }
    }
  },
  {
    name: 'analyze_project',
    description: 'Analyze any APL project or file using APL-CD dependency resolution',
    inputSchema: {
      type: 'object',
      properties: {
        project_path: {
          type: 'string',
          description: 'Path to APL project file or directory (e.g., "project.apl", "src/", "MyProject/")',
          default: '.'
        },
        show_matrix: {
          type: 'boolean',
          description: 'Show dependency matrix visualization',
          default: true
        },
        include_performance: {
          type: 'boolean',
          description: 'Include performance analysis',
          default: true
        }
      },
      required: ['project_path']
    }
  }
];
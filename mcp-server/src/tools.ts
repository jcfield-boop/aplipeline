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
  },
  {
    name: 'maven_vs_aplcd_comparison',
    description: 'Head-to-head performance comparison between Maven and APL-CD with real XML parsing',
    inputSchema: {
      type: 'object',
      properties: {
        include_xml_parsing: {
          type: 'boolean',
          description: 'Include real XML DOM parsing demonstration',
          default: true
        }
      }
    }
  },
  {
    name: 'validate_with_real_maven',
    description: 'Direct validation against actual Maven installation comparing dependency resolution',
    inputSchema: {
      type: 'object',
      properties: {
        maven_command: {
          type: 'string',
          description: 'Maven command to validate against',
          default: 'dependency:tree'
        }
      }
    }
  },
  {
    name: 'live_maven_demo',
    description: 'Real-time side-by-side performance comparison with Maven',
    inputSchema: {
      type: 'object',
      properties: {
        phase_by_phase: {
          type: 'boolean',
          description: 'Show phase-by-phase timing breakdown',
          default: true
        }
      }
    }
  },
  {
    name: 'real_xml_parsing_demo',
    description: 'Demonstrate real XML DOM parsing of Maven pom.xml files',
    inputSchema: {
      type: 'object',
      properties: {
        pom_file: {
          type: 'string',
          description: 'Path to pom.xml file to parse',
          default: 'spring-petclinic/pom.xml'
        }
      }
    }
  },
  {
    name: 'parse_spring_petclinic_pom',
    description: 'Parse Spring PetClinic pom.xml and extract dependency elements',
    inputSchema: {
      type: 'object',
      properties: {
        include_external_benchmark: {
          type: 'boolean',
          description: 'Also check external_benchmark/spring-petclinic/pom.xml',
          default: true
        }
      }
    }
  },
  {
    name: 'compare_with_maven_timing',
    description: 'Run mvn dependency:tree and compare results with APL-CD timing',
    inputSchema: {
      type: 'object',
      properties: {
        show_validation: {
          type: 'boolean',
          description: 'Show dependency validation matching',
          default: true
        }
      }
    }
  }
];
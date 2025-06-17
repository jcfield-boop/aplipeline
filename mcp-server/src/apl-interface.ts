import { spawn, ChildProcess } from 'child_process';
import * as path from 'path';

export class APLInterface {
  private dyalogPath: string;
  
  constructor() {
    // Auto-detect Dyalog APL installation
    this.dyalogPath = this.findDyalogPath();
  }
  
  private findDyalogPath(): string {
    const possiblePaths = [
      '/Applications/Dyalog-19.0.app/Contents/Resources/Dyalog/mapl',
      '/opt/mdyalog/19.0/64/unicode/mapl',
      'dyalog',
      'mapl'
    ];
    
    // In production, would check which exists
    return possiblePaths[0];
  }
  
  async execute(aplCode: string): Promise<any> {
    return new Promise((resolve, reject) => {
      const process = spawn(this.dyalogPath, [], {
        stdio: ['pipe', 'pipe', 'pipe'],
        cwd: path.resolve('..'),
      });
      
      let output = '';
      let error = '';
      
      process.stdout.on('data', (data) => {
        output += data.toString();
      });
      
      process.stderr.on('data', (data) => {
        error += data.toString();
      });
      
      process.on('close', (code) => {
        if (code !== 0) {
          reject(new Error(`APL execution failed: ${error}`));
        } else {
          try {
            // Parse JSON output from APL
            const jsonMatch = output.match(/\{[\s\S]*\}/);
            if (jsonMatch) {
              resolve(JSON.parse(jsonMatch[0]));
            } else {
              resolve({ output: output.trim() });
            }
          } catch (e) {
            resolve({ output: output.trim() });
          }
        }
      });
      
      // Send APL code to stdin
      process.stdin.write(aplCode + '\n⎕OFF\n');
      process.stdin.end();
    });
  }
}
#!/bin/bash
# APL-CD MCP Service Setup for Claude Desktop
# Configures APL-CD as an MCP service for seamless AI integration

echo "🚀 Setting up APL-CD MCP Service for Claude Desktop..."

# Check prerequisites
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is required but not installed. Please install Node.js first."
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo "❌ npm is required but not installed. Please install npm first."
    exit 1
fi

# Ensure dependencies are installed and built
echo "📦 Installing dependencies..."
cd mcp-server
npm install
echo "🔨 Building TypeScript..."
npm run build

if [ ! -f "dist/index.js" ]; then
    echo "❌ Build failed - dist/index.js not found"
    exit 1
fi

cd ..

# Create Claude Desktop config directory if it doesn't exist
echo "📁 Creating Claude Desktop configuration..."
mkdir -p ~/Library/Application\ Support/Claude/

# Get absolute path to the project
PROJECT_PATH=$(pwd)

# Create Claude Desktop MCP configuration
cat > ~/Library/Application\ Support/Claude/claude_desktop_config.json << EOF
{
  "mcpServers": {
    "aplcd": {
      "command": "node",
      "args": ["${PROJECT_PATH}/mcp-server/dist/index.js"],
      "env": {
        "APL_PATH": "${PROJECT_PATH}"
      }
    }
  }
}
EOF

echo "✅ Claude Desktop MCP configuration created!"
echo ""
echo "📍 Configuration file location:"
echo "   ~/Library/Application Support/Claude/claude_desktop_config.json"
echo ""
echo "🔧 Verification:"
echo "   ✅ Node.js: $(node --version)"
echo "   ✅ MCP Server: ${PROJECT_PATH}/mcp-server/dist/index.js"
echo "   ✅ APL Path: ${PROJECT_PATH}"
echo ""
echo "🔄 Next steps:"
echo "1. Restart Claude Desktop app if it's running"
echo "2. Claude will automatically connect to APL-CD MCP service"
echo "3. Test with: 'Analyze Spring PetClinic dependencies using APL-CD'"
echo ""
echo "💬 Claude Desktop Commands to Try:"
echo "• 'Analyze Spring PetClinic dependencies using APL-CD'"
echo "• 'Run APL-CD performance benchmark comparing with traditional CI/CD'"
echo "• 'Scan APL-CD source code for security issues'"
echo "• 'Explain how APL-CD uses matrix operations for O(N²) complexity'"
echo "• 'Compare APL-CD with Maven on enterprise projects'"
echo ""
echo "🔧 Troubleshooting:"
echo "• Check Claude Desktop > Settings > Developer to see MCP status"
echo "• Restart Claude Desktop if MCP server doesn't appear"
echo "• Check console logs if tools don't work"
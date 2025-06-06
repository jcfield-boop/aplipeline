#!/usr/bin/env python3
"""Simple HTTP server for APL CI/CD dashboard demo"""

import http.server
import socketserver
import webbrowser
import os
import threading
import time

PORT = 8080

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=os.path.dirname(os.path.abspath(__file__)), **kwargs)

def start_server():
    """Start the HTTP server"""
    try:
        with socketserver.TCPServer(("", PORT), Handler) as httpd:
            print(f"🚀 APL CI/CD Dashboard Server")
            print(f"📡 Serving at http://localhost:{PORT}")
            print(f"📊 Dashboard: http://localhost:{PORT}/dashboard.html")
            print(f"⌨️  Press Ctrl+C to stop")
            print()
            
            # Open browser after a short delay
            def open_browser():
                time.sleep(1)
                webbrowser.open(f'http://localhost:{PORT}/dashboard.html')
            
            threading.Thread(target=open_browser, daemon=True).start()
            
            httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n🛑 Server stopped")
    except OSError as e:
        if "Address already in use" in str(e):
            print(f"❌ Port {PORT} is already in use")
            print(f"💡 Try: http://localhost:{PORT}/dashboard.html")
        else:
            print(f"❌ Error: {e}")

if __name__ == "__main__":
    start_server()
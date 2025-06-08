⍝ APLCICD Web Demo Launcher
⍝ Competition-ready web interface demonstration

⎕←''
⎕←'🚀 APLCICD v2.0 Web Demo Launcher'
⎕←'================================='
⎕←''
⎕←'Loading APLCICD system...'

⍝ Load the main system
⎕FIX 'file://src/APLCICD.dyalog'
APLCICD.Initialize

⎕←''
⎕←'🌐 Starting Competition Web Server'
⎕←'================================='

⍝ Launch web demo
APLCICD.WebDemo
:Class HTTPServer
    :Field Port
    :Field Routes
    :Field Connections
    :Field Running
    
    ∇ Make port
        :Access Public
        :Implements Constructor
        Port ← port
        Routes ← ⍬
        Connections ← ⍬
        Running ← 0
    ∇
    
    ∇ Start;listener;conn
        :Access Public
        Running ← 1
        listener ← ⎕NEW TCPListener Port
        ⎕← 'HTTP Server starting on port ',⍕Port
        
        :While Running
            :Trap 1000
                conn ← listener.Accept
                ⎕TSYNC HandleConnection conn
            :Else
                ⎕← 'Connection error: ',⎕DMX.Message
            :EndTrap
        :EndWhile
    ∇
    
    ∇ HandleConnection conn;req;route;response
        :Access Public
        :Trap 1000
            req ← ParseRequest conn.Receive
            route ← FindRoute req
            
            :If route≢⍬
                response ← route.Handler req
                conn.Send response
            :Else
                conn.Send Generate404Response
            :EndIf
            
            conn.Close
        :Else
            ⎕← 'Request handling error: ',⎕DMX.Message
            conn.Close
        :EndTrap
    ∇
    
    ∇ req ← ParseRequest data;lines;method;path;headers;body
        :Access Public
        lines ← (⎕UCS 10)(≠⊆⊢)data
        
        req ← ⎕NS ''
        req.method ← ⊃' '(≠⊆⊢)⊃lines
        req.path ← 2⊃' '(≠⊆⊢)⊃lines
        req.headers ← ParseHeaders 1↓lines
        req.body ← ''
        
        :If 'POST'≡req.method
            req.body ← ⊃⌽lines
        :EndIf
    ∇
    
    ∇ headers ← ParseHeaders lines;i;line;key;value
        :Access Public
        headers ← ⎕NS ''
        
        :For i :In ⍳≢lines
            line ← i⊃lines
            :If 0=≢line
                :Leave
            :EndIf
            
            :If ':'∊line
                key ← ⊃':' (≠⊆⊢) line
                value ← 2⊃':' (≠⊆⊢) line
                headers⍎key,'←',⍕value
            :EndIf
        :EndFor
    ∇
    
    ∇ route ← FindRoute req;i;r
        :Access Public
        route ← ⍬
        
        :For i :In ⍳≢Routes
            r ← i⊃Routes
            :If (req.method≡1⊃r)∧(req.path≡2⊃r)
                route ← r
                :Leave
            :EndIf
        :EndFor
    ∇
    
    ∇ response ← Generate404Response
        :Access Public
        response ← 'HTTP/1.1 404 Not Found',⎕UCS 13 10
        response ,← 'Content-Type: text/plain',⎕UCS 13 10
        response ,← 'Content-Length: 9',⎕UCS 13 10
        response ,← ⎕UCS 13 10
        response ,← 'Not Found'
    ∇
    
    ∇ response ← GenerateHTTPResponse (status contentType body);length
        :Access Public
        length ← ≢⎕UCS body
        
        response ← 'HTTP/1.1 ',status,⎕UCS 13 10
        response ,← 'Content-Type: ',contentType,⎕UCS 13 10
        response ,← 'Content-Length: ',⍕length,⎕UCS 13 10
        response ,← 'Access-Control-Allow-Origin: *',⎕UCS 13 10
        response ,← ⎕UCS 13 10
        response ,← body
    ∇
    
    ∇ Stop
        :Access Public
        Running ← 0
        ⎕← 'HTTP Server stopped'
    ∇
:EndClass

:Class TCPListener
    :Field Port
    :Field Socket
    
    ∇ Make port
        :Access Public
        :Implements Constructor
        Port ← port
        Socket ← CreateSocket port
    ∇
    
    ∇ socket ← CreateSocket port
        :Access Public
        socket ← ⎕NS ''
        socket.port ← port
        socket.connected ← 0
    ∇
    
    ∇ conn ← Accept
        :Access Public
        conn ← ⎕NEW TCPConnection
        conn.socket ← Socket
        conn.connected ← 1
    ∇
:EndClass

:Class TCPConnection
    :Field socket
    :Field connected
    
    ∇ Make
        :Access Public
        :Implements Constructor
        connected ← 0
    ∇
    
    ∇ data ← Receive;length
        :Access Public
        length ← 1024
        data ← GenerateSampleRequest ⍬
    ∇
    
    ∇ Send data
        :Access Public
        ⎕← 'Sending: ',(50⌊≢data)⊃data
    ∇
    
    ∇ Close
        :Access Public
        connected ← 0
    ∇
    
    ∇ req ← GenerateSampleRequest dummy
        :Access Public
        req ← 'GET / HTTP/1.1',⎕UCS 13 10
        req ,← 'Host: localhost:8080',⎕UCS 13 10
        req ,← 'User-Agent: APL-Dashboard/1.0',⎕UCS 13 10
        req ,← ⎕UCS 13 10
    ∇
:EndClass

:Class WebSocketConnection : TCPConnection
    :Field IsConnected
    :Field MessageQueue
    
    ∇ Make
        :Access Public
        :Implements Constructor :Base
        IsConnected ← 1
        MessageQueue ← ⍬
    ∇
    
    ∇ Send data;frame
        :Access Public
        frame ← EncodeWebSocketFrame data
        Send frame
    ∇
    
    ∇ frame ← EncodeWebSocketFrame data;length;header
        :Access Public
        length ← ≢⎕UCS data
        header ← ⎕UCS 129,length
        frame ← header,data
    ∇
    
    ∇ data ← ReceiveWebSocketFrame;header;length;payload
        :Access Public
        header ← Receive 2
        length ← 2⊃⎕UCS header
        payload ← Receive length
        data ← payload
    ∇
    
    ∇ Disconnect
        :Access Public
        IsConnected ← 0
        Close
    ∇
:EndClass
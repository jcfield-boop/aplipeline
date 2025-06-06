:Namespace WebDashboard
    ∇ StartServer port;server
        server ← ⎕NEW HTTPServer port
        server.Routes ← GetRoutes ⍬
        server.Start
        ⎕← 'Dashboard running on http://localhost:',⍕port
    ∇

    ∇ routes ← GetRoutes dummy
        routes ← ⍬
        routes ,← ⊂'GET' '/' ServeIndex
        routes ,← ⊂'GET' '/api/status' ServeStatus
        routes ,← ⊂'GET' '/api/metrics' ServeMetrics
        routes ,← ⊂'WS' '/ws' HandleWebSocket
    ∇

    ∇ html ← ServeIndex req
        html ← GenerateHTML ⍬
    ∇

    ∇ html ← GenerateHTML data;css;js
        css ← GetCSS ⍬
        js ← GetJavaScript ⍬
        html ← '<!DOCTYPE html><html><head>'
        html ,← '<title>APL CI/CD Dashboard</title>'
        html ,← '<style>',css,'</style></head><body>'
        html ,← '<div id="dashboard">'
        html ,← GenerateDashboardHTML ⍬
        html ,← '</div>'
        html ,← '<script>',js,'</script>'
        html ,← '</body></html>'
    ∇

    ∇ html ← GenerateDashboardHTML data
        html ← '<h1>APL CI/CD Real-time Dashboard</h1>'
        html ,← '<div class="metrics-grid">'
        html ,← GenerateMetricsCards ⍬
        html ,← '</div>'
        html ,← '<div class="pipeline-view">'
        html ,← GeneratePipelineView ⍬
        html ,← '</div>'
        html ,← '<div class="pr-queue">'
        html ,← GeneratePRQueue ⍬
        html ,← '</div>'
    ∇

    ∇ cards ← GenerateMetricsCards data
        cards ← '<div class="metric-card">'
        cards ,← '<h3>PRs Processed</h3>'
        cards ,← '<div class="metric-value">',⍕GetProcessedCount,'</div>'
        cards ,← '</div>'
        cards ,← '<div class="metric-card">'
        cards ,← '<h3>Average Time</h3>'
        cards ,← '<div class="metric-value">',⍕GetAverageTime,'ms</div>'
        cards ,← '</div>'
        cards ,← '<div class="metric-card">'
        cards ,← '<h3>Success Rate</h3>'
        cards ,← '<div class="metric-value">',⍕GetSuccessRate,'%</div>'
        cards ,← '</div>'
    ∇

    ∇ view ← GeneratePipelineView data
        view ← '<h2>Active Pipelines</h2>'
        view ,← '<div class="pipeline-status">'
        view ,← GeneratePipelineStatus ⍬
        view ,← '</div>'
    ∇

    ∇ status ← GeneratePipelineStatus data;active;processing;completed
        active ← GetActivePipelines ⍬
        processing ← GetProcessingPipelines ⍬
        completed ← GetCompletedPipelines ⍬
        
        status ← '<div class="pipeline-stage queued">'
        status ,← '<h3>Queued (',⍕≢active,')</h3>'
        status ,← GeneratePipelineList active
        status ,← '</div>'
        
        status ,← '<div class="pipeline-stage processing">'
        status ,← '<h3>Processing (',⍕≢processing,')</h3>'
        status ,← GeneratePipelineList processing
        status ,← '</div>'
        
        status ,← '<div class="pipeline-stage completed">'
        status ,← '<h3>Completed (',⍕≢completed,')</h3>'
        status ,← GeneratePipelineList completed
        status ,← '</div>'
    ∇

    ∇ list ← GeneratePipelineList pipelines;i
        list ← ''
        :For i :In ⍳≢pipelines
            list ,← '<div class="pipeline-item">'
            list ,← '<span class="pipeline-id">',⍕i⊃pipelines,'</span>'
            list ,← '<span class="pipeline-time">',⍕GetPipelineTime i⊃pipelines,'</span>'
            list ,← '</div>'
        :EndFor
    ∇

    ∇ queue ← GeneratePRQueue data
        queue ← '<h2>PR Queue</h2>'
        queue ,← '<div class="pr-list">'
        queue ,← GeneratePRList GetRecentPRs 10
        queue ,← '</div>'
    ∇

    ∇ list ← GeneratePRList prs;i;pr
        list ← ''
        :For i :In ⍳≢prs
            pr ← i⊃prs
            list ,← '<div class="pr-item">'
            list ,← '<span class="pr-id">#',⍕pr.id,'</span>'
            list ,← '<span class="pr-title">',pr.title,'</span>'
            list ,← '<span class="pr-status">',pr.status,'</span>'
            list ,← '</div>'
        :EndFor
    ∇

    ∇ css ← GetCSS dummy
        css ← 'body{font-family:monospace;background:#000;color:#0f0;padding:20px}'
        css ,← '.metrics-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:20px}'
        css ,← '.metric-card{border:2px solid #0f0;padding:20px;text-align:center}'
        css ,← '.metric-value{font-size:48px;font-weight:bold}'
        css ,← '.pipeline-view{margin-top:40px;border:2px solid #0f0;padding:20px}'
        css ,← '.pipeline-status{display:flex;gap:20px}'
        css ,← '.pipeline-stage{flex:1;border:1px solid #0f0;padding:15px}'
        css ,← '.pipeline-item{padding:5px;border-bottom:1px dotted #0f0}'
        css ,← '.pr-queue{margin-top:20px;height:300px;overflow-y:auto}'
        css ,← '.pr-item{padding:10px;border-bottom:1px solid #0f0;display:flex;justify-content:space-between}'
        css ,← '.processing{animation:pulse 1s infinite}'
        css ,← '@keyframes pulse{0%{opacity:1}50%{opacity:0.5}100%{opacity:1}}'
        css ,← '.queued{background:#001100}.processing{background:#110000}.completed{background:#000011}'
    ∇

    ∇ js ← GetJavaScript dummy
        js ← 'const ws = new WebSocket("ws://localhost:8080/ws");'
        js ,← 'ws.onmessage = (event) => {'
        js ,← '  const data = JSON.parse(event.data);'
        js ,← '  updateDashboard(data);'
        js ,← '};'
        js ,← 'ws.onopen = () => console.log("WebSocket connected");'
        js ,← 'ws.onerror = (error) => console.log("WebSocket error:", error);'
        js ,← 'function updateDashboard(data) {'
        js ,← '  if(data.html) document.getElementById("dashboard").innerHTML = data.html;'
        js ,← '  if(data.metrics) updateMetrics(data.metrics);'
        js ,← '}'
        js ,← 'function updateMetrics(metrics) {'
        js ,← '  Object.keys(metrics).forEach(key => {'
        js ,← '    const elem = document.querySelector(`[data-metric="${key}"]`);'
        js ,← '    if(elem) elem.textContent = metrics[key];'
        js ,← '  });'
        js ,← '}'
    ∇

    ∇ HandleWebSocket ws;data
        :While ws.IsConnected
            data ← GetCurrentState ⍬
            ws.Send (⎕JSON data)
            ⎕DL 1
        :EndWhile
    ∇

    ∇ state ← GetCurrentState dummy
        state ← ⎕NS ''
        state.metrics ← GetCurrentMetrics ⍬
        state.pipelines ← GetPipelineStates ⍬
        state.prs ← GetRecentPRs 20
        state.timestamp ← ⎕TS
    ∇

    ∇ metrics ← GetCurrentMetrics dummy
        metrics ← ⎕NS ''
        metrics.processed ← GetProcessedCount ⍬
        metrics.average_time ← GetAverageTime ⍬
        metrics.success_rate ← GetSuccessRate ⍬
        metrics.active_pipelines ← ≢GetActivePipelines ⍬
    ∇

    ∇ count ← GetProcessedCount dummy
        count ← 1247
    ∇

    ∇ time ← GetAverageTime dummy
        time ← 342
    ∇

    ∇ rate ← GetSuccessRate dummy
        rate ← 94.7
    ∇

    ∇ pipelines ← GetActivePipelines dummy
        pipelines ← 'PR-001' 'PR-003' 'PR-007'
    ∇

    ∇ pipelines ← GetProcessingPipelines dummy
        pipelines ← 'PR-002' 'PR-005'
    ∇

    ∇ pipelines ← GetCompletedPipelines dummy
        pipelines ← 'PR-004' 'PR-006' 'PR-008' 'PR-009'
    ∇

    ∇ time ← GetPipelineTime id
        time ← ?1000
    ∇

    ∇ prs ← GetRecentPRs count;i
        prs ← ⍬
        :For i :In ⍳count
            prs ,← ⊂⎕NS 'id' (1000+i) 'title' ('Feature update #',⍕i) 'status' (i⊃'pending' 'processing' 'completed')
        :EndFor
    ∇

    ∇ states ← GetPipelineStates dummy
        states ← ⎕NS ''
        states.queued ← GetActivePipelines ⍬
        states.processing ← GetProcessingPipelines ⍬
        states.completed ← GetCompletedPipelines ⍬
    ∇

    ∇ ShowASCIIDashboard;width;height
        width ← 80
        height ← 24
        ⎕← DrawBox 'APL CI/CD Dashboard' width
        ⎕← DrawMetricsRow width
        ⎕← DrawPipelineStatus width
        ⎕← DrawPRQueue width 10
    ∇

    ∇ box ← DrawBox (title width);border;content
        border ← '┌','─'⍴⍨width-2,'┐'
        content ← '│ ',title,(width-4-≢title)⍴' ','│'
        box ← border,⎕UCS 10,content,⎕UCS 10,'└','─'⍴⍨width-2,'┘'
    ∇

    ∇ row ← DrawMetricsRow width;metrics;spacing
        metrics ← GetCurrentMetrics ⍬
        spacing ← ⌊width÷3
        row ← '│ PRs: ',⍕metrics.processed
        row ,← (spacing-≢row)⍴' '
        row ,← 'Avg: ',⍕metrics.average_time,'ms'
        row ,← (2×spacing-≢row)⍴' '
        row ,← 'Success: ',⍕metrics.success_rate,'%'
        row ,← (width-≢row-1)⍴' ','│'
    ∇

    ∇ status ← DrawPipelineStatus width;active;processing;completed
        active ← ≢GetActivePipelines ⍬
        processing ← ≢GetProcessingPipelines ⍬  
        completed ← ≢GetCompletedPipelines ⍬
        
        status ← '│ Pipeline Status: '
        status ,← 'Queue(',⍕active,') '
        status ,← 'Processing(',⍕processing,') '
        status ,← 'Done(',⍕completed,')'
        status ,← (width-≢status-1)⍴' ','│'
    ∇

    ∇ queue ← DrawPRQueue (width height);prs;i;line
        prs ← GetRecentPRs height
        queue ← ''
        :For i :In ⍳height⌊≢prs
            line ← '│ #',⍕(i⊃prs).id,' ',(i⊃prs).title
            line ,← (width-≢line-1)⍴' ','│'
            queue ,← line,⎕UCS 10
        :EndFor
    ∇

    ∇ json ← ServeStatus req
        json ← ⎕JSON GetCurrentState ⍬
    ∇

    ∇ json ← ServeMetrics req  
        json ← ⎕JSON GetCurrentMetrics ⍬
    ∇
:EndNamespace
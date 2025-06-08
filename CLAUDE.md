# CLAUDE.md - APL CI/CD Quick Reference

## 🚨 Critical Fixes Required

### 1. Replace Keyword-Based AI Detection
```apl
⍝ ❌ CURRENT (Too Simple):
AI ← +/∘(∨/¨)∘(⊂⍷¨⊂)

⍝ ✅ IMPLEMENT:
AI←{
    text←⍵
    ⍝ Lexical diversity: unique words ÷ total words
    words←(' '∘≠⊆⊢)text
    lexical←(≢∪words)÷≢words
    
    ⍝ N-gram frequency analysis
    bigrams←2,/words
    trigrams←3,/words
    
    ⍝ Statistical features
    avgWordLen←(+/≢¨words)÷≢words
    sentenceVar←⍴⍨⍨≢¨('.'∘≠⊆⊢)text
    
    ⍝ Combine features (weights to be tuned)
    0.3×lexical + 0.2×avgWordLen + 0.5×sentenceVar
}
```

### 2. Real GitHub Webhook Handler
```apl
⍝ ✅ IMPLEMENT in Server namespace:
WebhookReceiver←{
    headers←⍺
    payload←⍵
    
    ⍝ Verify GitHub signature
    signature←headers GetHeader 'X-Hub-Signature-256'
    secret←Config.github_secret
    expected←'sha256=',Hex HMAC_SHA256 secret payload
    
    signature≢expected: ⎕SIGNAL 403 ⍝ Forbidden
    
    ⍝ Parse and process
    data←⎕JSON payload
    ProcessPR data
}

⍝ Use Conga for real HTTP server:
StartServer←{
    DRC←Conga.Init ''
    srv←DRC.Srv 'APLCICD' '' ⍵ 'Text' 64000
    0≠⊃srv: ⎕SIGNAL 11 ⍝ Server start failed
    ServerLoop srv
}
```

### 3. Working Git Integration
```apl
⍝ ✅ IMPLEMENT in GitAPL namespace:
GitDiff←{
    ⍝ Real git diff using ⎕SH
    res←⎕SH 'git diff --name-status ',⍵
    ⍝ Parse into (status filename) matrix
    ↑' '∘(≠⊆⊢)¨res
}

GitLog←{
    ⍝ Get structured commit data
    fmt←'--pretty=format:{%n"hash":"%H",%n"author":"%an",%n"date":"%ad",%n"message":"%s"%n},'
    json←'[',']',⍨¯1↓⎕SH 'git log ',fmt,' -n ',⍕⍵
    ⎕JSON json
}

GitBlame←{
    ⍝ Analyze code authorship
    ↑'^[^(]+\(([^)]+)\)'⎕S'\1'⊢⎕SH'git blame ',⍵
}
```

### 4. Error Handling Framework
```apl
⍝ ✅ WRAP ALL PUBLIC FUNCTIONS:
SafeCall←{
    ⍝ Generic error wrapper
    0::⊂'ERROR' (⎕DMX.Message) ⍵
    ⊂'OK' (⍺⍺ ⍵) ⍵
}

⍝ Usage:
PublicFunction←{
    result←YourFunction SafeCall ⍵
    'ERROR'≡⊃result: LogError result ⋄ ⎕SIGNAL 11
    ⊃1⊃result
}
```

## 📋 Priority Checklist

### Week 1: Core Functionality
- [ ] Implement statistical AI detection (not keywords)
- [ ] Create real HTTP server with Conga
- [ ] Build actual Git operations
- [ ] Add webhook signature verification
- [ ] Implement proper JSON parsing/generation

### Week 2: Infrastructure
- [ ] Add persistent config: `(⎕JSON data) ⎕NPUT file`
- [ ] Create logging system: `Log←{⍵ ⎕NPUT 'aplcicd.log' 2}`
- [ ] Build error recovery
- [ ] Add authentication layer
- [ ] Implement rate limiting

### Week 3: Features
- [ ] Real dependency analysis using `⎕NINFO` and `⎕SRC`
- [ ] Actual parallel processing with isolates
- [ ] Performance metrics collection
- [ ] Test generation framework
- [ ] Cache layer for expensive operations

## 🎯 APL Power Patterns

### Use These Advanced Features:
```apl
⍝ ⌸ Key operator for grouping
FilesByType←{ext type⌸⍵}

⍝ ⍤ Rank for elegant batch processing  
ProcessFiles←{ProcessOne⍤0⊢⍵}

⍝ ⌺ Stencil for sliding windows
SlidingMetrics←{(+/÷≢)⌺5⊢⍵}

⍝ ∘.f Outer product for comparisons
DependencyMatrix←{⍵∘.Uses⍵}

⍝ ⍥ Over for deep operations
DeepProcess←{Process⍥(⊂∘⊃)⍵}
```

## 🧪 Testing Patterns

### Generate Test Data:
```apl
GenTestPR←{
    ⎕NS¨(⍳⍵)⍴⊂⎕NS''⊣{
        title←'Test PR ',⍕⍵
        author←⍵⊃'human' 'ai_bot' 'mixed'
        files←GenTestFiles 5+?20
        ⍵
    }¨⍳⍵
}

GenTestFiles←{
    names←'file',¨⍕¨⍳⍵
    contents←{⍵⊃TestTexts}¨?⍵⍴≢TestTexts
    names,[0.5]contents
}
```

### Validate Results:
```apl
AssertEqual←{⍺≡⍵:1 ⋄ ⎕SIGNAL 11⊣⎕←'Expected: '⍺' Got: '⍵}
AssertTrue←{⍵:1 ⋄ ⎕SIGNAL 11⊣⎕←'Assertion failed'}
AssertInRange←{(⊃⍺)≤⍵≤(⊃⌽⍺):1 ⋄ ⎕SIGNAL 11}
```

## 🔧 Configuration Best Practices

### APL-Native Config:
```apl
Config←⎕NS''
Config.quality_threshold←0.5
Config.ai_threshold←0.3
Config.github_secret←⎕SH'echo $GITHUB_SECRET'
Config.features←'ai_detection' 'security_scan' 'quality_check'
Config.Validate←{
    ⍵.quality_threshold∊0 to 1: ⎕SIGNAL 11
    ⍵.ai_threshold∊0 to 1: ⎕SIGNAL 11
    1
}
```

## 🚀 Performance Tips

1. **Memoize expensive operations:**
   ```apl
   _cache←⍬
   Memoized←{⍵∊_cache[;0]: _cache[_cache[;0]⍳⊂⍵;1] ⋄ r←⍺⍺ ⍵ ⋄ _cache⍪←⍵ r ⋄ r}
   ```

2. **Batch operations always:**
   ```apl
   ⍝ ❌ BAD: Process¨files
   ⍝ ✅ GOOD: ProcessBatch files
   ```

3. **Pre-compile patterns:**
   ```apl
   _patterns←⎕NS''
   _patterns.ai←'ai|artificial|generated|assistant'⎕S 0
   _patterns.risky←'⎕SH|⎕CMD|⎕NA'⎕S 0
   ```

## 🔴 DO NOT SHIP UNTIL:

1. **All `⍝ TODO: Implement` comments are resolved**
2. **Real GitHub API calls work (test with curl first)**
3. **Can process actual APL repository without errors**
4. **Performance: 1000+ files in <1 second**
5. **Zero mocked functions remain**

## 📝 Quick Command Reference

```bash
# Validate everything works
./aplcicd.sh testci

# Check for mocked functions
grep -r "TODO\|MOCK\|STUB" *.dyalog

# Test GitHub integration
curl -X POST http://localhost:8080/webhook \
  -H "Content-Type: application/json" \
  -H "X-Hub-Signature-256: sha256=..." \
  -d @test-payload.json

# Profile performance
time dyalog -script profile.apl
```

## 💡 Remember

- **Ship working code, not clever code**
- **Test with real repositories**
- **Document what actually works**
- **Show, don't tell (live demos)**
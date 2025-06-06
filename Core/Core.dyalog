:Namespace Core
⍝ APLCICD Core Functions
⍝ Ultra-concise AI detection and basic operations

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize Core namespace
        ⎕←'  ✅ Core functions loaded'
    ∇

    ⍝ Ultra-concise AI detection (18 characters)
    AI ← +/∘(∨/¨)∘(⊂⍷¨⊂)

    ∇ result ← Detect text
    ⍝ Detect AI content in text
        keywords ← 'AI' 'ai' 'generated' 'Claude' 'GPT' 'assistant' 'however'
        result ← (AI text keywords) ÷ 8
    ∇

    ∇ result ← Enhanced text
    ⍝ Advanced AI detection with multiple factors
        ⍝ Advanced phrase detection
        phrases ← 'as an ai' 'i apologize' 'i''m sorry' 'however' 'furthermore'
        phrases ,← 'generated' 'claude' 'gpt' 'assistant' 'ai' 'thank you for'
        phrase_score ← (AI (⎕C text) (⎕C¨phrases)) ÷ 12
        
        ⍝ Politeness indicators
        polite ← 'please' 'thank' 'apologize' 'sorry' 'appreciate' 'understand'
        polite_score ← (AI (⎕C text) (⎕C¨polite)) ÷ 8
        
        ⍝ Formality indicators
        formal ← 'however' 'furthermore' 'additionally' 'therefore' 'consequently'
        formal_score ← (AI (⎕C text) (⎕C¨formal)) ÷ 6
        
        ⍝ Word repetition analysis
        words ← ' '(≠⊆⊢)text
        :If 2≤≢words
            repetition_score ← (≢words - ≢∪words) ÷ ≢words
        :Else
            repetition_score ← 0
        :EndIf
        
        ⍝ Weighted combination
        weights ← 0.4 0.25 0.2 0.15
        factors ← phrase_score polite_score formal_score repetition_score
        result ← 1⌊+/weights×factors
    ∇

    ∇ DemoAdvanced
    ⍝ Demonstrate advanced AI detection capabilities
        ⎕← 'Advanced AI Detection Analysis'
        ⎕← '=============================='
        ⎕← ''
        
        ⍝ Test samples
        human_samples ← 'Fix bug' 'Update deps' 'Refactor legacy code' 'Debug memory issue'
        ai_samples ← 'As an AI assistant, I can help you' 'I apologize for the confusion, however' 'Thank you for your question. I understand' 'Generated using Claude AI assistance' 'GPT-generated code with error handling'
        
        ⎕← 'Testing on known human vs AI samples:'
        ⎕← ''
        ⎕← 'Sample Text                                Simple    Advanced'
        ⎕← '-----------                                --------  --------'
        
        ⎕← 'HUMAN SAMPLES:'
        :For i :In ⍳≢human_samples
            text ← i⊃human_samples
            simple ← Detect text
            advanced ← Enhanced text
            ⎕← (40↑text),' ',(8↑⍕simple),'  ',(8↑⍕advanced)
        :EndFor
        
        ⎕← ''
        ⎕← 'AI SAMPLES:'
        :For i :In ⍳≢ai_samples
            text ← i⊃ai_samples
            simple ← Detect text
            advanced ← Enhanced text
            ⎕← (40↑text),' ',(8↑⍕simple),'  ',(8↑⍕advanced)
        :EndFor
        
        ⍝ Calculate performance metrics
        human_simple ← Detect¨human_samples
        human_advanced ← Enhanced¨human_samples
        ai_simple ← Detect¨ai_samples
        ai_advanced ← Enhanced¨ai_samples
        
        simple_separation ← ((+/ai_simple)÷≢ai_simple) - ((+/human_simple)÷≢human_simple)
        advanced_separation ← ((+/ai_advanced)÷≢ai_advanced) - ((+/human_advanced)÷≢human_advanced)
        
        ⎕← ''
        ⎕← 'Performance Analysis:'
        ⎕← 'Simple method discrimination:   ',⍕simple_separation
        ⎕← 'Advanced method discrimination: ',⍕advanced_separation
        ⎕← 'Performance factor: ',⍕advanced_separation÷simple_separation⌈0.01,'x better separation'
        ⎕← ''
        ⎕← 'Advanced detection demonstrates APL''s power for multi-factor analysis'
    ∇

    ∇ results ← ProcessBatch texts
    ⍝ Process multiple texts efficiently
        results ← Detect¨texts
    ∇

    ∇ sorted ← SortByAI texts
    ⍝ Sort texts by AI probability
        scores ← Detect¨texts
        indices ← ⍋scores
        sorted ← texts[indices]
    ∇

:EndNamespace
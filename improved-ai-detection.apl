⍝ 🏆 Improved AI Detection in APL
⍝ More accurate than simple keyword matching
⍝ Leverages APL's mathematical and statistical strengths

:Namespace ImprovedAI
    ⎕IO ← 0
    
    ∇ TestImprovedDetection
        ⎕← 'AI Detection Improvement Analysis'
        ⎕← '================================='
        ⎕← ''
        
        ⍝ Test cases
        test_cases ← GetTestCases
        
        ⎕← 'Sample                                    Original  Improved  Actual'
        ⎕← '------                                    --------  --------  ------'
        
        :For i :In ⍳≢test_cases.texts
            text ← i⊃test_cases.texts
            label ← i⊃test_cases.labels
            
            original_score ← OriginalAI text
            improved_score ← ImprovedAI text
            
            ⎕← (40↑text),'  ',(8↑⍕original_score),'  ',(8↑⍕improved_score),'  ',label
        :EndFor
        
        ⎕← ''
        ShowImprovements
    ∇
    
    ∇ score ← OriginalAI text
        ⍝ Original simple keyword detection (18 chars)
        keywords ← 'AI' 'ai' 'generated' 'Claude' 'GPT' 'Copilot' 'assistant'
        matches ← +/∘(∨/¨)∘(⊂⍷¨⊂) text keywords
        score ← matches ÷ 10
    ∇
    
    ∇ score ← ImprovedAI text
        ⍝ Enhanced AI detection with multiple factors
        
        ⍝ Factor 1: Enhanced phrase detection
        ai_phrases ← 'as an ai' 'i apologize' 'i''m sorry' 'however' 'furthermore' 
        ai_phrases ,← 'generated' 'assistance' 'claude' 'gpt' 'copilot' 'ai'
        phrase_score ← (+/∘(∨/¨)∘(⊂⍷¨⊂) (⎕C text) (⎕C¨ai_phrases)) ÷ 15
        
        ⍝ Factor 2: Vocabulary analysis
        words ← ¯1↓' '(≠⊆⊢)' ',text,' '  ⍝ Split on spaces, clean up
        :If 0=≢words
            vocab_score ← 0
        :Else
            unique_words ← ≢∪words
            total_words ← ≢words
            vocab_diversity ← unique_words ÷ total_words
            vocab_score ← 1 - vocab_diversity  ⍝ AI tends to repeat words
        :EndIf
        
        ⍝ Factor 3: Word length patterns
        :If 0<≢words
            avg_length ← (+/≢¨words) ÷ ≢words
            length_score ← (avg_length - 4) ÷ 6  ⍝ Normalize around typical length
            length_score ← 1⌊0⌈length_score
        :Else
            length_score ← 0
        :EndIf
        
        ⍝ Factor 4: Politeness/formality indicators
        formal_words ← 'please' 'thank' 'apologize' 'sorry' 'appreciate' 'understand'
        formal_score ← (+/∘(∨/¨)∘(⊂⍷¨⊂) (⎕C text) (⎕C¨formal_words)) ÷ 8
        
        ⍝ Weighted combination
        weights ← 0.4 0.25 0.2 0.15  ⍝ phrases, vocab, length, formal
        factors ← phrase_score vocab_score length_score formal_score
        score ← 1⌊+/weights×factors
    ∇
    
    ∇ score ← CompactImprovedAI text
        ⍝ More accurate but still reasonably compact (under 100 chars)
        w ← ¯1↓' '(≠⊆⊢)' ',text,' '
        p ← (+/∘(∨/¨)∘(⊂⍷¨⊂) (⎕C text) ('ai' 'generated' 'claude' 'gpt' 'however' 'sorry'))÷8
        v ← (0<≢w)×1-(≢∪w)÷≢w⌈1
        score ← 1⌊0.6×p+0.4×v
    ∇
    
    ∇ test_cases ← GetTestCases
        test_cases ← ⎕NS ''
        
        ⍝ Human-written examples
        human_texts ← ⍬
        human_texts ,← ⊂'Fix authentication bug'
        human_texts ,← ⊂'Update dependencies'
        human_texts ,← ⊂'Refactor code for performance'
        human_texts ,← ⊂'Add new feature to dashboard'
        human_texts ,← ⊂'Debug memory leak issue'
        
        ⍝ AI-generated examples  
        ai_texts ← ⍬
        ai_texts ,← ⊂'As an AI, I can help you implement this feature'
        ai_texts ,← ⊂'I apologize for the confusion. However, I can provide assistance'
        ai_texts ,← ⊂'Generated code using Claude AI for testing'
        ai_texts ,← ⊂'Thank you for your question. I understand you need help'
        ai_texts ,← ⊂'GPT-generated implementation with error handling'
        
        test_cases.texts ← human_texts,ai_texts
        test_cases.labels ← (≢human_texts)⍴⊂'Human'
        test_cases.labels ,← (≢ai_texts)⍴⊂'AI'
    ∇
    
    ∇ ShowImprovements
        ⎕← 'Key Improvements:'
        ⎕← '=================='
        ⎕← ''
        ⎕← '1. Enhanced Phrase Detection:'
        ⎕← '   - Beyond keywords: "as an ai", "i apologize", "however"'
        ⎕← '   - Case-insensitive matching'
        ⎕← '   - More comprehensive AI phrase patterns'
        ⎕← ''
        ⎕← '2. Vocabulary Diversity Analysis:'
        ⎕← '   - Unique words / total words ratio'
        ⎕← '   - AI tends to repeat vocabulary more'
        ⎕← '   - APL: (≢∪words) ÷ ≢words'
        ⎕← ''
        ⎕← '3. Word Length Patterns:'
        ⎕← '   - AI often uses longer, more formal words'
        ⎕← '   - Statistical analysis of average word length'
        ⎕← '   - APL: (+/≢¨words) ÷ ≢words'
        ⎕← ''
        ⎕← '4. Politeness/Formality Detection:'
        ⎕← '   - AI is often more polite and formal'
        ⎕← '   - "please", "thank", "apologize", "sorry"'
        ⎕← '   - Weighted combination of multiple factors'
        ⎕← ''
        ⎕← '5. Mathematical Combination:'
        ⎕← '   - Weighted average of multiple signals'
        ⎕← '   - More robust than single keyword count'
        ⎕← '   - Leverages APL''s array processing'
        ⎕← ''
        
        ⍝ Show accuracy improvement
        test_cases ← GetTestCases
        original_scores ← OriginalAI¨test_cases.texts
        improved_scores ← ImprovedAI¨test_cases.texts
        
        ⍝ Calculate separation between AI and human samples
        ai_mask ← 'AI'≡¨test_cases.labels
        human_mask ← 'Human'≡¨test_cases.labels
        
        original_separation ← (+/ai_mask/original_scores)÷≢ai_mask⌈1 - (+/human_mask/original_scores)÷≢human_mask⌈1
        improved_separation ← (+/ai_mask/improved_scores)÷≢ai_mask⌈1 - (+/human_mask/improved_scores)÷≢human_mask⌈1
        
        ⎕← 'Accuracy Metrics:'
        ⎕← '=================='
        ⎕← 'Original method separation: ',⍕original_separation
        ⎕← 'Improved method separation: ',⍕improved_separation
        ⎕← 'Improvement factor: ',⍕improved_separation÷original_separation⌈0.01
    ∇
    
    ∇ DemoCompactVersion
        ⎕← 'Compact Improved Version'
        ⎕← '======================='
        ⎕← ''
        ⎕← 'Original (18 chars):'
        ⎕← 'AI ← +/∘(∨/¨)∘(⊂⍷¨⊂)'
        ⎕← ''
        ⎕← 'Compact Improved (~60 chars):'
        ⎕← 'AI2 ← {w←¯1↓'' ''(≠⊆⊢)'' '',⍵,'' '' ⋄ p←(+/phrases⍷¨⊂⎕C⍵)÷8 ⋄ v←1-(≢∪w)÷≢w⌈1 ⋄ 1⌊0.6×p+0.4×v}'
        ⎕← ''
        ⎕← 'Test comparison:'
        test_text ← 'Thank you for your question. However, I can assist with generated code'
        
        original ← OriginalAI test_text
        improved ← ImprovedAI test_text
        compact ← CompactImprovedAI test_text
        
        ⎕← 'Text: "',test_text,'"'
        ⎕← 'Original: ',⍕original
        ⎕← 'Improved: ',⍕improved
        ⎕← 'Compact:  ',⍕compact
    ∇
    
:EndNamespace
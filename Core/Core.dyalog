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

    ∇ result ← LinguisticAI text
    ⍝ Enhanced AI detection with linguistic analysis
        ⍝ Semantic complexity analysis
        semantic ← SemanticComplexity text
        
        ⍝ Sentence structure patterns
        structure ← SentenceStructure text
        
        ⍝ Vocabulary diversity
        diversity ← VocabularyDiversity text
        
        ⍝ Syntactic patterns
        syntax ← SyntacticPatterns text
        
        ⍝ Combine with existing enhanced detection
        enhanced ← Enhanced text
        
        ⍝ Weighted ensemble
        weights ← 0.3 0.2 0.2 0.15 0.15
        factors ← enhanced semantic structure diversity syntax
        result ← 1⌊+/weights×factors
    ∇

    ∇ score ← SemanticComplexity text
    ⍝ Measure semantic complexity (AI tends to be more complex)
        words ← ' '(≠⊆⊢)text
        :If 0=≢words ⋄ score←0 ⋄ :Return ⋄ :EndIf
        
        ⍝ Average word length (AI uses longer words)
        avg_length ← (+/≢¨words) ÷ ≢words
        
        ⍝ Syllable complexity (approximated by vowel clusters)
        vowels ← 'aeiouAEIOU'
        syllable_density ← (+/+/vowels∊¨words) ÷ ≢words⌈1
        
        ⍝ Technical term density
        tech_terms ← 'implementation' 'functionality' 'optimization' 'configuration'
        tech_score ← (AI (⎕C text) (⎕C¨tech_terms)) ÷ 4
        
        score ← 0.4×(avg_length÷8)⌊1 + 0.3×(syllable_density÷3)⌊1 + 0.3×tech_score
    ∇

    ∇ score ← SentenceStructure text
    ⍝ Analyze sentence structure patterns
        sentences ← '.'(≠⊆⊢)text
        :If 0=≢sentences ⋄ score←0 ⋄ :Return ⋄ :EndIf
        
        ⍝ Average sentence length (AI tends toward optimal length)
        avg_sentence ← (+/≢¨sentences) ÷ ≢sentences
        optimal_length ← |avg_sentence - 15  ⍝ AI often targets ~15 words
        
        ⍝ Transition word usage
        transitions ← 'however' 'furthermore' 'additionally' 'therefore' 'moreover'
        transition_score ← (AI (⎕C text) (⎕C¨transitions)) ÷ 5
        
        ⍝ Passive voice indicators (AI uses more passive voice)
        passive ← 'is created' 'was generated' 'can be' 'will be' 'has been'
        passive_score ← (AI (⎕C text) (⎕C¨passive)) ÷ 5
        
        score ← 0.3×(1-(optimal_length÷15)⌊1) + 0.4×transition_score + 0.3×passive_score
    ∇

    ∇ score ← VocabularyDiversity text
    ⍝ Measure vocabulary diversity (AI often has lower diversity)
        words ← ' '(≠⊆⊢)text
        :If 2>≢words ⋄ score←0 ⋄ :Return ⋄ :EndIf
        
        ⍝ Type-token ratio (unique words / total words)
        unique_words ← ≢∪⎕C¨words
        total_words ← ≢words
        diversity_ratio ← unique_words ÷ total_words
        
        ⍝ AI tends to have lower diversity (inverse score)
        score ← 1 - diversity_ratio⌊1
    ∇

    ∇ score ← SyntacticPatterns text
    ⍝ Detect AI-specific syntactic patterns
        ⍝ Hedging language (AI is often uncertain)
        hedging ← 'might' 'could' 'potentially' 'possibly' 'perhaps' 'may'
        hedge_score ← (AI (⎕C text) (⎕C¨hedging)) ÷ 6
        
        ⍝ Qualification patterns (AI qualifies statements)
        qualifiers ← 'in general' 'typically' 'often' 'usually' 'generally'
        qualifier_score ← (AI (⎕C text) (⎕C¨qualifiers)) ÷ 5
        
        ⍝ Explanation patterns (AI explains more)
        explanations ← 'this means' 'in other words' 'that is' 'specifically'
        explanation_score ← (AI (⎕C text) (⎕C¨explanations)) ÷ 4
        
        score ← 0.4×hedge_score + 0.3×qualifier_score + 0.3×explanation_score
    ∇

    ∇ result ← EnsembleAI text
    ⍝ Ensemble AI detection combining multiple algorithms
        simple ← Detect text
        enhanced ← Enhanced text
        linguistic ← LinguisticAI text
        
        ⍝ Adaptive weighting based on text length
        text_length ← ≢text
        :If text_length < 50
            weights ← 0.6 0.3 0.1  ⍝ Favor simple for short text
        :ElseIf text_length < 200
            weights ← 0.3 0.4 0.3  ⍝ Balanced for medium text
        :Else
            weights ← 0.2 0.3 0.5  ⍝ Favor linguistic for long text
        :EndIf
        
        result ← +/weights × simple enhanced linguistic
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
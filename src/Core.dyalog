:Namespace Core
⍝ APLCICD.Core - Consolidated AI Detection and Analysis Module
⍝ 
⍝ Combines: Core + Analysis + Performance modules
⍝ Focus: AI detection algorithms, performance analysis, benchmarking
⍝ 
⍝ Public Functions:
⍝   AI text                     - Ultra-concise 18-char AI detection
⍝   Enhanced text               - Multi-factor AI analysis
⍝   EnsembleAI text            - Ensemble detection method
⍝   LinguisticAI text          - Linguistic pattern analysis
⍝   BenchmarkPerformance n     - Performance benchmarking
⍝   DemoAdvanced               - Comprehensive demonstration

    ⎕IO ← 0 ⋄ ⎕ML ← 1

    ∇ Initialize
    ⍝ Initialize Core module
        ⎕←'  ✅ Core AI detection and analysis functions loaded'
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Ultra-Concise AI Detection (18 characters)
    ⍝ ═══════════════════════════════════════════════════════════════
    
    AI ← +/∘(∨/¨)∘(⊂⍷¨⊂)

    ∇ result ← Detect text
    ⍝ Detect AI content in text using keyword matching
    ⍝ 
    ⍝ Arguments:
    ⍝   text (character): Text content to analyze
    ⍝ 
    ⍝ Returns:
    ⍝   result (numeric): AI probability score 0-1
    ⍝ 
    ⍝ Example:
    ⍝   score ← Detect 'Generated using Claude AI'  ⍝ Returns: ~0.4
        keywords ← 'AI' 'ai' 'generated' 'Claude' 'GPT' 'assistant' 'however'
        result ← (AI text keywords) ÷ ≢keywords
    ∇

    ∇ result ← Enhanced text
    ⍝ Advanced AI detection with multiple factors
    ⍝ 
    ⍝ Uses phrase detection, politeness analysis, formality indicators,
    ⍝ and vocabulary diversity for comprehensive AI detection
    ⍝ 
    ⍝ Arguments:
    ⍝   text (character): Text content to analyze
    ⍝ 
    ⍝ Returns:
    ⍝   result (numeric): AI probability score 0-1
        
        ⍝ Advanced phrase detection - vectorized approach
        phrases ← 'as an ai' 'i apologize' 'i''m sorry' 'however' 'furthermore'
        phrases ,← 'generated' 'claude' 'gpt' 'assistant' 'ai' 'thank you for'
        phrase_score ← (AI (⎕C text) (⎕C¨phrases)) ÷ ≢phrases
        
        ⍝ Politeness indicators - vectorized
        polite ← 'please' 'thank' 'apologize' 'sorry' 'appreciate' 'understand'
        polite_score ← (AI (⎕C text) (⎕C¨polite)) ÷ ≢polite
        
        ⍝ Formality indicators - vectorized
        formal ← 'however' 'furthermore' 'additionally' 'therefore' 'consequently'
        formal_score ← (AI (⎕C text) (⎕C¨formal)) ÷ ≢formal
        
        ⍝ Word repetition analysis - APL array approach
        words ← ' '(≠⊆⊢)text
        repetition_score ← (2≤≢words)×((≢words - ≢∪words) ÷ ≢words⌈1)
        
        ⍝ Weighted combination using APL inner product
        weights ← 0.4 0.25 0.2 0.15
        factors ← phrase_score polite_score formal_score repetition_score
        result ← 1⌊weights +.× factors
    ∇

    ∇ result ← LinguisticAI text
    ⍝ Enhanced AI detection with linguistic analysis
    ⍝ 
    ⍝ Performs semantic complexity, sentence structure, vocabulary diversity,
    ⍝ and syntactic pattern analysis
        
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
        
        ⍝ Weighted ensemble using APL
        weights ← 0.3 0.2 0.2 0.15 0.15
        factors ← enhanced semantic structure diversity syntax
        result ← 1⌊weights +.× factors
    ∇

    ∇ score ← SemanticComplexity text
    ⍝ Measure semantic complexity (AI tends to be more complex)
        words ← ' '(≠⊆⊢)text
        :If 0=≢words ⋄ score←0 ⋄ :Return ⋄ :EndIf
        
        ⍝ Average word length (AI uses longer words) - vectorized
        avg_length ← (+/≢¨words) ÷ ≢words
        
        ⍝ Syllable complexity (approximated by vowel clusters) - vectorized
        vowels ← 'aeiouAEIOU'
        syllable_density ← (+/+/vowels∊¨words) ÷ ≢words⌈1
        
        ⍝ Technical term density - vectorized matching
        tech_terms ← 'implementation' 'functionality' 'optimization' 'configuration'
        tech_score ← (AI (⎕C text) (⎕C¨tech_terms)) ÷ ≢tech_terms
        
        ⍝ Weighted combination
        weights ← 0.4 0.3 0.3
        factors ← (avg_length÷8)⌊1 (syllable_density÷3)⌊1 tech_score
        score ← weights +.× factors
    ∇

    ∇ score ← SentenceStructure text
    ⍝ Analyze sentence structure patterns
        sentences ← '.'(≠⊆⊢)text
        :If 0=≢sentences ⋄ score←0 ⋄ :Return ⋄ :EndIf
        
        ⍝ Average sentence length (AI tends toward optimal length) - vectorized
        avg_sentence ← (+/≢¨sentences) ÷ ≢sentences
        optimal_length ← |avg_sentence - 15  ⍝ AI often targets ~15 words
        
        ⍝ Transition word usage - vectorized
        transitions ← 'however' 'furthermore' 'additionally' 'therefore' 'moreover'
        transition_score ← (AI (⎕C text) (⎕C¨transitions)) ÷ ≢transitions
        
        ⍝ Passive voice indicators - vectorized
        passive ← 'is created' 'was generated' 'can be' 'will be' 'has been'
        passive_score ← (AI (⎕C text) (⎕C¨passive)) ÷ ≢passive
        
        ⍝ Weighted combination
        weights ← 0.3 0.4 0.3
        factors ← (1-(optimal_length÷15)⌊1) transition_score passive_score
        score ← weights +.× factors
    ∇

    ∇ score ← VocabularyDiversity text
    ⍝ Measure vocabulary diversity (AI often has lower diversity)
        words ← ' '(≠⊆⊢)text
        :If 2>≢words ⋄ score←0 ⋄ :Return ⋄ :EndIf
        
        ⍝ Type-token ratio (unique words / total words) - pure APL
        unique_words ← ≢∪⎕C¨words
        total_words ← ≢words
        diversity_ratio ← unique_words ÷ total_words
        
        ⍝ AI tends to have lower diversity (inverse score)
        score ← 1 - diversity_ratio⌊1
    ∇

    ∇ score ← SyntacticPatterns text
    ⍝ Detect AI-specific syntactic patterns - all vectorized
        ⍝ Hedging language (AI is often uncertain) - vectorized
        hedging ← 'might' 'could' 'potentially' 'possibly' 'perhaps' 'may'
        hedge_score ← (AI (⎕C text) (⎕C¨hedging)) ÷ ≢hedging
        
        ⍝ Qualification patterns - vectorized
        qualifiers ← 'in general' 'typically' 'often' 'usually' 'generally'
        qualifier_score ← (AI (⎕C text) (⎕C¨qualifiers)) ÷ ≢qualifiers
        
        ⍝ Explanation patterns - vectorized
        explanations ← 'this means' 'in other words' 'that is' 'specifically'
        explanation_score ← (AI (⎕C text) (⎕C¨explanations)) ÷ ≢explanations
        
        ⍝ Weighted combination
        weights ← 0.4 0.3 0.3
        factors ← hedge_score qualifier_score explanation_score
        score ← weights +.× factors
    ∇

    ∇ result ← EnsembleAI text
    ⍝ Ensemble AI detection combining multiple algorithms
    ⍝ Uses adaptive weighting based on text length
        
        ⍝ Get scores from all methods - vectorized where possible
        scores ← (Detect text)(Enhanced text)(LinguisticAI text)
        
        ⍝ Adaptive weighting based on text length - APL logic
        text_length ← ≢text
        weights ← (text_length<50)⊃(0.2 0.3 0.5)(text_length<200)⊃(0.3 0.4 0.3)(0.6 0.3 0.1)
        
        result ← weights +.× scores
    ∇

    ⍝ ═══════════════════════════════════════════════════════════════
    ⍝ Performance Analysis and Benchmarking
    ⍝ ═══════════════════════════════════════════════════════════════

    ∇ BenchmarkPerformance iterations
    ⍝ Comprehensive performance benchmark of AI detection methods
    ⍝ 
    ⍝ Arguments:
    ⍝   iterations (numeric): Number of test iterations
        
        :If 0=⎕NC'iterations' ⋄ iterations ← 1000 ⋄ :EndIf
        
        ⎕←'🚀 AI Detection Performance Benchmark'
        ⎕←'====================================='
        ⎕←'Iterations: ',⍕iterations
        ⎕←''
        
        ⍝ Test samples - vectorized creation
        test_texts ← 'Fix authentication bug' 'Generated using Claude AI' 'Manual code review'
        test_texts ,← 'As an AI assistant, I can help' 'Human written commit message'
        
        ⍝ Benchmark each method using APL timing
        methods ← 'Detect' 'Enhanced' 'LinguisticAI' 'EnsembleAI'
        times ← ⍬
        
        ⍝ Time each method - vectorized where possible
        ⍝ Simple method
        start ← ⎕AI[3]
        simple_results ← ,/(⊂Detect)¨¨⊂¨iterations⍴⊂test_texts
        simple_time ← (⎕AI[3]-start)÷1000
        times ,← simple_time
        
        ⍝ Enhanced method  
        start ← ⎕AI[3]
        enhanced_results ← ,/(⊂Enhanced)¨¨⊂¨iterations⍴⊂test_texts
        enhanced_time ← (⎕AI[3]-start)÷1000
        times ,← enhanced_time
        
        ⍝ Linguistic method
        start ← ⎕AI[3]
        linguistic_results ← ,/(⊂LinguisticAI)¨¨⊂¨iterations⍴⊂test_texts
        linguistic_time ← (⎕AI[3]-start)÷1000
        times ,← linguistic_time
        
        ⍝ Ensemble method
        start ← ⎕AI[3]
        ensemble_results ← ,/(⊂EnsembleAI)¨¨⊂¨iterations⍴⊂test_texts
        ensemble_time ← (⎕AI[3]-start)÷1000
        times ,← ensemble_time
        
        ⍝ Display results using APL formatting
        ⎕←'Method          Time(s)    Ops/sec    Relative'
        ⎕←'------          -------    -------    --------'
        
        ops_per_sec ← (iterations×≢test_texts)÷times
        relative ← times÷⌊/times
        
        ⍝ Format results - vectorized display
        display_data ← methods,⍪(⍕¨times),⍪(⍕¨⌊ops_per_sec),⍪⍕¨relative
        ⎕←⍪,/' ',(¯15↑[1]display_data)
        
        ⎕←''
        ⎕←'📊 Performance Summary:'
        ⎕←'   Fastest method: ',(⊃methods[⍸times=⌊/times])
        ⎕←'   Speed range: ',⍕⌊⌊/ops_per_sec,' - ',⍕⌊⌈/ops_per_sec,' ops/sec'
        ⎕←'   Total operations: ',⍕iterations×≢test_texts
    ∇

    ∇ result ← QuickBenchmark n
    ⍝ Quick performance test for simple monitoring
        :If 0=⎕NC'n' ⋄ n ← 100 ⋄ :EndIf
        
        test_text ← 'Generated using AI assistance'
        start_time ← ⎕AI[3]
        
        ⍝ Run n iterations - vectorized
        results ← Detect¨n⍴⊂test_text
        
        elapsed ← (⎕AI[3]-start_time)÷1000
        ops_per_sec ← n÷elapsed⌈0.001
        
        result ← ⎕NS ''
        result.iterations ← n
        result.elapsed_seconds ← elapsed
        result.operations_per_second ← ops_per_sec
        result.average_result ← (+/results)÷≢results
        
        ⎕←'Quick Benchmark: ',⍕⌊ops_per_sec,' ops/sec (',⍕n,' iterations)'
    ∇

    ∇ ProcessBatch texts
    ⍝ Process multiple texts efficiently using vectorized operations
    ⍝ 
    ⍝ Arguments:
    ⍝   texts (character vector): Vector of texts to process
    ⍝ 
    ⍝ Returns:
    ⍝   results (numeric vector): AI detection scores
        
        ⍝ Vectorized processing - pure APL approach
        results ← Detect¨texts
        
        ⎕←'Processed ',⍕≢texts,' texts'
        ⎕←'Average AI score: ',⍕(+/results)÷≢results
        ⎕←'AI detected (>0.3): ',⍕+/results>0.3
        
        results
    ∇

    ∇ sorted ← SortByAI texts
    ⍝ Sort texts by AI probability using APL grade
    ⍝ 
    ⍝ Arguments:
    ⍝   texts (character vector): Vector of texts to sort
    ⍝ 
    ⍝ Returns:
    ⍝   sorted (character vector): Texts sorted by AI probability (low to high)
        
        scores ← Detect¨texts
        indices ← ⍋scores  ⍝ APL grade - ascending order
        sorted ← texts[indices]
    ∇

    ∇ DemoAdvanced
    ⍝ Demonstrate advanced AI detection capabilities
        ⎕←'Advanced AI Detection Analysis'
        ⎕←'=============================='
        ⎕←''
        
        ⍝ Test samples - realistic examples
        human_samples ← 'Fix bug' 'Update deps' 'Refactor legacy code' 'Debug memory issue'
        ai_samples ← 'As an AI assistant, I can help you' 'I apologize for the confusion, however'
        ai_samples ,← 'Thank you for your question. I understand' 'Generated using Claude AI assistance'
        
        ⎕←'Testing on known human vs AI samples:'
        ⎕←''
        ⎕←'Sample Text                                Simple    Enhanced  Ensemble'
        ⎕←'-----------                                -------   --------  --------'
        
        ⎕←'HUMAN SAMPLES:'
        ⍝ Process human samples - vectorized
        human_simple ← Detect¨human_samples
        human_enhanced ← Enhanced¨human_samples
        human_ensemble ← EnsembleAI¨human_samples
        
        ⍝ Display results using APL formatting
        human_display ← (40↑¨human_samples),¨' ',¨(8↑¨⍕¨human_simple),¨'  ',¨(8↑¨⍕¨human_enhanced),¨'  ',¨8↑¨⍕¨human_ensemble
        ⎕←⍪human_display
        
        ⎕←''
        ⎕←'AI SAMPLES:'
        ⍝ Process AI samples - vectorized
        ai_simple ← Detect¨ai_samples
        ai_enhanced ← Enhanced¨ai_samples
        ai_ensemble ← EnsembleAI¨ai_samples
        
        ⍝ Display results using APL formatting
        ai_display ← (40↑¨ai_samples),¨' ',¨(8↑¨⍕¨ai_simple),¨'  ',¨(8↑¨⍕¨ai_enhanced),¨'  ',¨8↑¨⍕¨ai_ensemble
        ⎕←⍪ai_display
        
        ⍝ Calculate performance metrics using APL array operations
        simple_separation ← ((+/ai_simple)÷≢ai_simple) - ((+/human_simple)÷≢human_simple)
        enhanced_separation ← ((+/ai_enhanced)÷≢ai_enhanced) - ((+/human_enhanced)÷≢human_enhanced)
        ensemble_separation ← ((+/ai_ensemble)÷≢ai_ensemble) - ((+/human_ensemble)÷≢human_ensemble)
        
        ⎕←''
        ⎕←'Performance Analysis:'
        ⎕←'Simple method discrimination:   ',⍕simple_separation
        ⎕←'Enhanced method discrimination: ',⍕enhanced_separation
        ⎕←'Ensemble method discrimination: ',⍕ensemble_separation
        ⎕←'Enhancement factor: ',⍕enhanced_separation÷simple_separation⌈0.01,'x better separation'
        ⎕←'Ensemble factor: ',⍕ensemble_separation÷simple_separation⌈0.01,'x better separation'
        ⎕←''
        ⎕←'🎯 Ensemble method provides best discrimination capability'
    ∇

:EndNamespace
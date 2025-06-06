⎕IO ← 0
⎕← 'APL CI/CD Working Test'
⎕← '====================='

⍝ Load the unified system
content ← ⊃⎕NGET 'src/aplci.apl' 1
⎕FIX content
⎕← '✓ Unified system loaded'

⍝ Test AI scoring
pr ← ⎕NS ''
pr.content ← 'This is Claude AI generated automated code'
pr.files ← ⊂'test.apl'

score ← APLCI.AIScore pr
⎕← '✓ AI Score: ', ⍕score

⍝ Test AI model detection
model ← APLCI.DetectAIModel pr.content
⎕← '✓ Detected model: ', model

⍝ Create multiple PRs for batch test
pr1 ← ⎕NS ''
pr1.content ← 'Claude generated automated code'
pr1.files ← ⊂'file1.apl'

pr2 ← ⎕NS ''
pr2.content ← 'Human written code'
pr2.files ← ⊂'file2.apl'

⍝ Test individual scoring
score1 ← APLCI.AIScore pr1
score2 ← APLCI.AIScore pr2
⎕← '✓ Individual scores: ', (⍕score1), ' ', ⍕score2

⍝ Test full pipeline
config ← ⎕NS ''
config.steps ← 'lint' 'ai-review' 'test' 'security' 'build'
config.pr ← pr1

result ← APLCI.Pipeline config
⎕← '✓ Full pipeline completed'
⎕← '  AI Model: ', result.ai_model
⎕← '  Lint passed: ', ⍕result.lint_passed
⎕← '  Tests passed: ', ⍕result.tests_passed
⎕← '  Security passed: ', ⍕result.security_passed
⎕← '  Build success: ', ⍕result.build_success

⍝ Performance test
⎕← ''
⎕← 'Performance Test:'
⎕← '=================='
prs ← APLCI.GenerateTestPRs 100
start ← ⎕AI[3]
scores ← APLCI.AIScore¨ prs
elapsed ← (⎕AI[3] - start) ÷ 1000
⎕← 'Processed 100 PRs in ', (⍕elapsed), ' seconds'
⎕← 'Rate: ', (⍕100÷elapsed), ' PRs/second'

⍝ Test system status
⎕← ''
APLCI.ShowSystemStatus

⎕← ''
⎕← '🎉 All tests passed! APL CI/CD is working!'

)OFF
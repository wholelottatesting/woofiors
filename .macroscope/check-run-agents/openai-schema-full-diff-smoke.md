---
title: OpenAI Schema Full Diff Smoke
model: gpt-5-6-luna
reasoning: medium
effort: medium
input: full_diff
include:
  - "src/openai-schema-regex-smoke.ts"
---

This is a production smoke test for the Check Run Agent terminal-output schema.
Review the in-scope fixture without posting comments. Conclude with state
`success`, title `OpenAI full-diff schema accepted`, and the one-sentence
summary `The Luna full-diff run completed with meaningful structured output.`

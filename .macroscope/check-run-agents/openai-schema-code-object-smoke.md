---
title: OpenAI Schema Code Object Smoke
model: gpt-5-6-luna
reasoning: medium
effort: medium
input: code_object
include:
  - "src/openai-schema-regex-smoke.ts"
---

This is a production smoke test for the Check Run Agent terminal-output schema.
Review each in-scope code object without posting comments. Report no issue for
the deliberately straightforward fixture and return meaningful, non-placeholder
structured output.

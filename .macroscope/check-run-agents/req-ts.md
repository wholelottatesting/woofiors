---
title: Req TS Check
model: claude-sonnet-4-6
reasoning: low
effort: low
tools:
  - browse_code
conclusion: failure
requiredStatusCheck: true
include:
  - "**/*.ts"
  - "**/*.tsx"
exclude:
  - "**/*.d.ts"
---

You are a trivial test check. Look at the changed TypeScript files in this PR.

If any changed file contains the exact string "TODO-FAIL", conclude with state failure and say which file contained it.

Otherwise conclude with state success. Do not post any comments. Keep your summary to one sentence.

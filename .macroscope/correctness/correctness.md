---
include:
  - '{{ .RepoName }}/v2/**'
waitsFor:
  - '{{ .RepoName }}-v2-ready'
---
FOUNDATION-V2 correctness event={{ .RepoName }}.

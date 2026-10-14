---
include:
  - '{{ .RepoName }}/v1/**'
waitsFor:
  - '{{ .RepoName }}-v1-ready'
---
FOUNDATION-V1 correctness event={{ .RepoName }}.

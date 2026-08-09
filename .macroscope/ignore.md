# Ignore rules, present only on this PR branch.
#
# NOTE: when an ignore file is found, its patterns REPLACE the built-in
# defaults entirely — they are not merged. That is why the usual noise
# directories are restated here.
#
# The probe: src/head-probe-ignored.ts and src/head-probe-reviewed.ts contain
# the same bug. Only the first is listed below. If this file was read from the
# PR head, the review flags the "reviewed" twin and stays silent on the
# "ignored" twin. If config still came from the default branch, this file does
# not exist there, the defaults apply, and BOTH twins get flagged.

src/head-probe-ignored.ts

**/node_modules/**
**/dist/**
**/*.lock

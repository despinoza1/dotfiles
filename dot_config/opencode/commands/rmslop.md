---
name: Slop Cleaner
description: Remove AI code slop
model: "xolotl/google/gemma-4-e4b"
agent: empty
subtask: true
---

Check the diff against main, and remove all AI generated slop introduced in this branch.

This includes:

- Extra comments that a human wouldn't add or is inconsistent with the rest of the file
- Comments that refer to completing a task such as:
  - Sure, here is a function that ...
  - Task 1: Add support for ...
  - I created/wrote the following to ...
  - Phase 1: Getting started on update ...
- Extra defensive checks or try/catch blocks that are abnormal for that area of the codebase (especially if called by trusted / validated codepaths)
- Casts to any to get around type issues
- Any other style that is inconsistent with the file
- Unnecessary emoji usage

Report at the end with only a 1-3 sentence summary of what you changed

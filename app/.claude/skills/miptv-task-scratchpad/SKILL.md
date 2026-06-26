---
name: miptv-task-scratchpad
description: Instructions for managing task-specific temporary directories and intermediate planning/analysis/walkthrough files under /Users/jmolina/.gemini/antigravity/scratch/tasks/<task-name>/.
---

# MiPTV Task Scratchpad Management Skill

This skill outlines instructions for creating, reading, writing, and updating files within the task-specific scratch directory to coordinate work between the **Planning**, **Technical Analysis**, and **Implementation** agents.

---

## 📂 Scratch Directory Structure

All agents must organize their intermediate task outputs under the absolute scratch path:
- `/Users/jmolina/.gemini/antigravity/scratch/tasks/<task-name>/`

### Definitions
- `<task-name>`: A short, descriptive name of the task in lowercase kebab-case (e.g. `lazy-sync-channels`, `favorites-isar-migration`, `secure-xtream-storage`).

---

## 🛠️ Step-by-Step Agent Workflow Instructions

### Step 1: Initialize Task & Draft (Planning Agent)
1. Determine the `<task-name>` based on the user's request.
2. Initialize the task directory (it will be automatically created if using file creation tools).
3. Draft a high-level solution plan detailing requirements and architecture impact.
4. Save the plan to:
   `/Users/jmolina/.gemini/antigravity/scratch/tasks/<task-name>/planning_draft.md`
5. Hand off to the technical analyst.

---

### Step 2: Refine to Technical Design (Technical Analysis Agent)
1. Read the high-level plan from `/Users/jmolina/.gemini/antigravity/scratch/tasks/<task-name>/planning_draft.md`.
2. Inspect the source codebase using search and viewing tools to locate exactly where changes should happen.
3. Review schema modifications and design details against the project guidelines (Riverpod, Isar models, isolates, and MediaKit).
4. Write the finalized technical implementation plan detailing modifications, new files, and tests to:
   `/Users/jmolina/.gemini/antigravity/scratch/tasks/<task-name>/implementation_plan.md`
5. Ask the user for approval.

---

### Step 3: Implement & Validate (Implementation Agent)
1. Read the approved `/Users/jmolina/.gemini/antigravity/scratch/tasks/<task-name>/implementation_plan.md`.
2. Apply changes sequentially to files in the `lib/` and `test/` directories.
3. Verify changes (compile check, linter rules, test execution).
4. Write a walkthrough summarizing findings, tested logic, and validation to:
   `/Users/jmolina/.gemini/antigravity/scratch/tasks/<task-name>/walkthrough.md`
5. Signal task completion to the user.

---

## ⚠️ Important Rules
- Do NOT delete other task folders in the scratch directory. Keep them intact for history.
- Always use absolute paths when referencing the task scratchpad directory in code/scripts or file tools to avoid relative path resolution discrepancies.

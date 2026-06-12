---
description: Get a 100-Days-of-Code day's plan as issue-ready fields + a learning pack
argument-hint: <day-number>
allowed-tools: Bash, Read
---

Produce two things for **Day $1** of the QRSafe 100 Days of Code challenge: (A) the GitHub issue content, and (B) a learning pack that teaches the day's Swift concept and scaffolds Carlos's reflection habit (notebook → PR 3-questions → CodeUp).

Steps:

1. Source the Obsidian config and fetch the schedule note, then isolate the Day $1 entry (the bullet that starts `**Day $1 —` up to the next `**Day`):
   ```bash
   source ~/.config/obsidian-brain/env
   curl -sk -H "Authorization: Bearer $OBSIDIAN_API_KEY" \
     "$OBSIDIAN_BASE_URL/vault/_AI/Projects/qrsafe/100-Days-Schedule.md"
   ```
2. Read `scripts/days.tsv` and grab the row where column 1 == $1 → gives the short title, phase label, and milestone version.

3. From the schedule entry, extract: the goal, the 🧠 Swift concept, and the 🔗 doc links.

4. Read the existing repo code the day builds on (e.g. `qrsafe/*.swift` — design tokens, prior-day files) so the learning pack references real symbols already in the project, not invented ones. Grep/glob as needed.

**Teaching rule (non-negotiable):** Carlos writes ALL app code himself. NEVER output a copy-pasteable solution for the day's task. In the learning pack you may show: public Apple API signatures, tiny generic illustrations of a concept (≤3 lines, not the actual task), and skeletons with `// you fill this` holes. The goal is that he can perform the issue by himself with enough understanding to not be stuck.

---

Then output **exactly** these two blocks.

**BLOCK A — issue content** (concrete acceptance criteria derived from the day's goal — 2–4 checkboxes, not placeholders):

```
Title: Day $1 — <title from days.tsv>
Labels: 100daysofcode, <phase label>
Milestone: <milestone version + name>

## User story
As a developer learning Swift in public, I want <goal restated as a capability>, so that <benefit>.

## Context
Day $1 of 100. <one line: where this fits>.

## Swift concept(s) for today
- <concept> — <why it matters> (<doc link>)

## Acceptance criteria
- [ ] <concrete, testable criterion 1>
- [ ] <concrete criterion 2>
- [ ] App builds & runs on simulator (device if camera-related)

## Definition of Done
- [ ] Tests written/updated and green
- [ ] App builds & runs
- [ ] Notebook entry written (concept + learnings)
- [ ] CodeUp day notes filled
- [ ] PR opened with `Closes #NN` (body answers What / Why / What I learned) and merged
- [ ] Instagram post published

## Time box
Min 1h · target ~3h

## Resources
- <links from the schedule entry>
```

**BLOCK B — learning pack** (NOT for the issue; this is Carlos's starting point):

```
## 🧠 Concept brief — <concept>
<3–6 sentences: the mental model. What problem it solves, where it sits in SwiftUI/Swift, and how it connects to what he already built (name the real symbols from the repo). Plain language.>

Key API:
- `<signature>` — <what each part means>
- <…>

Tiny illustration (generic, NOT the task):
<≤3 lines showing the concept's shape only>

Watch out for:
- <common pitfall 1>
- <pitfall 2>

## 🗺️ How to satisfy the issue (do it yourself)
1. <ordered step toward acceptance criterion 1 — guidance + which file/symbol, no full code>
2. <step …>
3. <how to verify: build/run, what to look for in preview/simulator>
Skeleton to fill (holes are yours):
<minimal skeleton with `// you fill this` markers — signatures only, not the answer>

## ✍️ Reflection scaffold (notebook → PR body → CodeUp)
**What:** <one-line draft of what got built today — he edits>
**Why:** <one line: why it matters / the decision made>
**What I learned:** <2–3 bullets drafted from the concept brief — he rewrites in his words>

## 📝 CodeUp note (paste + tweak)
<3–5 sentence summary tying the day's concept to the build, in first person, ready to drop into the CodeUp daily log>
```

Finally, print the one-liner to create the issue automatically:
`./scripts/new-day.sh $1`

Keep BLOCK A terse for copy-paste. BLOCK B is the teaching — substantive but no solution code. No extra commentary outside the two blocks.

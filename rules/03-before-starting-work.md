# Rule 3 — Before Starting Work

## Core Principle
Every team must complete pre-work checklist before implementation.

## Mandatory Pre-Work Checklist

### 1. Read Project Overview
- [ ] **Main project documentation** reviewed
- [ ] **Project goals and objectives** understood
- [ ] **Current project status** assessed
- [ ] **Stakeholder requirements** identified

### 2. Check Current Active Phase
- [ ] **Current phase definition** read from `.ssot/phases/current-phase.md`
- [ ] **Phase objectives** clearly understood
- [ ] **Phase deliverables** identified
- [ ] **Phase exit criteria** known

### 3. Review Recent Team Logs
- [ ] **Last 3-5 team files** reviewed for context
- [ ] **Recent decisions** understood
- [ ] **Previous blockers** identified
- [ ] **Handoff notes** from previous team read

### 4. Check Open Questions
- [ ] **`.questions/open/` directory** reviewed
- [ ] **Relevant questions** identified for your work
- [ ] **Question status** (new/working/blocked) noted
- [ ] **Related answers** reviewed if available

### 5. Claim Team Number and Create Team File
- [ ] **Highest team number** identified
- [ ] **New team ID** assigned (highest + 1)
- [ ] **Team file created** with proper template
- [ ] **Team file initialized** with current context

### 6. Ensure Tests Pass Before Making Changes
- [ ] **Full test suite** run successfully
- [ ] **Baseline tests** (if applicable) passing
- [ ] **Integration tests** passing
- [ ] **Performance benchmarks** stable

## Implementation Readiness Assessment

### Technical Readiness
- [ ] **Development environment** properly configured
- [ ] **Dependencies** installed and up to date
- [ ] **Database schema** synchronized
- [ ] **Build process** working correctly

### Context Readiness
- [ ] **Codebase structure** understood
- [ ] **Relevant APIs** reviewed
- [ ] **Data models** understood
- [ ] **Business logic** context clear

### Risk Assessment
- [ ] **Potential blockers** identified
- [ ] **Dependencies on other work** noted
- [ ] **Risks to timeline** assessed
- [ ] **Mitigation strategies** planned

## Pre-Work Documentation

### Team File Initialization
Update your team file with:

```markdown
## Pre-Work Assessment
### Project Understanding
- **Overview**: [Brief summary of project goals]
- **Current Phase**: [Phase name and objectives]
- **My Role**: [What this team will accomplish]

### Context Review
- **Previous Teams**: [Summary of recent work]
- **Open Questions**: [Relevant questions affecting this work]
- **Known Issues**: [Existing problems to consider]

### Readiness Check
- **Tests Status**: [All tests passing ✓]
- **Environment**: [Dev environment ready ✓]
- **Dependencies**: [All dependencies satisfied ✓]
- **Blockers**: [None identified ✓]

### Work Plan
- **Primary Objective**: [Main goal for this session]
- **Secondary Objectives**: [Additional goals if time permits]
- **Success Criteria**: [How we'll know we're done]
```

## Gate Criteria

### Do Not Start If:
- **Any tests are failing** - Fix tests first
- **Critical questions unanswered** - Get clarification
- **Previous work incomplete** - Finish or document gaps
- **Environment issues** - Resolve setup problems
- **Requirements unclear** - Ask for clarification

### Ready To Start When:
- **All checklist items completed** ✓
- **Team file initialized** ✓
- **Context clearly understood** ✓
- **No blocking issues** ✓
- **Success criteria defined** ✓

## Common Pre-Work Mistakes

### ❌ Avoid These
- **Jumping into code** without understanding context
- **Ignoring failing tests** with intention to fix later
- **Skipping team file creation** to save time
- **Not reviewing previous work** leading to duplicated effort
- **Starting with unclear requirements**

### ✅ Best Practices
- **Thorough context review** prevents rework
- **Complete test runs** catch issues early
- **Team file documentation** enables continuity
- **Question clarification** avoids wrong direction
- **Clear success criteria** ensures focused work

## Quality Assurance

### Self-Validation
Before starting implementation, ask yourself:

1. **Do I understand what success looks like?**
2. **Are all tests currently passing?**
3. **Have I learned from previous teams?**
4. **Are there any unanswered questions blocking me?**
5. **Is my team file properly initialized?**

### Team Lead Validation (if applicable)
- [ ] **Pre-work checklist reviewed**
- [ ] **Team file quality checked**
- [ ] **Context understanding verified**
- [ ] **Readiness confirmed**

---

## Remember
**5 minutes of preparation saves hours of rework. Complete the checklist.**

# Rule 1 — Single Source of Truth (SSOT)

## Core Principle
Every project must define one canonical location for all planning and coordination.

## Required SSOT Components

### Primary Location
Every project must have ONE canonical location for:

- **Plans** - Project roadmap, feature planning, sprint planning
- **Architecture documents** - System design, API specifications, database schemas
- **Team logs** - Meeting notes, decision records, progress tracking
- **Questions** - Open questions, clarifications, stakeholder feedback
- **Phase definitions** - Current development phase, milestones, deliverables

## Implementation Requirements

### SSOT Location Structure
```
project-root/
├── .ssot/
│   ├── plans/
│   │   ├── roadmap.md
│   │   ├── current-sprint.md
│   │   └── future-sprints.md
│   ├── architecture/
│   │   ├── system-design.md
│   │   ├── api-specification.md
│   │   └── database-schema.md
│   ├── team-logs/
│   │   ├── meetings/
│   │   ├── decisions/
│   │   └── progress/
│   ├── questions/
│   │   ├── open/
│   │   ├── answered/
│   │   └── blocked/
│   └── phases/
│       ├── current-phase.md
│       ├── phase-history.md
│       └── phase-transitions.md
```

### SSOT Rules

#### Rule: Centralized Planning
**All planning and coordination must happen in that SSOT location. Never fragment planning across multiple places.**

#### Rule: Single Reference
- **No duplicate documents** - If information exists in SSOT, reference it, don't duplicate
- **No external planning tools** - Use SSOT instead of scattered tools (Trello, Jira, etc.)
- **No email decisions** - All decisions must be documented in SSOT team logs
- **No chat-based planning** - Move chat discussions to SSOT documentation

#### Rule: Update Protocol
- **Real-time updates** - Update SSOT immediately when decisions are made
- **Version control** - All SSOT files must be in version control
- **Change notifications** - Team must be notified of SSOT changes
- **Backup strategy** - SSOT must have regular backups

## Access and Permissions

### Team Roles
- **SSOT Owner** - Maintains structure and enforces rules
- **Contributors** - Can update specific sections
- **Readers** - View-only access to most information
- **Auditors** - Review compliance and completeness

### Update Workflow
1. **Identify correct SSOT section** for your information
2. **Check for existing content** before creating new
3. **Update in place** rather than creating duplicates
4. **Notify relevant team members** of changes
5. **Reference SSOT location** in communications

## Integration with Development

### Before Starting Work
- **Read current phase** definition
- **Review relevant plans** for your work
- **Check open questions** that might affect your task
- **Understand architecture** decisions relevant to your area

### During Development
- **Update progress** in team logs
- **Document decisions** as they are made
- **Ask questions** in designated question area
- **Reference SSOT** in code comments and PRs

### After Completion
- **Update phase status** if phase transition occurs
- **Document lessons learned** in team logs
- **Close or answer** relevant questions
- **Update plans** for next iteration

## Tools and Automation

### Recommended Tools
- **Markdown files** in version control (preferred)
- **Wiki systems** with version control integration
- **Documentation platforms** with API access
- **Project management tools** with export capabilities

### Automation Scripts
- **SSOT validation** - Check for duplicates and inconsistencies
- **Link checking** - Verify all references are valid
- **Change detection** - Notify team of updates
- **Compliance reporting** - Ensure SSOT rules are followed

## Quality Assurance

### SSOT Health Checks
- **No orphaned content** - Everything should be referenced
- **No contradictions** - Information should be consistent
- **No outdated content** - Regular review and cleanup
- **No access issues** - Team can access needed information

### Metrics
- **SSOT usage rate** - How often team references SSOT
- **Information freshness** - Age of last updates
- **Question resolution time** - How quickly questions are answered
- **Decision documentation rate** - Percentage of decisions documented

---

## Remember
**Fragmented planning = fragmented execution. Centralized planning = coordinated success.**

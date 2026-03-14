# Rule 2 — Team Registration & Identity

## Core Principle
Every distinct AI conversation = one team. Your Team ID is permanent for the lifetime of the conversation, with full user traceability.

## User Identity Registration

### During Global Rules Installation
When installing the global rules, each user must provide:

- **Full Name** - Legal name for traceability
- **Email Address** - Professional contact information
- **Team/Department** - Organizational affiliation (optional)
- **User ID Prefix** - Short identifier for team files (e.g., "jsmith" for John Smith)

### User Identity Storage
User information is stored in `.users/` directory:
```
.users/
├── USER_<user-id-prefix>.md
└── user-registry.json
```

#### User Registration Template
```markdown
# USER_<user-id-prefix>

## User Identity
- **Full Name**: [User's full name]
- **Email**: [Professional email]
- **Team/Department**: [Organizational unit]
- **User ID Prefix**: [user-id-prefix]
- **Registration Date**: [Date/Time]
- **Installation Version**: [Rules version]

## Team History
- **TEAM_001** - [Date/Time] - [Project description]
- **TEAM_005** - [Date/Time] - [Project description]
- **TEAM_012** - [Date/Time] - [Current project]
```

## Team ID Assignment

### Enhanced Team Number System

1. **Check existing teams** in `.teams/` directory
2. **Find highest existing team number** (e.g., TEAM_015)
3. **Your number = highest + 1** (e.g., TEAM_016)
4. **Team ID is permanent** for this conversation
5. **Link to user identity** through registration system

### Team File Creation

Create your team log file at:
```
.teams/TEAM_XXX_<user-id-prefix>_<summary>.md
```

Where:
- `XXX` = your assigned team number (3 digits, zero-padded)
- `<user-id-prefix>` = your registered user ID prefix
- `<summary>` = brief description of conversation purpose

#### Enhanced Team File Template
```markdown
# TEAM_XXX_<user-id-prefix>_<summary>

## Team Information
- **Team ID**: TEAM_XXX
- **User ID**: <user-id-prefix>
- **User Full Name**: [Registered full name]
- **User Email**: [Registered email]
- **Started**: [Date/Time]
- **Context**: [Brief description of conversation purpose]
- **Members**: [AI assistant, User Full Name (<user-id-prefix>)]

## Progress Log
### [Date/Time] - Session Start
- **Objective**: [What we're trying to accomplish]
- **Initial Assessment**: [Current state analysis]
- **User Context**: [User's role and expertise]

### [Date/Time] - Progress Update
- **Completed**: [What was accomplished]
- **Next Steps**: [What needs to be done next]
- **Blockers**: [Any issues preventing progress]
- **User Decisions**: [Key decisions made by user]

## Decisions Made
- **[Date/Time]**: [Decision description and reasoning]
- **Decision Maker**: [User Full Name or AI assistant]

## Questions Raised
- **[Date/Time]**: [Question and status (open/answered)]
- **Asked By**: [User Full Name or AI assistant]

## Handoff Notes
- **Current State**: [Where we left off]
- **Next Actions**: [What the next team should do]
- **Important Context**: [Critical information for continuation]
```

## Code Comment Standards

### When Modifying Code
Always include your team ID in code comments:

```javascript
// TEAM_XXX: Reason for change
function updateUser(userData) {
  // TEAM_XXX: Added validation for security requirements
  if (!userData.email || !isValidEmail(userData.email)) {
    throw new Error('Valid email required');
  }
  // ... rest of function
}
```

### Comment Guidelines
- **Be specific** about what changed and why
- **Reference requirements** or decisions when applicable
- **Include team ID** for traceability
- **Keep comments concise** but informative

## Team Workflow Integration

### Before Starting Work
1. **Claim your team number** following the assignment process
2. **Create your team file** with the template
3. **Read existing team logs** for context
4. **Check for related questions** in `.questions/`

### During Work
1. **Update team file** with progress regularly
2. **Document decisions** as they are made
3. **Add code comments** with team ID for all changes
4. **Reference team ID** in communications

### Before Finishing
1. **Complete progress log** with final status
2. **Document handoff notes** for next team
3. **Update any related questions** with answers
4. **Ensure all code has team ID comments**

## Team File Management

### File Organization
```
.teams/
├── TEAM_001_initial-setup.md
├── TEAM_002_feature-development.md
├── TEAM_003_bug-fix-investigation.md
└── TEAM_XXX_current-conversation.md
```

### File Maintenance
- **Keep files active** during conversation
- **Archive completed conversations** after handoff
- **Reference previous teams** when relevant
- **Maintain chronological order**

## Traceability Benefits

### For Future Teams
- **Understand evolution** of code and decisions
- **Contact previous teams** for context if needed
- **Avoid repeating mistakes** or re-solving solved problems
- **Build on previous work** effectively

### For Current Team
- **Maintain focus** on current objectives
- **Document reasoning** for future reference
- **Track progress** systematically
- **Ensure accountability** for changes

## Quality Assurance

### Team File Validation
- [ ] Team ID correctly assigned (highest + 1)
- [ ] Team file created with proper template
- [ ] Progress log updated regularly
- [ ] All code changes include team ID comments
- [ ] Decisions documented with reasoning
- [ ] Handoff notes complete before finishing

### Integration Checks
- [ ] Previous team logs reviewed for context
- [ ] Related questions checked and updated
- [ ] SSOT documents referenced and updated
- [ ] Code comments follow team ID standard

---

## Remember
**Every conversation leaves a trace. Future teams depend on your documentation.**

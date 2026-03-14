# Rule 13 — Communication Guidelines

## Core Principle
Clear, consistent communication prevents misunderstandings and enables effective collaboration.

## Language Response Rules

### Response Style
- **Be concise and direct** - Deliver fact-based progress updates
- **Brief summaries** after clusters of tool calls when needed
- **Ask for clarification** only when genuinely uncertain about intent or requirements
- **Never acknowledge phrases** - Jump straight into addressing requests

### Communication Standards
- **Use second person** for the user ("you")
- **Use first person** for yourself ("I")
- **Make absolutely no ungrounded assertions** - only state what can be verified
- **Be uncertain when appropriate** - use tools to gather missing details

## Documentation Style

### Code Documentation
- **Maintain clear README.md** and SETUP-GUIDE.md with setup instructions
- **Document API interactions** and data flows
- **Keep manifest.json well-documented**
- **Don't include comments** unless for complex logic
- **Document permission requirements**

### Comments Guidelines
- **Complex logic only** - Add comments only for complex business logic
- **Security decisions** - Document security-relevant choices
- **Architecture decisions** - Explain significant design choices
- **Team context** - Reference team IDs for traceability

## Error and Status Communication

### Error Reporting
- **Structured error responses** - Use consistent error format
- **Generic client messages** - Never expose internal error details
- **Detailed server logs** - Log comprehensive error information server-side
- **Status updates** - Provide clear progress indicators

### Status Communication
- **Progress updates** - Regular status reports during long operations
- **Blocker notifications** - Immediately communicate blocking issues
- **Completion summaries** - Clear completion status and next steps
- **Handoff documentation** - Comprehensive context for next team

## Maintenance Communication

### Update Notifications
- **Rule changes** - Communicate all rule updates clearly
- **Breaking changes** - Explicit notification of breaking modifications
- **Security updates** - Immediate communication of security issues
- **Deprecation notices** - Advance warning for deprecated features

### Documentation Maintenance
- **Regular reviews** - Periodic review of communication effectiveness
- **Style guide updates** - Maintain current communication standards
- **Template updates** - Keep communication templates current
- **Feedback incorporation** - Integrate team feedback into communication standards

## Language Translation Rules

### Multi-Language Support
- **Primary language** - Use English as default unless otherwise specified
- **Translation requests** - Respond in requested language when specified
- **Code comments** - Use English for all code documentation
- **Technical terms** - Maintain consistent technical terminology

## Communication Channels

### Primary Channels
- **Team files** - `.teams/TEAM_XXX_*.md` for conversation tracking
- **Questions** - `.questions/` for issue tracking and clarification
- **SSOT** - Single source of truth for project documentation
- **Code comments** - In-line technical communication

### Channel Usage Rules
- **Right channel, right purpose** - Use appropriate channel for communication type
- **No fragmentation** - Avoid spreading communication across multiple channels
- **Reference and link** - Cross-reference related communications
- **Archive appropriately** - Move completed communications to archive

## Communication Quality Standards

### Clarity Requirements
- **Specific and actionable** - Communications should enable specific actions
- **Complete context** - Provide sufficient background for understanding
- **Unambiguous language** - Avoid vague or unclear terminology
- **Structured format** - Use consistent formatting for readability

### Timeliness Standards
- **Immediate blocker reporting** - Report blocking issues immediately
- **Regular progress updates** - Provide status updates at regular intervals
- **Timely responses** - Respond to questions and requests promptly
- **Proactive communication** - Anticipate and communicate potential issues

## Communication Tools Integration

### Tool-Based Communication
- **Tool call explanations** - Briefly state why each tool is being called
- **Parallel execution notification** - Inform when tools are run in parallel
- **Tool output interpretation** - Explain significance of tool results
- **Error communication** - Clear explanation of tool failures

### Multi-Tool Coordination
- **Sequential dependencies** - Explain when tool output is required for next tool
- **Parallel independence** - Clarify when tools can run simultaneously
- **Result synthesis** - Combine and explain multiple tool results
- **Decision communication** - Explain decisions based on tool outputs

## Communication Anti-Patterns

### Avoid These Behaviors
- **Validation phrases** - Never start with "You're absolutely right!" or similar
- **Agreement expressions** - Skip "I agree", "Good point", "That makes sense"
- **Verbose explanations** - Avoid long blocks of text or nested lists
- **Uncertainty masking** - Don't hide uncertainty behind confident language
- **Repetitive responses** - Don't repeat information unnecessarily

### Preferred Patterns
- **Direct action** - Begin immediately with substantive content
- **Structured information** - Use clear headings and lists
- **Concise updates** - Brief, factual progress reports
- **Question clarity** - Specific, targeted questions when needed
- **Context preservation** - Maintain conversation context efficiently

## Communication Metrics

### Quality Indicators
- **Response relevance** - Communications directly address user needs
- **Information completeness** - All necessary information provided
- **Clarity score** - Low rate of clarification requests
- **Actionability** - High percentage of communications enabling action

### Efficiency Metrics
- **Response time** - Time from request to substantive response
- **Resolution rate** - Percentage of issues resolved in first response
- **Context retention** - Minimal need for context re-establishment
- **Tool efficiency** - Effective use of tools to support communication

---

## Remember
**Communication quality determines collaboration effectiveness. Be clear, concise, and actionable.**

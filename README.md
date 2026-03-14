# AI Development Global Rules

A comprehensive, unified framework for AI software development teams combining quality-first principles, team workflow standards, and security best practices.

## Overview

This repository contains **22 streamlined rules** that merge the Universal AI Team Rulebook with enterprise-grade development standards. The framework ensures consistent, high-quality development across AI teams while maintaining security, traceability, and collaboration excellence.

## Rule Structure

### Foundation Rules (00-07) - Core Principles
- **Rule 00** - Quality Over Speed
- **Rule 01** - Single Source of Truth (SSOT)
- **Rule 02** - Team Workflow (+ Solo Mode)
- **Rule 03** - Work Boundaries (Before/During/After)
- **Rule 04** - Regression Protection
- **Rule 05** - Breaking Changes
- **Rule 06** - Code Cleanliness (No Dead Code + TODO Tracking)
- **Rule 07** - Ask Questions Early

### Reference & Communication (08-09)
- **Rule 08** - Quick Reference
- **Rule 09** - Communication

### Code Standards (10-12)
- **Rule 10** - Code Generation
- **Rule 11** - Security Standards
- **Rule 12** - Error Handling (Backend + Frontend)

### Development Practices (13-21)
- **Rule 13** - Tool Usage
- **Rule 14** - Architecture (Truthseeker)
- **Rule 15** - Dependencies
- **Rule 16** - Code Review
- **Rule 17** - Testing
- **Rule 18** - Development Workflow
- **Rule 19** - Async Events
- **Rule 20** - Infrastructure & Deployment
- **Rule 21** - Project Documentation

## Quick Start

### For Teams
1. **Clone this repository** to your project
2. **Run the installation script** for your platform
3. **Initialize your team** following Rule 2
4. **Complete pre-work checklist** per Rule 3
5. **Start development** with confidence

### For Individuals
1. **Read Rule 0** - Quality First Principles
2. **Review relevant rules** for your work type
3. **Follow team workflow** if working with others
4. **Apply security standards** from Rule 15

## Installation

### Automated Installation

#### Unix/Linux/macOS
```bash
curl -sSL https://raw.githubusercontent.com/your-org/ai-dev-global-rules/main/scripts/install.sh | bash
```

#### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/your-org/ai-dev-global-rules/main/scripts/install.ps1 | iex
```

### What Installation Collects

During installation, you'll be asked for:

- **Full Name** - For team traceability and accountability
- **Email Address** - Professional contact information  
- **Team/Department** - Organizational affiliation (optional)
- **User ID Prefix** - Unique identifier for team files (auto-generated)

### Manual Installation
1. **Clone repository** to your project root
2. **Run installation script** for your platform
3. **Complete user registration** when prompted
4. **Verify installation** with `/team-status` command

## Key Features

### 🎯 Quality First
- **Architectural excellence** over quick fixes
- **Technical debt avoidance** principles
- **Clean code standards** and practices

### 👥 Team Collaboration
- **Team-based workflow** with traceable conversations
- **Single source of truth** for project coordination
- **Structured handoffs** and continuity

### 🔒 Security Focused
- **Enterprise-grade security** standards
- **Parameterized queries** mandatory
- **Input validation** and sanitization
- **Error handling** that doesn't leak information

### 🔄 Regression Protection
- **Baseline testing** for critical behavior
- **Golden files** and reference outputs
- **Automated regression detection**
- **Behavioral verification** standards

### 📝 Comprehensive Documentation
- **Communication guidelines** for clarity
- **Documentation standards** for maintainability
- **Code review requirements** for quality
- **TODO tracking** for completeness

## Workflow Integration

### Development Lifecycle
1. **Team Setup** - Claim team ID, create team file
2. **Pre-Work** - Complete checklist, review context
3. **Development** - Follow rules, maintain standards
4. **Testing** - Baseline verification, regression checks
5. **Handoff** - Complete documentation, update team file

### Continuous Improvement
- **Regular rule updates** from this repository
- **Team feedback incorporation**
- **Security updates** and patches
- **New standards** as best practices evolve

## Repository Structure

```
ai-dev-global-rules/
├── README.md                    # This file
├── SETUP-GUIDE.md               # Detailed installation instructions
├── CHANGELOG.md                 # Version history and updates
├── VERSION                      # Current version number
├── .windsurfrules               # Project rules template
├── rules/                       # Core rule modules
│   ├── 00-foundations.md        # Quality-first principles
│   ├── 01-single-source-truth.md # SSOT guidelines
│   ├── 02-team-workflow.md      # Team ID and tracking
│   ├── 03-before-starting-work.md # Pre-work checklist
│   ├── 04-regression-protection.md # Baseline testing
│   ├── 15-security.md           # Security standards
│   ├── 13-communication.md      # Communication guidelines
│   └── ...                      # All 25 rules
├── workflows/                   # Command aliases
├── scripts/                     # Installation and automation
├── templates/                   # Project templates
└── examples/                    # Usage examples
```

## Contributing

### Rule Updates
1. **Fork the repository**
2. **Create feature branch** with descriptive name
3. **Update relevant rules** with clear rationale
4. **Add examples** and documentation
5. **Submit pull request** with detailed description

### Feedback
- **Issues** for rule problems or gaps
- **Discussions** for improvement suggestions
- **Pull requests** for direct contributions

## Version Management

This project follows **semantic versioning** (MAJOR.MINOR.PATCH):

- **MAJOR** - Breaking changes to rule structure
- **MINOR** - New rules or significant enhancements
- **PATCH** - Bug fixes and clarifications

### Update Process
```bash
# Check for updates
./scripts/update.sh

# Review changes
git log --oneline -n 10

# Apply updates
./scripts/install.sh
```

## Support

### Documentation
- **Rule-specific guidance** in each rule file
- **Setup instructions** in SETUP-GUIDE.md
- **Examples** in examples/ directory
- **FAQ** in documentation

### Community
- **GitHub Discussions** for questions
- **Issues** for problems and suggestions
- **Wiki** for additional resources

## License

This framework is released under the **MIT License** - see LICENSE file for details.

## Acknowledgments

- **Universal AI Team Rulebook** - Foundation principles and workflow
- **detritus project** - Distribution and automation patterns
- **Enterprise development teams** - Security and standards contributions

---

## Remember

**Good code is the result of good process. Follow the rules, build excellent software.**

For detailed guidance, see the specific rule files in the `rules/` directory.


# AI Development Global Rules Installation Script (PowerShell)
# This script installs the global rules and registers user identity

param(
    [switch]$Force,
    [string]$FullName,
    [string]$Email,
    [string]$TeamDept,
    [string]$UserIdPrefix
)

# Configuration
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir
$VersionFile = Join-Path $ProjectRoot "VERSION"
$UsersDir = Join-Path $ProjectRoot ".users"
$TeamsDir = Join-Path $ProjectRoot ".teams"

# Helper functions
function Write-Header {
    param([string]$Title)
    Write-Host "========================================" -ForegroundColor Blue
    Write-Host $Title -ForegroundColor Blue
    Write-Host "========================================" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor Red
}

function Get-Version {
    if (Test-Path $VersionFile) {
        return Get-Content $VersionFile
    } else {
        return "1.0.0"
    }
}

# Create directories
function Create-Directories {
    Write-Header "Creating Directory Structure"
    
    New-Item -ItemType Directory -Path $UsersDir -Force | Out-Null
    New-Item -ItemType Directory -Path $TeamsDir -Force | Out-Null
    $WorkflowsDir = Join-Path $ProjectRoot ".windsurf" "workflows"
    New-Item -ItemType Directory -Path $WorkflowsDir -Force | Out-Null
    
    Write-Success "Directory structure created"
}

# User registration
function Register-User {
    Write-Header "User Identity Registration"
    
    Write-Host "Please provide your identity information for team traceability:"
    Write-Host
    
    # Get user information
    while ([string]::IsNullOrEmpty($FullName)) {
        $FullName = Read-Host "Full Name"
        if ([string]::IsNullOrEmpty($FullName) -or $FullName.Length -lt 2) {
            Write-Error "Please enter a valid full name (at least 2 characters)"
            $FullName = $null
        }
    }
    
    while ([string]::IsNullOrEmpty($Email)) {
        $Email = Read-Host "Email Address"
        if ($Email -notmatch '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$') {
            Write-Error "Please enter a valid email address"
            $Email = $null
        }
    }
    
    if ([string]::IsNullOrEmpty($TeamDept)) {
        $TeamDept = Read-Host "Team/Department (optional)"
    }
    
    # Generate user ID prefix if not provided
    if ([string]::IsNullOrEmpty($UserIdPrefix)) {
        $UserIdPrefix = $FullName.ToLower() -replace '[^a-z0-9]', '' -replace '.{8,}.*', '$&'
        if ($UserIdPrefix.Length -gt 8) {
            $UserIdPrefix = $UserIdPrefix.Substring(0, 8)
        }
    }
    
    # Check if user ID already exists
    $UserFile = Join-Path $UsersDir "USER_$UserIdPrefix.md"
    while ((Test-Path $UserFile) -and -not $Force) {
        Write-Warning "User ID '$UserIdPrefix' already exists"
        $UserIdPrefix = Read-Host "Enter a unique user ID prefix (e.g., jsmith)"
        if ([string]::IsNullOrEmpty($UserIdPrefix)) {
            $UserIdPrefix = $FullName.ToLower() -replace '[^a-z0-9]', '' -replace '.{8,}.*', '$&'
            if ($UserIdPrefix.Length -gt 8) {
                $UserIdPrefix = $UserIdPrefix.Substring(0, 8)
            }
        }
        $UserFile = Join-Path $UsersDir "USER_$UserIdPrefix.md"
    }
    
    # Create user file
    $UserContent = @"
# USER_$UserIdPrefix

## User Identity
- **Full Name**: $FullName
- **Email**: $Email
- **Team/Department**: $(if ($TeamDept) { $TeamDept } else { "Not specified" })
- **User ID Prefix**: $UserIdPrefix
- **Registration Date**: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
- **Installation Version**: $(Get-Version)

## Team History
"@
    
    Set-Content -Path $UserFile -Value $UserContent
    
    Write-Success "User identity registered: $FullName ($UserIdPrefix)"
    
    # Return user info as object
    return @{
        FullName = $FullName
        Email = $Email
        TeamDept = $TeamDept
        UserIdPrefix = $UserIdPrefix
        UserFile = $UserFile
    }
}

# Update user registry
function Update-UserRegistry {
    param($UserInfo)
    
    $RegistryFile = Join-Path $UsersDir "user-registry.json"
    
    if (-not (Test-Path $RegistryFile)) {
        Set-Content -Path $RegistryFile -Value '{"users": []}'
    }
    
    # Add user to registry
    $Registry = Get-Content $RegistryFile | ConvertFrom-Json
    $UserEntry = @{
        user_id_prefix = $UserInfo.UserIdPrefix
        full_name = $UserInfo.FullName
        email = $UserInfo.Email
        team_dept = $UserInfo.TeamDept
        registration_date = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
        version = (Get-Version)
    }
    
    $Registry.users += $UserEntry
    $Registry | ConvertTo-Json -Depth 10 | Set-Content $RegistryFile
    
    Write-Success "User registry updated"
}

# Copy project files
function Copy-ProjectFiles {
    Write-Header "Installing Project Files"
    
    # Copy .windsurfrules if it doesn't exist
    $WindsurfRules = Join-Path $ProjectRoot ".windsurfrules"
    if (-not (Test-Path $WindsurfRules)) {
        $TemplateFile = Join-Path $ProjectRoot "templates" ".windsurfrules"
        if (Test-Path $TemplateFile) {
            Copy-Item $TemplateFile $WindsurfRules
        } else {
            # Create basic .windsurfrules if template doesn't exist
            $WindsurfRulesContent = @"
# Project Rules

## First-Time Setup
This project uses the AI Development Global Rules framework.

## User Identity
Current user: USER_$($UserInfo.UserIdPrefix)
Run `/team-status` to see current team information.

## Core Rules
- Rule 0: Quality Over Speed
- Rule 1: Single Source of Truth
- Rule 2: Team Registration & Identity
- Rule 3: Before Starting Work
- Rule 4: Behavioral Regression Protection
- Rule 15: Security Standards

## Workflows
| Command | Description |
|---------|-------------|
| `/team-init` | Initialize new team |
| `/handoff` | Complete team handoff |
| `/baseline` | Setup regression tests |
| `/team-status` | Show current team info |
"@
            Set-Content -Path $WindsurfRules -Value $WindsurfRulesContent
        }
        Write-Success ".windsurfrules installed"
    } else {
        Write-Warning ".windsurfrules already exists, skipping"
    }
    
    # Install workflow files
    Install-Workflows
    
    Write-Success "Project files installed"
}

# Install workflow files
function Install-Workflows {
    $WorkflowsDir = Join-Path $ProjectRoot ".windsurf" "workflows"
    
    # Team initialization workflow
    $TeamInitContent = @"
---
description: Initialize new team for current conversation
---

1. Check existing teams in `.teams/` directory
2. Find highest team number and assign new one
3. Create team file with user identity
4. Update user's team history
5. Return team ID and file location

Follow Rule 2 guidelines for team registration.
"@
    Set-Content -Path (Join-Path $WorkflowsDir "team-init.md") -Value $TeamInitContent
    
    # Team status workflow
    $TeamStatusContent = @"
---
description: Show current team and user information
---

Display:
1. Current user identity from `.users/USER_<user-id-prefix>.md`
2. Current team information if active
3. Team history for current user
4. Available team numbers for next team

Use information from user registration and team files.
"@
    Set-Content -Path (Join-Path $WorkflowsDir "team-status.md") -Value $TeamStatusContent
    
    # Handoff workflow
    $HandoffContent = @"
---
description: Complete team handoff with proper documentation
---

Follow Rule 10 - Before Finishing checklist:
1. Update team file with final progress
2. Ensure project builds cleanly
3. Ensure all tests pass
4. Document remaining problems and next steps
5. Write comprehensive handoff notes

Complete all handoff checklist items before marking team as complete.
"@
    Set-Content -Path (Join-Path $WorkflowsDir "handoff.md") -Value $HandoffContent
    
    Write-Success "Workflows installed"
}

# Create first team
function Create-FirstTeam {
    param($UserInfo)
    
    Write-Header "Creating Your First Team"
    
    $TeamSummary = Read-Host "Enter a brief description for your first team"
    if ([string]::IsNullOrEmpty($TeamSummary)) {
        $TeamSummary = "initial-setup"
    }
    
    # Find next team number
    $NextTeam = 1
    if (Test-Path $TeamsDir) {
        $ExistingTeams = Get-ChildItem -Path $TeamsDir -Filter "TEAM_*.md" | 
            ForEach-Object { $_.Name -replace 'TEAM_(\d+).*', '$1' } | 
            Where-Object { $_ -match '^\d+$' } |
            Sort-Object { [int]$_ }
        
        if ($ExistingTeams.Count -gt 0) {
            $LastTeam = [int]$ExistingTeams[-1]
            $NextTeam = $LastTeam + 1
        }
    }
    
    $TeamId = "TEAM_{0:D3}" -f $NextTeam
    $TeamFileName = "{0}_{1}_{2}.md" -f $TeamId, $UserInfo.UserIdPrefix, $TeamSummary
    $TeamFile = Join-Path $TeamsDir $TeamFileName
    
    # Create team file
    $TeamContent = @"
# $TeamFileName

## Team Information
- **Team ID**: $TeamId
- **User ID**: $($UserInfo.UserIdPrefix)
- **User Full Name**: $($UserInfo.FullName)
- **User Email**: $($UserInfo.Email)
- **Started**: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
- **Context**: $TeamSummary
- **Members**: AI assistant, $($UserInfo.FullName) ($($UserInfo.UserIdPrefix))

## Progress Log
### $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Session Start
- **Objective**: Initial setup of AI Development Global Rules
- **Initial Assessment**: New installation, user registration complete
- **User Context**: $($UserInfo.FullName) from $(if ($UserInfo.TeamDept) { $UserInfo.TeamDept } else { "Not specified" })

### $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Installation Complete
- **Completed**: User registration, directory setup, project files installed
- **Next Steps**: Begin development following global rules framework
- **Blockers**: None identified

## Decisions Made
- **$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')**: User identity registered as $($UserInfo.UserIdPrefix)
- **$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')**: First team $TeamId created for $TeamSummary

## Questions Raised
- None at this time

## Handoff Notes
- **Current State**: Installation complete, ready for development
- **Next Actions**: Follow Rule 3 pre-work checklist before starting
- **Important Context**: User is $($UserInfo.FullName), contact at $($UserInfo.Email)
"@
    
    Set-Content -Path $TeamFile -Value $TeamContent
    
    # Update user's team history
    "- **$TeamId** - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $TeamSummary" | Add-Content -Path $UserInfo.UserFile
    
    Write-Success "First team created: $TeamId"
    Write-Success "Team file: $TeamFile"
    
    return $TeamId
}

# Final setup
function Complete-Installation {
    param($UserInfo, $TeamId)
    
    Write-Header "Installation Complete"
    
    Write-Host ""
    Write-Success "🎉 AI Development Global Rules installed successfully!"
    Write-Host ""
    Write-Host "Installation Summary:"
    Write-Host "  • User Identity: $($UserInfo.FullName) ($($UserInfo.UserIdPrefix))"
    Write-Host "  • Email: $($UserInfo.Email)"
    Write-Host "  • Team: $(if ($UserInfo.TeamDept) { $UserInfo.TeamDept } else { "Not specified" })"
    Write-Host "  • Version: $(Get-Version)"
    Write-Host "  • First Team: $TeamId"
    Write-Host ""
    Write-Host "Next Steps:"
    Write-Host "  1. Review Rule 0 - Quality Over Speed"
    Write-Host "  2. Complete Rule 3 pre-work checklist"
    Write-Host "  3. Start development with team workflow"
    Write-Host ""
    Write-Host "Available Commands:"
    Write-Host "  • /team-status - Show current team information"
    Write-Host "  • /team-init - Create new team"
    Write-Host "  • /handoff - Complete team handoff"
    Write-Host ""
    Write-Success "Ready to build excellent software! 🚀"
}

# Main installation flow
function Main {
    Write-Header "AI Development Global Rules Installation"
    Write-Host "Version: $(Get-Version)"
    Write-Host ""
    
    # Check if already installed
    $RegistryFile = Join-Path $UsersDir "user-registry.json"
    if ((Test-Path $RegistryFile) -and -not $Force) {
        Write-Warning "Global rules already installed"
        $ReRegister = Read-Host "Do you want to re-register a new user? (y/N)"
        if ($ReRegister -notmatch '^[Yy]') {
            Write-Host "Installation cancelled. Use /team-status to see current setup."
            exit 0
        }
    }
    
    # Installation steps
    Create-Directories
    $UserInfo = Register-User
    Update-UserRegistry -UserInfo $UserInfo
    Copy-ProjectFiles
    $TeamId = Create-FirstTeam -UserInfo $UserInfo
    Complete-Installation -UserInfo $UserInfo -TeamId $TeamId
}

# Run installation
Main

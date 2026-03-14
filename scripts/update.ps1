# Global Rules Update Script for Windows
# Repository: https://github.com/wowpeterhkg/Global-Rules-Windsurf-Dev

param(
    [switch]$Force,
    [switch]$NoBackup
)

$ErrorActionPreference = "Stop"

# Script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RulesDir = Split-Path -Parent $ScriptDir

Write-Host "========================================" -ForegroundColor Blue
Write-Host "  Global Rules Update Script" -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue
Write-Host ""

# Check if we're in a git repository
if (-not (Test-Path "$RulesDir\.git")) {
    Write-Host "Error: Not a git repository." -ForegroundColor Red
    Write-Host "Please ensure you cloned the repository using git."
    exit 1
}

Set-Location $RulesDir

# Get current version
$CurrentVersion = "unknown"
if (Test-Path "VERSION") {
    $CurrentVersion = Get-Content "VERSION" -Raw
    $CurrentVersion = $CurrentVersion.Trim()
}
Write-Host "Current version: " -NoNewline -ForegroundColor Yellow
Write-Host $CurrentVersion

# Fetch latest changes
Write-Host ""
Write-Host "Checking for updates..." -ForegroundColor Blue

try {
    git fetch origin main 2>$null
} catch {
    try {
        git fetch origin master 2>$null
    } catch {
        Write-Host "Error: Could not fetch updates. Check your internet connection." -ForegroundColor Red
        exit 1
    }
}

# Check if there are updates
$Local = git rev-parse HEAD
try {
    $Remote = git rev-parse origin/main 2>$null
} catch {
    $Remote = git rev-parse origin/master 2>$null
}

if ($Local -eq $Remote) {
    Write-Host "✓ You are already on the latest version." -ForegroundColor Green
    Write-Host ""
    exit 0
}

# Show what's new
Write-Host ""
Write-Host "Updates available:" -ForegroundColor Yellow
try {
    git log HEAD..origin/main --oneline 2>$null
} catch {
    git log HEAD..origin/master --oneline 2>$null
}
Write-Host ""

# Confirm update (unless -Force is specified)
if (-not $Force) {
    $Confirm = Read-Host "Do you want to update? (y/n)"
    if ($Confirm -notmatch "^[Yy]") {
        Write-Host "Update cancelled." -ForegroundColor Yellow
        exit 0
    }
}

# Backup user data (unless -NoBackup is specified)
if (-not $NoBackup) {
    Write-Host ""
    Write-Host "Backing up user data..." -ForegroundColor Blue
    $BackupDir = "$RulesDir\.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null

    if (Test-Path "$RulesDir\.users") {
        Copy-Item -Recurse "$RulesDir\.users" "$BackupDir\"
        Write-Host "✓ User profiles backed up" -ForegroundColor Green
    }

    if (Test-Path "$RulesDir\.teams") {
        Copy-Item -Recurse "$RulesDir\.teams" "$BackupDir\"
        Write-Host "✓ Team files backed up" -ForegroundColor Green
    }
}

# Check for local changes
$LocalChanges = git status --porcelain
$Stashed = $false

if ($LocalChanges) {
    Write-Host ""
    Write-Host "Warning: You have local changes." -ForegroundColor Yellow
    Write-Host "Stashing local changes..."
    git stash push -m "Auto-stash before update $(Get-Date -Format 'yyyyMMdd_HHmmss')"
    $Stashed = $true
}

# Pull updates
Write-Host ""
Write-Host "Downloading updates..." -ForegroundColor Blue
try {
    git pull origin main 2>$null
} catch {
    git pull origin master 2>$null
}

# Get new version
$NewVersion = "unknown"
if (Test-Path "VERSION") {
    $NewVersion = Get-Content "VERSION" -Raw
    $NewVersion = $NewVersion.Trim()
}

# Restore stashed changes if any
if ($Stashed) {
    Write-Host ""
    Write-Host "Restoring local changes..." -ForegroundColor Blue
    try {
        git stash pop
    } catch {
        Write-Host "Warning: Could not restore some local changes. Check 'git stash list'." -ForegroundColor Yellow
    }
}

# Show changelog if available
if (Test-Path "CHANGELOG.md") {
    Write-Host ""
    Write-Host "Recent changes:" -ForegroundColor Blue
    Get-Content "CHANGELOG.md" -TotalCount 50
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Update Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Updated from " -NoNewline
Write-Host $CurrentVersion -NoNewline -ForegroundColor Yellow
Write-Host " to " -NoNewline
Write-Host $NewVersion -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Restart Windsurf to load the updated rules"
Write-Host "2. Review CHANGELOG.md for detailed changes"
Write-Host ""

if (-not $NoBackup) {
    Write-Host "Backup location: " -NoNewline
    Write-Host $BackupDir -ForegroundColor Blue
    Write-Host ""
}

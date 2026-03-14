# Windsurf Global Development Rules - Setup Guide

A step-by-step installation guide for setting up the AI Development Global Rules framework in Windsurf IDE on MacOS, Linux, and Windows.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Install](#quick-install)
- [Manual Installation](#manual-installation)
  - [MacOS Installation](#macos-installation)
  - [Linux Installation](#linux-installation)
  - [Windows Installation](#windows-installation)
- [Windsurf Configuration](#windsurf-configuration)
- [User Registration](#user-registration)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)
- [Updating](#updating)
- [Uninstallation](#uninstallation)

---

## Prerequisites

Before installing, ensure you have:

- **Windsurf IDE** installed and running
- **Git** installed on your system
- **Terminal access** (Terminal on MacOS/Linux, PowerShell on Windows)
- **Write permissions** to your Windsurf configuration directory

### Windsurf Configuration Locations

| Platform | Global Rules Location |
|----------|----------------------|
| **MacOS** | `~/.windsurf/global-rules/` or `~/Library/Application Support/Windsurf/global-rules/` |
| **Linux** | `~/.config/windsurf/global-rules/` or `~/.windsurf/global-rules/` |
| **Windows** | `%APPDATA%\Windsurf\global-rules\` or `%USERPROFILE%\.windsurf\global-rules\` |

---

## Quick Install

### MacOS / Linux (One-Line Install)

Open Terminal and run:

```bash
curl -sSL https://raw.githubusercontent.com/wowpeterhkg/Global-Rules-Windsurf-Dev/main/scripts/install.sh | bash
```

### Windows (One-Line Install)

Open PowerShell as Administrator and run:

```powershell
irm https://raw.githubusercontent.com/wowpeterhkg/Global-Rules-Windsurf-Dev/main/scripts/install.ps1 | iex
```


---

## Manual Installation

### MacOS Installation

#### Step 1: Open Terminal

Press `Cmd + Space`, type "Terminal", and press Enter.

#### Step 2: Navigate to Windsurf Directory

```bash
# Create the global-rules directory if it doesn't exist
mkdir -p ~/.windsurf/global-rules

# Navigate to the directory
cd ~/.windsurf/global-rules
```

#### Step 3: Clone the Repository

```bash
git clone https://github.com/wowpeterhkg/Global-Rules-Windsurf-Dev.git .
```

> **Note**: The `.` at the end clones directly into the current directory.

#### Step 4: Run the Installation Script

```bash
# Make the script executable
chmod +x scripts/install.sh

# Run the installation
./scripts/install.sh
```

#### Step 5: Follow the Prompts

The installer will ask for:
- Your **full name** (for team traceability)
- Your **email address** (professional contact)
- Your **team/department** (optional)

#### Step 6: Restart Windsurf

Close and reopen Windsurf to load the new global rules.

---

### Linux Installation

#### Step 1: Open Terminal

Use your preferred terminal emulator (Ctrl+Alt+T on most distributions).

#### Step 2: Navigate to Windsurf Directory

```bash
# Create the global-rules directory if it doesn't exist
mkdir -p ~/.config/windsurf/global-rules

# Navigate to the directory
cd ~/.config/windsurf/global-rules
```

> **Alternative location**: Some installations use `~/.windsurf/global-rules/`

#### Step 3: Clone the Repository

```bash
git clone https://github.com/wowpeterhkg/Global-Rules-Windsurf-Dev.git .
```

#### Step 4: Run the Installation Script

```bash
# Make the script executable
chmod +x scripts/install.sh

# Run the installation
./scripts/install.sh
```

#### Step 5: Follow the Prompts

Enter your user information when prompted.

#### Step 6: Restart Windsurf

Close and reopen Windsurf to load the new global rules.

---

### Windows Installation

#### Step 1: Open PowerShell as Administrator

Press `Win + X` and select "Windows PowerShell (Admin)" or "Terminal (Admin)".

#### Step 2: Navigate to Windsurf Directory

```powershell
# Create the global-rules directory if it doesn't exist
New-Item -ItemType Directory -Force -Path "$env:APPDATA\Windsurf\global-rules"

# Navigate to the directory
Set-Location "$env:APPDATA\Windsurf\global-rules"
```

> **Alternative location**: `$env:USERPROFILE\.windsurf\global-rules`

#### Step 3: Clone the Repository

```powershell
git clone https://github.com/wowpeterhkg/Global-Rules-Windsurf-Dev.git .
```

#### Step 4: Run the Installation Script

```powershell
# Allow script execution (if needed)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Run the installation
.\scripts\install.ps1
```

#### Step 5: Follow the Prompts

Enter your user information when prompted.

#### Step 6: Restart Windsurf

Close and reopen Windsurf to load the new global rules.

---

## Windsurf Configuration

### Setting Up Global Rules in Windsurf

After installation, configure Windsurf to use the global rules:

#### Option 1: Automatic (Recommended)

The installation script automatically creates a `.windsurfrules` file. Windsurf will detect and load it automatically.

#### Option 2: Manual Configuration

1. Open Windsurf
2. Go to **Settings** (Ctrl/Cmd + ,)
3. Search for "Global Rules" or "AI Rules"
4. Set the path to your global rules directory:
   - **MacOS**: `~/.windsurf/global-rules/`
   - **Linux**: `~/.config/windsurf/global-rules/`
   - **Windows**: `%APPDATA%\Windsurf\global-rules\`

### Verifying Rules Are Loaded

1. Open a new Windsurf chat/conversation
2. Ask: "What rules are you following?"
3. The AI should reference the 22 development rules (00-21)

---

## User Registration

During installation, you'll be asked to register your identity for team traceability.

### Information Collected

| Field | Required | Purpose |
|-------|----------|---------|
| **Full Name** | Yes | Team file attribution |
| **Email** | Yes | Contact and identification |
| **Team/Department** | No | Organizational grouping |
| **User ID Prefix** | Auto | Unique identifier (auto-generated) |

### User Profile Location

Your user profile is stored at:
- **MacOS/Linux**: `~/.windsurf/global-rules/.users/USER_<prefix>.md`
- **Windows**: `%APPDATA%\Windsurf\global-rules\.users\USER_<prefix>.md`

### Updating Your Profile

To update your user information:

```bash
# MacOS/Linux
./scripts/install.sh --update-user

# Windows (PowerShell)
.\scripts\install.ps1 -UpdateUser
```

---

## Verification

### Check Installation Status

#### MacOS/Linux

```bash
# Check if rules are installed
ls -la ~/.windsurf/global-rules/rules/

# Verify version
cat ~/.windsurf/global-rules/VERSION

# Check user registration
ls ~/.windsurf/global-rules/.users/
```

#### Windows (PowerShell)

```powershell
# Check if rules are installed
Get-ChildItem "$env:APPDATA\Windsurf\global-rules\rules\"

# Verify version
Get-Content "$env:APPDATA\Windsurf\global-rules\VERSION"

# Check user registration
Get-ChildItem "$env:APPDATA\Windsurf\global-rules\.users\"
```

### Expected Output

You should see 22 rule files (00-21) in the `rules/` directory:

```
00-quality-over-speed.md
01-single-source-truth.md
02-team-workflow.md
...
21-documentation.md
```

---

## Troubleshooting

### Common Issues

#### Issue: "Permission Denied" Error

**MacOS/Linux:**
```bash
# Fix permissions
chmod -R 755 ~/.windsurf/global-rules/
chmod +x ~/.windsurf/global-rules/scripts/*.sh
```

**Windows:**
```powershell
# Run PowerShell as Administrator
# Or adjust folder permissions in File Explorer
```

#### Issue: Git Clone Fails

```bash
# Check if git is installed
git --version

# If not installed:
# MacOS: brew install git
# Linux: sudo apt install git (Debian/Ubuntu) or sudo dnf install git (Fedora)
# Windows: Download from https://git-scm.com/download/win
```

#### Issue: Rules Not Loading in Windsurf

1. **Verify the path** - Ensure rules are in the correct directory
2. **Check file permissions** - Files must be readable
3. **Restart Windsurf** - Close completely and reopen
4. **Check Windsurf logs** - Look for loading errors

#### Issue: Script Execution Policy (Windows)

```powershell
# Check current policy
Get-ExecutionPolicy

# If "Restricted", run:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### Issue: Curl/irm Not Found

**MacOS:**
```bash
# curl is pre-installed on MacOS
# If missing, install via Homebrew:
brew install curl
```

**Linux:**
```bash
# Debian/Ubuntu
sudo apt install curl

# Fedora/RHEL
sudo dnf install curl
```

**Windows:**
```powershell
# irm (Invoke-RestMethod) is built into PowerShell 5.1+
# Verify PowerShell version:
$PSVersionTable.PSVersion
```

### Getting Help

If you encounter issues not covered here:

1. **Check the README** - `README.md` in the repository
2. **Review rule files** - Individual rules have detailed guidance
3. **Open an issue** - On the GitHub repository
4. **Contact support** - Via the repository's discussion board

---

## Updating

### Quick Update (Recommended)

Use the built-in update script for automatic updates with backup:

#### MacOS/Linux

```bash
cd ~/.windsurf/global-rules
./scripts/update.sh
```

#### Windows

```powershell
Set-Location "$env:APPDATA\Windsurf\global-rules"
.\scripts\update.ps1
```

### Update Script Features

The update script automatically:
- ✅ Checks for available updates
- ✅ Shows what's new before updating
- ✅ Backs up your user profiles and team files
- ✅ Stashes any local changes
- ✅ Pulls the latest version
- ✅ Restores your local changes
- ✅ Shows the changelog

### Update Script Options

#### Windows PowerShell Options

```powershell
# Force update without confirmation
.\scripts\update.ps1 -Force

# Skip backup (not recommended)
.\scripts\update.ps1 -NoBackup

# Combine options
.\scripts\update.ps1 -Force -NoBackup
```

### Manual Update (Alternative)

If you prefer manual control:

#### MacOS/Linux

```bash
cd ~/.windsurf/global-rules
git fetch origin
git log HEAD..origin/main --oneline  # See what's new
git pull origin main
```

#### Windows

```powershell
Set-Location "$env:APPDATA\Windsurf\global-rules"
git fetch origin
git log HEAD..origin/main --oneline  # See what's new
git pull origin main
```

### Version History

Check `CHANGELOG.md` for version history and release notes.

---

## Uninstallation

### Remove Global Rules

#### MacOS/Linux

```bash
# Backup user data first (optional)
cp -r ~/.windsurf/global-rules/.users ~/global-rules-backup/

# Remove the installation
rm -rf ~/.windsurf/global-rules
```

#### Windows

```powershell
# Backup user data first (optional)
Copy-Item -Recurse "$env:APPDATA\Windsurf\global-rules\.users" "$env:USERPROFILE\global-rules-backup\"

# Remove the installation
Remove-Item -Recurse -Force "$env:APPDATA\Windsurf\global-rules"
```

### Clean Windsurf Settings

1. Open Windsurf Settings
2. Search for "Global Rules"
3. Clear any custom paths
4. Restart Windsurf

---

## Quick Reference

### Directory Structure After Installation

```
global-rules/
├── README.md                 # Project overview
├── SETUP-GUIDE.md           # This file
├── VERSION                   # Current version
├── .windsurfrules           # Windsurf integration
├── rules/                    # 22 rule files
│   ├── 00-quality-over-speed.md
│   ├── 01-single-source-truth.md
│   └── ... (00-21)
├── scripts/
│   ├── install.sh           # MacOS/Linux installer
│   └── install.ps1          # Windows installer
├── .users/                   # User profiles
│   └── USER_<prefix>.md
├── .teams/                   # Team files
└── workflows/                # Workflow definitions
```

### Key Commands

| Action | MacOS/Linux | Windows |
|--------|-------------|---------|
| Install | `./scripts/install.sh` | `.\scripts\install.ps1` |
| Update | `git pull && ./scripts/install.sh --update` | `git pull; .\scripts\install.ps1 -Update` |
| Check version | `cat VERSION` | `Get-Content VERSION` |
| List rules | `ls rules/` | `Get-ChildItem rules\` |

---

## Support

- **Documentation**: See `rules/` directory for detailed guidance
- **Issues**: Open a GitHub issue for bugs or feature requests
- **Discussions**: Use GitHub Discussions for questions

---

**Happy coding with Windsurf Global Development Rules!** 🚀

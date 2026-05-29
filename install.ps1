<#
.SYNOPSIS
    Windows terminal environment installer and dotfiles symlink manager.
    Idempotent design: Safe to run multiple times.
#>

$DotfilesDir = $PSScriptRoot
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "[*] Initializing/Updating Windows Dotfiles Environment..." -ForegroundColor Cyan
Write-Host "[*] Current dotfiles repository path: $DotfilesDir" -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan

# ==========================================
# 1. Install Core Package Manager (Scoop)
# ==========================================
Write-Host "`n[1/3] Checking core package manager (Scoop)..." -ForegroundColor Yellow
if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "  -> Scoop not found. Installing..."
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
} else {
    Write-Host "  -> Scoop is already installed. Skipping." -ForegroundColor Green
}

Write-Host "`n[2/3] Checking development toolchain..." -ForegroundColor Yellow
scoop bucket add extras 2>$null
scoop bucket add nerd-fonts 2>$null

$Tools = @(
    "neovim", "yazi", "oh-my-posh", "gcc", 
    "fzf", "ripgrep", "7zip", "jq", "poppler", 
    "fd", "zoxide", "imagemagick", "main/uv", "rustup",
    "nodejs", "tssh"
)

foreach ($Tool in $Tools) {
    if (!(scoop list | Select-String -Pattern "^$Tool\s")) {
        Write-Host "  -> Installing: $Tool..."
        scoop install $Tool
    } else {
        Write-Host "  -> Already installed: $Tool" -ForegroundColor DarkGray
    }
}

# ==========================================
# 2. Symlink & Junction Management Logic
# ==========================================
Write-Host "`n[3/3] Managing configuration files (Move & Symlink)..." -ForegroundColor Yellow

function Setup-Symlink {
    param (
        [string]$RepoPath,
        [string]$SystemPath,
        [string]$ItemType
    )

    try {
        $RepoFullPath = Join-Path $DotfilesDir $RepoPath
        $SystemParent = Split-Path $SystemPath

        if (!(Test-Path $SystemParent)) { 
            New-Item -ItemType Directory -Path $SystemParent -Force | Out-Null 
        }

        # Scenario A: Already properly linked
        if (Test-Path $SystemPath) {
            $Item = Get-Item $SystemPath -Force
            if ($Item.LinkType) {
                Write-Host "  -> [+] Already linked: $RepoPath" -ForegroundColor Green
                return
            }
        }

        # Scenario B: Move existing system config to repo
        if (!(Test-Path $RepoFullPath) -and (Test-Path $SystemPath)) {
            Write-Host "  -> [>] Extracting: Moving $SystemPath to repo." -ForegroundColor Magenta
            $RepoParent = Split-Path $RepoFullPath
            if (!(Test-Path $RepoParent)) { New-Item -ItemType Directory -Path $RepoParent -Force | Out-Null }
            Move-Item -Path $SystemPath -Destination $RepoFullPath -Force
        }
        # Scenario C: Conflict detected (Both exist, system is not a link)
        elseif ((Test-Path $RepoFullPath) -and (Test-Path $SystemPath)) {
            $BackupPath = "$SystemPath.bak_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
            Write-Host "  -> [!] Conflict: Backing up original config to $BackupPath" -ForegroundColor Red
            Rename-Item -Path $SystemPath -NewName (Split-Path $BackupPath -Leaf)
        }
        # Scenario D: Neither exists, initialize an empty one
        elseif (!(Test-Path $RepoFullPath) -and !(Test-Path $SystemPath)) {
            Write-Host "  -> [*] Initializing: Creating empty $RepoPath" -ForegroundColor DarkGray
            if ($ItemType -eq 'Directory') {
                New-Item -ItemType Directory -Path $RepoFullPath -Force | Out-Null
            } else {
                New-Item -ItemType File -Path $RepoFullPath -Force | Out-Null
            }
        }

        # Create the link
        Write-Host "  -> [~] Creating link: $SystemPath -> $RepoFullPath" -ForegroundColor Cyan
        $LinkType = if ($ItemType -eq 'Directory') { 'Junction' } else { 'SymbolicLink' }
        New-Item -ItemType $LinkType -Path $SystemPath -Target $RepoFullPath -Force | Out-Null
    }
    catch {
        Write-Host "  -> [-] ERROR processing $RepoPath : $_" -ForegroundColor Red
    }
}

# ==========================================
# 3. Execute Bindings
# ==========================================

Setup-Symlink -RepoPath "nvim" -SystemPath "$env:LOCALAPPDATA\nvim" -ItemType "Directory"
Setup-Symlink -RepoPath "yazi" -SystemPath "$env:APPDATA\yazi\config" -ItemType "Directory"
Setup-Symlink -RepoPath ".wezterm.lua" -SystemPath "$env:USERPROFILE\.wezterm.lua" -ItemType "File"
Setup-Symlink -RepoPath "glazewm" -SystemPath "$env:USERPROFILE\.glzr\glazewm" -ItemType "Directory"
Setup-Symlink -RepoPath "zebar" -SystemPath "$env:USERPROFILE\.glzr\zebar" -ItemType "Directory"

# Dynamic Profile Resolution
Setup-Symlink -RepoPath "pwsh_profile.ps1" -SystemPath "C:\Users\16322\OneDrive\Onenote Documents\WindowsPowerShell\profile.ps1" -ItemType "File"

Write-Host "`n[+] All environment checks and symlink configurations are complete!" -ForegroundColor Green

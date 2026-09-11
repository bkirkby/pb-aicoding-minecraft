<#
.SYNOPSIS
    Session 1 setup script for The Sentience Quest curriculum.

.DESCRIPTION
    Part 0 - Opens the full setup guide in the default browser, so it's
    readable alongside the terminal while everything below runs.

    Part 1 - Detection: looks for the Minecraft Launcher and the .minecraft
    game data folder, lists installed versions, and flags which ones are
    new enough for Fabric mod development (Java 21 for 1.20.5-1.21.x, or
    Java 25 for the current 26.x year-based line).

    Part 2 - Setup: installs Git, IntelliJ IDEA Community Edition, Java 25,
    the Modrinth App, and the opencode AI coding agent via winget. Skips
    anything already present.

    Part 2.5 - Configuration: sets a git commit identity if one isn't
    already configured, checks that IntelliJ meets the 2025.3+ version
    Fabric requires for 26.x modding, and installs the Minecraft
    Development plugin (Fabric's recommended IDE, per their own docs -
    they explicitly advise against VS Code for this).

    Part 3 - Workspace: creates the devel\sentient-pets project folder and
    a "Pheirce Bytes" folder on the Desktop with PowerShell and IntelliJ
    shortcuts that both open straight into it.

.NOTES
    Run in a normal PowerShell window (Windows PowerShell 5.1 or PowerShell 7
    both work). Some installers may still trigger a UAC prompt - that's
    expected, approve it.

    If Windows blocks the script from running, launch it with:
        powershell -ExecutionPolicy Bypass -File .\minecraft-dev-setup.ps1
#>

function Write-Section($title) {
    Write-Host ""
    Write-Host "== $title ==" -ForegroundColor Cyan
}

# ----------------------------------------------------------------------
# PART 0: Open the full setup guide
# ----------------------------------------------------------------------

$guideUrl = "https://github.com/bkirkby/pb-aicoding-minecraft/blob/main/guides/windows-setup-guide.md"

Write-Section "Opening the setup guide"
Write-Host "  Opening the full guide in your browser - keep this window open too," -ForegroundColor Cyan
Write-Host "  it runs the automated setup while you read along." -ForegroundColor Cyan

try {
    Start-Process $guideUrl -ErrorAction Stop
} catch {
    Write-Host "  Couldn't open a browser automatically. Read the guide here:" -ForegroundColor Yellow
    Write-Host "  $guideUrl" -ForegroundColor Yellow
}

# ----------------------------------------------------------------------
# PART 1: Find Minecraft and report what's installed
# ----------------------------------------------------------------------

Write-Section "Checking for Minecraft Java Edition"

$launcherPaths = @(
    "$env:LOCALAPPDATA\Programs\Minecraft Launcher\MinecraftLauncher.exe",
    "${env:ProgramFiles(x86)}\Minecraft Launcher\MinecraftLauncher.exe",
    "$env:ProgramFiles\Minecraft Launcher\MinecraftLauncher.exe"
)
$launcherFound = $launcherPaths | Where-Object { Test-Path $_ -ErrorAction SilentlyContinue } | Select-Object -First 1

if ($launcherFound) {
    Write-Host "  Launcher found: $launcherFound" -ForegroundColor Green
} else {
    Write-Host "  Minecraft Launcher executable not found in the usual locations." -ForegroundColor Yellow
}

$mcDataDir = "$env:APPDATA\.minecraft"
$versionsDir = Join-Path $mcDataDir "versions"
$versions = @()

if (-not (Test-Path $mcDataDir -ErrorAction SilentlyContinue)) {
    Write-Host "  No .minecraft folder found at $mcDataDir" -ForegroundColor Yellow
    Write-Host "  This usually means Java Edition has never been launched on this account." -ForegroundColor Yellow
} else {
    Write-Host "  Game data folder found: $mcDataDir" -ForegroundColor Green
    if (Test-Path $versionsDir -ErrorAction SilentlyContinue) {
        $versions = Get-ChildItem $versionsDir -Directory -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name
    }
}

# Classify each installed version by the Java version Fabric needs for it
function Get-JavaRequirement($versionId) {
    # Already-modded profiles - not a vanilla version, skip Java classification
    if ($versionId -match '(?i)fabric|forge|quilt|optifine') {
        return @{ Label = "modded profile"; Java = "n/a"; Modern = $null }
    }
    # New year-based scheme (26.1, 26.2, 27.1, ...) - introduced in 2026, needs Java 25
    if ($versionId -match '^\d{1,2}\.\d+(\.\d+)?$' -and [int]($versionId.Split('.')[0]) -ge 26) {
        return @{ Label = "current (year-based)"; Java = "25"; Modern = $true }
    }
    # Classic 1.x scheme
    if ($versionId -match '^1\.(\d+)(\.(\d+))?$') {
        $minor = [int]$Matches[1]
        $patch = if ($Matches[3]) { [int]$Matches[3] } else { 0 }
        if ($minor -gt 20 -or ($minor -eq 20 -and $patch -ge 5)) {
            return @{ Label = "1.20.5+"; Java = "21"; Modern = $true }
        } elseif ($minor -ge 17) {
            return @{ Label = "1.17-1.20.4"; Java = "17"; Modern = $false }
        } else {
            return @{ Label = "pre-1.17"; Java = "8/16"; Modern = $false }
        }
    }
    return @{ Label = "unrecognized/snapshot"; Java = "unknown"; Modern = $null }
}

$hasModernVersion = $false

if ($versions.Count -eq 0) {
    Write-Host "  No installed versions found under versions\." -ForegroundColor Yellow
} else {
    Write-Host "  Installed versions:" -ForegroundColor Green
    foreach ($v in $versions) {
        $info = Get-JavaRequirement $v
        $color = if ($info.Modern -eq $true) { "Green" } elseif ($info.Modern -eq $false) { "Yellow" } else { "Gray" }
        Write-Host ("    - {0,-30} [{1}, needs Java {2}]" -f $v, $info.Label, $info.Java) -ForegroundColor $color
        if ($info.Modern -eq $true) { $hasModernVersion = $true }
    }
}

Write-Host ""
if ($hasModernVersion) {
    Write-Host "  RESULT: A Fabric-compatible version is installed. Good to go." -ForegroundColor Green
} elseif ($versions.Count -gt 0) {
    Write-Host "  RESULT: Versions found, but none new enough for Fabric mod dev." -ForegroundColor Yellow
    Write-Host "  Open the Minecraft Launcher and install 26.2 before session 2." -ForegroundColor Yellow
} else {
    Write-Host "  RESULT: Minecraft Java Edition doesn't appear to be set up on this machine yet." -ForegroundColor Red
}

Write-Host ""
$continue = Read-Host "Press Enter to continue with tool setup (or type 'n' to stop)"
if ($continue -eq 'n') {
    Write-Host "Stopped before installing tools." -ForegroundColor Yellow
    exit
}

# ----------------------------------------------------------------------
# PART 2: Install dev tools via winget
# ----------------------------------------------------------------------

Write-Section "Installing dev tools"

$tools = @(
    @{ Id = "Git.Git";                      Name = "Git" },
    @{ Id = "JetBrains.IntelliJIDEA.Community"; Name = "IntelliJ IDEA Community" },
    @{ Id = "Microsoft.OpenJDK.25";         Name = "Java 25 (Microsoft OpenJDK)" },
    @{ Id = "Modrinth.ModrinthApp";         Name = "Modrinth App" },
    @{ Id = "SST.opencode";                 Name = "opencode (AI coding agent)" }
)

$results = @()

foreach ($tool in $tools) {
    Write-Host ""
    Write-Host "-- $($tool.Name) --" -ForegroundColor Cyan

    $already = winget list --id $tool.Id -e --source winget 2>$null | Select-String ([regex]::Escape($tool.Id))
    if ($already) {
        Write-Host "  Already installed - checking for updates..." -ForegroundColor Yellow
        winget upgrade -e --id $tool.Id --source winget --accept-package-agreements --accept-source-agreements
        $checkExit = $LASTEXITCODE

        if ($checkExit -ne 0) {
            # winget upgrade often reports "nothing to do" even when a real
            # update exists, because of a stale/broken manifest upstream -
            # this is exactly what happened with Modrinth App. Microsoft's
            # own documented workaround is to force a fresh install instead
            # of trusting the upgrade check's negative result.
            Write-Host "  Upgrade check found nothing - forcing a fresh install to be sure..." -ForegroundColor Yellow
            winget install -e --id $tool.Id --source winget --force --accept-package-agreements --accept-source-agreements
            $checkExit = $LASTEXITCODE
        }

        if ($checkExit -eq 0) {
            Write-Host "  Up to date." -ForegroundColor Green
            $results += @{ Name = $tool.Name; Status = "already installed (up to date)" }
        } else {
            Write-Host "  Could not confirm the latest version (exit code $checkExit) - check manually." -ForegroundColor Yellow
            $results += @{ Name = $tool.Name; Status = "already installed (version uncertain)" }
        }
        continue
    }

    winget install -e --id $tool.Id --source winget --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  Installed successfully." -ForegroundColor Green
        $results += @{ Name = $tool.Name; Status = "installed" }
    } else {
        Write-Host "  Install reported an error (exit code $LASTEXITCODE)." -ForegroundColor Red
        $results += @{ Name = $tool.Name; Status = "FAILED - check manually" }
    }
}

# ----------------------------------------------------------------------
# PART 2.5: Post-install configuration
# ----------------------------------------------------------------------

Write-Section "Configuring git and IntelliJ"

# Resolve exe paths directly rather than relying on PATH, since a tool
# installed a few seconds ago by winget won't be on PATH in this window yet.

function Find-GitExe {
    $candidates = @(
        "$env:ProgramFiles\Git\cmd\git.exe",
        "${env:ProgramFiles(x86)}\Git\cmd\git.exe",
        "$env:LOCALAPPDATA\Programs\Git\cmd\git.exe"
    )
    foreach ($path in $candidates) {
        if (Test-Path $path -ErrorAction SilentlyContinue) { return $path }
    }
    $onPath = Get-Command git -ErrorAction SilentlyContinue
    if ($onPath) { return $onPath.Source }
    return $null
}

function Find-IntelliJInstall {
    # Installs under a versioned folder name, e.g.
    # "C:\Program Files\JetBrains\IntelliJ IDEA Community Edition 2026.2.2"
    # so the exact path has to be discovered rather than hard-coded.
    $base = "$env:ProgramFiles\JetBrains"
    if (-not (Test-Path $base -ErrorAction SilentlyContinue)) { return $null }

    $dir = Get-ChildItem $base -Directory -Filter "IntelliJ IDEA Community Edition*" -ErrorAction SilentlyContinue |
           Sort-Object Name -Descending | Select-Object -First 1
    if (-not $dir) { return $null }

    $exe = Join-Path $dir.FullName "bin\idea64.exe"
    if (-not (Test-Path $exe -ErrorAction SilentlyContinue)) { return $null }

    $version = $null
    if ($dir.Name -match '(\d{4})\.(\d+)') {
        $version = @{ Year = [int]$Matches[1]; Minor = [int]$Matches[2] }
    }

    return @{ Exe = $exe; Dir = $dir.FullName; Version = $version }
}

$gitExe = Find-GitExe
$ij = Find-IntelliJInstall

# --- Git identity - a commit will fail without this ---
if ($gitExe) {
    $gitName = & $gitExe config --global user.name 2>$null
    $gitEmail = & $gitExe config --global user.email 2>$null

    if (-not $gitName -or -not $gitEmail) {
        Write-Host "  Git needs a name and email before it can make commits." -ForegroundColor Yellow
        if (-not $gitName) {
            $gitName = Read-Host "  Enter a name for git commits (a first name is fine)"
            & $gitExe config --global user.name "$gitName" | Out-Null
        }
        if (-not $gitEmail) {
            $gitEmail = Read-Host "  Enter an email for git commits (doesn't need to be checked/verified)"
            & $gitExe config --global user.email "$gitEmail" | Out-Null
        }
        Write-Host "  Git identity set: $gitName <$gitEmail>" -ForegroundColor Green
    } else {
        Write-Host "  Git identity already set: $gitName <$gitEmail>" -ForegroundColor Green
    }
} else {
    Write-Host "  Could not find git.exe - skipping identity setup." -ForegroundColor Yellow
    Write-Host "  Re-run this script once Git is confirmed installed." -ForegroundColor Yellow
}

# --- IntelliJ version check + Minecraft Development plugin ---
# Fabric's own docs: "IntelliJ IDEA 2025.3 or higher is required to mod 26.1."
# winget has a known lag recognizing JetBrains updates, so this is checked
# directly against the installed folder rather than trusted blindly.
if ($ij) {
    Write-Host "  IntelliJ found: $($ij.Dir)" -ForegroundColor Green

    if ($ij.Version) {
        $verOk = ($ij.Version.Year -gt 2025) -or ($ij.Version.Year -eq 2025 -and $ij.Version.Minor -ge 3)
        if ($verOk) {
            Write-Host "  Version $($ij.Version.Year).$($ij.Version.Minor) meets the 2025.3+ Fabric needs for 26.2." -ForegroundColor Green
        } else {
            Write-Host "  Version $($ij.Version.Year).$($ij.Version.Minor) is older than the 2025.3 Fabric needs - mixins may not work correctly." -ForegroundColor Yellow
            Write-Host "  Open IntelliJ and check Help > Check for Updates before session 2." -ForegroundColor Yellow
        }
    }

    Write-Host "  Installing Minecraft Development plugin..." -ForegroundColor Cyan
    & $ij.Exe installPlugins com.demonwav.minecraft-dev | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "    Done." -ForegroundColor Green
    } else {
        Write-Host "    Reported an error - install manually from Settings > Plugins > Marketplace if needed." -ForegroundColor Yellow
    }
} else {
    Write-Host "  Could not find IntelliJ IDEA - skipping version check and plugin install." -ForegroundColor Yellow
    Write-Host "  Re-run this script once IntelliJ is confirmed installed." -ForegroundColor Yellow
}

# ----------------------------------------------------------------------
# PART 3: Project folder and desktop shortcuts
# ----------------------------------------------------------------------

Write-Section "Setting up project folder and shortcuts"

$projectDir = Join-Path $env:USERPROFILE "devel\sentient-pets"
if (-not (Test-Path $projectDir -ErrorAction SilentlyContinue)) {
    New-Item -ItemType Directory -Path $projectDir -Force | Out-Null
    Write-Host "  Created project folder: $projectDir" -ForegroundColor Green
} else {
    Write-Host "  Project folder already exists: $projectDir" -ForegroundColor Green
}

$desktopDir = [Environment]::GetFolderPath("Desktop")
$shortcutFolder = Join-Path $desktopDir "Pheirce Bytes"
if (-not (Test-Path $shortcutFolder -ErrorAction SilentlyContinue)) {
    New-Item -ItemType Directory -Path $shortcutFolder -Force | Out-Null
    Write-Host "  Created shortcut folder: $shortcutFolder" -ForegroundColor Green
} else {
    Write-Host "  Shortcut folder already exists: $shortcutFolder" -ForegroundColor Green
}

$WshShell = New-Object -ComObject WScript.Shell
$posh = "$env:WINDIR\System32\WindowsPowerShell\v1.0\powershell.exe"

# PowerShell shortcut - opens directly into the project folder
$psShortcutPath = Join-Path $shortcutFolder "PowerShell.lnk"
$psShortcut = $WshShell.CreateShortcut($psShortcutPath)
$psShortcut.TargetPath = $posh
$psShortcut.WorkingDirectory = $projectDir
$psShortcut.IconLocation = "$posh,0"
$psShortcut.Description = "PowerShell in sentient-pets"
$psShortcut.Save()
Write-Host "  Created shortcut: $psShortcutPath" -ForegroundColor Green

# IntelliJ shortcut - opens the project folder directly
if ($ij) {
    $ijShortcutPath = Join-Path $shortcutFolder "IntelliJ IDEA.lnk"
    $ijShortcut = $WshShell.CreateShortcut($ijShortcutPath)
    $ijShortcut.TargetPath = $ij.Exe
    $ijShortcut.Arguments = "`"$projectDir`""
    $ijShortcut.WorkingDirectory = $projectDir
    $ijShortcut.IconLocation = "$($ij.Exe),0"
    $ijShortcut.Description = "IntelliJ IDEA in sentient-pets"
    $ijShortcut.Save()
    Write-Host "  Created shortcut: $ijShortcutPath" -ForegroundColor Green
} else {
    Write-Host "  Could not find IntelliJ IDEA - skipping shortcut." -ForegroundColor Yellow
    Write-Host "  Re-run this script after confirming IntelliJ installed to generate it." -ForegroundColor Yellow
}

# ----------------------------------------------------------------------
# Summary
# ----------------------------------------------------------------------

Write-Section "Summary"
foreach ($r in $results) {
    $color = if ($r.Status -like "FAILED*") { "Red" } else { "Green" }
    Write-Host ("  {0,-35} {1}" -f $r.Name, $r.Status) -ForegroundColor $color
}

Write-Host ""
Write-Host "Close and reopen this terminal window before running 'java -version' or 'git --version' -" -ForegroundColor Yellow
Write-Host "PATH changes from the installs above won't be picked up in this window." -ForegroundColor Yellow
Write-Host ""
Write-Host "From now on, use the shortcuts in the 'Pheirce Bytes' folder on the Desktop -" -ForegroundColor Cyan
Write-Host "both open straight into $projectDir" -ForegroundColor Cyan

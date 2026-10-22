# Sentinel Skills Installer for Claude Code and Codex (Windows PowerShell)
# Links (or copies) every skill into the personal Claude Code skills directory
# so the /sentinel-* commands are available in every project.

param(
    [ValidateSet('Claude', 'Codex')]
    [string]$Target = 'Claude',
    [string]$SkillsDir
)

$ErrorActionPreference = 'Stop'
if (-not $SkillsDir) {
    $relativeDir = if ($Target -eq 'Codex') { '.agents\skills' } else { '.claude\skills' }
    $SkillsDir = Join-Path $env:USERPROFILE $relativeDir
}
$SkillsDir = [IO.Path]::GetFullPath($SkillsDir)
$SourceSkillsDir = Join-Path $PSScriptRoot "skills"

Write-Host "Installing Sentinel skills for $Target into $SkillsDir..." -ForegroundColor Cyan

if (-not (Test-Path $SourceSkillsDir)) {
    Write-Host "[ERROR] Source skills directory not found: $SourceSkillsDir" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path -LiteralPath $SkillsDir)) {
    New-Item -ItemType Directory -Path $SkillsDir -Force | Out-Null
}

$installed = 0
$failed = @()
$mode = ""

foreach ($skill in Get-ChildItem -Path $SourceSkillsDir -Directory) {
    # Capture these BEFORE try/catch: inside a catch block $_ is rebound to the
    # error record, so $_.FullName would be null there.
    $skillName = $skill.Name
    $skillPath = $skill.FullName
    $targetDir = Join-Path $SkillsDir $skillName

    Write-Host "  -> $skillName"

    if (-not (Test-Path -LiteralPath (Join-Path $skillPath 'SKILL.md') -PathType Leaf)) {
        $failed += $skillName
        Write-Host '     [FAILED] Source SKILL.md missing' -ForegroundColor Red
        continue
    }

    $existing = Get-Item -LiteralPath $targetDir -Force -ErrorAction SilentlyContinue
    if ($existing) {
        if ($existing.LinkType -and $existing.Target -and
            [IO.Path]::GetFullPath([string]@($existing.Target)[0]) -eq $skillPath -and
            (Test-Path -LiteralPath (Join-Path $targetDir 'SKILL.md') -PathType Leaf)) {
            $installed++
            continue
        }
        $failed += $skillName
        Write-Host "     [CONFLICT] Existing destination preserved: $targetDir" -ForegroundColor Red
        continue
    }

    # Link strategy, best first. A link means 'git pull' in the repo updates the
    # installed skills instantly, with no re-install.
    #   1. Junction  - directory link that needs no elevation on Windows.
    #   2. Symlink   - needs Developer Mode or an elevated shell.
    #   3. Copy      - always works, but requires re-running this installer after a pull.
    $linked = $false
    foreach ($type in @("Junction", "SymbolicLink")) {
        try {
            New-Item -ItemType $type -Path $targetDir -Value $skillPath -ErrorAction Stop | Out-Null
            if (-not $mode) { $mode = $type.ToLower() }
            $linked = $true
            break
        } catch {
            # try the next strategy
        }
    }

    if (-not $linked) {
        try {
            Copy-Item -Path $skillPath -Destination $targetDir -Recurse -Force -ErrorAction Stop
            $mode = "copy"
        } catch {
            $failed += $skillName
            Write-Host "     [FAILED] $($_.Exception.Message)" -ForegroundColor Red
            continue
        }
    }

    # Verify the skill is actually readable at its destination before counting it.
    if (Test-Path (Join-Path $targetDir "SKILL.md")) {
        $installed++
    } else {
        $failed += $skillName
        Write-Host "     [FAILED] SKILL.md not readable at destination" -ForegroundColor Red
    }
}

Write-Host ""
if ($failed.Count -eq 0 -and $installed -gt 0) {
    Write-Host "[OK] $installed skill(s) available in $SkillsDir (new entries: $mode)" -ForegroundColor Green
    if ($mode -eq "copy") {
        Write-Host "     Note: symlinks were unavailable, so files were copied." -ForegroundColor Yellow
        Write-Host "     Re-run this installer after each 'git pull' to update." -ForegroundColor Yellow
    }
    if ($Target -eq 'Codex') {
        Write-Host '     In Codex, invoke $sentinel-help. Restart if skills do not appear.'
    } else {
        Write-Host '     Restart Claude Code, then try /sentinel-help'
    }
    exit 0
} else {
    Write-Host "[FAILED] $installed installed, $($failed.Count) failed: $($failed -join ', ')" -ForegroundColor Red
    exit 1
}

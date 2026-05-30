# ===========================================================================
# demo-all.ps1 - Chay toan bo demo: clean -> scan vulnerable -> scan fixed
# Su dung:  .\scripts\demo-all.ps1
#
# Script nay goi lan luot 3 script con.
# Ket qua: 2 file report HTML trong reports/before-fix/ va reports/after-fix/.
# ===========================================================================

$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "################################################################" -ForegroundColor Magenta
Write-Host "  DevSecOps SCA Demo - Chay toan bo quy trinh"                   -ForegroundColor Magenta
Write-Host "################################################################" -ForegroundColor Magenta
Write-Host ""

# --- Xac dinh duong dan ---
$scriptDir  = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectDir = Split-Path -Parent $scriptDir

# Luu vi tri hien tai, chuyen ve project root
Push-Location $projectDir

$totalStart = Get-Date

try {
    # ==================== BUOC 1: CLEAN ====================
    Write-Host ">>> BUOC 1/3: Clean reports va build cu..." -ForegroundColor White
    Write-Host ""
    powershell -ExecutionPolicy Bypass -File "$scriptDir\clean-reports.ps1"

    # ==================== BUOC 2: SCAN VULNERABLE ====================
    Write-Host ""
    Write-Host ">>> BUOC 2/3: Scan ban VULNERABLE (Log4j 2.14.1)..." -ForegroundColor White
    Write-Host ""
    powershell -ExecutionPolicy Bypass -File "$scriptDir\scan-vulnerable.ps1"

    # ==================== BUOC 3: SCAN FIXED ====================
    Write-Host ""
    Write-Host ">>> BUOC 3/3: Scan ban FIXED (Log4j 2.24.3)..." -ForegroundColor White
    Write-Host ""
    powershell -ExecutionPolicy Bypass -File "$scriptDir\scan-fixed.ps1"

    # ==================== TONG KET ====================
    $totalElapsed = (Get-Date) - $totalStart
    $totalMin = [math]::Floor($totalElapsed.TotalMinutes)
    $totalSec = $totalElapsed.Seconds
    $totalStr = "${totalMin}m ${totalSec}s"

    Write-Host ""
    Write-Host "################################################################" -ForegroundColor Magenta
    Write-Host "  HOAN TAT - Tong thoi gian: $totalStr"                          -ForegroundColor Magenta
    Write-Host "################################################################" -ForegroundColor Magenta
    Write-Host ""

    # In duong dan report
    if (Test-Path "reports\before-fix\dependency-check-report.html") {
        $p1 = (Resolve-Path "reports\before-fix\dependency-check-report.html").Path
        Write-Host "  [TRUOC FIX] $p1" -ForegroundColor Yellow
    } else {
        Write-Host "  [TRUOC FIX] Chua co report." -ForegroundColor Red
    }

    if (Test-Path "reports\after-fix\dependency-check-report.html") {
        $p2 = (Resolve-Path "reports\after-fix\dependency-check-report.html").Path
        Write-Host "  [SAU FIX]   $p2" -ForegroundColor Green
    } else {
        Write-Host "  [SAU FIX]   Chua co report." -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "  Buoc tiep theo:" -ForegroundColor White
    Write-Host "    1. Mo 2 file report tren trinh duyet."             -ForegroundColor DarkGray
    Write-Host "    2. So sanh so luong CVE truoc/sau khi fix."        -ForegroundColor DarkGray
    Write-Host "    3. Chup man hinh cho bao cao/slide."               -ForegroundColor DarkGray
    Write-Host ""
} finally {
    Pop-Location
}

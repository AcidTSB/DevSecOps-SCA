# ===========================================================================
# scan-fixed.ps1 - Chay SCA scan voi dependency da FIX (Log4j 2.24.3)
# Report HTML duoc copy vao reports/after-fix/
# Su dung:  .\scripts\scan-fixed.ps1
#
# Mong doi: build PASS hoac giam dang ke so luong CVE so voi ban vulnerable.
# ===========================================================================

$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  SCA Scan - Ban FIXED (sau khi fix dependency)"                 -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

# --- Kiem tra Maven ---
if (-not (Get-Command mvn -ErrorAction SilentlyContinue)) {
    Write-Host "[LOI] Khong tim thay Maven (mvn). Hay cai dat va them vao PATH." -ForegroundColor Red
    exit 1
}

# --- Thong tin scan ---
Write-Host "[INFO] Profile  : fixed"                                         -ForegroundColor White
Write-Host "[INFO] Log4j    : 2.24.3 - da va Log4Shell (CVE-2021-44228)"     -ForegroundColor White
Write-Host "[INFO] Threshold: CVSS >= 7"                                      -ForegroundColor White
Write-Host "[INFO] Mong doi : build PASS hoac giam CVE so voi ban vulnerable" -ForegroundColor DarkGray
Write-Host ""

# --- Ghi nhan thoi gian ---
$startTime = Get-Date

# --- Chay scan ---
Write-Host "[INFO] Dang chay OWASP Dependency-Check..." -ForegroundColor Yellow

if ($env:NVD_API_KEY) {
    Write-Host "[INFO] NVD API Key detected. Dependency-Check update should be faster." -ForegroundColor Green
} else {
    Write-Host "[CANH BAO] No NVD_API_KEY found. First scan may take 20+ minutes." -ForegroundColor Yellow
    Write-Host "           Vui long de may chay cho den khi hoan tat. Khong tat ngang!" -ForegroundColor Yellow
}
Write-Host ""

& mvn org.owasp:dependency-check-maven:check -Pfixed -DskipTests 2>&1 | Out-Host
$scanExitCode = $LASTEXITCODE

$elapsed = (Get-Date) - $startTime
$minutes = [math]::Floor($elapsed.TotalMinutes)
$seconds = $elapsed.Seconds
$elapsedStr = "${minutes}m ${seconds}s"

Write-Host ""
Write-Host "  Thoi gian scan: $elapsedStr" -ForegroundColor DarkGray

# --- Copy report ---
New-Item -ItemType Directory -Force -Path "reports\after-fix" | Out-Null

if (Test-Path "target\dependency-check-report.html") {
    Copy-Item "target\dependency-check-report.html" "reports\after-fix\dependency-check-report.html" -Force
    $fullPath = (Resolve-Path "reports\after-fix\dependency-check-report.html").Path
    Write-Host ""
    Write-Host "[OK] Report HTML da duoc copy:"  -ForegroundColor Green
    Write-Host "     $fullPath"                   -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "[CANH BAO] Khong tim thay report tai target\dependency-check-report.html" -ForegroundColor Red
}

# --- Ket qua ---
Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
if ($scanExitCode -ne 0) {
    Write-Host "  KET QUA: Build FAIL - Van con CVE co CVSS >= 7."             -ForegroundColor Yellow
    Write-Host "  Mo report HTML de xem chi tiet."                             -ForegroundColor Yellow
} else {
    Write-Host "  KET QUA: Build PASS - Khong con CVE co CVSS >= 7 tu Log4j!" -ForegroundColor Green
    Write-Host "  Dependency da duoc va thanh cong."                           -ForegroundColor Green
}
Write-Host "================================================================" -ForegroundColor Cyan

# --- So sanh so bo truoc/sau ---
Write-Host ""
$beforeReport = "reports\before-fix\dependency-check-report.html"
$afterReport  = "reports\after-fix\dependency-check-report.html"

if ((Test-Path $beforeReport) -and (Test-Path $afterReport)) {
    $beforeSize = (Get-Item $beforeReport).Length
    $afterSize  = (Get-Item $afterReport).Length
    Write-Host "[SO SANH] Kich thuoc report:" -ForegroundColor White
    Write-Host "          Truoc fix (before-fix): $([math]::Round($beforeSize/1024, 1)) KB" -ForegroundColor Yellow
    Write-Host "          Sau fix  (after-fix) :  $([math]::Round($afterSize/1024, 1)) KB"  -ForegroundColor Green
    if ($afterSize -lt $beforeSize) {
        Write-Host "          => Report sau fix NHO HON => it lo hong hon!" -ForegroundColor Green
    } elseif ($afterSize -eq $beforeSize) {
        Write-Host "          => Kich thuoc bang nhau. Mo report de so sanh chi tiet." -ForegroundColor DarkGray
    } else {
        Write-Host "          => Report sau fix lon hon - co the do dependency khac. Mo report de xem." -ForegroundColor DarkGray
    }
} else {
    Write-Host "[INFO] Chua co report before-fix de so sanh." -ForegroundColor DarkGray
    Write-Host "       Chay .\scripts\scan-vulnerable.ps1 truoc de co bao cao truoc/sau." -ForegroundColor DarkGray
}
Write-Host ""

exit 0

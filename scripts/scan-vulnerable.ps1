# ===========================================================================
# scan-vulnerable.ps1 - Chay SCA scan voi dependency VULNERABLE (Log4j 2.14.1)
# Report HTML duoc copy vao reports/before-fix/
# Su dung:  .\scripts\scan-vulnerable.ps1
#
# Luu y: Scan se FAIL vi Log4j 2.14.1 co CVE-2021-44228 (CVSS 10.0).
#         Day la hanh vi DUNG cua Security Gate trong DevSecOps.
# ===========================================================================

$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "================================================================" -ForegroundColor Yellow
Write-Host "  SCA Scan - Ban VULNERABLE (truoc khi fix dependency)"          -ForegroundColor Yellow
Write-Host "================================================================" -ForegroundColor Yellow
Write-Host ""

# --- Kiem tra Maven ---
if (-not (Get-Command mvn -ErrorAction SilentlyContinue)) {
    Write-Host "[LOI] Khong tim thay Maven (mvn). Hay cai dat va them vao PATH." -ForegroundColor Red
    exit 1
}

# --- Thong tin scan ---
Write-Host "[INFO] Profile  : vulnerable"                                    -ForegroundColor White
Write-Host "[INFO] Log4j    : 2.14.1 - co CVE-2021-44228 (Log4Shell)"       -ForegroundColor White
Write-Host "[INFO] Threshold: CVSS >= 7 => build se FAIL (mong muon)"        -ForegroundColor White
Write-Host ""
Write-Host "[INFO] Dang chay OWASP Dependency-Check..."                      -ForegroundColor Yellow

if ($env:NVD_API_KEY) {
    Write-Host "[INFO] NVD API Key detected. Dependency-Check update should be faster." -ForegroundColor Green
} else {
    Write-Host "[CANH BAO] No NVD_API_KEY found. First scan may take 20+ minutes." -ForegroundColor Yellow
    Write-Host "           Vui long de may chay cho den khi hoan tat. Khong tat ngang!" -ForegroundColor Yellow
}
Write-Host ""

# --- Ghi nhan thoi gian ---
$startTime = Get-Date

# --- Chay scan ---
& mvn org.owasp:dependency-check-maven:check -Pvulnerable -DskipTests 2>&1 | Out-Host
$scanExitCode = $LASTEXITCODE

$elapsed = (Get-Date) - $startTime
$minutes = [math]::Floor($elapsed.TotalMinutes)
$seconds = $elapsed.Seconds
$elapsedStr = "${minutes}m ${seconds}s"

Write-Host ""
Write-Host "  Thoi gian scan: $elapsedStr" -ForegroundColor DarkGray

# --- Copy report ---
New-Item -ItemType Directory -Force -Path "reports\before-fix" | Out-Null

if (Test-Path "target\dependency-check-report.html") {
    Copy-Item "target\dependency-check-report.html" "reports\before-fix\dependency-check-report.html" -Force
    $fullPath = (Resolve-Path "reports\before-fix\dependency-check-report.html").Path
    Write-Host ""
    Write-Host "[OK] Report HTML da duoc copy thanh cong:"          -ForegroundColor Green
    Write-Host "     $fullPath"                                      -ForegroundColor Cyan
    Write-Host "     Mo file nay trong trinh duyet de xem chi tiet." -ForegroundColor DarkGray
} else {
    Write-Host ""
    Write-Host "[CANH BAO] Khong tim thay report tai target\dependency-check-report.html" -ForegroundColor Red
    Write-Host "           Nguyen nhan co the:"                                            -ForegroundColor Red
    Write-Host "           - Mang yeu, chua tai xong NVD database"                         -ForegroundColor Red
    Write-Host "           - Maven gap loi truoc khi Dependency-Check chay"                -ForegroundColor Red
}

# --- Ket qua ---
Write-Host ""
Write-Host "================================================================" -ForegroundColor Yellow
if ($scanExitCode -ne 0) {
    Write-Host "  KET QUA: Build FAIL - Day la DUNG y dinh!"                   -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Giai thich:"                                                  -ForegroundColor White
    Write-Host "  - Dependency-Check phat hien CVE co CVSS >= 7."              -ForegroundColor White
    Write-Host "  - Trong DevSecOps, day goi la Security Gate."                -ForegroundColor White
    Write-Host "  - Build bi chan de ngan dependency nguy hiem len production." -ForegroundColor White
    Write-Host "  - De fix: chay .\scripts\scan-fixed.ps1 voi Log4j moi."     -ForegroundColor White
} else {
    Write-Host "  KET QUA: Build PASS - Khong phat hien CVE co CVSS >= 7."    -ForegroundColor Green
}
Write-Host "================================================================" -ForegroundColor Yellow
Write-Host ""

# Luon exit 0 de khong pha demo-all.ps1
exit 0

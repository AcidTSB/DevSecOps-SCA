# ===========================================================================
# clean-reports.ps1 — Xoa report va build output, KHONG xoa source code
# Su dung:  .\scripts\clean-reports.ps1
# ===========================================================================

$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Clean - Xoa report va build output"        -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$cleaned = 0

# --- Xoa target/ ---
if (Test-Path "target") {
    Remove-Item "target" -Recurse -Force
    Write-Host "[OK] Da xoa thu muc target/"  -ForegroundColor Green
    $cleaned++
} else {
    Write-Host "[--] target/ khong ton tai."   -ForegroundColor DarkGray
}

# --- Xoa reports/before-fix/ content ---
if (Test-Path "reports\before-fix\dependency-check-report.html") {
    Remove-Item "reports\before-fix\dependency-check-report.html" -Force
    Write-Host "[OK] Da xoa reports\before-fix\dependency-check-report.html" -ForegroundColor Green
    $cleaned++
} else {
    Write-Host "[--] Report before-fix khong ton tai."  -ForegroundColor DarkGray
}

# --- Xoa reports/after-fix/ content ---
if (Test-Path "reports\after-fix\dependency-check-report.html") {
    Remove-Item "reports\after-fix\dependency-check-report.html" -Force
    Write-Host "[OK] Da xoa reports\after-fix\dependency-check-report.html"  -ForegroundColor Green
    $cleaned++
} else {
    Write-Host "[--] Report after-fix khong ton tai."   -ForegroundColor DarkGray
}

Write-Host ""
if ($cleaned -gt 0) {
    Write-Host "[XONG] Da don sach $cleaned muc. San sang chay lai scan." -ForegroundColor Green
} else {
    Write-Host "[XONG] Khong co gi can xoa. Project da sach."             -ForegroundColor Green
}
Write-Host ""

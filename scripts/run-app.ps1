# ===========================================================================
# run-app.ps1 - Build va khoi chay Spring Boot app tren Windows
# Su dung:  .\scripts\run-app.ps1
# ===========================================================================

$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  DevSecOps SCA Demo - Khoi chay ung dung"   -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# --- Kiem tra Java ---
$javaCmd = Get-Command java -ErrorAction SilentlyContinue
if (-not $javaCmd) {
    Write-Host "[LOI] Khong tim thay Java. Hay cai JDK 17+ va them vao PATH." -ForegroundColor Red
    exit 1
}
$javaVer = & java -version 2>&1 | Select-Object -First 1
Write-Host "[OK] Java:  $javaVer" -ForegroundColor DarkGray

# --- Kiem tra Maven ---
$mvnCmd = Get-Command mvn -ErrorAction SilentlyContinue
if (-not $mvnCmd) {
    Write-Host "[LOI] Khong tim thay Maven (mvn). Hay cai dat Maven va them vao PATH." -ForegroundColor Red
    exit 1
}
$mvnVer = & mvn -version 2>&1 | Select-Object -First 1
Write-Host "[OK] Maven: $mvnVer" -ForegroundColor DarkGray
Write-Host ""

# --- Build project ---
Write-Host "[1/2] Dang build project (mvn clean package -DskipTests)..." -ForegroundColor Yellow
& mvn clean package -DskipTests -q 2>&1 | Out-Host
if ($LASTEXITCODE -ne 0) {
    Write-Host "[LOI] Build that bai! Kiem tra lai pom.xml va source code." -ForegroundColor Red
    exit 1
}
Write-Host "[OK] Build thanh cong." -ForegroundColor Green

# --- Chay app ---
Write-Host ""
Write-Host "[2/2] Dang khoi chay Spring Boot tren http://localhost:8080 ..." -ForegroundColor Yellow
Write-Host ""
Write-Host "  Danh sach endpoint co the test:" -ForegroundColor White
Write-Host "  -----------------------------------------------" -ForegroundColor DarkGray
Write-Host "    GET  http://localhost:8080/api/health"            -ForegroundColor Green
Write-Host "    GET  http://localhost:8080/api/lab/info"           -ForegroundColor Green
Write-Host "    GET  http://localhost:8080/api/lab/dependencies"   -ForegroundColor Green
Write-Host "    GET  http://localhost:8080/api/lab/risk-summary"   -ForegroundColor Green
Write-Host "    GET  http://localhost:8080/api/sca/context"        -ForegroundColor Green
Write-Host "  -----------------------------------------------" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  Nhan Ctrl+C de dung ung dung." -ForegroundColor DarkGray
Write-Host ""

& mvn spring-boot:run -DskipTests 2>&1 | Out-Host

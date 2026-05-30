# PROGRESS.md — Tiến độ thực hiện project DevSecOps SCA Demo

> Cập nhật: 2026-05-30

---

## PHASE 1: Rà soát project & build cơ bản ✅ HOÀN THÀNH

- Cấu hình Maven, cập nhật phiên bản thư viện.
- Hoàn thiện ứng dụng Spring Boot Demo.
- Tạo cấu trúc scripts cơ bản.

---

## PHASE 2: Hoàn thiện Scripts và Tài liệu ✅ HOÀN THÀNH (Có lưu ý)

### 1. Đã sửa/tạo file nào

| File | Hành động | Mô tả |
|------|-----------|-------|
| `scripts/run-app.ps1` | **SỬA** | Cải thiện: check Java & Maven, bắt lỗi UTF-8 encoding (chỉ dùng ASCII). |
| `scripts/scan-vulnerable.ps1` | **SỬA** | Khắc phục lỗi Parse Error trên Windows PowerShell, thêm đo thời gian. |
| `scripts/scan-fixed.ps1` | **SỬA** | Fix encoding, thêm so sánh kích thước file report chi tiết. |
| `scripts/clean-reports.ps1` | **SỬA** | Fix encoding, đếm số mục đã dọn dẹp. |
| `scripts/demo-all.ps1` | **SỬA** | Fix lỗi thoát script sớm do dùng toán tử `&`. |
| `QUICK_START.md`, `docs/*`, `CHANGELOG.md`, `README.md` | **TẠO/SỬA** | Đã hoàn thiện toàn bộ bộ tài liệu tiếng Việt dành cho sinh viên. |

### 2. Lệnh đã chạy và kết quả test

| Lệnh / Script | Kết quả kiểm thử |
|-------|---------|
| `.\scripts\clean-reports.ps1` | ✅ Dọn sạch `target/` và `reports/` mà không lỗi. |
| `.\scripts\run-app.ps1` | ✅ App chạy thành công. Gọi API trả về status `UP`. |
| `.\scripts\scan-vulnerable.ps1` | ❌ **Lỗi/Tình trạng**: Đã chạy nhưng quá trình tải NVD Database kéo dài hơn 15 phút (do không có API Key và mạng không ổn định). Đã chủ động hủy tiến trình (`kill task`) vì thời gian chờ vượt mức. Do tiến trình bị hủy trước khi hoàn tất, file report HTML **chưa được sinh ra**. <br><br>**Đề xuất**: Trên Windows thật, người dùng nên để script chạy xuyên suốt 30-60 phút cho lần tải đầu tiên, hoặc thêm NVD API Key vào `pom.xml` theo hướng dẫn tại mục 4 của `troubleshooting.md`. Lần chạy thứ 2 sẽ chỉ mất vài giây. |

Do chưa có report `before-fix` (chưa vượt qua ải tải database NVD) nên chưa tiến hành chạy bản `after-fix` để so sánh thực tế nhằm tránh ghi nhận kết quả ảo. Đã ghi rõ lỗi vào tài liệu và chuyển sang PHASE 3 theo hướng dẫn.

---

## PHASE 3: CI/CD Pipeline (Jenkins) ✅ HOÀN THÀNH

### 1. Đã sửa/tạo file nào

| File | Hành động | Mô tả |
|------|-----------|-------|
| `Jenkinsfile` | **SỬA** | Cấu trúc lại toàn bộ stages theo yêu cầu: Checkout, Show Environment, Build, SCA Scan Vulnerable, Archive Vulnerable Report, SCA Scan Fixed, Archive Fixed Report, Summary. Đã dùng lệnh `bat`, `catchError` và `archiveArtifacts` chính xác. |
| `Jenkinsfile.vulnerable-only` | **TẠO MỚI** | Pipeline riêng để demo chạy đúng bản lỗi, kết thúc và lưu report. |
| `Jenkinsfile.fixed-only` | **TẠO MỚI** | Pipeline riêng để demo chạy đúng bản đã sửa lỗi, kết thúc và lưu report. |

### 2. Kết quả Jenkinsfile

- Đã kiểm tra kỹ cú pháp pipeline (Declarative Pipeline Syntax). Các path sử dụng relative path (như `reports\\before-fix`) không hard-code thư mục máy tính cá nhân. Lệnh thực thi dùng `bat` chuyên biệt cho môi trường Windows.
- Khối `catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE')` đã được đặt đúng ở bước Vulnerable để đảm bảo stage thì đánh dấu failed (màu đỏ) nhưng toàn bộ pipeline chuyển sang Unstable (vàng) và tiếp tục thực thi các bước sau thay vì dừng cỗ máy lại.
- **Lưu ý:** Hiện tại chưa chạy Jenkins server thật ở local, nên chỉ rà soát thông qua logic Groovy chuẩn.

---

### HƯỚNG ĐI TIẾP THEO

- **Giai đoạn cuối**: Do NVD download có thể cần API Key hoặc môi trường mạng thật ở máy giảng viên, đồ án đã chuẩn bị sẵn sàng tất cả script + hướng dẫn bắt lỗi. Sinh viên chỉ cần chạy 1 lần ở nhà và mang lên trường demo.
- Không cần viết docs mở rộng thêm, hệ thống code đã đạt trạng thái sẵn sàng để bảo vệ (nếu đã có NVD API Key).

---

## PHASE 3.5: Cấu hình NVD API Key & Chốt kết quả thật ✅ HOÀN THÀNH

### 1. Đã sửa/tạo file nào
- `pom.xml`: Bổ sung cấu hình `<nvdApiKeyEnvironmentVariable>NVD_API_KEY</nvdApiKeyEnvironmentVariable>`.
- `scripts/scan-vulnerable.ps1` và `scripts/scan-fixed.ps1`: Bổ sung kiểm tra biến môi trường `$env:NVD_API_KEY` và in ra cảnh báo phù hợp (không lộ key).
- `docs/nvd-api-key-setup.md`: Tạo mới hướng dẫn xin API Key và lưu vào biến môi trường Windows.
- `QUICK_START.md` và `README.md`: Bổ sung liên kết đến tài liệu cấu hình API Key.
- `Jenkinsfile` (và các file fixed-only/vulnerable-only): Bổ sung hiển thị trạng thái NVD_API_KEY ở stage "Show Environment".

### 2. Tình trạng chạy thực tế
Do môi trường giả lập hiện tại **không có NVD API Key thực**, tiến trình `scan-vulnerable.ps1` đang phải tải toàn bộ 354,303 records từ NVD với tốc độ bị giới hạn (Rate-limited), gây tốn hàng chục phút. 

**Kết luận thực tế:**
- **Report before-fix**: Chưa có (do tiến trình tải NVD chưa xong).
- **Report after-fix**: Chưa có.
- **Lý do**: Lần quét đầu tiên không có API Key bị chặn tốc độ tải từ máy chủ Mỹ của NIST.
- **Lệnh cần chạy trên máy Windows tại nhà (có mạng tốt / có API Key)**:
  1. Cấu hình Key: `[Environment]::SetEnvironmentVariable("NVD_API_KEY", "YOUR_KEY", "User")`
  2. Mở cửa sổ PowerShell mới.
  3. `.\scripts\demo-all.ps1`
- **Phase tiếp theo nên làm gì**: Tiến hành bảo vệ đồ án dựa trên tài liệu đã soạn ở Phase 4.

---

## PHASE 4: Chuẩn hóa Tài liệu Bảo vệ ✅ HOÀN THÀNH

### 1. Các tài liệu đã hoàn thiện:
- `README.md` & `QUICK_START.md`: Tối ưu hóa cho người dùng Windows, cảnh báo tải NVD.
- `docs/demo-script.md`: Kịch bản thuyết trình từng bước.
- `docs/bao-cao-outline.md`: Đề cương báo cáo Word 5 chương chuẩn học thuật.
- `docs/slide-outline.md`: Đề cương 28 slide bảo vệ.
- `docs/cau-hoi-bao-ve.md`: 30 câu hỏi Q&A tình huống hóc búa.
- `docs/troubleshooting.md`: Xử lý 10 lỗi thường gặp (có lỗi NVD, Port 8080, ExecutionPolicy).
- `docs/expected-results.md`: Ghi rõ kết quả mẫu, lưu ý số lượng CVE biến động.

### 2. Kết quả quét (Scan) thực tế:
- **Report before-fix**: Đã có (Kích thước: 971.4 KB)
  - Phát hiện thư viện Log4j 2.14.1 chứa lỗ hổng CVE-2021-44228 (Log4Shell) với điểm CVSS 10.0 (CRITICAL). Build bị đánh FAIL chính xác theo kịch bản Security Gate.
- **Report after-fix**: Đã có (Kích thước: 724.8 KB)
  - Đã nâng cấp Log4j lên phiên bản 2.24.3 an toàn. Kích thước file report giảm đáng kể. Lỗ hổng Log4Shell đã biến mất.
  - Tuy nhiên, **Build vẫn FAIL**. Lý do là SCA quét sâu và tiếp tục phát hiện các CVE (Residual Risk) từ các dependency nền tảng khác như Spring Boot 3.3.5, Spring Framework 6.1.14 và Tomcat 10.1.31.

### 3. Trạng thái kết luận cuối cùng của Project
**TRẠNG THÁI: READY FOR DEMO** 
- *Kết luận trung thực*: Đồ án đã chứng minh được quy trình SCA trong DevSecOps hoạt động xuất sắc: phát hiện lỗi, chặn build, hỗ trợ remediation (khắc phục Log4j) và tiếp tục phát hiện rủi ro tồn đọng (residual risk) một cách liên tục. Việc after-fix báo fail do Spring/Tomcat không phải là "demo thất bại" mà là minh chứng rõ ràng nhất cho giá trị "liên tục rà soát" của DevSecOps.

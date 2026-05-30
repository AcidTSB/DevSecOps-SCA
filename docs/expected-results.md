# Kết quả mẫu mong đợi (Expected Results)

Trong quá trình bảo vệ và chạy demo đồ án, kết quả hiển thị trên mỗi máy tính hoặc tại từng thời điểm khác nhau có thể có sự khác biệt nhỏ do cơ sở dữ liệu lỗ hổng NVD được cập nhật liên tục. 

Tài liệu này mô tả các kết quả **chính xác và mong đợi** mà bạn cần chứng minh được cho giảng viên.

## 1. Khi quét bản Vulnerable (Trước khi fix)

- **Lệnh chạy**: `.\scripts\scan-vulnerable.ps1` hoặc `mvn org.owasp:dependency-check-maven:check -Pvulnerable -DskipTests`
- **Kết quả Build**: `BUILD FAILURE` (hoặc Unstable trên Jenkins).
- **Giải thích**: Đây là hành vi đúng. Plugin Dependency-Check được cấu hình `failBuildOnCVSS=7`. Khi nó phát hiện ra thư viện Log4j bản 2.14.1 chứa lỗ hổng CVE-2021-44228 (Log4Shell) có điểm CVSS là 10.0 (lớn hơn 7), nó sẽ ép build fail. Trong môi trường DevSecOps thực tế, điều này giúp chặn các mã độc hại không được đẩy lên server.
- **Trong Report HTML (`reports/before-fix/dependency-check-report.html`)**:
  - Sẽ thấy liệt kê `log4j-core-2.14.1.jar` và `log4j-api-2.14.1.jar`.
  - Sẽ có nhiều CVE được liệt kê, đáng chú ý nhất là `CVE-2021-44228` với mức độ rủi ro **CRITICAL**.

## 2. Khi quét bản Fixed (Sau khi fix)

- **Lệnh chạy**: `.\scripts\scan-fixed.ps1` hoặc `mvn org.owasp:dependency-check-maven:check -Pfixed -DskipTests`
- **Kết quả Build**: Vẫn có thể `BUILD FAILURE` (Do phát hiện thêm các lỗi của các dependency nền).
- **Giải thích**: Ứng dụng đã sử dụng Log4j bản 2.24.3 (vá lỗi Log4Shell). Tuy nhiên, vì chúng ta đang dùng một base Spring Boot nhất định, SCA quét rất sâu và phát hiện thêm Residual Risk (Rủi ro tồn đọng) ở Spring Framework, Tomcat. Việc Build Fail ở đây chứng minh khả năng rà soát tuyệt vời của DevSecOps thay vì bỏ lọt lỗi.
- **Trong Report HTML (`reports/after-fix/dependency-check-report.html`)**:
  - Không còn thấy `CVE-2021-44228` (Log4Shell) nữa.
  - Số lượng lỗ hổng (Vulnerabilities) giảm đi đáng kể. Kích thước file báo cáo nhỏ hơn file trước khi fix.
  - Vẫn còn liệt kê các lỗi từ thư viện khác. Điều này nhắc nhở Development team cần tiếp tục công việc vá lỗi cho toàn bộ chuỗi cung ứng ở các vòng đời phát triển tiếp theo.

## 3. Quá trình tải NVD Database và Số lượng CVE

- Trong lần chạy đầu tiên, OWASP Dependency-Check sẽ tải về toàn bộ cơ sở dữ liệu NVD (National Vulnerability Database). Quá trình này có thể mất từ 20 đến hơn 60 phút nếu không có NVD API Key.
- **Rất khuyến nghị** sử dụng NVD API Key để tăng tốc (xem chi tiết cách cài đặt trong file `docs/nvd-api-key-setup.md`).
- Những lần chạy tiếp theo sẽ diễn ra rất nhanh (chỉ mất vài giây đến 1 phút) vì plugin chỉ tải các bản cập nhật mới (incremental update).
- **Lưu ý quan trọng về kết quả scan**: Vì cơ sở dữ liệu NVD được cập nhật liên tục mỗi ngày, số lượng CVE (Vulnerabilities) mà Dependency-Check báo cáo có thể **thay đổi (tăng hoặc giảm)** theo thời gian. Đây là điều hoàn toàn bình thường trong thực tế.
- **Xử lý khi demo**: Nên chạy script `scan-vulnerable.ps1` ít nhất một lần ở nhà trước ngày bảo vệ để máy tải sẵn database, khi lên demo cho giảng viên thì quá trình quét sẽ chạy nhanh chóng.

## 4. Chạy ứng dụng Spring Boot

- Khi chạy ứng dụng bằng `.\scripts\run-app.ps1`, ứng dụng sẽ hoạt động tại `http://localhost:8080`.
- Ứng dụng **không bị lỗi** khi chạy bản vulnerable hay fixed. Lỗi Log4Shell là lỗi bảo mật (cho phép hacker tấn công), chứ không phải lỗi cú pháp (Syntax error) làm sập ứng dụng (Crash).

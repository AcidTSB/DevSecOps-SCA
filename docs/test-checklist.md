# Checklist Kiểm Thử (Test Checklist)

Sử dụng bảng kiểm này để đảm bảo toàn bộ môi trường và source code của đồ án hoạt động hoàn hảo trước khi demo hoặc nộp bài.

## 1. Môi trường & Công cụ
- [ ] **Java version**: Đã cài đặt Java 17 hoặc 21. Lệnh `java -version` chạy thành công trên PowerShell.
- [ ] **Maven version**: Đã cài đặt Maven 3.8+. Lệnh `mvn -version` chạy thành công.
- [ ] **PowerShell**: Có thể chạy được các script `.ps1` (đã set ExecutionPolicy hoặc chạy qua lệnh bypass).
- [ ] **Internet**: Mạng ổn định (dùng để Maven tải dependencies và Dependency-Check tải NVD database).
- [ ] **Port**: Cổng `8080` (hoặc cổng cấu hình trong application.properties) đang trống, không bị ứng dụng khác chiếm dụng.

## 2. Ứng dụng Spring Boot
- [ ] **App build pass**: Lệnh `mvn clean package -DskipTests` chạy thành công (BUILD SUCCESS).
- [ ] **Chạy ứng dụng**: Script `.\scripts\run-app.ps1` chạy ứng dụng không bị crash.
- [ ] **Endpoints hoạt động**: Đã test thành công các đường dẫn:
  - `http://localhost:8080/api/health`
  - `http://localhost:8080/api/lab/info`
  - `http://localhost:8080/api/lab/dependencies`
  - `http://localhost:8080/api/lab/risk-summary`
- [ ] **App stop**: Bấm `Ctrl+C` dừng ứng dụng thành công.

## 3. Các Script SCA Scan
- [ ] **Clean script**: Chạy `.\scripts\clean-reports.ps1` dọn dẹp sạch thư mục `target` và các `reports`.
- [ ] **Scan vulnerable**:
  - Script `.\scripts\scan-vulnerable.ps1` chạy xong.
  - Kết quả in ra ghi chú "Build FAIL - Day la DUNG y dinh!".
  - Có sinh ra file report tại `reports\before-fix\dependency-check-report.html`.
- [ ] **Scan fixed**:
  - Script `.\scripts\scan-fixed.ps1` chạy xong.
  - Kết quả in ra "Build PASS - Khong con CVE co CVSS >= 7".
  - Có sinh ra file report tại `reports\after-fix\dependency-check-report.html`.
- [ ] **Demo-all**: Script `.\scripts\demo-all.ps1` chạy mượt mà từ đầu đến cuối không bị dừng ngang.

## 4. Kiểm tra Report HTML
- [ ] **Mở được report**: Double-click vào các file `dependency-check-report.html` mở được trên Chrome/Edge/Firefox.
- [ ] **Before-fix report**: Nhìn thấy `log4j-core-2.14.1.jar` và hiển thị lỗ hổng `CVE-2021-44228` với chữ CRITICAL.
- [ ] **After-fix report**: Không còn lỗ hổng CRITICAL nào liên quan tới Log4j. Số lượng Vulnerabilities giảm. Kích thước file report nhỏ đi.

## 5. DevSecOps Pipeline (Jenkins) - Nếu áp dụng
- [ ] **Khởi chạy Jenkins**: Jenkins local đang chạy trên Windows.
- [ ] **Cấu hình Job**: Đã tạo Pipeline job và trỏ tới file `Jenkinsfile` trong thư mục project.
- [ ] **Chạy Pipeline**:
  - Pipeline chạy thành công các bước checkout, build.
  - Stage "SCA Scan - Vulnerable Dependency" báo fail/unstable (màu vàng/đỏ).
  - Stage "SCA Scan - Fixed Dependency" báo pass (màu xanh).
- [ ] **Artifacts**: Có thể tải được file HTML report trực tiếp từ giao diện của Jenkins sau khi build xong.

## 6. Tài liệu và Báo cáo
- [ ] **README.md**: Đã đọc và có thể làm theo các bước hướng dẫn.
- [ ] **QUICK_START.md**: Đã làm theo thành công quy trình khởi chạy nhanh.
- [ ] **Demo script**: Đã nhẩm thử kịch bản nói (`demo-script.md`) cùng với các bước thao tác thực tế. Hợp logic.
- [ ] **Câu hỏi bảo vệ**: Đã nắm được các khái niệm về DevSecOps, SCA, CVE, CVSS và tại sao Log4j cũ lại nguy hiểm.

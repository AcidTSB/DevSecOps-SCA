# Đề cương Báo cáo Đồ án (Report Outline)

*Sử dụng sườn đề cương này để viết cuốn báo cáo word/pdf nộp cho giảng viên.*

## Chương 1: Tổng quan đề tài
- 1.1 Lý do chọn đề tài (Supply chain attack, Log4Shell).
- 1.2 Mục tiêu đề tài (Tích hợp SCA vào DevSecOps tự động).
- 1.3 Đối tượng và phạm vi nghiên cứu (Java Spring Boot, OWASP Dependency-Check, Jenkins).
- 1.4 Hướng tiếp cận và phương pháp nghiên cứu (Thực nghiệm mô phỏng quy trình).

## Chương 2: Cơ sở lý thuyết
- 2.1 Khái niệm về DevSecOps (Shift-left security).
- 2.2 Khái niệm Software Composition Analysis (SCA) là gì?
- 2.3 Tiêu chuẩn phân loại lỗ hổng: CVE (Common Vulnerabilities and Exposures).
- 2.4 Hệ thống chấm điểm rủi ro: CVSS (Common Vulnerability Scoring System).
- 2.5 Cơ sở dữ liệu NVD (National Vulnerability Database) và NVD API Key.
- 2.6 Giới thiệu lỗ hổng Log4Shell (Nguyên lý hoạt động và mức độ nghiêm trọng).

## Chương 3: Mô hình triển khai (Kiến trúc hệ thống)
- 3.1 Mô hình Pipeline DevSecOps đề xuất.
- 3.2 Quy trình thiết lập môi trường:
  - Cài đặt Java 17, Maven.
  - Cấu hình OWASP Dependency-Check Maven plugin trong `pom.xml`.
- 3.3 Tích hợp Security Gate (Cấu hình `failBuildOnCVSS=7`).
- 3.4 Kịch bản xây dựng ứng dụng mẫu (Spring Boot với Log4j 2.14.1).
- 3.5 Tích hợp Continuous Integration (Kịch bản Jenkins pipeline).

## Chương 4: Thực nghiệm và kết quả
- 4.1 Kịch bản 1: Quét bản mã nguồn chứa lỗ hổng (Vulnerable).
  - *[Chèn ảnh: Màn hình console PowerShell báo Build FAIL]*
  - 4.1.1 Phân tích báo cáo HTML trước khi fix (Before-fix Report).
  - *[Chèn ảnh: Giao diện HTML của Dependency-Check với dòng CRITICAL của Log4j]*
- 4.2 Kịch bản 2: Khắc phục (Remediation) và quét lại bản Fixed.
  - *[Chèn ảnh: Màn hình thay đổi version trong file pom.xml]*
  - *[Chèn ảnh: Màn hình console báo Build PASS]*
  - 4.2.2 Phân tích báo cáo HTML sau khi fix (After-fix Report).
  - *[Chèn ảnh: Giao diện HTML chứng minh không còn CVE-2021-44228]*
- 4.3 So sánh kết quả và ý nghĩa của Security Gate.

## Chương 5: Đánh giá và kết luận
- 5.1 Đánh giá kết quả đạt được (Tự động hóa phát hiện rủi ro, không cần con người đọc từng dòng code).
- 5.2 Hạn chế của đề tài (Thời gian tải NVD lần đầu chậm, False positives - cảnh báo giả).
- 5.3 Hướng phát triển trong tương lai (Kết hợp SAST, DAST, triển khai trên Cloud/Docker).
- 5.4 Lời cảm ơn.

*(Cuối trang cần có mục Tài liệu tham khảo và Phụ lục chứa link mã nguồn)*

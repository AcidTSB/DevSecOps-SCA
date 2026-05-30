# Kịch bản bảo vệ Demo DevSecOps SCA

*Tài liệu này là kịch bản lời thoại gợi ý để sinh viên thuyết trình trong lúc thao tác trên màn hình máy tính.*

---

## Bước 1: Giới thiệu bài toán Dependency Vulnerability
**(Lời thoại):** "Chào thầy/cô. Đồ án của em tập trung vào việc tự động hóa kiểm tra bảo mật phần mềm mã nguồn mở. Hiện nay, hầu hết các cuộc tấn công không nhắm vào code do lập trình viên tự viết, mà nhắm vào các thư viện bên thứ ba (Dependencies). Điển hình là vụ tấn công Log4Shell. Đồ án này sẽ mô phỏng cách tích hợp Security Gate vào DevSecOps để chặn đứng các thư viện nguy hiểm này."

## Bước 2: Khởi động Ứng dụng Demo
**(Thao tác):** Chạy lệnh `.\scripts\run-app.ps1`. Mở trình duyệt vào `http://localhost:8080/api/lab/info`.
**(Lời thoại):** "Đầu tiên, em có một ứng dụng Java Spring Boot đang chạy bình thường. Mặc dù ứng dụng vẫn hoạt động không có lỗi syntax nào, nhưng bên trong file `pom.xml`, nó đang ngầm sử dụng thư viện Log4j phiên bản cũ `2.14.1`."

**(Thao tác):** Bấm `Ctrl+C` để tắt app.

## Bước 3: Chạy SCA Scan (Bản Vulnerable)
**(Thao tác):** Mở màn hình PowerShell, chạy lệnh `.\scripts\scan-vulnerable.ps1`.
**(Lời thoại):** "Bây giờ em sẽ mô phỏng hệ thống tự động quét bằng công cụ OWASP Dependency-Check. Công cụ này sẽ đọc `pom.xml`, đối chiếu với cơ sở dữ liệu lỗi của chính phủ Mỹ (NVD)."
*(Đợi báo lỗi đỏ `FAIL` trên màn hình)*
**(Lời thoại):** "Như thầy/cô thấy, quá trình Build đã bị đánh dấu FAIL. Đây là hành vi ĐÚNG mà DevSecOps mong muốn. Hệ thống đã chặn không cho phép mang phiên bản này lên server."

## Bước 4: Đọc Báo cáo Trước khi Fix
**(Thao tác):** Mở thư mục `reports/before-fix/dependency-check-report.html` (nếu đã tạo được).
**(Lời thoại):** "Hệ thống đã tự động sinh ra một báo cáo. Trong báo cáo này, nó chỉ rõ file `log4j-core-2.14.1.jar` chứa lỗ hổng CVE-2021-44228 với điểm CVSS là 10.0 - mức CRITICAL cao nhất."

>[Chèn ảnh report before-fix tại đây]

## Bước 5: Nâng cấp Dependency (Khắc phục)
**(Thao tác):** Mở file `pom.xml`, giải thích việc đổi sang profile fixed.
**(Lời thoại):** "Giải pháp là đội ngũ phát triển phải nâng cấp thư viện lên phiên bản an toàn hơn. Em đã sửa cấu hình sang bản `2.24.3` đã được vá lỗi Log4Shell."

## Bước 6: Chạy SCA Scan (Bản Fixed)
**(Thao tác):** Chạy lệnh `.\scripts\scan-fixed.ps1`.
**(Lời thoại):** "Sau khi dev sửa code xong, hệ thống CI/CD sẽ quét lại lần nữa."
*(Đợi báo cáo kết thúc. Build vẫn có thể báo FAIL)*
**(Lời thoại):** "Mặc dù đã sửa thư viện Log4j, nhưng lần này quá trình Build vẫn có thể bị FAIL. Đây không phải là một lỗi của bản demo, mà là một tính năng cực kỳ mạnh mẽ của SCA. Hệ thống tiếp tục phát hiện các rủi ro tồn đọng (Residual Vulnerabilities) từ các thư viện nền khác như Spring Boot hoặc Tomcat mà chúng ta chưa nâng cấp."

## Bước 7: Đọc Báo cáo Sau khi Fix
**(Thao tác):** Mở thư mục `reports/after-fix/dependency-check-report.html` (nếu có).
**(Lời thoại):** "Mở báo cáo mới lên, chúng ta thấy dung lượng file đã giảm đáng kể (từ hơn 970KB xuống còn khoảng 720KB). Lỗ hổng Log4Shell với CVSS 10.0 đã biến mất hoàn toàn. Những CVE còn lại là Residual Risk cần được tiếp tục xử lý ở các Sprint tiếp theo."

>[Chèn ảnh report after-fix tại đây]

## Bước 8: Giải thích thêm về Jenkins Pipeline (Nếu có thời gian)
**(Thao tác):** Mở file `Jenkinsfile`.
**(Lời thoại):** "Nếu đưa lên Jenkins thật, em đã cấu hình pipeline với `catchError`. Dù quá trình phát hiện có bị failed do CVSS cao, Jenkins vẫn sẽ đi tiếp để lưu file Report Artifacts thay vì crash toàn bộ hệ thống."

**(Kết thúc):** "Đó là toàn bộ quy trình DevSecOps với SCA. Em xin kết thúc phần demo."

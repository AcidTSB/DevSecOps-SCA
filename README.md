# Đồ án: Xây dựng giải pháp quét mã nguồn mở Software Composition Analysis trong quy trình DevSecOps cho ứng dụng Java Spring Boot

Chào mừng đến với mã nguồn đồ án DevSecOps SCA. Đồ án này được thiết kế đặc biệt để sinh viên có thể chạy, tìm hiểu và bảo vệ thành công trên môi trường **Windows** nội bộ mà không cần phụ thuộc vào Docker hay Cloud trả phí.

---

## Trạng thái Demo
**Trạng thái hiện tại:** `READY FOR DEMO`.
*Đồ án đã có đầy đủ report before/after chân thực. Đã chứng minh quy trình SCA phát hiện, chặn build, hỗ trợ remediation (đối với Log4j) và tiếp tục phát hiện rủi ro tồn đọng (residual risk) từ các dependency nền tảng.*

## 1. Giới thiệu đề tài
Đồ án này tập trung vào việc mô phỏng một quy trình tích hợp kiểm tra bảo mật tự động vào quy trình phát triển phần mềm (CI/CD). Cụ thể, hệ thống sẽ sử dụng công cụ phân tích thành phần phần mềm (SCA) để tự động phát hiện các thư viện mã nguồn mở có chứa lỗ hổng bảo mật đã biết (CVE), ngăn chặn việc phát hành ứng dụng chứa mã độc hoặc lỗ hổng nghiêm trọng.

## 2. Lý do chọn đề tài
Trong những năm gần đây, tấn công qua chuỗi cung ứng phần mềm (Supply Chain Attack) ngày càng phổ biến. Điển hình là lỗ hổng Log4Shell (CVE-2021-44228) đã gây chấn động toàn cầu. Hầu hết các nhà phát triển chú trọng vào việc viết code an toàn (chống SQL Injection, XSS) nhưng lại bỏ quên việc kiểm tra các thư viện bên thứ ba mà họ import vào. Đề tài này giải quyết khoảng trống đó, mang tính thực tiễn cực kỳ cao cho các doanh nghiệp hiện đại.

## 3. DevSecOps là gì?
DevSecOps (Development, Security, and Operations) là phương pháp tiếp cận văn hóa, tự động hóa và thiết kế nền tảng tích hợp bảo mật như một trách nhiệm chung trong toàn bộ chu kỳ sống của IT. Thay vì kiểm tra bảo mật ở giai đoạn cuối cùng trước khi phát hành, DevSecOps tích hợp các công cụ kiểm tra bảo mật vào từng bước của pipeline CI/CD (Shift-Left Security), giúp phát hiện và khắc phục lỗ hổng sớm hơn, ít tốn kém hơn.

## 4. SCA là gì?
SCA (Software Composition Analysis) là một quy trình tự động hóa để xác định phần mềm nguồn mở trong cơ sở mã. Mục đích của quy trình này là đánh giá bảo mật, tuân thủ giấy phép và chất lượng mã. Quá trình kiểm tra này cung cấp khả năng hiển thị về các thành phần phần mềm mã nguồn mở, khả năng xác định điểm yếu hoặc lỗ hổng tiềm ẩn (CVE), từ đó đưa ra cảnh báo cho các nhà phát triển.

## 5. Công cụ sử dụng
- **Ngôn ngữ lập trình**: Java 17
- **Framework**: Spring Boot 3.3.x
- **Build tool**: Apache Maven 3.9+
- **SCA Scanner**: OWASP Dependency-Check Maven Plugin
- **CI/CD Pipeline**: Jenkins (Local on Windows)
- **Scripting**: PowerShell

## 6. Kiến trúc lab
- Ứng dụng Backend đơn giản với vài REST API.
- Tích hợp cố tình thư viện Log4j bản cũ (2.14.1) chứa lỗ hổng Log4Shell để mô phỏng.
- Có 2 profile trong Maven:
  - `vulnerable`: Chạy với Log4j 2.14.1 để kiểm tra phát hiện lỗi.
  - `fixed`: Chạy với Log4j 2.24.3 (bản đã vá) để kiểm chứng việc khắc phục.
- Scripts tự động hỗ trợ chạy build, scan và sinh báo cáo HTML trực quan.

## 7. Yêu cầu môi trường Windows
- Hệ điều hành: Windows 10 hoặc 11.
- RAM: Tối thiểu 8GB (khuyến nghị 16GB nếu chạy cùng Jenkins).
- Ổ cứng: Ít nhất 5GB trống.
- Mạng: Cần kết nối Internet ổn định để Maven tải thư viện và OWASP quét tải CSDL lỗ hổng NVD.

## 8. Cài đặt Java 17
1. Truy cập trang chủ Adoptium hoặc Oracle để tải JDK 17 cho Windows.
2. Cài đặt và đảm bảo tích chọn "Add to PATH".
3. Mở PowerShell, kiểm tra bằng lệnh:
   ```powershell
   java -version
   ```

## 9. Cài đặt Maven
1. Tải bản ZIP Apache Maven từ trang chủ.
2. Giải nén vào thư mục `C:\maven`.
3. Thêm `C:\maven\bin` vào biến môi trường `Path` của Windows.
4. Mở PowerShell, kiểm tra bằng lệnh:
   ```powershell
   mvn -version
   ```

## 10. Cài đặt Jenkins local trên Windows (Tùy chọn cho CI/CD Demo)
1. Tải gói cài đặt Windows (`.msi`) từ trang chủ Jenkins.
2. Cài đặt bình thường, chạy Jenkins trên cổng 8081 (nếu 8080 trùng với app Spring Boot).
3. Sau khi cài đặt, tải plugin "Pipeline".
4. Khởi tạo một Pipeline Job và trỏ tới file `Jenkinsfile` có sẵn trong source code.

## 11. Cách chạy app
Bạn có thể chạy thử ứng dụng Spring Boot bằng script có sẵn:
```powershell
.\scripts\run-app.ps1
```
Sau đó mở trình duyệt truy cập: `http://localhost:8080/api/lab/info`

## 12. Cách scan bản vulnerable
Dùng để mô phỏng giai đoạn ứng dụng chứa thư viện nguy hiểm:
```powershell
.\scripts\scan-vulnerable.ps1
```
*Lưu ý: Lần chạy đầu tiên sẽ rất lâu (từ 20-60p) vì tool cần tải NVD database. Đọc ngay file `docs/nvd-api-key-setup.md` để lấy API Key tăng tốc tiến trình này!*
- Quá trình build sẽ báo **FAIL** (đây là hành vi chuẩn xác vì cấu hình DevSecOps sẽ chặn các build có lỗi nguy hiểm - CVSS >= 7).

## 13. Cách scan bản fixed
Dùng để mô phỏng giai đoạn lập trình viên đã sửa lỗi thành công thư viện Log4j:
```powershell
.\scripts\scan-fixed.ps1
```
*Lưu ý: Quá trình quét bản fixed sẽ cho thấy lỗ hổng Log4Shell đã được xử lý (Report giảm từ 971KB xuống 724KB). Tuy nhiên, lệnh build có thể **vẫn báo FAIL**. Đây là minh chứng xuất sắc cho hệ thống SCA: nó tiếp tục phát hiện các rủi ro tồn đọng (Residual Risk) từ các thư viện nền (như Spring Boot, Tomcat) và yêu cầu chúng ta tiếp tục quy trình vá lỗi. Đây không phải là "demo thất bại", mà là minh chứng cho sự rà soát liên tục của DevSecOps.*

## 14. Cách đọc report Dependency-Check
- Mở thư mục `reports/before-fix/` hoặc `reports/after-fix/`.
- Mở file `dependency-check-report.html` trên trình duyệt Chrome/Edge.
- Dò tìm thư viện `log4j-core` trong danh sách.
- Đọc chỉ số **CVSS** (Điểm rủi ro, ví dụ 10.0 là cao nhất) và tên lỗ hổng (Ví dụ: `CVE-2021-44228`).
- Báo cáo cũng sẽ kèm theo mô tả về lỗi và cách phòng tránh.

## 15. Cách demo trước giảng viên
Bạn nên tham khảo kỹ file `docs/demo-script.md` (kịch bản trình bày). Các bước tóm tắt:
1. Chạy app, giới thiệu các API.
2. Mở file `pom.xml`, chỉ ra phiên bản thư viện lỗi.
3. Chạy `scan-vulnerable.ps1`, giải thích vì sao bị lỗi FAIL.
4. Mở file report trước fix để xem mã lỗi CVE.
5. Chạy `scan-fixed.ps1` để vá lỗi.
6. Mở file report sau fix để chứng minh lỗ hổng đã biến mất và pipeline thành công.

## 16. Kết quả mong đợi
- Thấy được báo cáo cảnh báo đỏ (Vulnerable).
- Cơ chế chặn (Fail Build) hoạt động đúng lúc.
- Báo cáo sạch sẽ, ít lỗi hơn sau khi Fixed.
- (Xem thêm `docs/expected-results.md` để hiểu chi tiết).

## 17. Lỗi thường gặp và cách sửa
Đã được tổng hợp đầy đủ tại: `docs/troubleshooting.md`. Các lỗi kinh điển:
- Không nhận lệnh `mvn` -> Cài lại biến Path.
- Quét báo fail -> Đó là tính năng, không phải lỗi.
- Quét bị đứng lâu -> Chờ NVD Database tải xong.

## 18. Hạn chế đề tài
- Quá trình quét bằng OWASP Dependency Check dựa vào cơ sở dữ liệu NVD nên việc cập nhật (download) lần đầu rất tốn thời gian.
- OWASP Dependency Check chủ yếu đối chiếu dựa trên tên file và metadata, đôi khi gây ra cảnh báo giả (False Positives).
- Project này chỉ mô phỏng SCA trong DevSecOps, chưa tích hợp SAST (Quét mã nguồn tự viết) hay DAST (Quét lỗ hổng động).

## 19. Hướng phát triển
- Tích hợp thêm SonarQube để quét SAST song song với SCA.
- Thử nghiệm các công cụ SCA thương mại hiện đại hơn như Snyk, Mend (WhiteSource).
- Cấu hình Jenkins chạy trên nền tảng Docker container để môi trường sạch sẽ hơn.
- Triển khai tự động Gửi cảnh báo về Slack/Telegram khi phát hiện lỗ hổng nghiêm trọng.

## 20. Tài liệu tham khảo
- Cổng thông tin lỗ hổng NVD (NIST): https://nvd.nist.gov/
- Trang chủ dự án OWASP Dependency-Check: https://jeremylong.github.io/DependencyCheck/
- Giới thiệu DevSecOps (Red Hat): https://www.redhat.com/en/topics/devops/what-is-devsecops
- Lỗ hổng Log4Shell: https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-44228

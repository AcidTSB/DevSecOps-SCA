# Hướng dẫn Đóng gói Nộp bài (Submission Notes)

Tài liệu này hướng dẫn những công việc cuối cùng bạn cần làm để nén dự án và nộp bài báo cáo thành công.

## 1. Các File/Thư mục cần nén (Zip)
Khi nộp mã nguồn cho giảng viên, hãy **XÓA** thư mục `target/` để giảm dung lượng file ZIP (từ vài trăm MB xuống chỉ còn vài MB). 

**Chỉ nén các thành phần sau:**
- Thư mục `src/` (Mã nguồn Java)
- Thư mục `scripts/` (Các script chạy)
- Thư mục `docs/` (Tài liệu hướng dẫn)
- Thư mục `reports/` (Chứa 2 report before/after HTML làm bằng chứng)
- File `pom.xml`, `Jenkinsfile` (và các file Jenkinsfile.xxx)
- Các file tài liệu ở thư mục gốc: `README.md`, `QUICK_START.md`, `PROGRESS.md`, `FINAL_CHECKLIST.md`.

## 2. Ảnh cần chụp (Screenshot) đưa vào Báo cáo/Slide
Để báo cáo/slide trực quan và thuyết phục, bạn bắt buộc phải có các bức ảnh sau do chính bạn chụp trên máy của mình:
1. **Ảnh 1:** Chụp cửa sổ trình duyệt (hoặc Postman) gọi API `http://localhost:8080/api/lab/info` trả về trạng thái UP. (Chứng minh app chạy tốt).
2. **Ảnh 2:** Chụp terminal PowerShell thông báo chữ đỏ: `KET QUA: Build FAIL - Day la DUNG y dinh!` sau khi chạy bản Vulnerable.
3. **Ảnh 3:** Mở `reports/before-fix/dependency-check-report.html` trên trình duyệt, cuộn đến phần hiển thị thư viện `log4j-core-2.14.1.jar` bị gạch đỏ với CVE-2021-44228 CRITICAL.
4. **Ảnh 4:** Chụp đoạn code trong file `pom.xml` chỗ profile `fixed` cho thấy bạn đã đổi version Log4j thành `2.24.3`.
5. **Ảnh 5:** Mở `reports/after-fix/dependency-check-report.html`, chụp phần Summary hiển thị tổng số Vulnerabilities đã giảm đi và Log4Shell biến mất.
6. **Ảnh 6:** Chụp màn hình Build FAIL sau khi chạy bản Fixed (để lấy cớ giải thích về Residual Risk).

## 3. Cách phản biện khi Giảng viên thắc mắc "Tại sao sửa rồi mà vẫn báo Fail?"
Giảng viên có thể hỏi: *"Em bảo em sửa lỗi Log4j xong rồi, quét lại mà máy vẫn báo Fail, vậy là demo của em hỏng à?"*

**Bạn cần bình tĩnh và dõng dạc trả lời:**
> "Thưa thầy/cô, đây không phải là lỗi demo mà chính là điểm mạnh tuyệt đối của quy trình DevSecOps và công cụ SCA. 
> Mục tiêu chính của em trong kịch bản này là khắc phục lỗ hổng cực kỳ nghiêm trọng Log4Shell (CVSS 10.0), và em đã làm được điều đó (chỉ vào báo cáo After-fix dung lượng giảm từ 971KB xuống 724KB).
> Tuy nhiên, vì SCA quét cực kỳ sâu vào toàn bộ chuỗi cung ứng phần mềm (Supply Chain), nên nó phát hiện ra hệ thống nền tảng Spring Boot và Tomcat của em vẫn còn một số rủi ro tồn đọng (Residual Vulnerability). 
> Thay vì lừa dối hệ thống bằng cách cấu hình bỏ qua lỗi, em giữ nguyên lệnh Build Fail để chứng minh rằng DevSecOps là một quá trình rà soát liên tục. Công việc của đội ngũ Dev ở Sprint tiếp theo chính là tiếp tục nâng cấp phiên bản Spring Boot để giải quyết dứt điểm các lỗi nền tảng này."

## 4. Chúc bạn bảo vệ thành công!
Đồ án này không chỉ có code, mà triết lý bảo mật và sự hiểu biết về cách vận hành DevSecOps (như câu trả lời trên) mới là thứ giúp bạn đạt điểm tuyệt đối. Chúc may mắn!

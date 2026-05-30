Bạn là một AI Coding Agent senior, có nhiệm vụ hoàn thiện toàn bộ project đồ án an ninh mạng theo đề tài:

“Xây dựng giải pháp quét mã nguồn mở Software Composition Analysis trong quy trình DevSecOps cho ứng dụng Java Spring Boot”

Bối cảnh:
- Tôi là sinh viên làm đồ án môn An ninh mạng.
- Tôi chỉ dùng Windows 10/11.
- Không dùng Linux bắt buộc.
- Không dùng cloud trả phí.
- Không dùng AWS/Azure/GCP.
- Không yêu cầu máy quá mạnh.
- Project cần chạy local được.
- Mục tiêu là có demo chuyên nghiệp hơn đề tài OWASP SQL Injection/XSS.
- Project cần phù hợp để bảo vệ trước giảng viên và có thể đưa vào portfolio backend/security/devsecops.

Project hiện tại:
- Tôi đã có sẵn bộ code tên `devsecops-sca-demo`.
- Hãy đọc toàn bộ source code, README, Jenkinsfile, scripts, docs trước khi sửa.
- Không được xóa bừa các file hiện có.
- Mọi thay đổi phải có lý do rõ ràng.
- Ưu tiên hoàn thiện thành một project có thể chạy, quét, fix dependency, tạo report và trình bày demo.

Mục tiêu cuối cùng:
Hoàn thiện project thành một lab DevSecOps + SCA hoàn chỉnh gồm:

1. Ứng dụng Java Spring Boot demo.
2. Dependency cố tình có lỗ hổng để OWASP Dependency-Check phát hiện.
3. Cấu hình Maven để chạy SCA scan.
4. Cấu hình profile hoặc cơ chế riêng để so sánh:
   - bản vulnerable
   - bản fixed
5. Script PowerShell chạy được trên Windows.
6. Jenkinsfile chạy được trên Jenkins local Windows.
7. Sinh được báo cáo HTML từ OWASP Dependency-Check.
8. Có README tiếng Việt hướng dẫn chạy từng bước.
9. Có tài liệu demo bảo vệ.
10. Có câu hỏi bảo vệ và câu trả lời.
11. Có checklist kiểm thử.
12. Có changelog các thay đổi đã làm.

Ràng buộc kỹ thuật:
- Chỉ dùng công cụ miễn phí.
- Không yêu cầu Docker bắt buộc.
- Không yêu cầu Linux.
- Không dùng lệnh bash/sh trong hướng dẫn chính.
- Scripts chính phải là PowerShell `.ps1`.
- Jenkinsfile phải dùng `bat` thay vì `sh`.
- Project phải phù hợp Windows path.
- Không đưa secret, token, API key thật vào source code.
- Không sử dụng mẫu mã độc hoặc khai thác nguy hiểm.
- Không biến đề tài thành malware/ransomware/phishing.
- Trọng tâm là phòng thủ, phát hiện lỗ hổng dependency và DevSecOps pipeline.

Công nghệ mong muốn:
- Java 17
- Spring Boot
- Maven
- OWASP Dependency-Check Maven Plugin
- Jenkins local trên Windows
- PowerShell scripts
- HTML security report

Nhiệm vụ 1: Rà soát cấu trúc project
Hãy kiểm tra toàn bộ cây thư mục hiện tại và đánh giá:
- File nào đã ổn.
- File nào thiếu.
- File nào sai.
- File nào cần sửa để project chạy tốt trên Windows.
- File nào cần bổ sung để phục vụ báo cáo/demo.

Sau đó trình bày ngắn gọn kế hoạch sửa trước khi bắt đầu chỉnh code.

Nhiệm vụ 2: Hoàn thiện ứng dụng Spring Boot
Ứng dụng demo không cần quá phức tạp, nhưng phải đủ chuyên nghiệp.

Yêu cầu:
- Có package rõ ràng.
- Có class main Spring Boot.
- Có ít nhất 2-3 endpoint REST để chứng minh đây là backend app thật.
- Có endpoint health/info đơn giản.
- Có endpoint mô phỏng dependency usage, ví dụ ghi log bằng Log4j hoặc trả thông tin version lab.
- Code sạch, dễ đọc, có comment vừa phải.
- Không cần database.
- Không cần frontend.
- Không cần login.

Gợi ý endpoint:
- GET `/api/health`
- GET `/api/lab/info`
- GET `/api/lab/dependencies`
- GET `/api/lab/risk-summary`

Response nên trả JSON đẹp, ví dụ:
{
  "project": "DevSecOps SCA Demo",
  "purpose": "Detect vulnerable open-source dependencies",
  "scaTool": "OWASP Dependency-Check",
  "environment": "Windows Local Lab"
}

Nhiệm vụ 3: Hoàn thiện Maven `pom.xml`
Kiểm tra và sửa `pom.xml` sao cho:
- Build được bằng Maven.
- Dùng Java 17.
- Có Spring Boot dependencies hợp lý.
- Có dependency cố tình vulnerable để demo SCA.
- Có cách chuyển sang bản fixed.

Ưu tiên thiết kế theo profile Maven:

Profile mặc định hoặc `vulnerable`:
- Dùng dependency có CVE nổi tiếng, ví dụ Log4j version cũ như `2.14.1`.
- Mục tiêu là Dependency-Check phát hiện lỗ hổng nghiêm trọng.

Profile `fixed`:
- Dùng version đã nâng cấp như `2.17.2` hoặc version an toàn hơn.
- Mục tiêu là quét lại để số lượng lỗ hổng giảm rõ ràng.

Lưu ý:
- Không cần ứng dụng thật sự khai thác Log4j.
- Chỉ cần dependency tồn tại trong dependency tree để SCA phát hiện.
- Đảm bảo không làm app crash vì conflict dependency.
- Giữ dependency càng đơn giản càng tốt.

Cấu hình OWASP Dependency-Check Maven Plugin:
- Sinh report HTML.
- Có thể sinh thêm JSON nếu hữu ích.
- Output report vào thư mục dễ tìm, ví dụ:
  - `target/dependency-check-report.html`
  - hoặc `reports/dependency-check/...`
- Cấu hình `failBuildOnCVSS` để demo build fail khi có CVE nghiêm trọng.
- Tuy nhiên phải có cách chạy scan không fail để vẫn sinh report phục vụ chụp hình.
- Có thể tạo 2 mode:
  - scan report only
  - scan strict fail build

Ví dụ mục tiêu:
- `mvn clean package -DskipTests`
- `mvn org.owasp:dependency-check-maven:check`
- `mvn org.owasp:dependency-check-maven:check -DfailBuildOnCVSS=7`
- `mvn clean verify -Pfixed`

Nhiệm vụ 4: Hoàn thiện scripts PowerShell
Trong thư mục `scripts/`, hãy tạo hoặc sửa các file sau:

1. `run-app.ps1`
Mục tiêu:
- Build app.
- Chạy Spring Boot app local.
- In ra URL các endpoint cần test.
- Dùng lệnh phù hợp Windows.

2. `scan-vulnerable.ps1`
Mục tiêu:
- Chạy scan với dependency vulnerable.
- Sinh report HTML.
- Copy report sang thư mục:
  `reports/before-fix/`
- In rõ đường dẫn report sau khi chạy xong.
- Không để script chết quá sớm nếu Dependency-Check trả non-zero exit code vì phát hiện CVE.
- Cần giải thích trong console rằng build fail vì CVSS threshold là hành vi mong muốn trong DevSecOps.

3. `scan-fixed.ps1`
Mục tiêu:
- Chạy scan với profile fixed.
- Sinh report HTML.
- Copy report sang thư mục:
  `reports/after-fix/`
- In rõ đường dẫn report.
- So sánh sơ bộ trước/sau nếu có thể.

4. `clean-reports.ps1`
Mục tiêu:
- Xóa thư mục target và reports đã sinh.
- Không xóa source code.
- Có thông báo rõ ràng.

5. Có thể bổ sung `demo-all.ps1`
Mục tiêu:
- Chạy lần lượt:
  - clean
  - scan vulnerable
  - scan fixed
- Cuối cùng in ra các file report cần mở.

Yêu cầu với PowerShell:
- Có comment.
- Có kiểm tra lỗi cơ bản.
- Có thông báo dễ hiểu bằng tiếng Việt hoặc tiếng Anh.
- Không dùng lệnh Linux.
- Không yêu cầu quyền admin.

Nhiệm vụ 5: Hoàn thiện Jenkinsfile
Tạo hoặc sửa `Jenkinsfile` để chạy tốt trên Jenkins local Windows.

Pipeline nên có các stage:

1. Checkout
2. Show Environment
3. Build
4. SCA Scan - Vulnerable
5. Archive Vulnerability Report
6. SCA Scan - Fixed
7. Archive Fixed Report
8. Summary

Yêu cầu:
- Dùng `bat`, không dùng `sh`.
- Không hard-code đường dẫn máy cá nhân.
- Có archive artifact:
  - `target/dependency-check-report.html`
  - `reports/**`
- Có thông điệp rõ ràng khi build fail vì CVE.
- Có thể dùng `catchError` để pipeline vẫn tiếp tục archive report kể cả khi scan phát hiện CVE.
- Tạo thêm `Jenkinsfile.vulnerable-only` và `Jenkinsfile.fixed-only` nếu thấy cần cho demo nhanh.

Mục tiêu khi bảo vệ:
- Cho giảng viên thấy pipeline tự động build và scan.
- Nếu có CVE Critical/High thì pipeline đánh dấu failed hoặc unstable.
- Sau khi fix dependency thì pipeline pass hoặc giảm risk.

Nhiệm vụ 6: Hoàn thiện tài liệu README tiếng Việt
README.md cần viết lại cho rõ ràng, sinh viên có thể làm theo.

README phải có các phần:

1. Giới thiệu đề tài
2. Lý do chọn đề tài
3. DevSecOps là gì?
4. SCA là gì?
5. Công cụ sử dụng
6. Kiến trúc lab
7. Yêu cầu môi trường Windows
8. Cài đặt Java 17
9. Cài đặt Maven
10. Cài đặt Jenkins local trên Windows
11. Cách chạy app
12. Cách scan bản vulnerable
13. Cách scan bản fixed
14. Cách đọc report Dependency-Check
15. Cách demo trước giảng viên
16. Kết quả mong đợi
17. Lỗi thường gặp và cách sửa
18. Hạn chế đề tài
19. Hướng phát triển
20. Tài liệu tham khảo

README cần dùng văn phong sinh viên, rõ ràng, không quá học thuật khô cứng.

Nhiệm vụ 7: Hoàn thiện tài liệu demo
Trong thư mục `docs/`, hãy tạo hoặc cập nhật:

1. `demo-script.md`
Nội dung:
- Kịch bản nói khi demo.
- Demo từng bước.
- Lệnh cần chạy.
- Màn hình cần chụp.
- Giải thích ý nghĩa từng kết quả.

Kịch bản demo mong muốn:

Bước 1:
Giới thiệu ứng dụng Spring Boot demo.

Bước 2:
Mở `pom.xml`, chỉ ra dependency vulnerable.

Bước 3:
Chạy:
`.\scripts\scan-vulnerable.ps1`

Bước 4:
Mở report HTML.
Chỉ ra:
- Vulnerable dependency
- CVE ID
- CVSS score
- Severity
- Recommendation

Bước 5:
Chạy:
`.\scripts\scan-fixed.ps1`

Bước 6:
Mở report after-fix.
So sánh trước/sau.

Bước 7:
Mở Jenkins pipeline.
Giải thích DevSecOps:
- Security scan được đưa vào pipeline.
- Build có thể fail nếu CVSS vượt ngưỡng.
- Đây là cách phát hiện sớm lỗ hổng trước khi deploy.

2. `bao-cao-outline.md`
Tạo outline báo cáo đồ án đầy đủ:

Chương 1: Tổng quan
- Lý do chọn đề tài
- Vấn đề an toàn chuỗi cung ứng phần mềm
- Mục tiêu
- Phạm vi

Chương 2: Cơ sở lý thuyết
- DevSecOps
- SCA
- CVE
- CVSS
- Dependency vulnerability
- OWASP Dependency-Check
- CI/CD security gate

Chương 3: Mô hình triển khai
- Môi trường Windows
- Kiến trúc lab
- Pipeline
- Công cụ

Chương 4: Thực nghiệm
- Tạo app demo
- Thêm dependency vulnerable
- Quét lần 1
- Phân tích report
- Nâng cấp dependency
- Quét lần 2
- So sánh kết quả

Chương 5: Đánh giá và kết luận
- Kết quả đạt được
- Ưu điểm
- Hạn chế
- Hướng phát triển

3. `slide-outline.md`
Tạo outline slide 25-40 slide.
Mỗi slide có:
- Tiêu đề
- Nội dung bullet ngắn
- Gợi ý hình ảnh cần chèn

4. `cau-hoi-bao-ve.md`
Tạo ít nhất 30 câu hỏi bảo vệ kèm câu trả lời.
Câu hỏi nên bao gồm:
- DevSecOps là gì?
- SCA là gì?
- SCA khác SAST/DAST thế nào?
- CVE là gì?
- CVSS là gì?
- Tại sao dependency cũ nguy hiểm?
- Vì sao dùng OWASP Dependency-Check?
- Vì sao build nên fail khi CVSS >= 7?
- False positive là gì?
- Hạn chế của Dependency-Check?
- Vì sao đề tài không phải khai thác Log4j?
- Nếu không có internet thì scan có chạy được không?
- Tại sao làm local Windows vẫn hợp lệ?
- Doanh nghiệp áp dụng mô hình này thế nào?
- Điểm khác biệt so với OWASP SQL Injection/XSS?

5. `test-checklist.md`
Checklist kiểm thử:
- Java version
- Maven version
- App build pass
- Endpoint chạy được
- Scan vulnerable sinh report
- Scan fixed sinh report
- Jenkins chạy được
- Report được archive
- README đủ hướng dẫn
- Demo script đủ rõ

6. `CHANGELOG.md`
Ghi lại toàn bộ thay đổi đã thực hiện.

Nhiệm vụ 8: Mermaid diagram
Tạo file `docs/mo-hinh-pipeline.mmd` hoặc cập nhật nếu đã có.

Diagram nên mô tả:

Developer
↓
Git Repository
↓
Jenkins Pipeline
↓
Maven Build
↓
OWASP Dependency-Check
↓
Vulnerability Report
↓
Security Gate
↓
Pass/Fail
↓
Fix Dependency
↓
Re-scan

Dùng Mermaid syntax hợp lệ.

Nhiệm vụ 9: Tạo dữ liệu kết quả mẫu
Vì máy người chấm có thể khác máy sinh viên, hãy tạo file tài liệu mô tả kết quả mong đợi:

`docs/expected-results.md`

Nội dung:
- Khi scan vulnerable, report có thể phát hiện nhiều CVE.
- Số lượng CVE có thể thay đổi theo thời gian vì database NVD cập nhật.
- Điểm chính cần chứng minh là dependency vulnerable bị phát hiện.
- Khi nâng version, số lượng lỗ hổng phải giảm hoặc không còn CVE nghiêm trọng liên quan dependency đó.
- Build fail do CVSS threshold là hành vi đúng, không phải lỗi project.

Nhiệm vụ 10: Tạo hướng dẫn xử lý lỗi thường gặp
Tạo file `docs/troubleshooting.md`.

Bao gồm lỗi:
1. `mvn` không nhận diện
2. `JAVA_HOME` sai
3. Jenkins không tìm thấy Maven
4. Dependency-Check tải NVD rất lâu
5. Scan fail vì CVE
6. Không thấy report HTML
7. PowerShell bị chặn ExecutionPolicy
8. Port 8080 bị chiếm
9. Jenkins workspace path có dấu cách
10. Internet yếu làm Dependency-Check lỗi tải database

Với mỗi lỗi:
- Triệu chứng
- Nguyên nhân
- Cách sửa trên Windows

Nhiệm vụ 11: Đảm bảo project dễ chấm
Tạo file `QUICK_START.md` ở root.

Nội dung cực ngắn:

1. Cài Java 17
2. Cài Maven
3. Mở PowerShell tại thư mục project
4. Chạy:
   `mvn clean package -DskipTests`
5. Chạy:
   `.\scripts\scan-vulnerable.ps1`
6. Mở:
   `reports/before-fix/dependency-check-report.html`
7. Chạy:
   `.\scripts\scan-fixed.ps1`
8. Mở:
   `reports/after-fix/dependency-check-report.html`

Nhiệm vụ 12: Kiểm tra thực tế
Sau khi sửa xong, hãy chạy các lệnh sau nếu môi trường có Java/Maven:

- `java -version`
- `mvn -version`
- `mvn clean package -DskipTests`
- `.\scripts\scan-vulnerable.ps1`
- `.\scripts\scan-fixed.ps1`

Nếu không thể chạy vì thiếu Java/Maven, hãy:
- Không bịa kết quả.
- Ghi rõ chưa chạy được do thiếu môi trường.
- Vẫn kiểm tra cú pháp file ở mức có thể.
- Ghi hướng dẫn để tôi chạy trên máy Windows.

Nhiệm vụ 13: Quy tắc chỉnh sửa
Khi chỉnh sửa:
- Không đổi mục tiêu đề tài.
- Không thêm cloud.
- Không bắt buộc Docker.
- Không chuyển sang Linux.
- Không thêm công cụ nặng như ELK, Kubernetes, SonarQube nếu không cần.
- Không làm project quá phức tạp.
- Ưu tiên “chạy chắc, demo đẹp, giải thích dễ”.
- Giữ code sạch.
- Tài liệu phải rõ cho sinh viên bảo vệ.

Nhiệm vụ 14: Kết quả cuối cùng cần báo cáo lại cho tôi
Sau khi hoàn thành, hãy trả lời theo format:

1. Tổng quan đã làm
2. Danh sách file đã sửa/tạo
3. Cách chạy nhanh
4. Cách demo trước giảng viên
5. Những điểm ăn điểm của đề tài
6. Những lỗi/hạn chế còn lại nếu có
7. Checklist xác nhận

Yêu cầu chất lượng cuối:
- Project phải build được.
- Có báo cáo HTML SCA.
- Có trước/sau fix.
- Có Jenkinsfile Windows.
- Có script PowerShell.
- Có README tiếng Việt.
- Có docs hỗ trợ báo cáo và slide.
- Người chưa giỏi security vẫn đọc hiểu và demo được.
- Nhìn đủ chuyên nghiệp để bảo vệ đồ án.
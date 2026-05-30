# Danh sách Câu hỏi Bảo vệ Đồ án (Q&A)

Dưới đây là 30+ câu hỏi thường gặp khi bảo vệ đồ án DevSecOps chuyên đề SCA, được phân loại theo từng chủ đề.

## Chủ đề 1: Kiến thức cơ bản (DevSecOps & SCA)
**1. DevSecOps là gì? Khác gì so với DevOps truyền thống?**
- DevOps là quy trình tự động hóa giữa phát triển (Dev) và vận hành (Ops). DevSecOps chèn thêm bảo mật (Security) vào giữa, đảm bảo bảo mật được thực hiện sớm và liên tục thay vì chỉ kiểm tra ở khâu cuối cùng.

**2. Khái niệm "Shift-Left Security" nghĩa là gì?**
- Là việc đẩy các bài kiểm tra bảo mật sang bên "trái" của trục thời gian (nghĩa là thực hiện sớm hơn ngay từ lúc code và build) để giảm chi phí sửa lỗi.

**3. SCA là viết tắt của từ gì và nó làm công việc gì?**
- SCA: Software Composition Analysis (Phân tích thành phần phần mềm). Nó kiểm tra các thư viện/framework mã nguồn mở mà ứng dụng sử dụng xem có chứa lỗ hổng bảo mật đã biết nào không.

**4. Tại sao đồ án này không làm tìm lỗi SQL Injection hay XSS?**
- Vì SQLi hay XSS là lỗi do lập trình viên tự viết sai logic (cần dùng công cụ SAST/DAST). Đồ án này tập trung vào SCA, tức là tìm lỗi do "dùng ké" code của người khác (thư viện bên thứ ba).

**5. Ứng dụng chạy báo status UP (bình thường), tại sao Dependency-Check lại báo FAIL?**
- Vì ứng dụng không bị lỗi cú pháp hay crash (chạy vẫn được), nhưng nó sử dụng phiên bản Log4j cũ chứa mã độc. Dependency-Check đánh fail quá trình build (Security Gate) để chặn mã độc không được đẩy lên Production.

## Chủ đề 2: Các khái niệm CVE, CVSS và NVD
**6. CVE là gì?**
- CVE (Common Vulnerabilities and Exposures): Là một danh sách định danh chuẩn cho các lỗ hổng bảo mật đã được công khai. Mỗi lỗ hổng có 1 mã duy nhất (VD: CVE-2021-44228).

**7. CVSS là gì? Ý nghĩa của điểm số CVSS?**
- CVSS (Common Vulnerability Scoring System): Là hệ thống chấm điểm rủi ro của lỗ hổng từ 0.0 đến 10.0. Điểm càng cao, mức độ nguy hiểm và dễ bị khai thác càng lớn.

**8. Lỗ hổng Log4Shell (CVE-2021-44228) có mức điểm CVSS là bao nhiêu và vì sao nó nguy hiểm?**
- Điểm 10.0 (Critical). Nguy hiểm vì Log4j được dùng ở hầu hết ứng dụng Java, và hacker chỉ cần gửi 1 chuỗi ký tự qua input/header là có thể chiếm quyền điều khiển máy chủ (Remote Code Execution).

**9. NVD là gì? Ai quản lý NVD?**
- NVD (National Vulnerability Database) là Cơ sở dữ liệu lỗ hổng bảo mật quốc gia của chính phủ Mỹ, do viện NIST quản lý.

**10. Tại sao lần chạy Dependency-Check đầu tiên lại mất tới 20-60 phút?**
- Vì tool phải tải toàn bộ dữ liệu lịch sử lỗ hổng từ NVD (hàng trăm ngàn records) về máy tính cá nhân. Nếu không có NVD API Key, máy chủ Mỹ sẽ bóp băng thông (rate limit) khiến quá trình tải rất chậm.

**11. NVD API Key là gì? Cấu hình như thế nào để không bị lộ?**
- Là chìa khóa do NIST cấp để cho phép tải dữ liệu nhanh hơn. Không được ghi trực tiếp vào code (sẽ bị đưa lên GitHub), mà phải thiết lập qua biến môi trường (Environment Variable) trên máy Windows.

## Chủ đề 3: Phân tích OWASP Dependency-Check
**12. OWASP là tổ chức gì?**
- Open Worldwide Application Security Project: Tổ chức phi lợi nhuận toàn cầu chuyên về bảo mật ứng dụng web.

**13. Tool OWASP Dependency-Check hoạt động như thế nào?**
- Nó quét các file `.jar`, trích xuất thông tin (Evidence) như tên, phiên bản. Sau đó tạo ra chuỗi định danh CPE, và mang CPE đó đi so sánh với NVD Database để tìm ra CVE tương ứng.

**14. CPE là gì?**
- Common Platform Enumeration: Tiêu chuẩn định danh tên phần mềm/phần cứng để dễ dàng đối chiếu (VD: `cpe:2.3:a:apache:log4j:2.14.1:...`).

**15. False Positive (Cảnh báo giả) trong SCA là gì?**
- Là khi công cụ đoán sai tên thư viện, dẫn đến việc báo cáo một lỗ hổng không hề tồn tại trong dự án. (VD: Dự án dùng thư viện X, nhưng tool tưởng là thư viện Y có lỗi).

**16. Làm sao để xử lý False Positive trong Dependency-Check?**
- Dùng tính năng `Suppression`. Tạo file `dependency-check-suppressions.xml` để loại bỏ cụ thể các cảnh báo sai.

**17. Tham số `failBuildOnCVSS=7` trong pom.xml có ý nghĩa gì?**
- Là cổng an ninh (Security Gate). Bất cứ lỗ hổng nào có điểm CVSS từ 7.0 trở lên (Mức High/Critical) sẽ khiến quá trình đóng gói phần mềm bị đánh rớt (FAIL).

## Chủ đề 4: Tích hợp Jenkins & CI/CD
**18. CI/CD là gì?**
- Continuous Integration / Continuous Deployment: Tích hợp liên tục và triển khai liên tục, giúp tự động hóa quy trình test và build code mỗi khi lập trình viên đẩy code lên Git.

**19. Jenkinsfile trong đồ án đóng vai trò gì?**
- Là kịch bản Pipeline dưới dạng code (Pipeline-as-Code) hướng dẫn Jenkins thực hiện lần lượt các bước: Checkout, Build, Quét SCA, và Lưu trữ báo cáo.

**20. Nếu Security Gate báo FAIL, tại sao Jenkins không dừng luôn mà vẫn sinh được Report?**
- Vì trong Jenkinsfile sử dụng lệnh `catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE')`. Lệnh này giúp chặn lỗi không làm sập toàn bộ Pipeline, cho phép Pipeline đi tiếp để chạy bước `archiveArtifacts` lưu lại HTML Report.

**21. Lệnh `bat` trong Jenkinsfile có ý nghĩa gì?**
- Dùng để chạy các lệnh Command Prompt/PowerShell trên môi trường Jenkins chạy trên Windows (khác với lệnh `sh` dành cho Linux).

**22. Tham số `-DskipTests` dùng để làm gì? Có an toàn không?**
- Dùng để bỏ qua bước chạy Unit Test của Maven giúp demo nhanh hơn. Trong thực tế (Production), KHÔNG được phép dùng tham số này vì Unit Test rất quan trọng.

## Chủ đề 5: Khắc phục lỗi & Rủi ro tồn đọng (Residual Risk)
**23. Vì sao sau khi fix thư viện Log4j (quét bản Fixed), quá trình Build vẫn bị FAIL? Điều này có phải là demo thất bại không?**
- Hoàn toàn KHÔNG phải thất bại. Đây là minh chứng cho sự "khắt khe" và khả năng rà soát tuyệt vời của DevSecOps. Dù đã sửa xong Log4j, nhưng SCA quét rất sâu và phát hiện thêm các lỗi tiềm ẩn từ thư viện nền khác (như Spring Boot, Spring Framework, Tomcat).

**24. Residual Risk (Rủi ro tồn đọng) là gì?**
- Là những rủi ro bảo mật vẫn còn tồn tại trong hệ thống sau khi đã áp dụng các biện pháp khắc phục chính (VD: Đã vá Log4Shell nhưng vẫn còn CVE ở Tomcat). 

**25. Vì sao SCA cần phải được chạy liên tục trong luồng CI/CD (Pipeline)?**
- Vì các lỗ hổng mới (CVE mới) được công bố hàng ngày trên NVD. Một thư viện hôm nay an toàn, nhưng ngày mai có thể bị phát hiện lỗi. Quét liên tục giúp cập nhật trạng thái bảo mật theo thời gian thực.

**26. Vì sao không nên chỉ tập trung nhìn vào một dependency duy nhất (như Log4j)?**
- Vì phần mềm hiện đại là một chuỗi cung ứng phức tạp (Supply Chain). Lỗi có thể nằm ở bất kỳ mắt xích nào: Spring Boot, Tomcat, Jackson, v.v. Việc bỏ qua các dependency nền tảng sẽ tạo ra lỗ hổng chết người (như Residual Risk).

## Chủ đề 6: Hạn chế và Mở rộng
**27. Đồ án của bạn có điểm yếu / hạn chế gì?**
- Mới chỉ áp dụng SCA (quét thư viện). Code do lập trình viên tự viết ra nếu có lỗi SQL Injection thì hệ thống này không phát hiện được. 
- Quá trình tải NVD Database phụ thuộc lớn vào đường truyền mạng quốc tế.

**28. Làm thế nào để giải quyết vấn đề không phát hiện lỗi code tự viết?**
- Cần tích hợp thêm công cụ SAST (Static Application Security Testing) như SonarQube vào Jenkins Pipeline.

**29. Có công cụ SCA nào khác ngoài OWASP Dependency-Check không?**
- Có rất nhiều công cụ thương mại mạnh mẽ như: Snyk, Mend (WhiteSource), Black Duck, hoặc GitHub Dependabot.

**30. Nếu phát hiện lỗ hổng mà thư viện đó chưa có bản vá (Zero-day), bạn làm gì?**
- Nếu không nâng cấp được, phải giảm thiểu rủi ro (Mitigation) bằng cách cấu hình WAF (Tường lửa), tắt tính năng gây lỗi, hoặc chuyển sang dùng thư viện khác tương đương.

**31. Có phải fix toàn bộ CVE trong report không?**
- Thực tế là không thể. Chỉ ưu tiên fix các lỗi Critical/High (CVSS >= 7) và các lỗi có khả năng khai thác cao trên hệ thống. Các lỗi Low thường được ghi nhận và chấp nhận rủi ro.

## Chủ đề 7: Xử lý tình huống trực tiếp
**32. [Tình huống]: Giảng viên hỏi: "Em hãy chứng minh file Report này là thật chứ không phải tự viết HTML tạo ra?"**
- Mở file `pom.xml` đổi Log4j sang một phiên bản bất kỳ (VD: 2.15.0), chạy lệnh `.\scripts\scan-vulnerable.ps1` trực tiếp trước mặt giảng viên, đợi 1-2 phút (do đã tải DB xong) để xem nó tự sinh file HTML mới.

**33. [Tình huống]: Tại sao kích thước file báo cáo Before và After lại khác nhau (VD: 971KB và 724KB)?**
- File After-fix nhỏ hơn do Log4j đã được nâng cấp, các CVE khổng lồ liên quan đến nó (như Log4Shell) bị loại bỏ hoàn toàn khỏi báo cáo, làm số lượng text trong file HTML giảm đi rõ rệt.

**34. [Tình huống]: Tại sao em chọn môi trường Windows mà không dùng Docker/Linux cho chuẩn DevOps?**
- Vì mục tiêu cốt lõi của đồ án là chứng minh nguyên lý hoạt động của DevSecOps và SCA. Triển khai trên môi trường Windows Native giúp người xem dễ dàng quan sát luồng chạy trực tiếp của Maven/Java mà không bị che khuất bởi độ phức tạp của container hóa (Docker) hay dòng lệnh Linux phức tạp.

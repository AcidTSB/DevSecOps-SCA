# Đề cương Slide Bảo vệ Đồ án (25-30 Slides)

## Slide 1: Trang bìa
- **Tiêu đề**: Xây dựng giải pháp quét mã nguồn mở (SCA) trong quy trình DevSecOps
- **Bullet**: Tên sinh viên, MSSV, Giáo viên hướng dẫn.

## Slide 2: Đặt vấn đề
- **Tiêu đề**: Thực trạng bảo mật phần mềm hiện đại
- **Bullet**:
  - Hơn 80% phần mềm hiện đại được cấu thành từ các thư viện mã nguồn mở (Open Source).
  - Tấn công qua chuỗi cung ứng phần mềm (Supply Chain Attack) gia tăng mạnh.
- **Gợi ý hình ảnh**: Biểu đồ hình tròn cho thấy tỷ lệ code tự viết vs code thư viện.

## Slide 3: Lỗi bảo mật điển hình - Log4Shell
- **Tiêu đề**: Nỗi ám ảnh mang tên Log4Shell (CVE-2021-44228)
- **Bullet**:
  - Tồn tại trong thư viện ghi log cực kỳ phổ biến của Java (`log4j-core`).
  - Điểm CVSS 10.0 (Tối đa) - Cho phép chạy mã độc từ xa (RCE) vô cùng dễ dàng.
- **Gợi ý hình ảnh**: Logo Log4j rực lửa hoặc biểu tượng hacker.

## Slide 4: Giải pháp truyền thống vs DevSecOps
- **Tiêu đề**: Vì sao cần DevSecOps?
- **Bullet**:
  - Truyền thống: Quét lỗi ở khâu cuối cùng -> Tốn chi phí sửa, dễ lọt lưới.
  - DevSecOps: Shift-left security (Bảo mật dịch sang trái), quét lỗi ngay từ khâu viết code và build.
- **Gợi ý hình ảnh**: Sơ đồ so sánh Waterfall security vs Shift-Left DevSecOps.

## Slide 5: SCA là gì?
- **Tiêu đề**: Software Composition Analysis (SCA)
- **Bullet**:
  - Quá trình tự động kiểm kê các thư viện bên thứ ba đang sử dụng.
  - So sánh chúng với cơ sở dữ liệu lỗ hổng bảo mật toàn cầu.
- **Gợi ý hình ảnh**: Hình minh họa kính lúp soi vào gói package phần mềm.

## Slide 6: Mục tiêu đồ án
- **Tiêu đề**: Mục tiêu đồ án
- **Bullet**:
  - Xây dựng một ứng dụng Java thực tế sử dụng thư viện lỗi.
  - Cấu hình công cụ SCA để phát hiện tự động.
  - Thiết lập "Security Gate" để chặn các bản build có rủi ro cao.

## Slide 7: Công cụ sử dụng
- **Tiêu đề**: Tech Stack
- **Bullet**:
  - Backend: Java 17, Spring Boot, Maven.
  - Security Scanner: OWASP Dependency-Check.
  - CI/CD: Jenkins (Local Windows) / PowerShell Script.
- **Gợi ý hình ảnh**: Logo Java, Spring, Maven, OWASP, Jenkins.

## Slide 8: Kiến trúc Lab
- **Tiêu đề**: Luồng hoạt động (Workflow)
- **Bullet**:
  - Developer viết code -> Maven tải Dependency -> Dependency-Check quét -> So khớp NVD Database -> Ra quyết định Pass/Fail.
- **Gợi ý hình ảnh**: Sơ đồ quy trình pipeline từ code đến báo cáo.

## Slide 9: OWASP Dependency-Check hoạt động ra sao?
- **Tiêu đề**: Cơ chế quét của OWASP Dependency-Check
- **Bullet**:
  - Trích xuất thông tin Evidence từ file `.jar`.
  - Phân tích và tạo ra chuỗi CPE (Common Platform Enumeration).
  - So khớp CPE với kho NVD để tìm CVE.

## Slide 10: NVD Database và API Key
- **Tiêu đề**: Cơ sở dữ liệu NVD (National Vulnerability Database)
- **Bullet**:
  - Do chính phủ Mỹ (NIST) quản lý, chứa thông tin mọi CVE.
  - Yêu cầu NVD API Key để công cụ SCA có thể tải database nhanh chóng mà không bị chặn (rate-limit).
- **Gợi ý hình ảnh**: Logo NVD NIST.

## Slide 11: Security Gate là gì?
- **Tiêu đề**: Cổng an ninh (Security Gate)
- **Bullet**:
  - Là tiêu chuẩn để quyết định phần mềm có được đi tiếp không.
  - Trong đồ án này: `failBuildOnCVSS = 7` (Chặn ngay nếu có lỗi mức độ High hoặc Critical).

## Slide 12: Kịch bản Thực nghiệm
- **Tiêu đề**: Kịch bản thực nghiệm
- **Bullet**:
  - Bước 1: Quét bản Vulnerable chứa Log4j 2.14.1.
  - Bước 2: Xem Build Fail và phân tích báo cáo.
  - Bước 3: Đổi cấu hình sang bản Fixed (Log4j 2.24.3).
  - Bước 4: Quét lại và xác nhận Build Pass.

## Slide 13: Demo - Khởi chạy ứng dụng
- **Tiêu đề**: Khởi chạy ứng dụng Spring Boot
- **Bullet**:
  - Ứng dụng chạy tốt dù chứa thư viện nguy hiểm, chứng minh lỗ hổng không phải là lỗi crash phần mềm.
- **Gợi ý hình ảnh**: Ảnh chụp API trả về JSON trên localhost:8080.

## Slide 14: Demo - Quét bản Vulnerable
- **Tiêu đề**: Quét bản có chứa lỗ hổng
- **Bullet**:
  - Chạy `scan-vulnerable.ps1`.
- **Gợi ý hình ảnh**: Ảnh chụp cửa sổ PowerShell với lệnh quét đang chạy.

## Slide 15: Tại sao Build Fail?
- **Tiêu đề**: Security Gate kích hoạt (Build Fail)
- **Bullet**:
  - Build trả về mã lỗi (Exit Code 1).
  - Vì hệ thống phát hiện CVE có điểm CVSS 10.0 > 7.
- **Gợi ý hình ảnh**: Ảnh báo cáo chữ đỏ ghi KẾT QUẢ: BUILD FAIL.

## Slide 16: Báo cáo Before-Fix
- **Tiêu đề**: Đọc báo cáo HTML (Trước khi fix)
- **Bullet**:
  - Nhận diện chính xác thư viện `log4j-core-2.14.1.jar`.
  - Gắn nhãn CRITICAL cho CVE-2021-44228.
- **Gợi ý hình ảnh**: *[Chèn ảnh report before-fix tại đây]*

## Slide 17: Phân tích CVSS
- **Tiêu đề**: CVSS 10.0 nghĩa là gì?
- **Bullet**:
  - Tấn công qua mạng (Network), không cần xác thực (No Authentication), ảnh hưởng nghiêm trọng đến tính bảo mật, toàn vẹn và tính sẵn sàng của dữ liệu.

## Slide 18: Remediation (Khắc phục)
- **Tiêu đề**: Nâng cấp Dependency
- **Bullet**:
  - Lập trình viên vào file `pom.xml`, đổi version sang phiên bản an toàn hơn.
- **Gợi ý hình ảnh**: Ảnh chụp code trước/sau khi đổi version trong thẻ `<dependency>`.

## Slide 19: Demo - Quét bản Fixed
- **Tiêu đề**: Quét bản đã khắc phục (Fixed Log4j)
- **Bullet**:
  - Chạy `scan-fixed.ps1`.
- **Gợi ý hình ảnh**: Ảnh chụp cửa sổ PowerShell chạy quét fixed.

## Slide 20: Build vẫn Fail? Không phải lỗi!
- **Tiêu đề**: Tại sao Build vẫn Fail? (Residual Risk)
- **Bullet**:
  - Dù đã vá Log4j, hệ thống vẫn báo FAIL. Tại sao?
  - Vì SCA quét cực sâu và phát hiện thêm các lỗi tiềm ẩn từ thư viện nền: Spring Boot, Tomcat, v.v.
  - Khẳng định: Đây là điểm mạnh tuyệt đối của DevSecOps, nó không bao giờ ngừng rà soát chuỗi cung ứng phần mềm.
- **Gợi ý hình ảnh**: Ảnh thông báo KẾT QUẢ: BUILD FAIL (với Log4j an toàn).

## Slide 21: Báo cáo After-Fix
- **Tiêu đề**: Phân tích Báo cáo HTML (Sau khi fix)
- **Bullet**:
  - Dung lượng file giảm đáng kể (Ví dụ: Từ 971KB xuống 724KB).
  - Lỗ hổng siêu nghiêm trọng Log4Shell (CVE-2021-44228) đã BỊ LOẠI BỎ hoàn toàn.
  - Các CVE còn lại là rủi ro tồn đọng (Residual Risk) cần được lên kế hoạch vá trong Sprint tiếp theo.
- **Gợi ý hình ảnh**: *[Chèn ảnh report after-fix tại đây chứng minh không còn Log4Shell]*

## Slide 22: Tích hợp Jenkins CI/CD
- **Tiêu đề**: Chạy Pipeline với Jenkins
- **Bullet**:
  - Quy trình bằng tay được tự động hóa bằng Jenkins pipeline (`Jenkinsfile`).
- **Gợi ý hình ảnh**: Ảnh Jenkins UI.

## Slide 23: Xử lý Pipeline Unstable
- **Tiêu đề**: Quản lý Pipeline thông minh
- **Bullet**:
  - Dùng `catchError` để đánh dấu pipeline là Unstable (Vàng) thay vì Fail (Đỏ) hoàn toàn, giúp Jenkins vẫn lưu được HTML Report ở bước cuối.

## Slide 24: False Positive (Cảnh báo giả)
- **Tiêu đề**: Thách thức của SCA - False Positive
- **Bullet**:
  - Tool có thể nhầm lẫn tên thư viện.
  - Cách giải quyết: Dùng tính năng Suppression (Bỏ qua) trong Dependency-Check.

## Slide 25: Hạn chế của đồ án
- **Tiêu đề**: Hạn chế
- **Bullet**:
  - Chỉ tập trung vào SCA, chưa quét code tự viết (SAST).
  - Tốc độ tải NVD phụ thuộc mạnh vào mạng quốc tế.

## Slide 26: Hướng phát triển
- **Tiêu đề**: Hướng phát triển tiếp theo
- **Bullet**:
  - Kết hợp SonarQube.
  - Sử dụng giải pháp thương mại (Snyk, Mend).
  - Gửi thông báo tự động (Slack/Telegram) khi Build Fail.

## Slide 27: Kết luận
- **Tiêu đề**: Kết luận
- **Bullet**:
  - Áp dụng SCA vào DevSecOps không hề khó, nhưng lợi ích đem lại trong việc bảo vệ phần mềm là vô giá.
- **Gợi ý hình ảnh**: Icon "Security Shield".

## Slide 28: Hỏi & Đáp
- **Tiêu đề**: Q&A
- **Bullet**:
  - Xin chân thành cảm ơn Thầy/Cô đã lắng nghe.

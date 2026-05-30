# Hướng dẫn Xử lý lỗi thường gặp (Troubleshooting)

Tài liệu này hướng dẫn cách khắc phục các lỗi phổ biến khi chạy đồ án DevSecOps SCA trên Windows.

## 1. Lỗi `mvn` không nhận diện (mvn : The term 'mvn' is not recognized)
- **Triệu chứng**: Gõ lệnh `mvn -version` bị báo lỗi không tìm thấy lệnh.
- **Nguyên nhân**: Chưa cài Maven hoặc chưa thêm biến môi trường (Environment Variables) cho Maven.
- **Cách sửa trên Windows**:
  1. Tải Apache Maven (file ZIP) từ trang chủ, giải nén vào ổ C (VD: `C:\maven`).
  2. Mở Start Menu, gõ "Environment Variables" -> Chọn "Edit the system environment variables".
  3. Bấm nút "Environment Variables...".
  4. Tìm biến `Path` ở mục System variables, bấm Edit -> New.
  5. Thêm đường dẫn trỏ tới thư mục `bin` của Maven (VD: `C:\maven\bin`).
  6. Khởi động lại PowerShell và gõ lại `mvn -version` để kiểm tra.

## 2. Lỗi `JAVA_HOME` bị cấu hình sai
- **Triệu chứng**: Lỗi báo `The JAVA_HOME environment variable is not defined correctly`.
- **Nguyên nhân**: Biến môi trường JAVA_HOME chưa được tạo hoặc trỏ sai thư mục JDK.
- **Cách sửa trên Windows**:
  1. Cài đặt Java JDK (khuyên dùng Java 17 hoặc 21).
  2. Mở "Environment Variables".
  3. Bấm New ở System variables, tạo biến tên `JAVA_HOME`.
  4. Value là đường dẫn tới thư mục JDK (VD: `C:\Program Files\Java\jdk-17`). Đừng thêm `\bin` ở cuối.
  5. Khởi động lại PowerShell.

## 3. Jenkins không tìm thấy Maven
- **Triệu chứng**: Chạy Pipeline trên Jenkins bị fail ở stage build với lỗi `mvn is not recognized`.
- **Nguyên nhân**: Jenkins service (chạy dưới quyền Local System) không nhận được biến môi trường `Path` của tài khoản người dùng, hoặc chưa cấu hình Maven trong Jenkins.
- **Cách sửa trên Windows**:
  1. Mở Jenkins UI ở `http://localhost:8080`.
  2. Vào `Manage Jenkins` -> `Tools`.
  3. Ở mục Maven installations, bấm "Add Maven".
  4. Đặt tên là `maven` (hoặc `M3`), bỏ chọn "Install automatically", và điền đường dẫn MAVEN_HOME (VD: `C:\maven`).
  5. Trong `Jenkinsfile`, thay vì gọi `bat 'mvn clean'`, cần gọi qua tool (nếu cần), hoặc đảm bảo đường dẫn thư mục `bin` của Maven nằm trong biến PATH ở cấu hình System của Jenkins (`Manage Jenkins` -> `System` -> `Environment variables`).

## 4. Dependency-Check tải NVD database rất lâu hoặc bị lỗi mạng
- **Triệu chứng**: Giai đoạn tải NVD (Updating NVD database) chạy rất lâu (có thể lên tới 1 tiếng) hoặc báo lỗi "Connection Reset", "Timeout".
- **Nguyên nhân**: Database của NVD khá lớn. Không có API Key sẽ bị giới hạn tốc độ tải. Mạng internet của bạn chập chờn.
- **Cách sửa trên Windows**:
  - **Cách 1 (Khuyến nghị)**: Xem file `docs/nvd-api-key-setup.md` để đăng ký NVD API Key và thiết lập biến môi trường `NVD_API_KEY`.
  - **Cách 2**: Chạy lần đầu trên một mạng Internet cực kỳ ổn định, cắm cáp LAN nếu cần, và kiên nhẫn đợi từ 20-60 phút. Các lần sau sẽ rất nhanh vì nó chỉ tải bản update nhỏ.
## 5. Script PowerShell báo lỗi "Build fail" dù app không lỗi
- **Triệu chứng**: Lệnh `.\scripts\scan-vulnerable.ps1` chạy ra chữ vàng/đỏ ghi "KET QUA: Build FAIL".
- **Nguyên nhân**: ĐÂY LÀ TÍNH NĂNG, KHÔNG PHẢI LỖI. Công cụ phát hiện CVE có CVSS >= 7 (Log4Shell) nên đã chặn build lại.
- **Cách sửa trên Windows**: Đọc file `expected-results.md`. Để thấy chữ màu xanh (Pass), hãy chạy bản đã fix bằng lệnh `.\scripts\scan-fixed.ps1`.

## 6. Không thấy file report HTML
- **Triệu chứng**: Vào thư mục `reports/before-fix/` hoặc `reports/after-fix/` nhưng trống trơn.
- **Nguyên nhân**: Bạn chưa chạy scripts scan tương ứng, hoặc quá trình scan bị chết giữa chừng do lỗi mạng (không tải được NVD).
- **Cách sửa trên Windows**: 
  - Xem kỹ console PowerShell xem có lỗi mạng không. Nếu có lỗi mạng, chạy lại script.
  - Đảm bảo bạn chạy từ thư mục gốc của project (có chứa pom.xml).

## 7. PowerShell bị chặn thực thi (ExecutionPolicy)
- **Triệu chứng**: Báo lỗi `.ps1 cannot be loaded because running scripts is disabled on this system`.
- **Nguyên nhân**: Bảo mật Windows chặn chạy scripts.
- **Cách sửa trên Windows**:
  - Mở PowerShell dưới quyền Administrator.
  - Chạy lệnh: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` và chọn Y.
  - (Hoặc dùng lệnh bypass tạm thời như hiện tại project đang dùng: `powershell -ExecutionPolicy Bypass -File <tên file>`).

## 8. Port 8080 bị chiếm (Address already in use)
- **Triệu chứng**: Khởi chạy ứng dụng Spring Boot bị fail kèm thông báo lỗi liên quan tới `Port 8080 was already in use`.
- **Nguyên nhân**: Có một ứng dụng khác (hoặc chính ứng dụng này nhưng chưa tắt) hoặc Jenkins đang chạy trên port 8080.
- **Cách sửa trên Windows**:
  - Mở file `src/main/resources/application.properties`.
  - Sửa `server.port=8080` thành `server.port=8081` (hoặc cổng khác).
  - Hoặc nếu đang chạy Jenkins ở port 8080 thì nên đổi port của Spring Boot app hoặc ngược lại.

## 9. Jenkins workspace path có dấu cách
- **Triệu chứng**: Jenkins build bị fail với các lỗi lạ liên quan đến đường dẫn không tồn tại.
- **Nguyên nhân**: Thư mục cài đặt Jenkins hoặc thư mục chứa source code có chứa dấu cách (VD: `C:\My Projects\Demo`). Một số script bat/cmd xử lý dấu cách không tốt.
- **Cách sửa trên Windows**: Chuyển thư mục chứa code sang đường dẫn không có dấu cách (VD: `C:\Projects\devsecops-sca-demo\`).

## 10. Chữ có dấu bị lỗi hiển thị (Encoding) trong PowerShell
- **Triệu chứng**: Các file `.ps1` in ra những ký tự lạ (VD: `??`) trong PowerShell.
- **Nguyên nhân**: PowerShell có thể không xử lý tốt bảng mã UTF-8 có BOM hoặc các ký tự Unicode nếu cấu hình console không hỗ trợ.
- **Cách sửa trên Windows**: Scripts hiện đã được sửa thành chữ không dấu (ASCII). Không nên dùng ký tự tiếng Việt có dấu hoặc ký tự đặc biệt (như dấu gạch ngang dài em-dash) trong `Write-Host` của PowerShell.

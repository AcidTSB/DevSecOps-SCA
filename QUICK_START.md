# Hướng Dẫn Chạy Nhanh (QUICK START)

1. Cài đặt **Java 17** (hoặc mới hơn) và **Maven**.
2. *(Rất khuyến nghị)* Cấu hình NVD API Key để lần quét đầu tiên chạy nhanh (Xem `docs/nvd-api-key-setup.md`).
3. Mở **PowerShell** tại thư mục project và chạy lần lượt các lệnh sau:

```powershell
# 1. Kiểm tra môi trường
java -version
mvn -version

# 2. Dọn dẹp thư mục cũ
.\scripts\clean-reports.ps1

# 3. Chạy ứng dụng (Nhấn Ctrl+C để dừng)
.\scripts\run-app.ps1

# 4. Chạy quét bảo mật với bản lỗi (Vulnerable)
.\scripts\scan-vulnerable.ps1

# 5. Chạy quét bảo mật với bản đã vá (Fixed)
.\scripts\scan-fixed.ps1
```

> **Ghi chú quan trọng**: 
> 1. Lần đầu chạy quét NVD Database có thể rất lâu (20-60 phút nếu không có API Key). Đây là hành vi bình thường, vui lòng không tắt ngang tiến trình. Các lần sau sẽ diễn ra rất nhanh.
> 2. Quá trình quét bản Fixed sẽ làm giảm đáng kể rủi ro (đã vá Log4Shell), nhưng lệnh build vẫn có thể FAIL do phát hiện **Residual Vulnerabilities** từ các thư viện nền (như Spring Boot, Tomcat). Đây là điểm mạnh của SCA giúp phát hiện rủi ro chuỗi phụ thuộc một cách liên tục.

# Hướng dẫn xin và cấu hình NVD API Key cho OWASP Dependency-Check

## 1. Vì sao lần scan đầu tiên thường mất rất nhiều thời gian?
OWASP Dependency-Check hoạt động dựa trên việc đối chiếu thư viện của bạn với cơ sở dữ liệu lỗ hổng quốc gia của Mỹ (NVD - National Vulnerability Database). Trong lần chạy đầu tiên, công cụ này sẽ phải tải về toàn bộ dữ liệu lịch sử lỗ hổng (hàng trăm ngàn records). Nếu không có API Key, giới hạn tốc độ (rate limit) của API NVD sẽ khiến quá trình này kéo dài từ 20 đến hơn 60 phút, hoặc thậm chí gây lỗi timeout `Connection Reset`.

## 2. Lợi ích khi dùng NVD API Key
- Miễn phí 100%.
- Giúp quá trình tải NVD database nhanh hơn đáng kể.
- Tránh các lỗi timeout không mong muốn.

## 3. Cách xin NVD API Key
1. Truy cập trang web: [https://nvd.nist.gov/developers/request-an-api-key](https://nvd.nist.gov/developers/request-an-api-key).
2. Điền thông tin vào form (chỉ cần Email hợp lệ).
3. NIST sẽ gửi một email xác nhận kèm API Key (là một chuỗi ký tự dài).

## 4. Cấu hình NVD API Key an toàn trên Windows
**TUYỆT ĐỐI KHÔNG** copy trực tiếp API Key vào file `pom.xml` hoặc commit lên GitHub. Kẻ xấu có thể lấy cắp Key của bạn.
Cách tốt nhất là thiết lập biến môi trường (Environment Variable) trên Windows.

Mở **PowerShell (chạy dưới quyền Administrator nếu cần)** và gõ lệnh sau để lưu API Key vào tài khoản Windows của bạn vĩnh viễn:
```powershell
[Environment]::SetEnvironmentVariable("NVD_API_KEY", "YOUR_KEY_HERE", "User")
```
*(Thay `YOUR_KEY_HERE` bằng Key thực tế nhận được trong email).*

## 5. Kiểm tra thiết lập
Để Windows nhận biến môi trường mới, bạn **PHẢI** tắt terminal hiện tại và mở một cửa sổ PowerShell mới.

Gõ lệnh sau để kiểm tra:
```powershell
echo $env:NVD_API_KEY
```
Nếu chuỗi ký tự API Key in ra màn hình, bạn đã cấu hình thành công. Bây giờ bạn có thể chạy lại các script `scan-vulnerable.ps1` hoặc `scan-fixed.ps1`.
Cấu hình trong `pom.xml` của project này đã được thiết lập sẵn để tự động đọc biến `NVD_API_KEY`.

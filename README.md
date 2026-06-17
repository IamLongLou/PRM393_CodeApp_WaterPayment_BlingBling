# 💧 Water Billing Collection System - PRM393

Hệ thống quản lý và thu tiền nước hiện đại được phát triển bằng **Flutter**, hỗ trợ nhân viên ghi chỉ số nước tại hiện trường một cách nhanh chóng và chính xác.

---

## 🚀 Tính năng chính

### 1. Quản lý Khách hàng & Tra cứu
- **Danh sách thông minh:** Hiển thị danh sách hộ dân với trạng thái thanh toán và chỉ số nước gần nhất.
- **Tìm kiếm thời gian thực:** Tìm kiếm khách hàng theo tên hoặc địa chỉ ngay lập tức.
- **Lịch sử tiêu thụ:** Tra cứu chi tiết các hóa đơn cũ, chỉ số đầu/cuối và lượng nước tiêu thụ qua các tháng.

### 2. Ghi chỉ số & Thanh toán (AI Reference)
- **Ghi chỉ số nhanh:** Nhập chỉ số mới với cơ chế kiểm soát lỗi (Chỉ số mới phải ≥ Chỉ số cũ).
- **Tính toán tự động:** Hệ thống tự động tính toán lượng tiêu thụ, áp đơn giá (12.000đ/m³) và thuế VAT.
- **Biên lai QR Code:** Xuất hóa đơn ngay lập tức với mã QR duy nhất để khách hàng đối soát.
- **Chụp ảnh minh chứng:** Tích hợp camera chụp ảnh đồng hồ nước để lưu trữ bằng chứng (Đang giả lập cho bản Web).

### 3. Thống kê & Đồng bộ
- **Dashboard trực quan:** Biểu đồ cột (Bar Chart) so sánh lượng tiêu thụ trong 6 tháng gần nhất.
- **Thẻ tóm tắt:** Tổng tiêu thụ, doanh thu, trung bình và lần ghi cuối.
- **Chế độ Offline & Sync:** Lưu dữ liệu tạm thời khi không có mạng và đồng bộ (Sync) lên Server khi có kết nối.

---

## 🛠 Công nghệ sử dụng

- **Core:** Flutter 3.x & Dart
- **State Management:** `Provider` (Kiến trúc sạch, dễ bảo trì)
- **Database:** `Sqflite` (Lưu trữ cục bộ cho Android/iOS)
- **UI Components:**
  - `fl_chart`: Biểu đồ thống kê.
  - `qr_flutter`: Tạo mã QR hóa đơn.
  - `google_fonts`: Font chữ hiện đại (Be Vietnam Pro).
- **Backend:** Java Spring Boot (Optional - Hiện tại đang sử dụng Mock Data cho mục đích Demo).

---

## 📦 Hướng dẫn cài đặt và chạy

Để chạy dự án này trên máy cục bộ, bạn hãy thực hiện các bước sau:

1. **Yêu cầu:** Máy đã cài đặt [Flutter SDK](https://docs.flutter.dev/get-started/install).
2. **Clone dự án:**
   ```bash
   git clone https://github.com/IamLongLou/PRM393-CodeApp-ThuTienNuoc-VibeCoding-.git
   cd PRM393-CodeApp-ThuTienNuoc-VibeCoding-
   ```
3. **Cài đặt thư viện:**
   ```bash
   flutter pub get
   ```
4. **Chạy ứng dụng:**
   - Chạy trên trình duyệt (Web):
     ```bash
     flutter run -d chrome
     ```
   - Chạy trên thiết bị Android/iOS:
     ```bash
     flutter run
     ```

---

## 📂 Cấu trúc thư mục (Clean Architecture)

```
lib/
├── core/            # Chứa các hằng số, theme, utils dùng chung
├── models/          # Các đối tượng dữ liệu (User, Customer, Bill)
├── providers/       # Quản lý trạng thái ứng dụng (Logic xử lý dữ liệu)
├── screens/         # Giao diện người dùng (Auth, Home, Customer, Sync...)
├── services/        # Xử lý API và Database cục bộ
└── widgets/         # Các component UI tái sử dụng (CustomerCard, CustomButton...)
```

---

## 👤 Thông tin phát triển
- **Dự án:** PRM393 - Mobile Application Development
- **Tác giả:** [IamLongLou](https://github.com/IamLongLou)
- **Trạng thái:** Đang phát triển (Beta)

---
*Lưu ý: Đăng nhập demo với tài khoản bất kỳ hoặc `nhanvien01`/`123456`.*

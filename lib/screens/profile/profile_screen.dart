import 'package:flutter/material.dart';

/// Màn hình hiển thị thông tin cá nhân của nhân viên ghi điện nước
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin cá nhân"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Ảnh đại diện mặc định
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 20),
            
            // Các thông tin chi tiết
            const ListTile(
              leading: Icon(Icons.person),
              title: Text("Họ và tên"),
              subtitle: Text("Nguyễn Văn A"),
            ),
            const ListTile(
              leading: Icon(Icons.email),
              title: Text("Email"),
              subtitle: Text("nguyenvana@example.com"),
            ),
            const ListTile(
              leading: Icon(Icons.phone),
              title: Text("Số điện thoại"),
              subtitle: Text("0123456789"),
            ),
            
            const Spacer(), // Đẩy nút Đăng xuất xuống cuối màn hình
            
            // Nút Đăng xuất
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Màu đỏ cảnh báo
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                // Xóa toàn bộ lịch sử điều hướng và quay về màn hình đăng nhập
                Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
              },
              child: const Text("Đăng xuất", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

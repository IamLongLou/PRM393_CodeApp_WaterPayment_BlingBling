import 'package:flutter/material.dart';

/// Màn hình đồng bộ dữ liệu giữa thiết bị di động và máy chủ
class SyncScreen extends StatelessWidget {
  const SyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đồng bộ dữ liệu"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Biểu tượng Sync lớn ở giữa màn hình
            const Icon(Icons.sync, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            
            const Text(
              "Tất cả dữ liệu đã được đồng bộ",
              style: TextStyle(fontSize: 18),
            ),
            
            const SizedBox(height: 40),
            
            // Nút kích hoạt quá trình đồng bộ
            ElevatedButton.icon(
              onPressed: () {
                // Giả lập quá trình đồng bộ dữ liệu
                // Trong thực tế sẽ gọi API gửi dữ liệu từ Local Database lên Server
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đang đồng bộ dữ liệu lên máy chủ...")),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text("Bắt đầu đồng bộ"),
            ),
          ],
        ),
      ),
    );
  }
}

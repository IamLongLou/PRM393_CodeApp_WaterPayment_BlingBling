import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Bảng điều khiển"),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, "/profile"),
            icon: const Icon(Icons.account_circle),
          )
        ],
      ),
      body: Column(
        children: [
          // Header chào mừng
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Xin chào,",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Text(
                  "Nguyễn Văn A",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Hôm nay bạn cần ghi 15 hộ gia đình.",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildMenuCard(
                    context,
                    "Khách hàng",
                    "Ghi chỉ số",
                    Icons.people_rounded,
                    Colors.blue,
                    () => Navigator.pushNamed(context, "/customer-list"),
                  ),
                  _buildMenuCard(
                    context,
                    "Đồng bộ",
                    "Gửi dữ liệu",
                    Icons.cloud_upload_rounded,
                    Colors.orange,
                    () => Navigator.pushNamed(context, "/sync"),
                  ),
                  _buildMenuCard(
                    context,
                    "Lịch sử",
                    "Tra cứu",
                    Icons.history_rounded,
                    Colors.green,
                    () => Navigator.pushNamed(context, "/history"),
                  ),
                  _buildMenuCard(
                    context,
                    "Cá nhân",
                    "Thiết lập",
                    Icons.person_pin_rounded,
                    Colors.purple,
                    () => Navigator.pushNamed(context, "/profile"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 36, color: color),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

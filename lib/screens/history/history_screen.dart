import 'package:flutter/material.dart';
import '../../models/customer.dart';
import '../../services/customer_service.dart';
import '../customer/customer_history_screen.dart';

/// Màn hình danh sách khách hàng để chọn xem lịch sử chi tiết
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Danh sách gốc từ service
  List<Customer> customers = [];
  // Danh sách hiển thị sau khi lọc
  List<Customer> filtered = [];

  @override
  void initState() {
    super.initState();
    // Lấy dữ liệu khách hàng khi khởi tạo màn hình
    customers = CustomerService.getCustomers();
    filtered = customers;
  }

  /// Hàm tìm kiếm khách hàng theo tên hoặc mã
  void _search(String keyword) {
    setState(() {
      filtered = customers.where((c) {
        return c.name.toLowerCase().contains(keyword.toLowerCase()) ||
               c.code.toLowerCase().contains(keyword.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chọn khách hàng xem lịch sử"),
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: _search,
              decoration: const InputDecoration(
                hintText: "Tìm tên hoặc mã khách hàng...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          // Danh sách khách hàng
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final customer = filtered[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(customer.name[0]), // Lấy chữ cái đầu của tên làm avatar
                  ),
                  title: Text(customer.name),
                  subtitle: Text("Mã: ${customer.code}"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Chuyển sang màn hình lịch sử chi tiết của khách hàng đã chọn
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerHistoryScreen(customer: customer),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

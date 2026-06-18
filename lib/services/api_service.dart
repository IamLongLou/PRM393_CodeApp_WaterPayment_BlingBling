import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // Dùng kIsWeb để kiểm tra nền tảng
import '../models/bill.dart';

/// Lớp xử lý các gọi API đến Backend (Spring Boot)
class ApiService {
  // Tự động chọn URL phù hợp: Web dùng localhost, Android Emulator dùng 10.0.2.2
  static String get baseUrl => kIsWeb 
    ? 'http://localhost:8080/api' 
    : 'http://10.0.2.2:8080/api';

  /// Hàm đăng nhập người dùng
  static Future<Map<String, dynamic>?> login(String u, String p) async {
    try {
      print('Đang gọi Đăng nhập: $baseUrl/auth/login');
      final res = await http.post(
        Uri.parse('$baseUrl/auth/login'), 
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }, 
        body: jsonEncode({'username': u, 'password': p})
      );
      print('Trạng thái Đăng nhập: ${res.statusCode}');
      if (res.statusCode == 200) return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      print('Lỗi đăng nhập: $e');
    }
    return null;
  }

  /// Lấy toàn bộ dữ liệu ban đầu từ Server (Khách hàng, Hóa đơn)
  static Future<Map<String, dynamic>?> bootstrap() async {
    try {
      print('Đang gọi Bootstrap: $baseUrl/bootstrap');
      final res = await http.get(Uri.parse('$baseUrl/bootstrap'));
      print('Trạng thái Bootstrap: ${res.statusCode}');
      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        print('Dữ liệu nhận được: ${data['customers']?.length} khách hàng');
        return data;
      }
    } catch (e) {
      print('Lỗi Bootstrap: $e');
    }
    return null;
  }

  /// Đồng bộ danh sách hóa đơn mới lên Server
  static Future<bool> syncBills(List<Bill> bills) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/sync/bills'), 
        headers: {'Content-Type': 'application/json'}, 
        body: jsonEncode({'bills': bills.map((b) => b.toMap()..['isSynced'] = 1).toList()})
      );
      return res.statusCode == 200;
    } catch (e) {
      print('Lỗi đồng bộ: $e');
    }
    return false;
  }
}

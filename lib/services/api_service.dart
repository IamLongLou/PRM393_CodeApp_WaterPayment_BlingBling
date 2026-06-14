import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/customer.dart';
import '../models/bill.dart';

class ApiService {
  // Đối với Android Emulator, 10.0.2.2 trỏ về localhost của máy tính
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  static Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      print('Login Error: $e');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> bootstrap() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/bootstrap'));
      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      print('Bootstrap Error: $e');
    }
    return null;
  }

  static Future<List<dynamic>?> syncBills(List<Bill> bills) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sync/bills'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'bills': bills.map((b) => {
            'customerId': b.customerId,
            'billCode': b.billCode,
            'date': b.date.toIso8601String(),
            'oldReading': b.oldReading,
            'newReading': b.newReading,
            'consumption': b.consumption,
            'unitPrice': b.unitPrice,
            'amount': b.amount,
            'vat': b.vat,
            'totalAmount': b.totalAmount,
            'imagePath': b.imagePath,
            'isSynced': true, // Khi gửi lên server thành công nó sẽ là true
          }).toList()
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      print('Sync Error: $e');
    }
    return null;
  }
}

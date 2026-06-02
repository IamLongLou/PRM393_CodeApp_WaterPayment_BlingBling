import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    // Giả lập delay mạng
    await Future.delayed(const Duration(seconds: 1));

    // Danh sách tài khoản giả lập cho phân quyền
    final mockUsers = [
      {'user': 'admin', 'pass': 'admin123', 'name': 'Quản Trị Viên', 'role': 'admin'},
      {'user': 'nhanvien01', 'pass': '123456', 'name': 'Nguyễn Văn A', 'role': 'staff'},
      {'user': 'khachhang01', 'pass': '654321', 'name': 'Lê Minh Triết', 'role': 'user'},
      {'user': 'abc', 'pass': '123', 'name': 'Khách Hàng Mới', 'role': 'user'},
    ];

    try {
      final userData = mockUsers.firstWhere(
        (u) => u['user'] == username && u['pass'] == password
      );

      _user = User(
        username: userData['user']!,
        fullName: userData['name']!,
        role: userData['role']!,
      );
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}

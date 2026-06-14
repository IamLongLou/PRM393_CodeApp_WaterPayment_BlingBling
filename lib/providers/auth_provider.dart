import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/database_helper.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _checkLastSession();
  }

  Future<void> _checkLastSession() async {
    _user = await _dbHelper.getLastSession();
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    // 1. Gọi API Online thật
    final response = await ApiService.login(username, password);

    if (response != null) {
      final userData = response['user'];
      final token = response['token'];

      _user = User(
        username: userData['username'],
        fullName: userData['fullName'],
        role: userData['role'],
        email: userData['email'],
        phone: userData['phone'],
      );
      
      // Lưu session vào SQLite để dùng offline
      await _dbHelper.saveSession(_user!, token);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      // 2. Xử lý Offline unlock nếu API lỗi/không có mạng
      final lastUser = await _dbHelper.getLastSession();
      if (lastUser != null && lastUser.username == username) {
        _user = lastUser;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> updateProfile(String name, String email, String phone) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (_user != null) {
      _user = _user!.copyWith(fullName: name, email: email, phone: phone);
      _isLoading = false;
      notifyListeners();
      return true;
    }
    _isLoading = false;
    return false;
  }

  Future<bool> changePassword(String oldPass, String newPass) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Trong thực tế sẽ gọi API, ở đây giả định luôn thành công nếu ko trống
    if (newPass.isNotEmpty) {
      _isLoading = false;
      notifyListeners();
      return true;
    }
    _isLoading = false;
    return false;
  }

  Future<void> logout() async {
    _user = null;
    await _dbHelper.clearSession();
    notifyListeners();
  }
}

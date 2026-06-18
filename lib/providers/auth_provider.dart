import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/database_helper.dart';
import '../services/api_service.dart';

/// Lớp quản lý xác thực và thông tin người dùng
class AuthProvider with ChangeNotifier {
  final _db = DatabaseHelper.instance;
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() { 
    _check(); // Kiểm tra phiên đăng nhập cũ khi khởi chạy
  }

  /// Kiểm tra xem có phiên đăng nhập nào được lưu trong SQLite không
  Future<void> _check() async {
    _user = await _db.getLastSession();
    notifyListeners();
  }

  /// Xử lý đăng nhập
  Future<bool> login(String username, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // 1. Gọi API đăng nhập trực tuyến
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
          customerCode: userData['customerCode'],
        );
        
        // Lưu phiên đăng nhập vào SQLite để dùng Offline sau này
        await _db.saveSession(_user!, token);
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        // 2. Nếu không có mạng, thử đăng nhập Offline bằng dữ liệu cũ trong SQLite
        final last = await _db.getLastSession();
        if (last != null && last.username == username) {
          _user = last; 
          _isLoading = false; 
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e, s) {
      debugPrint("LỖI ĐĂNG NHẬP: $e");
      debugPrint(s.toString());
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cập nhật thông tin cá nhân
  Future<bool> updateProfile(String name, String email, String phone) async {
    if (_user == null) return false;
    _isLoading = true; 
    notifyListeners();
    
    // Giả lập gọi API cập nhật
    await Future.delayed(const Duration(milliseconds: 500));
    _user = User(
      username: _user!.username,
      fullName: name,
      role: _user!.role,
      email: email,
      phone: phone,
    );
    await _db.saveSession(_user!, null); // Cập nhật lại vào SQLite
    
    _isLoading = false; 
    notifyListeners();
    return true;
  }

  /// Đổi mật khẩu
  Future<bool> changePassword(String oldPass, String newPass) async {
    _isLoading = true; 
    notifyListeners();
    // Giả lập gọi API đổi mật khẩu
    await Future.delayed(const Duration(milliseconds: 800));
    _isLoading = false; 
    notifyListeners();
    return true;
  }

  /// Đăng xuất và xóa phiên làm việc
  Future<void> logout() async {
    _user = null; 
    await _db.clearSession(); // Xóa khỏi SQLite
    notifyListeners();
  }
}

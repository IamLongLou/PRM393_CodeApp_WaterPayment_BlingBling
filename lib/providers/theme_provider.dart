import 'package:flutter/material.dart';

/// Lớp quản lý trạng thái giao diện (Sáng/Tối)
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light; // Mặc định là chế độ sáng

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Chuyển đổi giữa chế độ sáng và tối
  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // Thông báo cho UI cập nhật lại màu sắc
  }
}

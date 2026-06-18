import 'package:intl/intl.dart';

/// Lớp tiện ích để định dạng dữ liệu (Tiền tệ, Ngày tháng)
class FormatterUtils {
  /// Định dạng số tiền sang chuẩn Việt Nam Đồng (đ)
  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(amount);
  }

  /// Định dạng ngày tháng (mặc định: dd/MM/yyyy)
  static String formatDate(DateTime date, {String pattern = 'dd/MM/yyyy'}) {
    return DateFormat(pattern).format(date);
  }

  /// Định dạng ngày giờ đầy đủ
  static String formatDateTime(DateTime date) {
    return DateFormat('HH:mm - dd/MM/yyyy').format(date);
  }

  /// Lấy lời chào theo thời điểm trong ngày
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Chào buổi sáng';
    if (hour >= 12 && hour < 18) return 'Chào buổi chiều';
    return 'Chào buổi tối';
  }
}

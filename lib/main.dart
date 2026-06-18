import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'routes/app_routes.dart';
import 'providers/auth_provider.dart';
import 'providers/customer_provider.dart';
import 'providers/billing_provider.dart';
import 'providers/sync_provider.dart';
import 'providers/theme_provider.dart';
import 'core/theme/app_theme.dart';

void main() async {
  /// Đảm bảo các dịch vụ của Flutter đã khởi tạo
  WidgetsFlutterBinding.ensureInitialized();
  
  /// Khởi tạo định dạng ngày tháng cho tiếng Việt
  await initializeDateFormatting('vi_VN', null);
  
  runApp(
    MultiProvider(
      /// Đăng ký các Provider quản lý trạng thái cho toàn ứng dụng
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => BillingProvider()),
        ChangeNotifierProvider(create: (_) => SyncProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// Lấy trạng thái theme (sáng/tối) từ ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Water Billing',
      /// Cấu hình theme sáng
      theme: AppTheme.lightTheme,
      /// Cấu hình theme tối
      darkTheme: AppTheme.darkTheme,
      /// Chế độ theme hiện tại
      themeMode: themeProvider.themeMode,
      // Đường dẫn khởi đầu (Màn hình Splash)
      initialRoute: AppRoutes.splash,
      /// Danh sách các route trong ứng dụng
      routes: AppRoutes.routes,
    );
  }
}

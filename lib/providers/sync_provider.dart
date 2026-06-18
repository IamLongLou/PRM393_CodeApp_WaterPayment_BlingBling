import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bill.dart';
import '../services/database_helper.dart';
import '../services/api_service.dart';

/// Lớp quản lý trạng thái đồng bộ hóa dữ liệu lên Server
class SyncProvider with ChangeNotifier {
  final _db = DatabaseHelper.instance;
  List<Bill> _unsynced = []; // Danh sách hóa đơn chưa đồng bộ
  bool _isSyncing = false; // Trạng thái đang đồng bộ
  DateTime? _lastSyncTime; // Thời gian đồng bộ cuối cùng

  List<Bill> get unsyncedBills => _unsynced;
  bool get isSyncing => _isSyncing;
  DateTime? get lastSyncTime => _lastSyncTime;

  SyncProvider() {
    fetchUnsyncedBills(); // Lấy các hóa đơn chờ đồng bộ từ SQLite
    _loadLastSyncTime(); // Tải thời gian đồng bộ từ SharedPreferences
  }

  /// Tải thời gian đồng bộ cuối cùng từ bộ nhớ máy
  Future<void> _loadLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final String? timeString = prefs.getString('lastSyncTime');
    if (timeString != null) {
      _lastSyncTime = DateTime.tryParse(timeString);
      notifyListeners();
    }
  }

  /// Lấy danh sách các hóa đơn chưa được gửi lên Server
  Future<void> fetchUnsyncedBills() async {
    _unsynced = await _db.getUnsyncedBills();
    notifyListeners();
  }

  /// Thực hiện gửi toàn bộ hóa đơn chưa đồng bộ lên Server
  Future<void> syncAll() async {
    if (_unsynced.isEmpty) return;
    
    _isSyncing = true;
    notifyListeners();

    try {
      // 1. Gọi API để đẩy dữ liệu lên SQL Server thật
      final success = await ApiService.syncBills(_unsynced);
      
      if (success) {
        // 2. Nếu thành công, cập nhật trạng thái isSynced = 1 trong SQLite
        await _db.markBillsAsSynced(_unsynced);
        
        // 3. Xóa danh sách hóa đơn chờ đồng bộ cục bộ
        _unsynced = [];

        // 4. Cập nhật và lưu lại thời gian đồng bộ cuối cùng
        _lastSyncTime = DateTime.now();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('lastSyncTime', _lastSyncTime!.toIso8601String());
      }
    } catch (e) {
      debugPrint("Lỗi đồng bộ: $e");
    } finally {
      _isSyncing = false; 
      notifyListeners();
    }
  }
}

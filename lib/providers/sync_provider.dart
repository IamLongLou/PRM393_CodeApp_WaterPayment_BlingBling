import 'package:flutter/material.dart';
import '../models/bill.dart';
import '../services/database_helper.dart';
import '../services/api_service.dart';

class SyncProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Bill> _unsyncedBills = [];
  bool _isSyncing = false;

  List<Bill> get unsyncedBills => _unsyncedBills;
  bool get isSyncing => _isSyncing;

  SyncProvider() {
    fetchUnsyncedBills();
  }

  Future<void> fetchUnsyncedBills() async {
    _unsyncedBills = await _dbHelper.getUnsyncedBills();
    notifyListeners();
  }

  Future<void> syncAll() async {
    if (_unsyncedBills.isEmpty) return;
    
    _isSyncing = true;
    notifyListeners();

    // 1. Gọi API để đẩy dữ liệu lên SQL Server thật
    final response = await ApiService.syncBills(_unsyncedBills);
    
    if (response != null) {
      // 2. Cập nhật trạng thái isSynced = 1 trong SQLite
      await _dbHelper.markBillsAsSynced(_unsyncedBills);
      
      // 3. Clear danh sách local
      _unsyncedBills = [];
    }

    _isSyncing = false;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../models/bill.dart';
import '../services/database_helper.dart';
import '../services/api_service.dart';

/// Lớp quản lý trạng thái dữ liệu khách hàng
class CustomerProvider with ChangeNotifier {
  final _db = DatabaseHelper.instance;
  List<Customer> _customers = [];
  List<Customer> _filteredCustomers = [];
  bool _isLoading = false;
  String _searchQuery = "";
  DateTime? _lastSyncTime;

  // Getters để truy cập dữ liệu từ UI
  List<Customer> get customers => _filteredCustomers.isEmpty && _searchQuery.isEmpty ? _customers : _filteredCustomers;
  List<Customer> get allCustomers => _customers;
  bool get isLoading => _isLoading;
  DateTime? get lastSyncTime => _lastSyncTime;

  CustomerProvider() { 
    fetch(); // Tự động tải dữ liệu khi khởi tạo
  }

  /// Tải dữ liệu khách hàng từ SQLite
  Future<void> fetch() async {
    _isLoading = true; 
    notifyListeners();

    try {
      // 1. Lấy dữ liệu từ SQLite trước để UI hiện lên ngay
      _customers = await _db.getAllCustomers();
      _filteredCustomers = [];
      notifyListeners();

      // 2. Nếu local chưa có dữ liệu, tự động gọi refresh để tải từ server
      if (_customers.isEmpty) {
        await refresh();
      }
    } catch (e) {
      debugPrint("Lỗi tải dữ liệu: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Làm mới dữ liệu bằng cách tải lại từ Server
  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();
    try {
      // Gọi API lấy dữ liệu tổng hợp (Bootstrap)
      final data = await ApiService.bootstrap();
      if (data != null) {
        final List remoteC = data['customers'];
        final List remoteB = data['bills'];
        
        // Lưu khách hàng vào SQLite
        await _db.upsertCustomers(remoteC.map((e) => Customer.fromMap(e)).toList());
        
        // Lưu các hóa đơn cũ (đã đồng bộ) vào SQLite
        for (var b in remoteB) {
          await _db.insertBill(Bill.fromMap(b).copyWith(isSynced: true));
        }
        
        // Cập nhật lại danh sách hiển thị
        _customers = await _db.getAllCustomers();
        _lastSyncTime = DateTime.now();
        if (_searchQuery.isNotEmpty) searchCustomers(_searchQuery);
      }
    } catch (e) {
      debugPrint("Lỗi làm mới dữ liệu: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Tìm kiếm khách hàng theo tên hoặc mã
  void searchCustomers(String q) {
    _searchQuery = q.toLowerCase();
    if (_searchQuery.isEmpty) {
      _filteredCustomers = [];
    } else {
      _filteredCustomers = _customers.where((c) => 
        c.name.toLowerCase().contains(_searchQuery) || 
        c.code.toLowerCase().contains(_searchQuery)
      ).toList();
    }
    notifyListeners();
  }
}

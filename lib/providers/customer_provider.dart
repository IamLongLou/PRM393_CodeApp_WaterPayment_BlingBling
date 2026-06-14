import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../models/bill.dart';
import '../data/repositories/customer_repository.dart';
import '../data/repositories/local_customer_repository.dart';
import '../services/api_service.dart';
import '../services/database_helper.dart';

class CustomerProvider with ChangeNotifier {
  final CustomerRepository _repository = LocalCustomerRepository();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  
  List<Customer> _customers = [];
  List<Customer> _filteredCustomers = [];
  bool _isLoading = false;

  CustomerProvider() {
    fetchCustomers();
  }

  List<Customer> get customers => _filteredCustomers.isEmpty && _customers.isNotEmpty ? _customers : _filteredCustomers;
  List<Customer> get allCustomers => _customers;
  bool get isLoading => _isLoading;

  Future<void> fetchCustomers() async {
    _isLoading = true;
    notifyListeners();
    
    // 1. Luôn ưu tiên lấy từ SQLite trước để UI hiện lên ngay
    _customers = await _repository.getAll();
    _filteredCustomers = [];
    
    _isLoading = false;
    notifyListeners();
    
    // 2. Thử cập nhật từ API nếu có mạng (Back-ground refresh)
    refreshFromServer();
  }

  Future<void> refreshFromServer() async {
    final data = await ApiService.bootstrap();
    if (data != null) {
      final List<dynamic> customersJson = data['customers'];
      final List<dynamic> billsJson = data['bills'];

      final remoteCustomers = customersJson.map((c) => Customer.fromMap(c)).toList();
      final remoteBills = billsJson.map((b) => Bill.fromMap(b)).toList();

      // Lưu vào SQLite
      await _dbHelper.upsertCustomers(remoteCustomers);
      await _dbHelper.upsertBills(remoteBills);

      // Load lại dữ liệu local
      _customers = await _repository.getAll();
      notifyListeners();
    }
  }

  void searchCustomers(String query) async {
    _filteredCustomers = await _repository.search(query);
    notifyListeners();
  }

  Future<void> updateCustomerReading(int id, int newReading) async {
    await _repository.updateReading(id, newReading);
    // Sau khi cập nhật SQLite, load lại danh sách để UI đồng bộ
    await fetchCustomers();
  }
}

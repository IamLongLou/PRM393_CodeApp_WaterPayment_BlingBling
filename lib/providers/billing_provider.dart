import 'package:flutter/material.dart';
import '../models/bill.dart';
import '../services/database_helper.dart';

class BillingProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Bill> _customerBills = [];
  bool _isLoading = false;

  List<Bill> get customerBills => _customerBills;
  bool get isLoading => _isLoading;

  Future<void> fetchBillsByCustomer(int customerId) async {
    _isLoading = true;
    notifyListeners();
    
    // Lấy từ SQLite
    _customerBills = await _dbHelper.getBillsByCustomerId(customerId);
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveBill(Bill bill) async {
    // 1. Lưu vào SQLite local với trạng thái isSynced = false
    await _dbHelper.insertBill(bill);
    
    // 2. Cập nhật UI ngay lập tức
    _customerBills.insert(0, bill);
    notifyListeners();
  }

  Future<List<Bill>> getAllBills() async {
    return await _dbHelper.getAllBills();
  }

  Future<void> markBillsAsSynced(List<Bill> syncedBills) async {
    await _dbHelper.markBillsAsSynced(syncedBills);
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import '../models/bill.dart';
import '../services/database_helper.dart';

/// Lớp quản lý trạng thái các hóa đơn (Billing)
class BillingProvider with ChangeNotifier {
  final _db = DatabaseHelper.instance;
  List<Bill> _customerBills = []; // Danh sách hóa đơn của một khách hàng cụ thể

  List<Bill> get customerBills => _customerBills;

  /// Lấy danh sách hóa đơn theo mã khách hàng
  Future<void> fetchBillsByCustomer(int customerId) async {
    _customerBills = await _db.getBillsByCustomer(customerId);
    notifyListeners();
  }

  /// Lấy toàn bộ danh sách hóa đơn từ SQLite (Sắp xếp theo ngày mới nhất)
  Future<List<Bill>> getAllBills() async {
    final db = await _db.database;
    final res = await db.query('bills', orderBy: 'date DESC');
    return res.map((m) => Bill.fromMap(m)).toList();
  }

  /// Lưu hóa đơn mới vào SQLite và cập nhật chỉ số nước cho khách hàng
  Future<void> saveBill(Bill bill) async {
    await _db.insertBill(bill);
    await _db.updateCustomerReading(bill.customerId, bill.newReading);
    _customerBills.insert(0, bill); // Thêm vào đầu danh sách để hiển thị ngay
    notifyListeners();
  }

  /// Đánh dấu danh sách hóa đơn đã được đồng bộ lên Server
  Future<void> markBillsAsSynced(List<Bill> bills) async {
    await _db.markBillsAsSynced(bills);
    notifyListeners();
  }
}

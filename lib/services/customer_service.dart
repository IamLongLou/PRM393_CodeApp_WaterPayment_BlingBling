import '../models/customer.dart';
import 'database_helper.dart';

/// Lớp cung cấp các dịch vụ liên quan đến Khách hàng
class CustomerService {
  /// Lấy danh sách khách hàng từ database
  static Future<List<Customer>> getCustomers() async {
    return await DatabaseHelper.instance.getAllCustomers();
  }

  /// Cập nhật trạng thái thu tiền cho một khách hàng
  static Future<void> updateStatus(int customerId, CollectionStatus newStatus) async {
    final customer = await DatabaseHelper.instance.getCustomerById(customerId);
    if (customer != null) {
      // Tạo bản sao khách hàng với trạng thái mới và lưu lại
      await DatabaseHelper.instance.updateCustomer(customer.copyWith(status: newStatus));
    }
  }
}

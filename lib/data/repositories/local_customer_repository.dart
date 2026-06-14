import '../../models/customer.dart';
import '../../services/database_helper.dart';
import 'customer_repository.dart';

class LocalCustomerRepository implements CustomerRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Future<List<Customer>> getAll() async {
    return await _dbHelper.getAllCustomers();
  }

  @override
  Future<Customer?> getById(int id) async {
    return await _dbHelper.getCustomerById(id);
  }

  @override
  Future<void> save(Customer item) async {
    await _dbHelper.upsertCustomer(item);
  }

  @override
  Future<void> update(Customer item) async {
    await _dbHelper.updateCustomer(item);
  }

  @override
  Future<List<Customer>> search(String query) async {
    return await _dbHelper.searchCustomers(query);
  }

  @override
  Future<void> updateReading(int id, int newReading) async {
    final customer = await _dbHelper.getCustomerById(id);
    if (customer != null) {
      final updated = customer.copyWith(
        currentReading: newReading,
        status: CollectionStatus.completed,
      );
      await _dbHelper.updateCustomer(updated);
    }
  }
  
  Future<void> saveAll(List<Customer> customers) async {
    await _dbHelper.upsertCustomers(customers);
  }
}

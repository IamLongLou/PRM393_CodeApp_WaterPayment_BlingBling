import '../../models/customer.dart';
import 'base_repository.dart';

abstract class CustomerRepository extends BaseRepository<Customer> {
  Future<List<Customer>> search(String query);
  Future<void> updateReading(int id, int newReading);
}

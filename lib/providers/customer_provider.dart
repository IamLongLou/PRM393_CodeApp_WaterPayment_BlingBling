import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../data/repositories/customer_repository.dart';
import '../data/repositories/mock_customer_repository.dart';

class CustomerProvider with ChangeNotifier {
  final CustomerRepository _repository = MockCustomerRepository();
  
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
    
    _customers = await _repository.getAll();
    _filteredCustomers = [];
    
    _isLoading = false;
    notifyListeners();
  }

  void searchCustomers(String query) async {
    _filteredCustomers = await _repository.search(query);
    notifyListeners();
  }

  Future<void> updateCustomerReading(int id, int newReading) async {
    await _repository.updateReading(id, newReading);
    await fetchCustomers();
  }
}

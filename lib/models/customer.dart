/// Các trạng thái thu tiền/ghi chỉ số của khách hàng
enum CollectionStatus { pending, reading, completed }

/// Lớp đại diện cho đối tượng Khách hàng
class Customer {
  final int? id; // ID tự tăng từ database
  final String code; // Mã khách hàng (ví dụ: KH001)
  final String name; // Tên khách hàng
  final String address; // Địa chỉ
  final String phone; // Số điện thoại
  final int currentReading; // Chỉ số nước hiện tại
  final CollectionStatus status; // Trạng thái (chờ, đang ghi, hoàn tất)

  Customer({
    this.id, 
    required this.code, 
    required this.name, 
    required this.address, 
    required this.phone, 
    required this.currentReading, 
    this.status = CollectionStatus.pending
  });

  /// Chuyển đối tượng thành Map để lưu vào database SQLite
  Map<String, dynamic> toMap() => {
    'id': id, 
    'code': code, 
    'name': name, 
    'address': address, 
    'phone': phone, 
    'currentReading': currentReading, 
    'status': status.index,
  };

  /// Tạo đối tượng Customer từ dữ liệu Map (từ database hoặc API)
  factory Customer.fromMap(Map<String, dynamic> map) => Customer(
    id: map['id'],
    code: map['code'] ?? '',
    name: map['name'] ?? '',
    address: map['address'] ?? '',
    phone: map['phone'] ?? '',
    currentReading: map['currentReading'] ?? 0,
    status: CollectionStatus.values[map['status'] ?? 0],
  );

  /// Tạo một bản sao của đối tượng với các thuộc tính thay đổi
  Customer copyWith({
    int? id, 
    String? code, 
    String? name, 
    String? address, 
    String? phone, 
    int? currentReading, 
    CollectionStatus? status
  }) {
    return Customer(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      currentReading: currentReading ?? this.currentReading,
      status: status ?? this.status,
    );
  }
}

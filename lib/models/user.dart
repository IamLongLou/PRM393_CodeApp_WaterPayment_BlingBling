/// Lớp đại diện cho đối tượng Người dùng (Nhân viên hoặc Khách hàng)
class User {
  final String username; // Tên đăng nhập
  final String fullName; // Họ và tên
  final String role; // Vai trò (staff hoặc user)
  final String? email; // Email liên hệ
  final String? phone; // Số điện thoại
  final String? customerCode; // Mã khách hàng liên kết (nếu là khách hàng)

  User({
    required this.username,
    required this.fullName,
    required this.role,
    this.email,
    this.phone,
    this.customerCode,
  });

  /// Chuyển thông tin người dùng thành Map để lưu vào SQLite (Session)
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'fullName': fullName,
      'role': role,
      'email': email,
      'phone': phone,
      'customerCode': customerCode,
    };
  }

  /// Tạo đối tượng User từ dữ liệu Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] ?? '',
      fullName: map['fullName'] ?? '',
      role: map['role'] ?? 'user',
      email: map['email'],
      phone: map['phone'],
      customerCode: map['customerCode'],
    );
  }

  /// Tạo bản sao đối tượng User
  User copyWith({
    String? username,
    String? fullName,
    String? role,
    String? email,
    String? phone,
    String? customerCode,
  }) {
    return User(
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      customerCode: customerCode ?? this.customerCode,
    );
  }
}

/// Lớp đại diện cho đối tượng Hóa đơn
class Bill {
  final int? id; // ID tự tăng trong SQLite
  final int customerId; // ID khách hàng liên kết
  final String? customerName; // Tên khách hàng (để hiển thị nhanh)
  final String? customerCode; // Mã khách hàng
  final String billCode; // Mã hóa đơn (duy nhất)
  final DateTime date; // Ngày lập hóa đơn
  final int oldReading; // Chỉ số nước cũ
  final int newReading; // Chỉ số nước mới
  final double consumption; // Lượng nước tiêu thụ
  final double unitPrice; // Đơn giá
  final double amount; // Thành tiền (chưa thuế)
  final double vat; // Thuế VAT
  final double totalAmount; // Tổng tiền thanh toán (có thuế)
  final String? imagePath; // Đường dẫn ảnh chụp đồng hồ nước
  final bool isSynced; // Trạng thái đã đồng bộ lên Server chưa

  Bill({
    this.id, 
    required this.customerId, 
    this.customerName, 
    this.customerCode, 
    required this.billCode, 
    required this.date, 
    required this.oldReading, 
    required this.newReading, 
    required this.consumption, 
    required this.unitPrice, 
    required this.amount, 
    required this.vat, 
    required this.totalAmount, 
    this.imagePath, 
    this.isSynced = false
  });

  /// Chuyển đối tượng thành Map để lưu vào database SQLite
  Map<String, dynamic> toMap() => {
    'id': id, 
    'customerId': customerId, 
    'customerName': customerName, 
    'customerCode': customerCode, 
    'billCode': billCode, 
    'date': date.toIso8601String(), 
    'oldReading': oldReading, 
    'newReading': newReading, 
    'consumption': consumption, 
    'unitPrice': unitPrice, 
    'amount': amount, 
    'vat': vat, 
    'totalAmount': totalAmount, 
    'imagePath': imagePath, 
    'isSynced': isSynced ? 1 : 0,
  };

  /// Tạo đối tượng Bill từ dữ liệu Map (từ database hoặc API)
  factory Bill.fromMap(Map<String, dynamic> map) => Bill(
    id: map['id'],
    customerId: map['customerId'],
    customerName: map['customerName'],
    customerCode: map['customerCode'],
    billCode: map['billCode'] ?? '',
    date: DateTime.parse(map['date']),
    oldReading: map['oldReading'],
    newReading: map['newReading'],
    consumption: (map['consumption'] as num).toDouble(),
    unitPrice: (map['unitPrice'] as num).toDouble(),
    amount: (map['amount'] as num).toDouble(),
    vat: (map['vat'] as num).toDouble(),
    totalAmount: (map['totalAmount'] as num).toDouble(),
    imagePath: map['imagePath'],
    isSynced: map['isSynced'] == 1 || map['isSynced'] == true,
  );

  /// Tạo bản sao đối tượng với một vài thông tin thay đổi
  Bill copyWith({
    int? id, 
    int? customerId, 
    String? customerName, 
    String? customerCode, 
    String? billCode, 
    DateTime? date, 
    int? oldReading, 
    int? newReading, 
    double? consumption, 
    double? unitPrice, 
    double? amount, 
    double? vat, 
    double? totalAmount, 
    String? imagePath, 
    bool? isSynced
  }) {
    return Bill(
      id: id ?? this.id, 
      customerId: customerId ?? this.customerId, 
      customerName: customerName ?? this.customerName, 
      customerCode: customerCode ?? this.customerCode, 
      billCode: billCode ?? this.billCode, 
      date: date ?? this.date, 
      oldReading: oldReading ?? this.oldReading, 
      newReading: newReading ?? this.newReading, 
      consumption: consumption ?? this.consumption, 
      unitPrice: unitPrice ?? this.unitPrice, 
      amount: amount ?? this.amount, 
      vat: vat ?? this.vat, 
      totalAmount: totalAmount ?? this.totalAmount, 
      imagePath: imagePath ?? this.imagePath, 
      isSynced: isSynced ?? this.isSynced,
    );
  }
}

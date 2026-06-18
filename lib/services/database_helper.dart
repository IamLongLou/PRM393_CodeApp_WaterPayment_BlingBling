import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/customer.dart';
import '../models/bill.dart';
import '../models/user.dart';

/// Lớp hỗ trợ quản lý cơ sở dữ liệu SQLite local
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  /// Lấy đối tượng database, nếu chưa có thì khởi tạo
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('water_billing_final.db');
    return _database!;
  }

  /// Khởi tạo file database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  /// Tạo các bảng trong database lần đầu
  Future<void> _createDB(Database db, int version) async {
    // Bảng khách hàng
    await db.execute('''
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY,
        code TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        address TEXT NOT NULL,
        phone TEXT NOT NULL,
        currentReading INTEGER NOT NULL,
        status INTEGER NOT NULL
      )
    ''');

    // Bảng hóa đơn
    await db.execute('''
      CREATE TABLE bills (
        id INTEGER PRIMARY KEY,
        customerId INTEGER NOT NULL,
        customerName TEXT,
        customerCode TEXT,
        billCode TEXT NOT NULL UNIQUE,
        date TEXT NOT NULL,
        oldReading INTEGER NOT NULL,
        newReading INTEGER NOT NULL,
        consumption REAL NOT NULL,
        unitPrice REAL NOT NULL,
        amount REAL NOT NULL,
        vat REAL NOT NULL,
        totalAmount REAL NOT NULL,
        imagePath TEXT,
        isSynced INTEGER NOT NULL,
        FOREIGN KEY (customerId) REFERENCES customers (id) ON DELETE CASCADE
      )
    ''');

    // Bảng lưu phiên đăng nhập người dùng
    await db.execute('''
      CREATE TABLE user_session (
        username TEXT PRIMARY KEY,
        fullName TEXT NOT NULL,
        role TEXT NOT NULL,
        email TEXT,
        phone TEXT,
        customerCode TEXT,
        token TEXT,
        lastLoginAt TEXT NOT NULL
      )
    ''');
  }

  /// Nâng cấp database khi có thay đổi version
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _addColumnIfMissing(db, 'bills', 'customerName', 'TEXT');
      await _addColumnIfMissing(db, 'bills', 'customerCode', 'TEXT');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS user_session (
          username TEXT PRIMARY KEY,
          fullName TEXT NOT NULL,
          role TEXT NOT NULL,
          email TEXT,
          phone TEXT,
          customerCode TEXT,
          token TEXT,
          lastLoginAt TEXT NOT NULL
        )
      ''');
    }
    if (oldVersion < 3) {
      await _addColumnIfMissing(db, 'user_session', 'customerCode', 'TEXT');
    }
  }

  /// Hàm hỗ trợ thêm cột vào bảng nếu chưa tồn tại
  Future<void> _addColumnIfMissing(Database db, String table, String column, String type) async {
    final columns = await db.rawQuery('PRAGMA table_info($table)');
    final exists = columns.any((c) => c['name'] == column);
    if (!exists) {
      await db.execute('ALTER TABLE $table ADD COLUMN $column $type');
    }
  }

  /// Lấy danh sách toàn bộ khách hàng
  Future<List<Customer>> getAllCustomers() async {
    final db = await database;
    final res = await db.query('customers', orderBy: 'code ASC');
    return res.map(Customer.fromMap).toList();
  }

  /// Cập nhật hoặc thêm mới danh sách khách hàng (từ Server về)
  Future<void> upsertCustomers(List<Customer> customers) async {
    final db = await database;
    final batch = db.batch();
    for (var c in customers) batch.insert('customers', c.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    await batch.commit(noResult: true);
  }

  /// Cập nhật chỉ số nước cho khách hàng
  Future<void> updateCustomerReading(int id, int newReading) async {
    final db = await database;
    await db.update('customers', {'currentReading': newReading, 'status': 2}, where: 'id = ?', whereArgs: [id]);
  }

  /// Thêm hóa đơn mới
  Future<void> insertBill(Bill bill) async {
    final db = await database;
    await db.insert('bills', bill.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Lấy danh sách các hóa đơn chưa được đồng bộ lên Server
  Future<List<Bill>> getUnsyncedBills() async {
    final db = await database;
    final res = await db.query('bills', where: 'isSynced = ?', whereArgs: [0]);
    return res.map(Bill.fromMap).toList();
  }

  /// Đánh dấu các hóa đơn đã đồng bộ thành công
  Future<void> markBillsAsSynced(List<Bill> bills) async {
    final db = await database;
    for (var b in bills) {
      await db.update('bills', {'isSynced': 1}, where: 'billCode = ?', whereArgs: [b.billCode]);
    }
  }

  /// Lấy danh sách hóa đơn theo mã khách hàng
  Future<List<Bill>> getBillsByCustomer(int customerId) async {
    final db = await database;
    final res = await db.query('bills', where: 'customerId = ?', whereArgs: [customerId], orderBy: 'date DESC');
    return res.map(Bill.fromMap).toList();
  }

  // --- Các phương thức quản lý phiên đăng nhập (Session) ---

  /// Lưu thông tin đăng nhập vào SQLite để dùng Offline
  Future<void> saveSession(User user, String? token) async {
    final db = await database;
    await db.insert('user_session', {
      'username': user.username,
      'fullName': user.fullName,
      'role': user.role,
      'email': user.email,
      'phone': user.phone,
      'customerCode': user.customerCode,
      'token': token,
      'lastLoginAt': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Lấy thông tin đăng nhập cuối cùng
  Future<User?> getLastSession() async {
    final db = await database;
    final res = await db.query('user_session', orderBy: 'lastLoginAt DESC', limit: 1);
    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }
    return null;
  }

  /// Lấy thông tin một khách hàng theo ID
  Future<Customer?> getCustomerById(int id) async {
    final db = await database;
    final res = await db.query('customers', where: 'id = ?', whereArgs: [id]);
    if (res.isNotEmpty) {
      return Customer.fromMap(res.first);
    }
    return null;
  }

  /// Cập nhật thông tin khách hàng
  Future<void> updateCustomer(Customer customer) async {
    final db = await database;
    await db.update('customers', customer.toMap(), where: 'id = ?', whereArgs: [customer.id]);
  }

  /// Xóa phiên đăng nhập (khi đăng xuất)
  Future<void> clearSession() async {
    final db = await database;
    await db.delete('user_session');
  }
}

import 'dart:async';
import 'package:save_mart/models/order.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'orders.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            customerName TEXT,
            totalAmount REAL,
            date TEXT
          )
        ''');
        db.execute('''
          CREATE TABLE orderItems (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            orderId INTEGER,
            productName TEXT,
            quantity INTEGER,
            unitPrice REAL,
            totalPrice REAL,
            FOREIGN KEY (orderId) REFERENCES orders (id) ON DELETE CASCADE
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute('ALTER TABLE orders ADD COLUMN date TEXT');
        }
      },
    );
  }

  Future<int> insertOrder(Order order) async {
    final db = await database;
    int orderId = await db.insert('orders', order.toMap());

    for (var item in order.items) {
      item.orderId = orderId;
      await db.insert('orderItems', item.toMap());
    }

    return orderId;
  }

  Future<List<Order>> getOrders() async {
    final db = await database;

    final orderMaps = await db.query('orders');
    final List<Order> orders = [];

    for (var orderMap in orderMaps) {
      final orderId = orderMap['id'] as int;
      final itemMaps = await db
          .query('orderItems', where: 'orderId = ?', whereArgs: [orderId]);

      final items =
          itemMaps.map((itemMap) => OrderItem.fromMap(itemMap)).toList();
      final order = Order.fromMap(orderMap, items);
      orders.add(order);
    }

    return orders;
  }
}

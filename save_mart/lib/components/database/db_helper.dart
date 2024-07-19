import 'dart:async';
import 'package:save_mart/models/order.dart';
import 'package:save_mart/models/product.dart';
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
      version: 6,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            customerName TEXT,
            totalAmount REAL,
            date TEXT,
            isCompleted INTEGER
          )
        ''');
        db.execute('''
          CREATE TABLE orderItems (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            orderId INTEGER,
            productName TEXT,
            productImage TEXT,
            quantity INTEGER,
            unitPrice REAL,
            totalPrice REAL,
            color INTEGER, 
            size TEXT,
            FOREIGN KEY (orderId) REFERENCES orders (id) ON DELETE CASCADE
          )
        ''');
        db.execute('''
          CREATE TABLE wishlist (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            productId TEXT,
            productName TEXT,
            productImage TEXT,
            price REAL,
            discountedPrice REAL,
            brand TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute('ALTER TABLE orders ADD COLUMN date TEXT');
        }
        if (oldVersion < 3) {
          db.execute('ALTER TABLE orderItems ADD COLUMN productImage TEXT');
        }
        if (oldVersion < 4) {
          db.execute('''
            CREATE TABLE wishlist (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              productId TEXT,
              productName TEXT,
              productImage TEXT,
              price REAL,
              discountedPrice REAL,
              brand TEXT
            )
          ''');
        }
        if (oldVersion < 5) {
          db.execute(
              'ALTER TABLE orders ADD COLUMN isCompleted INTEGER DEFAULT 0');
          db.execute('ALTER TABLE orderItems ADD COLUMN color TEXT');
          db.execute('ALTER TABLE orderItems ADD COLUMN size TEXT');
        }
        if (oldVersion < 6) {
          db.execute('''
          ALTER TABLE orderItems RENAME COLUMN color TO colorTemp
        ''');
          db.execute('''
          ALTER TABLE orderItems ADD COLUMN color INTEGER
        ''');
          db.execute('''
          UPDATE orderItems SET color = colorTemp
        ''');
          db.execute('''
          ALTER TABLE orderItems DROP COLUMN colorTemp
        ''');
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

  Future<int> insertWishlistItem(Product product) async {
    final db = await database;
    return await db.insert('wishlist', {
      'productId': product.id,
      'productName': product.name,
      'productImage': product.imageUrls[0],
      'price': product.price,
      'discountedPrice': product.discountedPrice,
      'brand': product.brand,
    });
  }

  Future<List<Product>> getWishlistItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('wishlist');

    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['productId'],
        name: maps[i]['productName'],
        imageUrls: [maps[i]['productImage']],
        price: maps[i]['price'],
        discountedPrice: maps[i]['discountedPrice'],
        brand: maps[i]['brand'],
        description: '',
        rating: 0,
        reviews: 0,
        colors: [],
        sizes: [],
        categories: [],
      );
    });
  }

  Future<void> removeWishlistItem(String productId) async {
    final db = await database;
    await db.delete(
      'wishlist',
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }
}

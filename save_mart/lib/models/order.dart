// models/order.dart

class Order {
  int? id;
  String customerName;
  double totalAmount;
  DateTime date;
  List<OrderItem> items;

  Order({
    this.id,
    required this.customerName,
    required this.totalAmount,
    required this.items,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'totalAmount': totalAmount,
      'date': date.toIso8601String(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map, List<OrderItem> items) {
    return Order(
      id: map['id'] as int?,
      customerName: map['customerName'] as String? ??
          '', // Provide a default value if null
      totalAmount: map['totalAmount'] as double? ??
          0.0, // Provide a default value if null
      date: DateTime.parse(map['date'] as String? ??
          DateTime.now().toIso8601String()), // Provide a default value if null
      items: items,
    );
  }
}

class OrderItem {
  int? id;
  int? orderId;
  String productName;
  int quantity;
  double unitPrice;
  double totalPrice;

  OrderItem({
    this.id,
    this.orderId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  }) : totalPrice = quantity * unitPrice;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'],
      orderId: map['orderId'],
      productName: map['productName'],
      quantity: map['quantity'],
      unitPrice: map['unitPrice'],
    )..totalPrice = map['totalPrice'];
  }
}

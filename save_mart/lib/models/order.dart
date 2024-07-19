import 'package:flutter/material.dart';

class Order {
  int? id;
  String customerName;
  double totalAmount;
  DateTime date;
  final bool isCompleted;
  List<OrderItem> items;

  Order({
    this.id,
    required this.customerName,
    required this.totalAmount,
    required this.items,
    required this.date,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'totalAmount': totalAmount,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map, List<OrderItem> items) {
    return Order(
      id: map['id'] as int?,
      customerName: map['customerName'] as String? ??
          '', // Provide a default value if null
      totalAmount: map['totalAmount'] as double? ??
          0.0, // Provide a default value if null
      date: DateTime.parse(
          map['date'] as String? ?? DateTime.now().toIso8601String()),
      items: items,
      isCompleted: map['isCompleted'] == 1,
    );
  }
}

class OrderItem {
  int? id;
  int? orderId;
  String productName;
  String productImage;
  int quantity;
  double unitPrice;
  double totalPrice;
  Color? color;
  String? size;

  OrderItem({
    this.id,
    this.orderId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.unitPrice,
    this.color,
    this.size,
  }) : totalPrice = quantity * unitPrice;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'productName': productName,
      'productImage': productImage,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'color': color?.value,
      'size': size,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'],
      orderId: map['orderId'],
      productName: map['productName'],
      productImage: map['productImage'],
      quantity: map['quantity'],
      unitPrice: map['unitPrice'],
      color: map['color'] != null ? Color(map['color']) : null,
      size: map['size'],
    )..totalPrice = map['totalPrice'];
  }
}

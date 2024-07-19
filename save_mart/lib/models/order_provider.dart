import 'package:flutter/material.dart';
import 'package:save_mart/components/database/db_helper.dart';
import 'order.dart';

class OrderProvider with ChangeNotifier {
  final DBHelper _dbHelper = DBHelper();

  List<Order> _completedOrders = [];

  List<Order> get completedOrders => _completedOrders;

  OrderProvider() {
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    _completedOrders = await _dbHelper.getOrders();
    notifyListeners();
  }

  Future<void> addOrder(Order order) async {
    await _dbHelper.insertOrder(order);
    await _fetchOrders();
  }
}

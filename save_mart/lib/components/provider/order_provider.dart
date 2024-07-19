import 'package:flutter/material.dart';
import 'package:save_mart/components/database/db_helper.dart';
import '../../models/order.dart';

class OrderProvider with ChangeNotifier {
  final DBHelper _dbHelper = DBHelper();

  List<Order> _activeOrders = [];
  List<Order> _completedOrders = [];

  List<Order> get activeOrders => _activeOrders;
  List<Order> get completedOrders => _completedOrders;

  OrderProvider() {
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final allOrders = await _dbHelper.getOrders();
    _activeOrders = allOrders.where((order) => !order.isCompleted).toList();
    _completedOrders = allOrders.where((order) => order.isCompleted).toList();
    notifyListeners();
  }

  Future<void> addOrder(Order order) async {
    await _dbHelper.insertOrder(order);
    await _fetchOrders();
  }
}

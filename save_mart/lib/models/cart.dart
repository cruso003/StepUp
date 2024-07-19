import 'package:flutter/material.dart';
import 'package:save_mart/models/product.dart';

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addProduct(Product product, int quantity, int size, Color? color) {
    final existingItemIndex = _items.indexWhere(
      (item) =>
          item.product == product && item.size == size && item.color == color,
    );

    if (existingItemIndex != -1) {
      _items[existingItemIndex].quantity += quantity;
    } else {
      _items.add(CartItem(product, quantity, size, color));
    }
    notifyListeners();
  }

  void removeProduct(CartItem item) {
    if (item.quantity > 1) {
      item.quantity -= 1;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  int getProductQuantity(CartItem item) {
    return item.quantity;
  }

  bool get isEmpty => _items.isEmpty;

  double get totalPrice {
    double total = 0.0;
    for (var item in _items) {
      total +=
          (item.product.discountedPrice ?? item.product.price) * item.quantity;
    }
    return total;
  }
}

class CartItem {
  final Product product;
  int quantity;
  final int size;
  final Color? color;

  CartItem(this.product, this.quantity, this.size, this.color);
}

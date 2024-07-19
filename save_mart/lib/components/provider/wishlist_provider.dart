import 'package:flutter/material.dart';
import 'package:save_mart/models/product.dart';
import 'package:save_mart/components/database/db_helper.dart';

class WishlistProvider with ChangeNotifier {
  Set<String> _wishlistProductIds = {};

  Set<String> get wishlistProductIds => _wishlistProductIds;

  WishlistProvider() {
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final dbHelper = DBHelper();
    List<Product> products = await dbHelper.getWishlistItems();
    _wishlistProductIds = products.map((product) => product.id).toSet();
    notifyListeners();
  }

  void toggleWishlist(Product product) async {
    final dbHelper = DBHelper();
    if (_wishlistProductIds.contains(product.id)) {
      await dbHelper.removeWishlistItem(product.id);
      _wishlistProductIds.remove(product.id);
    } else {
      await dbHelper.insertWishlistItem(product);
      _wishlistProductIds.add(product.id);
    }
    notifyListeners();
  }

  bool isInWishlist(String productId) {
    return _wishlistProductIds.contains(productId);
  }
}

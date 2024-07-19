import 'package:flutter/material.dart';

class Product {
  final String name;
  final double price;
  final double? discountedPrice;
  final List<String> imageUrls;
  final String description;
  final String brand;
  final double rating;
  final int reviews;
  final String id;
  final List<Color> colors;
  final List<int> sizes;
  final List<Category> categories;

  static Map<Color, String> colorNames = {
    Colors.red: 'Red',
    Colors.blue: 'Blue',
    Colors.yellow: 'Yellow',
    Colors.green: 'Green',
    Colors.orange: 'Orange',
    Colors.purple: 'Purple',
    Colors.black: 'Black',
    Colors.white: 'White',
  };

  Product({
    required this.name,
    required this.price,
    this.discountedPrice,
    required this.imageUrls,
    required this.description,
    required this.brand,
    required this.rating,
    required this.reviews,
    required this.id,
    required this.colors,
    required this.sizes,
    required this.categories,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<String> imageUrls = [];
    if (json['photos'] != null && json['photos'].isNotEmpty) {
      imageUrls = json['photos']
          .map<String>(
              (photo) => 'https://api.timbu.cloud/images/${photo['url']}')
          .toList();
    } else {
      imageUrls = [
        'https://www.smilemerchant.com/images/products/noImageProduct.jpg'
      ];
    }

    String description = json['description'] ?? '';
    String id = json['id'] ?? '';

    double price = 0.0;
    double? discountedPrice;

    if (json['current_price'] != null && json['current_price'].isNotEmpty) {
      var prices = json['current_price'][0]['USD'];
      if (prices != null && prices.isNotEmpty) {
        price = prices[0]?.toDouble() ?? 0.0;
        if (prices.length > 1 && prices[1] != null) {
          discountedPrice = prices[1]?.toDouble();
        }
      }
    }

    List<Category> categories = [];
    if (json['categories'] != null && json['categories'].isNotEmpty) {
      categories = (json['categories'] as List)
          .map((categoryJson) => Category.fromJson(categoryJson))
          .toList();
    }

    String brand = '';
    if (categories.isNotEmpty) {
      brand = capitalizeFirstLetter(categories[0].name);
    }

    List<Color> colors = [
      Colors.purple,
      Colors.orange,
      Colors.yellow,
      Colors.blue,
      Colors.red,
      Colors.black,
      Colors.white,
      Colors.green,
    ];

    List<int> sizes = [32, 35, 38, 39, 40, 42, 45];

    return Product(
      name: json['name'],
      price: price,
      discountedPrice: discountedPrice,
      imageUrls: imageUrls,
      description: description,
      brand: brand,
      rating: 4.5,
      reviews: 32,
      id: id,
      colors: colors,
      sizes: sizes,
      categories: categories,
    );
  }

  static String getColorName(Color color) {
    final colorMap = {
      Colors.red: 'Red',
      Colors.blue: 'Blue',
      Colors.yellow: 'Yellow',
      Colors.green: 'Green',
      Colors.orange: 'Orange',
      Colors.purple: 'Purple',
      Colors.black: 'Black',
      Colors.white: 'White',
    };

    // Check if the exact color is in the map
    if (colorMap.containsKey(color)) {
      return colorMap[color]!;
    }

    // Optionally check for close matches
    final colorValue = color.value;
    for (var entry in colorMap.entries) {
      if (entry.key.value == colorValue) {
        return entry.value;
      }
    }

    return '';
  }

  static String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }
}

class Category {
  final String name;

  Category({required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(name: json['name']);
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  final String baseUrl = 'https://api.timbu.cloud/products';
  final String organizationId = 'ee9e1bd4e82c4f49a70f4f46afcf22a4';
  final String appId = 'PYOTILU5Z17ULXM';
  final String apiKey = 'af727b8bc2f246078a3572adc0efa61220240706165806507484';

  Future<Map<String, List<Product>>> fetchProducts(int page, int size) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl?organization_id=$organizationId&Appid=$appId&Apikey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final items = jsonResponse['items'] as List;
      final products = items.map((item) => Product.fromJson(item)).toList();

      List<Product> featuredProducts = [];
      List<Product> recommendedProducts = [];
      List<Product> specialOfferProducts = [];

      for (var product in products) {
        if (product.description.contains('#Featured')) {
          featuredProducts.add(product);
        }
        if (product.description.contains('#Recommended')) {
          recommendedProducts.add(product);
        }
        if (product.description.contains('#SpecialOffer')) {
          specialOfferProducts.add(product);
        }
      }

      return {
        'featured': featuredProducts,
        'recommended': recommendedProducts,
        'specialOffer': specialOfferProducts,
      };
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Product>> fetchProductsByCategory(String categoryName) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl?organization_id=$organizationId&Appid=$appId&Apikey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final items = jsonResponse['items'] as List;
      final products = items.map((item) => Product.fromJson(item)).toList();

      return products
          .where((product) => product.categories.any((category) =>
              category.name.toLowerCase() == categoryName.toLowerCase()))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}

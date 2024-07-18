import 'package:flutter/material.dart';
import 'package:save_mart/components/product_details_screen.dart';
import 'package:save_mart/services/api_services.dart';
import '../models/product.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late Future<List<Product>> futureProducts;
  Set<String> wishlistedProductIds = {};
  List<Product> products = [];
  int currentPage = 1;
  final int pageSize = 10;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    setState(() {
      isLoadingMore = true;
    });
    List<Product> newProducts =
        await ApiService().fetchAllProducts(currentPage, pageSize);
    setState(() {
      products.addAll(newProducts);
      currentPage++;
      isLoadingMore = false;
    });
  }

  void toggleWishlist(String productId) {
    setState(() {
      if (wishlistedProductIds.contains(productId)) {
        wishlistedProductIds.remove(productId);
      } else {
        wishlistedProductIds.add(productId);
      }
    });
  }

  void navigateToProductDetails(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductDetailsScreen(product: product)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'All Products',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount:
                  products.length + 1, // Add one for the "View More" button
              itemBuilder: (context, index) {
                if (index == products.length) {
                  // "View More" button
                  return Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: fetchProducts,
                      child: const Text('View More'),
                    ),
                  );
                }
                return _buildProductCard(products[index]);
              },
            ),
          ),
          if (isLoadingMore) const CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    navigateToProductDetails(product);
                  },
                  child: Image.network(
                    product.imageUrls[0],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/noImage.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      wishlistedProductIds.contains(product.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: wishlistedProductIds.contains(product.id)
                          ? Colors.red
                          : Colors.grey,
                    ),
                    onPressed: () {
                      toggleWishlist(product.id);
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.brand, style: const TextStyle(fontSize: 12)),
                Text(product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 16),
                    Text('4.5 (100 sold)', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.discountedPrice != null)
                          Text(
                            '₦${product.discountedPrice!.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              color: product.discountedPrice != null
                                  ? Colors.blue.shade900
                                  : Colors.grey,
                            ),
                          ),
                        const SizedBox(width: 8),
                        Text(
                          '₦${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: product.discountedPrice == null
                                ? Colors.blue.shade900
                                : Colors.grey,
                            decoration: product.discountedPrice == null
                                ? TextDecoration.none
                                : TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        navigateToProductDetails(product);
                      },
                      child: const Icon(Icons.shopping_cart),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

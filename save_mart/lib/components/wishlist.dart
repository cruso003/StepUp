import 'package:flutter/material.dart';
import 'package:save_mart/components/database/db_helper.dart';
import 'package:save_mart/components/products_page.dart';
import 'package:save_mart/models/product.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<Product> wishlistItems = [];

  @override
  void initState() {
    super.initState();
    _fetchWishlistItems();
  }

  Future<void> _fetchWishlistItems() async {
    final dbHelper = DBHelper();
    List<Product> products = await dbHelper.getWishlistItems();
    setState(() {
      wishlistItems = products;
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite_border,
            size: 100,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'You have not added any item to your wish list',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductsPage(),
                ),
              );
            },
            child: const Text('Discover products'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: wishlistItems.isEmpty
          ? _buildEmptyState()
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 0.75,
              ),
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                final product = wishlistItems[index];
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.brand,
                                style: const TextStyle(fontSize: 12)),
                            Text(product.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const Row(
                              children: [
                                Icon(Icons.star,
                                    color: Colors.orange, size: 16),
                                Text('4.5 (100 sold)',
                                    style: TextStyle(fontSize: 12)),
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
                                        decoration:
                                            product.discountedPrice == null
                                                ? TextDecoration.none
                                                : TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    await DBHelper()
                                        .removeWishlistItem(product.id);
                                    setState(() {
                                      wishlistItems.remove(product);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

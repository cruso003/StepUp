import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_mart/components/brand_product_page.dart';
import 'package:save_mart/components/card/product_card.dart';
import 'package:save_mart/components/products_page.dart';
import 'package:save_mart/components/provider/wishlist_provider.dart';
import 'package:save_mart/components/wishlist.dart';
import 'package:save_mart/services/api_services.dart';
import '../models/product.dart';
import 'product_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, List<Product>>> futureProducts;
  int _currentCarouselIndex = 0;
  Set<String> wishlistedProductIds = {};

  @override
  void initState() {
    super.initState();
    futureProducts = ApiService().fetchProducts(1, 10);
  }

  void navigateToProductDetails(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductDetailsScreen(product: product)),
    );
  }

  void showAllBrands(BuildContext context, Map<String, String> brandImages) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('All Brands'),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: brandImages.keys.map((brandName) {
                return _buildBrandIcon(brandName);
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('SaveMart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WishlistPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                        'https://cdn2.stylecraze.com/wp-content/uploads/2019/02/Tufted-TWA-1.jpg.webp'),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good afternoon 👋', style: TextStyle(fontSize: 16)),
                      Text('Ada Dennis',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              FutureBuilder<Map<String, List<Product>>>(
                future: futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No products found'));
                  } else {
                    final products = snapshot.data!;
                    final brandImages = {
                      'Nike': 'assets/images/nike.png',
                      'Gucci': 'assets/images/gucci.png',
                      'Jordan': 'assets/images/jordan.png',
                      'Balenciaga': 'assets/images/balen.png',
                      'Adidas': 'assets/images/addidas.png',
                      'Reebok': 'assets/images/rb.png',
                      'New Balance': 'assets/images/nb.png',
                      'Puma': 'assets/images/puma.jpg',
                      'Converse': 'assets/images/converse.jpg',
                      'Asics': 'assets/images/asics.jpg'
                    };
                    final displayedBrands = brandImages.keys.take(7).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCarousel(products['recommended']!),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 10.0,
                          runSpacing: 10.0,
                          children: [
                            ...displayedBrands.map((brandName) {
                              return _buildBrandIcon(brandName);
                            }),
                            GestureDetector(
                              onTap: () {
                                showAllBrands(context, brandImages);
                              },
                              child: const Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    child: Text('All'),
                                  ),
                                  SizedBox(height: 5),
                                  Text('View All'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildSectionTitle('Our Special Offers'),
                        _buildProductList(
                            products['specialOffer']!, wishlistProvider),
                        const SizedBox(height: 20),
                        _buildSectionTitle('Featured Sneakers'),
                        _buildProductList(
                            products['featured']!, wishlistProvider),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProductsPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade900,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('View more'),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandIcon(String brandName) {
    Widget brandIcon;

    Map<String, String> brandImages = {
      'Nike': 'assets/images/nike.png',
      'Gucci': 'assets/images/gucci.png',
      'Jordan': 'assets/images/jordan.png',
      'Balenciaga': 'assets/images/balen.png',
      'Adidas': 'assets/images/addidas.png',
      'Reebok': 'assets/images/rb.png',
      'New Balance': 'assets/images/nb.png',
      'Puma': 'assets/images/puma.jpg',
      'Converse': 'assets/images/converse.jpg',
      'Asics': 'assets/images/asics.jpg'
    };

    if (brandImages.containsKey(brandName)) {
      brandIcon = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: ClipOval(
          child: Image.asset(
            brandImages[brandName]!,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      brandIcon = CircleAvatar(
        radius: 30,
        child: Text(brandName[0]),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BrandProductsPage(brandName: brandName),
          ),
        );
      },
      child: Column(
        children: [
          brandIcon,
          const SizedBox(height: 5),
          Text(brandName),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildProductList(
      List<Product> products, WishlistProvider wishlistProvider) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2 / 3,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ChangeNotifierProvider.value(
          value: Provider.of<WishlistProvider>(context),
          child: ProductCard(
            product: product,
          ),
        );
      },
    );
  }

  Widget _buildCarousel(List<Product> products) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 220.0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentCarouselIndex = index;
                  });
                },
              ),
              items: products.map((product) {
                return GestureDetector(
                  onTap: () {
                    navigateToProductDetails(product);
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.lightBlue,
                          Colors.blue.shade900,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              product.imageUrls[0],
                              fit: BoxFit.cover,
                              width: 150.0,
                              height: 150.0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  product.brand,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '₦${product.discountedPrice != null ? product.discountedPrice!.toStringAsFixed(2) : product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    navigateToProductDetails(product);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.shopping_cart,
                                          color:
                                              Color.fromRGBO(13, 71, 161, 1)),
                                      SizedBox(width: 4),
                                      Text(
                                        'Add to cart',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(13, 71, 161, 1)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            Positioned(
              bottom: 10.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: products.map((product) {
                  int index = products.indexOf(product);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentCarouselIndex == index
                          ? Colors.blue
                          : Colors.grey[300],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

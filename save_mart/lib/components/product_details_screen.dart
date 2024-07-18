import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_mart/components/cart_page.dart';
import 'package:save_mart/models/cart.dart';
import 'package:save_mart/services/api_services.dart';
import '../models/product.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  ApiService apiService = ApiService();
  List<Product> relatedProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchRelatedProducts();
  }

  Future<void> _fetchRelatedProducts() async {
    print('Fetching related products for: ${widget.product}');
    try {
      List<Product> products =
          await apiService.fetchProductsByCategory(widget.product.brand);
      setState(() {
        relatedProducts = products;
      });

      // Debug print to verify fetched products
      print('Fetched ${products.length} related products:');
      products.forEach((product) {
        print('${product.name} - ${product.brand}');
      });
    } catch (e) {
      print('Error fetching related products: $e');
    }
  }

  Set<String> wishlistedProductIds = {};
  int quantity = 1;
  int selectedSize = 0;
  Color? selectedColor;
  int _currentCarouselIndex = 0;

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
    // Reset selectedSize and selectedColor when navigating to a new product
    setState(() {
      selectedSize = 0; // Reset to default size (or appropriate initial value)
      selectedColor = null; // Reset to default color (or null)
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(product: product),
      ),
    );
  }

  void addToCart(Product product) {
    final cart = Provider.of<CartModel>(context, listen: false);
    print(
        'Adding to cart: $product, Quantity: $quantity, Size: $selectedSize, Color: $selectedColor');
    cart.addProduct(product, quantity, selectedSize, selectedColor);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(),
      ),
    );
  }

  Widget _buildMoreProductCard(Product product) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carousel slider
              CarouselSlider(
                options: CarouselOptions(
                  height: 250.0,
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
                items: widget.product.imageUrls.map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  );
                }).toList(),
              ),
              Positioned(
                bottom: 10.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      widget.product.imageUrls.asMap().entries.map((entry) {
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.blue.shade900)
                            .withOpacity(
                                _currentCarouselIndex == entry.key ? 0.9 : 0.4),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.product.brand,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.red),
                    onPressed: () {
                      // Handle wishlist toggle
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.product.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (widget.product.discountedPrice != null)
                    Text(
                      '₦${widget.product.discountedPrice!.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  const SizedBox(width: 8),
                  Text(
                    '₦${widget.product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.product.discountedPrice == null
                          ? Colors.blue.shade900
                          : Colors.grey,
                      decoration: widget.product.discountedPrice == null
                          ? TextDecoration.none
                          : TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 16),
                  Text(
                    '${widget.product.rating} (${widget.product.reviews} reviews)',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Description',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(widget.product.description),
              const SizedBox(height: 16),
              const Text(
                'Size',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: widget.product.sizes.map((size) {
                  return ChoiceChip(
                    label: Text(size.toString()),
                    selected: selectedSize == size,
                    onSelected: (selected) {
                      setState(() {
                        selectedSize = size;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                'Colours',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: widget.product.colors.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: color,
                      child: selectedColor == color
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                'Quantity',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: quantity > 1
                        ? () {
                            setState(() {
                              quantity--;
                            });
                          }
                        : null,
                  ),
                  Text(quantity.toString()),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'More Products',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              relatedProducts.isEmpty
                  ? const Text('No related products found.')
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: relatedProducts.length,
                      itemBuilder: (context, index) {
                        final product = relatedProducts[index];
                        return _buildMoreProductCard(product);
                      },
                    ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total price: ₦${widget.product.discountedPrice != null ? widget.product.discountedPrice!.toStringAsFixed(2) : widget.product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      addToCart(widget.product);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_cart),
                        SizedBox(width: 4),
                        Text('Add to cart'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

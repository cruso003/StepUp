import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_mart/models/cart.dart';
import 'package:save_mart/models/product.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    double totalPrice = cart.totalPrice;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        titleTextStyle: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      body: cart.isEmpty
          ? const Center(
              child: Text('Your cart is empty'),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = cart.items[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Card(
                              margin: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Image.network(
                                      cartItem.product.imageUrls[0],
                                      width: 110,
                                      height: 110,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cartItem.product.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              if (cartItem.color != null)
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: cartItem.color,
                                                    shape: BoxShape.rectangle,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              const SizedBox(width: 5),
                                              Text(
                                                Product.getColorName(
                                                    cartItem.color ??
                                                        Colors.transparent),
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                              const SizedBox(width: 5),
                                              const Text("|"),
                                              const SizedBox(width: 5),
                                              Text(
                                                'Size: ${cartItem.size}',
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      iconSize: 16,
                                                      icon: const Icon(
                                                          Icons.remove),
                                                      onPressed: () {
                                                        cart.removeProduct(
                                                            cartItem);
                                                      },
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 30,
                                                      width: 30,
                                                      color:
                                                          Colors.blue.shade100,
                                                      child: Text(
                                                        '${cart.getProductQuantity(cartItem)}',
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.blue),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      iconSize: 16,
                                                      icon:
                                                          const Icon(Icons.add),
                                                      onPressed: () {
                                                        cart.addProduct(
                                                          cartItem.product,
                                                          1,
                                                          cartItem.size,
                                                          cartItem.color,
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  '₦${(cartItem.product.discountedPrice != null ? cartItem.product.discountedPrice! : cartItem.product.price) * cart.getProductQuantity(cartItem)}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 5.5,
                              right: 5.5,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  size: 30,
                                ),
                                onPressed: () {
                                  cart.removeProduct(cartItem);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total price: ₦${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckoutPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade900,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Checkout',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

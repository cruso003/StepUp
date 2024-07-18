import 'package:flutter/material.dart';
import 'package:save_mart/models/cart.dart';
import 'package:save_mart/models/product.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Order List Section
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Order List',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      // Implement navigation back to the cart page
                      Navigator.pop(context);
                    },
                    child: const Text('Edit'),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final cartItem = cart.items[index];
                final quantity = cart.getProductQuantity(cartItem);
                return ListTile(
                  leading: Image.network(cartItem.product.imageUrls[0]),
                  title: Text(cartItem.product.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (cartItem.color != null)
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: cartItem.color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          const SizedBox(width: 5),
                          Text(
                            Product.getColorName(
                                cartItem.color ?? Colors.transparent),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 5),
                          const Text('|'),
                          const SizedBox(width: 5),
                          Text('Size: ${cartItem.size}'),
                        ],
                      ),
                      Text(
                          '₦${(cartItem.product.discountedPrice ?? cartItem.product.price) * quantity}'),
                    ],
                  ),
                  trailing: Text('x$quantity'),
                );
              },
            ),
            // Personal Information Section
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Personal information',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {
                          // Implement edit functionality
                        },
                        child: const Text('Edit'),
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.grey[200],
                    padding: const EdgeInsets.all(8.0),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ada Dennis'),
                        Text('ad@gmail.com'),
                        Text('09100000000'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Delivery Option Section
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Delivery option',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {
                          // Implement edit functionality
                        },
                        child: const Text('Edit'),
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.grey[200],
                    padding: const EdgeInsets.all(8.0),
                    child: const Text('Pick up point\nIkeja, Lagos'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Price summary'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total price'),
                      Text('₦${cart.totalPrice.toStringAsFixed(2)}'),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delivery fee'),
                      Text('₦1,550.00'),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Discount'),
                      Text('₦0.00'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₦${(cart.totalPrice + 1550).toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement proceed functionality
                      },
                      child: const Text('Proceed'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

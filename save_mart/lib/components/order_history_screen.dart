import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_mart/components/order_details_screen.dart';
import 'package:save_mart/components/products_page.dart';
import 'package:save_mart/models/order_provider.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final completedOrders = orderProvider.completedOrders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: completedOrders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_basket,
                    size: 100,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No Orders Yet',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Browse products and start order. Delivery fee is free for your first order!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductsPage(),
                        ),
                      );
                    },
                    child: const Text('Start Shopping'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: completedOrders.length,
              itemBuilder: (context, index) {
                final order = completedOrders[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: const Icon(Icons.receipt_long, color: Colors.blue),
                    title: Text(
                      'Order #${order.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total: \$${order.totalAmount.toStringAsFixed(2)}',
                        ),
                        Text(
                          'Date: ${DateFormat('yyyy-MM-dd – kk:mm').format(order.date)}',
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrderDetailsScreen(order: order),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

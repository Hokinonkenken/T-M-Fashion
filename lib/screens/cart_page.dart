import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/common_drawer.dart';
import '../providers/cart_provider.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      drawer: CommonDrawer(),
      body: Consumer<CartProvider>(
        builder: (ctx, cart, child) => ListView(
          children: [
            ...cart.items.values.map((item) => ListTile(
                  title: Text(item.name),
                  subtitle: Text(
                      '${item.quantity} x \$${item.price.toStringAsFixed(2)}'),
                  trailing: Text(
                      '\$${(item.price * item.quantity).toStringAsFixed(2)}'),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Size: ${item.size}'),
                      Text('Color: ${item.color}'),
                    ],
                  ),
                )),
            Divider(),
            ListTile(
              title:
                  Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: Text('\$${cart.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              child: Text('Proceed to Checkout'),
              onPressed: cart.itemCount == 0
                  ? null
                  : () {
                      Navigator.of(context).pushNamed('/payment');
                    },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _paymentMethod = 'credit';

  // These would typically be handled by a payment processing library
  void _processCreditCardPayment() {
    // Implement credit card payment logic
    print('Processing credit card payment');
  }

  void _processApplePay() {
    // Implement Apple Pay logic
    print('Processing Apple Pay payment');
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Amount: \$${cart.totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Select Payment Method:', style: TextStyle(fontSize: 18)),
            RadioListTile(
              title: Text('Credit Card'),
              value: 'credit',
              groupValue: _paymentMethod,
              onChanged: (value) {
                setState(() {
                  _paymentMethod = value.toString();
                });
              },
            ),
            RadioListTile(
              title: Text('Apple Pay'),
              value: 'apple',
              groupValue: _paymentMethod,
              onChanged: (value) {
                setState(() {
                  _paymentMethod = value.toString();
                });
              },
            ),
            SizedBox(height: 20),
            if (_paymentMethod == 'credit')
              Column(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Card Number'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: 'Expiry Date'),
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: 'CVV'),
                          keyboardType: TextInputType.number,
                          obscureText: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Pay Now'),
              onPressed: () async {
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Center(child: CircularProgressIndicator());
                  },
                );

                // Process payment
                if (_paymentMethod == 'credit') {
                  _processCreditCardPayment();
                } else {
                  _processApplePay();
                }

                // Simulate payment processing delay
                await Future.delayed(Duration(seconds: 2));

                // Close loading indicator
                Navigator.of(context).pop();

                // Clear the cart
                await cart.checkout();

                // Show success message and navigate back to home
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Payment successful!')),
                );
                Navigator.of(context).pushReplacementNamed('/home');
              },
            ),
          ],
        ),
      ),
    );
  }
}

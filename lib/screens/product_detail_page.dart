import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  ProductDetailPage({required this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String? _selectedSize;

  void _selectSize() {
    List<String> sizes = (widget.product['size'] as List<dynamic>)
        .map((e) => e.toString())
        .toList();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Size'),
          content: SingleChildScrollView(
            child: ListBody(
              children: sizes.map((size) {
                return ListTile(
                  title: Text(size),
                  onTap: () {
                    setState(() {
                      _selectedSize = size;
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product['name'])),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.product['image_url']),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.product['name'],
                      style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 8),
                  Text('\$${widget.product['price']}',
                      style: TextStyle(fontSize: 20, color: Colors.green)),
                  SizedBox(height: 16),
                  Text(widget.product['description'] ??
                      'No description available.'),
                  SizedBox(height: 16),
                  Text('Color: ${widget.product['color']}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    child: Text(_selectedSize ?? 'Select Size'),
                    onPressed: _selectSize,
                  ),
                  SizedBox(height: 16),
                  Consumer<CartProvider>(
                    builder: (ctx, cart, _) => ElevatedButton(
                      child: Text('Add to Cart'),
                      onPressed: _selectedSize == null
                          ? null
                          : () {
                              cart.addItem(
                                widget.product['id'],
                                widget.product['name'],
                                widget.product['price'],
                                size: _selectedSize!,
                                color: widget.product['color'],
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Added item to cart')),
                              );
                            },
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

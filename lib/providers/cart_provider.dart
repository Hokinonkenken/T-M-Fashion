import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final String size;
  final String color;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.size,
    required this.color,
    this.quantity = 1,
  });
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.values
        .fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  void addItem(String productId, String name, double price,
      {required String size, required String color}) {
    if (_items.containsKey(productId)) {
      // If the item exists, increase the quantity
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          name: existingItem.name,
          price: existingItem.price,
          size: existingItem.size,
          color: existingItem.color,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      // If the item doesn't exist, add a new item
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: productId,
          name: name,
          price: price,
          size: size,
          color: color,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  // Added method for checkout functionality
  Future<void> checkout() async {
    // Implement your checkout logic here
    // For example, you might want to send the order to a server
    // and process payment

    // For now, we'll just clear the cart after a delay
    await Future.delayed(Duration(seconds: 2)); // Simulate network request
    clear();
  }
}

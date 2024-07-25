import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/common_drawer.dart';
import '../widgets/bottom_nav_bar.dart';
import '../services/product_service.dart';
import '../providers/cart_provider.dart';
import 'product_detail_page.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Map<String, dynamic>> _products = [];
  String? _selectedCategory;
  RangeValues _priceRange = RangeValues(0, 100);
  Map<String, String> _selectedSizes = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });
    await ProductService.loadProducts(); // Ensure this method is asynchronous
    setState(() {
      _products = ProductService.getAllProducts();
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      setState(() {
        _selectedCategory = args;
        _filterProducts();
      });
    }
  }

  void _filterProducts() {
    final allProducts = ProductService.getAllProducts();
    setState(() {
      _products = allProducts.where((product) {
        final price = product['price'] as double;
        final matchesCategory = _selectedCategory == null ||
            product['category'] == _selectedCategory;
        final matchesPrice =
            price >= _priceRange.start && price <= _priceRange.end;
        return matchesCategory && matchesPrice;
      }).toList();
    });
  }

  void _selectSize(String productId) {
    final product = _products.firstWhere((p) => p['id'] == productId);
    List<String> sizes =
        (product['size'] as List<dynamic>).map((e) => e.toString()).toList();
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
                      _selectedSizes[productId] = size;
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
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/filters')
                  as Map<String, dynamic>?;
              if (result != null) {
                setState(() {
                  _priceRange = result['priceRange'] as RangeValues;
                  _selectedCategory = result['categories'].isNotEmpty
                      ? result['categories'][0]
                      : null;
                  _filterProducts();
                });
              }
            },
          ),
        ],
      ),
      drawer: CommonDrawer(),
      body: RefreshIndicator(
        onRefresh: _loadProducts,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _products.isEmpty
                ? Center(child: Text('No products found'))
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailPage(product: product),
                            ),
                          );
                        },
                        child: Card(
                          child: Column(
                            children: [
                              Image.network(
                                product['image_url'],
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 100,
                                    color: Colors.grey[300],
                                    child: Icon(Icons.error),
                                  );
                                },
                              ),
                              Text(product['name']),
                              Text('\$${product['price']}'),
                              ElevatedButton(
                                child: Text(_selectedSizes[product['id']] ??
                                    'Select Size'),
                                onPressed: () => _selectSize(product['id']),
                              ),
                              Consumer<CartProvider>(
                                builder: (ctx, cart, _) => ElevatedButton(
                                  child: Text('Add to Cart'),
                                  onPressed: _selectedSizes[product['id']] ==
                                          null
                                      ? null
                                      : () {
                                          cart.addItem(
                                            product['id'],
                                            product['name'],
                                            product['price'],
                                            size:
                                                _selectedSizes[product['id']]!,
                                            color: product['color'],
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content:
                                                    Text('Added item to cart')),
                                          );
                                        },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}

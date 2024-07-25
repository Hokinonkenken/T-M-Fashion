import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/sign_in_page.dart';
import 'screens/home_page.dart';
import 'screens/products_page.dart';
import 'screens/store_page.dart';
import 'screens/cart_page.dart';
import 'screens/product_detail_page.dart';
import 'screens/filters_page.dart';
import 'screens/payment_page.dart';
import 'services/product_service.dart';
import 'providers/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProductService.loadProducts();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => CartProvider(),
      child: MaterialApp(
        title: 'T&M',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/sign_in',
        routes: {
          '/sign_in': (context) => SignInPage(),
          '/home': (context) => HomePage(),
          '/products': (context) => ProductsPage(),
          '/store': (context) => StorePage(),
          '/cart': (context) => CartPage(),
          '/product_detail': (context) => ProductDetailPage(
                product: ModalRoute.of(context)!.settings.arguments
                    as Map<String, dynamic>,
              ),
          '/filters': (context) => FiltersPage(),
          '/payment': (context) => PaymentPage(),
        },
      ),
    );
  }
}

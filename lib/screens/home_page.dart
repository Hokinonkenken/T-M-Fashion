import 'package:flutter/material.dart';
import '../widgets/common_drawer.dart';
import '../widgets/bottom_nav_bar.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('T&M Fashion', style: TextStyle(fontSize: 24)),
      ),
      drawer: CommonDrawer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/store_background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome',
                style: TextStyle(
                    fontSize: 50,
                    color: const Color.fromARGB(255, 242, 4, 4),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                child: Text('Shop Now'),
                onPressed: () {
                  Navigator.pushNamed(context, '/products');
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}

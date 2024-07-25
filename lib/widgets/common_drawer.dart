import 'package:flutter/material.dart';

class CommonDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.purple),
            child: Text('T&M Fashion',
                style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('Products'),
            onTap: () => Navigator.pushReplacementNamed(context, '/products'),
          ),
          ListTile(
            leading: Icon(Icons.store),
            title: Text('Store'),
            onTap: () => Navigator.pushReplacementNamed(context, '/store'),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Cart'),
            onTap: () => Navigator.pushReplacementNamed(context, '/cart'),
          ),
          ListTile(
            leading: Icon(Icons.login),
            title: Text('Sign In'),
            onTap: () => Navigator.pushNamed(context, '/sign_in'),
          ),
        ],
      ),
    );
  }
}

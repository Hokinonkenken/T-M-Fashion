import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  final List<String> categories = [
    'T-shirts',
    'Hoodies',
    'Pants',
    'Shoes',
    'Accessories'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(categories[index]),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to category specific products
            },
          );
        },
      ),
    );
  }
}

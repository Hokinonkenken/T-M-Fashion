import 'package:flutter/material.dart';
import '../widgets/common_drawer.dart';

class PlaceholderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Placeholder')),
      drawer: CommonDrawer(),
      body: Center(
        child: Text('This page is not yet implemented'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/common_drawer.dart';
import 'dart:math' as math;

class StorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Store')),
      drawer: CommonDrawer(),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.store),
            title: Text('My Store'),
            subtitle: Text('View store location'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => StoreMapPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('My Orders'),
            subtitle: Text('View cart items'),
            onTap: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }
}

class StoreMapPage extends StatefulWidget {
  @override
  _StoreMapPageState createState() => _StoreMapPageState();
}

class _StoreMapPageState extends State<StoreMapPage> {
  Offset? _userLocation;
  bool _showPath = false;
  final Offset _storeLocation = Offset(150, 150); // Center of our map
  List<Offset> _routePoints = [];

  void _handleTap(TapDownDetails details) {
    setState(() {
      _userLocation = details.localPosition;
      _showPath = true;
      _generateRoute();
    });
  }

  void _generateRoute() {
    if (_userLocation == null) return;

    _routePoints = [];
    Offset currentPoint = _userLocation!;
    _routePoints.add(currentPoint);

    while ((currentPoint - _storeLocation).distance > 20) {
      double dx = _storeLocation.dx - currentPoint.dx;
      double dy = _storeLocation.dy - currentPoint.dy;

      if (dx.abs() > dy.abs()) {
        currentPoint += Offset(dx.sign * 20, 0);
      } else {
        currentPoint += Offset(0, dy.sign * 20);
      }

      _routePoints.add(currentPoint);
    }

    _routePoints.add(_storeLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Local Store')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTapDown: _handleTap,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: GridPainter(),
                      ),
                    ),
                    if (_showPath && _userLocation != null)
                      CustomPaint(
                        painter: RoutePainter(_routePoints),
                      ),
                    Positioned(
                      left: _storeLocation.dx - 25,
                      top: _storeLocation.dy - 25,
                      child: Icon(
                        Icons.store,
                        color: Colors.red,
                        size: 50,
                      ),
                    ),
                    if (_userLocation != null)
                      Positioned(
                        left: _userLocation!.dx - 12,
                        top: _userLocation!.dy - 12,
                        child: Icon(
                          Icons.person_pin_circle,
                          color: Colors.blue,
                          size: 24,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Store Location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Mong Kok, Hong Kong'),
          ],
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;

    for (int i = 0; i < size.width; i += 20) {
      canvas.drawLine(
          Offset(i.toDouble(), 0), Offset(i.toDouble(), size.height), paint);
    }

    for (int i = 0; i < size.height; i += 20) {
      canvas.drawLine(
          Offset(0, i.toDouble()), Offset(size.width, i.toDouble()), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class RoutePainter extends CustomPainter {
  final List<Offset> points;

  RoutePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();

    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

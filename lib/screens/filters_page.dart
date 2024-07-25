import 'package:flutter/material.dart';
import '../widgets/common_drawer.dart';

class FiltersPage extends StatefulWidget {
  @override
  _FiltersPageState createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  RangeValues _priceRange = RangeValues(0, 100);
  List<String> _selectedCategories = [];

  void _clearFilters() {
    setState(() {
      _priceRange = RangeValues(0, 100);
      _selectedCategories.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: _clearFilters,
            tooltip: 'Clear Filters',
          ),
        ],
      ),
      drawer: CommonDrawer(),
      body: ListView(
        children: [
          ListTile(title: Text('Price Range')),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 100,
            divisions: 10,
            labels: RangeLabels('\$${_priceRange.start.toStringAsFixed(2)}',
                '\$${_priceRange.end.toStringAsFixed(2)}'),
            onChanged: (RangeValues values) {
              setState(() {
                _priceRange = values;
              });
            },
          ),
          ListTile(title: Text('Categories')),
          Wrap(
            children: ['T-shirts', 'Pants', 'Hoodies', 'Shoes', 'Accessories']
                .map((category) {
              return FilterChip(
                label: Text(category),
                selected: _selectedCategories.contains(category),
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      _selectedCategories.add(category);
                    } else {
                      _selectedCategories.remove(category);
                    }
                  });
                },
              );
            }).toList(),
          ),
          ElevatedButton(
            child: Text('Search'),
            onPressed: () {
              // Apply filters and return to products page
              Navigator.pop(context, {
                'priceRange': _priceRange,
                'categories': _selectedCategories,
              });
            },
          ),
        ],
      ),
    );
  }
}

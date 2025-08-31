import 'package:flutter/material.dart';

class ShoppingCategory {
  final String name;
  final String displayName;
  final IconData icon;
  final Color color;

  const ShoppingCategory({
    required this.name,
    required this.displayName,
    required this.icon,
    required this.color,
  });

  static const List<ShoppingCategory> _categories = [
    ShoppingCategory(
      name: 'dairy',
      displayName: 'Dairy',
      icon: Icons.local_drink,
      color: Colors.blue,
    ),
    ShoppingCategory(
      name: 'meat',
      displayName: 'Meat',
      icon: Icons.restaurant,
      color: Colors.red,
    ),
    ShoppingCategory(
      name: 'vegetables',
      displayName: 'Vegetables',
      icon: Icons.eco,
      color: Colors.green,
    ),
    ShoppingCategory(
      name: 'fruits',
      displayName: 'Fruits',
      icon: Icons.apple,
      color: Colors.orange,
    ),
    ShoppingCategory(
      name: 'bakery',
      displayName: 'Bakery',
      icon: Icons.cake,
      color: Colors.brown,
    ),
    ShoppingCategory(
      name: 'beverages',
      displayName: 'Beverages',
      icon: Icons.local_cafe,
      color: Colors.purple,
    ),
    ShoppingCategory(
      name: 'snacks',
      displayName: 'Snacks',
      icon: Icons.fastfood,
      color: Colors.amber,
    ),
    ShoppingCategory(
      name: 'grains',
      displayName: 'Grains',
      icon: Icons.grain,
      color: Colors.yellow,
    ),
    ShoppingCategory(
      name: 'frozen',
      displayName: 'Frozen',
      icon: Icons.ac_unit,
      color: Colors.lightBlue,
    ),
    ShoppingCategory(
      name: 'canned',
      displayName: 'Canned',
      icon: Icons.kitchen,
      color: Colors.grey,
    ),
    ShoppingCategory(
      name: 'personal_care',
      displayName: 'Personal Care',
      icon: Icons.face_retouching_natural,
      color: Colors.pink,
    ),
    ShoppingCategory(
      name: 'household',
      displayName: 'Household',
      icon: Icons.home,
      color: Colors.indigo,
    ),
    ShoppingCategory(
      name: 'other',
      displayName: 'Other',
      icon: Icons.shopping_bag,
      color: Colors.grey,
    ),
  ];

  static List<ShoppingCategory> get allCategories => _categories;

  static ShoppingCategory fromString(String? category) {
    if (category == null) return _categories.last; // Default to 'Other'
    
    for (var cat in _categories) {
      if (cat.name.toLowerCase() == category.toLowerCase() ||
          cat.displayName.toLowerCase() == category.toLowerCase()) {
        return cat;
      }
    }
    return _categories.last; // Default to 'Other'
  }

  static IconData getIconForCategory(String? category) {
    return fromString(category).icon;
  }

  static Color getColorForCategory(String? category) {
    return fromString(category).color;
  }

  static List<String> get categoryNames => 
      _categories.map((cat) => cat.displayName).toList();

  static String getDisplayName(String? category) {
    return fromString(category).displayName;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingCategory &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

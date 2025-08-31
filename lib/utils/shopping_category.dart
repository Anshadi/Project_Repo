import 'package:flutter/material.dart';

enum ShoppingCategory {
  fruits('Fruits', '🍎'),
  vegetables('Vegetables', '🥬'),
  dairy('Dairy', '🥛'),
  meat('Meat', '🥩'),
  seafood('Seafood', '🐟'),
  bakery('Bakery', '🍞'),
  beverages('Beverages', '🥤'),
  snacks('Snacks', '🍿'),
  condiments('Condiments', '🧂'),
  spices('Spices', '🌶️'),
  grains('Grains', '🌾'),
  household('Household', '🧽'),
  personalCare('Personal Care', '🧴'),
  health('Health', '💊'),
  baby('Baby', '🍼'),
  general('General', '🛒');

  const ShoppingCategory(this.displayName, this.emoji);

  final String displayName;
  final String emoji;

  static ShoppingCategory fromString(String categoryName) {
    for (ShoppingCategory category in ShoppingCategory.values) {
      if (category.name.toLowerCase() == categoryName.toLowerCase() ||
          category.displayName.toLowerCase() == categoryName.toLowerCase()) {
        return category;
      }
    }
    return ShoppingCategory.general;
  }

  static List<ShoppingCategory> getAllCategories() {
    return ShoppingCategory.values;
  }

  static IconData getIconData(String categoryName) {
    final category = fromString(categoryName);
    switch (category) {
      case ShoppingCategory.fruits:
        return Icons.apple;
      case ShoppingCategory.vegetables:
        return Icons.eco;
      case ShoppingCategory.dairy:
        return Icons.local_drink;
      case ShoppingCategory.meat:
        return Icons.restaurant;
      case ShoppingCategory.seafood:
        return Icons.set_meal;
      case ShoppingCategory.bakery:
        return Icons.bakery_dining;
      case ShoppingCategory.beverages:
        return Icons.local_cafe;
      case ShoppingCategory.snacks:
        return Icons.cookie;
      case ShoppingCategory.condiments:
        return Icons.restaurant_menu;
      case ShoppingCategory.spices:
        return Icons.grass;
      case ShoppingCategory.grains:
        return Icons.grain;
      case ShoppingCategory.household:
        return Icons.home;
      case ShoppingCategory.personalCare:
        return Icons.face;
      case ShoppingCategory.health:
        return Icons.medical_services;
      case ShoppingCategory.baby:
        return Icons.child_care;
      case ShoppingCategory.general:
      default:
        return Icons.shopping_basket;
    }
  }

  static Color getCategoryColor(String categoryName) {
    final category = fromString(categoryName);
    switch (category) {
      case ShoppingCategory.fruits:
        return Colors.red;
      case ShoppingCategory.vegetables:
        return Colors.green;
      case ShoppingCategory.dairy:
        return Colors.blue;
      case ShoppingCategory.meat:
        return const Color(0xFFFF5722);
      case ShoppingCategory.seafood:
        return Colors.lightBlue;
      case ShoppingCategory.bakery:
        return Colors.orange;
      case ShoppingCategory.beverages:
        return Colors.purple;
      case ShoppingCategory.snacks:
        return Colors.amber;
      case ShoppingCategory.condiments:
        return Colors.brown;
      case ShoppingCategory.spices:
        return Colors.deepOrange;
      case ShoppingCategory.grains:
        return Colors.yellow;
      case ShoppingCategory.household:
        return Colors.grey;
      case ShoppingCategory.personalCare:
        return Colors.pink;
      case ShoppingCategory.health:
        return Colors.teal;
      case ShoppingCategory.baby:
        return const Color(0xFFF8BBD9);
      case ShoppingCategory.general:
      default:
        return Colors.blueGrey;
    }
  }

  static String getEmoji(String categoryName) {
    final category = fromString(categoryName);
    return category.emoji;
  }

  static String getDisplayName(String categoryName) {
    final category = fromString(categoryName);
    return category.displayName;
  }
}

class CategoryHelper {
  static Widget buildCategoryChip(String categoryName, BuildContext context) {
    final category = ShoppingCategory.fromString(categoryName);
    final color = ShoppingCategory.getCategoryColor(categoryName);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            category.emoji,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 4),
          Text(
            category.displayName,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildCategoryIcon(String categoryName, {double size = 24}) {
    final color = ShoppingCategory.getCategoryColor(categoryName);
    
    return Container(
      width: size * 2,
      height: size * 2,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        ShoppingCategory.getIconData(categoryName),
        color: color,
        size: size,
      ),
    );
  }

  static List<DropdownMenuItem<String>> getCategoryDropdownItems() {
    return ShoppingCategory.getAllCategories().map((category) {
      return DropdownMenuItem<String>(
        value: category.name,
        child: Row(
          children: [
            Text(category.emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(category.displayName),
          ],
        ),
      );
    }).toList();
  }
}

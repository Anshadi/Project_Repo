import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _themeKey = 'theme_mode';

  // Get theme preference from storage
  static Future<bool> getThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false; // Default to light mode
  }

  // Set theme preference to storage
  static Future<void> setThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }

  // Get system theme
  static bool isSystemDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  // Theme colors for consistent usage across the app
  static ColorScheme getLightColorScheme() {
    return ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    );
  }

  static ColorScheme getDarkColorScheme() {
    return ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    );
  }

  // Helper method to get category colors that work in both themes
  static Color getCategoryColor(String category, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (category.toLowerCase()) {
      case 'dairy':
        return isDark ? Colors.blue[300]! : Colors.blue;
      case 'bakery':
        return isDark ? Colors.orange[300]! : Colors.orange;
      case 'fruits':
        return isDark ? Colors.green[300]! : Colors.green;
      case 'vegetables':
        return isDark ? Colors.lightGreen[300]! : Colors.lightGreen;
      case 'meat':
        return isDark ? Colors.red[300]! : Colors.red;
      case 'beverages':
        return isDark ? Colors.purple[300]! : Colors.purple;
      default:
        return isDark ? Colors.grey[400]! : Colors.grey;
    }
  }
}

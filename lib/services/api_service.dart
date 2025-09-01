import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/shopping_item.dart';
import 'user_service.dart';

class ApiService {
  static const String baseUrl = 'https://project-repo-backend-1-3oi6.onrender.com/api';

  // Get current user ID dynamically
  static String get userId => UserService.currentUserId;

  // Headers for API requests
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  // Test backend connectivity
  static Future<bool> testBackendConnection() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/health'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5));

      debugPrint('Backend connection test: ${response.statusCode}');
      debugPrint('Backend response: ${response.body}');
      if (response.statusCode == 200) {
        debugPrint('Health check successful: ${jsonDecode(response.body)}');
        debugPrint('Backend is running on: $baseUrl');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Backend connection failed: $e');
      return false;
    }
  }

  // Enhanced voice command processing with better error handling
  static Future<Map<String, dynamic>> processVoiceCommand(String query) async {
    debugPrint('Processing voice command: "$query"');
    debugPrint('Sending to backend: $baseUrl/voice/process');

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/voice/process'),
            headers: headers,
            body: jsonEncode({
              'userId': userId,
              'query': query,
            }),
          )
          .timeout(const Duration(seconds: 10));

      debugPrint('Voice command response: ${response.statusCode}');
      debugPrint('Voice command body: ${response.body}');

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        debugPrint('Voice command processed successfully: $result');
        return result;
      } else {
        debugPrint('Backend error: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Failed to process voice command: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Voice command processing error: $e');
      throw Exception('Error processing voice command: $e');
    }
  }

  // Shopping List Management
  // GET /list/{userId}
  static Future<List<ShoppingItem>> getShoppingList() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/list/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => ShoppingItem.fromJson(item)).toList();
      } else {
        throw Exception('Failed to get shopping list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting shopping list: $e');
    }
  }

  // POST /list/add
  static Future<bool> addItemToList(String itemName, int quantity, {double? price, String? brand}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/list/add'),
        headers: headers,
        body: jsonEncode({
          'userId': userId,
          'item': itemName,
          'quantity': quantity,
          'category': 'General',
          'unit': 'pcs',
          'notes': '',
          'priority': 'medium',
          'price': price,
          'brand': brand,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to add item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding item: $e');
    }
  }

  // PUT /list/update
  static Future<bool> updateItem(String itemId, int newQuantity) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/list/update'),
        headers: headers,
        body: jsonEncode({
          'userId': userId,
          'itemId': itemId,
          'quantity': newQuantity,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating item: $e');
    }
  }

  // DELETE /list/{userId}/{itemId}
  static Future<bool> removeItem(String itemId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/list/$userId/$itemId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to remove item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error removing item: $e');
    }
  }

  // Product Search and Management
  // GET /search - Search products with optional query
  static Future<List<Product>> searchProducts([String? query]) async {
    try {
      final uri = query != null && query.isNotEmpty
          ? Uri.parse('$baseUrl/search?query=$query')
          : Uri.parse('$baseUrl/search/all');

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Failed to search products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching products: $e');
    }
  }

  // GET /search/all - Get all available products
  static Future<List<Product>> getAllProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search/all'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Failed to get all products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting all products: $e');
    }
  }

  // DELETE /list/{userId}/clear - Clear shopping list
  static Future<bool> clearShoppingList() async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/list/$userId/clear'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to clear shopping list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error clearing shopping list: $e');
    }
  }

  // GET /recommendations/{userId}
  static Future<List<String>> getRecommendations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/recommendations/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> suggestions = data['suggestions'] ?? [];
        return suggestions.map((item) => item.toString()).toList();
      } else {
        throw Exception(
            'Failed to get recommendations: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting recommendations: $e');
    }
  }

  // GET /history/{userId} - Get shopping history
  static Future<List<Map<String, dynamic>>> getHistory() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/history/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load history: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error getting history: $e');
      rethrow;
    }
  }

  static Future<bool> clearHistory() async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/history/clear'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to clear history: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error clearing history: $e');
      return false;
    }
  }

  // POST /history/add - Add item to purchase history
  static Future<bool> addToPurchaseHistory(ShoppingItem item) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/history/add'),
        headers: headers,
        body: jsonEncode({
          'userId': userId,
          'itemName': item.name,
          'quantity': item.quantity,
          'category': item.category,
          'unit': item.unit,
          'price': item.price ?? 0.0, // Use actual item price
          'brand': item.brand ?? '',
          'store': 'Online Store',
          'purchaseDate': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to add to history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding to history: $e');
    }
  }

  // POST /list/add-from-product - Add product from search with full price info
  static Future<bool> addProductToList(String productId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/list/add-from-product'),
        headers: headers,
        body: jsonEncode({
          'userId': userId,
          'productId': productId,
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to add product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding product: $e');
    }
  }
}

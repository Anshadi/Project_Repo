import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/speech_service.dart';
import '../widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];
  bool _isLoading = false;
  bool _isListening = false;
  String _voiceSearchText = '';

  @override
  void initState() {
    super.initState();
    // Load initial items to show when no search is performed
    _loadAllProducts();
  }

  Future<void> _loadAllProducts() async {
    if (mounted) {          // Loading state if mounted because there could happen a chance when the user is performed activity and then clicked back to another screen ,
      setState(() {          // so in that case , when asynchronous response comes ,
        _isLoading = true;      //  it will cause crash because the screen is moved , so before setting the state we check whether the user is on the same screen that the widget is still visible in the widget tree.
      });
    }

    try {
      // Try to get all products from API
      final results = await ApiService.getAllProducts();
      if (mounted) {
        setState(() {
          _searchResults = results;
        });
      }
    } catch (e) {
      if (!mounted) return;
      // Mock all products for demo when backend is not available
      setState(() {
        _searchResults = [
          Product(
            id: '1',
            name: 'Organic Milk',
            brand: 'Fresh Farm',
            price: 3.99,
            category: 'Dairy',
            description: 'Fresh organic whole milk',
          ),
          Product(
            id: '2',
            name: 'Whole Wheat Bread',
            brand: 'Bakery Fresh',
            price: 2.49,
            category: 'Bakery',
            description: 'Freshly baked whole wheat bread',
          ),
          Product(
            id: '3',
            name: 'Free Range Eggs',
            brand: 'Farm Fresh',
            price: 4.99,
            category: 'Dairy',
            description: 'Farm fresh free range eggs',
          ),
          Product(
            id: '4',
            name: 'Fresh Apples',
            brand: 'Nature\'s Best',
            price: 2.99,
            category: 'Fruits',
            description: 'Sweet and crisp red apples',
          ),
          Product(
            id: '5',
            name: 'Bananas',
            brand: 'Tropical Delight',
            price: 1.49,
            category: 'Fruits',
            description: 'Fresh yellow bananas',
          ),
          Product(
            id: '6',
            name: 'Chicken Breast',
            brand: 'Premium Meats',
            price: 8.99,
            category: 'Meat',
            description: 'Boneless skinless chicken breast',
          ),
          Product(
            id: '7',
            name: 'Tomatoes',
            brand: 'Garden Fresh',
            price: 3.49,
            category: 'Vegetables',
            description: 'Fresh red tomatoes',
          ),
          Product(
            id: '8',
            name: 'Orange Juice',
            brand: 'Citrus Delight',
            price: 4.49,
            category: 'Beverages',
            description: '100% pure orange juice',
          ),
        ];
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    // Cancel any ongoing speech recognition
    SpeechService.cancelListening();
    super.dispose();
  }

  Future<void> _performSearch([String? query]) async {
    final searchQuery = query ?? _searchController.text.trim();

    if (searchQuery.isEmpty) {
      // If search is empty, show all products
      _loadAllProducts();
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final results = await ApiService.searchProducts(searchQuery);
      if (mounted) {
        setState(() {
          _searchResults = results;
        });
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorMessage('Error searching products: $e');
      // Mock search results for demo when backend is not available
      setState(() {
        _searchResults = [
          Product(
            id: '1',
            name: 'Organic Milk',
            brand: 'Fresh Farm',
            price: 3.99,
            category: 'Dairy',
            description: 'Fresh organic whole milk',
          ),
          Product(
            id: '2',
            name: 'Whole Wheat Bread',
            brand: 'Bakery Fresh',
            price: 2.49,
            category: 'Bakery',
            description: 'Freshly baked whole wheat bread',
          ),
          Product(
            id: '3',
            name: 'Free Range Eggs',
            brand: 'Farm Fresh',
            price: 4.99,
            category: 'Dairy',
            description: 'Farm fresh free range eggs',
          ),
        ];
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _startVoiceSearch() async {
    if (!await SpeechService.checkMicrophonePermission()) {
      final granted = await SpeechService.requestMicrophonePermission();
      if (!granted) {
        _showErrorMessage('Microphone permission is required for voice search');
        return;
      }
    }

    if (mounted) {
      setState(() {
        _isListening = true;
        _voiceSearchText = '';
      });
    }

    await SpeechService.startListening(
      onResult: (text) {
        if (mounted) {
          setState(() {
            _voiceSearchText = text;
            _searchController.text = text;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _isListening = false;
          });
        }
        if (mounted) {
          _showErrorMessage('Voice recognition error: $error');
        }
      },
    );
  }

  Future<void> _stopVoiceSearch() async {
    await SpeechService.stopListening();

    if (mounted) {
      setState(() {
        _isListening = false;
      });

      if (_voiceSearchText.isNotEmpty) {
        await _performSearch(_voiceSearchText);
      }
    }
  }

  void _clearSearch() {
    _searchController.clear();
    // Load all products when search is cleared
    _loadAllProducts();
  }

  Future<void> _addToShoppingList(Product product) async {
    try {
      // Use the new method that preserves price and brand information
      await ApiService.addProductToList(product.id, 1);
      if (!mounted) return;
      _showSuccessMessage('${product.name} added to shopping list with price \$${product.price.toStringAsFixed(2)}');
    } catch (e) {
      if (!mounted) return;
      // Fallback to regular add with price/brand info
      try {
        await ApiService.addItemToList(product.name, 1, price: product.price, brand: product.brand);
        if (!mounted) return;
        _showSuccessMessage('${product.name} added to shopping list');
      } catch (fallbackError) {
        if (!mounted) return;
        _showErrorMessage('Error adding ${product.name} to list: $fallbackError');
      }
    }
  }

  void _showErrorMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Products'),
      ),
      body: Column(
        children: [
          // Search Section
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Bar
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search for items...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: _clearSearch,
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 15.0,
                          ),
                        ),
                        onSubmitted: (value) => _performSearch(),
                        onChanged: (value) {
                          setState(() {}); // Trigger rebuild for clear button
                        },
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Voice Search Button
                    Container(
                      decoration: BoxDecoration(
                        color: _isListening ? Colors.red : Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          color: Colors.white,
                        ),
                        onPressed:
                            _isListening ? _stopVoiceSearch : _startVoiceSearch,
                      ),
                    ),
                  ],
                ),

                // Voice Search Status
                if (_isListening)
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Listening...',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Voice Search Text
                if (_voiceSearchText.isNotEmpty && _isListening)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    width: double.infinity,
                    child: Text(
                      _voiceSearchText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Search Results
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No products found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try searching for something else',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final product = _searchResults[index];
                          return ProductCard(
                            product: product,
                            onAddToList: () => _addToShoppingList(product),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/shopping_item.dart';
import '../services/api_service.dart';
import '../widgets/shopping_item_card.dart';
import '../widgets/suggestions_section.dart';
import '../widgets/voice_input_widget.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<ShoppingItem> _shoppingItems = [];
  List<String> _suggestions = [];
  bool _isLoading = false;
  String _lastRecognizedText = '';

  @override
  void initState() {
    super.initState();
    _loadShoppingList();
    _loadSuggestions();
    _testBackendConnection();
  }

  Future<void> _testBackendConnection() async {
    try {
      final isConnected = await ApiService.testBackendConnection();
      if (mounted) {
        if (!isConnected) {
          _showErrorMessage('Backend connection failed - using local fallback');
        }
        // Success case is silent - no message shown to user
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage('Backend test error: $e');
      }
    }
  }

  Future<void> _loadShoppingList() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final items = await ApiService.getShoppingList();
      if (!mounted) return;
      setState(() {
        _shoppingItems = items;
      });
    } catch (e) {
      if (!mounted) return;
      _showErrorMessage('Error loading shopping list: $e');
      // No mock data - start with empty list
      setState(() {
        _shoppingItems = [];
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadSuggestions() async {
    try {
      final suggestions = await ApiService.getRecommendations();
      if (!mounted) return;
      setState(() {
        _suggestions = suggestions;
      });
    } catch (e) {
      // Log error but don't show any fallback suggestions
      debugPrint('Error loading suggestions: $e');
      if (!mounted) return;
      setState(() {
        _suggestions = [];
      });
    }
  }

  Future<void> _processVoiceCommand(String text) async {
    debugPrint('=== VOICE COMMAND PROCESSING ===');
    debugPrint('Voice recognition started');
    debugPrint('Recognized text: "$text"');

    if (!mounted) return;
    setState(() {
      _lastRecognizedText = text;
    });

    try {
      debugPrint('Attempting to send to backend...');
      final result = await ApiService.processVoiceCommand(text);
      debugPrint('Backend response received: $result');

      // Refresh the shopping list and suggestions after processing
      await _loadShoppingList();
      await _loadSuggestions();

      // Show success message
      if (!mounted) return;
      _showSuccessMessage(
          result['message'] ?? 'Command processed successfully');
    } catch (e) {
      debugPrint('Backend processing failed: $e');
      debugPrint('Falling back to local processing...');

      if (!mounted) return;

      // Try to process the command locally as fallback
      await _processCommandLocally(text);
    }
  }

  // Local command processing as fallback when backend fails
  Future<void> _processCommandLocally(String text) async {
    final lowerText = text.toLowerCase();

    if (lowerText.contains('add') || lowerText.contains('buy')) {
      // Extract item name and quantity with better parsing
      String itemName = '';
      int quantity = 1;
      String unit = 'pcs';

      // Remove common words and clean up
      String cleanText = lowerText
          .replaceAll('add', '')
          .replaceAll('buy', '')
          .replaceAll('to', '')
          .replaceAll('list', '')
          .replaceAll('shopping', '')
          .replaceAll('my', '')
          .replaceAll('the', '')
          .trim();

      // Check for quantity patterns like "5", "5 pieces", "5 bottles", etc.
      final quantityPattern = RegExp(
          r'(\d+)\s*(pieces?|bottles?|loaves?|kilos?|grams?|pounds?|ounces?|cans?|packets?|bags?|boxes?|units?|items?|pcs?)',
          caseSensitive: false);
      final quantityMatch = quantityPattern.firstMatch(cleanText);

      if (quantityMatch != null) {
        quantity = int.parse(quantityMatch.group(1)!);
        unit = quantityMatch.group(2)!.toLowerCase();
        // Remove the quantity and unit from the text
        cleanText = cleanText.replaceAll(quantityMatch.group(0)!, '').trim();
      } else {
        // Check for just numbers
        final simpleQuantityMatch = RegExp(r'(\d+)').firstMatch(cleanText);
        if (simpleQuantityMatch != null) {
          quantity = int.parse(simpleQuantityMatch.group(1)!);
          cleanText =
              cleanText.replaceAll(simpleQuantityMatch.group(1)!, '').trim();
        }
      }

      // Clean up the item name - remove common filler words
      final fillerWords = [
        'amount',
        'of',
        'some',
        'a',
        'an',
        'the',
        'and',
        'or',
        'but',
        'in',
        'on',
        'at',
        'to',
        'for',
        'with',
        'by',
        'from',
        'my',
        'your',
        'this',
        'that',
        'these',
        'those',
        'they',
        'them',
        'their',
        'there',
        'where',
        'when',
        'why',
        'how',
        'what',
        'which',
        'who',
        'whom',
        'whose',
        'if',
        'else',
        'then',
        'than',
        'also',
        'too',
        'very',
        'just',
        'about',
        'above',
        'after',
        'again',
        'against',
        'along',
        'among',
        'around',
        'as',
        'at',
        'before',
        'behind',
        'below',
        'beside',
        'between',
        'beyond',
        'both',
        'but',
        'by',
        'down',
        'during',
        'each',
        'except',
        'few',
        'following',
        'for',
        'from',
        'further',
        'had',
        'has',
        'have',
        'having',
        'he',
        'hence',
        'her',
        'here',
        'hereby',
        'herein',
        'hereupon',
        'hers',
        'herself',
        'him',
        'himself',
        'his',
        'how',
        'however',
        'i',
        'if',
        'in',
        'into',
        'is',
        'it',
        'its',
        'itself',
        'just',
        'keep',
        'know',
        'known',
        'large',
        'last',
        'latter',
        'latterly',
        'least',
        'less',
        'let',
        'like',
        'likely',
        'little',
        'long',
        'longer',
        'lately',
        'made',
        'make',
        'makes',
        'making',
        'many',
        'may',
        'maybe',
        'me',
        'mean',
        'means',
        'meantime',
        'meanwhile',
        'might',
        'more',
        'moreover',
        'most',
        'mostly',
        'move',
        'much',
        'must',
        'my',
        'myself',
        'namely',
        'neither',
        'never',
        'nevertheless',
        'new',
        'next',
        'no',
        'nobody',
        'none',
        'noone',
        'nor',
        'not',
        'nothing',
        'now',
        'nowhere',
        'of',
        'off',
        'often',
        'on',
        'once',
        'one',
        'ones',
        'only',
        'onto',
        'or',
        'other',
        'others',
        'otherwise',
        'our',
        'ours',
        'ourselves',
        'out',
        'over',
        'own',
        'per',
        'perhaps',
        'please',
        'rather',
        'really',
        'recent',
        'recently',
        'regarding',
        'relating',
        'respectively',
        'right',
        'same',
        'say',
        'says',
        'see',
        'seem',
        'seemed',
        'seeming',
        'seems',
        'seen',
        'self',
        'selves',
        'sent',
        'several',
        'shall',
        'she',
        'should',
        'show',
        'side',
        'since',
        'sincere',
        'so',
        'some',
        'somebody',
        'somehow',
        'someone',
        'something',
        'sometime',
        'sometimes',
        'somewhere',
        'still',
        'such',
        'sufficiently',
        'sure',
        'surely',
        'take',
        'taken',
        'than',
        'that',
        'the',
        'their',
        'them',
        'themselves',
        'then',
        'thence',
        'there',
        'thereafter',
        'thereby',
        'therefore',
        'therein',
        'thereof',
        'thereon',
        'thereto',
        'thereupon',
        'these',
        'they',
        'think',
        'this',
        'those',
        'though',
        'through',
        'throughout',
        'thru',
        'thus',
        'to',
        'together',
        'too',
        'toward',
        'towards',
        'under',
        'underneath',
        'unless',
        'until',
        'up',
        'upon',
        'upwards',
        'us',
        'used',
        'using',
        'various',
        'very',
        'via',
        'was',
        'we',
        'well',
        'were',
        'what',
        'whatever',
        'whatsoever',
        'when',
        'whence',
        'whenever',
        'where',
        'whereafter',
        'whereas',
        'whereat',
        'whereby',
        'wherefore',
        'wherefrom',
        'wherein',
        'whereof',
        'whereon',
        'whereto',
        'whereupon',
        'wherever',
        'whether',
        'which',
        'whichever',
        'while',
        'whilst',
        'whither',
        'who',
        'whoever',
        'whole',
        'whom',
        'whomever',
        'whose',
        'why',
        'will',
        'with',
        'within',
        'without',
        'would',
        'yet',
        'you',
        'your',
        'yours',
        'yourself',
        'yourselves'
      ];
      for (final word in fillerWords) {
        cleanText = cleanText.replaceAll(
            RegExp(r'\b' + word + r'\b', caseSensitive: false), '');
      }

      itemName = cleanText.replaceAll(RegExp(r'\s+'), ' ').trim();

      // Validate that the item name makes sense
      if (itemName.isNotEmpty && _isValidItemName(itemName)) {
        // Don't add locally - let backend handle it through API call
        _showSuccessMessage(
            'Processing: Add $quantity ${unit == 'pcs' ? 'pieces' : unit} of $itemName to your list');
      } else {
        _showErrorMessage(
            'Please specify a valid item to add. Try saying "add bread" or "add 2 bottles of milk"');
      }
    } else if (lowerText.contains('remove') || lowerText.contains('delete')) {
      // Extract item name
      String itemName = lowerText
          .replaceAll('remove', '')
          .replaceAll('delete', '')
          .replaceAll('from', '')
          .replaceAll('list', '')
          .replaceAll('my', '')
          .replaceAll('the', '')
          .trim();

      // Find and remove item
      final itemIndex = _shoppingItems.indexWhere((item) =>
          item.name.toLowerCase().contains(itemName) ||
          itemName.contains(item.name.toLowerCase()));

      if (itemIndex != -1) {
        final removedItem = _shoppingItems[itemIndex];
        setState(() {
          _shoppingItems.removeAt(itemIndex);
        });
        _showSuccessMessage('Removed ${removedItem.name} from your list');
      } else {
        _showErrorMessage('Item not found in your list');
      }
    } else if (lowerText.contains('show') || lowerText.contains('list')) {
      _showSuccessMessage(
          'You have ${_shoppingItems.length} items in your list');
    } else {
      _showErrorMessage(
          'Command not recognized. Try saying "add bread" or "add 2 bottles of milk" or "remove milk"');
    }
  }

  // Helper method to validate item names
  bool _isValidItemName(String itemName) {
    if (itemName.length < 2) return false;

    // Check if it's not just numbers or common invalid words
    final invalidWords = [
      'amount',
      'quantity',
      'number',
      'count',
      'total',
      'sum'
    ];
    final lowerItem = itemName.toLowerCase();

    for (final word in invalidWords) {
      if (lowerItem.contains(word)) return false;
    }

    // Check if it contains at least one letter
    return RegExp(r'[a-zA-Z]').hasMatch(itemName);
  }

  Future<void> _removeItem(String itemId) async {
    try {
      await ApiService.removeItem(itemId);
      await _loadShoppingList();
      await _loadSuggestions();
      if (!mounted) return;
      _showSuccessMessage('Item removed successfully');
    } catch (e) {
      if (!mounted) return;
      _showErrorMessage('Error removing item: $e');
    }
  }

  Future<void> _updateItemQuantity(String itemId, int newQuantity) async {
    try {
      await ApiService.updateItem(itemId, newQuantity);
      await _loadShoppingList();
      await _loadSuggestions();
      if (!mounted) return;
      _showSuccessMessage('Item updated successfully');
    } catch (e) {
      if (!mounted) return;
      _showErrorMessage('Error updating item: $e');
    }
  }

  Future<void> _addSuggestion(String suggestion) async {
    try {
      await ApiService.addItemToList(suggestion, 1);
      await _loadShoppingList();
      await _loadSuggestions();
      if (!mounted) return;
      _showSuccessMessage('$suggestion added to your list');
    } catch (e) {
      if (!mounted) return;
      _showErrorMessage('Error adding suggestion: $e');
    }
  }

  Future<void> _toggleItemCompleted(String itemId, bool completed) async {
    try {
      // This would need to be implemented in ApiService
      // await ApiService.updateItemCompleted(itemId, completed);

      // For now, update locally and refresh
      final itemIndex = _shoppingItems.indexWhere((item) => item.id == itemId);
      if (itemIndex != -1) {
        setState(() {
          _shoppingItems[itemIndex] =
              _shoppingItems[itemIndex].copyWith(completed: completed);
        });
      }

      if (!mounted) return;
      _showSuccessMessage(
          completed ? 'Item marked as completed' : 'Item marked as pending');
    } catch (e) {
      if (!mounted) return;
      _showErrorMessage('Error updating item: $e');
    }
  }

  Future<void> _updateItemNotes(String itemId, String notes) async {
    try {
      // This would need to be implemented in ApiService
      // await ApiService.updateItemNotes(itemId, notes);

      // For now, update locally and refresh
      final itemIndex = _shoppingItems.indexWhere((item) => item.id == itemId);
      if (itemIndex != -1) {
        setState(() {
          _shoppingItems[itemIndex] =
              _shoppingItems[itemIndex].copyWith(notes: notes);
        });
      }

      if (!mounted) return;
      _showSuccessMessage('Notes updated successfully');
    } catch (e) {
      if (!mounted) return;
      _showErrorMessage('Error updating notes: $e');
    }
  }

  Future<void> _updateItemPriority(String itemId, String priority) async {
    try {
      // This would need to be implemented in ApiService
      // await ApiService.updateItemPriority(itemId, priority);

      // For now, update locally and refresh
      final itemIndex = _shoppingItems.indexWhere((item) => item.id == itemId);
      if (itemIndex != -1) {
        setState(() {
          _shoppingItems[itemIndex] =
              _shoppingItems[itemIndex].copyWith(priority: priority);
        });
      }

      if (!mounted) return;
      _showSuccessMessage('Priority updated successfully');
    } catch (e) {
      if (!mounted) return;
      _showErrorMessage('Error updating priority: $e');
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

  Future<void> _buyShoppingList() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      // Add all items to purchase history
      for (final item in _shoppingItems) {
        await ApiService.addToPurchaseHistory(item);
      }

      // Clear the shopping list from backend
      await ApiService.clearShoppingList();

      // Clear local state and reload
      await _loadShoppingList();
      await _loadSuggestions();

      if (!mounted) return;
      _showSuccessMessage(
          'Shopping completed! Items added to purchase history.');
    } catch (e) {
      if (!mounted) return;
      _showErrorMessage('Error adding shopping list to history: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Assistant'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadShoppingList();
          await _loadSuggestions();
        },
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  // Voice Input Section
                  SliverToBoxAdapter(
                    child: VoiceInputWidget(
                      onVoiceCommand: _processVoiceCommand,
                      lastRecognizedText: _lastRecognizedText,
                    ),
                  ),

                  // Shopping List Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'My Shopping List (${_shoppingItems.length} items)',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                  ),

                  // Shopping Items
                  _shoppingItems.isEmpty
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.shopping_cart_outlined,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Your shopping list is empty',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Use the microphone button to add items',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final item = _shoppingItems[index];
                              return ShoppingItemCard(
                                item: item,
                                onRemove: () => _removeItem(item.id),
                                onUpdateQuantity: (newQuantity) =>
                                    _updateItemQuantity(item.id, newQuantity),
                                onToggleCompleted: (completed) =>
                                    _toggleItemCompleted(item.id, completed),
                                onUpdateNotes: (notes) =>
                                    _updateItemNotes(item.id, notes),
                                onUpdatePriority: (priority) =>
                                    _updateItemPriority(item.id, priority),
                              );
                            },
                            childCount: _shoppingItems.length,
                          ),
                        ),

                  // Buy Button Section (only show when there are items)
                  if (_shoppingItems.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _buyShoppingList,
                            icon: const Icon(Icons.shopping_cart_checkout),
                            label: const Text(
                              'Buy Shopping List',
                              style: TextStyle(fontSize: 18),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Suggestions Section
                  SliverToBoxAdapter(
                    child: SuggestionsSection(
                      suggestions: _suggestions,
                      onAddSuggestion: _addSuggestion,
                    ),
                  ),

                  // Bottom padding
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 100),
                  ),
                ],
              ),
      ),
    );
  }
}

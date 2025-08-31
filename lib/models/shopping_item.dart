class ShoppingItem {
  final String id;
  final String name;
  final int quantity;
  final String category;
  final String unit;
  final String? notes;
  final String priority;
  final bool completed;
  final double? price; // Price per unit for analytics
  final String? brand; // Product brand

  ShoppingItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    this.unit = 'pcs',
    this.notes,
    this.priority = 'medium',
    this.completed = false,
    this.price,
    this.brand,
  });

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 1,
      category: json['category'] ?? 'General',
      unit: json['unit'] ?? 'pcs',
      notes: json['notes'],
      priority: json['priority'] ?? 'medium',
      completed: json['completed'] ?? false,
      price: json['price']?.toDouble(),
      brand: json['brand'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'category': category,
      'unit': unit,
      'notes': notes,
      'priority': priority,
      'completed': completed,
      'price': price,
      'brand': brand,
    };
  }

  ShoppingItem copyWith({
    String? id,
    String? name,
    int? quantity,
    String? category,
    String? unit,
    String? notes,
    String? priority,
    bool? completed,
    double? price,
    String? brand,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      notes: notes ?? this.notes,
      priority: priority ?? this.priority,
      completed: completed ?? this.completed,
      price: price ?? this.price,
      brand: brand ?? this.brand,
    );
  }

  // Helper method to get total value (price * quantity)
  double get totalValue => (price ?? 0.0) * quantity;

  // Helper method to check if item has price information
  bool get hasPriceInfo => price != null && price! > 0;
}

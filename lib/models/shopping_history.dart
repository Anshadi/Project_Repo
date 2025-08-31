class ShoppingHistory {
  final String id;
  final String itemName;
  final int quantity;
  final String category;
  final String unit;
  final DateTime purchaseDate;
  final double? price;
  final String? store;
  final String? brand;

  ShoppingHistory({
    required this.id,
    required this.itemName,
    required this.quantity,
    required this.category,
    this.unit = 'pcs',
    required this.purchaseDate,
    this.price,
    this.store,
    this.brand,
  });

  factory ShoppingHistory.fromJson(Map<String, dynamic> json) {
    return ShoppingHistory(
      id: json['id'] ?? '',
      itemName: json['itemName'] ?? json['name'] ?? '',
      quantity: json['quantity'] ?? 1,
      category: json['category'] ?? 'General',
      unit: json['unit'] ?? 'pcs',
      purchaseDate: json['purchaseDate'] != null
          ? DateTime.parse(json['purchaseDate'])
          : DateTime.now(),
      price: json['price']?.toDouble(),
      store: json['store'] ??
          json['brand'], // Use brand as store if store not available
      brand: json['brand'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemName': itemName,
      'quantity': quantity,
      'category': category,
      'unit': unit,
      'purchaseDate': purchaseDate.toIso8601String(),
      'price': price,
      'store': store,
      'brand': brand,
    };
  }

  // Helper method to get formatted date
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(purchaseDate).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else if (difference < 30) {
      final weeks = (difference / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      final months = (difference / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    }
  }

  // Helper method for monthly grouping
  String get monthYear {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[purchaseDate.month - 1]} ${purchaseDate.year}';
  }
}

// Model for history statistics
class HistoryStats {
  final int totalItems;
  final int totalQuantity;
  final double totalSpent;
  final Map<String, int> categoryBreakdown;
  final Map<String, int> monthlyPurchases;

  HistoryStats({
    required this.totalItems,
    required this.totalQuantity,
    required this.totalSpent,
    required this.categoryBreakdown,
    required this.monthlyPurchases,
  });

  factory HistoryStats.fromHistory(List<ShoppingHistory> history) {
    final categoryBreakdown = <String, int>{};
    final monthlyPurchases = <String, int>{};

    int totalQuantity = 0;
    double totalSpent = 0;

    for (final item in history) {
      // Category breakdown
      categoryBreakdown[item.category] =
          (categoryBreakdown[item.category] ?? 0) + item.quantity;

      // Monthly purchases
      monthlyPurchases[item.monthYear] =
          (monthlyPurchases[item.monthYear] ?? 0) + 1;

      totalQuantity += item.quantity;
      totalSpent += (item.price ?? 0) * item.quantity;
    }

    return HistoryStats(
      totalItems: history.length,
      totalQuantity: totalQuantity,
      totalSpent: totalSpent,
      categoryBreakdown: categoryBreakdown,
      monthlyPurchases: monthlyPurchases,
    );
  }
}

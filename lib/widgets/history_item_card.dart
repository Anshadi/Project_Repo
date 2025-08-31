import 'package:flutter/material.dart';
import '../models/shopping_history.dart';
import '../services/theme_service.dart';

class HistoryItemCard extends StatelessWidget {
  final ShoppingHistory history;
  final VoidCallback? onTap;

  const HistoryItemCard({
    super.key,
    required this.history,
    this.onTap,
  });

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'dairy':
        return Icons.local_drink;
      case 'bakery':
        return Icons.bakery_dining;
      case 'fruits':
        return Icons.apple;
      case 'vegetables':
        return Icons.eco;
      case 'meat':
        return Icons.restaurant;
      case 'beverages':
        return Icons.local_cafe;
      default:
        return Icons.shopping_basket;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Category Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color:
                      ThemeService.getCategoryColor(history.category, context)
                          .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(history.category),
                  color:
                      ThemeService.getCategoryColor(history.category, context),
                  size: 24,
                ),
              ),

              const SizedBox(width: 16),

              // Item Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item Name
                    Text(
                      history.itemName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Quantity and Store
                    Row(
                      children: [
                        Text(
                          '${history.quantity} ${history.unit}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (history.store != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              history.store!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Price and Arrow
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (history.price != null)
                    Text(
                      '\$${(history.price! * history.quantity).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

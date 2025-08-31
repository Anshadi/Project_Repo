import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/theme_service.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToList;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToList,
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
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image/Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: ThemeService.getCategoryColor(product.category, context)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getCategoryIcon(product.category),
                color: ThemeService.getCategoryColor(product.category, context),
                size: 28,
              ),
            ),

            const SizedBox(width: 16),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Brand
                  Text(
                    product.brand,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Price and Category
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: ThemeService.getCategoryColor(
                                  product.category, context)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          product.category,
                          style: TextStyle(
                            fontSize: 12,
                            color: ThemeService.getCategoryColor(
                                product.category, context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Description
                  if (product.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Add to List Button
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: onAddToList,
                  icon: const Icon(
                    Icons.add_shopping_cart,
                    size: 16,
                  ),
                  label: const Text(
                    'Add',
                    style: TextStyle(fontSize: 12),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    minimumSize: Size.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

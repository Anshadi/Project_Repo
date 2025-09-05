import 'package:flutter/material.dart';
import '../models/shopping_history.dart';

class HistoryStatsCard extends StatelessWidget {
  final HistoryStats stats;

  const HistoryStatsCard({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Shopping Statistics',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(    // Uses title Large of app theme and .copywith() allows its specific properties to be overriden
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Stats Grid
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Total Items',
                    value: stats.totalItems.toString(),
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.format_list_numbered,
                    title: 'Total Quantity',
                    value: stats.totalQuantity.toString(),
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.attach_money,
                    title: 'Total Spent',
                    value: '\$${stats.totalSpent.toStringAsFixed(2)}',
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.trending_up,
                    title: 'Avg per Item',
                    value: stats.totalItems > 0
                        ? '\$${(stats.totalSpent / stats.totalItems).toStringAsFixed(2)}'
                        : '\$0.00',
                    color: Colors.purple,
                  ),
                ),
              ],
            ),

            if (stats.categoryBreakdown.isNotEmpty) ...[
              const SizedBox(height: 24),

              // Top Categories
              Text(
                'Top Categories',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 12),
              ...(stats.categoryBreakdown.entries.toList()
                    ..sort((a, b) => b.value.compareTo(a.value)))
                  .take(3)
                  .map((entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: _getCategoryColor(entry.key),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                entry.key,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              '${entry.value} items',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )),
            ],
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'dairy':
        return Colors.blue;
      case 'bakery':
        return Colors.orange;
      case 'fruits':
        return Colors.green;
      case 'vegetables':
        return Colors.lightGreen;
      case 'meat':
        return Colors.red;
      case 'beverages':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

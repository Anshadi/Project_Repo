import 'package:flutter/material.dart';
import '../models/shopping_history.dart';
import '../services/api_service.dart';
import '../services/theme_service.dart';
import '../widgets/history_item_card.dart';
import '../widgets/history_stats_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  List<ShoppingHistory> _history = [];
  HistoryStats? _stats;
  bool _isLoading = false;
  String _selectedFilter = 'All';
  late TabController _tabController;

  final List<String> _filters = [
    'All',
    'This Week',
    'This Month',
    'Last 3 Months'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);        //  vsync acts as a signal that tells your animations when to update, ensuring they are smooth, efficient, and synchronized with the display.
    _loadHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      // Try to load from API first
      final historyData = await ApiService.getHistory();
      final history =
          historyData.map((item) => ShoppingHistory.fromJson(item)).toList();

      if (mounted) {
        setState(() {
          _history = history;
          _stats = HistoryStats.fromHistory(_history);
        });
      }
    } catch (e) {
      // Load mock data for demo
      _loadMockHistory();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _loadMockHistory() {
    // No mock data - show empty history when backend is unavailable
    if (mounted) {
      setState(() {
        _history = [];
        _stats = HistoryStats.fromHistory(_history);
      });
    }
  }

  List<ShoppingHistory> get _filteredHistory {
    final now = DateTime.now();
    switch (_selectedFilter) {
      case 'This Week':
        return _history
            .where((item) => item.purchaseDate
                .isAfter(now.subtract(const Duration(days: 7))))
            .toList();
      case 'This Month':
        return _history
            .where((item) => item.purchaseDate
                .isAfter(now.subtract(const Duration(days: 30))))
            .toList();
      case 'Last 3 Months':
        return _history
            .where((item) => item.purchaseDate
                .isAfter(now.subtract(const Duration(days: 90))))
            .toList();
      default:
        return _history;
    }
  }

  Map<String, List<ShoppingHistory>> get _groupedHistory {
    final filtered = _filteredHistory;
    final grouped = <String, List<ShoppingHistory>>{};

    for (final item in filtered) {
      final date = item.formattedDate;
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(item);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(                         
        title: const Text('Shopping History'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.history), text: 'History'),
            Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
          ],
        ),
        actions: [                    // AppBar is used to add a filter selection dropdown to the shopping history screen. 
          PopupMenuButton<String>(
            onSelected: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
            itemBuilder: (context) => _filters
                .map(
                  (filter) => PopupMenuItem(
                    value: filter,
                    child: Row(
                      children: [
                        Icon(
                          _selectedFilter == filter
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(filter),
                      ],
                    ),
                  ),
                )
                .toList(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedFilter,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildHistoryTab(),
                _buildAnalyticsTab(),
              ],
            ),
    );
  }

  Widget _buildHistoryTab() {
    final grouped = _groupedHistory;

    if (grouped.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No shopping history found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your purchase history will appear here',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadHistory,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: grouped.keys.length,
        itemBuilder: (context, index) {
          final date = grouped.keys.elementAt(index);
          final items = grouped[date]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index > 0) const SizedBox(height: 24),

              // Date Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  date,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Items for this date
              ...items.map((item) => HistoryItemCard(
                    history: item,
                    onTap: () => _showItemDetails(item),
                  )),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    if (_stats == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          HistoryStatsCard(stats: _stats!),
          const SizedBox(height: 16),
          _buildCategoryChart(),
          const SizedBox(height: 16),
          _buildMonthlyChart(),
        ],
      ),
    );
  }

  Widget _buildCategoryChart() {
    if (_stats == null || _stats!.categoryBreakdown.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.pie_chart,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Category Breakdown',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._stats!.categoryBreakdown.entries.map((entry) {
              final total = _stats!.totalQuantity;
              final percentage = (entry.value / total * 100).round();

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color:
                            ThemeService.getCategoryColor(entry.key, context),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(entry.key),
                    ),
                    Text('${entry.value} items ($percentage%)'),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyChart() {
    if (_stats == null || _stats!.monthlyPurchases.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bar_chart,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Monthly Purchases',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._stats!.monthlyPurchases.entries.map((entry) {
              final maxPurchases = _stats!.monthlyPurchases.values
                  .reduce((a, b) => a > b ? a : b);
              final barWidth = (entry.value / maxPurchases * 200).toDouble();

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key),
                        Text('${entry.value} purchases'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 8,
                      width: barWidth,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showItemDetails(ShoppingHistory item) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: ThemeService.getCategoryColor(item.category, context)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(item.category),
                    color:
                        ThemeService.getCategoryColor(item.category, context),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.itemName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        '${item.quantity} ${item.unit}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailRow('Category', item.category),
            _buildDetailRow('Purchase Date', item.formattedDate),
            _buildDetailRow('Price',
                '\$${(item.price! * item.quantity).toStringAsFixed(2)}'),
            _buildDetailRow('Store', item.store ?? 'Online Store'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

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
}

import 'package:flutter/material.dart';
import '../models/shopping_item.dart';
import '../utils/shopping_category.dart';

class ShoppingItemCard extends StatelessWidget {
  final ShoppingItem item;
  final VoidCallback onRemove;
  final Function(int) onUpdateQuantity;
  final Function(bool)? onToggleCompleted;
  final Function(String)? onUpdateNotes;
  final Function(String)? onUpdatePriority;

  const ShoppingItemCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onUpdateQuantity,
    this.onToggleCompleted,
    this.onUpdateNotes,
    this.onUpdatePriority,
  });

  void _showQuantityDialog(BuildContext context) {
    showDialog(                                              // Used to show the pop up on the current screen 
      context: context,                                      // Passes Build context to it to determine where the dialog is displayed in the widget tree
      builder: (context) => _QuantityDialog(                // An anonymous function that takes a BuildContext and returns a widget here _QuantityDialog .
        currentQuantity: item.quantity,
        itemName: item.name,
        onUpdate: onUpdateQuantity,
      ),
    );
  }

  Color _priorityColor(String priority, BuildContext context) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Dismissible(                        // Provides the functionality of swipe to delete to the widget 
        key: Key(item.id),                      // Provides a key to uniquely identify this dissimissible widget for each element 
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.delete,
                color: Colors.white,
                size: 28,
              ),
              SizedBox(height: 4),
              Text(
                'Remove',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        direction: DismissDirection.endToStart,        // It Allows the widget to be dismissed by swiping from right to left.
        confirmDismiss: (direction) async {           // It is a callback function that is called when the user starts to dismiss the widget .  (direction) async { ... }: it is an asynchronous function that takes the swipe direction as input.
          return await showDialog<bool>(              // Shows a dialog and waits for the user's response. so that the user wants to confirm the deletion
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Remove Item'),
              content: Text(
                  'Are you sure you want to remove ${item.name} from your shopping list?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    'Remove',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
        onDismissed: (direction) => onRemove(),          // A callback function that is called when the widget is dismissed. Calls the onRemove function (passed to the widget) when the widget is dismissed.
        child: Card(                                     // The widget that will be displayed inside the Dismissible.
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showQuantityDialog(context),      //  A callback function that is called when the card is tapped.  _showQuantityDialog(context): Calls a method to show a dialog for updating the item's quantity.
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(    
                children: [
                  // Category Icon
                  CategoryHelper.buildCategoryIcon(item.category, size: 24),      // Builds item based on item category , but here we set the size

                  const SizedBox(width: 16),

                  // Item Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Item Name and Completed Checkbox
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  decoration: item.completed
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                            Checkbox(
                              value: item.completed,
                              onChanged: (value) {
                                if (onToggleCompleted != null &&
                                    value != null) {
                                  onToggleCompleted!(value);
                                }
                              },
                            ),
                          ],
                        ),
                        if (item.notes != null && item.notes!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.notes!,
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                        const SizedBox(height: 4),
                        // Quantity and Category with Priority
                        Row(
                          children: [
                            Text(
                              '${item.quantity} ${item.unit}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                CategoryHelper.buildCategoryChip(
                                    item.category, context),
                                if (item.priority.isNotEmpty &&
                                    item.priority != 'medium') ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color:
                                          _priorityColor(item.priority, context)
                                              .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,        //  Makes the Row take up only as much horizontal space as its children need.
                                      children: [
                                        Icon(
                                          Icons.priority_high,
                                          color: _priorityColor(
                                              item.priority, context),
                                          size: 12,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          item.priority.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: _priorityColor(
                                                item.priority, context),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Edit Arrow
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                  ),

                  // Manual Remove Button
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red[400],
                    onPressed: () => onRemove(),
                    tooltip: 'Remove item',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuantityDialog extends StatefulWidget {
  final int currentQuantity;
  final String itemName;
  final Function(int) onUpdate;

  const _QuantityDialog({
    required this.currentQuantity,
    required this.itemName,
    required this.onUpdate,
  });

  @override
  State<_QuantityDialog> createState() => _QuantityDialogState();
}

class _QuantityDialogState extends State<_QuantityDialog> {
  late int _quantity;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _quantity = widget.currentQuantity;
    _controller.text = _quantity.toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateQuantity(int newQuantity) {
    if (newQuantity > 0) {
      setState(() {
        _quantity = newQuantity;
        _controller.text = _quantity.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update ${widget.itemName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quantity Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _updateQuantity(_quantity - 1),
                icon: const Icon(Icons.remove_circle_outline),
                iconSize: 32,
              ),
              SizedBox(
                width: 80,
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  onChanged: (value) {
                    final newQuantity = int.tryParse(value);
                    if (newQuantity != null && newQuantity > 0) {
                      _quantity = newQuantity;
                    }
                  },
                ),
              ),
              IconButton(
                onPressed: () => _updateQuantity(_quantity + 1),
                icon: const Icon(Icons.add_circle_outline),
                iconSize: 32,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Quick Select Buttons
          Wrap(                // It Automatically wraps children to the next line if they don't fit in the current line.
            spacing: 8,
            children: [1, 2, 5, 10].map((value) {
              return ActionChip(                        // It is to initiate an action related to primary content, often appearing dynamically or contextually within the UI. It only requires a label and OnPressed callback
                label: Text(value.toString()),
                onPressed: () => _updateQuantity(value),
                backgroundColor: _quantity == value
                    ? Theme.of(context).primaryColor.withOpacity(0.1)
                    : null,
              );
            }).toList(),
          ),
        ],
      ),
      actions: [                                        // A list of widgets displayed at the bottom of the dialog (typically buttons).
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onUpdate(_quantity);                // Calls the onUpdate callback passed to the widget, passing the selected quantity (_quantity) .
            Navigator.of(context).pop();
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}

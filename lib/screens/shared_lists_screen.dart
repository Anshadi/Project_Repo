import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SharedListsScreen extends StatefulWidget {
  const SharedListsScreen({super.key});

  @override
  State<SharedListsScreen> createState() => _SharedListsScreenState();
}

class _SharedListsScreenState extends State<SharedListsScreen> {
  List<Map<String, dynamic>> _sharedLists = [];
  bool _isLoading = false;
  final TextEditingController _shareCodeController = TextEditingController();
  final TextEditingController _listNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSharedLists();
  }

  @override
  void dispose() {
    _shareCodeController.dispose();
    _listNameController.dispose();
    super.dispose();
  }

  Future<void> _loadSharedLists() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // This would call the backend API
      // final lists = await ApiService.getSharedLists();
      // For now, using mock data
      setState(() {
        _sharedLists = [
          {
            'id': '1',
            'name': 'Family Groceries',
            'shareCode': 'FAM123',
            'isOwner': true,
            'sharedWith': ['john@email.com', 'sarah@email.com'],
            'itemCount': 15,
          },
          {
            'id': '2',
            'name': 'Office Supplies',
            'shareCode': 'OFF456',
            'isOwner': false,
            'sharedWith': ['manager@company.com'],
            'itemCount': 8,
          },
        ];
      });
    } catch (e) {
      _showErrorMessage('Error loading shared lists: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createSharedList() async {
    if (_listNameController.text.trim().isEmpty) {
      _showErrorMessage('Please enter a list name');
      return;
    }

    try {
      // This would call the backend API
      // final shareCode = await ApiService.createSharedList(_listNameController.text);
      
      _showSuccessMessage('Shared list created successfully!');
      _listNameController.clear();
      Navigator.of(context).pop();
      await _loadSharedLists();
    } catch (e) {
      _showErrorMessage('Error creating shared list: $e');
    }
  }

  Future<void> _joinSharedList() async {
    if (_shareCodeController.text.trim().isEmpty) {
      _showErrorMessage('Please enter a share code');
      return;
    }

    try {
      // This would call the backend API
      // await ApiService.joinSharedList(_shareCodeController.text);
      
      _showSuccessMessage('Joined shared list successfully!');
      _shareCodeController.clear();
      Navigator.of(context).pop();
      await _loadSharedLists();
    } catch (e) {
      _showErrorMessage('Error joining shared list: $e');
    }
  }

  void _copyShareCode(String shareCode) {
    Clipboard.setData(ClipboardData(text: shareCode));
    _showSuccessMessage('Share code copied to clipboard');
  }

  void _showCreateListDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Shared List'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _listNameController,
              decoration: const InputDecoration(
                labelText: 'List Name',
                hintText: 'Enter list name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _createSharedList,
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showJoinListDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join Shared List'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _shareCodeController,
              decoration: const InputDecoration(
                labelText: 'Share Code',
                hintText: 'Enter 6-digit code',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _joinSharedList,
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessMessage(String message) {
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
        title: const Text('Shared Lists'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'create') {
                _showCreateListDialog();
              } else if (value == 'join') {
                _showJoinListDialog();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'create',
                child: Row(
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text('Create List'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'join',
                child: Row(
                  children: [
                    Icon(Icons.person_add),
                    SizedBox(width: 8),
                    Text('Join List'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadSharedLists,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _sharedLists.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No shared lists yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create a new list or join an existing one',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: _showCreateListDialog,
                                icon: const Icon(Icons.add),
                                label: const Text('Create List'),
                              ),
                              const SizedBox(width: 16),
                              OutlinedButton.icon(
                                onPressed: _showJoinListDialog,
                                icon: const Icon(Icons.person_add),
                                label: const Text('Join List'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _sharedLists.length,
                    itemBuilder: (context, index) {
                      final list = _sharedLists[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: list['isOwner'] 
                                ? Theme.of(context).primaryColor 
                                : Colors.grey[400],
                            child: Icon(
                              list['isOwner'] ? Icons.admin_panel_settings : Icons.people,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            list['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${list['itemCount']} items'),
                              const SizedBox(height: 4),
                              Text(
                                'Shared with ${list['sharedWith'].length} people',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () => _copyShareCode(list['shareCode']),
                                tooltip: 'Copy share code',
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                          onTap: () {
                            // Navigate to shared list details
                            _showListDetails(list);
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  void _showListDetails(Map<String, dynamic> list) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(list['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Share Code: ${list['shareCode']}'),
            const SizedBox(height: 8),
            Text('Role: ${list['isOwner'] ? 'Owner' : 'Member'}'),
            const SizedBox(height: 8),
            Text('Items: ${list['itemCount']}'),
            const SizedBox(height: 8),
            const Text('Shared with:'),
            ...list['sharedWith'].map<Widget>((email) => 
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 4),
                child: Text('• $email'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => _copyShareCode(list['shareCode']),
            child: const Text('Copy Code'),
          ),
          if (list['isOwner'])
            TextButton(
              onPressed: () {
                // Implement regenerate share code
                Navigator.of(context).pop();
                _showSuccessMessage('Share code regenerated');
              },
              child: const Text('Regenerate Code'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

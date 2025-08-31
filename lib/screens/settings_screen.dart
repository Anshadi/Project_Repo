import 'package:flutter/material.dart';
import '../services/theme_service.dart';
import '../services/api_service.dart';
import 'user_profile_screen.dart';
import 'shared_lists_screen.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const SettingsScreen({
    super.key,
    required this.onThemeToggle,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  bool _voiceFeedbackEnabled = true;

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian'
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final isDark = await ThemeService.getThemePreference();
    setState(() {
      _isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // App Theme Section
          _buildSectionCard(
            title: 'Appearance',
            icon: Icons.palette_outlined,
            children: [
              _buildSwitchTile(
                title: 'Dark Mode',
                subtitle: 'Use dark theme throughout the app',
                icon: isDark ? Icons.dark_mode : Icons.light_mode,
                value: _isDarkMode,
                onChanged: (value) {
                  setState(() {
                    _isDarkMode = value;
                  });
                  widget.onThemeToggle();
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Voice & Language Section
          _buildSectionCard(
            title: 'Voice & Language',
            icon: Icons.mic_outlined,
            children: [
              _buildDropdownTile(
                title: 'Language',
                subtitle: 'Choose your preferred language',
                icon: Icons.language,
                value: _selectedLanguage,
                items: _languages,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                },
              ),
              _buildSwitchTile(
                title: 'Voice Feedback',
                subtitle: 'Play sounds when voice commands are processed',
                icon: Icons.volume_up_outlined,
                value: _voiceFeedbackEnabled,
                onChanged: (value) {
                  setState(() {
                    _voiceFeedbackEnabled = value;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Notifications Section
          _buildSectionCard(
            title: 'Notifications',
            icon: Icons.notifications_outlined,
            children: [
              _buildSwitchTile(
                title: 'Push Notifications',
                subtitle: 'Receive shopping reminders and updates',
                icon: Icons.notifications,
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Account Section
          _buildSectionCard(
            title: 'Account',
            icon: Icons.person_outline,
            children: [
              _buildListTile(
                title: 'User Profile',
                subtitle: 'Manage your personal information and preferences',
                icon: Icons.person,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const UserProfileScreen(),
                    ),
                  );
                },
              ),
              _buildListTile(
                title: 'Shared Lists',
                subtitle: 'Manage lists shared with family and friends',
                icon: Icons.people,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SharedListsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Data & Privacy Section
          _buildSectionCard(
            title: 'Data & Privacy',
            icon: Icons.privacy_tip_outlined,
            children: [
              _buildListTile(
                title: 'Clear Shopping History',
                subtitle: 'Remove all purchase history data',
                icon: Icons.delete_outline,
                onTap: () => _showClearHistoryDialog(),
              ),
              _buildListTile(
                title: 'Export Data',
                subtitle: 'Download your shopping data',
                icon: Icons.download_outlined,
                onTap: () => _showExportDialog(),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // About Section
          _buildSectionCard(
            title: 'About',
            icon: Icons.info_outline,
            children: [
              _buildListTile(
                title: 'App Version',
                subtitle: '1.0.0',
                icon: Icons.info,
                onTap: null,
              ),
              _buildListTile(
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                icon: Icons.policy_outlined,
                onTap: () => _showPrivacyPolicy(),
              ),
              _buildListTile(
                title: 'Terms of Service',
                subtitle: 'View terms and conditions',
                icon: Icons.gavel_outlined,
                onTap: () => _showTermsOfService(),
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: onTap != null
          ? Icon(Icons.chevron_right, color: Colors.grey[400])
          : null,
      onTap: onTap,
    );
  }

  void _showClearHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Shopping History'),
        content: const Text(
          'Are you sure you want to delete all your shopping history? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _clearHistoryData();
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text(
          'Your shopping data will be exported as a CSV file. This includes your shopping history, preferences, and statistics.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSnackBar('Data export started. Check your downloads.');
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Voice Shopping Assistant Privacy Policy\n\n'
            'We are committed to protecting your privacy. This policy explains how we collect, use, and protect your information.\n\n'
            '• Voice data is processed locally on your device\n'
            '• Shopping lists are stored securely\n'
            '• We do not share your data with third parties\n'
            '• You can delete your data at any time\n\n'
            'For more information, visit our website.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'Voice Shopping Assistant Terms of Service\n\n'
            'By using this app, you agree to the following terms:\n\n'
            '• Use the app responsibly and legally\n'
            '• Voice commands are processed to provide service\n'
            '• We reserve the right to update these terms\n'
            '• You are responsible for your shopping decisions\n\n'
            'Thank you for using Voice Shopping Assistant!',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearHistoryData() async {
    try {
      final success = await ApiService.clearHistory();
      if (success) {
        _showSnackBar('Shopping history cleared successfully');
      } else {
        _showSnackBar('Failed to clear history. Please try again.');
      }
    } catch (e) {
      _showSnackBar('Error clearing history: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

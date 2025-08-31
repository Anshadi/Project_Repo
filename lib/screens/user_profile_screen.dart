import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  bool _voiceEnabled = true;
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  String _preferredLanguage = 'English';
  String _preferredUnit = 'Metric';
  bool _isLoading = false;

  final List<String> _languages = ['English', 'Spanish', 'French', 'German'];
  final List<String> _units = ['Metric', 'Imperial'];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // This would call the backend API
      // final userProfile = await ApiService.getUserProfile();
      // For now, using mock data
      setState(() {
        _nameController.text = 'John Doe';
        _emailController.text = 'john.doe@example.com';
        _phoneController.text = '+1 (555) 123-4567';
        _voiceEnabled = true;
        _pushNotifications = true;
        _emailNotifications = false;
        _preferredLanguage = 'English';
        _preferredUnit = 'Metric';
      });
    } catch (e) {
      _showErrorMessage('Error loading profile: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_nameController.text.trim().isEmpty || _emailController.text.trim().isEmpty) {
      _showErrorMessage('Name and email are required');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // This would call the backend API with the collected data
      // await ApiService.updateUserProfile({
      //   'name': _nameController.text.trim(),
      //   'email': _emailController.text.trim(),
      //   'phone': _phoneController.text.trim(),
      // });
      // await ApiService.updateUserPreferences({
      //   'voiceEnabled': _voiceEnabled,
      //   'pushNotifications': _pushNotifications,
      //   'emailNotifications': _emailNotifications,
      //   'preferredLanguage': _preferredLanguage,
      //   'preferredUnit': _preferredUnit,
      // });

      _showSuccessMessage('Profile updated successfully!');
    } catch (e) {
      _showErrorMessage('Error updating profile: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _updateProfile,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personal Information',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Full Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Preferences Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Preferences',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          
                          // Voice Recognition
                          SwitchListTile(
                            title: const Text('Voice Recognition'),
                            subtitle: const Text('Enable voice commands'),
                            value: _voiceEnabled,
                            onChanged: (value) {
                              setState(() {
                                _voiceEnabled = value;
                              });
                            },
                          ),

                          // Push Notifications
                          SwitchListTile(
                            title: const Text('Push Notifications'),
                            subtitle: const Text('Receive app notifications'),
                            value: _pushNotifications,
                            onChanged: (value) {
                              setState(() {
                                _pushNotifications = value;
                              });
                            },
                          ),

                          // Email Notifications
                          SwitchListTile(
                            title: const Text('Email Notifications'),
                            subtitle: const Text('Receive email updates'),
                            value: _emailNotifications,
                            onChanged: (value) {
                              setState(() {
                                _emailNotifications = value;
                              });
                            },
                          ),

                          const Divider(),

                          // Language Preference
                          ListTile(
                            title: const Text('Language'),
                            subtitle: Text(_preferredLanguage),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              _showLanguageDialog();
                            },
                          ),

                          // Unit Preference
                          ListTile(
                            title: const Text('Units'),
                            subtitle: Text(_preferredUnit),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              _showUnitDialog();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Account Actions
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Account Actions',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          
                          ListTile(
                            leading: const Icon(Icons.lock_reset),
                            title: const Text('Change Password'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              _showChangePasswordDialog();
                            },
                          ),

                          ListTile(
                            leading: const Icon(Icons.download),
                            title: const Text('Export Data'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              _showSuccessMessage('Data export started');
                            },
                          ),

                          ListTile(
                            leading: const Icon(Icons.delete_forever, color: Colors.red),
                            title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              _showDeleteAccountDialog();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _updateProfile,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _languages.map((language) {
            return RadioListTile<String>(
              title: Text(language),
              value: language,
              groupValue: _preferredLanguage,
              onChanged: (value) {
                setState(() {
                  _preferredLanguage = value!;
                });
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showUnitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Units'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _units.map((unit) {
            return RadioListTile<String>(
              title: Text(unit),
              value: unit,
              groupValue: _preferredUnit,
              onChanged: (value) {
                setState(() {
                  _preferredUnit = value!;
                });
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newPasswordController.text != confirmPasswordController.text) {
                _showErrorMessage('Passwords do not match');
                return;
              }
              // Implement password change
              Navigator.of(context).pop();
              _showSuccessMessage('Password changed successfully');
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showErrorMessage('Account deletion is not implemented yet');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

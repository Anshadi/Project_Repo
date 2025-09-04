import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _userIdKey = 'user_id';              // It is just a placeholder for key in the local storage 
  static const String _userNameKey = 'user_name';

  static String? _currentUserId;
  static String? _currentUserName;

  /// Initialize user service and get or create user ID
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    // Gets existing user ID or generate new one
    _currentUserId = prefs.getString(_userIdKey);
    if (_currentUserId == null) {
      _currentUserId = _generateUserId();
      await prefs.setString(_userIdKey, _currentUserId!);
    }

    // Gets user name or set default
    _currentUserName = prefs.getString(_userNameKey) ?? 'Shopping User';
  }

  /// Gets current user ID
  static String get currentUserId {
    if (_currentUserId == null) {
      throw Exception(
          'UserService not initialized. Call UserService.initialize() first.');
    }
    return _currentUserId!;
  }

  /// Gets current user name
  static String get currentUserName {
    return _currentUserName ?? 'Shopping User';
  }

  /// Sets user name
  static Future<void> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserName = name;
    await prefs.setString(_userNameKey, name);
  }

  /// Checks if user is initialized
  static bool get isInitialized => _currentUserId != null;

  /// Generates a unique user ID
  static String _generateUserId() {
    return 'user123'; // Using consistent user ID for development
  }

  /// Reset user (for testing or demo purposes)
  static Future<void> resetUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    _currentUserId = null;
    _currentUserName = null;
    await initialize();
  }
}

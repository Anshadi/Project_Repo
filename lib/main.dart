import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'services/theme_service.dart';

void main() {
  runApp(const VoiceShoppingApp());
}

class VoiceShoppingApp extends StatefulWidget {
  const VoiceShoppingApp({super.key});

  @override
  State<VoiceShoppingApp> createState() => _VoiceShoppingAppState();
}

class _VoiceShoppingAppState extends State<VoiceShoppingApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final isDark = await ThemeService.getThemePreference();
    setState(() {
      _isDarkMode = isDark;
    });
  }

  void _toggleTheme() async {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    await ThemeService.setThemePreference(_isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,          // here i do not need to mention the keyword theme and darkTheme , These are inbuilt words in Flutter , Will get automatically choosen when we choose ThemeMode.dark or ThemeMode.light .
      home: SplashScreen(onThemeToggle: _toggleTheme),
      debugShowCheckedModeBanner: false,
    );
  }
}

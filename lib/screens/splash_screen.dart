import 'package:flutter/material.dart';
import 'main_navigation.dart';
import '../services/speech_service.dart';
import '../services/user_service.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const SplashScreen({
    super.key,
    required this.onThemeToggle,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize user service
    await UserService.initialize();

    // Initialize speech service
    await SpeechService.initialize();

    // Wait for splash screen duration
    await Future.delayed(const Duration(seconds: 3));

    // Navigate to main app
    if (mounted) {                                    // It is where i as a user see the logo screen 
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainNavigation(
            onThemeToggle: widget.onThemeToggle,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 60,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 30),

            // App Name
            const Text(
              'Shopping Assistant',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            // Subtitle
            const Text(
              'Voice-Powered Shopping Lists',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 50),

            // Loading indicator
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

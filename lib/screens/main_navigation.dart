import 'package:flutter/material.dart';
import 'shopping_list_screen.dart';
import 'search_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class MainNavigation extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const MainNavigation({
    super.key,                              //Here we have used key in the Main Navigation , so that when flutter builds it again on the state change , so it builds only the nescessary things
    required this.onThemeToggle,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  List<Widget> get _screens => [
        const ShoppingListScreen(),
        const SearchScreen(),
        const HistoryScreen(),
        SettingsScreen(onThemeToggle: widget.onThemeToggle),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [                  //Items property of Bottom navigation Bar , No children or child here , Expects list of items - having Icon and label
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Shopping List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

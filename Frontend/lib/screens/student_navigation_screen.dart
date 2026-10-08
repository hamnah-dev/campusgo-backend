import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'student_profile_screen.dart';
import '../theme/app_theme.dart';

class StudentNavigationScreen extends StatefulWidget {
  const StudentNavigationScreen({super.key});

  @override
  State<StudentNavigationScreen> createState() =>
      _StudentNavigationScreenState();
}

class _StudentNavigationScreenState
    extends State<StudentNavigationScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens = [
    const HomeScreen(),
    const StudentSearchScreen(),
    const StudentOrdersScreen(),
    const StudentProfileScreen(),
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        backgroundColor: AppColors.cream,
        indicatorColor:
            AppColors.terracotta.withValues(alpha: 0.18),
        elevation: 0,

        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              color: AppColors.muted,
            ),
            selectedIcon: Icon(
              Icons.home_rounded,
              color: AppColors.forest,
            ),
            label: 'Home',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.search_outlined,
              color: AppColors.muted,
            ),
            selectedIcon: Icon(
              Icons.search_rounded,
              color: AppColors.forest,
            ),
            label: 'Search',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.receipt_long_outlined,
              color: AppColors.muted,
            ),
            selectedIcon: Icon(
              Icons.receipt_long_rounded,
              color: AppColors.forest,
            ),
            label: 'Orders',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.person_outline_rounded,
              color: AppColors.muted,
            ),
            selectedIcon: Icon(
              Icons.person_rounded,
              color: AppColors.forest,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TEMPORARY SEARCH SCREEN
// ============================================================

class StudentSearchScreen extends StatelessWidget {
  const StudentSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Search Screen',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.forest,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// TEMPORARY ORDERS SCREEN
// ============================================================

class StudentOrdersScreen extends StatelessWidget {
  const StudentOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Orders Screen',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.forest,
          ),
        ),
      ),
    );
  }
}


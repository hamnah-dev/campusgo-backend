import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'vendor_menu_screen.dart';
import 'vendor_profile_screen.dart';

class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({super.key});

  @override
  State<VendorDashboardScreen> createState() =>
      _VendorDashboardScreenState();
}

class _VendorDashboardScreenState
    extends State<VendorDashboardScreen> {
  int _selectedIndex = 0;

  bool isOpen = true;

  final List<VendorFoodItem> popularItems = [
    VendorFoodItem(
      name: 'Chicken Burger',
      description: 'Crispy chicken burger with fresh vegetables.',
      price: 450,
      category: 'Fast Food',
      preparationTime: 15,
      isAvailable: true,
    ),
    VendorFoodItem(
      name: 'Loaded Fries',
      description: 'Crispy fries with cheese and special sauce.',
      price: 350,
      category: 'Fast Food',
      preparationTime: 10,
      isAvailable: true,
    ),
    VendorFoodItem(
      name: 'Cold Coffee',
      description: 'Creamy chilled coffee.',
      price: 280,
      category: 'Drinks',
      preparationTime: 5,
      isAvailable: true,
    ),
  ];

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature is coming soon.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openMenu() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VendorMenuScreen(
          initialItems: popularItems,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,

      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        title: const Text(
          'Campus Eats',
          style: TextStyle(
            color: AppColors.forest,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: _buildSelectedPage(),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.peach,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedPage() {
    switch (_selectedIndex) {
      case 1:
        return _buildOrdersPage();

      case 2:
        return _buildMenuPage();

      case 3:
        return const VendorProfileScreen();

      default:
        return _buildDashboardPage();
    }
  }

  Widget _buildDashboardPage() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.forest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.storefront,
                        color: AppColors.white,
                        size: 27,
                      ),
                    ),

                    const Spacer(),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isOpen = !isOpen;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isOpen
                              ? AppColors.sage.withValues(alpha: 0.18)
                              : AppColors.peach.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: isOpen
                                    ? AppColors.forest
                                    : AppColors.terracotta,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 7),
                            Text(
                              isOpen ? 'OPEN' : 'CLOSED',
                              style: TextStyle(
                                color: isOpen
                                    ? AppColors.forest
                                    : AppColors.terracotta,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const Text(
                  'Good morning,',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'Campus Café',
                  style: TextStyle(
                    color: AppColors.forest,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 24),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.55,
                  children: [
                    _statCard(
                      title: "Today's Orders",
                      value: '24',
                      icon: Icons.receipt_long,
                    ),
                    _statCard(
                      title: 'Pending',
                      value: '6',
                      icon: Icons.pending_actions,
                    ),
                    _statCard(
                      title: 'Completed',
                      value: '18',
                      icon: Icons.check_circle_outline,
                    ),
                    _statCard(
                      title: "Today's Revenue",
                      value: 'Rs 8.4K',
                      icon: Icons.payments_outlined,
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Popular Items',
                      style: TextStyle(
                        color: AppColors.charcoal,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextButton(
                      onPressed: _openMenu,
                      child: const Text(
                        'Manage Menu',
                        style: TextStyle(
                          color: AppColors.forest,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                ...popularItems.map(_foodItemCard),

                const SizedBox(height: 20),

                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    color: AppColors.charcoal,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _quickAction(
                        icon: Icons.restaurant_menu,
                        title: 'Manage Menu',
                        onTap: _openMenu,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _quickAction(
                        icon: Icons.receipt_long,
                        title: 'View Orders',
                        onTap: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.forest,
            size: 21,
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.forest,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _foodItemCard(VendorFoodItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.peach.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.fastfood_outlined,
              color: AppColors.forest,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    color: AppColors.charcoal,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rs ${item.price.toStringAsFixed(0)} • ${item.preparationTime} min',
                  style: const TextStyle(
                    color: AppColors.terracotta,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: item.isAvailable,
            activeThumbColor: AppColors.forest,
            onChanged: (value) {
              setState(() {
                item.isAvailable = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.forest,
              size: 26,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.charcoal,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersPage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              size: 65,
              color: AppColors.forest,
            ),
            const SizedBox(height: 20),
            const Text(
              'Orders',
              style: TextStyle(
                color: AppColors.forest,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your incoming campus orders will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuPage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Manage Menu',
                  style: TextStyle(
                    color: AppColors.forest,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: _openMenu,
                icon: const Icon(Icons.add),
                label: const Text('Add'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.forest,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: popularItems.length,
            itemBuilder: (context, index) {
              return _foodItemCard(popularItems[index]);
            },
          ),
        ),
      ],
    );
  }
}

class VendorFoodItem {
  final String name;
  final String description;
  final double price;
  final String category;
  final int preparationTime;
  bool isAvailable;
  final String? imageUrl;

  VendorFoodItem({
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.preparationTime,
    required this.isAvailable,
    this.imageUrl,
  });
}
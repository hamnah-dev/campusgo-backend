import 'package:flutter/material.dart';
import '../services/vendor_service.dart';
import '../theme/app_theme.dart';
import 'student_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'All';
  String _selectedSort = 'Rating';

    List<String> _categories = ['All'];

  List<Map<String, dynamic>> _vendors = [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final categories = await VendorService.fetchCategories();
      final vendors = await VendorService.fetchVendors();

      if (!mounted) return;

      setState(() {
        _categories = categories;
        _vendors = vendors;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Could not load vendors. Please try again.';
        _isLoading = false;
      });
    }
  }

  
  List<Map<String, dynamic>> get _filteredVendors {
    List<Map<String, dynamic>> result = List.from(_vendors);

    if (_selectedCategory != 'All') {
      result = result
          .where((vendor) => vendor['category'] == _selectedCategory)
          .toList();
    }

    final search = _searchController.text.trim().toLowerCase();

    if (search.isNotEmpty) {
      result = result.where((vendor) {
        final name = vendor['name'].toString().toLowerCase();
        final category = vendor['category'].toString().toLowerCase();

        return name.contains(search) || category.contains(search);
      }).toList();
    }

    if (_selectedSort == 'Rating') {
      result.sort(
        (a, b) => (b['rating'] as double).compareTo(a['rating'] as double),
      );
    } else {
      result.sort((a, b) => (a['price'] as int).compareTo(b['price'] as int));
    }

    return result;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature is coming soon.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,

      // ONLY ONE TOP BAR
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

      // MAIN CONTENT
      body: _buildCurrentPage(),
    );
  }

  Widget _buildCurrentPage() {
    switch (_selectedIndex) {
      case 1:
        return _buildOrdersPage();

      case 2:
        return _buildCartPage();

      case 3:
        return const StudentProfileScreen();

      case 0:
      default:
        return _buildHomePage();
    }
  }

  // =========================
  // HOME
  // =========================

  Widget _buildHomePage() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Good afternoon',
                  style: TextStyle(color: AppColors.muted, fontSize: 14),
                ),

                const SizedBox(height: 5),

                const Text(
                  'What are you craving?',
                  style: TextStyle(
                    color: AppColors.forest,
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 18),

                // SEARCH
                TextField(
                  controller: _searchController,
                  onChanged: (_) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'Search food or vendors',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.forest,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.close),
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'Explore',
                  style: TextStyle(
                    color: AppColors.charcoal,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 12),

                // CATEGORIES
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final selected = category == _selectedCategory;

                      return ChoiceChip(
                        label: Text(category),
                        selected: selected,
                        onSelected: (_) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        selectedColor: AppColors.forest,
                        backgroundColor: AppColors.white,
                        side: BorderSide.none,
                        labelStyle: TextStyle(
                          color: selected
                              ? AppColors.white
                              : AppColors.charcoal,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 25),

                // VENDORS HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Nearby vendors',
                      style: TextStyle(
                        color: AppColors.charcoal,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    PopupMenuButton<String>(
                      initialValue: _selectedSort,
                      onSelected: (value) {
                        setState(() {
                          _selectedSort = value;
                        });
                      },
                      itemBuilder: (context) {
                        return const [
                          PopupMenuItem(
                            value: 'Rating',
                            child: Text('Sort by Rating'),
                          ),
                          PopupMenuItem(
                            value: 'Price',
                            child: Text('Sort by Price'),
                          ),
                        ];
                      },
                      child: const Icon(Icons.tune, color: AppColors.forest),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // VENDOR LIST
                                // VENDOR LIST
                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator(
                        color: AppColors.forest,
                      ),
                    ),
                  )
                else if (_errorMessage != null)
                  Center(
                    child: Column(
                      children: [
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: AppColors.muted),
                        ),
                        TextButton(
                          onPressed: _loadHomeData,
                          child: const Text(
                            'Retry',
                            style: TextStyle(color: AppColors.forest),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ..._filteredVendors.map(_vendorCard),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _vendorCard(Map<String, dynamic> vendor) {
    final bool isOpen = vendor['isOpen'];

    return GestureDetector(
      onTap: () {
        _showComingSoon('${vendor['name']} menu');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: SizedBox(
                height: 150,
                width: double.infinity,
                child: Image.network(
                  vendor['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) {
                    return Container(
                      color: AppColors.peach,
                      child: const Center(
                        child: Icon(
                          Icons.restaurant,
                          size: 45,
                          color: AppColors.forest,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          vendor['name'],
                          style: const TextStyle(
                            color: AppColors.charcoal,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: isOpen
                              ? AppColors.sage.withValues(alpha: 0.18)
                              : AppColors.peach.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isOpen ? 'OPEN' : 'CLOSED',
                          style: TextStyle(
                            color: isOpen
                                ? AppColors.forest
                                : AppColors.terracotta,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 17,
                        color: AppColors.terracotta,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${vendor['rating']}',
                        style: const TextStyle(
                          color: AppColors.charcoal,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(width: 15),

                      const Icon(
                        Icons.access_time,
                        size: 17,
                        color: AppColors.muted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        vendor['time'],
                        style: const TextStyle(color: AppColors.muted),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Text(
                        'Rs ${vendor['price']} avg.',
                        style: const TextStyle(
                          color: AppColors.terracotta,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const Spacer(),

                      if (vendor['delivery'])
                        const Icon(
                          Icons.delivery_dining,
                          size: 19,
                          color: AppColors.forest,
                        ),

                      if (vendor['delivery'] && vendor['pickup'])
                        const SizedBox(width: 8),

                      if (vendor['pickup'])
                        const Icon(
                          Icons.storefront_outlined,
                          size: 19,
                          color: AppColors.forest,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // ORDERS
  // =========================

  Widget _buildOrdersPage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: AppColors.peach.withValues(alpha: 0.45),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 38,
                color: AppColors.forest,
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'My Orders',
              style: TextStyle(
                color: AppColors.forest,
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Your food orders will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted, fontSize: 14),
            ),

            const SizedBox(height: 24),

            FilledButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
              style: FilledButton.styleFrom(backgroundColor: AppColors.forest),
              child: const Text('Browse Vendors'),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // CART
  // =========================

  Widget _buildCartPage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: AppColors.peach.withValues(alpha: 0.45),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 38,
                color: AppColors.forest,
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Your Cart',
              style: TextStyle(
                color: AppColors.forest,
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Items you add from a vendor will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted, fontSize: 14),
            ),

            const SizedBox(height: 24),

            FilledButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
              style: FilledButton.styleFrom(backgroundColor: AppColors.forest),
              child: const Text('Explore Food'),
            ),
          ],
        ),
      ),
    );
  }
}

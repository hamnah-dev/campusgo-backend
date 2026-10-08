import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'vendor_dashboard_screen.dart';

class VendorMenuScreen extends StatefulWidget {
  final List<VendorFoodItem> initialItems;

  const VendorMenuScreen({
    super.key,
    required this.initialItems,
  });

  @override
  State<VendorMenuScreen> createState() => _VendorMenuScreenState();
}

class _VendorMenuScreenState extends State<VendorMenuScreen> {
  late List<VendorFoodItem> menuItems;

  @override
  void initState() {
    super.initState();
    menuItems = List.from(widget.initialItems);
  }

  // ------------------------------------------------------------
  // ADD FOOD ITEM
  // ------------------------------------------------------------

  void _showAddItemDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final preparationController = TextEditingController();
    final imageController = TextEditingController();

    String selectedCategory = 'Fast Food';
    bool isAvailable = true;

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.cream,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: const Text(
                'Add Food Item',
                style: TextStyle(
                  color: AppColors.forest,
                  fontWeight: FontWeight.w800,
                ),
              ),
              content: SizedBox(
                width: 450,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        _dialogField(
                          controller: nameController,
                          label: 'Name',
                          icon: Icons.fastfood_outlined,
                        ),
                        _dialogField(
                          controller: descriptionController,
                          label: 'Description',
                          icon: Icons.description_outlined,
                        ),
                        _dialogField(
                          controller: priceController,
                          label: 'Price',
                          icon: Icons.payments_outlined,
                          keyboardType: TextInputType.number,
                        ),
                        _dialogField(
                          controller: preparationController,
                          label: 'Preparation Time (minutes)',
                          icon: Icons.timer_outlined,
                          keyboardType: TextInputType.number,
                        ),
                        _dialogField(
                          controller: imageController,
                          label: 'Image URL (optional)',
                          icon: Icons.image_outlined,
                          requiredField: false,
                        ),

                        const SizedBox(height: 8),

                        // CATEGORY
                        DropdownButtonFormField<String>(
                          initialValue: selectedCategory,
                          decoration: _dialogDecoration(
                            'Category',
                            Icons.category_outlined,
                          ),
                          items: const [
                            'Fast Food',
                            'Pizza',
                            'Desi',
                            'Drinks',
                            'Desserts',
                            'Healthy',
                          ].map((category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setDialogState(() {
                                selectedCategory = value;
                              });
                            }
                          },
                        ),

                        const SizedBox(height: 12),

                        // AVAILABILITY
                        SwitchListTile(
                          value: isAvailable,
                          onChanged: (value) {
                            setDialogState(() {
                              isAvailable = value;
                            });
                          },
                          title: const Text(
                            'Available',
                            style: TextStyle(
                              color: AppColors.charcoal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          activeThumbColor: AppColors.forest,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppColors.muted,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }

                    setState(() {
                      menuItems.add(
                        VendorFoodItem(
                          name: nameController.text.trim(),
                          description: descriptionController.text.trim(),
                          price: double.parse(
                            priceController.text.trim(),
                          ),
                          category: selectedCategory,
                          preparationTime: int.parse(
                            preparationController.text.trim(),
                          ),
                          isAvailable: isAvailable,
                          imageUrl:
                              imageController.text.trim().isEmpty
                                  ? null
                                  : imageController.text.trim(),
                        ),
                      );
                    });

                    Navigator.pop(dialogContext);

                    _showMessage(
                      'Food item added successfully',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.forest,
                    foregroundColor: AppColors.white,
                  ),
                  child: const Text('Add Item'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ------------------------------------------------------------
  // EDIT FOOD ITEM
  // ------------------------------------------------------------

  void _showEditItemDialog(
    VendorFoodItem item,
    int index,
  ) {
    final nameController = TextEditingController(
      text: item.name,
    );

    final descriptionController = TextEditingController(
      text: item.description,
    );

    final priceController = TextEditingController(
      text: item.price.toString(),
    );

    final preparationController = TextEditingController(
      text: item.preparationTime.toString(),
    );

    String selectedCategory = item.category;
    bool isAvailable = item.isAvailable;

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.cream,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: const Text(
                'Edit Food Item',
                style: TextStyle(
                  color: AppColors.forest,
                  fontWeight: FontWeight.w800,
                ),
              ),
              content: SizedBox(
                width: 450,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        _dialogField(
                          controller: nameController,
                          label: 'Name',
                          icon: Icons.fastfood_outlined,
                        ),
                        _dialogField(
                          controller: descriptionController,
                          label: 'Description',
                          icon: Icons.description_outlined,
                        ),
                        _dialogField(
                          controller: priceController,
                          label: 'Price',
                          icon: Icons.payments_outlined,
                          keyboardType: TextInputType.number,
                        ),
                        _dialogField(
                          controller: preparationController,
                          label: 'Preparation Time (minutes)',
                          icon: Icons.timer_outlined,
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(height: 8),

                        // CATEGORY
                        DropdownButtonFormField<String>(
                          initialValue: selectedCategory,
                          decoration: _dialogDecoration(
                            'Category',
                            Icons.category_outlined,
                          ),
                          items: const [
                            'Fast Food',
                            'Pizza',
                            'Desi',
                            'Drinks',
                            'Desserts',
                            'Healthy',
                          ].map((category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setDialogState(() {
                                selectedCategory = value;
                              });
                            }
                          },
                        ),

                        const SizedBox(height: 12),

                        // AVAILABILITY
                        SwitchListTile(
                          value: isAvailable,
                          onChanged: (value) {
                            setDialogState(() {
                              isAvailable = value;
                            });
                          },
                          title: const Text(
                            'Available',
                            style: TextStyle(
                              color: AppColors.charcoal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          activeThumbColor: AppColors.forest,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppColors.muted,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }

                    setState(() {
                      menuItems[index] = VendorFoodItem(
                        name: nameController.text.trim(),
                        description:
                            descriptionController.text.trim(),
                        price: double.parse(
                          priceController.text.trim(),
                        ),
                        category: selectedCategory,
                        preparationTime: int.parse(
                          preparationController.text.trim(),
                        ),
                        isAvailable: isAvailable,
                        imageUrl: item.imageUrl,
                      );
                    });

                    Navigator.pop(dialogContext);

                    _showMessage(
                      'Food item updated successfully',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.forest,
                    foregroundColor: AppColors.white,
                  ),
                  child: const Text('Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ------------------------------------------------------------
  // DELETE FOOD ITEM
  // ------------------------------------------------------------

  void _deleteItem(int index) {
    final item = menuItems[index];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.cream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Delete Food Item?',
            style: TextStyle(
              color: AppColors.forest,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${item.name}"?',
            style: const TextStyle(
              color: AppColors.muted,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.muted,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  menuItems.removeAt(index);
                });

                Navigator.pop(dialogContext);

                _showMessage(
                  'Food item deleted',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.terracotta,
                foregroundColor: AppColors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // ------------------------------------------------------------
  // SNACKBAR
  // ------------------------------------------------------------

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.forest,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ------------------------------------------------------------
  // DIALOG TEXT FIELD
  // ------------------------------------------------------------

  Widget _dialogField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool requiredField = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (requiredField &&
              (value == null || value.trim().isEmpty)) {
            return '$label is required';
          }

          if (label == 'Price' &&
              double.tryParse(value?.trim() ?? '') == null) {
            return 'Enter a valid price';
          }

          if (label.contains('Preparation') &&
              int.tryParse(value?.trim() ?? '') == null) {
            return 'Enter valid minutes';
          }

          return null;
        },
        decoration: _dialogDecoration(
          label,
          icon,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // INPUT DECORATION
  // ------------------------------------------------------------

  InputDecoration _dialogDecoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon,
        color: AppColors.forest,
      ),
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.forest,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // MAIN SCREEN
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.forest,
          ),
        ),
        title: const Text(
          'Manage Menu',
          style: TextStyle(
            color: AppColors.forest,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: _showAddItemDialog,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.forest,
                foregroundColor: AppColors.white,
              ),
              icon: const Icon(
                Icons.add_rounded,
              ),
            ),
          ),
        ],
      ),
      body: menuItems.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                22,
                12,
                22,
                30,
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return _menuItemCard(
                  menuItems[index],
                  index,
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddItemDialog,
        backgroundColor: AppColors.forest,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Food',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // FOOD ITEM CARD
  // ------------------------------------------------------------

  Widget _menuItemCard(
    VendorFoodItem item,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.sage.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.peach.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: item.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(17),
                        child: Image.network(
                          item.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) {
                            return const Icon(
                              Icons.fastfood_outlined,
                              color: AppColors.forest,
                              size: 28,
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.fastfood_outlined,
                        color: AppColors.forest,
                        size: 28,
                      ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        color: AppColors.charcoal,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Text(
                          'Rs ${item.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: AppColors.terracotta,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${item.preparationTime} min',
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.muted,
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditItemDialog(
                      item,
                      index,
                    );
                  } else if (value == 'delete') {
                    _deleteItem(index);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Divider(
            height: 1,
            color: Color(0xFFE9E4DB),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Text(
                item.isAvailable
                    ? 'Available'
                    : 'Unavailable',
                style: TextStyle(
                  color: item.isAvailable
                      ? AppColors.forest
                      : AppColors.terracotta,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const Spacer(),

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
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // EMPTY STATE
  // ------------------------------------------------------------

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.restaurant_menu_rounded,
              size: 55,
              color: AppColors.forest,
            ),

            const SizedBox(height: 18),

            const Text(
              'Your menu is empty',
              style: TextStyle(
                color: AppColors.forest,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Add your first food item to start building your menu.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.muted,
              ),
            ),

            const SizedBox(height: 22),

            ElevatedButton.icon(
              onPressed: _showAddItemDialog,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Food'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.forest,
                foregroundColor: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
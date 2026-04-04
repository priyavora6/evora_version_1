import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/app_strings.dart';
import '../../models/package_model.dart'; 
import '../../models/cart_item_model.dart';
import '../../providers/cart_provider.dart';
import 'widgets/package_card.dart'; 

class PackagesScreen extends StatelessWidget {
  final String sectionId;
  final String sectionName;

  const PackagesScreen({
    super.key,
    required this.sectionId,
    required this.sectionName,
  });

  // ➜ This is a new method to convert StaticPackage to Package
  Package _convertStaticToPackage(dynamic staticPackage) {
    return Package(
      id: staticPackage.id,
      sectionId: sectionId, 
      eventTypeId: '', // You may need to pass this from the previous screen
      name: staticPackage.name,
      description: staticPackage.description,
      price: staticPackage.price,
      images: List<String>.from(staticPackage.images),
      features: List<String>.from(staticPackage.features),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ➜ Using a FutureBuilder to simulate an async data fetch
    return FutureBuilder<List<Package>>(
      future: _getPackages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final packages = snapshot.data ?? [];

        return Scaffold(
          appBar: AppBar(
            title: Text(sectionName),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart_outlined),
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.cart);
                        },
                      ),
                      if (cartProvider.itemCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              cartProvider.itemCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // Header Info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.secondary.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(Icons.palette, size: 36, color: AppColors.primary),
                    const SizedBox(height: 12),
                    Text(
                      'Choose a Package',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select one package that suits your style and budget',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),

              // Packages List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: packages.length,
                  itemBuilder: (context, index) {
                    final package = packages[index];

                    return PackageCard(
                      package: package, 
                      sectionId: sectionId,
                      sectionName: sectionName,
                      onViewDetails: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.packageDetail,
                          arguments: {'packageId': package.id},
                        );
                      },
                      onSelect: () {
                        final cartProvider = Provider.of<CartProvider>(
                          context,
                          listen: false,
                        );

                        final existingItems = cartProvider.getItemsBySection(sectionId);
                        for (var item in existingItems) {
                          if (item.type == 'package') {
                            cartProvider.removeItem(item.id);
                          }
                        }

                        final cartItem = CartItem(
                          id: package.id,
                          sectionId: sectionId,
                          sectionName: sectionName,
                          itemName: package.name,
                          price: package.price,
                          quantity: 1,
                          image: package.images.isNotEmpty ? package.images.first : '',
                          type: 'package',
                        );

                        cartProvider.addItem(cartItem);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${package.name} selected'),
                            backgroundColor: AppColors.success,
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // Bottom Bar
              _buildBottomBar(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomBar() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final sectionItems = cartProvider.getItemsBySection(sectionId);
        final selectedPackage = sectionItems.where((item) => item.type == 'package').toList();

        if (selectedPackage.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedPackage.first.itemName,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${AppStrings.rupee}${selectedPackage.first.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ➜ This method simulates fetching and converting your static data
  Future<List<Package>> _getPackages() async {
    // In a real app, you'd fetch this from a database (e.g., Firebase)
    // For now, we're just converting your static data.
    await Future.delayed(const Duration(milliseconds: 200)); // Simulate network delay

    const staticPackages = [
      // ... (your StaticPackage data would be here)
    ];

    // ➜ Convert the static data to the Package model
    return staticPackages.map((p) => _convertStaticToPackage(p)).toList();
  }
}

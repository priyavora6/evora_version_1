import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_strings.dart';
// ✅ Import our new ServiceModel
import '../../../models/service_model.dart';
import '../../../providers/cart_provider.dart';

class PackageCard extends StatelessWidget {
  final ServiceModel service; // ✅ Changed from Package to ServiceModel
  final String subCategoryName;
  final VoidCallback onViewDetails;
  final VoidCallback onSelect;

  const PackageCard({
    super.key,
    required this.service,
    required this.subCategoryName,
    required this.onViewDetails,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Preview
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: SizedBox(
              height: 180,
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: service.image, // ✅ Using service.image
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.border,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.border,
                      child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                    ),
                  ),
                  // Badge (Dynamic based on name)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getBadgeColor(service.name),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getBadgeText(service.name),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        service.name,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      '₹${service.basePrice.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                Text(
                  service.description,
                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // Tags as "What's Included"
                if (service.tags.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  const Text('Highlights:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: service.tags.take(3).map((tag) => Chip(
                      label: Text(tag, style: const TextStyle(fontSize: 11)),
                      backgroundColor: AppColors.primary.withOpacity(0.05),
                      padding: EdgeInsets.zero,
                    )).toList(),
                  ),
                ],

                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onViewDetails,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('View Info'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Consumer<CartProvider>(
                        builder: (context, cart, child) {
                          // ✅ Check if this specific service is in cart
                          final isSelected = cart.items.any((item) => item.id.contains(service.id));

                          return isSelected
                              ? Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle, size: 20, color: Colors.green),
                                SizedBox(width: 8),
                                Text('Selected', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                              ],
                            ),
                          )
                              : ElevatedButton(
                            onPressed: onSelect,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Select', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getBadgeColor(String name) {
    if (name.toLowerCase().contains('basic')) return Colors.blue;
    if (name.toLowerCase().contains('premium')) return Colors.orange;
    if (name.toLowerCase().contains('royal') || name.toLowerCase().contains('luxury')) return Colors.purple;
    return AppColors.primary;
  }

  String _getBadgeText(String name) {
    if (name.toLowerCase().contains('basic')) return 'Budget Friendly';
    if (name.toLowerCase().contains('premium')) return 'Most Popular';
    if (name.toLowerCase().contains('royal') || name.toLowerCase().contains('luxury')) return 'Premium Choice';
    return 'Verified';
  }
}
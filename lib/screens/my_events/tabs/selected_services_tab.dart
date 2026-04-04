// lib/screens/my_events/tabs/selected_services_tab.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../config/app_colors.dart';
import '../../../providers/user_event_provider.dart';
import '../../../models/cart_item_model.dart';
import '../../../widgets/loading_indicator.dart';

class SelectedServicesTab extends StatelessWidget {
  final String eventId;

  const SelectedServicesTab({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    // 🔥 Use a StreamBuilder to get real-time services from the sub-collection
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('userEvents')
          .doc(eventId)
          .collection('selectedItems')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 64,
                  color: AppColors.secondary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  "No services selected.\nThis was a custom booking.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final items = snapshot.data!.docs
            .map((doc) => CartItem.fromMap(doc.data() as Map<String, dynamic>))
            .toList();

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 15),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getCategoryIcon(item.sectionName),
                    color: AppColors.primary,
                  ),
                ),
                title: Text(
                  item.itemName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  item.sectionName,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "₹${item.price.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 16,
                      ),
                    ),
                    const Text(
                      "Est. Cost",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 🎨 Helper to show correct icon for service type
  IconData _getCategoryIcon(String section) {
    String s = section.toLowerCase();
    if (s.contains('photography')) return Icons.camera_alt_outlined;
    if (s.contains('cake')) return Icons.cake_outlined;
    if (s.contains('decor')) return Icons.auto_awesome_mosaic_outlined;
    if (s.contains('food') || s.contains('cater')) return Icons.restaurant_menu;
    if (s.contains('music') || s.contains('dj')) return Icons.music_note;
    if (s.contains('makeup')) return Icons.face_retouching_natural;
    return Icons.check_circle_outline;
  }
}
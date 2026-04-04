// lib/screens/sections/widgets/section_card.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../models/section_model.dart';
import '../../../providers/cart_provider.dart';

class SectionCard extends StatelessWidget {
  final Section section;
  final VoidCallback onTap;

  const SectionCard({
    super.key,
    required this.section,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image/Icon
            Container(
              width: 100,
              height: 120,
              decoration: BoxDecoration(
                color: _getSectionColor(section.name).withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: section.image.isNotEmpty
                  ? ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: CachedNetworkImage(
                  imageUrl: section.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: Icon(
                      _getSectionIcon(section.name),
                      size: 40,
                      color: _getSectionColor(section.name),
                    ),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Icon(
                      _getSectionIcon(section.name),
                      size: 40,
                      color: _getSectionColor(section.name),
                    ),
                  ),
                ),
              )
                  : Center(
                child: Icon(
                  _getSectionIcon(section.name),
                  size: 40,
                  color: _getSectionColor(section.name),
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            section.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (section.isRequired)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Required',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.error,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      section.description.isNotEmpty
                          ? section.description
                          : 'Tap to explore options',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Consumer<CartProvider>(
                      builder: (context, cartProvider, child) {
                        final itemsInSection = cartProvider.getItemsBySection(section.id);

                        if (itemsInSection.isEmpty) {
                          return Row(
                            children: [
                              Icon(
                                Icons.arrow_forward,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Explore Options',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          );
                        }

                        final sectionTotal = cartProvider.getSectionTotal(section.id);

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 16,
                                color: AppColors.success,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${itemsInSection.length} selected • ₹${sectionTotal.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSectionIcon(String sectionName) {
    switch (sectionName.toLowerCase()) {
      case 'vidhi':
        return Icons.self_improvement;
      case 'decoration':
        return Icons.palette;
      case 'food':
      case 'catering':
        return Icons.restaurant;
      case 'sangeet':
      case 'music':
      case 'dj':
        return Icons.music_note;
      case 'photography':
        return Icons.camera_alt;
      case 'makeup':
        return Icons.face_retouching_natural;
      case 'invitation':
        return Icons.mail;
      case 'venue':
        return Icons.location_city;
      default:
        return Icons.category;
    }
  }

  Color _getSectionColor(String sectionName) {
    switch (sectionName.toLowerCase()) {
      case 'vidhi':
        return Colors.orange;
      case 'decoration':
        return Colors.pink;
      case 'food':
      case 'catering':
        return Colors.green;
      case 'sangeet':
      case 'music':
      case 'dj':
        return Colors.purple;
      case 'photography':
        return Colors.blue;
      case 'makeup':
        return Colors.red;
      case 'invitation':
        return Colors.teal;
      case 'venue':
        return Colors.indigo;
      default:
        return AppColors.primary;
    }
  }
}
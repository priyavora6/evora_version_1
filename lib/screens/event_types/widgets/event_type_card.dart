// lib/screens/event_types/widgets/event_type_card.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../config/app_colors.dart';
import '../../../models/event_type_model.dart';

class EventTypeCard extends StatelessWidget {
  final EventType eventType;
  final VoidCallback onTap;

  const EventTypeCard({
    super.key,
    required this.eventType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon or Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _getEventColor(eventType.name).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: eventType.image.isNotEmpty
                  ? ClipOval(
                child: CachedNetworkImage(
                  imageUrl: eventType.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Icon(
                    _getEventIcon(eventType.name),
                    size: 40,
                    color: _getEventColor(eventType.name),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    _getEventIcon(eventType.name),
                    size: 40,
                    color: _getEventColor(eventType.name),
                  ),
                ),
              )
                  : Icon(
                _getEventIcon(eventType.name),
                size: 40,
                color: _getEventColor(eventType.name),
              ),
            ),

            const SizedBox(height: 16),

            // Name
            Text(
              eventType.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 4),

            // Description
            if (eventType.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  eventType.description,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            const SizedBox(height: 8),

            // Arrow
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _getEventColor(eventType.name).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward,
                size: 16,
                color: _getEventColor(eventType.name),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getEventIcon(String eventName) {
    switch (eventName.toLowerCase()) {
      case 'marriage':
      case 'wedding':
        return Icons.favorite;
      case 'birthday':
        return Icons.cake;
      case 'engagement':
        return Icons.diamond;
      case 'anniversary':
        return Icons.celebration;
      case 'baby shower':
        return Icons.child_care;
      case 'corporate':
        return Icons.business;
      case 'graduation':
        return Icons.school;
      case 'housewarming':
        return Icons.home;
      default:
        return Icons.event;
    }
  }

  Color _getEventColor(String eventName) {
    switch (eventName.toLowerCase()) {
      case 'marriage':
      case 'wedding':
        return Colors.pink;
      case 'birthday':
        return Colors.orange;
      case 'engagement':
        return Colors.purple;
      case 'anniversary':
        return Colors.red;
      case 'baby shower':
        return Colors.teal;
      case 'corporate':
        return Colors.blue;
      case 'graduation':
        return Colors.indigo;
      case 'housewarming':
        return Colors.green;
      default:
        return AppColors.primary;
    }
  }
}
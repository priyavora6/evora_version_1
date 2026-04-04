import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/notification_provider.dart';

class VendorAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const VendorAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70); // Taller, modern height

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent, // Prevents tint on scroll
      elevation: 0,
      centerTitle: false,
      automaticallyImplyLeading: false,

      // 1. Make Status Bar Icons Dark (Time, Battery, etc.)
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light, // For iOS
      ),

      // 2. Subtle Bottom Border
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: Colors.grey.shade100,
          height: 1,
        ),
      ),

      // 3. Back Button Logic
      leadingWidth: showBackButton ? 56 : 16,
      leading: showBackButton
          ? Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Center(
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black87),
            onPressed: onBackPressed ?? () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey.shade50,
              shape: const CircleBorder(),
            ),
          ),
        ),
      )
          : const SizedBox(width: 16), // Padding if no back button

      // 4. Main Title Area
      title: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final vendor = authProvider.currentVendor;
          String businessName = vendor?.businessName ?? 'Vendor';

          // Logic: Capitalize first letter (photography -> Photography)
          if (businessName.isNotEmpty) {
            businessName = businessName[0].toUpperCase() + businessName.substring(1);
          }

          // If looking at a sub-page with back button, show Title only
          if (showBackButton) {
            return Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            );
          }

          // Dashboard View
          return Row(
            children: [
              // Circular Avatar
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                ),
                child: Center(
                  child: Text(
                    businessName.isNotEmpty ? businessName[0].toUpperCase() : "V",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Text Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      businessName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.green, // "Online" dot
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          title.toUpperCase(), // e.g. "DASHBOARD"
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade500,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),

      // 5. Notification Bell
      actions: [
        Consumer<NotificationProvider>(
          builder: (context, notificationProvider, _) {
            // Note: Ideally filter this count for vendor-specific notifications in provider
            final unreadCount = notificationProvider.unreadCount;

            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      // ✅ FIXED: Routes to Vendor Notification Screen
                      onPressed: () => Navigator.pushNamed(context, '/vendor-notifications'),
                      icon: const Icon(Icons.notifications_outlined, color: Colors.black54, size: 26),
                      splashRadius: 24,
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
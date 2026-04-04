import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../config/app_colors.dart';
import '../../models/guest_model.dart';

class GuestPassScreen extends StatelessWidget {
  final String eventId; // Needed for the Magic Link
  final String eventName;
  final GuestModel guest;

  const GuestPassScreen({
    super.key,
    required this.eventId,
    required this.eventName,
    required this.guest,
  });

  // 🔗 Share the "Magic Link"
  void _sharePass() {
    // Replace with your actual Firebase Hosting domain
    final String domain = "https://online-voting-system-76856.web.app";
    final String ticketLink = "$domain/ticket.html?event=$eventId&guest=${guest.id}";

    String message = "Hi ${guest.name}! 🎉\n\nHere is your official Entry Pass for $eventName.\n\nClick the link below to view your digital ticket and QR Code:\n$ticketLink";

    Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Digital Pass"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // 🎫 THE TICKET CARD
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    // TOP HALF (Event Info)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: Column(
                        children: [
                          if (guest.isVIP)
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star, size: 14, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text("VIP GUEST", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                ],
                              ),
                            ),
                          const Text(
                            "ENTRY PASS",
                            style: TextStyle(color: Colors.white70, letterSpacing: 2, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            eventName,
                            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    // MIDDLE (Tear Line)
                    Row(
                      children: [
                        Container(
                          width: 15,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade300, width: 2, style: BorderStyle.solid),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 15,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(30)),
                          ),
                        ),
                      ],
                    ),

                    // BOTTOM HALF (Guest Info & QR)
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Text(
                            guest.name,
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
                            textAlign: TextAlign.center,
                          ),
                          if (guest.phone.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(guest.phone, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                          ],

                          const SizedBox(height: 32),

                          // 🔥 THE GUEST'S UNIQUE QR CODE (Uses Document ID)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200, width: 2),
                            ),
                            child: QrImageView(
                              data: guest.id, // 🔥 SCANNER READS THIS ID
                              version: QrVersions.auto,
                              size: 200.0,
                              backgroundColor: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 16),
                          Text(
                            "Scan at entrance",
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // 📤 SHARE BUTTON
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _sharePass,
                  icon: const Icon(Icons.share, color: Colors.white),
                  label: const Text(
                    "Share Digital Pass via WhatsApp",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600, // WhatsApp Green
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Helper Text
              Text(
                "Guest will receive a magic link to view this ticket.",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
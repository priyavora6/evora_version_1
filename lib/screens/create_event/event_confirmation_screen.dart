
// lib/screens/create_event/event_confirmation_screen.dart

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../widgets/custom_button.dart';

class EventConfirmationScreen extends StatefulWidget {
  final String eventId;

  const EventConfirmationScreen({
    super.key,
    required this.eventId,
  });

  @override
  State<EventConfirmationScreen> createState() => _EventConfirmationScreenState();
}

class _EventConfirmationScreenState extends State<EventConfirmationScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    // Play confetti for 3 seconds
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // Success/Pending Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      size: 80,
                      color: AppColors.success,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Title (Updated)
                  const Text(
                    "Booking Request Sent!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // Description (Updated)
                  const Text(
                    "Your event request has been sent successfully. The status is currently 'Pending'. An admin will review and confirm your booking shortly.",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // Event ID Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Event ID',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.eventId.substring(0, 8).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // View Event Button
                  CustomButton(
                    text: 'View Event Details',
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.eventDetail,
                            (route) => route.settings.name == AppRoutes.dashboard,
                        arguments: {'eventId': widget.eventId},
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Go to Dashboard
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.dashboard,
                            (route) => false,
                      );
                    },
                    child: const Text(
                      'Go to Dashboard',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Confetti Animation
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                AppColors.primary,
                AppColors.secondary,
                AppColors.success,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
              numberOfParticles: 30,
              emissionFrequency: 0.05,
            ),
          ),
        ],
      ),
    );
  }
}

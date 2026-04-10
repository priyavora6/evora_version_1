import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_strings.dart';
import '../../../models/user_event_model.dart';
import '../../../providers/user_event_provider.dart';
import '../../dashboard/widgets/countdown_timer.dart';

class OverviewTab extends StatelessWidget {
  final UserEvent event;

  const OverviewTab({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    double paidAmount = 0.0;
    if (event.amountPaid is int) {
      paidAmount = (event.amountPaid as int).toDouble();
    } else if (event.amountPaid is double) {
      paidAmount = event.amountPaid as double;
    }

    double remainingAmount = event.totalEstimatedCost - paidAmount;
    if (remainingAmount < 0) remainingAmount = 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Countdown Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  'Time Remaining',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 12),
                CountdownTimer(eventDate: event.eventDate),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Event Details Card
          _buildDetailCard(
            title: 'Event Details',
            children: [
              // 🏆 PROPER EVENT TYPE DISPLAY
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.celebration, color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'EVENT CATEGORY',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          event.eventTypeName.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              _buildDetailRow(Icons.event, 'Event Name', event.eventName),
              _buildDetailRow(Icons.calendar_today, 'Date', _formatDate(event.eventDate)),
              _buildDetailRow(Icons.access_time, 'Time', event.eventTime),
              _buildDetailRow(Icons.location_on, 'Location', event.location),
              _buildDetailRow(Icons.people, 'Guest Count', '${event.guestCount} guests'),
            ],
          ),

          const SizedBox(height: 20),

          // Budget Card
          _buildDetailCard(
            title: 'Budget Overview',
            children: [
              _buildBudgetRow('Estimated Cost', event.totalEstimatedCost, AppColors.primary),
              _buildBudgetRow('Paid Amount', paidAmount, AppColors.success),
              _buildBudgetRow('Remaining', remainingAmount, remainingAmount > 0 ? AppColors.warning : Colors.grey),
            ],
          ),

          const SizedBox(height: 20),

          // Status Card
          _buildDetailCard(
            title: 'Event Status',
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _getStatusColor(event.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(_getStatusIcon(event.status), size: 18, color: _getStatusColor(event.status)),
                        const SizedBox(width: 8),
                        Text(
                          event.status.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(event.status),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDetailCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetRow(String label, double amount, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          Text(
            '${AppStrings.rupee}${amount.toStringAsFixed(0)}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  Color _getStatusColor(EventStatus status) {
    switch (status) {
      case EventStatus.confirmed:
      case EventStatus.approved:
        return AppColors.success;
      case EventStatus.pending:
        return AppColors.warning;
      case EventStatus.completed:
        return AppColors.secondary;
      case EventStatus.rejected:
      case EventStatus.cancelled:
        return Colors.red;
      case EventStatus.inProgress:
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon(EventStatus status) {
    switch (status) {
      case EventStatus.confirmed:
      case EventStatus.approved:
        return Icons.check_circle;
      case EventStatus.pending:
        return Icons.access_time;
      case EventStatus.completed:
        return Icons.done_all;
      case EventStatus.rejected:
      case EventStatus.cancelled:
        return Icons.cancel;
      case EventStatus.inProgress:
        return Icons.sync;
      default:
        return Icons.info;
    }
  }
}

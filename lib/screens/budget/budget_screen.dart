import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../providers/budget_provider.dart';
import 'budget_detail_screen.dart';
import 'payment_tracking_screen.dart';

class BudgetScreen extends StatefulWidget {
  final String eventId;
  final double totalEstimated;

  const BudgetScreen({
    super.key,
    required this.eventId,
    required this.totalEstimated,
  });

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BudgetProvider>(context, listen: false).fetchEventBudget(widget.eventId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Budget Tracker")),
      body: Consumer<BudgetProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.budget == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final budget = provider.budget;
          final paid = budget?.totalPaid ?? 0.0;
          final remaining = widget.totalEstimated - paid;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Budget Summary Card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Total Budget",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "₹${widget.totalEstimated.toStringAsFixed(0)}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildBudgetDetailColumn("Spent", "₹${paid.toStringAsFixed(0)}", Colors.green),
                          _buildBudgetDetailColumn("Remaining", "₹${(remaining / 1000).toStringAsFixed(1)}k", Colors.orange),
                          _buildBudgetDetailColumn("Pending Bills", "₹0", Colors.redAccent),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Expenses Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Expenses",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => BudgetDetailScreen(eventId: widget.eventId)));
                      },
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                      label: const Text("Add New"),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                    )
                  ],
                ),
                
                const SizedBox(height: 10),

                // This is where you would list expenses, but they are on another screen
                // For now, let's keep the payment history link
                
                const Divider(),

                ListTile(
                  title: const Text("Payment History", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("Track recent transactions"),
                  leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.history, color: Colors.green)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentTrackingScreen(eventId: widget.eventId)));
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBudgetDetailColumn(String title, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
              color: color, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

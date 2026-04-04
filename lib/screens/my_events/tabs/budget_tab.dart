
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_routes.dart';
import '../../../../config/app_strings.dart';
import '../../../../providers/budget_provider.dart';
import '../../../../models/budget_model.dart';

class BudgetTab extends StatefulWidget {
  final String eventId;
  final double totalEstimated;

  const BudgetTab({
    super.key,
    required this.eventId,
    required this.totalEstimated,
  });

  @override
  State<BudgetTab> createState() => _BudgetTabState();
}

class _BudgetTabState extends State<BudgetTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BudgetProvider>(context, listen: false)
          .fetchEventBudget(widget.eventId);
    });
  }

  // 🕒 Calculate Days Left for Payment
  int _calculateDaysLeft(Timestamp? approvedAt) {
    if (approvedAt == null) return 7; // Default if not found
    final deadline = approvedAt.toDate().add(const Duration(days: 8));
    final now = DateTime.now();
    return deadline.difference(now).inDays;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('userEvents')
          .doc(widget.eventId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final eventData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
        String eventStatus = (eventData['status'] ?? 'pending').toString().toLowerCase().trim();
        Timestamp? approvedAt = eventData['approvedAt'] as Timestamp?;

        bool isApproved = eventStatus.contains('approved');

        // 1. Base Event Data
        double baseEventCost = (eventData['totalEstimatedCost'] ?? widget.totalEstimated).toDouble();
        double baseEventPaid = (eventData['amountPaid'] ?? 0.0).toDouble();

        // Main Event Balance
        double eventBalance = baseEventCost - baseEventPaid;
        if (eventBalance < 0) eventBalance = 0;

        return Consumer<BudgetProvider>(
          builder: (context, budgetProvider, child) {
            final allExpenses = budgetProvider.budget?.expenses ?? [];
            final paidExpenses = allExpenses.where((e) => e.isPaid).toList();
            final unpaidExpenses = allExpenses.where((e) => !e.isPaid).toList();

            // 2. Extra Expenses Data
            final totalExpensesCost = allExpenses.fold<double>(0.0, (sum, e) => sum + e.amount);
            final paidExpensesAmount = paidExpenses.fold<double>(0.0, (sum, e) => sum + e.amount);

            // 3. Grand Totals (Event + Extra Expenses)
            final grandTotalCost = baseEventCost + totalExpensesCost;
            final grandTotalPaid = baseEventPaid + paidExpensesAmount;
            final grandTotalRemaining = grandTotalCost - grandTotalPaid;

            // Check if Main Event is fully paid (for the warning banner)
            final isMainEventPaid = eventBalance <= 1.0;

            return Scaffold(
              backgroundColor: Colors.grey[50],
              body: RefreshIndicator(
                onRefresh: () => budgetProvider.fetchEventBudget(widget.eventId),
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // ⚠️ POLICY BANNER (Shows only if Approved & Main Event Not Paid)
                    if (isApproved && !isMainEventPaid)
                      _buildPolicyBanner(approvedAt),

                    // 📊 1. MAIN BUDGET CARD
                    _buildMainBudgetCard(
                      grandTotalCost,
                      grandTotalPaid,
                      grandTotalRemaining,
                      eventStatus,
                      isMainEventPaid && unpaidExpenses.isEmpty,
                    ),

                    const SizedBox(height: 24),

                    // 💳 2. PENDING PAYMENTS
                    if (eventBalance > 1.0 || unpaidExpenses.isNotEmpty) ...[
                      const Text("Pending Payments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),

                      // A. Main Event Payment (If balance exists)
                      if (eventBalance > 1.0)
                        _buildEventPaymentTile(eventBalance),

                      // B. Extra Expenses (Vendors/Other)
                      ...unpaidExpenses.map((e) => _buildUnpaidExpenseTile(e, budgetProvider)),

                      const SizedBox(height: 24),
                    ],

                    // ✅ 3. PAID HISTORY
                    if (baseEventPaid > 0 || paidExpenses.isNotEmpty) ...[
                      _buildSectionHeader(
                        "Paid History",
                        Icons.history,
                        Colors.green,
                        paidExpenses.length + (baseEventPaid > 0 ? 1 : 0),
                        grandTotalPaid,
                        showAddButton: true,
                        onAddPressed: () => _showAddExpenseDialog(context, budgetProvider),
                      ),

                      const SizedBox(height: 12),

                      // Main Booking Payment Record
                      if (baseEventPaid > 0)
                        _buildPaidTile("Event Payment", "Main Package", baseEventPaid),

                      // Other Paid Expenses
                      ...paidExpenses.map((e) => _buildPaidExpenseTile(e, budgetProvider)),
                    ],

                    // If no paid history, still show Add Button
                    if (baseEventPaid <= 0 && paidExpenses.isEmpty)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () => _showAddExpenseDialog(context, budgetProvider),
                          icon: const Icon(Icons.add),
                          label: const Text("Add Manual Expense"),
                        ),
                      ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // ⚠️ POLICY WARNING BANNER
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildPolicyBanner(Timestamp? approvedAt) {
    int daysLeft = _calculateDaysLeft(approvedAt);

    Color bannerColor = daysLeft <= 3 ? Colors.red.shade50 : Colors.orange.shade50;
    Color textColor = daysLeft <= 3 ? Colors.red : Colors.orange.shade800;
    IconData icon = daysLeft <= 3 ? Icons.error_outline : Icons.warning_amber_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bannerColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: textColor),
              const SizedBox(width: 8),
              Text(
                daysLeft > 0 ? "Payment Due in $daysLeft Days" : "Payment Overdue",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Per policy, full payment must be cleared within 8 days of approval to avoid auto-cancellation. Please clear pending dues.",
            style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 📊 MAIN BUDGET CARD
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildMainBudgetCard(
      double total,
      double paid,
      double remaining,
      String status,
      bool isFullyPaid,
      ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text("Total Event Cost", style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Text(
            '${AppStrings.rupee}${total.toStringAsFixed(0)}',
            style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          if (isFullyPaid)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text("ALL PAID", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat("Paid", paid, Icons.check_circle),
              Container(width: 1, height: 40, color: Colors.white30),
              _buildStat("Due", remaining < 0 ? 0 : remaining, Icons.pending),
            ],
          ),
        ],
      ),
    );
  }

  // 🏛️ MAIN EVENT PAYMENT TILE
  Widget _buildEventPaymentTile(double amount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue.shade200, width: 1.5),
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.1), blurRadius: 8)],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48, height: 48,
          decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.star, color: Colors.blue),
        ),
        title: const Text("Main Event Package", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text("Required to confirm booking", style: TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: ElevatedButton(
          onPressed: () => _showPaymentOptions(context, amount, 'EVENT_PAYMENT'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
          child: const Text("PAY NOW"),
        ),
      ),
    );
  }

  // 🔴 UNPAID EXPENSE TILE
  Widget _buildUnpaidExpenseTile(Expense expense, BudgetProvider provider) {
    return Dismissible(
      key: Key(expense.id),
      direction: DismissDirection.endToStart,
      background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
      confirmDismiss: (_) => _confirmDelete(expense.name),
      onDismissed: (_) => provider.deleteExpense(widget.eventId, expense),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.orange.shade200, width: 1.5),
        ),
        child: ListTile(
          leading: const Icon(Icons.receipt_long, color: Colors.orange),
          title: Text(expense.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Extra Expense", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          trailing: ElevatedButton(
            onPressed: () => _goToExpensePayment(expense),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
            child: Text("Pay ${expense.amount.toStringAsFixed(0)}"),
          ),
        ),
      ),
    );
  }

  // ✅ PAID TILE (Generic)
  Widget _buildPaidTile(String title, String subtitle, double amount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200)),
      child: ListTile(
        leading: const Icon(Icons.check_circle, color: Colors.green),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: Text('${AppStrings.rupee}${amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
      ),
    );
  }

  // ✅ PAID EXPENSE TILE (Specific)
  Widget _buildPaidExpenseTile(Expense expense, BudgetProvider provider) {
    return Dismissible(
      key: Key(expense.id),
      direction: DismissDirection.endToStart,
      background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
      confirmDismiss: (_) => _confirmDelete(expense.name),
      onDismissed: (_) => provider.deleteExpense(widget.eventId, expense),
      child: _buildPaidTile(expense.name, "Extra Expense", expense.amount),
    );
  }

  // 📝 SECTION HEADER
  Widget _buildSectionHeader(String title, IconData icon, Color color, int count, double amount, {bool showAddButton = false, VoidCallback? onAddPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
        ]),
        if (showAddButton)
          TextButton.icon(onPressed: onAddPressed, icon: const Icon(Icons.add, size: 18), label: const Text("Add Expense")),
      ],
    );
  }

  // 🔢 STAT WIDGET
  Widget _buildStat(String label, double val, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text('${AppStrings.rupee}${val.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  // 🗑 DELETE CONFIRM
  Future<bool?> _confirmDelete(String name) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Expense"),
        content: Text("Remove '$name' from budget?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  // 💳 PAYMENTS
  void _goToExpensePayment(Expense expense) {
    Navigator.pushNamed(
      context,
      AppRoutes.payment,
      arguments: {
        'totalAmount': expense.amount,
        'eventId': widget.eventId,
        'bookingId': 'EXPENSE_${expense.id}',
        'paymentType': 'expense',
      },
    );
  }

  // 🚨 REMOVED ADVANCE OPTION HERE
  void _showPaymentOptions(BuildContext context, double amount, String type) {
    final customController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, left: 24, right: 24, top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Select Payment Amount", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),

              // ✅ Only "Pay Full" is left here
              _buildPaymentOption("Pay Full Amount", amount, Icons.check_circle, Colors.green),

              const Divider(height: 32),

              // Custom Amount (Still useful if they want to pay partial manually)
              TextField(
                controller: customController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Custom Amount",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      final amt = double.tryParse(customController.text) ?? 0;
                      if (amt > 0 && amt <= amount) {
                        Navigator.pop(context);
                        _goToPayment(amt, type);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentOption(String title, double amount, IconData icon, Color color) {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        _goToPayment(amount, 'EVENT_PAYMENT');
      },
      leading: Icon(icon, color: color),
      title: Text(title),
      trailing: Text('${AppStrings.rupee}${amount.toStringAsFixed(0)}', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }

  void _goToPayment(double amount, String paymentType) {
    Navigator.pushNamed(context, AppRoutes.payment, arguments: {
      'totalAmount': amount,
      'eventId': widget.eventId,
      'bookingId': paymentType,
      'paymentType': 'event',
    });
  }

  // ➕ ADD EXPENSE DIALOG
  void _showAddExpenseDialog(BuildContext context, BudgetProvider provider) {
    final nameCtrl = TextEditingController();
    final amtCtrl = TextEditingController();
    String selectedCategory = 'Other';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, left: 24, right: 24, top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Add New Expense", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Expense Name (e.g. Taxi)")),
              const SizedBox(height: 16),
              TextField(controller: amtCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Amount")),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: ['Venue', 'Catering', 'Decoration', 'Music', 'Transport', 'Other']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (val) => setModalState(() => selectedCategory = val!),
              ),
              const SizedBox(height: 24),

              // 💳 PAY NOW
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (nameCtrl.text.isEmpty || amtCtrl.text.isEmpty) return;
                    final amount = double.parse(amtCtrl.text);
                    final expense = Expense(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameCtrl.text,
                      amount: amount,
                      category: selectedCategory,
                      isPaid: false,
                    );
                    await provider.addExpense(widget.eventId, expense);
                    Navigator.pop(context);
                    _goToExpensePayment(expense);
                  },
                  icon: const Icon(Icons.payment, color: Colors.white),
                  label: const Text("Add & Pay Now", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ),

              const SizedBox(height: 12),

              // ⏳ PAY LATER
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    if (nameCtrl.text.isEmpty || amtCtrl.text.isEmpty) return;
                    final expense = Expense(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameCtrl.text,
                      amount: double.parse(amtCtrl.text),
                      category: selectedCategory,
                      isPaid: false,
                    );
                    await provider.addExpense(widget.eventId, expense);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.access_time),
                  label: const Text("Add & Pay Later"),
                ),
              ),

              const SizedBox(height: 12),

              // 💵 CASH PAID
              TextButton(
                onPressed: () async {
                  if (nameCtrl.text.isEmpty || amtCtrl.text.isEmpty) return;
                  final expense = Expense(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameCtrl.text,
                    amount: double.parse(amtCtrl.text),
                    category: selectedCategory,
                    isPaid: true, // Marked as paid immediately
                    paidDate: DateTime.now(),
                  );
                  await provider.addExpense(widget.eventId, expense);
                  Navigator.pop(context);
                },
                child: const Text("Already Paid (Cash/UPI)"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

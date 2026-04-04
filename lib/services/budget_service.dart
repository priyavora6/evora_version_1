import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/budget_model.dart';

class BudgetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DocumentReference _budgetRef(String eventId) {
    return _firestore
        .collection('userEvents')
        .doc(eventId)
        .collection('budget')
        .doc('main');
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🔧 SELF-HEALING: RECALCULATE TOTAL PAID FROM HISTORY
  // ═══════════════════════════════════════════════════════════════════════
  Future<void> recalculateAndFixTotalPaid(String eventId, String userId) async {
    try {
      // 1. Fetch all successful payments for this event AND THIS USER
      final paymentsSnapshot = await _firestore
          .collection('payments')
          .where('userId', isEqualTo: userId)
          .where('eventId', isEqualTo: eventId)
          .where('status', isEqualTo: 'success') // Only count successful ones
          .get();

      // 2. Sum them up
      double correctTotal = 0.0;
      for (var doc in paymentsSnapshot.docs) {
        correctTotal += (doc.data()['amount'] ?? 0.0).toDouble();
      }

      // 3. Force update the 'userEvents' document with the CORRECT total
      await _firestore.collection('userEvents').doc(eventId).update({
        'amountPaid': correctTotal,
        'lastBudgetSync': FieldValue.serverTimestamp(),
      });

      print("✅ Budget Self-Healed: Fixed amountPaid to $correctTotal");

    } catch (e) {
      print("❌ Error fixing budget: $e");
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 📊 GET BUDGET
  // ═══════════════════════════════════════════════════════════════════════
  Future<Budget?> getEventBudget(String eventId) async {
    try {
      final doc = await _budgetRef(eventId).get();
      if (doc.exists && doc.data() != null) {
        return Budget.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Get budget error: $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🔄 INITIALIZE BUDGET
  // ═══════════════════════════════════════════════════════════════════════
  Future<bool> initializeBudget(String eventId) async {
    try {
      final doc = await _budgetRef(eventId).get();
      if (!doc.exists) {
        await _budgetRef(eventId).set({
          'totalEstimated': 0,
          'totalPaid': 0,
          'expenses': [],
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      return true;
    } catch (e) {
      print('Initialize budget error: $e');
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 💾 SAVE BUDGET
  // ═══════════════════════════════════════════════════════════════════════
  Future<bool> saveEventBudget({
    required String eventId,
    required double totalEstimated,
  }) async {
    try {
      await _budgetRef(eventId).set({
        'totalEstimated': totalEstimated,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      print('Save budget error: $e');
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // ➕ ADD EXPENSE
  // ═══════════════════════════════════════════════════════════════════════
  Future<bool> addExpense(String eventId, Expense expense) async {
    try {
      final doc = await _budgetRef(eventId).get();

      // Ensure timestamp is valid for Firestore
      Map<String, dynamic> expenseData = expense.toMap();
      if (expenseData['paidDate'] == null && expense.isPaid) {
        expenseData['paidDate'] = Timestamp.now();
      }

      if (doc.exists) {
        await _budgetRef(eventId).update({
          'expenses': FieldValue.arrayUnion([expenseData]),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        await _budgetRef(eventId).set({
          'totalEstimated': 0,
          'totalPaid': 0,
          'expenses': [expenseData],
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      return true;
    } catch (e) {
      print('Add expense error: $e');
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // ✏️ UPDATE EXPENSE
  // ═══════════════════════════════════════════════════════════════════════
  Future<bool> updateExpense(String eventId, Expense oldExpense, Expense newExpense) async {
    try {
      // Get current expenses
      final doc = await _budgetRef(eventId).get();
      if (!doc.exists) return false;

      final data = doc.data() as Map<String, dynamic>;
      List<dynamic> expenses = List.from(data['expenses'] ?? []);

      // Find and update the expense
      final index = expenses.indexWhere((e) => e['id'] == oldExpense.id);
      if (index != -1) {
        // Prepare new data
        Map<String, dynamic> newData = newExpense.toMap();

        // Preserve original created timestamp if possible
        if (expenses[index]['createdAt'] != null) {
          // Keep original creation time? Or just overwrite.
          // Usually overwrite is fine as long as ID is same.
        }

        expenses[index] = newData;

        await _budgetRef(eventId).update({
          'expenses': expenses,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        return true;
      }
      return false;
    } catch (e) {
      print('Update expense error: $e');
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🗑️ DELETE EXPENSE
  // ═══════════════════════════════════════════════════════════════════════
  Future<bool> deleteExpense(String eventId, Expense expense) async {
    try {
      // Get current expenses
      final doc = await _budgetRef(eventId).get();
      if (!doc.exists) return false;

      final data = doc.data() as Map<String, dynamic>;
      List<dynamic> expenses = List.from(data['expenses'] ?? []);

      // Remove expense by ID
      expenses.removeWhere((e) => e['id'] == expense.id);

      await _budgetRef(eventId).update({
        'expenses': expenses,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Delete expense error: $e');
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 📈 GET EXPENSE BREAKDOWN
  // ═══════════════════════════════════════════════════════════════════════
  Future<Map<String, double>> getExpenseBreakdown(String eventId) async {
    try {
      final doc = await _budgetRef(eventId).get();
      if (!doc.exists || doc.data() == null) return {};

      final data = doc.data() as Map<String, dynamic>;
      final expenses = List<Map<String, dynamic>>.from(data['expenses'] ?? []);

      Map<String, double> breakdown = {};
      for (var expense in expenses) {
        final category = expense['category'] ?? 'Other';
        final amount = (expense['amount'] ?? 0).toDouble();
        breakdown[category] = (breakdown[category] ?? 0) + amount;
      }
      return breakdown;
    } catch (e) {
      print('Get breakdown error: $e');
      return {};
    }
  }
}
import 'package:flutter/material.dart';
import 'add_expense_screen.dart';
import 'home_screen.dart';

class ReportScreen extends StatelessWidget {
  final List<Expense> expenses;
  final double monthlyBudget;

  const ReportScreen({
    super.key,
    required this.expenses,
    required this.monthlyBudget,
  });

  double get _totalSpent =>
      expenses.fold(0.0, (sum, item) => sum + item.amount);

  double get _remainingBalance => monthlyBudget - _totalSpent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Expenses Chart:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Same Dynamic Chart Widget connected to master state
            ExpenseChart(expenses: expenses),

            const SizedBox(height: 24),
            const Text(
              'Monthly Overview',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              child: ListTile(
                leading: const Icon(Icons.account_balance_wallet_outlined,
                    color: Color(0xFF0D9488)),
                title: const Text('Monthly Budget'),
                trailing: Text(
                  'Rp ${monthlyBudget.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              child: ListTile(
                leading: const Icon(Icons.trending_down, color: Colors.red),
                title: const Text('Total Spent'),
                trailing: Text(
                  'Rp ${_totalSpent.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.red),
                ),
              ),
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              child: ListTile(
                leading:
                    const Icon(Icons.account_balance, color: Color(0xFF16A34A)),
                title: const Text('Remaining Balance'),
                trailing: Text(
                  'Rp ${_remainingBalance.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: _remainingBalance < 0
                        ? Colors.red
                        : const Color(0xFF16A34A),
                  ),
                ),
              ),
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              child: ListTile(
                leading:
                    const Icon(Icons.receipt_long, color: Color(0xFF1E293B)),
                title: const Text('Total Transactions'),
                trailing: Text(
                  '${expenses.length}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

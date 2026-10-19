import 'package:flutter/material.dart';
import 'add_expense_screen.dart';
import 'budget_screen.dart';
import 'report_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({
    super.key,
    this.userName = 'Alex', // Fallback default name
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Master user name state
  late String _userName;

  double _monthlyBudget = 1000000.00;
  final double _savingsGoal = 500000.00;

  // Master shared expenses list
  final List<Expense> _expenses = [
    Expense(
      id: 'e1',
      title: 'Groceries',
      amount: 300000.00,
      category: 'Shopping',
      date: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    Expense(
      id: 'e2',
      title: 'Stationaries',
      amount: 80000.00,
      category: 'Education',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // Initialize username from login/signup input
    _userName = widget.userName;
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double get _totalSpent {
    return _expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  double get _remainingBalance {
    return _monthlyBudget - _totalSpent;
  }

  void _updateUserName(String newName) {
    setState(() {
      _userName = newName;
    });
  }

  Future<void> _openAddExpenseScreen() async {
    final Expense? newExpense = await Navigator.of(context).push<Expense>(
      MaterialPageRoute(builder: (ctx) => const AddExpenseScreen()),
    );

    if (newExpense != null) {
      setState(() {
        _expenses.insert(0, newExpense);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added "${newExpense.title}" successfully!')),
        );
      }
    }
  }

  void _updateMonthlyBudget(double newBudget) {
    setState(() {
      _monthlyBudget = newBudget;
    });
  }

  void _deleteExpense(String id) {
    setState(() {
      _expenses.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _buildHomeDashboardView(),
      ReportScreen(expenses: _expenses, monthlyBudget: _monthlyBudget),
      BudgetScreen(
        expenses: _expenses,
        monthlyBudget: _monthlyBudget,
        onUpdateBudget: _updateMonthlyBudget,
        onDeleteExpense: _deleteExpense,
      ),
      ProfileScreen(
        userName: _userName,
        onUpdateUserName: _updateUserName,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text(
          'Financial Budget Tracker',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      floatingActionButton: _selectedIndex == 0 || _selectedIndex == 2
          ? FloatingActionButton(
              onPressed: _openAddExpenseScreen,
              backgroundColor: const Color(0xFF1E293B),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1E293B),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeDashboardView() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFF1E293B),
                  child:
                      const Icon(Icons.person, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Active User Profile',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Expenses Chart:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          // Dynamic Chart Widget
          ExpenseChart(expenses: _expenses),

          const SizedBox(height: 20),
          const Text(
            'Monthly budget left:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Remaining Balance',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Rp ${_remainingBalance.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF16A34A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Savings Goal:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Target Goal',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Rp ${_savingsGoal.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D9488),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          InkWell(
            onTap: () {
              setState(() => _selectedIndex = 2);
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'Expenditure Records',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// Native Dynamic Bar Chart Component
class ExpenseChart extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseChart({super.key, required this.expenses});

  Map<String, double> get _categoryTotals {
    final Map<String, double> totals = {};
    for (var e in expenses) {
      totals[e.category] = (totals[e.category] ?? 0.0) + e.amount;
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    final totals = _categoryTotals;

    if (expenses.isEmpty || totals.isEmpty) {
      return Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFCBD5E1)),
        ),
        child: const Center(
          child: Text(
            'No expenditure data recorded yet',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
          ),
        ),
      );
    }

    final maxAmount = totals.values.reduce((a, b) => a > b ? a : b);

    return Container(
      height: 160,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: totals.entries.map((entry) {
          final double ratio = maxAmount > 0 ? (entry.value / maxAmount) : 0.0;
          final double barHeight = ratio * 75;

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Rp ${(entry.value / 1000).toStringAsFixed(0)}k',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 28,
                height: barHeight < 8 ? 8 : barHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                entry.key,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

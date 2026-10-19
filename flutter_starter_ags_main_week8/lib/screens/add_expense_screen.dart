import 'package:flutter/material.dart';

class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  IconData get categoryIcon {
    switch (category) {
      case 'Food & Drinks':
        return Icons.fastfood;
      case 'Utilities':
        return Icons.bolt;
      case 'Entertainment':
        return Icons.movie;
      case 'Transport':
        return Icons.directions_bus;
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Healthcare':
        return Icons.medical_services;
      case 'Education':
        return Icons.school;
      case 'Bills':
        return Icons.receipt_long;
      default:
        return Icons.category;
    }
  }
}

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  String _selectedCategory = 'Food & Drinks';
  bool _isValid = false;

  final List<String> _categories = [
    'Food & Drinks',
    'Utilities',
    'Entertainment',
    'Transport',
    'Shopping',
    'Healthcare',
    'Education',
    'Bills',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _amountController = TextEditingController();

    _titleController.addListener(_validateForm);
    _amountController.addListener(_validateForm);
  }

  void _validateForm() {
    final titleNotEmpty = _titleController.text.trim().isNotEmpty;
    final amountParsed = double.tryParse(_amountController.text.trim());
    final validAmount = amountParsed != null && amountParsed > 0;

    final isFormValid = titleNotEmpty && validAmount;
    if (isFormValid != _isValid) {
      setState(() {
        _isValid = isFormValid;
      });
    }
  }

  void _submitData() {
    final title = _titleController.text.trim();
    final amount = double.parse(_amountController.text.trim());

    final newExpense = Expense(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      category: _selectedCategory,
      date: DateTime.now(),
    );

    Navigator.of(context).pop(newExpense);
  }

  @override
  void dispose() {
    _titleController.removeListener(_validateForm);
    _amountController.removeListener(_validateForm);
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Add New Expense'),
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                prefixIcon: Icon(Icons.edit, color: Color(0xFF64748B)),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount (Rp)',
                prefixIcon: Icon(Icons.attach_money, color: Color(0xFF64748B)),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              items: _categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedCategory = val);
                }
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isValid ? _submitData : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E293B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Save Expense',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

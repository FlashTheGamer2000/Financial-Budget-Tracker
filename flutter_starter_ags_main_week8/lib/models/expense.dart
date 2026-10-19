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
      case 'Food':
        return Icons.fastfood;
      case 'Utilities':
        return Icons.bolt;
      case 'Entertainment':
        return Icons.movie;
      case 'Transport':
        return Icons.directions_bus;
      default:
        return Icons.attach_money;
    }
  }
}

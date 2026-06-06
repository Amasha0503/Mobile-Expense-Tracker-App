import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense_tracker/controllers/track_controller.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  String _formatAmount(double value) {
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final history = context.watch<TrackController>().history;
    final rows = [
      const TableRow(
        children: [
          Padding(
            padding: EdgeInsets.all(8), 
            child: Text("Date" ,style: TextStyle(fontWeight: FontWeight.bold),)
          ),
          Padding(
            padding: EdgeInsets.all(8), 
            child: Text("Income", style: TextStyle(fontWeight: FontWeight.bold),)
          ),
          Padding(
            padding: EdgeInsets.all(8), 
            child: Text("Expense", style: TextStyle(fontWeight: FontWeight.bold),)
          ),
          Padding(
            padding: EdgeInsets.all(8), 
            child: Text("Balance", style: TextStyle(fontWeight: FontWeight.bold),)
          ),
        ],
      ),
      ...history.reversed.map(
        (item) => TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(_formatDate(item.date)),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                _formatAmount(item.totalIncome),
                style: const TextStyle(color: Color.fromARGB(255, 10, 120, 210)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                _formatAmount(item.totalExpense),
                style: const TextStyle(color: Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                _formatAmount(item.balance),
                style: const TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text("Finance History")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: history.isEmpty
            ? const Center(
                child: Text("No records yet. Start a cycle to see history."),
              )
            : Table(
                border: TableBorder.all(color: Colors.black12),
                children: rows,
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import '../controllers/track_controller.dart';

class AddExpenseDialog extends StatefulWidget {
  final Expense? editItem;
  final String? preselectedCategory;

  const AddExpenseDialog({this.editItem, this.preselectedCategory});

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final desc = TextEditingController();
  final amount = TextEditingController();

  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrackController>(context);

    return AlertDialog(
      title: const Text("Add Expense"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: selectedCategory,
            hint: const Text("Select Category"),
            items: provider.categories.map((cat) {
              return DropdownMenuItem(value: cat.id, child: Text(cat.name));
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCategory = value;
              });
            },
          ),
          TextField(
            controller: desc,
            decoration: const InputDecoration(labelText: "Description"),
          ),
          TextField(
            controller: amount,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Amount"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (selectedCategory == null) return;

            Provider.of<TrackController>(context, listen: false).addExpense(
              Expense(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                categoryId: selectedCategory!,
                date: DateTime.now(),
                description: desc.text,
                amount: double.parse(amount.text),
              ),
            );

            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}

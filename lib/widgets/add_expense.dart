import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import '../controllers/track_controller.dart';

class AddExpenseDialog extends StatefulWidget {
  final Expense? editItem;
  final String? preselectedCategory;

  const AddExpenseDialog({super.key, this.editItem, this.preselectedCategory});

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final desc = TextEditingController();
  final amount = TextEditingController();

  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    final editItem = widget.editItem;
    selectedCategory = editItem?.categoryId ?? widget.preselectedCategory;

    if (editItem != null) {
      desc.text = editItem.description;
      amount.text = editItem.amount.toString();
    }
  }

  @override
  void dispose() {
    desc.dispose();
    amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrackController>(context);
    final isEditing = widget.editItem != null;

    return AlertDialog(
      title: Text(isEditing ? "Edit Expense" : "Add Expense"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            initialValue: selectedCategory,
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
            final parsedAmount = double.tryParse(amount.text);
            if (parsedAmount == null) return;

            final editItem = widget.editItem;

            if (editItem != null) {
              Provider.of<TrackController>(
                context,
                listen: false,
              ).updateExpense(
                Expense(
                  id: editItem.id,
                  categoryId: selectedCategory!,
                  date: editItem.date,
                  description: desc.text,
                  amount: parsedAmount,
                ),
              );
            } else {
              Provider.of<TrackController>(context, listen: false).addExpense(
                Expense(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  categoryId: selectedCategory!,
                  date: DateTime.now(),
                  description: desc.text,
                  amount: parsedAmount,
                ),
              );
            }

            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}

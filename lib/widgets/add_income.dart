import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/income.dart';
import '../controllers/track_controller.dart';

class AddIncomeDialog extends StatefulWidget {
  final Income? editItem;
  const AddIncomeDialog({super.key, this.editItem});

  @override
  State<AddIncomeDialog> createState() => _AddIncomeDialogState();
}

class _AddIncomeDialogState extends State<AddIncomeDialog> {
  final desc = TextEditingController();
  final amount = TextEditingController();

  @override
  void initState() {
    super.initState();
    final editItem = widget.editItem;
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
    final isEditing = widget.editItem != null;

    return AlertDialog(
      title: Text(isEditing ? "Edit Income" : "Add Income"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
            final parsedAmount = double.tryParse(amount.text);
            if (parsedAmount == null) return;

            final editItem = widget.editItem;

            if (editItem != null) {
              Provider.of<TrackController>(context, listen: false).updateIncome(
                Income(
                  id: editItem.id,
                  date: editItem.date,
                  description: desc.text,
                  amount: parsedAmount,
                ),
              );
            } else {
              Provider.of<TrackController>(context, listen: false).addIncome(
                Income(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
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

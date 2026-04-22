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
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Income"),
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
            Provider.of<TrackController>(context, listen: false).addIncome(
              Income(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                date: DateTime.now(),
                description: desc.text,
                amount: double.parse(amount.text),
              ),
            );

            Navigator.pop(context);
          },
          child: const Text("Save"),
        )
      ],
    );
  }
}
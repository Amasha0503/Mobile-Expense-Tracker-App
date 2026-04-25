import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/track_controller.dart';
import 'add_income.dart';

class IncomeList extends StatelessWidget {
  const IncomeList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrackController>(context);

    return Card(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Incomes",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  provider.totalIncome.toStringAsFixed(2),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          ...provider.incomes.map((item) => ListTile(
                title: Text(item.description),
                subtitle: Text(item.date.toString().substring(0, 19)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("+${item.amount.toStringAsFixed(2)}"),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AddIncomeDialog(editItem: item),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        provider.deleteIncome(item.id);
                      },
                    ),
                  ],
                ),
              )),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const AddIncomeDialog(),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text("Add Income"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
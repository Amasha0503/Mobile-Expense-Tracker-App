import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/track_controller.dart';
import '../models/category.dart';
import 'add_expense.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({super.key});

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
                  "Expenses",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  provider.totalExpense.toStringAsFixed(2),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          ...provider.categories.map((cat) {
            final items = provider.expenses
                .where((e) => e.categoryId == cat.id)
                .toList();

            return ExpansionTile(
              title: Text(cat.name),
              childrenPadding: const EdgeInsets.only(left: 10),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AddExpenseDialog(
                          preselectedCategory: cat.id,
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      provider.deleteCategory(cat.id);
                    },
                  ),
                ],
              ),

              children: items.map((item) {
                return ListTile(
                  title: Text(item.description),
                  subtitle: Text(item.date.toString().substring(0, 19)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "-${item.amount.toStringAsFixed(2)}",
                        style: const TextStyle(color: Colors.red),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AddExpenseDialog(
                              editItem: item,
                              preselectedCategory: cat.id,
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          provider.deleteExpense(item.id);
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  _addCategory(context);
                },
                icon: const Icon(Icons.add),
                label: const Text("Add Category"),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _addCategory(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("New Category"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Category name",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Provider.of<TrackController>(
                  context,
                  listen: false,
                ).addCategory(
                  Category(
                    id: DateTime.now()
                        .millisecondsSinceEpoch
                        .toString(),
                    name: controller.text,
                  ),
                );
              }

              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }
}
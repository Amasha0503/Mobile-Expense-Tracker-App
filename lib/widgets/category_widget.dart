import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/track_controller.dart';
import '../models/category.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrackController>(context);

    return Card(
      child: ExpansionTile(
        title: const Text("Expense Categories"),
        children: [
          ...provider.categories.map(
            (cat) => ListTile(
              title: Text(cat.name),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  provider.deleteCategory(cat.id);
                },
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              _showAddCategory(context);
            },
            icon: const Icon(Icons.add),
            label: const Text("Add Category"),
          )
        ],
      ),
    );
  }

  void _showAddCategory(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("New Category"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Category Name",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final name = controller.text.trim();

              if (name.isNotEmpty) {
                Provider.of<TrackController>(context, listen: false).addCategory(
                  Category(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense_tracker/controllers/track_controller.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool isSelectionMode = false;
  Set<String> selectedIds = {};

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  String _formatAmount(double value) {
    return value.toStringAsFixed(2);
  }

  void _toggleSelection(String id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }
    });
  }

  void _selectAll(List<String> ids) {
    setState(() {
      if (selectedIds.length == ids.length) {
        selectedIds.clear();
      } else {
        selectedIds = Set.from(ids);
      }
    });
  }

  void _deleteSelected(BuildContext context) {
    if (selectedIds.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Delete ${selectedIds.length} record(s)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TrackController>().deleteHistoryRecords(
                selectedIds.toList(),
              );
              setState(() {
                isSelectionMode = false;
                selectedIds.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final history = context.watch<TrackController>().history;
    final reversedHistory = history.reversed.toList();
    final historyIds = reversedHistory.map((h) => h.id).toList();
    final allSelected =
        selectedIds.length == reversedHistory.length &&
        reversedHistory.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Finance History"),
        actions: isSelectionMode
            ? [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: Text(
                      '${selectedIds.length} selected',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: history.isEmpty
            ? const Center(
                child: Text("No records yet. Start a cycle to see history."),
              )
            : Column(
                children: [
                  if (isSelectionMode)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Checkbox(
                            value: allSelected,
                            onChanged: (_) => _selectAll(historyIds),
                          ),
                          const Text('Select All'),
                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: selectedIds.isEmpty
                                ? null
                                : () => _deleteSelected(context),
                            icon: const Icon(Icons.delete),
                            label: const Text('Delete'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isSelectionMode = false;
                                selectedIds.clear();
                              });
                            },
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Table(
                        border: TableBorder.all(color: Colors.black12),
                        children: [
                          TableRow(
                            children: [
                              if (isSelectionMode)
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: SizedBox(width: 40),
                                ),
                              const Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  "Date",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  "Income",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  "Expense",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  "Balance",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          ...reversedHistory.map(
                            (item) => TableRow(
                              children: [
                                if (isSelectionMode)
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Checkbox(
                                      value: selectedIds.contains(item.id),
                                      onChanged: (_) =>
                                          _toggleSelection(item.id),
                                    ),
                                  ),
                                GestureDetector(
                                  onLongPress: () {
                                    if (!isSelectionMode) {
                                      setState(() {
                                        isSelectionMode = true;
                                        selectedIds.add(item.id);
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(_formatDate(item.date)),
                                  ),
                                ),
                                GestureDetector(
                                  onLongPress: () {
                                    if (!isSelectionMode) {
                                      setState(() {
                                        isSelectionMode = true;
                                        selectedIds.add(item.id);
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      _formatAmount(item.totalIncome),
                                      style: const TextStyle(
                                        color: Color.fromARGB(
                                          255,
                                          10,
                                          120,
                                          210,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onLongPress: () {
                                    if (!isSelectionMode) {
                                      setState(() {
                                        isSelectionMode = true;
                                        selectedIds.add(item.id);
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      _formatAmount(item.totalExpense),
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onLongPress: () {
                                    if (!isSelectionMode) {
                                      setState(() {
                                        isSelectionMode = true;
                                        selectedIds.add(item.id);
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      _formatAmount(item.balance),
                                      style: const TextStyle(
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

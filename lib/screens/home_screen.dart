import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense_tracker/controllers/track_controller.dart';
import 'history.dart';
import '../widgets/income_list.dart';
import '../widgets/expense_list.dart';
import '../widgets/balance_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const FinancePage(),
      const HistoryScreen(),
    ];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) {
          setState(() => index = i);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.wallet),
            label: "Finances",
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: "History",
          ),
        ],
      ),
    );
  }
}

class FinancePage extends StatelessWidget {
  const FinancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finance Tracker"),
        centerTitle: false,
        titleSpacing: 20,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            BalanceCard(),
            SizedBox(height: 14),
            IncomeList(),
            SizedBox(height: 14),
            ExpenseList(),
          ],
        ),
      ),
      floatingActionButton: FilledButton(
  onPressed: () {
    Provider.of<TrackController>(context, listen: false).startNewCycle();
  },
  style: FilledButton.styleFrom(
    minimumSize: const Size(56, 56),
    padding: EdgeInsets.zero,
  ),
  child: const Text(
    "+",
    style: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w600,
      height: 1,
    ),
  ),
),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

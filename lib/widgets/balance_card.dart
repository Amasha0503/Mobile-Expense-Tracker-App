import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/track_controller.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrackController>(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Text(
              "Current Balance",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              provider.balance.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 32,
                color: provider.balance >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "As of ${DateTime.now().toString().substring(0, 10)}",
              style: const TextStyle(fontSize: 13),
            )
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/track_controller.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const FinanceTrackerApp());
}

class FinanceTrackerApp extends StatelessWidget {
  const FinanceTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TrackController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Finance Tracker",
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xfff5f5f2),
          fontFamily: 'Roboto',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          cardTheme: CardThemeData(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xfff5f5f2),
            foregroundColor: Colors.black,
            centerTitle: true,
            elevation: 0,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

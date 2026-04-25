import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/track_controller.dart';
import 'screens/home_screen.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
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
        title: "TrackWallet",
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
        home: Consumer<TrackController>(
          builder: (context, controller, _) {
            if (controller.isLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return const HomeScreen();
          },
        ),
      ),
    );
  }
}

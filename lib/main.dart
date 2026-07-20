import 'package:flutter/material.dart';

import 'data/database.dart';
import 'data/goal_repository.dart';
import 'ui/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final repo = GoalRepository(AppDatabase());
  runApp(SecondSightApp(repo: repo));
}

class SecondSightApp extends StatelessWidget {
  final GoalRepository repo;

  const SecondSightApp({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SecondSight',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0E13),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5EEAD4),
          brightness: Brightness.dark,
        ),
      ),
      home: HomeScreen(repo: repo),
    );
  }
}

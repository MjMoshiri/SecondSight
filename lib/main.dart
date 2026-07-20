import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'data/database.dart';
import 'data/goal_repository.dart';
import 'ui/home_screen.dart';
import 'widget/timer_notification.dart';
import 'widget/widget_sync.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final repo = GoalRepository(AppDatabase());
  if (widgetSupported) {
    registerWidgetInteractivity();
    // Keep the home-screen widget and shade in lockstep with data changes.
    repo.watchAll().listen((goals) {
      unawaited(syncWidget(goals));
      unawaited(syncTimerNotifications(goals));
    });
    // Timer notifications (Android 13+ needs an explicit grant).
    unawaited(Permission.notification.request());
  }
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

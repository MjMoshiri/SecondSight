import 'package:flutter/material.dart';

import '../data/goal_repository.dart';
import 'home_screen.dart';
import 'report_screen.dart';

/// Root scaffold: bottom navigation between the goal list and the report.
class AppShell extends StatefulWidget {
  final GoalRepository repo;

  const AppShell({super.key, required this.repo});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(repo: widget.repo),
          ReportScreen(repo: widget.repo),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF0E1219),
        indicatorColor: const Color(0xFF5EEAD4).withValues(alpha: 0.16),
        height: 68,
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.flag_outlined),
            selectedIcon: Icon(Icons.flag_rounded),
            label: 'Goals',
          ),
          NavigationDestination(
            icon: Icon(Icons.insert_chart_outlined_rounded),
            selectedIcon: Icon(Icons.insert_chart_rounded),
            label: 'Report',
          ),
        ],
      ),
    );
  }
}

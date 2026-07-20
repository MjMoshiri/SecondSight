import 'dart:async';

import 'package:flutter/material.dart';

import '../data/goal_repository.dart';
import '../widget/widget_sync.dart';
import 'format.dart';
import 'goal_card.dart';
import 'goal_detail_screen.dart';
import 'new_goal_sheet.dart';

class HomeScreen extends StatefulWidget {
  final GoalRepository repo;

  const HomeScreen({super.key, required this.repo});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    // 1s heartbeat so running timers tick; cheap when nothing is running.
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nowUtcMs = DateTime.now().millisecondsSinceEpoch;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await showNewGoalSheet(context);
          if (result != null) {
            await widget.repo.createGoal(
              name: result.name,
              targetMinutes: result.targetMinutes,
              period: result.period,
              sections: result.sections,
            );
          }
        },
        backgroundColor: goalHues.first,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'New goal',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<List<GoalProgress>>(
          stream: widget.repo.watchAll(),
          builder: (context, snapshot) {
            final goals = snapshot.data ?? const <GoalProgress>[];
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _header(goals, nowUtcMs)),
                if (snapshot.hasData && goals.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _empty(),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
                    sliver: SliverList.separated(
                      itemCount: goals.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, i) => GoalCard(
                        progress: goals[i],
                        nowUtcMs: nowUtcMs,
                        onStart: () => widget.repo.start(goals[i].goal.id),
                        onPause: () => widget.repo.pause(goals[i].goal.id),
                        onResume: () => widget.repo.resume(goals[i].goal.id),
                        onStop: () => widget.repo.stop(goals[i].goal.id),
                        onDelete: () => _confirmDelete(goals[i]),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GoalDetailScreen(
                              repo: widget.repo,
                              goalId: goals[i].goal.id,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _header(List<GoalProgress> goals, int nowUtcMs) {
    final running = goals.where((g) => g.isRunning).length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SecondSight',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  running > 0
                      ? '$running ${running == 1 ? 'timer' : 'timers'} running'
                      : 'Nothing tracking right now',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),
          ),
          if (widgetSupported)
            IconButton(
              tooltip: 'Add widget to home screen',
              icon: Icon(
                Icons.widgets_outlined,
                color: Colors.white.withValues(alpha: 0.6),
              ),
              onPressed: requestPinWidget,
            ),
        ],
      ),
    );
  }

  Widget _empty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.hourglass_empty_rounded,
            size: 44,
            color: Colors.white.withValues(alpha: 0.25),
          ),
          const SizedBox(height: 14),
          Text(
            'No goals yet',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Something like “400 minutes weekly”.',
            style: TextStyle(
              fontSize: 13.5,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(GoalProgress p) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B2130),
        title: Text('Delete “${p.goal.name}”?'),
        content: const Text('Its logged time goes with it.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xFFFB7185)),
            ),
          ),
        ],
      ),
    );
    if (yes == true) await widget.repo.deleteGoal(p.goal.id);
  }
}

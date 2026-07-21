import 'dart:async';

import 'package:flutter/material.dart';

import '../data/database.dart';
import '../data/goal_repository.dart';
import 'format.dart';
import 'segmented_bar.dart';
import 'session_sheet.dart';

/// The tracking dashboard for one goal: current period, lifetime stats,
/// past-period history, and recent sessions.
class GoalDetailScreen extends StatefulWidget {
  final GoalRepository repo;
  final String goalId;

  const GoalDetailScreen({super.key, required this.repo, required this.goalId});

  @override
  State<GoalDetailScreen> createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends State<GoalDetailScreen> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
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
      body: SafeArea(
        child: StreamBuilder<GoalDetail?>(
          stream: widget.repo.watchDetail(widget.goalId),
          builder: (context, snapshot) {
            final detail = snapshot.data;
            if (detail == null) {
              // Deleted underneath us or still loading.
              return const Center(child: SizedBox.shrink());
            }
            final color = goalColor(detail.progress.goal.id);
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _header(detail)),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 48),
                  sliver: SliverList.list(
                    children: [
                      _currentPeriod(detail, color, nowUtcMs),
                      const SizedBox(height: 24),
                      _stats(detail, color),
                      const SizedBox(height: 28),
                      _sectionTitle('History'),
                      const SizedBox(height: 12),
                      _historyChart(detail, color),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Expanded(
                            child: _sectionTitle(
                              detail.progress.isCount
                                  ? 'Check-ins'
                                  : 'Recent sessions',
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_rounded),
                            tooltip: detail.progress.isCount
                                ? 'Add check-in'
                                : 'Add session',
                            onPressed: () => _addSession(detail.progress),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (detail.recentLogs.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Nothing logged yet.',
                            style: TextStyle(
                              fontSize: 13.5,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                        )
                      else
                        for (final log in detail.recentLogs)
                          _logRow(log, color, detail.progress.isCount),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _header(GoalDetail detail) {
    final goal = detail.progress.goal;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${detail.progress.isCount ? '${detail.progress.targetCount}×' : fmtCompact(detail.progress.targetMs)} '
                  '${detail.progress.period.label}'
                  ' · since ${fmtDay(goal.startDay)}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _currentPeriod(GoalDetail detail, Color color, int nowUtcMs) {
    final p = detail.progress;
    final daysLeft = p.window.daysLeft;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161B24),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'This period',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.55),
                ),
              ),
              const Spacer(),
              Text(
                '$daysLeft ${daysLeft == 1 ? 'day' : 'days'} left',
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                p.isCount
                    ? '${p.checksInWindow}'
                    : fmtCompact(p.elapsedMs(nowUtcMs)),
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                  height: 1,
                  color: p.isRunning ? color : Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  p.isCount
                      ? 'of ${p.targetCount} '
                            '${p.targetCount == 1 ? 'time' : 'times'}'
                      : 'of ${fmtCompact(p.targetMs)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.45),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${(p.ratio(nowUtcMs) * 100).round()}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SegmentedBar(
            ratio: p.ratio(nowUtcMs),
            sections: p.goal.sections,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _stats(GoalDetail detail, Color color) {
    final rate = detail.completedPeriods == 0
        ? '—'
        : '${(detail.metPeriods / detail.completedPeriods * 100).round()}%';
    final isCount = detail.progress.isCount;
    return Row(
      children: [
        if (isCount)
          _tile('Check-ins', '${detail.totalCount}×')
        else
          _tile('Total tracked', fmtCompact(detail.totalMs)),
        const SizedBox(width: 10),
        _tile('Hit rate', rate),
        const SizedBox(width: 10),
        _tile(
          'Streak',
          '${detail.currentStreak}',
          accent: detail.currentStreak > 0 ? color : null,
        ),
        const SizedBox(width: 10),
        _tile('Best', '${detail.bestStreak}'),
      ],
    );
  }

  Widget _tile(String label, String value, {Color? accent}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF12161E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: accent ?? Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2,
    ),
  );

  Widget _historyChart(GoalDetail detail, Color color) {
    final p = detail.progress;
    double fill(PeriodStat stat) {
      if (p.isCount) {
        return p.targetCount == 0
            ? 0
            : (stat.count / p.targetCount).clamp(0.0, 1.0);
      }
      return p.targetMs == 0 ? 0 : (stat.loggedMs / p.targetMs).clamp(0.0, 1.0);
    }

    final bars = detail.history;
    const chartHeight = 120.0;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF12161E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: chartHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < bars.length; i++) ...[
                  if (i > 0) const SizedBox(width: 4),
                  Expanded(
                    child: _bar(
                      bars[i],
                      fill(bars[i]),
                      color,
                      isCurrent: i == bars.length - 1,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                fmtDay(bars.first.window.startDay),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ),
              Text(
                'now',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bar(
    PeriodStat stat,
    double ratio,
    Color color, {
    required bool isCurrent,
  }) {
    final barColor = stat.met
        ? color
        : isCurrent
        ? color.withValues(alpha: 0.45)
        : Colors.white.withValues(alpha: 0.18);
    return AnimatedFractionallySizedBox(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      alignment: Alignment.bottomCenter,
      heightFactor: ratio < 0.04 ? 0.04 : ratio,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: barColor,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _logRow(TimeLog log, Color color, bool isCount) {
    return InkWell(
      onTap: () => _editSession(log, isCount),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              fmtDay(log.day),
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
            const Spacer(),
            if (isCount)
              Icon(
                Icons.check_rounded,
                size: 18,
                color: color.withValues(alpha: 0.8),
              )
            else
              Text(
                fmtCompact(log.durationMs),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: Colors.white.withValues(alpha: 0.25),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addSession(GoalProgress p) async {
    final result = await showSessionSheet(context, countGoal: p.isCount);
    if (result == null || result.delete) return;
    await widget.repo.addManualLog(
      goalId: p.goal.id,
      day: result.day,
      durationMinutes: result.durationMinutes,
    );
  }

  Future<void> _editSession(TimeLog log, bool isCount) async {
    final result = await showSessionSheet(
      context,
      existing: log,
      countGoal: isCount,
    );
    if (result == null) return;
    if (result.delete) {
      await widget.repo.deleteLog(log.id);
    } else {
      await widget.repo.updateLog(
        logId: log.id,
        day: result.day,
        durationMinutes: result.durationMinutes,
      );
    }
  }
}

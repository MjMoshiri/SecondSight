import 'package:flutter/material.dart';

import '../data/goal_repository.dart';
import 'format.dart';
import 'goal_detail_screen.dart';

/// How many past windows a goal card shows at most.
const _maxCells = 20;

/// The report tab: overall totals plus a per-goal look at how every past
/// period went.
class ReportScreen extends StatelessWidget {
  final GoalRepository repo;

  const ReportScreen({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<List<GoalReport>>(
        stream: repo.watchReport(),
        builder: (context, snapshot) {
          final reports = snapshot.data ?? const <GoalReport>[];
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _header()),
              if (snapshot.hasData && reports.isEmpty)
                SliverFillRemaining(hasScrollBody: false, child: _empty())
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                  sliver: SliverList.list(
                    children: [
                      _summary(reports),
                      const SizedBox(height: 24),
                      for (final report in reports) ...[
                        _GoalReportCard(
                          report: report,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GoalDetailScreen(
                                repo: repo,
                                goalId: report.goal.id,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Report',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'How your goals have been going',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summary(List<GoalReport> reports) {
    var totalMs = 0, weekMs = 0, completed = 0, met = 0;
    for (final r in reports) {
      totalMs += r.totalMs;
      weekMs += r.last7DaysMs;
      completed += r.completedPeriods;
      met += r.metPeriods;
    }
    final rate = completed == 0 ? '—' : '${(met / completed * 100).round()}%';
    return Row(
      children: [
        _tile('All time', fmtCompact(totalMs)),
        const SizedBox(width: 10),
        _tile('Last 7 days', fmtCompact(weekMs)),
        const SizedBox(width: 10),
        _tile('Hit rate', rate),
      ],
    );
  }

  Widget _tile(String label, String value) {
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
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _empty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.insert_chart_outlined_rounded,
            size: 44,
            color: Colors.white.withValues(alpha: 0.25),
          ),
          const SizedBox(height: 14),
          Text(
            'Nothing to report yet',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Create a goal and log some time first.',
            style: TextStyle(
              fontSize: 13.5,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalReportCard extends StatelessWidget {
  final GoalReport report;
  final VoidCallback onTap;

  const _GoalReportCard({required this.report, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = goalColor(report.goal.id);
    final rate = report.completedPeriods == 0
        ? '—'
        : '${(report.metPeriods / report.completedPeriods * 100).round()}%';
    final cells = report.history.length > _maxCells
        ? report.history.sublist(report.history.length - _maxCells)
        : report.history;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
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
                Expanded(
                  child: Text(
                    report.goal.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                _chip(report.period.chipLabel),
                const SizedBox(width: 10),
                Text(
                  rate,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var i = 0; i < cells.length; i++) ...[
                    if (i > 0) const SizedBox(width: 3),
                    Expanded(
                      child: _cell(
                        cells[i],
                        color,
                        isCurrent: i == cells.length - 1,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(fmtDay(cells.first.window.startDay), style: _axisStyle),
                Text('now', style: _axisStyle),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _footNote(
                  report.currentStreak > 0
                      ? 'streak ${report.currentStreak} · best '
                            '${report.bestStreak}'
                      : 'best streak ${report.bestStreak}',
                ),
                const Spacer(),
                _footNote(
                  report.isCount
                      ? '${report.totalCount} check-ins total'
                      : '${fmtCompact(report.totalMs)} total',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextStyle get _axisStyle =>
      TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.35));

  Widget _cell(PeriodStat stat, Color color, {required bool isCurrent}) {
    final ratio = report.isCount
        ? (report.targetCount == 0
              ? 0.0
              : (stat.count / report.targetCount).clamp(0.0, 1.0))
        : (report.targetMs == 0
              ? 0.0
              : (stat.loggedMs / report.targetMs).clamp(0.0, 1.0));
    final cellColor = stat.met
        ? color
        : isCurrent
        ? color.withValues(alpha: 0.45)
        : Colors.white.withValues(alpha: 0.18);
    return FractionallySizedBox(
      alignment: Alignment.bottomCenter,
      heightFactor: ratio < 0.08 ? 0.08 : ratio,
      child: Container(
        decoration: BoxDecoration(
          color: cellColor,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _footNote(String text) => Text(
    text,
    style: TextStyle(
      fontSize: 12.5,
      color: Colors.white.withValues(alpha: 0.45),
    ),
  );
}

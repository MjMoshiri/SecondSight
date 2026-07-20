import 'package:flutter/material.dart';

import '../data/goal_repository.dart';
import 'format.dart';
import 'segmented_bar.dart';

class GoalCard extends StatelessWidget {
  final GoalProgress progress;
  final int nowUtcMs;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onStop;
  final VoidCallback onDelete;

  const GoalCard({
    super.key,
    required this.progress,
    required this.nowUtcMs,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onStop,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final p = progress;
    final color = goalColor(p.goal.id);
    final active = p.timer != null;
    final elapsed = p.elapsedMs(nowUtcMs);
    final ratio = p.ratio(nowUtcMs);
    final daysLeft = p.window.daysLeft;

    return GestureDetector(
      onLongPress: onDelete,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
        decoration: BoxDecoration(
          color: const Color(0xFF161B24),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: active
                ? color.withValues(alpha: p.isRunning ? 0.55 : 0.25)
                : Colors.white.withValues(alpha: 0.06),
            width: 1.2,
          ),
          boxShadow: [
            if (p.isRunning)
              BoxShadow(
                color: color.withValues(alpha: 0.12),
                blurRadius: 24,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.goal.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${fmtCompact(p.targetMs)} every '
                        '${p.goal.periodDays == 1 ? 'day' : '${p.goal.periodDays} days'}'
                        ' · $daysLeft ${daysLeft == 1 ? 'day' : 'days'} left',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.white.withValues(alpha: 0.45),
                        ),
                      ),
                    ],
                  ),
                ),
                _controls(color),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (active) ...[
                  Text(
                    fmtTicking(p.timerElapsedMs(nowUtcMs)),
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                      color: p.isRunning
                          ? color
                          : Colors.white.withValues(alpha: 0.55),
                      letterSpacing: -0.5,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  '${fmtCompact(elapsed)} of ${fmtCompact(p.targetMs)}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.5),
                    height: 1.4,
                  ),
                ),
                const Spacer(),
                Text(
                  '${(ratio * 100).round()}%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SegmentedBar(
              ratio: ratio,
              sections: p.goal.sections,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  Widget _controls(Color color) {
    final p = progress;
    if (p.timer == null) {
      return _roundButton(
        icon: Icons.play_arrow_rounded,
        color: color,
        filled: true,
        onTap: onStart,
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _roundButton(
          icon: p.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: color,
          filled: true,
          onTap: p.isRunning ? onPause : onResume,
        ),
        const SizedBox(width: 8),
        _roundButton(
          icon: Icons.stop_rounded,
          color: Colors.white.withValues(alpha: 0.7),
          filled: false,
          onTap: onStop,
        ),
      ],
    );
  }

  Widget _roundButton({
    required IconData icon,
    required Color color,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return Material(
      color: filled
          ? color.withValues(alpha: 0.16)
          : Colors.white.withValues(alpha: 0.05),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: color, size: 26),
        ),
      ),
    );
  }
}

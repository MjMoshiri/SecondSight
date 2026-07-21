import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

import '../data/database.dart';
import '../data/goal_repository.dart';
import '../ui/format.dart';
import '../ui/segmented_bar.dart';
import 'timer_notification.dart';

const _androidProvider = 'GoalsWidgetProvider';

/// Max goals the fixed-layout widget can show.
const _maxWidgetGoals = 5;

bool get widgetSupported => !kIsWeb;

/// Pushes current goal state to the home-screen widget. The segmented bar
/// is rendered by Flutter to an image so the widget matches the app 1:1;
/// the ticking timer itself is a native Chronometer fed base timestamps.
Future<void> syncWidget(List<GoalProgress> goals) async {
  if (!widgetSupported) return;
  final now = DateTime.now().millisecondsSinceEpoch;
  final entries = <Map<String, Object?>>[];
  for (final p in goals.take(_maxWidgetGoals)) {
    final color = goalColor(p.goal.id);
    String? barPath;
    try {
      final rendered = await HomeWidget.renderFlutterWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SegmentedBar(
            ratio: p.ratio(now),
            sections: p.goal.sections,
            color: color,
            height: 10,
          ),
        ),
        key: 'bar_${p.goal.id}',
        logicalSize: const Size(280, 10),
      );
      barPath = rendered as String?;
    } catch (_) {
      barPath = null; // widget falls back to text-only for this row
    }
    final daysLeft = p.window.daysLeft;
    entries.add({
      'id': p.goal.id,
      'name': p.goal.name,
      'status': p.isCount
          ? '${p.checksInWindow} of ${p.targetCount} · ${daysLeft}d left'
          : p.isPaused
          ? 'Paused ${fmtTicking(p.timerElapsedMs(now))} · '
                '${fmtCompact(p.elapsedMs(now))} of ${fmtCompact(p.targetMs)}'
          : '${fmtCompact(p.elapsedMs(now))} of '
                '${fmtCompact(p.targetMs)} · ${daysLeft}d left',
      'running': p.isRunning,
      'paused': p.isPaused,
      'check': p.isCount,
      'elapsedMs': p.timerElapsedMs(now),
      'writtenAtUtc': now,
      'bar': barPath,
    });
  }
  await HomeWidget.saveWidgetData('goals', jsonEncode(entries));
  await HomeWidget.updateWidget(androidName: _androidProvider);
}

/// Ask the launcher to pin the widget to the home screen (Android 8+).
Future<void> requestPinWidget() =>
    HomeWidget.requestPinWidget(androidName: _androidProvider);

void registerWidgetInteractivity() {
  if (!widgetSupported) return;
  HomeWidget.registerInteractivityCallback(widgetInteractivityCallback);
}

/// Runs in a background isolate when a widget button is tapped — the app
/// may not be alive. Opens its own database connection, applies the action,
/// re-syncs the widget, and exits.
@pragma('vm:entry-point')
Future<void> widgetInteractivityCallback(Uri? uri) async {
  if (uri == null) return;
  final action = uri.queryParameters['action'];
  final goalId = uri.queryParameters['goalId'];
  if (action == null || goalId == null) return;

  final db = AppDatabase();
  try {
    final repo = GoalRepository(db);
    final goal = await (db.select(
      db.goals,
    )..where((g) => g.id.equals(goalId))).getSingleOrNull();
    // Stale widgets may still send 'start' for a goal that is now a count
    // goal; treat it as a check-in rather than starting a timer.
    final isCount = goal?.goalType == 'count';
    switch (action) {
      case 'check':
        await repo.check(goalId);
      case 'start':
        if (isCount) {
          await repo.check(goalId);
        } else {
          await repo.start(goalId);
        }
      case 'pause':
        await repo.pause(goalId);
      case 'resume':
        await repo.resume(goalId);
      case 'stop':
        await repo.stop(goalId);
    }
    final goals = await repo.watchAll().first;
    await syncWidget(goals);
    await syncTimerNotifications(goals);
  } finally {
    await db.close();
  }
}

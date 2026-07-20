import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../data/goal_repository.dart';
import '../ui/format.dart';

final _plugin = FlutterLocalNotificationsPlugin();
bool _initialized = false;

bool get _supported => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

Future<void> _ensureInit() async {
  if (_initialized) return;
  await _plugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
  );
  _initialized = true;
}

/// Stable per-goal notification id.
int _notificationId(String goalId) => goalId.hashCode & 0x7fffffff;

/// Mirrors timer state into the notification shade: a live chronometer
/// while running, a static "Paused" line while paused, nothing otherwise.
/// Runs both from the app and from the widget's background isolate.
Future<void> syncTimerNotifications(List<GoalProgress> goals) async {
  if (!_supported) return;
  await _ensureInit();
  final now = DateTime.now().millisecondsSinceEpoch;

  for (final p in goals) {
    final id = _notificationId(p.goal.id);
    if (!p.isRunning && !p.isPaused) {
      await _plugin.cancel(id);
      continue;
    }
    final details = AndroidNotificationDetails(
      'timers',
      'Timers',
      channelDescription: 'Live goal timers',
      importance: Importance.low, // visible but silent
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      onlyAlertOnce: true,
      playSound: false,
      enableVibration: false,
      showWhen: p.isRunning,
      usesChronometer: p.isRunning,
      when: p.isRunning ? now - p.timerElapsedMs(now) : null,
      category: AndroidNotificationCategory.stopwatch,
    );
    final body = p.isRunning
        ? '${fmtCompact(p.elapsedMs(now))} of ${fmtCompact(p.targetMs)}'
        : 'Paused at ${fmtTicking(p.timerElapsedMs(now))} · '
            '${fmtCompact(p.elapsedMs(now))} of ${fmtCompact(p.targetMs)}';
    await _plugin.show(
      id,
      p.goal.name,
      body,
      NotificationDetails(android: details),
    );
  }
}

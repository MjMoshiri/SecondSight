import 'package:drift/drift.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import 'database.dart';
import 'goal_type.dart';
import 'period.dart';

/// A goal joined with everything the UI needs to draw it: time logged (or
/// check-ins made) in the current period window and the live timer, if one
/// exists.
class GoalProgress {
  final Goal goal;
  final ActiveTimer? timer;
  final int loggedMsInWindow;

  /// Number of logs in the window — the progress of a count goal.
  final int checksInWindow;

  final PeriodWindow window;

  const GoalProgress({
    required this.goal,
    required this.timer,
    required this.loggedMsInWindow,
    required this.checksInWindow,
    required this.window,
  });

  int get targetMs => goal.targetMinutes * 60000;
  GoalPeriod get period => GoalPeriod.values.byName(goal.period);
  GoalType get type => GoalType.values.byName(goal.goalType);
  bool get isCount => type == GoalType.count;

  /// Target check-ins per period; only meaningful for count goals.
  int get targetCount => goal.targetMinutes;

  bool get isRunning => timer?.isRunning ?? false;
  bool get isPaused => timer != null && !timer!.isRunning;

  /// Logged time plus whatever the live timer has elapsed as of [nowUtcMs].
  int elapsedMs(int nowUtcMs) => loggedMsInWindow + timerElapsedMs(nowUtcMs);

  int timerElapsedMs(int nowUtcMs) {
    final t = timer;
    if (t == null) return 0;
    final inFlight = t.isRunning ? nowUtcMs - t.lastResumedAtUtc! : 0;
    return t.accumulatedMs + inFlight;
  }

  /// 0..1 fill fraction as of [nowUtcMs].
  double ratio(int nowUtcMs) {
    if (isCount) {
      return targetCount == 0
          ? 0
          : (checksInWindow / targetCount).clamp(0.0, 1.0);
    }
    return targetMs == 0 ? 0 : (elapsedMs(nowUtcMs) / targetMs).clamp(0.0, 1.0);
  }
}

/// One past (or current) period window and how it went.
class PeriodStat {
  final PeriodWindow window;
  final int loggedMs;

  /// Number of logs in the window — the progress of a count goal.
  final int count;

  final bool met;

  const PeriodStat({
    required this.window,
    required this.loggedMs,
    required this.count,
    required this.met,
  });
}

/// Historical performance for one goal, as shown on the report tab.
class GoalReport {
  final Goal goal;

  /// Oldest first; the current window is always last.
  final List<PeriodStat> history;

  final int totalMs;
  final int totalCount;
  final int last7DaysMs;
  final int completedPeriods;
  final int metPeriods;
  final int currentStreak;
  final int bestStreak;

  const GoalReport({
    required this.goal,
    required this.history,
    required this.totalMs,
    required this.totalCount,
    required this.last7DaysMs,
    required this.completedPeriods,
    required this.metPeriods,
    required this.currentStreak,
    required this.bestStreak,
  });

  int get targetMs => goal.targetMinutes * 60000;
  int get targetCount => goal.targetMinutes;
  GoalPeriod get period => GoalPeriod.values.byName(goal.period);
  GoalType get type => GoalType.values.byName(goal.goalType);
  bool get isCount => type == GoalType.count;
}

/// Everything the dashboard shows for one goal.
class GoalDetail {
  final GoalProgress progress;

  /// Oldest first; the current period is always last.
  final List<PeriodStat> history;

  /// Newest first, capped.
  final List<TimeLog> recentLogs;

  final int totalMs;
  final int totalCount;
  final int completedPeriods;
  final int metPeriods;
  final int currentStreak;
  final int bestStreak;

  const GoalDetail({
    required this.progress,
    required this.history,
    required this.recentLogs,
    required this.totalMs,
    required this.totalCount,
    required this.completedPeriods,
    required this.metPeriods,
    required this.currentStreak,
    required this.bestStreak,
  });
}

class GoalRepository {
  final AppDatabase db;
  final DateTime Function() _clock;
  final _uuid = const Uuid();

  GoalRepository(this.db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  int get _nowUtcMs => _clock().millisecondsSinceEpoch;
  String get _today => formatDay(_clock());

  /// All non-archived goals with progress, newest first. Re-emits whenever
  /// goals, logs, or timers change.
  Stream<List<GoalProgress>> watchAll() {
    final goals =
        (db.select(db.goals)
              ..where((g) => g.archivedAtUtc.isNull())
              ..orderBy([(g) => OrderingTerm.desc(g.createdAtUtc)]))
            .watch();
    final logs = db.select(db.timeLogs).watch();
    final timers = db.select(db.activeTimers).watch();
    return Rx.combineLatest3(goals, logs, timers, _assemble);
  }

  List<GoalProgress> _assemble(
    List<Goal> goals,
    List<TimeLog> logs,
    List<ActiveTimer> timers,
  ) {
    final today = _clock();
    final timerByGoal = {for (final t in timers) t.goalId: t};
    return [
      for (final goal in goals)
        () {
          final window = currentWindow(
            period: GoalPeriod.values.byName(goal.period),
            today: today,
          );
          var logged = 0, checks = 0;
          for (final log in logs) {
            if (log.goalId == goal.id &&
                log.day.compareTo(window.startDay) >= 0 &&
                log.day.compareTo(window.endDay) < 0) {
              logged += log.durationMs;
              checks++;
            }
          }
          return GoalProgress(
            goal: goal,
            timer: timerByGoal[goal.id],
            loggedMsInWindow: logged,
            checksInWindow: checks,
            window: window,
          );
        }(),
    ];
  }

  /// Past performance of every non-archived goal, newest goal first.
  /// Re-emits whenever goals or logs change.
  Stream<List<GoalReport>> watchReport() {
    final goals =
        (db.select(db.goals)
              ..where((g) => g.archivedAtUtc.isNull())
              ..orderBy([(g) => OrderingTerm.desc(g.createdAtUtc)]))
            .watch();
    final logs = db.select(db.timeLogs).watch();
    return Rx.combineLatest2(goals, logs, _assembleReport);
  }

  List<GoalReport> _assembleReport(List<Goal> goals, List<TimeLog> logs) {
    final today = _clock();
    final weekCutoff = formatDay(today.subtract(const Duration(days: 6)));
    return [
      for (final goal in goals)
        () {
          final goalLogs = [
            for (final log in logs)
              if (log.goalId == goal.id) log,
          ];
          final history = _history(goal, goalLogs, today);
          final (current, best) = _streaks(history);
          var totalMs = 0, weekMs = 0;
          for (final log in goalLogs) {
            totalMs += log.durationMs;
            if (log.day.compareTo(weekCutoff) >= 0) weekMs += log.durationMs;
          }
          final completed = history.length - 1;
          return GoalReport(
            goal: goal,
            history: history,
            totalMs: totalMs,
            totalCount: goalLogs.length,
            last7DaysMs: weekMs,
            completedPeriods: completed,
            metPeriods: history.take(completed).where((p) => p.met).length,
            currentStreak: current,
            bestStreak: best,
          );
        }(),
    ];
  }

  /// Dashboard stream for one goal. Emits null if the goal was deleted.
  Stream<GoalDetail?> watchDetail(String goalId) {
    final goal = (db.select(
      db.goals,
    )..where((g) => g.id.equals(goalId))).watchSingleOrNull();
    final logs = (db.select(
      db.timeLogs,
    )..where((l) => l.goalId.equals(goalId))).watch();
    final timer = (db.select(
      db.activeTimers,
    )..where((t) => t.goalId.equals(goalId))).watchSingleOrNull();
    return Rx.combineLatest3(goal, logs, timer, _assembleDetail);
  }

  GoalDetail? _assembleDetail(
    Goal? goal,
    List<TimeLog> logs,
    ActiveTimer? timer,
  ) {
    if (goal == null) return null;
    final history = _history(goal, logs, _clock());
    final (current, best) = _streaks(history);
    final completed = history.length - 1; // all but the current window

    var totalMs = 0;
    for (final log in logs) {
      totalMs += log.durationMs;
    }
    final recent = [...logs]
      ..sort((a, b) {
        final byDay = b.day.compareTo(a.day);
        return byDay != 0 ? byDay : b.createdAtUtc.compareTo(a.createdAtUtc);
      });

    return GoalDetail(
      progress: GoalProgress(
        goal: goal,
        timer: timer,
        loggedMsInWindow: history.last.loggedMs,
        checksInWindow: history.last.count,
        window: history.last.window,
      ),
      history: history,
      recentLogs: recent.take(20).toList(),
      totalMs: totalMs,
      totalCount: logs.length,
      completedPeriods: completed,
      metPeriods: history.take(completed).where((p) => p.met).length,
      currentStreak: current,
      bestStreak: best,
    );
  }

  /// Per-window stats for [goal] from its creation window through today.
  /// [logs] must already be filtered to this goal.
  List<PeriodStat> _history(Goal goal, List<TimeLog> logs, DateTime today) {
    final windows = windowsThrough(
      period: GoalPeriod.values.byName(goal.period),
      firstDay: goal.startDay,
      today: today,
    );
    final isCount = goal.goalType == GoalType.count.name;
    final targetMs = goal.targetMinutes * 60000;
    return [
      for (final w in windows)
        () {
          var logged = 0, count = 0;
          for (final log in logs) {
            if (log.day.compareTo(w.startDay) >= 0 &&
                log.day.compareTo(w.endDay) < 0) {
              logged += log.durationMs;
              count++;
            }
          }
          return PeriodStat(
            window: w,
            loggedMs: logged,
            count: count,
            met: isCount ? count >= goal.targetMinutes : logged >= targetMs,
          );
        }(),
    ];
  }

  /// (current, best) streak of met periods. The in-progress window only
  /// counts toward the current streak once it's already met.
  (int, int) _streaks(List<PeriodStat> history) {
    final completed = history.length - 1;
    var best = 0, run = 0;
    for (var i = 0; i < completed; i++) {
      run = history[i].met ? run + 1 : 0;
      if (run > best) best = run;
    }
    var current = 0;
    for (var i = completed - 1; i >= 0; i--) {
      if (!history[i].met) break;
      current++;
    }
    if (history.isNotEmpty && history.last.met) current++;
    if (current > best) best = current;
    return (current, best);
  }

  /// For count goals, [targetMinutes] is the target number of check-ins.
  Future<String> createGoal({
    required String name,
    required int targetMinutes,
    required GoalPeriod period,
    int sections = 1,
    GoalType type = GoalType.time,
  }) async {
    final id = _uuid.v4();
    await db
        .into(db.goals)
        .insert(
          GoalsCompanion.insert(
            id: id,
            name: name,
            targetMinutes: targetMinutes,
            period: period.name,
            goalType: Value(type.name),
            sections: Value(sections),
            startDay: _today,
            createdAtUtc: _nowUtcMs,
          ),
        );
    return id;
  }

  Future<void> deleteGoal(String goalId) => db.transaction(() async {
    await (db.delete(
      db.activeTimers,
    )..where((t) => t.goalId.equals(goalId))).go();
    await (db.delete(db.timeLogs)..where((l) => l.goalId.equals(goalId))).go();
    await (db.delete(db.goals)..where((g) => g.id.equals(goalId))).go();
  });

  /// Starts a timer for [goalId]. No-op if one already exists.
  Future<void> start(String goalId) async {
    final now = _nowUtcMs;
    await db
        .into(db.activeTimers)
        .insert(
          ActiveTimersCompanion.insert(
            goalId: goalId,
            isRunning: true,
            startedAtUtc: now,
            lastResumedAtUtc: Value(now),
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  Future<void> pause(String goalId) => db.transaction(() async {
    final timer = await _timerFor(goalId);
    if (timer == null || !timer.isRunning) return;
    final now = _nowUtcMs;
    await _updateTimer(
      goalId,
      ActiveTimersCompanion(
        isRunning: const Value(false),
        lastResumedAtUtc: const Value(null),
        accumulatedMs: Value(
          timer.accumulatedMs + (now - timer.lastResumedAtUtc!),
        ),
      ),
    );
  });

  Future<void> resume(String goalId) => db.transaction(() async {
    final timer = await _timerFor(goalId);
    if (timer == null || timer.isRunning) return;
    await _updateTimer(
      goalId,
      ActiveTimersCompanion(
        isRunning: const Value(true),
        lastResumedAtUtc: Value(_nowUtcMs),
      ),
    );
  });

  /// Stops the timer, writing its elapsed time as a TimeLog on today's day.
  Future<void> stop(String goalId) => db.transaction(() async {
    final timer = await _timerFor(goalId);
    if (timer == null) return;
    final now = _nowUtcMs;
    final inFlight = timer.isRunning ? now - timer.lastResumedAtUtc! : 0;
    final elapsed = timer.accumulatedMs + inFlight;
    if (elapsed > 0) {
      await db
          .into(db.timeLogs)
          .insert(
            TimeLogsCompanion.insert(
              id: _uuid.v4(),
              goalId: goalId,
              durationMs: elapsed,
              day: _today,
              createdAtUtc: now,
            ),
          );
    }
    await (db.delete(
      db.activeTimers,
    )..where((t) => t.goalId.equals(goalId))).go();
  });

  /// Logs one check-in for a count goal on [day] (defaults to today).
  /// Returns the log id so the caller can offer an undo.
  Future<String> check(String goalId, {String? day}) async {
    final id = _uuid.v4();
    await db
        .into(db.timeLogs)
        .insert(
          TimeLogsCompanion.insert(
            id: id,
            goalId: goalId,
            durationMs: 0,
            day: day ?? _today,
            createdAtUtc: _nowUtcMs,
          ),
        );
    return id;
  }

  /// Manually logs a session, as if a timer had run for [durationMinutes]
  /// on [day] ('yyyy-MM-dd').
  Future<void> addManualLog({
    required String goalId,
    required String day,
    required int durationMinutes,
  }) async {
    await db
        .into(db.timeLogs)
        .insert(
          TimeLogsCompanion.insert(
            id: _uuid.v4(),
            goalId: goalId,
            durationMs: durationMinutes * 60000,
            day: day,
            createdAtUtc: _nowUtcMs,
          ),
        );
  }

  Future<void> updateLog({
    required String logId,
    required String day,
    required int durationMinutes,
  }) => (db.update(db.timeLogs)..where((l) => l.id.equals(logId))).write(
    TimeLogsCompanion(
      day: Value(day),
      durationMs: Value(durationMinutes * 60000),
    ),
  );

  Future<void> deleteLog(String logId) =>
      (db.delete(db.timeLogs)..where((l) => l.id.equals(logId))).go();

  Future<ActiveTimer?> _timerFor(String goalId) => (db.select(
    db.activeTimers,
  )..where((t) => t.goalId.equals(goalId))).getSingleOrNull();

  Future<void> _updateTimer(String goalId, ActiveTimersCompanion changes) =>
      (db.update(
        db.activeTimers,
      )..where((t) => t.goalId.equals(goalId))).write(changes);
}

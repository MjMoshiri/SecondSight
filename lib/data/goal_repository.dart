import 'package:drift/drift.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import 'database.dart';
import 'period.dart';

/// A goal joined with everything the UI needs to draw it: time logged in the
/// current period window and the live timer, if one exists.
class GoalProgress {
  final Goal goal;
  final ActiveTimer? timer;
  final int loggedMsInWindow;
  final PeriodWindow window;

  const GoalProgress({
    required this.goal,
    required this.timer,
    required this.loggedMsInWindow,
    required this.window,
  });

  int get targetMs => goal.targetMinutes * 60000;

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
  double ratio(int nowUtcMs) =>
      targetMs == 0 ? 0 : (elapsedMs(nowUtcMs) / targetMs).clamp(0.0, 1.0);
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
    final goals = (db.select(db.goals)
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
            startDay: goal.startDay,
            periodDays: goal.periodDays,
            today: today,
          );
          var logged = 0;
          for (final log in logs) {
            if (log.goalId == goal.id &&
                log.day.compareTo(window.startDay) >= 0 &&
                log.day.compareTo(window.endDay) < 0) {
              logged += log.durationMs;
            }
          }
          return GoalProgress(
            goal: goal,
            timer: timerByGoal[goal.id],
            loggedMsInWindow: logged,
            window: window,
          );
        }(),
    ];
  }

  Future<String> createGoal({
    required String name,
    required int targetMinutes,
    required int periodDays,
    int sections = 1,
  }) async {
    final id = _uuid.v4();
    await db.into(db.goals).insert(GoalsCompanion.insert(
          id: id,
          name: name,
          targetMinutes: targetMinutes,
          periodDays: periodDays,
          sections: Value(sections),
          startDay: _today,
          createdAtUtc: _nowUtcMs,
        ));
    return id;
  }

  Future<void> deleteGoal(String goalId) => db.transaction(() async {
        await (db.delete(db.activeTimers)
              ..where((t) => t.goalId.equals(goalId)))
            .go();
        await (db.delete(db.timeLogs)..where((l) => l.goalId.equals(goalId)))
            .go();
        await (db.delete(db.goals)..where((g) => g.id.equals(goalId))).go();
      });

  /// Starts a timer for [goalId]. No-op if one already exists.
  Future<void> start(String goalId) async {
    final now = _nowUtcMs;
    await db.into(db.activeTimers).insert(
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
            accumulatedMs:
                Value(timer.accumulatedMs + (now - timer.lastResumedAtUtc!)),
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
          await db.into(db.timeLogs).insert(TimeLogsCompanion.insert(
                id: _uuid.v4(),
                goalId: goalId,
                durationMs: elapsed,
                day: _today,
                createdAtUtc: now,
              ));
        }
        await (db.delete(db.activeTimers)
              ..where((t) => t.goalId.equals(goalId)))
            .go();
      });

  Future<ActiveTimer?> _timerFor(String goalId) =>
      (db.select(db.activeTimers)..where((t) => t.goalId.equals(goalId)))
          .getSingleOrNull();

  Future<void> _updateTimer(String goalId, ActiveTimersCompanion changes) =>
      (db.update(db.activeTimers)..where((t) => t.goalId.equals(goalId)))
          .write(changes);
}

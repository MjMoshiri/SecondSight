import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secondsight/data/database.dart';
import 'package:secondsight/data/goal_repository.dart';
import 'package:secondsight/data/goal_type.dart';
import 'package:secondsight/data/period.dart';

void main() {
  late AppDatabase db;
  late DateTime now;
  late GoalRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    now = DateTime(2026, 7, 19, 10, 0, 0);
    repo = GoalRepository(db, clock: () => now);
  });

  tearDown(() => db.close());

  int ms(GoalProgress p) => p.elapsedMs(now.millisecondsSinceEpoch);

  Future<GoalProgress> progress() async => (await repo.watchAll().first).single;

  test('create goal → appears with zero progress and correct window', () async {
    await repo.createGoal(
      name: 'Deep work',
      targetMinutes: 400,
      period: GoalPeriod.weekly,
      sections: 5,
    );
    final p = await progress();
    expect(p.goal.name, 'Deep work');
    expect(p.goal.sections, 5);
    expect(p.targetMs, 400 * 60000);
    expect(p.window.startDay, '2026-07-13');
    expect(p.window.endDay, '2026-07-20');
    expect(ms(p), 0);
    expect(p.timer, isNull);
  });

  test('start → run 90s → pause → resume → stop writes one log', () async {
    final id = await repo.createGoal(
      name: 'Read',
      targetMinutes: 60,
      period: GoalPeriod.daily,
    );

    await repo.start(id);
    now = now.add(const Duration(seconds: 90));
    expect(ms(await progress()), 90000);
    expect((await progress()).isRunning, isTrue);

    await repo.pause(id);
    now = now.add(const Duration(minutes: 10)); // paused time doesn't count
    expect(ms(await progress()), 90000);
    expect((await progress()).isPaused, isTrue);

    await repo.resume(id);
    now = now.add(const Duration(seconds: 30));
    expect(ms(await progress()), 120000);

    await repo.stop(id);
    final p = await progress();
    expect(p.timer, isNull);
    expect(p.loggedMsInWindow, 120000);

    final logs = await db.select(db.timeLogs).get();
    expect(logs.single.durationMs, 120000);
    expect(logs.single.day, '2026-07-19');
  });

  test('start is a no-op when a timer already exists', () async {
    final id = await repo.createGoal(
      name: 'X',
      targetMinutes: 10,
      period: GoalPeriod.daily,
    );
    await repo.start(id);
    now = now.add(const Duration(seconds: 60));
    await repo.start(id); // must not reset the running timer
    expect(ms(await progress()), 60000);
  });

  test('logs outside the current window are excluded', () async {
    final id = await repo.createGoal(
      name: 'X',
      targetMinutes: 10,
      period: GoalPeriod.weekly,
    );
    await repo.start(id);
    now = now.add(const Duration(minutes: 5));
    await repo.stop(id);
    expect((await progress()).loggedMsInWindow, 5 * 60000);

    // Jump into the next calendar week: old log no longer counts.
    now = DateTime(2026, 7, 22, 9, 0, 0);
    expect((await progress()).loggedMsInWindow, 0);
    expect((await progress()).window.startDay, '2026-07-20');
  });

  test('stopping an immediately-stopped timer writes no zero log', () async {
    final id = await repo.createGoal(
      name: 'X',
      targetMinutes: 10,
      period: GoalPeriod.daily,
    );
    await repo.start(id);
    await repo.stop(id);
    expect(await db.select(db.timeLogs).get(), isEmpty);
  });

  test('watchReport aggregates history, streaks, and week total', () async {
    // Created on Sunday Jul 19; backdate creation to get past windows.
    final id = await repo.createGoal(
      name: 'Read',
      targetMinutes: 10,
      period: GoalPeriod.daily,
    );
    await (db.update(db.goals)..where((g) => g.id.equals(id))).write(
      const GoalsCompanion(startDay: Value('2026-07-16')),
    );

    Future<void> log(Duration d) async {
      await repo.start(id);
      now = now.add(d);
      await repo.stop(id);
    }

    // Jul 16 met, Jul 17 missed, Jul 18 met, Jul 19 (today) met.
    now = DateTime(2026, 7, 16, 9);
    await log(const Duration(minutes: 12));
    now = DateTime(2026, 7, 18, 9);
    await log(const Duration(minutes: 10));
    now = DateTime(2026, 7, 19, 9);
    await log(const Duration(minutes: 15));

    final report = (await repo.watchReport().first).single;
    expect(report.history.map((h) => h.met), [true, false, true, true]);
    expect(report.completedPeriods, 3);
    expect(report.metPeriods, 2);
    expect(report.currentStreak, 2); // Jul 18 + today
    expect(report.bestStreak, 2);
    expect(report.totalMs, 37 * 60000);
    expect(report.last7DaysMs, 37 * 60000);
  });

  test('addManualLog writes a log for the given day and duration', () async {
    final id = await repo.createGoal(
      name: 'X',
      targetMinutes: 10,
      period: GoalPeriod.daily,
    );
    await repo.addManualLog(goalId: id, day: '2026-07-19', durationMinutes: 25);
    final logs = await db.select(db.timeLogs).get();
    expect(logs.single.day, '2026-07-19');
    expect(logs.single.durationMs, 25 * 60000);
    expect((await progress()).loggedMsInWindow, 25 * 60000);
  });

  test('updateLog changes an existing log\'s day and duration', () async {
    final id = await repo.createGoal(
      name: 'X',
      targetMinutes: 10,
      period: GoalPeriod.daily,
    );
    await repo.addManualLog(goalId: id, day: '2026-07-19', durationMinutes: 10);
    final logId = (await db.select(db.timeLogs).get()).single.id;

    await repo.updateLog(logId: logId, day: '2026-07-18', durationMinutes: 40);
    final logs = await db.select(db.timeLogs).get();
    expect(logs.single.day, '2026-07-18');
    expect(logs.single.durationMs, 40 * 60000);
  });

  test('deleteLog removes just that log', () async {
    final id = await repo.createGoal(
      name: 'X',
      targetMinutes: 10,
      period: GoalPeriod.daily,
    );
    await repo.addManualLog(goalId: id, day: '2026-07-19', durationMinutes: 10);
    await repo.addManualLog(goalId: id, day: '2026-07-19', durationMinutes: 20);
    final logs = await db.select(db.timeLogs).get();

    await repo.deleteLog(logs.first.id);
    final remaining = await db.select(db.timeLogs).get();
    expect(remaining.length, 1);
    expect(remaining.single.id, logs.last.id);
  });

  test(
    'count goal: checks fill the window and can exceed the target',
    () async {
      final id = await repo.createGoal(
        name: 'Gym',
        targetMinutes: 3, // 3 times a week
        period: GoalPeriod.weekly,
        type: GoalType.count,
      );

      var p = await progress();
      expect(p.isCount, isTrue);
      expect(p.targetCount, 3);
      expect(p.checksInWindow, 0);
      expect(p.ratio(now.millisecondsSinceEpoch), 0);

      await repo.check(id);
      await repo.check(id);
      p = await progress();
      expect(p.checksInWindow, 2);
      expect(p.ratio(now.millisecondsSinceEpoch), closeTo(2 / 3, 1e-9));

      // Third check meets the goal; a fourth is allowed and caps the ratio.
      await repo.check(id);
      await repo.check(id);
      p = await progress();
      expect(p.checksInWindow, 4);
      expect(p.ratio(now.millisecondsSinceEpoch), 1.0);

      final detail = (await repo.watchDetail(id).first)!;
      expect(detail.history.last.count, 4);
      expect(detail.history.last.met, isTrue);
      expect(detail.totalCount, 4);
    },
  );

  test('count goal: checks land on their window; undo via deleteLog', () async {
    final id = await repo.createGoal(
      name: 'Gym',
      targetMinutes: 2,
      period: GoalPeriod.weekly,
      type: GoalType.count,
    );

    // Backdated check-in belongs to last week's window, not this one.
    await repo.check(id, day: '2026-07-12');
    expect((await progress()).checksInWindow, 0);

    final logId = await repo.check(id);
    expect((await progress()).checksInWindow, 1);

    await repo.deleteLog(logId);
    expect((await progress()).checksInWindow, 0);

    // Zero-duration check-ins never leak into time totals.
    final report = (await repo.watchReport().first).single;
    expect(report.totalMs, 0);
    expect(report.totalCount, 1);
  });

  test('deleteGoal removes goal, logs, and timer', () async {
    final id = await repo.createGoal(
      name: 'X',
      targetMinutes: 10,
      period: GoalPeriod.daily,
    );
    await repo.start(id);
    now = now.add(const Duration(minutes: 1));
    await repo.stop(id);
    await repo.start(id);
    await repo.deleteGoal(id);
    expect(await repo.watchAll().first, isEmpty);
    expect(await db.select(db.timeLogs).get(), isEmpty);
    expect(await db.select(db.activeTimers).get(), isEmpty);
  });
}

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secondsight/data/database.dart';
import 'package:secondsight/data/goal_repository.dart';

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

  Future<GoalProgress> progress() async =>
      (await repo.watchAll().first).single;

  test('create goal → appears with zero progress and correct window',
      () async {
    await repo.createGoal(
        name: 'Deep work', targetMinutes: 400, periodDays: 3, sections: 5);
    final p = await progress();
    expect(p.goal.name, 'Deep work');
    expect(p.goal.sections, 5);
    expect(p.targetMs, 400 * 60000);
    expect(p.window.startDay, '2026-07-19');
    expect(p.window.endDay, '2026-07-22');
    expect(ms(p), 0);
    expect(p.timer, isNull);
  });

  test('start → run 90s → pause → resume → stop writes one log', () async {
    final id = await repo.createGoal(
        name: 'Read', targetMinutes: 60, periodDays: 1);

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
    final id =
        await repo.createGoal(name: 'X', targetMinutes: 10, periodDays: 1);
    await repo.start(id);
    now = now.add(const Duration(seconds: 60));
    await repo.start(id); // must not reset the running timer
    expect(ms(await progress()), 60000);
  });

  test('logs outside the current window are excluded', () async {
    final id =
        await repo.createGoal(name: 'X', targetMinutes: 10, periodDays: 3);
    await repo.start(id);
    now = now.add(const Duration(minutes: 5));
    await repo.stop(id);
    expect((await progress()).loggedMsInWindow, 5 * 60000);

    // Jump into the next 3-day window: old log no longer counts.
    now = DateTime(2026, 7, 22, 9, 0, 0);
    expect((await progress()).loggedMsInWindow, 0);
    expect((await progress()).window.startDay, '2026-07-22');
  });

  test('stopping an immediately-stopped timer writes no zero log', () async {
    final id =
        await repo.createGoal(name: 'X', targetMinutes: 10, periodDays: 1);
    await repo.start(id);
    await repo.stop(id);
    expect(await db.select(db.timeLogs).get(), isEmpty);
  });

  test('deleteGoal removes goal, logs, and timer', () async {
    final id =
        await repo.createGoal(name: 'X', targetMinutes: 10, periodDays: 1);
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

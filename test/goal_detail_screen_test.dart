import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secondsight/data/database.dart';
import 'package:secondsight/data/goal_repository.dart';
import 'package:secondsight/data/period.dart';
import 'package:secondsight/ui/goal_detail_screen.dart';

void main() {
  testWidgets('detail screen renders history chart and sessions without '
      'layout errors', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    final now = DateTime(2026, 7, 21, 10);
    final repo = GoalRepository(db, clock: () => now);

    // Drift completes its futures on real async events, so run DB setup
    // outside the test's fake-async zone.
    late final String id;
    await tester.runAsync(() async {
      id = await repo.createGoal(
        name: 'Read',
        targetMinutes: 60,
        period: GoalPeriod.daily,
      );
      await repo.addManualLog(
        goalId: id,
        day: '2026-07-21',
        durationMinutes: 30,
      );
    });

    await tester.pumpWidget(
      MaterialApp(
        home: GoalDetailScreen(repo: repo, goalId: id),
      ),
    );
    // Let the watchDetail stream deliver its first event, then rebuild.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400)); // bar animation

    expect(tester.takeException(), isNull);
    expect(find.text('Read'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('Recent sessions'), findsOneWidget);

    // Tear down the screen's 1s ticker before the test ends. Closing the
    // db is fire-and-forget: awaiting it deadlocks under the test zone.
    await tester.pumpWidget(const SizedBox());
    // Flush drift's zero-duration stream-close timer.
    await tester.pump(const Duration(milliseconds: 50));
    unawaited(db.close());
  });
}

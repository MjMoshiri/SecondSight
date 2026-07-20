import 'package:flutter_test/flutter_test.dart';
import 'package:secondsight/data/period.dart';

void main() {
  // 2026-07-19 is a Sunday.
  final sunday = DateTime(2026, 7, 19);

  test('formatDay pads and sorts', () {
    expect(formatDay(DateTime(2026, 7, 9)), '2026-07-09');
    expect('2026-07-09'.compareTo('2026-07-19'), lessThan(0));
  });

  test('daily: every day is its own window', () {
    final w = currentWindow(period: GoalPeriod.daily, today: sunday);
    expect(w.startDay, '2026-07-19');
    expect(w.endDay, '2026-07-20');
    expect(w.daysLeft, 1);
  });

  test('weekly: windows run Monday to Monday', () {
    final w = currentWindow(period: GoalPeriod.weekly, today: sunday);
    expect(w.startDay, '2026-07-13');
    expect(w.endDay, '2026-07-20');
    expect(w.daysLeft, 1);

    final monday = currentWindow(
      period: GoalPeriod.weekly,
      today: DateTime(2026, 7, 20),
    );
    expect(monday.startDay, '2026-07-20');
    expect(monday.daysLeft, 7);
  });

  test('biweekly: 14-day windows anchored to a fixed Monday', () {
    final w = currentWindow(period: GoalPeriod.biweekly, today: sunday);
    expect(w.startDay, '2026-07-13');
    expect(w.endDay, '2026-07-27');
    expect(w.daysLeft, 8);
  });

  test('monthly: windows run 1st to 1st', () {
    final w = currentWindow(period: GoalPeriod.monthly, today: sunday);
    expect(w.startDay, '2026-07-01');
    expect(w.endDay, '2026-08-01');
    expect(w.daysLeft, 13);

    final dec = currentWindow(
      period: GoalPeriod.monthly,
      today: DateTime(2026, 12, 31),
    );
    expect(dec.startDay, '2026-12-01');
    expect(dec.endDay, '2027-01-01');
    expect(dec.daysLeft, 1);
  });

  test('windowsThrough spans creation week through current week', () {
    final windows = windowsThrough(
      period: GoalPeriod.weekly,
      firstDay: '2026-07-05', // a Sunday, inside the week of Jun 29
      today: sunday,
    );
    expect(windows.map((w) => w.startDay),
        ['2026-06-29', '2026-07-06', '2026-07-13']);
    expect(windows.take(2).map((w) => w.daysLeft), [0, 0]);
    expect(windows.last.daysLeft, 1);
  });

  test('windowsThrough handles month lengths', () {
    final windows = windowsThrough(
      period: GoalPeriod.monthly,
      firstDay: '2026-05-20',
      today: sunday,
    );
    expect(windows.map((w) => w.startDay),
        ['2026-05-01', '2026-06-01', '2026-07-01']);
    expect(windows.map((w) => w.endDay),
        ['2026-06-01', '2026-07-01', '2026-08-01']);
  });

  test('windowsThrough caps at the limit most recent windows', () {
    final windows = windowsThrough(
      period: GoalPeriod.daily,
      firstDay: '2026-01-01',
      today: sunday,
      limit: 60,
    );
    expect(windows.length, 60);
    expect(windows.last.startDay, '2026-07-19');
  });
}

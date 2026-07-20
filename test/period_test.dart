import 'package:flutter_test/flutter_test.dart';
import 'package:secondsight/data/period.dart';

void main() {
  test('formatDay pads and sorts', () {
    expect(formatDay(DateTime(2026, 7, 9)), '2026-07-09');
    expect('2026-07-09'.compareTo('2026-07-19'), lessThan(0));
  });

  test('first window: day 0 of a 3-day period', () {
    final w = currentWindow(
      startDay: '2026-07-19',
      periodDays: 3,
      today: DateTime(2026, 7, 19),
    );
    expect(w.startDay, '2026-07-19');
    expect(w.endDay, '2026-07-22');
    expect(w.daysLeft, 3);
  });

  test('last day of first window', () {
    final w = currentWindow(
      startDay: '2026-07-19',
      periodDays: 3,
      today: DateTime(2026, 7, 21),
    );
    expect(w.startDay, '2026-07-19');
    expect(w.endDay, '2026-07-22');
    expect(w.daysLeft, 1);
  });

  test('rolls into the second window', () {
    final w = currentWindow(
      startDay: '2026-07-19',
      periodDays: 3,
      today: DateTime(2026, 7, 22),
    );
    expect(w.startDay, '2026-07-22');
    expect(w.endDay, '2026-07-25');
    expect(w.daysLeft, 3);
  });

  test('crosses month boundary', () {
    final w = currentWindow(
      startDay: '2026-07-30',
      periodDays: 7,
      today: DateTime(2026, 8, 2),
    );
    expect(w.startDay, '2026-07-30');
    expect(w.endDay, '2026-08-06');
    expect(w.daysLeft, 4);
  });

  test('daily goal: every day is its own window', () {
    final w = currentWindow(
      startDay: '2026-07-01',
      periodDays: 1,
      today: DateTime(2026, 7, 19),
    );
    expect(w.startDay, '2026-07-19');
    expect(w.endDay, '2026-07-20');
    expect(w.daysLeft, 1);
  });
}

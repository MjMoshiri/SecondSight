/// Pure date math for goal periods. Days are local calendar days encoded as
/// sortable 'yyyy-MM-dd' strings; all arithmetic happens in UTC to dodge DST.
///
/// Periods are calendar-aligned, so there is nothing to configure: daily
/// resets at midnight, weekly and biweekly on Mondays, monthly on the 1st.
library;

/// Reference Monday that anchors biweekly windows (2024-01-01 was a Monday).
final DateTime _biweeklyAnchor = DateTime.utc(2024, 1, 1);

enum GoalPeriod {
  daily,
  weekly,
  biweekly,
  monthly;

  /// Inline label: '2h daily', '6h every 2 weeks'.
  String get label => switch (this) {
        daily => 'daily',
        weekly => 'weekly',
        biweekly => 'every 2 weeks',
        monthly => 'monthly',
      };

  /// Short label for selection chips.
  String get chipLabel => switch (this) {
        daily => 'Daily',
        weekly => 'Weekly',
        biweekly => '2 weeks',
        monthly => 'Monthly',
      };
}

String formatDay(DateTime local) {
  final y = local.year.toString().padLeft(4, '0');
  final m = local.month.toString().padLeft(2, '0');
  final d = local.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

DateTime _parseDayUtc(String day) {
  final parts = day.split('-');
  return DateTime.utc(
    int.parse(parts[0]),
    int.parse(parts[1]),
    int.parse(parts[2]),
  );
}

/// A period window, e.g. one calendar week for a weekly goal.
class PeriodWindow {
  /// First day of the window, inclusive ('yyyy-MM-dd').
  final String startDay;

  /// First day after the window, exclusive ('yyyy-MM-dd').
  final String endDay;

  /// Days remaining in the window, counting today. 0 for past windows.
  final int daysLeft;

  const PeriodWindow({
    required this.startDay,
    required this.endDay,
    required this.daysLeft,
  });
}

/// First day of the window containing [day].
DateTime _windowStart(GoalPeriod period, DateTime day) => switch (period) {
      GoalPeriod.daily => day,
      GoalPeriod.weekly => day.subtract(Duration(days: day.weekday - 1)),
      GoalPeriod.biweekly => () {
          final days = day.difference(_biweeklyAnchor).inDays;
          return _biweeklyAnchor.add(Duration(days: (days ~/ 14) * 14));
        }(),
      GoalPeriod.monthly => DateTime.utc(day.year, day.month, 1),
    };

/// First day of the window after the one starting at [windowStart].
DateTime _nextWindowStart(GoalPeriod period, DateTime windowStart) =>
    switch (period) {
      GoalPeriod.daily => windowStart.add(const Duration(days: 1)),
      GoalPeriod.weekly => windowStart.add(const Duration(days: 7)),
      GoalPeriod.biweekly => windowStart.add(const Duration(days: 14)),
      GoalPeriod.monthly =>
        DateTime.utc(windowStart.year, windowStart.month + 1, 1),
    };

PeriodWindow _window(GoalPeriod period, DateTime start, DateTime? today) {
  final end = _nextWindowStart(period, start);
  return PeriodWindow(
    startDay: formatDay(start),
    endDay: formatDay(end),
    daysLeft: today == null ? 0 : end.difference(today).inDays,
  );
}

/// The calendar window containing [today].
PeriodWindow currentWindow({
  required GoalPeriod period,
  required DateTime today,
}) {
  final day = _parseDayUtc(formatDay(today));
  return _window(period, _windowStart(period, day), day);
}

/// Every window from the one containing [firstDay] (the goal's creation day)
/// through the one containing [today], oldest first, capped at the [limit]
/// most recent. The current window is always last; daysLeft is 0 for past
/// windows.
List<PeriodWindow> windowsThrough({
  required GoalPeriod period,
  required String firstDay,
  required DateTime today,
  int limit = 60,
}) {
  final day = _parseDayUtc(formatDay(today));
  final currentStart = _windowStart(period, day);
  var first = _windowStart(period, _parseDayUtc(firstDay));
  if (first.isAfter(currentStart)) first = currentStart;

  final starts = <DateTime>[];
  for (var s = first;
      !s.isAfter(currentStart);
      s = _nextWindowStart(period, s)) {
    starts.add(s);
  }
  final visible =
      starts.length <= limit ? starts : starts.sublist(starts.length - limit);
  return [
    for (final s in visible)
      _window(period, s, s == currentStart ? day : null),
  ];
}

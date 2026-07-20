/// Pure date math for goal periods. Days are local calendar days encoded as
/// sortable 'yyyy-MM-dd' strings; all arithmetic happens in UTC to dodge DST.
library;

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

/// The period window containing [today] for a goal that started on [startDay]
/// and repeats every [periodDays] days.
class PeriodWindow {
  /// First day of the window, inclusive ('yyyy-MM-dd').
  final String startDay;

  /// First day after the window, exclusive ('yyyy-MM-dd').
  final String endDay;

  /// Days remaining in the window, counting today. Always in 1..periodDays.
  final int daysLeft;

  const PeriodWindow({
    required this.startDay,
    required this.endDay,
    required this.daysLeft,
  });
}

PeriodWindow currentWindow({
  required String startDay,
  required int periodDays,
  required DateTime today,
}) {
  final start = _parseDayUtc(startDay);
  final now = _parseDayUtc(formatDay(today));
  var daysSince = now.difference(start).inDays;
  if (daysSince < 0) daysSince = 0; // goal starting in the future: clamp
  final index = daysSince ~/ periodDays;
  final winStart = start.add(Duration(days: index * periodDays));
  final winEnd = winStart.add(Duration(days: periodDays));
  return PeriodWindow(
    startDay: formatDay(winStart),
    endDay: formatDay(winEnd),
    daysLeft: periodDays - (daysSince % periodDays),
  );
}

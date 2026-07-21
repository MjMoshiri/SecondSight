/// What a goal counts: tracked time, or how many times you did the thing.
enum GoalType {
  /// Minutes per period, filled by timers or manual sessions.
  time,

  /// Check-ins per period, e.g. gym 3 times a week. One tap = one check-in.
  count,
}

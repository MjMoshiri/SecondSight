import 'package:drift/drift.dart';

/// A goal is a target per calendar period: either a portion of time
/// (400 minutes weekly) or a number of check-ins (gym 3 times a week).
///
/// Period windows are derived, never stored — they align to the calendar
/// (daily = midnight, weekly/biweekly = Mondays, monthly = the 1st), so
/// every goal with the same cadence shares the same window boundaries.
class Goals extends Table {
  TextColumn get id => text()(); // uuid
  TextColumn get name => text()();

  /// The per-period target. Minutes for 'time' goals; number of check-ins
  /// for 'count' goals.
  IntColumn get targetMinutes => integer()();

  /// GoalType name: 'time' | 'count'.
  TextColumn get goalType => text().withDefault(const Constant('time'))();

  /// GoalPeriod name: 'daily' | 'weekly' | 'biweekly' | 'monthly'.
  TextColumn get period => text()();

  /// Display only: how many segments the progress bar is drawn with.
  /// Has no effect on tracking or progress math.
  IntColumn get sections => integer().withDefault(const Constant(1))();

  /// Local day ('yyyy-MM-dd') the goal was created; bounds period history.
  TextColumn get startDay => text()();

  IntColumn get createdAtUtc => integer()();
  IntColumn get archivedAtUtc => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A finished chunk of tracked time — written when a timer stops, or
/// entered/edited manually. Progress is always the sum of logs in a period
/// window.
///
/// For count goals each row is one check-in with durationMs 0; progress is
/// the number of rows in the window instead of their summed duration.
@TableIndex(name: 'time_logs_goal_day', columns: {#goalId, #day})
class TimeLogs extends Table {
  TextColumn get id => text()(); // uuid
  TextColumn get goalId => text().references(Goals, #id)();
  IntColumn get durationMs => integer()();

  /// Local day ('yyyy-MM-dd') this time counts toward.
  TextColumn get day => text()();

  IntColumn get createdAtUtc => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// The live timer. At most one per goal; deleted on stop after its time
/// is written to TimeLogs.
///
/// elapsed = accumulatedMs + (isRunning ? now - lastResumedAtUtc : 0)
class ActiveTimers extends Table {
  TextColumn get goalId => text().references(Goals, #id)();
  BoolColumn get isRunning => boolean()();
  IntColumn get startedAtUtc => integer()();

  /// Non-null exactly when [isRunning] is true.
  IntColumn get lastResumedAtUtc => integer().nullable()();
  IntColumn get accumulatedMs => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {goalId};
}

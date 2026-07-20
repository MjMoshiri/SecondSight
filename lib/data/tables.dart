import 'package:drift/drift.dart';

/// A goal is a portion of time per calendar period, e.g. 400 minutes weekly.
///
/// Period windows are derived, never stored — they align to the calendar
/// (daily = midnight, weekly/biweekly = Mondays, monthly = the 1st), so
/// every goal with the same cadence shares the same window boundaries.
class Goals extends Table {
  TextColumn get id => text()(); // uuid
  TextColumn get name => text()();
  IntColumn get targetMinutes => integer()();

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

/// A finished chunk of tracked time. Written once when a timer stops;
/// never updated. Progress is always the sum of logs in a period window.
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

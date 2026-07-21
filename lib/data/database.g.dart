// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $GoalsTable extends Goals with TableInfo<$GoalsTable, Goal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMinutesMeta = const VerificationMeta(
    'targetMinutes',
  );
  @override
  late final GeneratedColumn<int> targetMinutes = GeneratedColumn<int>(
    'target_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalTypeMeta = const VerificationMeta(
    'goalType',
  );
  @override
  late final GeneratedColumn<String> goalType = GeneratedColumn<String>(
    'goal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('time'),
  );
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
    'period',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sectionsMeta = const VerificationMeta(
    'sections',
  );
  @override
  late final GeneratedColumn<int> sections = GeneratedColumn<int>(
    'sections',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _startDayMeta = const VerificationMeta(
    'startDay',
  );
  @override
  late final GeneratedColumn<String> startDay = GeneratedColumn<String>(
    'start_day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<int> createdAtUtc = GeneratedColumn<int>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtUtcMeta = const VerificationMeta(
    'archivedAtUtc',
  );
  @override
  late final GeneratedColumn<int> archivedAtUtc = GeneratedColumn<int>(
    'archived_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    targetMinutes,
    goalType,
    period,
    sections,
    startDay,
    createdAtUtc,
    archivedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Goal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_minutes')) {
      context.handle(
        _targetMinutesMeta,
        targetMinutes.isAcceptableOrUnknown(
          data['target_minutes']!,
          _targetMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetMinutesMeta);
    }
    if (data.containsKey('goal_type')) {
      context.handle(
        _goalTypeMeta,
        goalType.isAcceptableOrUnknown(data['goal_type']!, _goalTypeMeta),
      );
    }
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    } else if (isInserting) {
      context.missing(_periodMeta);
    }
    if (data.containsKey('sections')) {
      context.handle(
        _sectionsMeta,
        sections.isAcceptableOrUnknown(data['sections']!, _sectionsMeta),
      );
    }
    if (data.containsKey('start_day')) {
      context.handle(
        _startDayMeta,
        startDay.isAcceptableOrUnknown(data['start_day']!, _startDayMeta),
      );
    } else if (isInserting) {
      context.missing(_startDayMeta);
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    if (data.containsKey('archived_at_utc')) {
      context.handle(
        _archivedAtUtcMeta,
        archivedAtUtc.isAcceptableOrUnknown(
          data['archived_at_utc']!,
          _archivedAtUtcMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Goal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Goal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      targetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_minutes'],
      )!,
      goalType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_type'],
      )!,
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period'],
      )!,
      sections: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sections'],
      )!,
      startDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_day'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc'],
      )!,
      archivedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}archived_at_utc'],
      ),
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }
}

class Goal extends DataClass implements Insertable<Goal> {
  final String id;
  final String name;

  /// The per-period target. Minutes for 'time' goals; number of check-ins
  /// for 'count' goals.
  final int targetMinutes;

  /// GoalType name: 'time' | 'count'.
  final String goalType;

  /// GoalPeriod name: 'daily' | 'weekly' | 'biweekly' | 'monthly'.
  final String period;

  /// Display only: how many segments the progress bar is drawn with.
  /// Has no effect on tracking or progress math.
  final int sections;

  /// Local day ('yyyy-MM-dd') the goal was created; bounds period history.
  final String startDay;
  final int createdAtUtc;
  final int? archivedAtUtc;
  const Goal({
    required this.id,
    required this.name,
    required this.targetMinutes,
    required this.goalType,
    required this.period,
    required this.sections,
    required this.startDay,
    required this.createdAtUtc,
    this.archivedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['target_minutes'] = Variable<int>(targetMinutes);
    map['goal_type'] = Variable<String>(goalType);
    map['period'] = Variable<String>(period);
    map['sections'] = Variable<int>(sections);
    map['start_day'] = Variable<String>(startDay);
    map['created_at_utc'] = Variable<int>(createdAtUtc);
    if (!nullToAbsent || archivedAtUtc != null) {
      map['archived_at_utc'] = Variable<int>(archivedAtUtc);
    }
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      name: Value(name),
      targetMinutes: Value(targetMinutes),
      goalType: Value(goalType),
      period: Value(period),
      sections: Value(sections),
      startDay: Value(startDay),
      createdAtUtc: Value(createdAtUtc),
      archivedAtUtc: archivedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAtUtc),
    );
  }

  factory Goal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goal(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      targetMinutes: serializer.fromJson<int>(json['targetMinutes']),
      goalType: serializer.fromJson<String>(json['goalType']),
      period: serializer.fromJson<String>(json['period']),
      sections: serializer.fromJson<int>(json['sections']),
      startDay: serializer.fromJson<String>(json['startDay']),
      createdAtUtc: serializer.fromJson<int>(json['createdAtUtc']),
      archivedAtUtc: serializer.fromJson<int?>(json['archivedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'targetMinutes': serializer.toJson<int>(targetMinutes),
      'goalType': serializer.toJson<String>(goalType),
      'period': serializer.toJson<String>(period),
      'sections': serializer.toJson<int>(sections),
      'startDay': serializer.toJson<String>(startDay),
      'createdAtUtc': serializer.toJson<int>(createdAtUtc),
      'archivedAtUtc': serializer.toJson<int?>(archivedAtUtc),
    };
  }

  Goal copyWith({
    String? id,
    String? name,
    int? targetMinutes,
    String? goalType,
    String? period,
    int? sections,
    String? startDay,
    int? createdAtUtc,
    Value<int?> archivedAtUtc = const Value.absent(),
  }) => Goal(
    id: id ?? this.id,
    name: name ?? this.name,
    targetMinutes: targetMinutes ?? this.targetMinutes,
    goalType: goalType ?? this.goalType,
    period: period ?? this.period,
    sections: sections ?? this.sections,
    startDay: startDay ?? this.startDay,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
    archivedAtUtc: archivedAtUtc.present
        ? archivedAtUtc.value
        : this.archivedAtUtc,
  );
  Goal copyWithCompanion(GoalsCompanion data) {
    return Goal(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      targetMinutes: data.targetMinutes.present
          ? data.targetMinutes.value
          : this.targetMinutes,
      goalType: data.goalType.present ? data.goalType.value : this.goalType,
      period: data.period.present ? data.period.value : this.period,
      sections: data.sections.present ? data.sections.value : this.sections,
      startDay: data.startDay.present ? data.startDay.value : this.startDay,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
      archivedAtUtc: data.archivedAtUtc.present
          ? data.archivedAtUtc.value
          : this.archivedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Goal(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetMinutes: $targetMinutes, ')
          ..write('goalType: $goalType, ')
          ..write('period: $period, ')
          ..write('sections: $sections, ')
          ..write('startDay: $startDay, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('archivedAtUtc: $archivedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    targetMinutes,
    goalType,
    period,
    sections,
    startDay,
    createdAtUtc,
    archivedAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goal &&
          other.id == this.id &&
          other.name == this.name &&
          other.targetMinutes == this.targetMinutes &&
          other.goalType == this.goalType &&
          other.period == this.period &&
          other.sections == this.sections &&
          other.startDay == this.startDay &&
          other.createdAtUtc == this.createdAtUtc &&
          other.archivedAtUtc == this.archivedAtUtc);
}

class GoalsCompanion extends UpdateCompanion<Goal> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> targetMinutes;
  final Value<String> goalType;
  final Value<String> period;
  final Value<int> sections;
  final Value<String> startDay;
  final Value<int> createdAtUtc;
  final Value<int?> archivedAtUtc;
  final Value<int> rowid;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.targetMinutes = const Value.absent(),
    this.goalType = const Value.absent(),
    this.period = const Value.absent(),
    this.sections = const Value.absent(),
    this.startDay = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.archivedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsCompanion.insert({
    required String id,
    required String name,
    required int targetMinutes,
    this.goalType = const Value.absent(),
    required String period,
    this.sections = const Value.absent(),
    required String startDay,
    required int createdAtUtc,
    this.archivedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       targetMinutes = Value(targetMinutes),
       period = Value(period),
       startDay = Value(startDay),
       createdAtUtc = Value(createdAtUtc);
  static Insertable<Goal> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? targetMinutes,
    Expression<String>? goalType,
    Expression<String>? period,
    Expression<int>? sections,
    Expression<String>? startDay,
    Expression<int>? createdAtUtc,
    Expression<int>? archivedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (targetMinutes != null) 'target_minutes': targetMinutes,
      if (goalType != null) 'goal_type': goalType,
      if (period != null) 'period': period,
      if (sections != null) 'sections': sections,
      if (startDay != null) 'start_day': startDay,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (archivedAtUtc != null) 'archived_at_utc': archivedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? targetMinutes,
    Value<String>? goalType,
    Value<String>? period,
    Value<int>? sections,
    Value<String>? startDay,
    Value<int>? createdAtUtc,
    Value<int?>? archivedAtUtc,
    Value<int>? rowid,
  }) {
    return GoalsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      targetMinutes: targetMinutes ?? this.targetMinutes,
      goalType: goalType ?? this.goalType,
      period: period ?? this.period,
      sections: sections ?? this.sections,
      startDay: startDay ?? this.startDay,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      archivedAtUtc: archivedAtUtc ?? this.archivedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetMinutes.present) {
      map['target_minutes'] = Variable<int>(targetMinutes.value);
    }
    if (goalType.present) {
      map['goal_type'] = Variable<String>(goalType.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (sections.present) {
      map['sections'] = Variable<int>(sections.value);
    }
    if (startDay.present) {
      map['start_day'] = Variable<String>(startDay.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<int>(createdAtUtc.value);
    }
    if (archivedAtUtc.present) {
      map['archived_at_utc'] = Variable<int>(archivedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetMinutes: $targetMinutes, ')
          ..write('goalType: $goalType, ')
          ..write('period: $period, ')
          ..write('sections: $sections, ')
          ..write('startDay: $startDay, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('archivedAtUtc: $archivedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TimeLogsTable extends TimeLogs with TableInfo<$TimeLogsTable, TimeLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimeLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
    'goal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES goals (id)',
    ),
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<int> createdAtUtc = GeneratedColumn<int>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    goalId,
    durationMs,
    day,
    createdAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'time_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimeLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMsMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimeLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimeLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_id'],
      )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc'],
      )!,
    );
  }

  @override
  $TimeLogsTable createAlias(String alias) {
    return $TimeLogsTable(attachedDatabase, alias);
  }
}

class TimeLog extends DataClass implements Insertable<TimeLog> {
  final String id;
  final String goalId;
  final int durationMs;

  /// Local day ('yyyy-MM-dd') this time counts toward.
  final String day;
  final int createdAtUtc;
  const TimeLog({
    required this.id,
    required this.goalId,
    required this.durationMs,
    required this.day,
    required this.createdAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['goal_id'] = Variable<String>(goalId);
    map['duration_ms'] = Variable<int>(durationMs);
    map['day'] = Variable<String>(day);
    map['created_at_utc'] = Variable<int>(createdAtUtc);
    return map;
  }

  TimeLogsCompanion toCompanion(bool nullToAbsent) {
    return TimeLogsCompanion(
      id: Value(id),
      goalId: Value(goalId),
      durationMs: Value(durationMs),
      day: Value(day),
      createdAtUtc: Value(createdAtUtc),
    );
  }

  factory TimeLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimeLog(
      id: serializer.fromJson<String>(json['id']),
      goalId: serializer.fromJson<String>(json['goalId']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      day: serializer.fromJson<String>(json['day']),
      createdAtUtc: serializer.fromJson<int>(json['createdAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'goalId': serializer.toJson<String>(goalId),
      'durationMs': serializer.toJson<int>(durationMs),
      'day': serializer.toJson<String>(day),
      'createdAtUtc': serializer.toJson<int>(createdAtUtc),
    };
  }

  TimeLog copyWith({
    String? id,
    String? goalId,
    int? durationMs,
    String? day,
    int? createdAtUtc,
  }) => TimeLog(
    id: id ?? this.id,
    goalId: goalId ?? this.goalId,
    durationMs: durationMs ?? this.durationMs,
    day: day ?? this.day,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
  );
  TimeLog copyWithCompanion(TimeLogsCompanion data) {
    return TimeLog(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      day: data.day.present ? data.day.value : this.day,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimeLog(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('durationMs: $durationMs, ')
          ..write('day: $day, ')
          ..write('createdAtUtc: $createdAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, goalId, durationMs, day, createdAtUtc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimeLog &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.durationMs == this.durationMs &&
          other.day == this.day &&
          other.createdAtUtc == this.createdAtUtc);
}

class TimeLogsCompanion extends UpdateCompanion<TimeLog> {
  final Value<String> id;
  final Value<String> goalId;
  final Value<int> durationMs;
  final Value<String> day;
  final Value<int> createdAtUtc;
  final Value<int> rowid;
  const TimeLogsCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.day = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TimeLogsCompanion.insert({
    required String id,
    required String goalId,
    required int durationMs,
    required String day,
    required int createdAtUtc,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       goalId = Value(goalId),
       durationMs = Value(durationMs),
       day = Value(day),
       createdAtUtc = Value(createdAtUtc);
  static Insertable<TimeLog> custom({
    Expression<String>? id,
    Expression<String>? goalId,
    Expression<int>? durationMs,
    Expression<String>? day,
    Expression<int>? createdAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (durationMs != null) 'duration_ms': durationMs,
      if (day != null) 'day': day,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TimeLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? goalId,
    Value<int>? durationMs,
    Value<String>? day,
    Value<int>? createdAtUtc,
    Value<int>? rowid,
  }) {
    return TimeLogsCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      durationMs: durationMs ?? this.durationMs,
      day: day ?? this.day,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<int>(createdAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimeLogsCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('durationMs: $durationMs, ')
          ..write('day: $day, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActiveTimersTable extends ActiveTimers
    with TableInfo<$ActiveTimersTable, ActiveTimer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActiveTimersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
    'goal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES goals (id)',
    ),
  );
  static const VerificationMeta _isRunningMeta = const VerificationMeta(
    'isRunning',
  );
  @override
  late final GeneratedColumn<bool> isRunning = GeneratedColumn<bool>(
    'is_running',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_running" IN (0, 1))',
    ),
  );
  static const VerificationMeta _startedAtUtcMeta = const VerificationMeta(
    'startedAtUtc',
  );
  @override
  late final GeneratedColumn<int> startedAtUtc = GeneratedColumn<int>(
    'started_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastResumedAtUtcMeta = const VerificationMeta(
    'lastResumedAtUtc',
  );
  @override
  late final GeneratedColumn<int> lastResumedAtUtc = GeneratedColumn<int>(
    'last_resumed_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accumulatedMsMeta = const VerificationMeta(
    'accumulatedMs',
  );
  @override
  late final GeneratedColumn<int> accumulatedMs = GeneratedColumn<int>(
    'accumulated_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    goalId,
    isRunning,
    startedAtUtc,
    lastResumedAtUtc,
    accumulatedMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'active_timers';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActiveTimer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('is_running')) {
      context.handle(
        _isRunningMeta,
        isRunning.isAcceptableOrUnknown(data['is_running']!, _isRunningMeta),
      );
    } else if (isInserting) {
      context.missing(_isRunningMeta);
    }
    if (data.containsKey('started_at_utc')) {
      context.handle(
        _startedAtUtcMeta,
        startedAtUtc.isAcceptableOrUnknown(
          data['started_at_utc']!,
          _startedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startedAtUtcMeta);
    }
    if (data.containsKey('last_resumed_at_utc')) {
      context.handle(
        _lastResumedAtUtcMeta,
        lastResumedAtUtc.isAcceptableOrUnknown(
          data['last_resumed_at_utc']!,
          _lastResumedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('accumulated_ms')) {
      context.handle(
        _accumulatedMsMeta,
        accumulatedMs.isAcceptableOrUnknown(
          data['accumulated_ms']!,
          _accumulatedMsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {goalId};
  @override
  ActiveTimer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActiveTimer(
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_id'],
      )!,
      isRunning: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_running'],
      )!,
      startedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at_utc'],
      )!,
      lastResumedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_resumed_at_utc'],
      ),
      accumulatedMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}accumulated_ms'],
      )!,
    );
  }

  @override
  $ActiveTimersTable createAlias(String alias) {
    return $ActiveTimersTable(attachedDatabase, alias);
  }
}

class ActiveTimer extends DataClass implements Insertable<ActiveTimer> {
  final String goalId;
  final bool isRunning;
  final int startedAtUtc;

  /// Non-null exactly when [isRunning] is true.
  final int? lastResumedAtUtc;
  final int accumulatedMs;
  const ActiveTimer({
    required this.goalId,
    required this.isRunning,
    required this.startedAtUtc,
    this.lastResumedAtUtc,
    required this.accumulatedMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['goal_id'] = Variable<String>(goalId);
    map['is_running'] = Variable<bool>(isRunning);
    map['started_at_utc'] = Variable<int>(startedAtUtc);
    if (!nullToAbsent || lastResumedAtUtc != null) {
      map['last_resumed_at_utc'] = Variable<int>(lastResumedAtUtc);
    }
    map['accumulated_ms'] = Variable<int>(accumulatedMs);
    return map;
  }

  ActiveTimersCompanion toCompanion(bool nullToAbsent) {
    return ActiveTimersCompanion(
      goalId: Value(goalId),
      isRunning: Value(isRunning),
      startedAtUtc: Value(startedAtUtc),
      lastResumedAtUtc: lastResumedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(lastResumedAtUtc),
      accumulatedMs: Value(accumulatedMs),
    );
  }

  factory ActiveTimer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActiveTimer(
      goalId: serializer.fromJson<String>(json['goalId']),
      isRunning: serializer.fromJson<bool>(json['isRunning']),
      startedAtUtc: serializer.fromJson<int>(json['startedAtUtc']),
      lastResumedAtUtc: serializer.fromJson<int?>(json['lastResumedAtUtc']),
      accumulatedMs: serializer.fromJson<int>(json['accumulatedMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'goalId': serializer.toJson<String>(goalId),
      'isRunning': serializer.toJson<bool>(isRunning),
      'startedAtUtc': serializer.toJson<int>(startedAtUtc),
      'lastResumedAtUtc': serializer.toJson<int?>(lastResumedAtUtc),
      'accumulatedMs': serializer.toJson<int>(accumulatedMs),
    };
  }

  ActiveTimer copyWith({
    String? goalId,
    bool? isRunning,
    int? startedAtUtc,
    Value<int?> lastResumedAtUtc = const Value.absent(),
    int? accumulatedMs,
  }) => ActiveTimer(
    goalId: goalId ?? this.goalId,
    isRunning: isRunning ?? this.isRunning,
    startedAtUtc: startedAtUtc ?? this.startedAtUtc,
    lastResumedAtUtc: lastResumedAtUtc.present
        ? lastResumedAtUtc.value
        : this.lastResumedAtUtc,
    accumulatedMs: accumulatedMs ?? this.accumulatedMs,
  );
  ActiveTimer copyWithCompanion(ActiveTimersCompanion data) {
    return ActiveTimer(
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      isRunning: data.isRunning.present ? data.isRunning.value : this.isRunning,
      startedAtUtc: data.startedAtUtc.present
          ? data.startedAtUtc.value
          : this.startedAtUtc,
      lastResumedAtUtc: data.lastResumedAtUtc.present
          ? data.lastResumedAtUtc.value
          : this.lastResumedAtUtc,
      accumulatedMs: data.accumulatedMs.present
          ? data.accumulatedMs.value
          : this.accumulatedMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActiveTimer(')
          ..write('goalId: $goalId, ')
          ..write('isRunning: $isRunning, ')
          ..write('startedAtUtc: $startedAtUtc, ')
          ..write('lastResumedAtUtc: $lastResumedAtUtc, ')
          ..write('accumulatedMs: $accumulatedMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    goalId,
    isRunning,
    startedAtUtc,
    lastResumedAtUtc,
    accumulatedMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActiveTimer &&
          other.goalId == this.goalId &&
          other.isRunning == this.isRunning &&
          other.startedAtUtc == this.startedAtUtc &&
          other.lastResumedAtUtc == this.lastResumedAtUtc &&
          other.accumulatedMs == this.accumulatedMs);
}

class ActiveTimersCompanion extends UpdateCompanion<ActiveTimer> {
  final Value<String> goalId;
  final Value<bool> isRunning;
  final Value<int> startedAtUtc;
  final Value<int?> lastResumedAtUtc;
  final Value<int> accumulatedMs;
  final Value<int> rowid;
  const ActiveTimersCompanion({
    this.goalId = const Value.absent(),
    this.isRunning = const Value.absent(),
    this.startedAtUtc = const Value.absent(),
    this.lastResumedAtUtc = const Value.absent(),
    this.accumulatedMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActiveTimersCompanion.insert({
    required String goalId,
    required bool isRunning,
    required int startedAtUtc,
    this.lastResumedAtUtc = const Value.absent(),
    this.accumulatedMs = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : goalId = Value(goalId),
       isRunning = Value(isRunning),
       startedAtUtc = Value(startedAtUtc);
  static Insertable<ActiveTimer> custom({
    Expression<String>? goalId,
    Expression<bool>? isRunning,
    Expression<int>? startedAtUtc,
    Expression<int>? lastResumedAtUtc,
    Expression<int>? accumulatedMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (goalId != null) 'goal_id': goalId,
      if (isRunning != null) 'is_running': isRunning,
      if (startedAtUtc != null) 'started_at_utc': startedAtUtc,
      if (lastResumedAtUtc != null) 'last_resumed_at_utc': lastResumedAtUtc,
      if (accumulatedMs != null) 'accumulated_ms': accumulatedMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActiveTimersCompanion copyWith({
    Value<String>? goalId,
    Value<bool>? isRunning,
    Value<int>? startedAtUtc,
    Value<int?>? lastResumedAtUtc,
    Value<int>? accumulatedMs,
    Value<int>? rowid,
  }) {
    return ActiveTimersCompanion(
      goalId: goalId ?? this.goalId,
      isRunning: isRunning ?? this.isRunning,
      startedAtUtc: startedAtUtc ?? this.startedAtUtc,
      lastResumedAtUtc: lastResumedAtUtc ?? this.lastResumedAtUtc,
      accumulatedMs: accumulatedMs ?? this.accumulatedMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (isRunning.present) {
      map['is_running'] = Variable<bool>(isRunning.value);
    }
    if (startedAtUtc.present) {
      map['started_at_utc'] = Variable<int>(startedAtUtc.value);
    }
    if (lastResumedAtUtc.present) {
      map['last_resumed_at_utc'] = Variable<int>(lastResumedAtUtc.value);
    }
    if (accumulatedMs.present) {
      map['accumulated_ms'] = Variable<int>(accumulatedMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActiveTimersCompanion(')
          ..write('goalId: $goalId, ')
          ..write('isRunning: $isRunning, ')
          ..write('startedAtUtc: $startedAtUtc, ')
          ..write('lastResumedAtUtc: $lastResumedAtUtc, ')
          ..write('accumulatedMs: $accumulatedMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $TimeLogsTable timeLogs = $TimeLogsTable(this);
  late final $ActiveTimersTable activeTimers = $ActiveTimersTable(this);
  late final Index timeLogsGoalDay = Index(
    'time_logs_goal_day',
    'CREATE INDEX time_logs_goal_day ON time_logs (goal_id, day)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    goals,
    timeLogs,
    activeTimers,
    timeLogsGoalDay,
  ];
}

typedef $$GoalsTableCreateCompanionBuilder =
    GoalsCompanion Function({
      required String id,
      required String name,
      required int targetMinutes,
      Value<String> goalType,
      required String period,
      Value<int> sections,
      required String startDay,
      required int createdAtUtc,
      Value<int?> archivedAtUtc,
      Value<int> rowid,
    });
typedef $$GoalsTableUpdateCompanionBuilder =
    GoalsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> targetMinutes,
      Value<String> goalType,
      Value<String> period,
      Value<int> sections,
      Value<String> startDay,
      Value<int> createdAtUtc,
      Value<int?> archivedAtUtc,
      Value<int> rowid,
    });

final class $$GoalsTableReferences
    extends BaseReferences<_$AppDatabase, $GoalsTable, Goal> {
  $$GoalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TimeLogsTable, List<TimeLog>> _timeLogsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.timeLogs,
    aliasName: 'goals__id__time_logs__goal_id',
  );

  $$TimeLogsTableProcessedTableManager get timeLogsRefs {
    final manager = $$TimeLogsTableTableManager(
      $_db,
      $_db.timeLogs,
    ).filter((f) => f.goalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_timeLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ActiveTimersTable, List<ActiveTimer>>
  _activeTimersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.activeTimers,
    aliasName: 'goals__id__active_timers__goal_id',
  );

  $$ActiveTimersTableProcessedTableManager get activeTimersRefs {
    final manager = $$ActiveTimersTableTableManager(
      $_db,
      $_db.activeTimers,
    ).filter((f) => f.goalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_activeTimersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GoalsTableFilterComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetMinutes => $composableBuilder(
    column: $table.targetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sections => $composableBuilder(
    column: $table.sections,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDay => $composableBuilder(
    column: $table.startDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get archivedAtUtc => $composableBuilder(
    column: $table.archivedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> timeLogsRefs(
    Expression<bool> Function($$TimeLogsTableFilterComposer f) f,
  ) {
    final $$TimeLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeLogs,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeLogsTableFilterComposer(
            $db: $db,
            $table: $db.timeLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> activeTimersRefs(
    Expression<bool> Function($$ActiveTimersTableFilterComposer f) f,
  ) {
    final $$ActiveTimersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activeTimers,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActiveTimersTableFilterComposer(
            $db: $db,
            $table: $db.activeTimers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetMinutes => $composableBuilder(
    column: $table.targetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sections => $composableBuilder(
    column: $table.sections,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDay => $composableBuilder(
    column: $table.startDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get archivedAtUtc => $composableBuilder(
    column: $table.archivedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get targetMinutes => $composableBuilder(
    column: $table.targetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goalType =>
      $composableBuilder(column: $table.goalType, builder: (column) => column);

  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<int> get sections =>
      $composableBuilder(column: $table.sections, builder: (column) => column);

  GeneratedColumn<String> get startDay =>
      $composableBuilder(column: $table.startDay, builder: (column) => column);

  GeneratedColumn<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get archivedAtUtc => $composableBuilder(
    column: $table.archivedAtUtc,
    builder: (column) => column,
  );

  Expression<T> timeLogsRefs<T extends Object>(
    Expression<T> Function($$TimeLogsTableAnnotationComposer a) f,
  ) {
    final $$TimeLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeLogs,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.timeLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> activeTimersRefs<T extends Object>(
    Expression<T> Function($$ActiveTimersTableAnnotationComposer a) f,
  ) {
    final $$ActiveTimersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activeTimers,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActiveTimersTableAnnotationComposer(
            $db: $db,
            $table: $db.activeTimers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalsTable,
          Goal,
          $$GoalsTableFilterComposer,
          $$GoalsTableOrderingComposer,
          $$GoalsTableAnnotationComposer,
          $$GoalsTableCreateCompanionBuilder,
          $$GoalsTableUpdateCompanionBuilder,
          (Goal, $$GoalsTableReferences),
          Goal,
          PrefetchHooks Function({bool timeLogsRefs, bool activeTimersRefs})
        > {
  $$GoalsTableTableManager(_$AppDatabase db, $GoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> targetMinutes = const Value.absent(),
                Value<String> goalType = const Value.absent(),
                Value<String> period = const Value.absent(),
                Value<int> sections = const Value.absent(),
                Value<String> startDay = const Value.absent(),
                Value<int> createdAtUtc = const Value.absent(),
                Value<int?> archivedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion(
                id: id,
                name: name,
                targetMinutes: targetMinutes,
                goalType: goalType,
                period: period,
                sections: sections,
                startDay: startDay,
                createdAtUtc: createdAtUtc,
                archivedAtUtc: archivedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int targetMinutes,
                Value<String> goalType = const Value.absent(),
                required String period,
                Value<int> sections = const Value.absent(),
                required String startDay,
                required int createdAtUtc,
                Value<int?> archivedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion.insert(
                id: id,
                name: name,
                targetMinutes: targetMinutes,
                goalType: goalType,
                period: period,
                sections: sections,
                startDay: startDay,
                createdAtUtc: createdAtUtc,
                archivedAtUtc: archivedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GoalsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({timeLogsRefs = false, activeTimersRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (timeLogsRefs) db.timeLogs,
                    if (activeTimersRefs) db.activeTimers,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (timeLogsRefs)
                        await $_getPrefetchedData<Goal, $GoalsTable, TimeLog>(
                          currentTable: table,
                          referencedTable: $$GoalsTableReferences
                              ._timeLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GoalsTableReferences(
                                db,
                                table,
                                p0,
                              ).timeLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.goalId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (activeTimersRefs)
                        await $_getPrefetchedData<
                          Goal,
                          $GoalsTable,
                          ActiveTimer
                        >(
                          currentTable: table,
                          referencedTable: $$GoalsTableReferences
                              ._activeTimersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GoalsTableReferences(
                                db,
                                table,
                                p0,
                              ).activeTimersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.goalId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalsTable,
      Goal,
      $$GoalsTableFilterComposer,
      $$GoalsTableOrderingComposer,
      $$GoalsTableAnnotationComposer,
      $$GoalsTableCreateCompanionBuilder,
      $$GoalsTableUpdateCompanionBuilder,
      (Goal, $$GoalsTableReferences),
      Goal,
      PrefetchHooks Function({bool timeLogsRefs, bool activeTimersRefs})
    >;
typedef $$TimeLogsTableCreateCompanionBuilder =
    TimeLogsCompanion Function({
      required String id,
      required String goalId,
      required int durationMs,
      required String day,
      required int createdAtUtc,
      Value<int> rowid,
    });
typedef $$TimeLogsTableUpdateCompanionBuilder =
    TimeLogsCompanion Function({
      Value<String> id,
      Value<String> goalId,
      Value<int> durationMs,
      Value<String> day,
      Value<int> createdAtUtc,
      Value<int> rowid,
    });

final class $$TimeLogsTableReferences
    extends BaseReferences<_$AppDatabase, $TimeLogsTable, TimeLog> {
  $$TimeLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GoalsTable _goalIdTable(_$AppDatabase db) =>
      db.goals.createAlias('time_logs__goal_id__goals__id');

  $$GoalsTableProcessedTableManager get goalId {
    final $_column = $_itemColumn<String>('goal_id')!;

    final manager = $$GoalsTableTableManager(
      $_db,
      $_db.goals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TimeLogsTableFilterComposer
    extends Composer<_$AppDatabase, $TimeLogsTable> {
  $$TimeLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  $$GoalsTableFilterComposer get goalId {
    final $$GoalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableFilterComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimeLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $TimeLogsTable> {
  $$TimeLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  $$GoalsTableOrderingComposer get goalId {
    final $$GoalsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableOrderingComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimeLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimeLogsTable> {
  $$TimeLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  $$GoalsTableAnnotationComposer get goalId {
    final $$GoalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableAnnotationComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimeLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TimeLogsTable,
          TimeLog,
          $$TimeLogsTableFilterComposer,
          $$TimeLogsTableOrderingComposer,
          $$TimeLogsTableAnnotationComposer,
          $$TimeLogsTableCreateCompanionBuilder,
          $$TimeLogsTableUpdateCompanionBuilder,
          (TimeLog, $$TimeLogsTableReferences),
          TimeLog,
          PrefetchHooks Function({bool goalId})
        > {
  $$TimeLogsTableTableManager(_$AppDatabase db, $TimeLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimeLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimeLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimeLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> goalId = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<String> day = const Value.absent(),
                Value<int> createdAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TimeLogsCompanion(
                id: id,
                goalId: goalId,
                durationMs: durationMs,
                day: day,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String goalId,
                required int durationMs,
                required String day,
                required int createdAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => TimeLogsCompanion.insert(
                id: id,
                goalId: goalId,
                durationMs: durationMs,
                day: day,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TimeLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({goalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (goalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.goalId,
                                referencedTable: $$TimeLogsTableReferences
                                    ._goalIdTable(db),
                                referencedColumn: $$TimeLogsTableReferences
                                    ._goalIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TimeLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TimeLogsTable,
      TimeLog,
      $$TimeLogsTableFilterComposer,
      $$TimeLogsTableOrderingComposer,
      $$TimeLogsTableAnnotationComposer,
      $$TimeLogsTableCreateCompanionBuilder,
      $$TimeLogsTableUpdateCompanionBuilder,
      (TimeLog, $$TimeLogsTableReferences),
      TimeLog,
      PrefetchHooks Function({bool goalId})
    >;
typedef $$ActiveTimersTableCreateCompanionBuilder =
    ActiveTimersCompanion Function({
      required String goalId,
      required bool isRunning,
      required int startedAtUtc,
      Value<int?> lastResumedAtUtc,
      Value<int> accumulatedMs,
      Value<int> rowid,
    });
typedef $$ActiveTimersTableUpdateCompanionBuilder =
    ActiveTimersCompanion Function({
      Value<String> goalId,
      Value<bool> isRunning,
      Value<int> startedAtUtc,
      Value<int?> lastResumedAtUtc,
      Value<int> accumulatedMs,
      Value<int> rowid,
    });

final class $$ActiveTimersTableReferences
    extends BaseReferences<_$AppDatabase, $ActiveTimersTable, ActiveTimer> {
  $$ActiveTimersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GoalsTable _goalIdTable(_$AppDatabase db) =>
      db.goals.createAlias('active_timers__goal_id__goals__id');

  $$GoalsTableProcessedTableManager get goalId {
    final $_column = $_itemColumn<String>('goal_id')!;

    final manager = $$GoalsTableTableManager(
      $_db,
      $_db.goals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ActiveTimersTableFilterComposer
    extends Composer<_$AppDatabase, $ActiveTimersTable> {
  $$ActiveTimersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<bool> get isRunning => $composableBuilder(
    column: $table.isRunning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAtUtc => $composableBuilder(
    column: $table.startedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastResumedAtUtc => $composableBuilder(
    column: $table.lastResumedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accumulatedMs => $composableBuilder(
    column: $table.accumulatedMs,
    builder: (column) => ColumnFilters(column),
  );

  $$GoalsTableFilterComposer get goalId {
    final $$GoalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableFilterComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActiveTimersTableOrderingComposer
    extends Composer<_$AppDatabase, $ActiveTimersTable> {
  $$ActiveTimersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<bool> get isRunning => $composableBuilder(
    column: $table.isRunning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAtUtc => $composableBuilder(
    column: $table.startedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastResumedAtUtc => $composableBuilder(
    column: $table.lastResumedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accumulatedMs => $composableBuilder(
    column: $table.accumulatedMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$GoalsTableOrderingComposer get goalId {
    final $$GoalsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableOrderingComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActiveTimersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActiveTimersTable> {
  $$ActiveTimersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<bool> get isRunning =>
      $composableBuilder(column: $table.isRunning, builder: (column) => column);

  GeneratedColumn<int> get startedAtUtc => $composableBuilder(
    column: $table.startedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastResumedAtUtc => $composableBuilder(
    column: $table.lastResumedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get accumulatedMs => $composableBuilder(
    column: $table.accumulatedMs,
    builder: (column) => column,
  );

  $$GoalsTableAnnotationComposer get goalId {
    final $$GoalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableAnnotationComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActiveTimersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActiveTimersTable,
          ActiveTimer,
          $$ActiveTimersTableFilterComposer,
          $$ActiveTimersTableOrderingComposer,
          $$ActiveTimersTableAnnotationComposer,
          $$ActiveTimersTableCreateCompanionBuilder,
          $$ActiveTimersTableUpdateCompanionBuilder,
          (ActiveTimer, $$ActiveTimersTableReferences),
          ActiveTimer,
          PrefetchHooks Function({bool goalId})
        > {
  $$ActiveTimersTableTableManager(_$AppDatabase db, $ActiveTimersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActiveTimersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActiveTimersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActiveTimersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> goalId = const Value.absent(),
                Value<bool> isRunning = const Value.absent(),
                Value<int> startedAtUtc = const Value.absent(),
                Value<int?> lastResumedAtUtc = const Value.absent(),
                Value<int> accumulatedMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActiveTimersCompanion(
                goalId: goalId,
                isRunning: isRunning,
                startedAtUtc: startedAtUtc,
                lastResumedAtUtc: lastResumedAtUtc,
                accumulatedMs: accumulatedMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String goalId,
                required bool isRunning,
                required int startedAtUtc,
                Value<int?> lastResumedAtUtc = const Value.absent(),
                Value<int> accumulatedMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActiveTimersCompanion.insert(
                goalId: goalId,
                isRunning: isRunning,
                startedAtUtc: startedAtUtc,
                lastResumedAtUtc: lastResumedAtUtc,
                accumulatedMs: accumulatedMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActiveTimersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({goalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (goalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.goalId,
                                referencedTable: $$ActiveTimersTableReferences
                                    ._goalIdTable(db),
                                referencedColumn: $$ActiveTimersTableReferences
                                    ._goalIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ActiveTimersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActiveTimersTable,
      ActiveTimer,
      $$ActiveTimersTableFilterComposer,
      $$ActiveTimersTableOrderingComposer,
      $$ActiveTimersTableAnnotationComposer,
      $$ActiveTimersTableCreateCompanionBuilder,
      $$ActiveTimersTableUpdateCompanionBuilder,
      (ActiveTimer, $$ActiveTimersTableReferences),
      ActiveTimer,
      PrefetchHooks Function({bool goalId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$TimeLogsTableTableManager get timeLogs =>
      $$TimeLogsTableTableManager(_db, _db.timeLogs);
  $$ActiveTimersTableTableManager get activeTimers =>
      $$ActiveTimersTableTableManager(_db, _db.activeTimers);
}

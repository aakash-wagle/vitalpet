// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CheckInsTable extends CheckIns with TableInfo<$CheckInsTable, CheckIn> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CheckInsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _utcDateMeta = const VerificationMeta(
    'utcDate',
  );
  @override
  late final GeneratedColumn<String> utcDate = GeneratedColumn<String>(
    'utc_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wellnessScoreMeta = const VerificationMeta(
    'wellnessScore',
  );
  @override
  late final GeneratedColumn<int> wellnessScore = GeneratedColumn<int>(
    'wellness_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<int> mode = GeneratedColumn<int>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _depthScoreMeta = const VerificationMeta(
    'depthScore',
  );
  @override
  late final GeneratedColumn<double> depthScore = GeneratedColumn<double>(
    'depth_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _isPartialMeta = const VerificationMeta(
    'isPartial',
  );
  @override
  late final GeneratedColumn<bool> isPartial = GeneratedColumn<bool>(
    'is_partial',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_partial" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _amendedAtMeta = const VerificationMeta(
    'amendedAt',
  );
  @override
  late final GeneratedColumn<String> amendedAt = GeneratedColumn<String>(
    'amended_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    utcDate,
    localDate,
    wellnessScore,
    mode,
    depthScore,
    isPartial,
    amendedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'check_ins';
  @override
  VerificationContext validateIntegrity(
    Insertable<CheckIn> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('utc_date')) {
      context.handle(
        _utcDateMeta,
        utcDate.isAcceptableOrUnknown(data['utc_date']!, _utcDateMeta),
      );
    } else if (isInserting) {
      context.missing(_utcDateMeta);
    }
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('wellness_score')) {
      context.handle(
        _wellnessScoreMeta,
        wellnessScore.isAcceptableOrUnknown(
          data['wellness_score']!,
          _wellnessScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_wellnessScoreMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('depth_score')) {
      context.handle(
        _depthScoreMeta,
        depthScore.isAcceptableOrUnknown(data['depth_score']!, _depthScoreMeta),
      );
    }
    if (data.containsKey('is_partial')) {
      context.handle(
        _isPartialMeta,
        isPartial.isAcceptableOrUnknown(data['is_partial']!, _isPartialMeta),
      );
    }
    if (data.containsKey('amended_at')) {
      context.handle(
        _amendedAtMeta,
        amendedAt.isAcceptableOrUnknown(data['amended_at']!, _amendedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CheckIn map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CheckIn(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      utcDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}utc_date'],
      )!,
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_date'],
      )!,
      wellnessScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wellness_score'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mode'],
      )!,
      depthScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}depth_score'],
      )!,
      isPartial: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_partial'],
      )!,
      amendedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}amended_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CheckInsTable createAlias(String alias) {
    return $CheckInsTable(attachedDatabase, alias);
  }
}

class CheckIn extends DataClass implements Insertable<CheckIn> {
  final String id;
  final String utcDate;
  final String localDate;
  final int wellnessScore;
  final int mode;
  final double depthScore;
  final bool isPartial;
  final String? amendedAt;
  final String createdAt;
  const CheckIn({
    required this.id,
    required this.utcDate,
    required this.localDate,
    required this.wellnessScore,
    required this.mode,
    required this.depthScore,
    required this.isPartial,
    this.amendedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['utc_date'] = Variable<String>(utcDate);
    map['local_date'] = Variable<String>(localDate);
    map['wellness_score'] = Variable<int>(wellnessScore);
    map['mode'] = Variable<int>(mode);
    map['depth_score'] = Variable<double>(depthScore);
    map['is_partial'] = Variable<bool>(isPartial);
    if (!nullToAbsent || amendedAt != null) {
      map['amended_at'] = Variable<String>(amendedAt);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  CheckInsCompanion toCompanion(bool nullToAbsent) {
    return CheckInsCompanion(
      id: Value(id),
      utcDate: Value(utcDate),
      localDate: Value(localDate),
      wellnessScore: Value(wellnessScore),
      mode: Value(mode),
      depthScore: Value(depthScore),
      isPartial: Value(isPartial),
      amendedAt: amendedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(amendedAt),
      createdAt: Value(createdAt),
    );
  }

  factory CheckIn.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CheckIn(
      id: serializer.fromJson<String>(json['id']),
      utcDate: serializer.fromJson<String>(json['utcDate']),
      localDate: serializer.fromJson<String>(json['localDate']),
      wellnessScore: serializer.fromJson<int>(json['wellnessScore']),
      mode: serializer.fromJson<int>(json['mode']),
      depthScore: serializer.fromJson<double>(json['depthScore']),
      isPartial: serializer.fromJson<bool>(json['isPartial']),
      amendedAt: serializer.fromJson<String?>(json['amendedAt']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'utcDate': serializer.toJson<String>(utcDate),
      'localDate': serializer.toJson<String>(localDate),
      'wellnessScore': serializer.toJson<int>(wellnessScore),
      'mode': serializer.toJson<int>(mode),
      'depthScore': serializer.toJson<double>(depthScore),
      'isPartial': serializer.toJson<bool>(isPartial),
      'amendedAt': serializer.toJson<String?>(amendedAt),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  CheckIn copyWith({
    String? id,
    String? utcDate,
    String? localDate,
    int? wellnessScore,
    int? mode,
    double? depthScore,
    bool? isPartial,
    Value<String?> amendedAt = const Value.absent(),
    String? createdAt,
  }) => CheckIn(
    id: id ?? this.id,
    utcDate: utcDate ?? this.utcDate,
    localDate: localDate ?? this.localDate,
    wellnessScore: wellnessScore ?? this.wellnessScore,
    mode: mode ?? this.mode,
    depthScore: depthScore ?? this.depthScore,
    isPartial: isPartial ?? this.isPartial,
    amendedAt: amendedAt.present ? amendedAt.value : this.amendedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  CheckIn copyWithCompanion(CheckInsCompanion data) {
    return CheckIn(
      id: data.id.present ? data.id.value : this.id,
      utcDate: data.utcDate.present ? data.utcDate.value : this.utcDate,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      wellnessScore: data.wellnessScore.present
          ? data.wellnessScore.value
          : this.wellnessScore,
      mode: data.mode.present ? data.mode.value : this.mode,
      depthScore: data.depthScore.present
          ? data.depthScore.value
          : this.depthScore,
      isPartial: data.isPartial.present ? data.isPartial.value : this.isPartial,
      amendedAt: data.amendedAt.present ? data.amendedAt.value : this.amendedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CheckIn(')
          ..write('id: $id, ')
          ..write('utcDate: $utcDate, ')
          ..write('localDate: $localDate, ')
          ..write('wellnessScore: $wellnessScore, ')
          ..write('mode: $mode, ')
          ..write('depthScore: $depthScore, ')
          ..write('isPartial: $isPartial, ')
          ..write('amendedAt: $amendedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    utcDate,
    localDate,
    wellnessScore,
    mode,
    depthScore,
    isPartial,
    amendedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CheckIn &&
          other.id == this.id &&
          other.utcDate == this.utcDate &&
          other.localDate == this.localDate &&
          other.wellnessScore == this.wellnessScore &&
          other.mode == this.mode &&
          other.depthScore == this.depthScore &&
          other.isPartial == this.isPartial &&
          other.amendedAt == this.amendedAt &&
          other.createdAt == this.createdAt);
}

class CheckInsCompanion extends UpdateCompanion<CheckIn> {
  final Value<String> id;
  final Value<String> utcDate;
  final Value<String> localDate;
  final Value<int> wellnessScore;
  final Value<int> mode;
  final Value<double> depthScore;
  final Value<bool> isPartial;
  final Value<String?> amendedAt;
  final Value<String> createdAt;
  final Value<int> rowid;
  const CheckInsCompanion({
    this.id = const Value.absent(),
    this.utcDate = const Value.absent(),
    this.localDate = const Value.absent(),
    this.wellnessScore = const Value.absent(),
    this.mode = const Value.absent(),
    this.depthScore = const Value.absent(),
    this.isPartial = const Value.absent(),
    this.amendedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CheckInsCompanion.insert({
    required String id,
    required String utcDate,
    required String localDate,
    required int wellnessScore,
    required int mode,
    this.depthScore = const Value.absent(),
    this.isPartial = const Value.absent(),
    this.amendedAt = const Value.absent(),
    required String createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       utcDate = Value(utcDate),
       localDate = Value(localDate),
       wellnessScore = Value(wellnessScore),
       mode = Value(mode),
       createdAt = Value(createdAt);
  static Insertable<CheckIn> custom({
    Expression<String>? id,
    Expression<String>? utcDate,
    Expression<String>? localDate,
    Expression<int>? wellnessScore,
    Expression<int>? mode,
    Expression<double>? depthScore,
    Expression<bool>? isPartial,
    Expression<String>? amendedAt,
    Expression<String>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (utcDate != null) 'utc_date': utcDate,
      if (localDate != null) 'local_date': localDate,
      if (wellnessScore != null) 'wellness_score': wellnessScore,
      if (mode != null) 'mode': mode,
      if (depthScore != null) 'depth_score': depthScore,
      if (isPartial != null) 'is_partial': isPartial,
      if (amendedAt != null) 'amended_at': amendedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CheckInsCompanion copyWith({
    Value<String>? id,
    Value<String>? utcDate,
    Value<String>? localDate,
    Value<int>? wellnessScore,
    Value<int>? mode,
    Value<double>? depthScore,
    Value<bool>? isPartial,
    Value<String?>? amendedAt,
    Value<String>? createdAt,
    Value<int>? rowid,
  }) {
    return CheckInsCompanion(
      id: id ?? this.id,
      utcDate: utcDate ?? this.utcDate,
      localDate: localDate ?? this.localDate,
      wellnessScore: wellnessScore ?? this.wellnessScore,
      mode: mode ?? this.mode,
      depthScore: depthScore ?? this.depthScore,
      isPartial: isPartial ?? this.isPartial,
      amendedAt: amendedAt ?? this.amendedAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (utcDate.present) {
      map['utc_date'] = Variable<String>(utcDate.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (wellnessScore.present) {
      map['wellness_score'] = Variable<int>(wellnessScore.value);
    }
    if (mode.present) {
      map['mode'] = Variable<int>(mode.value);
    }
    if (depthScore.present) {
      map['depth_score'] = Variable<double>(depthScore.value);
    }
    if (isPartial.present) {
      map['is_partial'] = Variable<bool>(isPartial.value);
    }
    if (amendedAt.present) {
      map['amended_at'] = Variable<String>(amendedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CheckInsCompanion(')
          ..write('id: $id, ')
          ..write('utcDate: $utcDate, ')
          ..write('localDate: $localDate, ')
          ..write('wellnessScore: $wellnessScore, ')
          ..write('mode: $mode, ')
          ..write('depthScore: $depthScore, ')
          ..write('isPartial: $isPartial, ')
          ..write('amendedAt: $amendedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CheckInSymptomsTable extends CheckInSymptoms
    with TableInfo<$CheckInSymptomsTable, CheckInSymptom> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CheckInSymptomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkInIdMeta = const VerificationMeta(
    'checkInId',
  );
  @override
  late final GeneratedColumn<String> checkInId = GeneratedColumn<String>(
    'check_in_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES check_ins (id)',
    ),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _onsetDayMeta = const VerificationMeta(
    'onsetDay',
  );
  @override
  late final GeneratedColumn<int> onsetDay = GeneratedColumn<int>(
    'onset_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _patternMeta = const VerificationMeta(
    'pattern',
  );
  @override
  late final GeneratedColumn<String> pattern = GeneratedColumn<String>(
    'pattern',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    checkInId,
    category,
    onsetDay,
    pattern,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'check_in_symptoms';
  @override
  VerificationContext validateIntegrity(
    Insertable<CheckInSymptom> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('check_in_id')) {
      context.handle(
        _checkInIdMeta,
        checkInId.isAcceptableOrUnknown(data['check_in_id']!, _checkInIdMeta),
      );
    } else if (isInserting) {
      context.missing(_checkInIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('onset_day')) {
      context.handle(
        _onsetDayMeta,
        onsetDay.isAcceptableOrUnknown(data['onset_day']!, _onsetDayMeta),
      );
    }
    if (data.containsKey('pattern')) {
      context.handle(
        _patternMeta,
        pattern.isAcceptableOrUnknown(data['pattern']!, _patternMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CheckInSymptom map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CheckInSymptom(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      checkInId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}check_in_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      onsetDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}onset_day'],
      ),
      pattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pattern'],
      ),
    );
  }

  @override
  $CheckInSymptomsTable createAlias(String alias) {
    return $CheckInSymptomsTable(attachedDatabase, alias);
  }
}

class CheckInSymptom extends DataClass implements Insertable<CheckInSymptom> {
  final String id;
  final String checkInId;
  final String category;
  final int? onsetDay;
  final String? pattern;
  const CheckInSymptom({
    required this.id,
    required this.checkInId,
    required this.category,
    this.onsetDay,
    this.pattern,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['check_in_id'] = Variable<String>(checkInId);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || onsetDay != null) {
      map['onset_day'] = Variable<int>(onsetDay);
    }
    if (!nullToAbsent || pattern != null) {
      map['pattern'] = Variable<String>(pattern);
    }
    return map;
  }

  CheckInSymptomsCompanion toCompanion(bool nullToAbsent) {
    return CheckInSymptomsCompanion(
      id: Value(id),
      checkInId: Value(checkInId),
      category: Value(category),
      onsetDay: onsetDay == null && nullToAbsent
          ? const Value.absent()
          : Value(onsetDay),
      pattern: pattern == null && nullToAbsent
          ? const Value.absent()
          : Value(pattern),
    );
  }

  factory CheckInSymptom.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CheckInSymptom(
      id: serializer.fromJson<String>(json['id']),
      checkInId: serializer.fromJson<String>(json['checkInId']),
      category: serializer.fromJson<String>(json['category']),
      onsetDay: serializer.fromJson<int?>(json['onsetDay']),
      pattern: serializer.fromJson<String?>(json['pattern']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'checkInId': serializer.toJson<String>(checkInId),
      'category': serializer.toJson<String>(category),
      'onsetDay': serializer.toJson<int?>(onsetDay),
      'pattern': serializer.toJson<String?>(pattern),
    };
  }

  CheckInSymptom copyWith({
    String? id,
    String? checkInId,
    String? category,
    Value<int?> onsetDay = const Value.absent(),
    Value<String?> pattern = const Value.absent(),
  }) => CheckInSymptom(
    id: id ?? this.id,
    checkInId: checkInId ?? this.checkInId,
    category: category ?? this.category,
    onsetDay: onsetDay.present ? onsetDay.value : this.onsetDay,
    pattern: pattern.present ? pattern.value : this.pattern,
  );
  CheckInSymptom copyWithCompanion(CheckInSymptomsCompanion data) {
    return CheckInSymptom(
      id: data.id.present ? data.id.value : this.id,
      checkInId: data.checkInId.present ? data.checkInId.value : this.checkInId,
      category: data.category.present ? data.category.value : this.category,
      onsetDay: data.onsetDay.present ? data.onsetDay.value : this.onsetDay,
      pattern: data.pattern.present ? data.pattern.value : this.pattern,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CheckInSymptom(')
          ..write('id: $id, ')
          ..write('checkInId: $checkInId, ')
          ..write('category: $category, ')
          ..write('onsetDay: $onsetDay, ')
          ..write('pattern: $pattern')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, checkInId, category, onsetDay, pattern);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CheckInSymptom &&
          other.id == this.id &&
          other.checkInId == this.checkInId &&
          other.category == this.category &&
          other.onsetDay == this.onsetDay &&
          other.pattern == this.pattern);
}

class CheckInSymptomsCompanion extends UpdateCompanion<CheckInSymptom> {
  final Value<String> id;
  final Value<String> checkInId;
  final Value<String> category;
  final Value<int?> onsetDay;
  final Value<String?> pattern;
  final Value<int> rowid;
  const CheckInSymptomsCompanion({
    this.id = const Value.absent(),
    this.checkInId = const Value.absent(),
    this.category = const Value.absent(),
    this.onsetDay = const Value.absent(),
    this.pattern = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CheckInSymptomsCompanion.insert({
    required String id,
    required String checkInId,
    required String category,
    this.onsetDay = const Value.absent(),
    this.pattern = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       checkInId = Value(checkInId),
       category = Value(category);
  static Insertable<CheckInSymptom> custom({
    Expression<String>? id,
    Expression<String>? checkInId,
    Expression<String>? category,
    Expression<int>? onsetDay,
    Expression<String>? pattern,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (checkInId != null) 'check_in_id': checkInId,
      if (category != null) 'category': category,
      if (onsetDay != null) 'onset_day': onsetDay,
      if (pattern != null) 'pattern': pattern,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CheckInSymptomsCompanion copyWith({
    Value<String>? id,
    Value<String>? checkInId,
    Value<String>? category,
    Value<int?>? onsetDay,
    Value<String?>? pattern,
    Value<int>? rowid,
  }) {
    return CheckInSymptomsCompanion(
      id: id ?? this.id,
      checkInId: checkInId ?? this.checkInId,
      category: category ?? this.category,
      onsetDay: onsetDay ?? this.onsetDay,
      pattern: pattern ?? this.pattern,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (checkInId.present) {
      map['check_in_id'] = Variable<String>(checkInId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (onsetDay.present) {
      map['onset_day'] = Variable<int>(onsetDay.value);
    }
    if (pattern.present) {
      map['pattern'] = Variable<String>(pattern.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CheckInSymptomsCompanion(')
          ..write('id: $id, ')
          ..write('checkInId: $checkInId, ')
          ..write('category: $category, ')
          ..write('onsetDay: $onsetDay, ')
          ..write('pattern: $pattern, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SymptomFeverTable extends SymptomFever
    with TableInfo<$SymptomFeverTable, SymptomFeverData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SymptomFeverTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _symptomIdMeta = const VerificationMeta(
    'symptomId',
  );
  @override
  late final GeneratedColumn<String> symptomId = GeneratedColumn<String>(
    'symptom_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES check_in_symptoms (id)',
    ),
  );
  static const VerificationMeta _temperatureMeta = const VerificationMeta(
    'temperature',
  );
  @override
  late final GeneratedColumn<double> temperature = GeneratedColumn<double>(
    'temperature',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _skippedMeta = const VerificationMeta(
    'skipped',
  );
  @override
  late final GeneratedColumn<bool> skipped = GeneratedColumn<bool>(
    'skipped',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("skipped" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    symptomId,
    temperature,
    unit,
    method,
    skipped,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'symptom_fever';
  @override
  VerificationContext validateIntegrity(
    Insertable<SymptomFeverData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('symptom_id')) {
      context.handle(
        _symptomIdMeta,
        symptomId.isAcceptableOrUnknown(data['symptom_id']!, _symptomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_symptomIdMeta);
    }
    if (data.containsKey('temperature')) {
      context.handle(
        _temperatureMeta,
        temperature.isAcceptableOrUnknown(
          data['temperature']!,
          _temperatureMeta,
        ),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    }
    if (data.containsKey('skipped')) {
      context.handle(
        _skippedMeta,
        skipped.isAcceptableOrUnknown(data['skipped']!, _skippedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {symptomId};
  @override
  SymptomFeverData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SymptomFeverData(
      symptomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptom_id'],
      )!,
      temperature: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temperature'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      ),
      skipped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}skipped'],
      )!,
    );
  }

  @override
  $SymptomFeverTable createAlias(String alias) {
    return $SymptomFeverTable(attachedDatabase, alias);
  }
}

class SymptomFeverData extends DataClass
    implements Insertable<SymptomFeverData> {
  final String symptomId;
  final double? temperature;
  final String? unit;
  final String? method;
  final bool skipped;
  const SymptomFeverData({
    required this.symptomId,
    this.temperature,
    this.unit,
    this.method,
    required this.skipped,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['symptom_id'] = Variable<String>(symptomId);
    if (!nullToAbsent || temperature != null) {
      map['temperature'] = Variable<double>(temperature);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || method != null) {
      map['method'] = Variable<String>(method);
    }
    map['skipped'] = Variable<bool>(skipped);
    return map;
  }

  SymptomFeverCompanion toCompanion(bool nullToAbsent) {
    return SymptomFeverCompanion(
      symptomId: Value(symptomId),
      temperature: temperature == null && nullToAbsent
          ? const Value.absent()
          : Value(temperature),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      method: method == null && nullToAbsent
          ? const Value.absent()
          : Value(method),
      skipped: Value(skipped),
    );
  }

  factory SymptomFeverData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SymptomFeverData(
      symptomId: serializer.fromJson<String>(json['symptomId']),
      temperature: serializer.fromJson<double?>(json['temperature']),
      unit: serializer.fromJson<String?>(json['unit']),
      method: serializer.fromJson<String?>(json['method']),
      skipped: serializer.fromJson<bool>(json['skipped']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'symptomId': serializer.toJson<String>(symptomId),
      'temperature': serializer.toJson<double?>(temperature),
      'unit': serializer.toJson<String?>(unit),
      'method': serializer.toJson<String?>(method),
      'skipped': serializer.toJson<bool>(skipped),
    };
  }

  SymptomFeverData copyWith({
    String? symptomId,
    Value<double?> temperature = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    Value<String?> method = const Value.absent(),
    bool? skipped,
  }) => SymptomFeverData(
    symptomId: symptomId ?? this.symptomId,
    temperature: temperature.present ? temperature.value : this.temperature,
    unit: unit.present ? unit.value : this.unit,
    method: method.present ? method.value : this.method,
    skipped: skipped ?? this.skipped,
  );
  SymptomFeverData copyWithCompanion(SymptomFeverCompanion data) {
    return SymptomFeverData(
      symptomId: data.symptomId.present ? data.symptomId.value : this.symptomId,
      temperature: data.temperature.present
          ? data.temperature.value
          : this.temperature,
      unit: data.unit.present ? data.unit.value : this.unit,
      method: data.method.present ? data.method.value : this.method,
      skipped: data.skipped.present ? data.skipped.value : this.skipped,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SymptomFeverData(')
          ..write('symptomId: $symptomId, ')
          ..write('temperature: $temperature, ')
          ..write('unit: $unit, ')
          ..write('method: $method, ')
          ..write('skipped: $skipped')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(symptomId, temperature, unit, method, skipped);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SymptomFeverData &&
          other.symptomId == this.symptomId &&
          other.temperature == this.temperature &&
          other.unit == this.unit &&
          other.method == this.method &&
          other.skipped == this.skipped);
}

class SymptomFeverCompanion extends UpdateCompanion<SymptomFeverData> {
  final Value<String> symptomId;
  final Value<double?> temperature;
  final Value<String?> unit;
  final Value<String?> method;
  final Value<bool> skipped;
  final Value<int> rowid;
  const SymptomFeverCompanion({
    this.symptomId = const Value.absent(),
    this.temperature = const Value.absent(),
    this.unit = const Value.absent(),
    this.method = const Value.absent(),
    this.skipped = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SymptomFeverCompanion.insert({
    required String symptomId,
    this.temperature = const Value.absent(),
    this.unit = const Value.absent(),
    this.method = const Value.absent(),
    this.skipped = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : symptomId = Value(symptomId);
  static Insertable<SymptomFeverData> custom({
    Expression<String>? symptomId,
    Expression<double>? temperature,
    Expression<String>? unit,
    Expression<String>? method,
    Expression<bool>? skipped,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (symptomId != null) 'symptom_id': symptomId,
      if (temperature != null) 'temperature': temperature,
      if (unit != null) 'unit': unit,
      if (method != null) 'method': method,
      if (skipped != null) 'skipped': skipped,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SymptomFeverCompanion copyWith({
    Value<String>? symptomId,
    Value<double?>? temperature,
    Value<String?>? unit,
    Value<String?>? method,
    Value<bool>? skipped,
    Value<int>? rowid,
  }) {
    return SymptomFeverCompanion(
      symptomId: symptomId ?? this.symptomId,
      temperature: temperature ?? this.temperature,
      unit: unit ?? this.unit,
      method: method ?? this.method,
      skipped: skipped ?? this.skipped,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (symptomId.present) {
      map['symptom_id'] = Variable<String>(symptomId.value);
    }
    if (temperature.present) {
      map['temperature'] = Variable<double>(temperature.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (skipped.present) {
      map['skipped'] = Variable<bool>(skipped.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SymptomFeverCompanion(')
          ..write('symptomId: $symptomId, ')
          ..write('temperature: $temperature, ')
          ..write('unit: $unit, ')
          ..write('method: $method, ')
          ..write('skipped: $skipped, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SymptomPainTable extends SymptomPain
    with TableInfo<$SymptomPainTable, SymptomPainData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SymptomPainTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _symptomIdMeta = const VerificationMeta(
    'symptomId',
  );
  @override
  late final GeneratedColumn<String> symptomId = GeneratedColumn<String>(
    'symptom_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES check_in_symptoms (id)',
    ),
  );
  static const VerificationMeta _regionsJsonMeta = const VerificationMeta(
    'regionsJson',
  );
  @override
  late final GeneratedColumn<String> regionsJson = GeneratedColumn<String>(
    'regions_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _triggersJsonMeta = const VerificationMeta(
    'triggersJson',
  );
  @override
  late final GeneratedColumn<String> triggersJson = GeneratedColumn<String>(
    'triggers_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    symptomId,
    regionsJson,
    type,
    triggersJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'symptom_pain';
  @override
  VerificationContext validateIntegrity(
    Insertable<SymptomPainData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('symptom_id')) {
      context.handle(
        _symptomIdMeta,
        symptomId.isAcceptableOrUnknown(data['symptom_id']!, _symptomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_symptomIdMeta);
    }
    if (data.containsKey('regions_json')) {
      context.handle(
        _regionsJsonMeta,
        regionsJson.isAcceptableOrUnknown(
          data['regions_json']!,
          _regionsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_regionsJsonMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('triggers_json')) {
      context.handle(
        _triggersJsonMeta,
        triggersJson.isAcceptableOrUnknown(
          data['triggers_json']!,
          _triggersJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {symptomId};
  @override
  SymptomPainData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SymptomPainData(
      symptomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptom_id'],
      )!,
      regionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}regions_json'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      triggersJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}triggers_json'],
      ),
    );
  }

  @override
  $SymptomPainTable createAlias(String alias) {
    return $SymptomPainTable(attachedDatabase, alias);
  }
}

class SymptomPainData extends DataClass implements Insertable<SymptomPainData> {
  final String symptomId;
  final String regionsJson;
  final String type;
  final String? triggersJson;
  const SymptomPainData({
    required this.symptomId,
    required this.regionsJson,
    required this.type,
    this.triggersJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['symptom_id'] = Variable<String>(symptomId);
    map['regions_json'] = Variable<String>(regionsJson);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || triggersJson != null) {
      map['triggers_json'] = Variable<String>(triggersJson);
    }
    return map;
  }

  SymptomPainCompanion toCompanion(bool nullToAbsent) {
    return SymptomPainCompanion(
      symptomId: Value(symptomId),
      regionsJson: Value(regionsJson),
      type: Value(type),
      triggersJson: triggersJson == null && nullToAbsent
          ? const Value.absent()
          : Value(triggersJson),
    );
  }

  factory SymptomPainData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SymptomPainData(
      symptomId: serializer.fromJson<String>(json['symptomId']),
      regionsJson: serializer.fromJson<String>(json['regionsJson']),
      type: serializer.fromJson<String>(json['type']),
      triggersJson: serializer.fromJson<String?>(json['triggersJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'symptomId': serializer.toJson<String>(symptomId),
      'regionsJson': serializer.toJson<String>(regionsJson),
      'type': serializer.toJson<String>(type),
      'triggersJson': serializer.toJson<String?>(triggersJson),
    };
  }

  SymptomPainData copyWith({
    String? symptomId,
    String? regionsJson,
    String? type,
    Value<String?> triggersJson = const Value.absent(),
  }) => SymptomPainData(
    symptomId: symptomId ?? this.symptomId,
    regionsJson: regionsJson ?? this.regionsJson,
    type: type ?? this.type,
    triggersJson: triggersJson.present ? triggersJson.value : this.triggersJson,
  );
  SymptomPainData copyWithCompanion(SymptomPainCompanion data) {
    return SymptomPainData(
      symptomId: data.symptomId.present ? data.symptomId.value : this.symptomId,
      regionsJson: data.regionsJson.present
          ? data.regionsJson.value
          : this.regionsJson,
      type: data.type.present ? data.type.value : this.type,
      triggersJson: data.triggersJson.present
          ? data.triggersJson.value
          : this.triggersJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SymptomPainData(')
          ..write('symptomId: $symptomId, ')
          ..write('regionsJson: $regionsJson, ')
          ..write('type: $type, ')
          ..write('triggersJson: $triggersJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(symptomId, regionsJson, type, triggersJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SymptomPainData &&
          other.symptomId == this.symptomId &&
          other.regionsJson == this.regionsJson &&
          other.type == this.type &&
          other.triggersJson == this.triggersJson);
}

class SymptomPainCompanion extends UpdateCompanion<SymptomPainData> {
  final Value<String> symptomId;
  final Value<String> regionsJson;
  final Value<String> type;
  final Value<String?> triggersJson;
  final Value<int> rowid;
  const SymptomPainCompanion({
    this.symptomId = const Value.absent(),
    this.regionsJson = const Value.absent(),
    this.type = const Value.absent(),
    this.triggersJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SymptomPainCompanion.insert({
    required String symptomId,
    required String regionsJson,
    required String type,
    this.triggersJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : symptomId = Value(symptomId),
       regionsJson = Value(regionsJson),
       type = Value(type);
  static Insertable<SymptomPainData> custom({
    Expression<String>? symptomId,
    Expression<String>? regionsJson,
    Expression<String>? type,
    Expression<String>? triggersJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (symptomId != null) 'symptom_id': symptomId,
      if (regionsJson != null) 'regions_json': regionsJson,
      if (type != null) 'type': type,
      if (triggersJson != null) 'triggers_json': triggersJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SymptomPainCompanion copyWith({
    Value<String>? symptomId,
    Value<String>? regionsJson,
    Value<String>? type,
    Value<String?>? triggersJson,
    Value<int>? rowid,
  }) {
    return SymptomPainCompanion(
      symptomId: symptomId ?? this.symptomId,
      regionsJson: regionsJson ?? this.regionsJson,
      type: type ?? this.type,
      triggersJson: triggersJson ?? this.triggersJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (symptomId.present) {
      map['symptom_id'] = Variable<String>(symptomId.value);
    }
    if (regionsJson.present) {
      map['regions_json'] = Variable<String>(regionsJson.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (triggersJson.present) {
      map['triggers_json'] = Variable<String>(triggersJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SymptomPainCompanion(')
          ..write('symptomId: $symptomId, ')
          ..write('regionsJson: $regionsJson, ')
          ..write('type: $type, ')
          ..write('triggersJson: $triggersJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SymptomFatigueTable extends SymptomFatigue
    with TableInfo<$SymptomFatigueTable, SymptomFatigueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SymptomFatigueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _symptomIdMeta = const VerificationMeta(
    'symptomId',
  );
  @override
  late final GeneratedColumn<String> symptomId = GeneratedColumn<String>(
    'symptom_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES check_in_symptoms (id)',
    ),
  );
  static const VerificationMeta _scopeMeta = const VerificationMeta('scope');
  @override
  late final GeneratedColumn<String> scope = GeneratedColumn<String>(
    'scope',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _blocksDailyMeta = const VerificationMeta(
    'blocksDaily',
  );
  @override
  late final GeneratedColumn<bool> blocksDaily = GeneratedColumn<bool>(
    'blocks_daily',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("blocks_daily" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [symptomId, scope, blocksDaily];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'symptom_fatigue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SymptomFatigueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('symptom_id')) {
      context.handle(
        _symptomIdMeta,
        symptomId.isAcceptableOrUnknown(data['symptom_id']!, _symptomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_symptomIdMeta);
    }
    if (data.containsKey('scope')) {
      context.handle(
        _scopeMeta,
        scope.isAcceptableOrUnknown(data['scope']!, _scopeMeta),
      );
    } else if (isInserting) {
      context.missing(_scopeMeta);
    }
    if (data.containsKey('blocks_daily')) {
      context.handle(
        _blocksDailyMeta,
        blocksDaily.isAcceptableOrUnknown(
          data['blocks_daily']!,
          _blocksDailyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_blocksDailyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {symptomId};
  @override
  SymptomFatigueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SymptomFatigueData(
      symptomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptom_id'],
      )!,
      scope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope'],
      )!,
      blocksDaily: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}blocks_daily'],
      )!,
    );
  }

  @override
  $SymptomFatigueTable createAlias(String alias) {
    return $SymptomFatigueTable(attachedDatabase, alias);
  }
}

class SymptomFatigueData extends DataClass
    implements Insertable<SymptomFatigueData> {
  final String symptomId;
  final String scope;
  final bool blocksDaily;
  const SymptomFatigueData({
    required this.symptomId,
    required this.scope,
    required this.blocksDaily,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['symptom_id'] = Variable<String>(symptomId);
    map['scope'] = Variable<String>(scope);
    map['blocks_daily'] = Variable<bool>(blocksDaily);
    return map;
  }

  SymptomFatigueCompanion toCompanion(bool nullToAbsent) {
    return SymptomFatigueCompanion(
      symptomId: Value(symptomId),
      scope: Value(scope),
      blocksDaily: Value(blocksDaily),
    );
  }

  factory SymptomFatigueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SymptomFatigueData(
      symptomId: serializer.fromJson<String>(json['symptomId']),
      scope: serializer.fromJson<String>(json['scope']),
      blocksDaily: serializer.fromJson<bool>(json['blocksDaily']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'symptomId': serializer.toJson<String>(symptomId),
      'scope': serializer.toJson<String>(scope),
      'blocksDaily': serializer.toJson<bool>(blocksDaily),
    };
  }

  SymptomFatigueData copyWith({
    String? symptomId,
    String? scope,
    bool? blocksDaily,
  }) => SymptomFatigueData(
    symptomId: symptomId ?? this.symptomId,
    scope: scope ?? this.scope,
    blocksDaily: blocksDaily ?? this.blocksDaily,
  );
  SymptomFatigueData copyWithCompanion(SymptomFatigueCompanion data) {
    return SymptomFatigueData(
      symptomId: data.symptomId.present ? data.symptomId.value : this.symptomId,
      scope: data.scope.present ? data.scope.value : this.scope,
      blocksDaily: data.blocksDaily.present
          ? data.blocksDaily.value
          : this.blocksDaily,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SymptomFatigueData(')
          ..write('symptomId: $symptomId, ')
          ..write('scope: $scope, ')
          ..write('blocksDaily: $blocksDaily')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(symptomId, scope, blocksDaily);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SymptomFatigueData &&
          other.symptomId == this.symptomId &&
          other.scope == this.scope &&
          other.blocksDaily == this.blocksDaily);
}

class SymptomFatigueCompanion extends UpdateCompanion<SymptomFatigueData> {
  final Value<String> symptomId;
  final Value<String> scope;
  final Value<bool> blocksDaily;
  final Value<int> rowid;
  const SymptomFatigueCompanion({
    this.symptomId = const Value.absent(),
    this.scope = const Value.absent(),
    this.blocksDaily = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SymptomFatigueCompanion.insert({
    required String symptomId,
    required String scope,
    required bool blocksDaily,
    this.rowid = const Value.absent(),
  }) : symptomId = Value(symptomId),
       scope = Value(scope),
       blocksDaily = Value(blocksDaily);
  static Insertable<SymptomFatigueData> custom({
    Expression<String>? symptomId,
    Expression<String>? scope,
    Expression<bool>? blocksDaily,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (symptomId != null) 'symptom_id': symptomId,
      if (scope != null) 'scope': scope,
      if (blocksDaily != null) 'blocks_daily': blocksDaily,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SymptomFatigueCompanion copyWith({
    Value<String>? symptomId,
    Value<String>? scope,
    Value<bool>? blocksDaily,
    Value<int>? rowid,
  }) {
    return SymptomFatigueCompanion(
      symptomId: symptomId ?? this.symptomId,
      scope: scope ?? this.scope,
      blocksDaily: blocksDaily ?? this.blocksDaily,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (symptomId.present) {
      map['symptom_id'] = Variable<String>(symptomId.value);
    }
    if (scope.present) {
      map['scope'] = Variable<String>(scope.value);
    }
    if (blocksDaily.present) {
      map['blocks_daily'] = Variable<bool>(blocksDaily.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SymptomFatigueCompanion(')
          ..write('symptomId: $symptomId, ')
          ..write('scope: $scope, ')
          ..write('blocksDaily: $blocksDaily, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SymptomNauseaTable extends SymptomNausea
    with TableInfo<$SymptomNauseaTable, SymptomNauseaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SymptomNauseaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _symptomIdMeta = const VerificationMeta(
    'symptomId',
  );
  @override
  late final GeneratedColumn<String> symptomId = GeneratedColumn<String>(
    'symptom_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES check_in_symptoms (id)',
    ),
  );
  static const VerificationMeta _vomitingMeta = const VerificationMeta(
    'vomiting',
  );
  @override
  late final GeneratedColumn<bool> vomiting = GeneratedColumn<bool>(
    'vomiting',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("vomiting" IN (0, 1))',
    ),
  );
  static const VerificationMeta _vomitFreqMeta = const VerificationMeta(
    'vomitFreq',
  );
  @override
  late final GeneratedColumn<String> vomitFreq = GeneratedColumn<String>(
    'vomit_freq',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _appetiteMeta = const VerificationMeta(
    'appetite',
  );
  @override
  late final GeneratedColumn<String> appetite = GeneratedColumn<String>(
    'appetite',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dehydrationSignsJsonMeta =
      const VerificationMeta('dehydrationSignsJson');
  @override
  late final GeneratedColumn<String> dehydrationSignsJson =
      GeneratedColumn<String>(
        'dehydration_signs_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    symptomId,
    vomiting,
    vomitFreq,
    appetite,
    dehydrationSignsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'symptom_nausea';
  @override
  VerificationContext validateIntegrity(
    Insertable<SymptomNauseaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('symptom_id')) {
      context.handle(
        _symptomIdMeta,
        symptomId.isAcceptableOrUnknown(data['symptom_id']!, _symptomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_symptomIdMeta);
    }
    if (data.containsKey('vomiting')) {
      context.handle(
        _vomitingMeta,
        vomiting.isAcceptableOrUnknown(data['vomiting']!, _vomitingMeta),
      );
    } else if (isInserting) {
      context.missing(_vomitingMeta);
    }
    if (data.containsKey('vomit_freq')) {
      context.handle(
        _vomitFreqMeta,
        vomitFreq.isAcceptableOrUnknown(data['vomit_freq']!, _vomitFreqMeta),
      );
    }
    if (data.containsKey('appetite')) {
      context.handle(
        _appetiteMeta,
        appetite.isAcceptableOrUnknown(data['appetite']!, _appetiteMeta),
      );
    } else if (isInserting) {
      context.missing(_appetiteMeta);
    }
    if (data.containsKey('dehydration_signs_json')) {
      context.handle(
        _dehydrationSignsJsonMeta,
        dehydrationSignsJson.isAcceptableOrUnknown(
          data['dehydration_signs_json']!,
          _dehydrationSignsJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {symptomId};
  @override
  SymptomNauseaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SymptomNauseaData(
      symptomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptom_id'],
      )!,
      vomiting: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}vomiting'],
      )!,
      vomitFreq: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vomit_freq'],
      ),
      appetite: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}appetite'],
      )!,
      dehydrationSignsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dehydration_signs_json'],
      ),
    );
  }

  @override
  $SymptomNauseaTable createAlias(String alias) {
    return $SymptomNauseaTable(attachedDatabase, alias);
  }
}

class SymptomNauseaData extends DataClass
    implements Insertable<SymptomNauseaData> {
  final String symptomId;
  final bool vomiting;
  final String? vomitFreq;
  final String appetite;
  final String? dehydrationSignsJson;
  const SymptomNauseaData({
    required this.symptomId,
    required this.vomiting,
    this.vomitFreq,
    required this.appetite,
    this.dehydrationSignsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['symptom_id'] = Variable<String>(symptomId);
    map['vomiting'] = Variable<bool>(vomiting);
    if (!nullToAbsent || vomitFreq != null) {
      map['vomit_freq'] = Variable<String>(vomitFreq);
    }
    map['appetite'] = Variable<String>(appetite);
    if (!nullToAbsent || dehydrationSignsJson != null) {
      map['dehydration_signs_json'] = Variable<String>(dehydrationSignsJson);
    }
    return map;
  }

  SymptomNauseaCompanion toCompanion(bool nullToAbsent) {
    return SymptomNauseaCompanion(
      symptomId: Value(symptomId),
      vomiting: Value(vomiting),
      vomitFreq: vomitFreq == null && nullToAbsent
          ? const Value.absent()
          : Value(vomitFreq),
      appetite: Value(appetite),
      dehydrationSignsJson: dehydrationSignsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(dehydrationSignsJson),
    );
  }

  factory SymptomNauseaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SymptomNauseaData(
      symptomId: serializer.fromJson<String>(json['symptomId']),
      vomiting: serializer.fromJson<bool>(json['vomiting']),
      vomitFreq: serializer.fromJson<String?>(json['vomitFreq']),
      appetite: serializer.fromJson<String>(json['appetite']),
      dehydrationSignsJson: serializer.fromJson<String?>(
        json['dehydrationSignsJson'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'symptomId': serializer.toJson<String>(symptomId),
      'vomiting': serializer.toJson<bool>(vomiting),
      'vomitFreq': serializer.toJson<String?>(vomitFreq),
      'appetite': serializer.toJson<String>(appetite),
      'dehydrationSignsJson': serializer.toJson<String?>(dehydrationSignsJson),
    };
  }

  SymptomNauseaData copyWith({
    String? symptomId,
    bool? vomiting,
    Value<String?> vomitFreq = const Value.absent(),
    String? appetite,
    Value<String?> dehydrationSignsJson = const Value.absent(),
  }) => SymptomNauseaData(
    symptomId: symptomId ?? this.symptomId,
    vomiting: vomiting ?? this.vomiting,
    vomitFreq: vomitFreq.present ? vomitFreq.value : this.vomitFreq,
    appetite: appetite ?? this.appetite,
    dehydrationSignsJson: dehydrationSignsJson.present
        ? dehydrationSignsJson.value
        : this.dehydrationSignsJson,
  );
  SymptomNauseaData copyWithCompanion(SymptomNauseaCompanion data) {
    return SymptomNauseaData(
      symptomId: data.symptomId.present ? data.symptomId.value : this.symptomId,
      vomiting: data.vomiting.present ? data.vomiting.value : this.vomiting,
      vomitFreq: data.vomitFreq.present ? data.vomitFreq.value : this.vomitFreq,
      appetite: data.appetite.present ? data.appetite.value : this.appetite,
      dehydrationSignsJson: data.dehydrationSignsJson.present
          ? data.dehydrationSignsJson.value
          : this.dehydrationSignsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SymptomNauseaData(')
          ..write('symptomId: $symptomId, ')
          ..write('vomiting: $vomiting, ')
          ..write('vomitFreq: $vomitFreq, ')
          ..write('appetite: $appetite, ')
          ..write('dehydrationSignsJson: $dehydrationSignsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    symptomId,
    vomiting,
    vomitFreq,
    appetite,
    dehydrationSignsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SymptomNauseaData &&
          other.symptomId == this.symptomId &&
          other.vomiting == this.vomiting &&
          other.vomitFreq == this.vomitFreq &&
          other.appetite == this.appetite &&
          other.dehydrationSignsJson == this.dehydrationSignsJson);
}

class SymptomNauseaCompanion extends UpdateCompanion<SymptomNauseaData> {
  final Value<String> symptomId;
  final Value<bool> vomiting;
  final Value<String?> vomitFreq;
  final Value<String> appetite;
  final Value<String?> dehydrationSignsJson;
  final Value<int> rowid;
  const SymptomNauseaCompanion({
    this.symptomId = const Value.absent(),
    this.vomiting = const Value.absent(),
    this.vomitFreq = const Value.absent(),
    this.appetite = const Value.absent(),
    this.dehydrationSignsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SymptomNauseaCompanion.insert({
    required String symptomId,
    required bool vomiting,
    this.vomitFreq = const Value.absent(),
    required String appetite,
    this.dehydrationSignsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : symptomId = Value(symptomId),
       vomiting = Value(vomiting),
       appetite = Value(appetite);
  static Insertable<SymptomNauseaData> custom({
    Expression<String>? symptomId,
    Expression<bool>? vomiting,
    Expression<String>? vomitFreq,
    Expression<String>? appetite,
    Expression<String>? dehydrationSignsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (symptomId != null) 'symptom_id': symptomId,
      if (vomiting != null) 'vomiting': vomiting,
      if (vomitFreq != null) 'vomit_freq': vomitFreq,
      if (appetite != null) 'appetite': appetite,
      if (dehydrationSignsJson != null)
        'dehydration_signs_json': dehydrationSignsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SymptomNauseaCompanion copyWith({
    Value<String>? symptomId,
    Value<bool>? vomiting,
    Value<String?>? vomitFreq,
    Value<String>? appetite,
    Value<String?>? dehydrationSignsJson,
    Value<int>? rowid,
  }) {
    return SymptomNauseaCompanion(
      symptomId: symptomId ?? this.symptomId,
      vomiting: vomiting ?? this.vomiting,
      vomitFreq: vomitFreq ?? this.vomitFreq,
      appetite: appetite ?? this.appetite,
      dehydrationSignsJson: dehydrationSignsJson ?? this.dehydrationSignsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (symptomId.present) {
      map['symptom_id'] = Variable<String>(symptomId.value);
    }
    if (vomiting.present) {
      map['vomiting'] = Variable<bool>(vomiting.value);
    }
    if (vomitFreq.present) {
      map['vomit_freq'] = Variable<String>(vomitFreq.value);
    }
    if (appetite.present) {
      map['appetite'] = Variable<String>(appetite.value);
    }
    if (dehydrationSignsJson.present) {
      map['dehydration_signs_json'] = Variable<String>(
        dehydrationSignsJson.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SymptomNauseaCompanion(')
          ..write('symptomId: $symptomId, ')
          ..write('vomiting: $vomiting, ')
          ..write('vomitFreq: $vomitFreq, ')
          ..write('appetite: $appetite, ')
          ..write('dehydrationSignsJson: $dehydrationSignsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SymptomOtherTable extends SymptomOther
    with TableInfo<$SymptomOtherTable, SymptomOtherData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SymptomOtherTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _symptomIdMeta = const VerificationMeta(
    'symptomId',
  );
  @override
  late final GeneratedColumn<String> symptomId = GeneratedColumn<String>(
    'symptom_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES check_in_symptoms (id)',
    ),
  );
  static const VerificationMeta _freeTextMeta = const VerificationMeta(
    'freeText',
  );
  @override
  late final GeneratedColumn<String> freeText = GeneratedColumn<String>(
    'free_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extractedDetailsJsonMeta =
      const VerificationMeta('extractedDetailsJson');
  @override
  late final GeneratedColumn<String> extractedDetailsJson =
      GeneratedColumn<String>(
        'extracted_details_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    symptomId,
    freeText,
    extractedDetailsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'symptom_other';
  @override
  VerificationContext validateIntegrity(
    Insertable<SymptomOtherData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('symptom_id')) {
      context.handle(
        _symptomIdMeta,
        symptomId.isAcceptableOrUnknown(data['symptom_id']!, _symptomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_symptomIdMeta);
    }
    if (data.containsKey('free_text')) {
      context.handle(
        _freeTextMeta,
        freeText.isAcceptableOrUnknown(data['free_text']!, _freeTextMeta),
      );
    } else if (isInserting) {
      context.missing(_freeTextMeta);
    }
    if (data.containsKey('extracted_details_json')) {
      context.handle(
        _extractedDetailsJsonMeta,
        extractedDetailsJson.isAcceptableOrUnknown(
          data['extracted_details_json']!,
          _extractedDetailsJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {symptomId};
  @override
  SymptomOtherData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SymptomOtherData(
      symptomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptom_id'],
      )!,
      freeText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}free_text'],
      )!,
      extractedDetailsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extracted_details_json'],
      ),
    );
  }

  @override
  $SymptomOtherTable createAlias(String alias) {
    return $SymptomOtherTable(attachedDatabase, alias);
  }
}

class SymptomOtherData extends DataClass
    implements Insertable<SymptomOtherData> {
  final String symptomId;
  final String freeText;
  final String? extractedDetailsJson;
  const SymptomOtherData({
    required this.symptomId,
    required this.freeText,
    this.extractedDetailsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['symptom_id'] = Variable<String>(symptomId);
    map['free_text'] = Variable<String>(freeText);
    if (!nullToAbsent || extractedDetailsJson != null) {
      map['extracted_details_json'] = Variable<String>(extractedDetailsJson);
    }
    return map;
  }

  SymptomOtherCompanion toCompanion(bool nullToAbsent) {
    return SymptomOtherCompanion(
      symptomId: Value(symptomId),
      freeText: Value(freeText),
      extractedDetailsJson: extractedDetailsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(extractedDetailsJson),
    );
  }

  factory SymptomOtherData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SymptomOtherData(
      symptomId: serializer.fromJson<String>(json['symptomId']),
      freeText: serializer.fromJson<String>(json['freeText']),
      extractedDetailsJson: serializer.fromJson<String?>(
        json['extractedDetailsJson'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'symptomId': serializer.toJson<String>(symptomId),
      'freeText': serializer.toJson<String>(freeText),
      'extractedDetailsJson': serializer.toJson<String?>(extractedDetailsJson),
    };
  }

  SymptomOtherData copyWith({
    String? symptomId,
    String? freeText,
    Value<String?> extractedDetailsJson = const Value.absent(),
  }) => SymptomOtherData(
    symptomId: symptomId ?? this.symptomId,
    freeText: freeText ?? this.freeText,
    extractedDetailsJson: extractedDetailsJson.present
        ? extractedDetailsJson.value
        : this.extractedDetailsJson,
  );
  SymptomOtherData copyWithCompanion(SymptomOtherCompanion data) {
    return SymptomOtherData(
      symptomId: data.symptomId.present ? data.symptomId.value : this.symptomId,
      freeText: data.freeText.present ? data.freeText.value : this.freeText,
      extractedDetailsJson: data.extractedDetailsJson.present
          ? data.extractedDetailsJson.value
          : this.extractedDetailsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SymptomOtherData(')
          ..write('symptomId: $symptomId, ')
          ..write('freeText: $freeText, ')
          ..write('extractedDetailsJson: $extractedDetailsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(symptomId, freeText, extractedDetailsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SymptomOtherData &&
          other.symptomId == this.symptomId &&
          other.freeText == this.freeText &&
          other.extractedDetailsJson == this.extractedDetailsJson);
}

class SymptomOtherCompanion extends UpdateCompanion<SymptomOtherData> {
  final Value<String> symptomId;
  final Value<String> freeText;
  final Value<String?> extractedDetailsJson;
  final Value<int> rowid;
  const SymptomOtherCompanion({
    this.symptomId = const Value.absent(),
    this.freeText = const Value.absent(),
    this.extractedDetailsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SymptomOtherCompanion.insert({
    required String symptomId,
    required String freeText,
    this.extractedDetailsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : symptomId = Value(symptomId),
       freeText = Value(freeText);
  static Insertable<SymptomOtherData> custom({
    Expression<String>? symptomId,
    Expression<String>? freeText,
    Expression<String>? extractedDetailsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (symptomId != null) 'symptom_id': symptomId,
      if (freeText != null) 'free_text': freeText,
      if (extractedDetailsJson != null)
        'extracted_details_json': extractedDetailsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SymptomOtherCompanion copyWith({
    Value<String>? symptomId,
    Value<String>? freeText,
    Value<String?>? extractedDetailsJson,
    Value<int>? rowid,
  }) {
    return SymptomOtherCompanion(
      symptomId: symptomId ?? this.symptomId,
      freeText: freeText ?? this.freeText,
      extractedDetailsJson: extractedDetailsJson ?? this.extractedDetailsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (symptomId.present) {
      map['symptom_id'] = Variable<String>(symptomId.value);
    }
    if (freeText.present) {
      map['free_text'] = Variable<String>(freeText.value);
    }
    if (extractedDetailsJson.present) {
      map['extracted_details_json'] = Variable<String>(
        extractedDetailsJson.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SymptomOtherCompanion(')
          ..write('symptomId: $symptomId, ')
          ..write('freeText: $freeText, ')
          ..write('extractedDetailsJson: $extractedDetailsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CheckInSubjectiveTable extends CheckInSubjective
    with TableInfo<$CheckInSubjectiveTable, CheckInSubjectiveData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CheckInSubjectiveTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _checkInIdMeta = const VerificationMeta(
    'checkInId',
  );
  @override
  late final GeneratedColumn<String> checkInId = GeneratedColumn<String>(
    'check_in_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES check_ins (id)',
    ),
  );
  static const VerificationMeta _freeNotesMeta = const VerificationMeta(
    'freeNotes',
  );
  @override
  late final GeneratedColumn<String> freeNotes = GeneratedColumn<String>(
    'free_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _slmTagsJsonMeta = const VerificationMeta(
    'slmTagsJson',
  );
  @override
  late final GeneratedColumn<String> slmTagsJson = GeneratedColumn<String>(
    'slm_tags_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _followUpExchangesJsonMeta =
      const VerificationMeta('followUpExchangesJson');
  @override
  late final GeneratedColumn<String> followUpExchangesJson =
      GeneratedColumn<String>(
        'follow_up_exchanges_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    checkInId,
    freeNotes,
    slmTagsJson,
    followUpExchangesJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'check_in_subjective';
  @override
  VerificationContext validateIntegrity(
    Insertable<CheckInSubjectiveData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('check_in_id')) {
      context.handle(
        _checkInIdMeta,
        checkInId.isAcceptableOrUnknown(data['check_in_id']!, _checkInIdMeta),
      );
    } else if (isInserting) {
      context.missing(_checkInIdMeta);
    }
    if (data.containsKey('free_notes')) {
      context.handle(
        _freeNotesMeta,
        freeNotes.isAcceptableOrUnknown(data['free_notes']!, _freeNotesMeta),
      );
    }
    if (data.containsKey('slm_tags_json')) {
      context.handle(
        _slmTagsJsonMeta,
        slmTagsJson.isAcceptableOrUnknown(
          data['slm_tags_json']!,
          _slmTagsJsonMeta,
        ),
      );
    }
    if (data.containsKey('follow_up_exchanges_json')) {
      context.handle(
        _followUpExchangesJsonMeta,
        followUpExchangesJson.isAcceptableOrUnknown(
          data['follow_up_exchanges_json']!,
          _followUpExchangesJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {checkInId};
  @override
  CheckInSubjectiveData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CheckInSubjectiveData(
      checkInId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}check_in_id'],
      )!,
      freeNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}free_notes'],
      ),
      slmTagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slm_tags_json'],
      ),
      followUpExchangesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}follow_up_exchanges_json'],
      ),
    );
  }

  @override
  $CheckInSubjectiveTable createAlias(String alias) {
    return $CheckInSubjectiveTable(attachedDatabase, alias);
  }
}

class CheckInSubjectiveData extends DataClass
    implements Insertable<CheckInSubjectiveData> {
  final String checkInId;
  final String? freeNotes;
  final String? slmTagsJson;
  final String? followUpExchangesJson;
  const CheckInSubjectiveData({
    required this.checkInId,
    this.freeNotes,
    this.slmTagsJson,
    this.followUpExchangesJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['check_in_id'] = Variable<String>(checkInId);
    if (!nullToAbsent || freeNotes != null) {
      map['free_notes'] = Variable<String>(freeNotes);
    }
    if (!nullToAbsent || slmTagsJson != null) {
      map['slm_tags_json'] = Variable<String>(slmTagsJson);
    }
    if (!nullToAbsent || followUpExchangesJson != null) {
      map['follow_up_exchanges_json'] = Variable<String>(followUpExchangesJson);
    }
    return map;
  }

  CheckInSubjectiveCompanion toCompanion(bool nullToAbsent) {
    return CheckInSubjectiveCompanion(
      checkInId: Value(checkInId),
      freeNotes: freeNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(freeNotes),
      slmTagsJson: slmTagsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(slmTagsJson),
      followUpExchangesJson: followUpExchangesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(followUpExchangesJson),
    );
  }

  factory CheckInSubjectiveData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CheckInSubjectiveData(
      checkInId: serializer.fromJson<String>(json['checkInId']),
      freeNotes: serializer.fromJson<String?>(json['freeNotes']),
      slmTagsJson: serializer.fromJson<String?>(json['slmTagsJson']),
      followUpExchangesJson: serializer.fromJson<String?>(
        json['followUpExchangesJson'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'checkInId': serializer.toJson<String>(checkInId),
      'freeNotes': serializer.toJson<String?>(freeNotes),
      'slmTagsJson': serializer.toJson<String?>(slmTagsJson),
      'followUpExchangesJson': serializer.toJson<String?>(
        followUpExchangesJson,
      ),
    };
  }

  CheckInSubjectiveData copyWith({
    String? checkInId,
    Value<String?> freeNotes = const Value.absent(),
    Value<String?> slmTagsJson = const Value.absent(),
    Value<String?> followUpExchangesJson = const Value.absent(),
  }) => CheckInSubjectiveData(
    checkInId: checkInId ?? this.checkInId,
    freeNotes: freeNotes.present ? freeNotes.value : this.freeNotes,
    slmTagsJson: slmTagsJson.present ? slmTagsJson.value : this.slmTagsJson,
    followUpExchangesJson: followUpExchangesJson.present
        ? followUpExchangesJson.value
        : this.followUpExchangesJson,
  );
  CheckInSubjectiveData copyWithCompanion(CheckInSubjectiveCompanion data) {
    return CheckInSubjectiveData(
      checkInId: data.checkInId.present ? data.checkInId.value : this.checkInId,
      freeNotes: data.freeNotes.present ? data.freeNotes.value : this.freeNotes,
      slmTagsJson: data.slmTagsJson.present
          ? data.slmTagsJson.value
          : this.slmTagsJson,
      followUpExchangesJson: data.followUpExchangesJson.present
          ? data.followUpExchangesJson.value
          : this.followUpExchangesJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CheckInSubjectiveData(')
          ..write('checkInId: $checkInId, ')
          ..write('freeNotes: $freeNotes, ')
          ..write('slmTagsJson: $slmTagsJson, ')
          ..write('followUpExchangesJson: $followUpExchangesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(checkInId, freeNotes, slmTagsJson, followUpExchangesJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CheckInSubjectiveData &&
          other.checkInId == this.checkInId &&
          other.freeNotes == this.freeNotes &&
          other.slmTagsJson == this.slmTagsJson &&
          other.followUpExchangesJson == this.followUpExchangesJson);
}

class CheckInSubjectiveCompanion
    extends UpdateCompanion<CheckInSubjectiveData> {
  final Value<String> checkInId;
  final Value<String?> freeNotes;
  final Value<String?> slmTagsJson;
  final Value<String?> followUpExchangesJson;
  final Value<int> rowid;
  const CheckInSubjectiveCompanion({
    this.checkInId = const Value.absent(),
    this.freeNotes = const Value.absent(),
    this.slmTagsJson = const Value.absent(),
    this.followUpExchangesJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CheckInSubjectiveCompanion.insert({
    required String checkInId,
    this.freeNotes = const Value.absent(),
    this.slmTagsJson = const Value.absent(),
    this.followUpExchangesJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : checkInId = Value(checkInId);
  static Insertable<CheckInSubjectiveData> custom({
    Expression<String>? checkInId,
    Expression<String>? freeNotes,
    Expression<String>? slmTagsJson,
    Expression<String>? followUpExchangesJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (checkInId != null) 'check_in_id': checkInId,
      if (freeNotes != null) 'free_notes': freeNotes,
      if (slmTagsJson != null) 'slm_tags_json': slmTagsJson,
      if (followUpExchangesJson != null)
        'follow_up_exchanges_json': followUpExchangesJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CheckInSubjectiveCompanion copyWith({
    Value<String>? checkInId,
    Value<String?>? freeNotes,
    Value<String?>? slmTagsJson,
    Value<String?>? followUpExchangesJson,
    Value<int>? rowid,
  }) {
    return CheckInSubjectiveCompanion(
      checkInId: checkInId ?? this.checkInId,
      freeNotes: freeNotes ?? this.freeNotes,
      slmTagsJson: slmTagsJson ?? this.slmTagsJson,
      followUpExchangesJson:
          followUpExchangesJson ?? this.followUpExchangesJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (checkInId.present) {
      map['check_in_id'] = Variable<String>(checkInId.value);
    }
    if (freeNotes.present) {
      map['free_notes'] = Variable<String>(freeNotes.value);
    }
    if (slmTagsJson.present) {
      map['slm_tags_json'] = Variable<String>(slmTagsJson.value);
    }
    if (followUpExchangesJson.present) {
      map['follow_up_exchanges_json'] = Variable<String>(
        followUpExchangesJson.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CheckInSubjectiveCompanion(')
          ..write('checkInId: $checkInId, ')
          ..write('freeNotes: $freeNotes, ')
          ..write('slmTagsJson: $slmTagsJson, ')
          ..write('followUpExchangesJson: $followUpExchangesJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PetStateTableTable extends PetStateTable
    with TableInfo<$PetStateTableTable, PetStateTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PetStateTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _petIdMeta = const VerificationMeta('petId');
  @override
  late final GeneratedColumn<String> petId = GeneratedColumn<String>(
    'pet_id',
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
  static const VerificationMeta _speciesMeta = const VerificationMeta(
    'species',
  );
  @override
  late final GeneratedColumn<String> species = GeneratedColumn<String>(
    'species',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vitalityMeta = const VerificationMeta(
    'vitality',
  );
  @override
  late final GeneratedColumn<int> vitality = GeneratedColumn<int>(
    'vitality',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(60),
  );
  static const VerificationMeta _streakMeta = const VerificationMeta('streak');
  @override
  late final GeneratedColumn<int> streak = GeneratedColumn<int>(
    'streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastCheckinUtcMeta = const VerificationMeta(
    'lastCheckinUtc',
  );
  @override
  late final GeneratedColumn<String> lastCheckinUtc = GeneratedColumn<String>(
    'last_checkin_utc',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _calmModeMeta = const VerificationMeta(
    'calmMode',
  );
  @override
  late final GeneratedColumn<bool> calmMode = GeneratedColumn<bool>(
    'calm_mode',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("calm_mode" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _consecutiveBadDaysMeta =
      const VerificationMeta('consecutiveBadDays');
  @override
  late final GeneratedColumn<int> consecutiveBadDays = GeneratedColumn<int>(
    'consecutive_bad_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _freezeAvailableMeta = const VerificationMeta(
    'freezeAvailable',
  );
  @override
  late final GeneratedColumn<bool> freezeAvailable = GeneratedColumn<bool>(
    'freeze_available',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("freeze_available" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _freezeLastUsedDateMeta =
      const VerificationMeta('freezeLastUsedDate');
  @override
  late final GeneratedColumn<String> freezeLastUsedDate =
      GeneratedColumn<String>(
        'freeze_last_used_date',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _deletionScheduledAtMeta =
      const VerificationMeta('deletionScheduledAt');
  @override
  late final GeneratedColumn<String> deletionScheduledAt =
      GeneratedColumn<String>(
        'deletion_scheduled_at',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _vulnerabilityCardShownMeta =
      const VerificationMeta('vulnerabilityCardShown');
  @override
  late final GeneratedColumn<bool> vulnerabilityCardShown =
      GeneratedColumn<bool>(
        'vulnerability_card_shown',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("vulnerability_card_shown" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _vulnerabilityFrozenMeta =
      const VerificationMeta('vulnerabilityFrozen');
  @override
  late final GeneratedColumn<bool> vulnerabilityFrozen = GeneratedColumn<bool>(
    'vulnerability_frozen',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("vulnerability_frozen" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    petId,
    name,
    species,
    vitality,
    streak,
    lastCheckinUtc,
    calmMode,
    consecutiveBadDays,
    freezeAvailable,
    freezeLastUsedDate,
    deletionScheduledAt,
    vulnerabilityCardShown,
    vulnerabilityFrozen,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pet_state_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PetStateTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pet_id')) {
      context.handle(
        _petIdMeta,
        petId.isAcceptableOrUnknown(data['pet_id']!, _petIdMeta),
      );
    } else if (isInserting) {
      context.missing(_petIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('species')) {
      context.handle(
        _speciesMeta,
        species.isAcceptableOrUnknown(data['species']!, _speciesMeta),
      );
    } else if (isInserting) {
      context.missing(_speciesMeta);
    }
    if (data.containsKey('vitality')) {
      context.handle(
        _vitalityMeta,
        vitality.isAcceptableOrUnknown(data['vitality']!, _vitalityMeta),
      );
    }
    if (data.containsKey('streak')) {
      context.handle(
        _streakMeta,
        streak.isAcceptableOrUnknown(data['streak']!, _streakMeta),
      );
    }
    if (data.containsKey('last_checkin_utc')) {
      context.handle(
        _lastCheckinUtcMeta,
        lastCheckinUtc.isAcceptableOrUnknown(
          data['last_checkin_utc']!,
          _lastCheckinUtcMeta,
        ),
      );
    }
    if (data.containsKey('calm_mode')) {
      context.handle(
        _calmModeMeta,
        calmMode.isAcceptableOrUnknown(data['calm_mode']!, _calmModeMeta),
      );
    }
    if (data.containsKey('consecutive_bad_days')) {
      context.handle(
        _consecutiveBadDaysMeta,
        consecutiveBadDays.isAcceptableOrUnknown(
          data['consecutive_bad_days']!,
          _consecutiveBadDaysMeta,
        ),
      );
    }
    if (data.containsKey('freeze_available')) {
      context.handle(
        _freezeAvailableMeta,
        freezeAvailable.isAcceptableOrUnknown(
          data['freeze_available']!,
          _freezeAvailableMeta,
        ),
      );
    }
    if (data.containsKey('freeze_last_used_date')) {
      context.handle(
        _freezeLastUsedDateMeta,
        freezeLastUsedDate.isAcceptableOrUnknown(
          data['freeze_last_used_date']!,
          _freezeLastUsedDateMeta,
        ),
      );
    }
    if (data.containsKey('deletion_scheduled_at')) {
      context.handle(
        _deletionScheduledAtMeta,
        deletionScheduledAt.isAcceptableOrUnknown(
          data['deletion_scheduled_at']!,
          _deletionScheduledAtMeta,
        ),
      );
    }
    if (data.containsKey('vulnerability_card_shown')) {
      context.handle(
        _vulnerabilityCardShownMeta,
        vulnerabilityCardShown.isAcceptableOrUnknown(
          data['vulnerability_card_shown']!,
          _vulnerabilityCardShownMeta,
        ),
      );
    }
    if (data.containsKey('vulnerability_frozen')) {
      context.handle(
        _vulnerabilityFrozenMeta,
        vulnerabilityFrozen.isAcceptableOrUnknown(
          data['vulnerability_frozen']!,
          _vulnerabilityFrozenMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {petId};
  @override
  PetStateTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PetStateTableData(
      petId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pet_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      species: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}species'],
      )!,
      vitality: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vitality'],
      )!,
      streak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}streak'],
      )!,
      lastCheckinUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_checkin_utc'],
      ),
      calmMode: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}calm_mode'],
      )!,
      consecutiveBadDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}consecutive_bad_days'],
      )!,
      freezeAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}freeze_available'],
      )!,
      freezeLastUsedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}freeze_last_used_date'],
      ),
      deletionScheduledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deletion_scheduled_at'],
      ),
      vulnerabilityCardShown: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}vulnerability_card_shown'],
      )!,
      vulnerabilityFrozen: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}vulnerability_frozen'],
      )!,
    );
  }

  @override
  $PetStateTableTable createAlias(String alias) {
    return $PetStateTableTable(attachedDatabase, alias);
  }
}

class PetStateTableData extends DataClass
    implements Insertable<PetStateTableData> {
  final String petId;
  final String name;
  final String species;
  final int vitality;
  final int streak;
  final String? lastCheckinUtc;
  final bool calmMode;
  final int consecutiveBadDays;
  final bool freezeAvailable;
  final String? freezeLastUsedDate;
  final String? deletionScheduledAt;
  final bool vulnerabilityCardShown;
  final bool vulnerabilityFrozen;
  const PetStateTableData({
    required this.petId,
    required this.name,
    required this.species,
    required this.vitality,
    required this.streak,
    this.lastCheckinUtc,
    required this.calmMode,
    required this.consecutiveBadDays,
    required this.freezeAvailable,
    this.freezeLastUsedDate,
    this.deletionScheduledAt,
    required this.vulnerabilityCardShown,
    required this.vulnerabilityFrozen,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pet_id'] = Variable<String>(petId);
    map['name'] = Variable<String>(name);
    map['species'] = Variable<String>(species);
    map['vitality'] = Variable<int>(vitality);
    map['streak'] = Variable<int>(streak);
    if (!nullToAbsent || lastCheckinUtc != null) {
      map['last_checkin_utc'] = Variable<String>(lastCheckinUtc);
    }
    map['calm_mode'] = Variable<bool>(calmMode);
    map['consecutive_bad_days'] = Variable<int>(consecutiveBadDays);
    map['freeze_available'] = Variable<bool>(freezeAvailable);
    if (!nullToAbsent || freezeLastUsedDate != null) {
      map['freeze_last_used_date'] = Variable<String>(freezeLastUsedDate);
    }
    if (!nullToAbsent || deletionScheduledAt != null) {
      map['deletion_scheduled_at'] = Variable<String>(deletionScheduledAt);
    }
    map['vulnerability_card_shown'] = Variable<bool>(vulnerabilityCardShown);
    map['vulnerability_frozen'] = Variable<bool>(vulnerabilityFrozen);
    return map;
  }

  PetStateTableCompanion toCompanion(bool nullToAbsent) {
    return PetStateTableCompanion(
      petId: Value(petId),
      name: Value(name),
      species: Value(species),
      vitality: Value(vitality),
      streak: Value(streak),
      lastCheckinUtc: lastCheckinUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCheckinUtc),
      calmMode: Value(calmMode),
      consecutiveBadDays: Value(consecutiveBadDays),
      freezeAvailable: Value(freezeAvailable),
      freezeLastUsedDate: freezeLastUsedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(freezeLastUsedDate),
      deletionScheduledAt: deletionScheduledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletionScheduledAt),
      vulnerabilityCardShown: Value(vulnerabilityCardShown),
      vulnerabilityFrozen: Value(vulnerabilityFrozen),
    );
  }

  factory PetStateTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PetStateTableData(
      petId: serializer.fromJson<String>(json['petId']),
      name: serializer.fromJson<String>(json['name']),
      species: serializer.fromJson<String>(json['species']),
      vitality: serializer.fromJson<int>(json['vitality']),
      streak: serializer.fromJson<int>(json['streak']),
      lastCheckinUtc: serializer.fromJson<String?>(json['lastCheckinUtc']),
      calmMode: serializer.fromJson<bool>(json['calmMode']),
      consecutiveBadDays: serializer.fromJson<int>(json['consecutiveBadDays']),
      freezeAvailable: serializer.fromJson<bool>(json['freezeAvailable']),
      freezeLastUsedDate: serializer.fromJson<String?>(
        json['freezeLastUsedDate'],
      ),
      deletionScheduledAt: serializer.fromJson<String?>(
        json['deletionScheduledAt'],
      ),
      vulnerabilityCardShown: serializer.fromJson<bool>(
        json['vulnerabilityCardShown'],
      ),
      vulnerabilityFrozen: serializer.fromJson<bool>(
        json['vulnerabilityFrozen'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'petId': serializer.toJson<String>(petId),
      'name': serializer.toJson<String>(name),
      'species': serializer.toJson<String>(species),
      'vitality': serializer.toJson<int>(vitality),
      'streak': serializer.toJson<int>(streak),
      'lastCheckinUtc': serializer.toJson<String?>(lastCheckinUtc),
      'calmMode': serializer.toJson<bool>(calmMode),
      'consecutiveBadDays': serializer.toJson<int>(consecutiveBadDays),
      'freezeAvailable': serializer.toJson<bool>(freezeAvailable),
      'freezeLastUsedDate': serializer.toJson<String?>(freezeLastUsedDate),
      'deletionScheduledAt': serializer.toJson<String?>(deletionScheduledAt),
      'vulnerabilityCardShown': serializer.toJson<bool>(vulnerabilityCardShown),
      'vulnerabilityFrozen': serializer.toJson<bool>(vulnerabilityFrozen),
    };
  }

  PetStateTableData copyWith({
    String? petId,
    String? name,
    String? species,
    int? vitality,
    int? streak,
    Value<String?> lastCheckinUtc = const Value.absent(),
    bool? calmMode,
    int? consecutiveBadDays,
    bool? freezeAvailable,
    Value<String?> freezeLastUsedDate = const Value.absent(),
    Value<String?> deletionScheduledAt = const Value.absent(),
    bool? vulnerabilityCardShown,
    bool? vulnerabilityFrozen,
  }) => PetStateTableData(
    petId: petId ?? this.petId,
    name: name ?? this.name,
    species: species ?? this.species,
    vitality: vitality ?? this.vitality,
    streak: streak ?? this.streak,
    lastCheckinUtc: lastCheckinUtc.present
        ? lastCheckinUtc.value
        : this.lastCheckinUtc,
    calmMode: calmMode ?? this.calmMode,
    consecutiveBadDays: consecutiveBadDays ?? this.consecutiveBadDays,
    freezeAvailable: freezeAvailable ?? this.freezeAvailable,
    freezeLastUsedDate: freezeLastUsedDate.present
        ? freezeLastUsedDate.value
        : this.freezeLastUsedDate,
    deletionScheduledAt: deletionScheduledAt.present
        ? deletionScheduledAt.value
        : this.deletionScheduledAt,
    vulnerabilityCardShown:
        vulnerabilityCardShown ?? this.vulnerabilityCardShown,
    vulnerabilityFrozen: vulnerabilityFrozen ?? this.vulnerabilityFrozen,
  );
  PetStateTableData copyWithCompanion(PetStateTableCompanion data) {
    return PetStateTableData(
      petId: data.petId.present ? data.petId.value : this.petId,
      name: data.name.present ? data.name.value : this.name,
      species: data.species.present ? data.species.value : this.species,
      vitality: data.vitality.present ? data.vitality.value : this.vitality,
      streak: data.streak.present ? data.streak.value : this.streak,
      lastCheckinUtc: data.lastCheckinUtc.present
          ? data.lastCheckinUtc.value
          : this.lastCheckinUtc,
      calmMode: data.calmMode.present ? data.calmMode.value : this.calmMode,
      consecutiveBadDays: data.consecutiveBadDays.present
          ? data.consecutiveBadDays.value
          : this.consecutiveBadDays,
      freezeAvailable: data.freezeAvailable.present
          ? data.freezeAvailable.value
          : this.freezeAvailable,
      freezeLastUsedDate: data.freezeLastUsedDate.present
          ? data.freezeLastUsedDate.value
          : this.freezeLastUsedDate,
      deletionScheduledAt: data.deletionScheduledAt.present
          ? data.deletionScheduledAt.value
          : this.deletionScheduledAt,
      vulnerabilityCardShown: data.vulnerabilityCardShown.present
          ? data.vulnerabilityCardShown.value
          : this.vulnerabilityCardShown,
      vulnerabilityFrozen: data.vulnerabilityFrozen.present
          ? data.vulnerabilityFrozen.value
          : this.vulnerabilityFrozen,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PetStateTableData(')
          ..write('petId: $petId, ')
          ..write('name: $name, ')
          ..write('species: $species, ')
          ..write('vitality: $vitality, ')
          ..write('streak: $streak, ')
          ..write('lastCheckinUtc: $lastCheckinUtc, ')
          ..write('calmMode: $calmMode, ')
          ..write('consecutiveBadDays: $consecutiveBadDays, ')
          ..write('freezeAvailable: $freezeAvailable, ')
          ..write('freezeLastUsedDate: $freezeLastUsedDate, ')
          ..write('deletionScheduledAt: $deletionScheduledAt, ')
          ..write('vulnerabilityCardShown: $vulnerabilityCardShown, ')
          ..write('vulnerabilityFrozen: $vulnerabilityFrozen')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    petId,
    name,
    species,
    vitality,
    streak,
    lastCheckinUtc,
    calmMode,
    consecutiveBadDays,
    freezeAvailable,
    freezeLastUsedDate,
    deletionScheduledAt,
    vulnerabilityCardShown,
    vulnerabilityFrozen,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PetStateTableData &&
          other.petId == this.petId &&
          other.name == this.name &&
          other.species == this.species &&
          other.vitality == this.vitality &&
          other.streak == this.streak &&
          other.lastCheckinUtc == this.lastCheckinUtc &&
          other.calmMode == this.calmMode &&
          other.consecutiveBadDays == this.consecutiveBadDays &&
          other.freezeAvailable == this.freezeAvailable &&
          other.freezeLastUsedDate == this.freezeLastUsedDate &&
          other.deletionScheduledAt == this.deletionScheduledAt &&
          other.vulnerabilityCardShown == this.vulnerabilityCardShown &&
          other.vulnerabilityFrozen == this.vulnerabilityFrozen);
}

class PetStateTableCompanion extends UpdateCompanion<PetStateTableData> {
  final Value<String> petId;
  final Value<String> name;
  final Value<String> species;
  final Value<int> vitality;
  final Value<int> streak;
  final Value<String?> lastCheckinUtc;
  final Value<bool> calmMode;
  final Value<int> consecutiveBadDays;
  final Value<bool> freezeAvailable;
  final Value<String?> freezeLastUsedDate;
  final Value<String?> deletionScheduledAt;
  final Value<bool> vulnerabilityCardShown;
  final Value<bool> vulnerabilityFrozen;
  final Value<int> rowid;
  const PetStateTableCompanion({
    this.petId = const Value.absent(),
    this.name = const Value.absent(),
    this.species = const Value.absent(),
    this.vitality = const Value.absent(),
    this.streak = const Value.absent(),
    this.lastCheckinUtc = const Value.absent(),
    this.calmMode = const Value.absent(),
    this.consecutiveBadDays = const Value.absent(),
    this.freezeAvailable = const Value.absent(),
    this.freezeLastUsedDate = const Value.absent(),
    this.deletionScheduledAt = const Value.absent(),
    this.vulnerabilityCardShown = const Value.absent(),
    this.vulnerabilityFrozen = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PetStateTableCompanion.insert({
    required String petId,
    required String name,
    required String species,
    this.vitality = const Value.absent(),
    this.streak = const Value.absent(),
    this.lastCheckinUtc = const Value.absent(),
    this.calmMode = const Value.absent(),
    this.consecutiveBadDays = const Value.absent(),
    this.freezeAvailable = const Value.absent(),
    this.freezeLastUsedDate = const Value.absent(),
    this.deletionScheduledAt = const Value.absent(),
    this.vulnerabilityCardShown = const Value.absent(),
    this.vulnerabilityFrozen = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : petId = Value(petId),
       name = Value(name),
       species = Value(species);
  static Insertable<PetStateTableData> custom({
    Expression<String>? petId,
    Expression<String>? name,
    Expression<String>? species,
    Expression<int>? vitality,
    Expression<int>? streak,
    Expression<String>? lastCheckinUtc,
    Expression<bool>? calmMode,
    Expression<int>? consecutiveBadDays,
    Expression<bool>? freezeAvailable,
    Expression<String>? freezeLastUsedDate,
    Expression<String>? deletionScheduledAt,
    Expression<bool>? vulnerabilityCardShown,
    Expression<bool>? vulnerabilityFrozen,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (petId != null) 'pet_id': petId,
      if (name != null) 'name': name,
      if (species != null) 'species': species,
      if (vitality != null) 'vitality': vitality,
      if (streak != null) 'streak': streak,
      if (lastCheckinUtc != null) 'last_checkin_utc': lastCheckinUtc,
      if (calmMode != null) 'calm_mode': calmMode,
      if (consecutiveBadDays != null)
        'consecutive_bad_days': consecutiveBadDays,
      if (freezeAvailable != null) 'freeze_available': freezeAvailable,
      if (freezeLastUsedDate != null)
        'freeze_last_used_date': freezeLastUsedDate,
      if (deletionScheduledAt != null)
        'deletion_scheduled_at': deletionScheduledAt,
      if (vulnerabilityCardShown != null)
        'vulnerability_card_shown': vulnerabilityCardShown,
      if (vulnerabilityFrozen != null)
        'vulnerability_frozen': vulnerabilityFrozen,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PetStateTableCompanion copyWith({
    Value<String>? petId,
    Value<String>? name,
    Value<String>? species,
    Value<int>? vitality,
    Value<int>? streak,
    Value<String?>? lastCheckinUtc,
    Value<bool>? calmMode,
    Value<int>? consecutiveBadDays,
    Value<bool>? freezeAvailable,
    Value<String?>? freezeLastUsedDate,
    Value<String?>? deletionScheduledAt,
    Value<bool>? vulnerabilityCardShown,
    Value<bool>? vulnerabilityFrozen,
    Value<int>? rowid,
  }) {
    return PetStateTableCompanion(
      petId: petId ?? this.petId,
      name: name ?? this.name,
      species: species ?? this.species,
      vitality: vitality ?? this.vitality,
      streak: streak ?? this.streak,
      lastCheckinUtc: lastCheckinUtc ?? this.lastCheckinUtc,
      calmMode: calmMode ?? this.calmMode,
      consecutiveBadDays: consecutiveBadDays ?? this.consecutiveBadDays,
      freezeAvailable: freezeAvailable ?? this.freezeAvailable,
      freezeLastUsedDate: freezeLastUsedDate ?? this.freezeLastUsedDate,
      deletionScheduledAt: deletionScheduledAt ?? this.deletionScheduledAt,
      vulnerabilityCardShown:
          vulnerabilityCardShown ?? this.vulnerabilityCardShown,
      vulnerabilityFrozen: vulnerabilityFrozen ?? this.vulnerabilityFrozen,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (petId.present) {
      map['pet_id'] = Variable<String>(petId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (species.present) {
      map['species'] = Variable<String>(species.value);
    }
    if (vitality.present) {
      map['vitality'] = Variable<int>(vitality.value);
    }
    if (streak.present) {
      map['streak'] = Variable<int>(streak.value);
    }
    if (lastCheckinUtc.present) {
      map['last_checkin_utc'] = Variable<String>(lastCheckinUtc.value);
    }
    if (calmMode.present) {
      map['calm_mode'] = Variable<bool>(calmMode.value);
    }
    if (consecutiveBadDays.present) {
      map['consecutive_bad_days'] = Variable<int>(consecutiveBadDays.value);
    }
    if (freezeAvailable.present) {
      map['freeze_available'] = Variable<bool>(freezeAvailable.value);
    }
    if (freezeLastUsedDate.present) {
      map['freeze_last_used_date'] = Variable<String>(freezeLastUsedDate.value);
    }
    if (deletionScheduledAt.present) {
      map['deletion_scheduled_at'] = Variable<String>(
        deletionScheduledAt.value,
      );
    }
    if (vulnerabilityCardShown.present) {
      map['vulnerability_card_shown'] = Variable<bool>(
        vulnerabilityCardShown.value,
      );
    }
    if (vulnerabilityFrozen.present) {
      map['vulnerability_frozen'] = Variable<bool>(vulnerabilityFrozen.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PetStateTableCompanion(')
          ..write('petId: $petId, ')
          ..write('name: $name, ')
          ..write('species: $species, ')
          ..write('vitality: $vitality, ')
          ..write('streak: $streak, ')
          ..write('lastCheckinUtc: $lastCheckinUtc, ')
          ..write('calmMode: $calmMode, ')
          ..write('consecutiveBadDays: $consecutiveBadDays, ')
          ..write('freezeAvailable: $freezeAvailable, ')
          ..write('freezeLastUsedDate: $freezeLastUsedDate, ')
          ..write('deletionScheduledAt: $deletionScheduledAt, ')
          ..write('vulnerabilityCardShown: $vulnerabilityCardShown, ')
          ..write('vulnerabilityFrozen: $vulnerabilityFrozen, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BaselineStatsTable extends BaselineStats
    with TableInfo<$BaselineStatsTable, BaselineStat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BaselineStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _metricMeta = const VerificationMeta('metric');
  @override
  late final GeneratedColumn<String> metric = GeneratedColumn<String>(
    'metric',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mean14dMeta = const VerificationMeta(
    'mean14d',
  );
  @override
  late final GeneratedColumn<double> mean14d = GeneratedColumn<double>(
    'mean14d',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stddev14dMeta = const VerificationMeta(
    'stddev14d',
  );
  @override
  late final GeneratedColumn<double> stddev14d = GeneratedColumn<double>(
    'stddev14d',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sampleCountMeta = const VerificationMeta(
    'sampleCount',
  );
  @override
  late final GeneratedColumn<int> sampleCount = GeneratedColumn<int>(
    'sample_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastComputedUtcMeta = const VerificationMeta(
    'lastComputedUtc',
  );
  @override
  late final GeneratedColumn<String> lastComputedUtc = GeneratedColumn<String>(
    'last_computed_utc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    metric,
    mean14d,
    stddev14d,
    sampleCount,
    lastComputedUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'baseline_stats';
  @override
  VerificationContext validateIntegrity(
    Insertable<BaselineStat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('metric')) {
      context.handle(
        _metricMeta,
        metric.isAcceptableOrUnknown(data['metric']!, _metricMeta),
      );
    } else if (isInserting) {
      context.missing(_metricMeta);
    }
    if (data.containsKey('mean14d')) {
      context.handle(
        _mean14dMeta,
        mean14d.isAcceptableOrUnknown(data['mean14d']!, _mean14dMeta),
      );
    } else if (isInserting) {
      context.missing(_mean14dMeta);
    }
    if (data.containsKey('stddev14d')) {
      context.handle(
        _stddev14dMeta,
        stddev14d.isAcceptableOrUnknown(data['stddev14d']!, _stddev14dMeta),
      );
    } else if (isInserting) {
      context.missing(_stddev14dMeta);
    }
    if (data.containsKey('sample_count')) {
      context.handle(
        _sampleCountMeta,
        sampleCount.isAcceptableOrUnknown(
          data['sample_count']!,
          _sampleCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sampleCountMeta);
    }
    if (data.containsKey('last_computed_utc')) {
      context.handle(
        _lastComputedUtcMeta,
        lastComputedUtc.isAcceptableOrUnknown(
          data['last_computed_utc']!,
          _lastComputedUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastComputedUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {metric};
  @override
  BaselineStat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BaselineStat(
      metric: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metric'],
      )!,
      mean14d: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}mean14d'],
      )!,
      stddev14d: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stddev14d'],
      )!,
      sampleCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sample_count'],
      )!,
      lastComputedUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_computed_utc'],
      )!,
    );
  }

  @override
  $BaselineStatsTable createAlias(String alias) {
    return $BaselineStatsTable(attachedDatabase, alias);
  }
}

class BaselineStat extends DataClass implements Insertable<BaselineStat> {
  final String metric;
  final double mean14d;
  final double stddev14d;
  final int sampleCount;
  final String lastComputedUtc;
  const BaselineStat({
    required this.metric,
    required this.mean14d,
    required this.stddev14d,
    required this.sampleCount,
    required this.lastComputedUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['metric'] = Variable<String>(metric);
    map['mean14d'] = Variable<double>(mean14d);
    map['stddev14d'] = Variable<double>(stddev14d);
    map['sample_count'] = Variable<int>(sampleCount);
    map['last_computed_utc'] = Variable<String>(lastComputedUtc);
    return map;
  }

  BaselineStatsCompanion toCompanion(bool nullToAbsent) {
    return BaselineStatsCompanion(
      metric: Value(metric),
      mean14d: Value(mean14d),
      stddev14d: Value(stddev14d),
      sampleCount: Value(sampleCount),
      lastComputedUtc: Value(lastComputedUtc),
    );
  }

  factory BaselineStat.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BaselineStat(
      metric: serializer.fromJson<String>(json['metric']),
      mean14d: serializer.fromJson<double>(json['mean14d']),
      stddev14d: serializer.fromJson<double>(json['stddev14d']),
      sampleCount: serializer.fromJson<int>(json['sampleCount']),
      lastComputedUtc: serializer.fromJson<String>(json['lastComputedUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'metric': serializer.toJson<String>(metric),
      'mean14d': serializer.toJson<double>(mean14d),
      'stddev14d': serializer.toJson<double>(stddev14d),
      'sampleCount': serializer.toJson<int>(sampleCount),
      'lastComputedUtc': serializer.toJson<String>(lastComputedUtc),
    };
  }

  BaselineStat copyWith({
    String? metric,
    double? mean14d,
    double? stddev14d,
    int? sampleCount,
    String? lastComputedUtc,
  }) => BaselineStat(
    metric: metric ?? this.metric,
    mean14d: mean14d ?? this.mean14d,
    stddev14d: stddev14d ?? this.stddev14d,
    sampleCount: sampleCount ?? this.sampleCount,
    lastComputedUtc: lastComputedUtc ?? this.lastComputedUtc,
  );
  BaselineStat copyWithCompanion(BaselineStatsCompanion data) {
    return BaselineStat(
      metric: data.metric.present ? data.metric.value : this.metric,
      mean14d: data.mean14d.present ? data.mean14d.value : this.mean14d,
      stddev14d: data.stddev14d.present ? data.stddev14d.value : this.stddev14d,
      sampleCount: data.sampleCount.present
          ? data.sampleCount.value
          : this.sampleCount,
      lastComputedUtc: data.lastComputedUtc.present
          ? data.lastComputedUtc.value
          : this.lastComputedUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BaselineStat(')
          ..write('metric: $metric, ')
          ..write('mean14d: $mean14d, ')
          ..write('stddev14d: $stddev14d, ')
          ..write('sampleCount: $sampleCount, ')
          ..write('lastComputedUtc: $lastComputedUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(metric, mean14d, stddev14d, sampleCount, lastComputedUtc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BaselineStat &&
          other.metric == this.metric &&
          other.mean14d == this.mean14d &&
          other.stddev14d == this.stddev14d &&
          other.sampleCount == this.sampleCount &&
          other.lastComputedUtc == this.lastComputedUtc);
}

class BaselineStatsCompanion extends UpdateCompanion<BaselineStat> {
  final Value<String> metric;
  final Value<double> mean14d;
  final Value<double> stddev14d;
  final Value<int> sampleCount;
  final Value<String> lastComputedUtc;
  final Value<int> rowid;
  const BaselineStatsCompanion({
    this.metric = const Value.absent(),
    this.mean14d = const Value.absent(),
    this.stddev14d = const Value.absent(),
    this.sampleCount = const Value.absent(),
    this.lastComputedUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BaselineStatsCompanion.insert({
    required String metric,
    required double mean14d,
    required double stddev14d,
    required int sampleCount,
    required String lastComputedUtc,
    this.rowid = const Value.absent(),
  }) : metric = Value(metric),
       mean14d = Value(mean14d),
       stddev14d = Value(stddev14d),
       sampleCount = Value(sampleCount),
       lastComputedUtc = Value(lastComputedUtc);
  static Insertable<BaselineStat> custom({
    Expression<String>? metric,
    Expression<double>? mean14d,
    Expression<double>? stddev14d,
    Expression<int>? sampleCount,
    Expression<String>? lastComputedUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (metric != null) 'metric': metric,
      if (mean14d != null) 'mean14d': mean14d,
      if (stddev14d != null) 'stddev14d': stddev14d,
      if (sampleCount != null) 'sample_count': sampleCount,
      if (lastComputedUtc != null) 'last_computed_utc': lastComputedUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BaselineStatsCompanion copyWith({
    Value<String>? metric,
    Value<double>? mean14d,
    Value<double>? stddev14d,
    Value<int>? sampleCount,
    Value<String>? lastComputedUtc,
    Value<int>? rowid,
  }) {
    return BaselineStatsCompanion(
      metric: metric ?? this.metric,
      mean14d: mean14d ?? this.mean14d,
      stddev14d: stddev14d ?? this.stddev14d,
      sampleCount: sampleCount ?? this.sampleCount,
      lastComputedUtc: lastComputedUtc ?? this.lastComputedUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (metric.present) {
      map['metric'] = Variable<String>(metric.value);
    }
    if (mean14d.present) {
      map['mean14d'] = Variable<double>(mean14d.value);
    }
    if (stddev14d.present) {
      map['stddev14d'] = Variable<double>(stddev14d.value);
    }
    if (sampleCount.present) {
      map['sample_count'] = Variable<int>(sampleCount.value);
    }
    if (lastComputedUtc.present) {
      map['last_computed_utc'] = Variable<String>(lastComputedUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BaselineStatsCompanion(')
          ..write('metric: $metric, ')
          ..write('mean14d: $mean14d, ')
          ..write('stddev14d: $stddev14d, ')
          ..write('sampleCount: $sampleCount, ')
          ..write('lastComputedUtc: $lastComputedUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditLogTable extends AuditLog
    with TableInfo<$AuditLogTable, AuditLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _utcTimestampMeta = const VerificationMeta(
    'utcTimestamp',
  );
  @override
  late final GeneratedColumn<String> utcTimestamp = GeneratedColumn<String>(
    'utc_timestamp',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadHashMeta = const VerificationMeta(
    'payloadHash',
  );
  @override
  late final GeneratedColumn<String> payloadHash = GeneratedColumn<String>(
    'payload_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventType,
    utcTimestamp,
    sessionId,
    payloadHash,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('utc_timestamp')) {
      context.handle(
        _utcTimestampMeta,
        utcTimestamp.isAcceptableOrUnknown(
          data['utc_timestamp']!,
          _utcTimestampMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_utcTimestampMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    }
    if (data.containsKey('payload_hash')) {
      context.handle(
        _payloadHashMeta,
        payloadHash.isAcceptableOrUnknown(
          data['payload_hash']!,
          _payloadHashMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      utcTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}utc_timestamp'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      ),
      payloadHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_hash'],
      ),
    );
  }

  @override
  $AuditLogTable createAlias(String alias) {
    return $AuditLogTable(attachedDatabase, alias);
  }
}

class AuditLogData extends DataClass implements Insertable<AuditLogData> {
  final int id;
  final String eventType;
  final String utcTimestamp;
  final String? sessionId;
  final String? payloadHash;
  const AuditLogData({
    required this.id,
    required this.eventType,
    required this.utcTimestamp,
    this.sessionId,
    this.payloadHash,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_type'] = Variable<String>(eventType);
    map['utc_timestamp'] = Variable<String>(utcTimestamp);
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<String>(sessionId);
    }
    if (!nullToAbsent || payloadHash != null) {
      map['payload_hash'] = Variable<String>(payloadHash);
    }
    return map;
  }

  AuditLogCompanion toCompanion(bool nullToAbsent) {
    return AuditLogCompanion(
      id: Value(id),
      eventType: Value(eventType),
      utcTimestamp: Value(utcTimestamp),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      payloadHash: payloadHash == null && nullToAbsent
          ? const Value.absent()
          : Value(payloadHash),
    );
  }

  factory AuditLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLogData(
      id: serializer.fromJson<int>(json['id']),
      eventType: serializer.fromJson<String>(json['eventType']),
      utcTimestamp: serializer.fromJson<String>(json['utcTimestamp']),
      sessionId: serializer.fromJson<String?>(json['sessionId']),
      payloadHash: serializer.fromJson<String?>(json['payloadHash']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventType': serializer.toJson<String>(eventType),
      'utcTimestamp': serializer.toJson<String>(utcTimestamp),
      'sessionId': serializer.toJson<String?>(sessionId),
      'payloadHash': serializer.toJson<String?>(payloadHash),
    };
  }

  AuditLogData copyWith({
    int? id,
    String? eventType,
    String? utcTimestamp,
    Value<String?> sessionId = const Value.absent(),
    Value<String?> payloadHash = const Value.absent(),
  }) => AuditLogData(
    id: id ?? this.id,
    eventType: eventType ?? this.eventType,
    utcTimestamp: utcTimestamp ?? this.utcTimestamp,
    sessionId: sessionId.present ? sessionId.value : this.sessionId,
    payloadHash: payloadHash.present ? payloadHash.value : this.payloadHash,
  );
  AuditLogData copyWithCompanion(AuditLogCompanion data) {
    return AuditLogData(
      id: data.id.present ? data.id.value : this.id,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      utcTimestamp: data.utcTimestamp.present
          ? data.utcTimestamp.value
          : this.utcTimestamp,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      payloadHash: data.payloadHash.present
          ? data.payloadHash.value
          : this.payloadHash,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogData(')
          ..write('id: $id, ')
          ..write('eventType: $eventType, ')
          ..write('utcTimestamp: $utcTimestamp, ')
          ..write('sessionId: $sessionId, ')
          ..write('payloadHash: $payloadHash')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, eventType, utcTimestamp, sessionId, payloadHash);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLogData &&
          other.id == this.id &&
          other.eventType == this.eventType &&
          other.utcTimestamp == this.utcTimestamp &&
          other.sessionId == this.sessionId &&
          other.payloadHash == this.payloadHash);
}

class AuditLogCompanion extends UpdateCompanion<AuditLogData> {
  final Value<int> id;
  final Value<String> eventType;
  final Value<String> utcTimestamp;
  final Value<String?> sessionId;
  final Value<String?> payloadHash;
  const AuditLogCompanion({
    this.id = const Value.absent(),
    this.eventType = const Value.absent(),
    this.utcTimestamp = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.payloadHash = const Value.absent(),
  });
  AuditLogCompanion.insert({
    this.id = const Value.absent(),
    required String eventType,
    required String utcTimestamp,
    this.sessionId = const Value.absent(),
    this.payloadHash = const Value.absent(),
  }) : eventType = Value(eventType),
       utcTimestamp = Value(utcTimestamp);
  static Insertable<AuditLogData> custom({
    Expression<int>? id,
    Expression<String>? eventType,
    Expression<String>? utcTimestamp,
    Expression<String>? sessionId,
    Expression<String>? payloadHash,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventType != null) 'event_type': eventType,
      if (utcTimestamp != null) 'utc_timestamp': utcTimestamp,
      if (sessionId != null) 'session_id': sessionId,
      if (payloadHash != null) 'payload_hash': payloadHash,
    });
  }

  AuditLogCompanion copyWith({
    Value<int>? id,
    Value<String>? eventType,
    Value<String>? utcTimestamp,
    Value<String?>? sessionId,
    Value<String?>? payloadHash,
  }) {
    return AuditLogCompanion(
      id: id ?? this.id,
      eventType: eventType ?? this.eventType,
      utcTimestamp: utcTimestamp ?? this.utcTimestamp,
      sessionId: sessionId ?? this.sessionId,
      payloadHash: payloadHash ?? this.payloadHash,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (utcTimestamp.present) {
      map['utc_timestamp'] = Variable<String>(utcTimestamp.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (payloadHash.present) {
      map['payload_hash'] = Variable<String>(payloadHash.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogCompanion(')
          ..write('id: $id, ')
          ..write('eventType: $eventType, ')
          ..write('utcTimestamp: $utcTimestamp, ')
          ..write('sessionId: $sessionId, ')
          ..write('payloadHash: $payloadHash')
          ..write(')'))
        .toString();
  }
}

class $SlmContextCacheTable extends SlmContextCache
    with TableInfo<$SlmContextCacheTable, SlmContextCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SlmContextCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contextSnapshotMeta = const VerificationMeta(
    'contextSnapshot',
  );
  @override
  late final GeneratedColumn<String> contextSnapshot = GeneratedColumn<String>(
    'context_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [date, contextSnapshot];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'slm_context_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<SlmContextCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('context_snapshot')) {
      context.handle(
        _contextSnapshotMeta,
        contextSnapshot.isAcceptableOrUnknown(
          data['context_snapshot']!,
          _contextSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contextSnapshotMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  SlmContextCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SlmContextCacheData(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      contextSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}context_snapshot'],
      )!,
    );
  }

  @override
  $SlmContextCacheTable createAlias(String alias) {
    return $SlmContextCacheTable(attachedDatabase, alias);
  }
}

class SlmContextCacheData extends DataClass
    implements Insertable<SlmContextCacheData> {
  final String date;
  final String contextSnapshot;
  const SlmContextCacheData({
    required this.date,
    required this.contextSnapshot,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['context_snapshot'] = Variable<String>(contextSnapshot);
    return map;
  }

  SlmContextCacheCompanion toCompanion(bool nullToAbsent) {
    return SlmContextCacheCompanion(
      date: Value(date),
      contextSnapshot: Value(contextSnapshot),
    );
  }

  factory SlmContextCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SlmContextCacheData(
      date: serializer.fromJson<String>(json['date']),
      contextSnapshot: serializer.fromJson<String>(json['contextSnapshot']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'contextSnapshot': serializer.toJson<String>(contextSnapshot),
    };
  }

  SlmContextCacheData copyWith({String? date, String? contextSnapshot}) =>
      SlmContextCacheData(
        date: date ?? this.date,
        contextSnapshot: contextSnapshot ?? this.contextSnapshot,
      );
  SlmContextCacheData copyWithCompanion(SlmContextCacheCompanion data) {
    return SlmContextCacheData(
      date: data.date.present ? data.date.value : this.date,
      contextSnapshot: data.contextSnapshot.present
          ? data.contextSnapshot.value
          : this.contextSnapshot,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SlmContextCacheData(')
          ..write('date: $date, ')
          ..write('contextSnapshot: $contextSnapshot')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, contextSnapshot);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SlmContextCacheData &&
          other.date == this.date &&
          other.contextSnapshot == this.contextSnapshot);
}

class SlmContextCacheCompanion extends UpdateCompanion<SlmContextCacheData> {
  final Value<String> date;
  final Value<String> contextSnapshot;
  final Value<int> rowid;
  const SlmContextCacheCompanion({
    this.date = const Value.absent(),
    this.contextSnapshot = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SlmContextCacheCompanion.insert({
    required String date,
    required String contextSnapshot,
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       contextSnapshot = Value(contextSnapshot);
  static Insertable<SlmContextCacheData> custom({
    Expression<String>? date,
    Expression<String>? contextSnapshot,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (contextSnapshot != null) 'context_snapshot': contextSnapshot,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SlmContextCacheCompanion copyWith({
    Value<String>? date,
    Value<String>? contextSnapshot,
    Value<int>? rowid,
  }) {
    return SlmContextCacheCompanion(
      date: date ?? this.date,
      contextSnapshot: contextSnapshot ?? this.contextSnapshot,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (contextSnapshot.present) {
      map['context_snapshot'] = Variable<String>(contextSnapshot.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SlmContextCacheCompanion(')
          ..write('date: $date, ')
          ..write('contextSnapshot: $contextSnapshot, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PetArchiveTable extends PetArchive
    with TableInfo<$PetArchiveTable, PetArchiveData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PetArchiveTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _speciesMeta = const VerificationMeta(
    'species',
  );
  @override
  late final GeneratedColumn<String> species = GeneratedColumn<String>(
    'species',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lifespanDaysMeta = const VerificationMeta(
    'lifespanDays',
  );
  @override
  late final GeneratedColumn<int> lifespanDays = GeneratedColumn<int>(
    'lifespan_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCheckinsMeta = const VerificationMeta(
    'totalCheckins',
  );
  @override
  late final GeneratedColumn<int> totalCheckins = GeneratedColumn<int>(
    'total_checkins',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topSymptomMeta = const VerificationMeta(
    'topSymptom',
  );
  @override
  late final GeneratedColumn<String> topSymptom = GeneratedColumn<String>(
    'top_symptom',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diedAtUtcMeta = const VerificationMeta(
    'diedAtUtc',
  );
  @override
  late final GeneratedColumn<String> diedAtUtc = GeneratedColumn<String>(
    'died_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    species,
    lifespanDays,
    totalCheckins,
    topSymptom,
    diedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pet_archive';
  @override
  VerificationContext validateIntegrity(
    Insertable<PetArchiveData> instance, {
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
    if (data.containsKey('species')) {
      context.handle(
        _speciesMeta,
        species.isAcceptableOrUnknown(data['species']!, _speciesMeta),
      );
    } else if (isInserting) {
      context.missing(_speciesMeta);
    }
    if (data.containsKey('lifespan_days')) {
      context.handle(
        _lifespanDaysMeta,
        lifespanDays.isAcceptableOrUnknown(
          data['lifespan_days']!,
          _lifespanDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lifespanDaysMeta);
    }
    if (data.containsKey('total_checkins')) {
      context.handle(
        _totalCheckinsMeta,
        totalCheckins.isAcceptableOrUnknown(
          data['total_checkins']!,
          _totalCheckinsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalCheckinsMeta);
    }
    if (data.containsKey('top_symptom')) {
      context.handle(
        _topSymptomMeta,
        topSymptom.isAcceptableOrUnknown(data['top_symptom']!, _topSymptomMeta),
      );
    }
    if (data.containsKey('died_at_utc')) {
      context.handle(
        _diedAtUtcMeta,
        diedAtUtc.isAcceptableOrUnknown(data['died_at_utc']!, _diedAtUtcMeta),
      );
    } else if (isInserting) {
      context.missing(_diedAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PetArchiveData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PetArchiveData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      species: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}species'],
      )!,
      lifespanDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lifespan_days'],
      )!,
      totalCheckins: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_checkins'],
      )!,
      topSymptom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}top_symptom'],
      ),
      diedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}died_at_utc'],
      )!,
    );
  }

  @override
  $PetArchiveTable createAlias(String alias) {
    return $PetArchiveTable(attachedDatabase, alias);
  }
}

class PetArchiveData extends DataClass implements Insertable<PetArchiveData> {
  final String id;
  final String name;
  final String species;
  final int lifespanDays;
  final int totalCheckins;
  final String? topSymptom;
  final String diedAtUtc;
  const PetArchiveData({
    required this.id,
    required this.name,
    required this.species,
    required this.lifespanDays,
    required this.totalCheckins,
    this.topSymptom,
    required this.diedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['species'] = Variable<String>(species);
    map['lifespan_days'] = Variable<int>(lifespanDays);
    map['total_checkins'] = Variable<int>(totalCheckins);
    if (!nullToAbsent || topSymptom != null) {
      map['top_symptom'] = Variable<String>(topSymptom);
    }
    map['died_at_utc'] = Variable<String>(diedAtUtc);
    return map;
  }

  PetArchiveCompanion toCompanion(bool nullToAbsent) {
    return PetArchiveCompanion(
      id: Value(id),
      name: Value(name),
      species: Value(species),
      lifespanDays: Value(lifespanDays),
      totalCheckins: Value(totalCheckins),
      topSymptom: topSymptom == null && nullToAbsent
          ? const Value.absent()
          : Value(topSymptom),
      diedAtUtc: Value(diedAtUtc),
    );
  }

  factory PetArchiveData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PetArchiveData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      species: serializer.fromJson<String>(json['species']),
      lifespanDays: serializer.fromJson<int>(json['lifespanDays']),
      totalCheckins: serializer.fromJson<int>(json['totalCheckins']),
      topSymptom: serializer.fromJson<String?>(json['topSymptom']),
      diedAtUtc: serializer.fromJson<String>(json['diedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'species': serializer.toJson<String>(species),
      'lifespanDays': serializer.toJson<int>(lifespanDays),
      'totalCheckins': serializer.toJson<int>(totalCheckins),
      'topSymptom': serializer.toJson<String?>(topSymptom),
      'diedAtUtc': serializer.toJson<String>(diedAtUtc),
    };
  }

  PetArchiveData copyWith({
    String? id,
    String? name,
    String? species,
    int? lifespanDays,
    int? totalCheckins,
    Value<String?> topSymptom = const Value.absent(),
    String? diedAtUtc,
  }) => PetArchiveData(
    id: id ?? this.id,
    name: name ?? this.name,
    species: species ?? this.species,
    lifespanDays: lifespanDays ?? this.lifespanDays,
    totalCheckins: totalCheckins ?? this.totalCheckins,
    topSymptom: topSymptom.present ? topSymptom.value : this.topSymptom,
    diedAtUtc: diedAtUtc ?? this.diedAtUtc,
  );
  PetArchiveData copyWithCompanion(PetArchiveCompanion data) {
    return PetArchiveData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      species: data.species.present ? data.species.value : this.species,
      lifespanDays: data.lifespanDays.present
          ? data.lifespanDays.value
          : this.lifespanDays,
      totalCheckins: data.totalCheckins.present
          ? data.totalCheckins.value
          : this.totalCheckins,
      topSymptom: data.topSymptom.present
          ? data.topSymptom.value
          : this.topSymptom,
      diedAtUtc: data.diedAtUtc.present ? data.diedAtUtc.value : this.diedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PetArchiveData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('species: $species, ')
          ..write('lifespanDays: $lifespanDays, ')
          ..write('totalCheckins: $totalCheckins, ')
          ..write('topSymptom: $topSymptom, ')
          ..write('diedAtUtc: $diedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    species,
    lifespanDays,
    totalCheckins,
    topSymptom,
    diedAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PetArchiveData &&
          other.id == this.id &&
          other.name == this.name &&
          other.species == this.species &&
          other.lifespanDays == this.lifespanDays &&
          other.totalCheckins == this.totalCheckins &&
          other.topSymptom == this.topSymptom &&
          other.diedAtUtc == this.diedAtUtc);
}

class PetArchiveCompanion extends UpdateCompanion<PetArchiveData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> species;
  final Value<int> lifespanDays;
  final Value<int> totalCheckins;
  final Value<String?> topSymptom;
  final Value<String> diedAtUtc;
  final Value<int> rowid;
  const PetArchiveCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.species = const Value.absent(),
    this.lifespanDays = const Value.absent(),
    this.totalCheckins = const Value.absent(),
    this.topSymptom = const Value.absent(),
    this.diedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PetArchiveCompanion.insert({
    required String id,
    required String name,
    required String species,
    required int lifespanDays,
    required int totalCheckins,
    this.topSymptom = const Value.absent(),
    required String diedAtUtc,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       species = Value(species),
       lifespanDays = Value(lifespanDays),
       totalCheckins = Value(totalCheckins),
       diedAtUtc = Value(diedAtUtc);
  static Insertable<PetArchiveData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? species,
    Expression<int>? lifespanDays,
    Expression<int>? totalCheckins,
    Expression<String>? topSymptom,
    Expression<String>? diedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (species != null) 'species': species,
      if (lifespanDays != null) 'lifespan_days': lifespanDays,
      if (totalCheckins != null) 'total_checkins': totalCheckins,
      if (topSymptom != null) 'top_symptom': topSymptom,
      if (diedAtUtc != null) 'died_at_utc': diedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PetArchiveCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? species,
    Value<int>? lifespanDays,
    Value<int>? totalCheckins,
    Value<String?>? topSymptom,
    Value<String>? diedAtUtc,
    Value<int>? rowid,
  }) {
    return PetArchiveCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      lifespanDays: lifespanDays ?? this.lifespanDays,
      totalCheckins: totalCheckins ?? this.totalCheckins,
      topSymptom: topSymptom ?? this.topSymptom,
      diedAtUtc: diedAtUtc ?? this.diedAtUtc,
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
    if (species.present) {
      map['species'] = Variable<String>(species.value);
    }
    if (lifespanDays.present) {
      map['lifespan_days'] = Variable<int>(lifespanDays.value);
    }
    if (totalCheckins.present) {
      map['total_checkins'] = Variable<int>(totalCheckins.value);
    }
    if (topSymptom.present) {
      map['top_symptom'] = Variable<String>(topSymptom.value);
    }
    if (diedAtUtc.present) {
      map['died_at_utc'] = Variable<String>(diedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PetArchiveCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('species: $species, ')
          ..write('lifespanDays: $lifespanDays, ')
          ..write('totalCheckins: $totalCheckins, ')
          ..write('topSymptom: $topSymptom, ')
          ..write('diedAtUtc: $diedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CheckInsTable checkIns = $CheckInsTable(this);
  late final $CheckInSymptomsTable checkInSymptoms = $CheckInSymptomsTable(
    this,
  );
  late final $SymptomFeverTable symptomFever = $SymptomFeverTable(this);
  late final $SymptomPainTable symptomPain = $SymptomPainTable(this);
  late final $SymptomFatigueTable symptomFatigue = $SymptomFatigueTable(this);
  late final $SymptomNauseaTable symptomNausea = $SymptomNauseaTable(this);
  late final $SymptomOtherTable symptomOther = $SymptomOtherTable(this);
  late final $CheckInSubjectiveTable checkInSubjective =
      $CheckInSubjectiveTable(this);
  late final $PetStateTableTable petStateTable = $PetStateTableTable(this);
  late final $BaselineStatsTable baselineStats = $BaselineStatsTable(this);
  late final $AuditLogTable auditLog = $AuditLogTable(this);
  late final $SlmContextCacheTable slmContextCache = $SlmContextCacheTable(
    this,
  );
  late final $PetArchiveTable petArchive = $PetArchiveTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    checkIns,
    checkInSymptoms,
    symptomFever,
    symptomPain,
    symptomFatigue,
    symptomNausea,
    symptomOther,
    checkInSubjective,
    petStateTable,
    baselineStats,
    auditLog,
    slmContextCache,
    petArchive,
  ];
}

typedef $$CheckInsTableCreateCompanionBuilder =
    CheckInsCompanion Function({
      required String id,
      required String utcDate,
      required String localDate,
      required int wellnessScore,
      required int mode,
      Value<double> depthScore,
      Value<bool> isPartial,
      Value<String?> amendedAt,
      required String createdAt,
      Value<int> rowid,
    });
typedef $$CheckInsTableUpdateCompanionBuilder =
    CheckInsCompanion Function({
      Value<String> id,
      Value<String> utcDate,
      Value<String> localDate,
      Value<int> wellnessScore,
      Value<int> mode,
      Value<double> depthScore,
      Value<bool> isPartial,
      Value<String?> amendedAt,
      Value<String> createdAt,
      Value<int> rowid,
    });

final class $$CheckInsTableReferences
    extends BaseReferences<_$AppDatabase, $CheckInsTable, CheckIn> {
  $$CheckInsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CheckInSymptomsTable, List<CheckInSymptom>>
  _checkInSymptomsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.checkInSymptoms,
    aliasName: $_aliasNameGenerator(
      db.checkIns.id,
      db.checkInSymptoms.checkInId,
    ),
  );

  $$CheckInSymptomsTableProcessedTableManager get checkInSymptomsRefs {
    final manager = $$CheckInSymptomsTableTableManager(
      $_db,
      $_db.checkInSymptoms,
    ).filter((f) => f.checkInId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _checkInSymptomsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $CheckInSubjectiveTable,
    List<CheckInSubjectiveData>
  >
  _checkInSubjectiveRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.checkInSubjective,
        aliasName: $_aliasNameGenerator(
          db.checkIns.id,
          db.checkInSubjective.checkInId,
        ),
      );

  $$CheckInSubjectiveTableProcessedTableManager get checkInSubjectiveRefs {
    final manager = $$CheckInSubjectiveTableTableManager(
      $_db,
      $_db.checkInSubjective,
    ).filter((f) => f.checkInId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _checkInSubjectiveRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CheckInsTableFilterComposer
    extends Composer<_$AppDatabase, $CheckInsTable> {
  $$CheckInsTableFilterComposer({
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

  ColumnFilters<String> get utcDate => $composableBuilder(
    column: $table.utcDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wellnessScore => $composableBuilder(
    column: $table.wellnessScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get depthScore => $composableBuilder(
    column: $table.depthScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPartial => $composableBuilder(
    column: $table.isPartial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get amendedAt => $composableBuilder(
    column: $table.amendedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> checkInSymptomsRefs(
    Expression<bool> Function($$CheckInSymptomsTableFilterComposer f) f,
  ) {
    final $$CheckInSymptomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checkInSymptoms,
      getReferencedColumn: (t) => t.checkInId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInSymptomsTableFilterComposer(
            $db: $db,
            $table: $db.checkInSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> checkInSubjectiveRefs(
    Expression<bool> Function($$CheckInSubjectiveTableFilterComposer f) f,
  ) {
    final $$CheckInSubjectiveTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checkInSubjective,
      getReferencedColumn: (t) => t.checkInId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInSubjectiveTableFilterComposer(
            $db: $db,
            $table: $db.checkInSubjective,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CheckInsTableOrderingComposer
    extends Composer<_$AppDatabase, $CheckInsTable> {
  $$CheckInsTableOrderingComposer({
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

  ColumnOrderings<String> get utcDate => $composableBuilder(
    column: $table.utcDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wellnessScore => $composableBuilder(
    column: $table.wellnessScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get depthScore => $composableBuilder(
    column: $table.depthScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPartial => $composableBuilder(
    column: $table.isPartial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get amendedAt => $composableBuilder(
    column: $table.amendedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CheckInsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CheckInsTable> {
  $$CheckInsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get utcDate =>
      $composableBuilder(column: $table.utcDate, builder: (column) => column);

  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<int> get wellnessScore => $composableBuilder(
    column: $table.wellnessScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<double> get depthScore => $composableBuilder(
    column: $table.depthScore,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPartial =>
      $composableBuilder(column: $table.isPartial, builder: (column) => column);

  GeneratedColumn<String> get amendedAt =>
      $composableBuilder(column: $table.amendedAt, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> checkInSymptomsRefs<T extends Object>(
    Expression<T> Function($$CheckInSymptomsTableAnnotationComposer a) f,
  ) {
    final $$CheckInSymptomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checkInSymptoms,
      getReferencedColumn: (t) => t.checkInId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInSymptomsTableAnnotationComposer(
            $db: $db,
            $table: $db.checkInSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> checkInSubjectiveRefs<T extends Object>(
    Expression<T> Function($$CheckInSubjectiveTableAnnotationComposer a) f,
  ) {
    final $$CheckInSubjectiveTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.checkInSubjective,
          getReferencedColumn: (t) => t.checkInId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CheckInSubjectiveTableAnnotationComposer(
                $db: $db,
                $table: $db.checkInSubjective,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CheckInsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CheckInsTable,
          CheckIn,
          $$CheckInsTableFilterComposer,
          $$CheckInsTableOrderingComposer,
          $$CheckInsTableAnnotationComposer,
          $$CheckInsTableCreateCompanionBuilder,
          $$CheckInsTableUpdateCompanionBuilder,
          (CheckIn, $$CheckInsTableReferences),
          CheckIn,
          PrefetchHooks Function({
            bool checkInSymptomsRefs,
            bool checkInSubjectiveRefs,
          })
        > {
  $$CheckInsTableTableManager(_$AppDatabase db, $CheckInsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CheckInsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CheckInsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CheckInsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> utcDate = const Value.absent(),
                Value<String> localDate = const Value.absent(),
                Value<int> wellnessScore = const Value.absent(),
                Value<int> mode = const Value.absent(),
                Value<double> depthScore = const Value.absent(),
                Value<bool> isPartial = const Value.absent(),
                Value<String?> amendedAt = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CheckInsCompanion(
                id: id,
                utcDate: utcDate,
                localDate: localDate,
                wellnessScore: wellnessScore,
                mode: mode,
                depthScore: depthScore,
                isPartial: isPartial,
                amendedAt: amendedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String utcDate,
                required String localDate,
                required int wellnessScore,
                required int mode,
                Value<double> depthScore = const Value.absent(),
                Value<bool> isPartial = const Value.absent(),
                Value<String?> amendedAt = const Value.absent(),
                required String createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CheckInsCompanion.insert(
                id: id,
                utcDate: utcDate,
                localDate: localDate,
                wellnessScore: wellnessScore,
                mode: mode,
                depthScore: depthScore,
                isPartial: isPartial,
                amendedAt: amendedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CheckInsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({checkInSymptomsRefs = false, checkInSubjectiveRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (checkInSymptomsRefs) db.checkInSymptoms,
                    if (checkInSubjectiveRefs) db.checkInSubjective,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (checkInSymptomsRefs)
                        await $_getPrefetchedData<
                          CheckIn,
                          $CheckInsTable,
                          CheckInSymptom
                        >(
                          currentTable: table,
                          referencedTable: $$CheckInsTableReferences
                              ._checkInSymptomsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CheckInsTableReferences(
                                db,
                                table,
                                p0,
                              ).checkInSymptomsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.checkInId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (checkInSubjectiveRefs)
                        await $_getPrefetchedData<
                          CheckIn,
                          $CheckInsTable,
                          CheckInSubjectiveData
                        >(
                          currentTable: table,
                          referencedTable: $$CheckInsTableReferences
                              ._checkInSubjectiveRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CheckInsTableReferences(
                                db,
                                table,
                                p0,
                              ).checkInSubjectiveRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.checkInId == item.id,
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

typedef $$CheckInsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CheckInsTable,
      CheckIn,
      $$CheckInsTableFilterComposer,
      $$CheckInsTableOrderingComposer,
      $$CheckInsTableAnnotationComposer,
      $$CheckInsTableCreateCompanionBuilder,
      $$CheckInsTableUpdateCompanionBuilder,
      (CheckIn, $$CheckInsTableReferences),
      CheckIn,
      PrefetchHooks Function({
        bool checkInSymptomsRefs,
        bool checkInSubjectiveRefs,
      })
    >;
typedef $$CheckInSymptomsTableCreateCompanionBuilder =
    CheckInSymptomsCompanion Function({
      required String id,
      required String checkInId,
      required String category,
      Value<int?> onsetDay,
      Value<String?> pattern,
      Value<int> rowid,
    });
typedef $$CheckInSymptomsTableUpdateCompanionBuilder =
    CheckInSymptomsCompanion Function({
      Value<String> id,
      Value<String> checkInId,
      Value<String> category,
      Value<int?> onsetDay,
      Value<String?> pattern,
      Value<int> rowid,
    });

final class $$CheckInSymptomsTableReferences
    extends
        BaseReferences<_$AppDatabase, $CheckInSymptomsTable, CheckInSymptom> {
  $$CheckInSymptomsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CheckInsTable _checkInIdTable(_$AppDatabase db) =>
      db.checkIns.createAlias(
        $_aliasNameGenerator(db.checkInSymptoms.checkInId, db.checkIns.id),
      );

  $$CheckInsTableProcessedTableManager get checkInId {
    final $_column = $_itemColumn<String>('check_in_id')!;

    final manager = $$CheckInsTableTableManager(
      $_db,
      $_db.checkIns,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_checkInIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SymptomFeverTable, List<SymptomFeverData>>
  _symptomFeverRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.symptomFever,
    aliasName: $_aliasNameGenerator(
      db.checkInSymptoms.id,
      db.symptomFever.symptomId,
    ),
  );

  $$SymptomFeverTableProcessedTableManager get symptomFeverRefs {
    final manager = $$SymptomFeverTableTableManager(
      $_db,
      $_db.symptomFever,
    ).filter((f) => f.symptomId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_symptomFeverRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SymptomPainTable, List<SymptomPainData>>
  _symptomPainRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.symptomPain,
    aliasName: $_aliasNameGenerator(
      db.checkInSymptoms.id,
      db.symptomPain.symptomId,
    ),
  );

  $$SymptomPainTableProcessedTableManager get symptomPainRefs {
    final manager = $$SymptomPainTableTableManager(
      $_db,
      $_db.symptomPain,
    ).filter((f) => f.symptomId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_symptomPainRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SymptomFatigueTable, List<SymptomFatigueData>>
  _symptomFatigueRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.symptomFatigue,
    aliasName: $_aliasNameGenerator(
      db.checkInSymptoms.id,
      db.symptomFatigue.symptomId,
    ),
  );

  $$SymptomFatigueTableProcessedTableManager get symptomFatigueRefs {
    final manager = $$SymptomFatigueTableTableManager(
      $_db,
      $_db.symptomFatigue,
    ).filter((f) => f.symptomId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_symptomFatigueRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SymptomNauseaTable, List<SymptomNauseaData>>
  _symptomNauseaRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.symptomNausea,
    aliasName: $_aliasNameGenerator(
      db.checkInSymptoms.id,
      db.symptomNausea.symptomId,
    ),
  );

  $$SymptomNauseaTableProcessedTableManager get symptomNauseaRefs {
    final manager = $$SymptomNauseaTableTableManager(
      $_db,
      $_db.symptomNausea,
    ).filter((f) => f.symptomId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_symptomNauseaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SymptomOtherTable, List<SymptomOtherData>>
  _symptomOtherRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.symptomOther,
    aliasName: $_aliasNameGenerator(
      db.checkInSymptoms.id,
      db.symptomOther.symptomId,
    ),
  );

  $$SymptomOtherTableProcessedTableManager get symptomOtherRefs {
    final manager = $$SymptomOtherTableTableManager(
      $_db,
      $_db.symptomOther,
    ).filter((f) => f.symptomId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_symptomOtherRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CheckInSymptomsTableFilterComposer
    extends Composer<_$AppDatabase, $CheckInSymptomsTable> {
  $$CheckInSymptomsTableFilterComposer({
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

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get onsetDay => $composableBuilder(
    column: $table.onsetDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnFilters(column),
  );

  $$CheckInsTableFilterComposer get checkInId {
    final $$CheckInsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkInId,
      referencedTable: $db.checkIns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInsTableFilterComposer(
            $db: $db,
            $table: $db.checkIns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> symptomFeverRefs(
    Expression<bool> Function($$SymptomFeverTableFilterComposer f) f,
  ) {
    final $$SymptomFeverTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.symptomFever,
      getReferencedColumn: (t) => t.symptomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomFeverTableFilterComposer(
            $db: $db,
            $table: $db.symptomFever,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> symptomPainRefs(
    Expression<bool> Function($$SymptomPainTableFilterComposer f) f,
  ) {
    final $$SymptomPainTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.symptomPain,
      getReferencedColumn: (t) => t.symptomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomPainTableFilterComposer(
            $db: $db,
            $table: $db.symptomPain,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> symptomFatigueRefs(
    Expression<bool> Function($$SymptomFatigueTableFilterComposer f) f,
  ) {
    final $$SymptomFatigueTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.symptomFatigue,
      getReferencedColumn: (t) => t.symptomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomFatigueTableFilterComposer(
            $db: $db,
            $table: $db.symptomFatigue,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> symptomNauseaRefs(
    Expression<bool> Function($$SymptomNauseaTableFilterComposer f) f,
  ) {
    final $$SymptomNauseaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.symptomNausea,
      getReferencedColumn: (t) => t.symptomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomNauseaTableFilterComposer(
            $db: $db,
            $table: $db.symptomNausea,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> symptomOtherRefs(
    Expression<bool> Function($$SymptomOtherTableFilterComposer f) f,
  ) {
    final $$SymptomOtherTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.symptomOther,
      getReferencedColumn: (t) => t.symptomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomOtherTableFilterComposer(
            $db: $db,
            $table: $db.symptomOther,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CheckInSymptomsTableOrderingComposer
    extends Composer<_$AppDatabase, $CheckInSymptomsTable> {
  $$CheckInSymptomsTableOrderingComposer({
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

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get onsetDay => $composableBuilder(
    column: $table.onsetDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnOrderings(column),
  );

  $$CheckInsTableOrderingComposer get checkInId {
    final $$CheckInsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkInId,
      referencedTable: $db.checkIns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInsTableOrderingComposer(
            $db: $db,
            $table: $db.checkIns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CheckInSymptomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CheckInSymptomsTable> {
  $$CheckInSymptomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get onsetDay =>
      $composableBuilder(column: $table.onsetDay, builder: (column) => column);

  GeneratedColumn<String> get pattern =>
      $composableBuilder(column: $table.pattern, builder: (column) => column);

  $$CheckInsTableAnnotationComposer get checkInId {
    final $$CheckInsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkInId,
      referencedTable: $db.checkIns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInsTableAnnotationComposer(
            $db: $db,
            $table: $db.checkIns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> symptomFeverRefs<T extends Object>(
    Expression<T> Function($$SymptomFeverTableAnnotationComposer a) f,
  ) {
    final $$SymptomFeverTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.symptomFever,
      getReferencedColumn: (t) => t.symptomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomFeverTableAnnotationComposer(
            $db: $db,
            $table: $db.symptomFever,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> symptomPainRefs<T extends Object>(
    Expression<T> Function($$SymptomPainTableAnnotationComposer a) f,
  ) {
    final $$SymptomPainTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.symptomPain,
      getReferencedColumn: (t) => t.symptomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomPainTableAnnotationComposer(
            $db: $db,
            $table: $db.symptomPain,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> symptomFatigueRefs<T extends Object>(
    Expression<T> Function($$SymptomFatigueTableAnnotationComposer a) f,
  ) {
    final $$SymptomFatigueTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.symptomFatigue,
      getReferencedColumn: (t) => t.symptomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomFatigueTableAnnotationComposer(
            $db: $db,
            $table: $db.symptomFatigue,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> symptomNauseaRefs<T extends Object>(
    Expression<T> Function($$SymptomNauseaTableAnnotationComposer a) f,
  ) {
    final $$SymptomNauseaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.symptomNausea,
      getReferencedColumn: (t) => t.symptomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomNauseaTableAnnotationComposer(
            $db: $db,
            $table: $db.symptomNausea,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> symptomOtherRefs<T extends Object>(
    Expression<T> Function($$SymptomOtherTableAnnotationComposer a) f,
  ) {
    final $$SymptomOtherTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.symptomOther,
      getReferencedColumn: (t) => t.symptomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomOtherTableAnnotationComposer(
            $db: $db,
            $table: $db.symptomOther,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CheckInSymptomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CheckInSymptomsTable,
          CheckInSymptom,
          $$CheckInSymptomsTableFilterComposer,
          $$CheckInSymptomsTableOrderingComposer,
          $$CheckInSymptomsTableAnnotationComposer,
          $$CheckInSymptomsTableCreateCompanionBuilder,
          $$CheckInSymptomsTableUpdateCompanionBuilder,
          (CheckInSymptom, $$CheckInSymptomsTableReferences),
          CheckInSymptom,
          PrefetchHooks Function({
            bool checkInId,
            bool symptomFeverRefs,
            bool symptomPainRefs,
            bool symptomFatigueRefs,
            bool symptomNauseaRefs,
            bool symptomOtherRefs,
          })
        > {
  $$CheckInSymptomsTableTableManager(
    _$AppDatabase db,
    $CheckInSymptomsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CheckInSymptomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CheckInSymptomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CheckInSymptomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> checkInId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int?> onsetDay = const Value.absent(),
                Value<String?> pattern = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CheckInSymptomsCompanion(
                id: id,
                checkInId: checkInId,
                category: category,
                onsetDay: onsetDay,
                pattern: pattern,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String checkInId,
                required String category,
                Value<int?> onsetDay = const Value.absent(),
                Value<String?> pattern = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CheckInSymptomsCompanion.insert(
                id: id,
                checkInId: checkInId,
                category: category,
                onsetDay: onsetDay,
                pattern: pattern,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CheckInSymptomsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                checkInId = false,
                symptomFeverRefs = false,
                symptomPainRefs = false,
                symptomFatigueRefs = false,
                symptomNauseaRefs = false,
                symptomOtherRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (symptomFeverRefs) db.symptomFever,
                    if (symptomPainRefs) db.symptomPain,
                    if (symptomFatigueRefs) db.symptomFatigue,
                    if (symptomNauseaRefs) db.symptomNausea,
                    if (symptomOtherRefs) db.symptomOther,
                  ],
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
                        if (checkInId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.checkInId,
                                    referencedTable:
                                        $$CheckInSymptomsTableReferences
                                            ._checkInIdTable(db),
                                    referencedColumn:
                                        $$CheckInSymptomsTableReferences
                                            ._checkInIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (symptomFeverRefs)
                        await $_getPrefetchedData<
                          CheckInSymptom,
                          $CheckInSymptomsTable,
                          SymptomFeverData
                        >(
                          currentTable: table,
                          referencedTable: $$CheckInSymptomsTableReferences
                              ._symptomFeverRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CheckInSymptomsTableReferences(
                                db,
                                table,
                                p0,
                              ).symptomFeverRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.symptomId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (symptomPainRefs)
                        await $_getPrefetchedData<
                          CheckInSymptom,
                          $CheckInSymptomsTable,
                          SymptomPainData
                        >(
                          currentTable: table,
                          referencedTable: $$CheckInSymptomsTableReferences
                              ._symptomPainRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CheckInSymptomsTableReferences(
                                db,
                                table,
                                p0,
                              ).symptomPainRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.symptomId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (symptomFatigueRefs)
                        await $_getPrefetchedData<
                          CheckInSymptom,
                          $CheckInSymptomsTable,
                          SymptomFatigueData
                        >(
                          currentTable: table,
                          referencedTable: $$CheckInSymptomsTableReferences
                              ._symptomFatigueRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CheckInSymptomsTableReferences(
                                db,
                                table,
                                p0,
                              ).symptomFatigueRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.symptomId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (symptomNauseaRefs)
                        await $_getPrefetchedData<
                          CheckInSymptom,
                          $CheckInSymptomsTable,
                          SymptomNauseaData
                        >(
                          currentTable: table,
                          referencedTable: $$CheckInSymptomsTableReferences
                              ._symptomNauseaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CheckInSymptomsTableReferences(
                                db,
                                table,
                                p0,
                              ).symptomNauseaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.symptomId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (symptomOtherRefs)
                        await $_getPrefetchedData<
                          CheckInSymptom,
                          $CheckInSymptomsTable,
                          SymptomOtherData
                        >(
                          currentTable: table,
                          referencedTable: $$CheckInSymptomsTableReferences
                              ._symptomOtherRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CheckInSymptomsTableReferences(
                                db,
                                table,
                                p0,
                              ).symptomOtherRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.symptomId == item.id,
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

typedef $$CheckInSymptomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CheckInSymptomsTable,
      CheckInSymptom,
      $$CheckInSymptomsTableFilterComposer,
      $$CheckInSymptomsTableOrderingComposer,
      $$CheckInSymptomsTableAnnotationComposer,
      $$CheckInSymptomsTableCreateCompanionBuilder,
      $$CheckInSymptomsTableUpdateCompanionBuilder,
      (CheckInSymptom, $$CheckInSymptomsTableReferences),
      CheckInSymptom,
      PrefetchHooks Function({
        bool checkInId,
        bool symptomFeverRefs,
        bool symptomPainRefs,
        bool symptomFatigueRefs,
        bool symptomNauseaRefs,
        bool symptomOtherRefs,
      })
    >;
typedef $$SymptomFeverTableCreateCompanionBuilder =
    SymptomFeverCompanion Function({
      required String symptomId,
      Value<double?> temperature,
      Value<String?> unit,
      Value<String?> method,
      Value<bool> skipped,
      Value<int> rowid,
    });
typedef $$SymptomFeverTableUpdateCompanionBuilder =
    SymptomFeverCompanion Function({
      Value<String> symptomId,
      Value<double?> temperature,
      Value<String?> unit,
      Value<String?> method,
      Value<bool> skipped,
      Value<int> rowid,
    });

final class $$SymptomFeverTableReferences
    extends
        BaseReferences<_$AppDatabase, $SymptomFeverTable, SymptomFeverData> {
  $$SymptomFeverTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CheckInSymptomsTable _symptomIdTable(_$AppDatabase db) =>
      db.checkInSymptoms.createAlias(
        $_aliasNameGenerator(db.symptomFever.symptomId, db.checkInSymptoms.id),
      );

  $$CheckInSymptomsTableProcessedTableManager get symptomId {
    final $_column = $_itemColumn<String>('symptom_id')!;

    final manager = $$CheckInSymptomsTableTableManager(
      $_db,
      $_db.checkInSymptoms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_symptomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SymptomFeverTableFilterComposer
    extends Composer<_$AppDatabase, $SymptomFeverTable> {
  $$SymptomFeverTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get skipped => $composableBuilder(
    column: $table.skipped,
    builder: (column) => ColumnFilters(column),
  );

  $$CheckInSymptomsTableFilterComposer get symptomId {
    final $$CheckInSymptomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomId,
      referencedTable: $db.checkInSymptoms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInSymptomsTableFilterComposer(
            $db: $db,
            $table: $db.checkInSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SymptomFeverTableOrderingComposer
    extends Composer<_$AppDatabase, $SymptomFeverTable> {
  $$SymptomFeverTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get skipped => $composableBuilder(
    column: $table.skipped,
    builder: (column) => ColumnOrderings(column),
  );

  $$CheckInSymptomsTableOrderingComposer get symptomId {
    final $$CheckInSymptomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomId,
      referencedTable: $db.checkInSymptoms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInSymptomsTableOrderingComposer(
            $db: $db,
            $table: $db.checkInSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SymptomFeverTableAnnotationComposer
    extends Composer<_$AppDatabase, $SymptomFeverTable> {
  $$SymptomFeverTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<bool> get skipped =>
      $composableBuilder(column: $table.skipped, builder: (column) => column);

  $$CheckInSymptomsTableAnnotationComposer get symptomId {
    final $$CheckInSymptomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomId,
      referencedTable: $db.checkInSymptoms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInSymptomsTableAnnotationComposer(
            $db: $db,
            $table: $db.checkInSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SymptomFeverTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SymptomFeverTable,
          SymptomFeverData,
          $$SymptomFeverTableFilterComposer,
          $$SymptomFeverTableOrderingComposer,
          $$SymptomFeverTableAnnotationComposer,
          $$SymptomFeverTableCreateCompanionBuilder,
          $$SymptomFeverTableUpdateCompanionBuilder,
          (SymptomFeverData, $$SymptomFeverTableReferences),
          SymptomFeverData,
          PrefetchHooks Function({bool symptomId})
        > {
  $$SymptomFeverTableTableManager(_$AppDatabase db, $SymptomFeverTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SymptomFeverTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SymptomFeverTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SymptomFeverTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> symptomId = const Value.absent(),
                Value<double?> temperature = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> method = const Value.absent(),
                Value<bool> skipped = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SymptomFeverCompanion(
                symptomId: symptomId,
                temperature: temperature,
                unit: unit,
                method: method,
                skipped: skipped,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String symptomId,
                Value<double?> temperature = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> method = const Value.absent(),
                Value<bool> skipped = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SymptomFeverCompanion.insert(
                symptomId: symptomId,
                temperature: temperature,
                unit: unit,
                method: method,
                skipped: skipped,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SymptomFeverTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({symptomId = false}) {
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
                    if (symptomId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.symptomId,
                                referencedTable: $$SymptomFeverTableReferences
                                    ._symptomIdTable(db),
                                referencedColumn: $$SymptomFeverTableReferences
                                    ._symptomIdTable(db)
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

typedef $$SymptomFeverTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SymptomFeverTable,
      SymptomFeverData,
      $$SymptomFeverTableFilterComposer,
      $$SymptomFeverTableOrderingComposer,
      $$SymptomFeverTableAnnotationComposer,
      $$SymptomFeverTableCreateCompanionBuilder,
      $$SymptomFeverTableUpdateCompanionBuilder,
      (SymptomFeverData, $$SymptomFeverTableReferences),
      SymptomFeverData,
      PrefetchHooks Function({bool symptomId})
    >;
typedef $$SymptomPainTableCreateCompanionBuilder =
    SymptomPainCompanion Function({
      required String symptomId,
      required String regionsJson,
      required String type,
      Value<String?> triggersJson,
      Value<int> rowid,
    });
typedef $$SymptomPainTableUpdateCompanionBuilder =
    SymptomPainCompanion Function({
      Value<String> symptomId,
      Value<String> regionsJson,
      Value<String> type,
      Value<String?> triggersJson,
      Value<int> rowid,
    });

final class $$SymptomPainTableReferences
    extends BaseReferences<_$AppDatabase, $SymptomPainTable, SymptomPainData> {
  $$SymptomPainTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CheckInSymptomsTable _symptomIdTable(_$AppDatabase db) =>
      db.checkInSymptoms.createAlias(
        $_aliasNameGenerator(db.symptomPain.symptomId, db.checkInSymptoms.id),
      );

  $$CheckInSymptomsTableProcessedTableManager get symptomId {
    final $_column = $_itemColumn<String>('symptom_id')!;

    final manager = $$CheckInSymptomsTableTableManager(
      $_db,
      $_db.checkInSymptoms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_symptomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SymptomPainTableFilterComposer
    extends Composer<_$AppDatabase, $SymptomPainTable> {
  $$SymptomPainTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get regionsJson => $composableBuilder(
    column: $table.regionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get triggersJson => $composableBuilder(
    column: $table.triggersJson,
    builder: (column) => ColumnFilters(column),
  );

  $$CheckInSymptomsTableFilterComposer get symptomId {
    final $$CheckInSymptomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomId,
      referencedTable: $db.checkInSymptoms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInSymptomsTableFilterComposer(
            $db: $db,
            $table: $db.checkInSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SymptomPainTableOrderingComposer
    extends Composer<_$AppDatabase, $SymptomPainTable> {
  $$SymptomPainTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get regionsJson => $composableBuilder(
    column: $table.regionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get triggersJson => $composableBuilder(
    column: $table.triggersJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$CheckInSymptomsTableOrderingComposer get symptomId {
    final $$CheckInSymptomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomId,
      referencedTable: $db.checkInSymptoms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInSymptomsTableOrderingComposer(
            $db: $db,
            $table: $db.checkInSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SymptomPainTableAnnotationComposer
    extends Composer<_$AppDatabase, $SymptomPainTable> {
  $$SymptomPainTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get regionsJson => $composableBuilder(
    column: $table.regionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get triggersJson => $composableBuilder(
    column: $table.triggersJson,
    builder: (column) => column,
  );

  $$CheckInSymptomsTableAnnotationComposer get symptomId {
    final $$CheckInSymptomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomId,
      referencedTable: $db.checkInSymptoms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInSymptomsTableAnnotationComposer(
            $db: $db,
            $table: $db.checkInSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SymptomPainTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SymptomPainTable,
          SymptomPainData,
          $$SymptomPainTableFilterComposer,
          $$SymptomPainTableOrderingComposer,
          $$SymptomPainTableAnnotationComposer,
          $$SymptomPainTableCreateCompanionBuilder,
          $$SymptomPainTableUpdateCompanionBuilder,
          (SymptomPainData, $$SymptomPainTableReferences),
          SymptomPainData,
          PrefetchHooks Function({bool symptomId})
        > {
  $$SymptomPainTableTableManager(_$AppDatabase db, $SymptomPainTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SymptomPainTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SymptomPainTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SymptomPainTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> symptomId = const Value.absent(),
                Value<String> regionsJson = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> triggersJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SymptomPainCompanion(
                symptomId: symptomId,
                regionsJson: regionsJson,
                type: type,
                triggersJson: triggersJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String symptomId,
                required String regionsJson,
                required String type,
                Value<String?> triggersJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SymptomPainCompanion.insert(
                symptomId: symptomId,
                regionsJson: regionsJson,
                type: type,
                triggersJson: triggersJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SymptomPainTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({symptomId = false}) {
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
                    if (symptomId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.symptomId,
                                referencedTable: $$SymptomPainTableReferences
                                    ._symptomIdTable(db),
                                referencedColumn: $$SymptomPainTableReferences
                                    ._symptomIdTable(db)
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

typedef $$SymptomPainTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SymptomPainTable,
      SymptomPainData,
      $$SymptomPainTableFilterComposer,
      $$SymptomPainTableOrderingComposer,
      $$SymptomPainTableAnnotationComposer,
      $$SymptomPainTableCreateCompanionBuilder,
      $$SymptomPainTableUpdateCompanionBuilder,
      (SymptomPainData, $$SymptomPainTableReferences),
      SymptomPainData,
      PrefetchHooks Function({bool symptomId})
    >;
typedef $$SymptomFatigueTableCreateCompanionBuilder =
    SymptomFatigueCompanion Function({
      required String symptomId,
      required String scope,
      required bool blocksDaily,
      Value<int> rowid,
    });
typedef $$SymptomFatigueTableUpdateCompanionBuilder =
    SymptomFatigueCompanion Function({
      Value<String> symptomId,
      Value<String> scope,
      Value<bool> blocksDaily,
      Value<int> rowid,
    });

final class $$SymptomFatigueTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SymptomFatigueTable,
          SymptomFatigueData
        > {
  $$SymptomFatigueTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CheckInSymptomsTable _symptomIdTable(_$AppDatabase db) =>
      db.checkInSymptoms.createAlias(
        $_aliasNameGenerator(
          db.symptomFatigue.symptomId,
          db.checkInSymptoms.id,
        ),
      );

  $$CheckInSymptomsTableProcessedTableManager get symptomId {
    final $_column = $_itemColumn<String>('symptom_id')!;

    final manager = $$CheckInSymptomsTableTableManager(
      $_db,
      $_db.checkInSymptoms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_symptomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SymptomFatigueTableFilterComposer
    extends Composer<_$AppDatabase, $SymptomFatigueTable> {
  $$SymptomFatigueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get blocksDaily => $composableBuilder(
    column: $table.blocksDaily,
    builder: (column) => ColumnFilters(column),
  );

  $$CheckInSymptomsTableFilterComposer get symptomId {
    final $$CheckInSymptomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomId,
      referencedTable: $db.checkInSymptoms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInSymptomsTableFilterComposer(
            $db: $db,
            $table: $db.checkInSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SymptomFatigueTableOrderingComposer
    extends Composer<_$AppDatabase, $SymptomFatigueTable> {
  $$SymptomFatigueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get blocksDaily => $composableBuilder(
    column: $table.blocksDaily,
    builder: (column) => ColumnOrderings(column),
  );

  $$CheckInSymptomsTableOrderingComposer get symptomId {
    final $$CheckInSymptomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomId,
      referencedTable: $db.checkInSymptoms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInSymptomsTableOrderingComposer(
            $db: $db,
            $table: $db.checkInSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SymptomFatigueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SymptomFatigueTable> {
  $$SymptomFatigueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get scope =>
      $composableBuilder(column: $table.scope, builder: (column) => column);

  GeneratedColumn<bool> get blocksDaily => $composableBuilder(
    column: $table.blocksDaily,
    builder: (column) => column,
  );

  $$CheckInSymptomsTableAnnotationComposer get symptomId {
    final $$CheckInSymptomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomId,
      referencedTable: $db.checkInSymptoms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInSymptomsTableAnnotationComposer(
            $db: $db,
            $table: $db.checkInSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SymptomFatigueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SymptomFatigueTable,
          SymptomFatigueData,
          $$SymptomFatigueTableFilterComposer,
          $$SymptomFatigueTableOrderingComposer,
          $$SymptomFatigueTableAnnotationComposer,
          $$SymptomFatigueTableCreateCompanionBuilder,
          $$SymptomFatigueTableUpdateCompanionBuilder,
          (SymptomFatigueData, $$SymptomFatigueTableReferences),
          SymptomFatigueData,
          PrefetchHooks Function({bool symptomId})
        > {
  $$SymptomFatigueTableTableManager(
    _$AppDatabase db,
    $SymptomFatigueTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SymptomFatigueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SymptomFatigueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SymptomFatigueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> symptomId = const Value.absent(),
                Value<String> scope = const Value.absent(),
                Value<bool> blocksDaily = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SymptomFatigueCompanion(
                symptomId: symptomId,
                scope: scope,
                blocksDaily: blocksDaily,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String symptomId,
                required String scope,
                required bool blocksDaily,
                Value<int> rowid = const Value.absent(),
              }) => SymptomFatigueCompanion.insert(
                symptomId: symptomId,
                scope: scope,
                blocksDaily: blocksDaily,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SymptomFatigueTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({symptomId = false}) {
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
                    if (symptomId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.symptomId,
                                referencedTable: $$SymptomFatigueTableReferences
                                    ._symptomIdTable(db),
                                referencedColumn:
                                    $$SymptomFatigueTableReferences
                                        ._symptomIdTable(db)
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

typedef $$SymptomFatigueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SymptomFatigueTable,
      SymptomFatigueData,
      $$SymptomFatigueTableFilterComposer,
      $$SymptomFatigueTableOrderingComposer,
      $$SymptomFatigueTableAnnotationComposer,
      $$SymptomFatigueTableCreateCompanionBuilder,
      $$SymptomFatigueTableUpdateCompanionBuilder,
      (SymptomFatigueData, $$SymptomFatigueTableReferences),
      SymptomFatigueData,
      PrefetchHooks Function({bool symptomId})
    >;
typedef $$SymptomNauseaTableCreateCompanionBuilder =
    SymptomNauseaCompanion Function({
      required String symptomId,
      required bool vomiting,
      Value<String?> vomitFreq,
      required String appetite,
      Value<String?> dehydrationSignsJson,
      Value<int> rowid,
    });
typedef $$SymptomNauseaTableUpdateCompanionBuilder =
    SymptomNauseaCompanion Function({
      Value<String> symptomId,
      Value<bool> vomiting,
      Value<String?> vomitFreq,
      Value<String> appetite,
      Value<String?> dehydrationSignsJson,
      Value<int> rowid,
    });

final class $$SymptomNauseaTableReferences
    extends
        BaseReferences<_$AppDatabase, $SymptomNauseaTable, SymptomNauseaData> {
  $$SymptomNauseaTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CheckInSymptomsTable _symptomIdTable(_$AppDatabase db) =>
      db.checkInSymptoms.createAlias(
        $_aliasNameGenerator(db.symptomNausea.symptomId, db.checkInSymptoms.id),
      );

  $$CheckInSymptomsTableProcessedTableManager get symptomId {
    final $_column = $_itemColumn<String>('symptom_id')!;

    final manager = $$CheckInSymptomsTableTableManager(
      $_db,
      $_db.checkInSymptoms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_symptomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SymptomNauseaTableFilterComposer
    extends Composer<_$AppDatabase, $SymptomNauseaTable> {
  $$SymptomNauseaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<bool> get vomiting => $composableBuilder(
    column: $table.vomiting,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vomitFreq => $composableBuilder(
    column: $table.vomitFreq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appetite => $composableBuilder(
    column: $table.appetite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dehydrationSignsJson => $composableBuilder(
    column: $table.dehydrationSignsJson,
    builder: (column) => ColumnFilters(column),
  );

  $$CheckInSymptomsTableFilterComposer get symptomId {
    final $$CheckInSymptomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomId,
      referencedTable: $db.checkInSymptoms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInSymptomsTableFilterComposer(
            $db: $db,
            $table: $db.checkInSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SymptomNauseaTableOrderingComposer
    extends Composer<_$AppDatabase, $SymptomNauseaTable> {
  $$SymptomNauseaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<bool> get vomiting => $composableBuilder(
    column: $table.vomiting,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vomitFreq => $composableBuilder(
    column: $table.vomitFreq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appetite => $composableBuilder(
    column: $table.appetite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dehydrationSignsJson => $composableBuilder(
    column: $table.dehydrationSignsJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$CheckInSymptomsTableOrderingComposer get symptomId {
    final $$CheckInSymptomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomId,
      referencedTable: $db.checkInSymptoms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInSymptomsTableOrderingComposer(
            $db: $db,
            $table: $db.checkInSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SymptomNauseaTableAnnotationComposer
    extends Composer<_$AppDatabase, $SymptomNauseaTable> {
  $$SymptomNauseaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<bool> get vomiting =>
      $composableBuilder(column: $table.vomiting, builder: (column) => column);

  GeneratedColumn<String> get vomitFreq =>
      $composableBuilder(column: $table.vomitFreq, builder: (column) => column);

  GeneratedColumn<String> get appetite =>
      $composableBuilder(column: $table.appetite, builder: (column) => column);

  GeneratedColumn<String> get dehydrationSignsJson => $composableBuilder(
    column: $table.dehydrationSignsJson,
    builder: (column) => column,
  );

  $$CheckInSymptomsTableAnnotationComposer get symptomId {
    final $$CheckInSymptomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomId,
      referencedTable: $db.checkInSymptoms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInSymptomsTableAnnotationComposer(
            $db: $db,
            $table: $db.checkInSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SymptomNauseaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SymptomNauseaTable,
          SymptomNauseaData,
          $$SymptomNauseaTableFilterComposer,
          $$SymptomNauseaTableOrderingComposer,
          $$SymptomNauseaTableAnnotationComposer,
          $$SymptomNauseaTableCreateCompanionBuilder,
          $$SymptomNauseaTableUpdateCompanionBuilder,
          (SymptomNauseaData, $$SymptomNauseaTableReferences),
          SymptomNauseaData,
          PrefetchHooks Function({bool symptomId})
        > {
  $$SymptomNauseaTableTableManager(_$AppDatabase db, $SymptomNauseaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SymptomNauseaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SymptomNauseaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SymptomNauseaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> symptomId = const Value.absent(),
                Value<bool> vomiting = const Value.absent(),
                Value<String?> vomitFreq = const Value.absent(),
                Value<String> appetite = const Value.absent(),
                Value<String?> dehydrationSignsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SymptomNauseaCompanion(
                symptomId: symptomId,
                vomiting: vomiting,
                vomitFreq: vomitFreq,
                appetite: appetite,
                dehydrationSignsJson: dehydrationSignsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String symptomId,
                required bool vomiting,
                Value<String?> vomitFreq = const Value.absent(),
                required String appetite,
                Value<String?> dehydrationSignsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SymptomNauseaCompanion.insert(
                symptomId: symptomId,
                vomiting: vomiting,
                vomitFreq: vomitFreq,
                appetite: appetite,
                dehydrationSignsJson: dehydrationSignsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SymptomNauseaTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({symptomId = false}) {
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
                    if (symptomId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.symptomId,
                                referencedTable: $$SymptomNauseaTableReferences
                                    ._symptomIdTable(db),
                                referencedColumn: $$SymptomNauseaTableReferences
                                    ._symptomIdTable(db)
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

typedef $$SymptomNauseaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SymptomNauseaTable,
      SymptomNauseaData,
      $$SymptomNauseaTableFilterComposer,
      $$SymptomNauseaTableOrderingComposer,
      $$SymptomNauseaTableAnnotationComposer,
      $$SymptomNauseaTableCreateCompanionBuilder,
      $$SymptomNauseaTableUpdateCompanionBuilder,
      (SymptomNauseaData, $$SymptomNauseaTableReferences),
      SymptomNauseaData,
      PrefetchHooks Function({bool symptomId})
    >;
typedef $$SymptomOtherTableCreateCompanionBuilder =
    SymptomOtherCompanion Function({
      required String symptomId,
      required String freeText,
      Value<String?> extractedDetailsJson,
      Value<int> rowid,
    });
typedef $$SymptomOtherTableUpdateCompanionBuilder =
    SymptomOtherCompanion Function({
      Value<String> symptomId,
      Value<String> freeText,
      Value<String?> extractedDetailsJson,
      Value<int> rowid,
    });

final class $$SymptomOtherTableReferences
    extends
        BaseReferences<_$AppDatabase, $SymptomOtherTable, SymptomOtherData> {
  $$SymptomOtherTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CheckInSymptomsTable _symptomIdTable(_$AppDatabase db) =>
      db.checkInSymptoms.createAlias(
        $_aliasNameGenerator(db.symptomOther.symptomId, db.checkInSymptoms.id),
      );

  $$CheckInSymptomsTableProcessedTableManager get symptomId {
    final $_column = $_itemColumn<String>('symptom_id')!;

    final manager = $$CheckInSymptomsTableTableManager(
      $_db,
      $_db.checkInSymptoms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_symptomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SymptomOtherTableFilterComposer
    extends Composer<_$AppDatabase, $SymptomOtherTable> {
  $$SymptomOtherTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get freeText => $composableBuilder(
    column: $table.freeText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extractedDetailsJson => $composableBuilder(
    column: $table.extractedDetailsJson,
    builder: (column) => ColumnFilters(column),
  );

  $$CheckInSymptomsTableFilterComposer get symptomId {
    final $$CheckInSymptomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomId,
      referencedTable: $db.checkInSymptoms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInSymptomsTableFilterComposer(
            $db: $db,
            $table: $db.checkInSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SymptomOtherTableOrderingComposer
    extends Composer<_$AppDatabase, $SymptomOtherTable> {
  $$SymptomOtherTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get freeText => $composableBuilder(
    column: $table.freeText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extractedDetailsJson => $composableBuilder(
    column: $table.extractedDetailsJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$CheckInSymptomsTableOrderingComposer get symptomId {
    final $$CheckInSymptomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomId,
      referencedTable: $db.checkInSymptoms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInSymptomsTableOrderingComposer(
            $db: $db,
            $table: $db.checkInSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SymptomOtherTableAnnotationComposer
    extends Composer<_$AppDatabase, $SymptomOtherTable> {
  $$SymptomOtherTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get freeText =>
      $composableBuilder(column: $table.freeText, builder: (column) => column);

  GeneratedColumn<String> get extractedDetailsJson => $composableBuilder(
    column: $table.extractedDetailsJson,
    builder: (column) => column,
  );

  $$CheckInSymptomsTableAnnotationComposer get symptomId {
    final $$CheckInSymptomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomId,
      referencedTable: $db.checkInSymptoms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInSymptomsTableAnnotationComposer(
            $db: $db,
            $table: $db.checkInSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SymptomOtherTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SymptomOtherTable,
          SymptomOtherData,
          $$SymptomOtherTableFilterComposer,
          $$SymptomOtherTableOrderingComposer,
          $$SymptomOtherTableAnnotationComposer,
          $$SymptomOtherTableCreateCompanionBuilder,
          $$SymptomOtherTableUpdateCompanionBuilder,
          (SymptomOtherData, $$SymptomOtherTableReferences),
          SymptomOtherData,
          PrefetchHooks Function({bool symptomId})
        > {
  $$SymptomOtherTableTableManager(_$AppDatabase db, $SymptomOtherTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SymptomOtherTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SymptomOtherTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SymptomOtherTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> symptomId = const Value.absent(),
                Value<String> freeText = const Value.absent(),
                Value<String?> extractedDetailsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SymptomOtherCompanion(
                symptomId: symptomId,
                freeText: freeText,
                extractedDetailsJson: extractedDetailsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String symptomId,
                required String freeText,
                Value<String?> extractedDetailsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SymptomOtherCompanion.insert(
                symptomId: symptomId,
                freeText: freeText,
                extractedDetailsJson: extractedDetailsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SymptomOtherTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({symptomId = false}) {
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
                    if (symptomId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.symptomId,
                                referencedTable: $$SymptomOtherTableReferences
                                    ._symptomIdTable(db),
                                referencedColumn: $$SymptomOtherTableReferences
                                    ._symptomIdTable(db)
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

typedef $$SymptomOtherTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SymptomOtherTable,
      SymptomOtherData,
      $$SymptomOtherTableFilterComposer,
      $$SymptomOtherTableOrderingComposer,
      $$SymptomOtherTableAnnotationComposer,
      $$SymptomOtherTableCreateCompanionBuilder,
      $$SymptomOtherTableUpdateCompanionBuilder,
      (SymptomOtherData, $$SymptomOtherTableReferences),
      SymptomOtherData,
      PrefetchHooks Function({bool symptomId})
    >;
typedef $$CheckInSubjectiveTableCreateCompanionBuilder =
    CheckInSubjectiveCompanion Function({
      required String checkInId,
      Value<String?> freeNotes,
      Value<String?> slmTagsJson,
      Value<String?> followUpExchangesJson,
      Value<int> rowid,
    });
typedef $$CheckInSubjectiveTableUpdateCompanionBuilder =
    CheckInSubjectiveCompanion Function({
      Value<String> checkInId,
      Value<String?> freeNotes,
      Value<String?> slmTagsJson,
      Value<String?> followUpExchangesJson,
      Value<int> rowid,
    });

final class $$CheckInSubjectiveTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CheckInSubjectiveTable,
          CheckInSubjectiveData
        > {
  $$CheckInSubjectiveTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CheckInsTable _checkInIdTable(_$AppDatabase db) =>
      db.checkIns.createAlias(
        $_aliasNameGenerator(db.checkInSubjective.checkInId, db.checkIns.id),
      );

  $$CheckInsTableProcessedTableManager get checkInId {
    final $_column = $_itemColumn<String>('check_in_id')!;

    final manager = $$CheckInsTableTableManager(
      $_db,
      $_db.checkIns,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_checkInIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CheckInSubjectiveTableFilterComposer
    extends Composer<_$AppDatabase, $CheckInSubjectiveTable> {
  $$CheckInSubjectiveTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get freeNotes => $composableBuilder(
    column: $table.freeNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slmTagsJson => $composableBuilder(
    column: $table.slmTagsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get followUpExchangesJson => $composableBuilder(
    column: $table.followUpExchangesJson,
    builder: (column) => ColumnFilters(column),
  );

  $$CheckInsTableFilterComposer get checkInId {
    final $$CheckInsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkInId,
      referencedTable: $db.checkIns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInsTableFilterComposer(
            $db: $db,
            $table: $db.checkIns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CheckInSubjectiveTableOrderingComposer
    extends Composer<_$AppDatabase, $CheckInSubjectiveTable> {
  $$CheckInSubjectiveTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get freeNotes => $composableBuilder(
    column: $table.freeNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slmTagsJson => $composableBuilder(
    column: $table.slmTagsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get followUpExchangesJson => $composableBuilder(
    column: $table.followUpExchangesJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$CheckInsTableOrderingComposer get checkInId {
    final $$CheckInsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkInId,
      referencedTable: $db.checkIns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInsTableOrderingComposer(
            $db: $db,
            $table: $db.checkIns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CheckInSubjectiveTableAnnotationComposer
    extends Composer<_$AppDatabase, $CheckInSubjectiveTable> {
  $$CheckInSubjectiveTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get freeNotes =>
      $composableBuilder(column: $table.freeNotes, builder: (column) => column);

  GeneratedColumn<String> get slmTagsJson => $composableBuilder(
    column: $table.slmTagsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get followUpExchangesJson => $composableBuilder(
    column: $table.followUpExchangesJson,
    builder: (column) => column,
  );

  $$CheckInsTableAnnotationComposer get checkInId {
    final $$CheckInsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkInId,
      referencedTable: $db.checkIns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckInsTableAnnotationComposer(
            $db: $db,
            $table: $db.checkIns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CheckInSubjectiveTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CheckInSubjectiveTable,
          CheckInSubjectiveData,
          $$CheckInSubjectiveTableFilterComposer,
          $$CheckInSubjectiveTableOrderingComposer,
          $$CheckInSubjectiveTableAnnotationComposer,
          $$CheckInSubjectiveTableCreateCompanionBuilder,
          $$CheckInSubjectiveTableUpdateCompanionBuilder,
          (CheckInSubjectiveData, $$CheckInSubjectiveTableReferences),
          CheckInSubjectiveData,
          PrefetchHooks Function({bool checkInId})
        > {
  $$CheckInSubjectiveTableTableManager(
    _$AppDatabase db,
    $CheckInSubjectiveTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CheckInSubjectiveTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CheckInSubjectiveTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CheckInSubjectiveTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> checkInId = const Value.absent(),
                Value<String?> freeNotes = const Value.absent(),
                Value<String?> slmTagsJson = const Value.absent(),
                Value<String?> followUpExchangesJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CheckInSubjectiveCompanion(
                checkInId: checkInId,
                freeNotes: freeNotes,
                slmTagsJson: slmTagsJson,
                followUpExchangesJson: followUpExchangesJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String checkInId,
                Value<String?> freeNotes = const Value.absent(),
                Value<String?> slmTagsJson = const Value.absent(),
                Value<String?> followUpExchangesJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CheckInSubjectiveCompanion.insert(
                checkInId: checkInId,
                freeNotes: freeNotes,
                slmTagsJson: slmTagsJson,
                followUpExchangesJson: followUpExchangesJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CheckInSubjectiveTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({checkInId = false}) {
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
                    if (checkInId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.checkInId,
                                referencedTable:
                                    $$CheckInSubjectiveTableReferences
                                        ._checkInIdTable(db),
                                referencedColumn:
                                    $$CheckInSubjectiveTableReferences
                                        ._checkInIdTable(db)
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

typedef $$CheckInSubjectiveTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CheckInSubjectiveTable,
      CheckInSubjectiveData,
      $$CheckInSubjectiveTableFilterComposer,
      $$CheckInSubjectiveTableOrderingComposer,
      $$CheckInSubjectiveTableAnnotationComposer,
      $$CheckInSubjectiveTableCreateCompanionBuilder,
      $$CheckInSubjectiveTableUpdateCompanionBuilder,
      (CheckInSubjectiveData, $$CheckInSubjectiveTableReferences),
      CheckInSubjectiveData,
      PrefetchHooks Function({bool checkInId})
    >;
typedef $$PetStateTableTableCreateCompanionBuilder =
    PetStateTableCompanion Function({
      required String petId,
      required String name,
      required String species,
      Value<int> vitality,
      Value<int> streak,
      Value<String?> lastCheckinUtc,
      Value<bool> calmMode,
      Value<int> consecutiveBadDays,
      Value<bool> freezeAvailable,
      Value<String?> freezeLastUsedDate,
      Value<String?> deletionScheduledAt,
      Value<bool> vulnerabilityCardShown,
      Value<bool> vulnerabilityFrozen,
      Value<int> rowid,
    });
typedef $$PetStateTableTableUpdateCompanionBuilder =
    PetStateTableCompanion Function({
      Value<String> petId,
      Value<String> name,
      Value<String> species,
      Value<int> vitality,
      Value<int> streak,
      Value<String?> lastCheckinUtc,
      Value<bool> calmMode,
      Value<int> consecutiveBadDays,
      Value<bool> freezeAvailable,
      Value<String?> freezeLastUsedDate,
      Value<String?> deletionScheduledAt,
      Value<bool> vulnerabilityCardShown,
      Value<bool> vulnerabilityFrozen,
      Value<int> rowid,
    });

class $$PetStateTableTableFilterComposer
    extends Composer<_$AppDatabase, $PetStateTableTable> {
  $$PetStateTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get petId => $composableBuilder(
    column: $table.petId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get species => $composableBuilder(
    column: $table.species,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get vitality => $composableBuilder(
    column: $table.vitality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get streak => $composableBuilder(
    column: $table.streak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastCheckinUtc => $composableBuilder(
    column: $table.lastCheckinUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get calmMode => $composableBuilder(
    column: $table.calmMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get consecutiveBadDays => $composableBuilder(
    column: $table.consecutiveBadDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get freezeAvailable => $composableBuilder(
    column: $table.freezeAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get freezeLastUsedDate => $composableBuilder(
    column: $table.freezeLastUsedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletionScheduledAt => $composableBuilder(
    column: $table.deletionScheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get vulnerabilityCardShown => $composableBuilder(
    column: $table.vulnerabilityCardShown,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get vulnerabilityFrozen => $composableBuilder(
    column: $table.vulnerabilityFrozen,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PetStateTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PetStateTableTable> {
  $$PetStateTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get petId => $composableBuilder(
    column: $table.petId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get species => $composableBuilder(
    column: $table.species,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vitality => $composableBuilder(
    column: $table.vitality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get streak => $composableBuilder(
    column: $table.streak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastCheckinUtc => $composableBuilder(
    column: $table.lastCheckinUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get calmMode => $composableBuilder(
    column: $table.calmMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get consecutiveBadDays => $composableBuilder(
    column: $table.consecutiveBadDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get freezeAvailable => $composableBuilder(
    column: $table.freezeAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get freezeLastUsedDate => $composableBuilder(
    column: $table.freezeLastUsedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletionScheduledAt => $composableBuilder(
    column: $table.deletionScheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get vulnerabilityCardShown => $composableBuilder(
    column: $table.vulnerabilityCardShown,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get vulnerabilityFrozen => $composableBuilder(
    column: $table.vulnerabilityFrozen,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PetStateTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PetStateTableTable> {
  $$PetStateTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get petId =>
      $composableBuilder(column: $table.petId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get species =>
      $composableBuilder(column: $table.species, builder: (column) => column);

  GeneratedColumn<int> get vitality =>
      $composableBuilder(column: $table.vitality, builder: (column) => column);

  GeneratedColumn<int> get streak =>
      $composableBuilder(column: $table.streak, builder: (column) => column);

  GeneratedColumn<String> get lastCheckinUtc => $composableBuilder(
    column: $table.lastCheckinUtc,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get calmMode =>
      $composableBuilder(column: $table.calmMode, builder: (column) => column);

  GeneratedColumn<int> get consecutiveBadDays => $composableBuilder(
    column: $table.consecutiveBadDays,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get freezeAvailable => $composableBuilder(
    column: $table.freezeAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get freezeLastUsedDate => $composableBuilder(
    column: $table.freezeLastUsedDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deletionScheduledAt => $composableBuilder(
    column: $table.deletionScheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get vulnerabilityCardShown => $composableBuilder(
    column: $table.vulnerabilityCardShown,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get vulnerabilityFrozen => $composableBuilder(
    column: $table.vulnerabilityFrozen,
    builder: (column) => column,
  );
}

class $$PetStateTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PetStateTableTable,
          PetStateTableData,
          $$PetStateTableTableFilterComposer,
          $$PetStateTableTableOrderingComposer,
          $$PetStateTableTableAnnotationComposer,
          $$PetStateTableTableCreateCompanionBuilder,
          $$PetStateTableTableUpdateCompanionBuilder,
          (
            PetStateTableData,
            BaseReferences<
              _$AppDatabase,
              $PetStateTableTable,
              PetStateTableData
            >,
          ),
          PetStateTableData,
          PrefetchHooks Function()
        > {
  $$PetStateTableTableTableManager(_$AppDatabase db, $PetStateTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PetStateTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PetStateTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PetStateTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> petId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> species = const Value.absent(),
                Value<int> vitality = const Value.absent(),
                Value<int> streak = const Value.absent(),
                Value<String?> lastCheckinUtc = const Value.absent(),
                Value<bool> calmMode = const Value.absent(),
                Value<int> consecutiveBadDays = const Value.absent(),
                Value<bool> freezeAvailable = const Value.absent(),
                Value<String?> freezeLastUsedDate = const Value.absent(),
                Value<String?> deletionScheduledAt = const Value.absent(),
                Value<bool> vulnerabilityCardShown = const Value.absent(),
                Value<bool> vulnerabilityFrozen = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PetStateTableCompanion(
                petId: petId,
                name: name,
                species: species,
                vitality: vitality,
                streak: streak,
                lastCheckinUtc: lastCheckinUtc,
                calmMode: calmMode,
                consecutiveBadDays: consecutiveBadDays,
                freezeAvailable: freezeAvailable,
                freezeLastUsedDate: freezeLastUsedDate,
                deletionScheduledAt: deletionScheduledAt,
                vulnerabilityCardShown: vulnerabilityCardShown,
                vulnerabilityFrozen: vulnerabilityFrozen,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String petId,
                required String name,
                required String species,
                Value<int> vitality = const Value.absent(),
                Value<int> streak = const Value.absent(),
                Value<String?> lastCheckinUtc = const Value.absent(),
                Value<bool> calmMode = const Value.absent(),
                Value<int> consecutiveBadDays = const Value.absent(),
                Value<bool> freezeAvailable = const Value.absent(),
                Value<String?> freezeLastUsedDate = const Value.absent(),
                Value<String?> deletionScheduledAt = const Value.absent(),
                Value<bool> vulnerabilityCardShown = const Value.absent(),
                Value<bool> vulnerabilityFrozen = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PetStateTableCompanion.insert(
                petId: petId,
                name: name,
                species: species,
                vitality: vitality,
                streak: streak,
                lastCheckinUtc: lastCheckinUtc,
                calmMode: calmMode,
                consecutiveBadDays: consecutiveBadDays,
                freezeAvailable: freezeAvailable,
                freezeLastUsedDate: freezeLastUsedDate,
                deletionScheduledAt: deletionScheduledAt,
                vulnerabilityCardShown: vulnerabilityCardShown,
                vulnerabilityFrozen: vulnerabilityFrozen,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PetStateTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PetStateTableTable,
      PetStateTableData,
      $$PetStateTableTableFilterComposer,
      $$PetStateTableTableOrderingComposer,
      $$PetStateTableTableAnnotationComposer,
      $$PetStateTableTableCreateCompanionBuilder,
      $$PetStateTableTableUpdateCompanionBuilder,
      (
        PetStateTableData,
        BaseReferences<_$AppDatabase, $PetStateTableTable, PetStateTableData>,
      ),
      PetStateTableData,
      PrefetchHooks Function()
    >;
typedef $$BaselineStatsTableCreateCompanionBuilder =
    BaselineStatsCompanion Function({
      required String metric,
      required double mean14d,
      required double stddev14d,
      required int sampleCount,
      required String lastComputedUtc,
      Value<int> rowid,
    });
typedef $$BaselineStatsTableUpdateCompanionBuilder =
    BaselineStatsCompanion Function({
      Value<String> metric,
      Value<double> mean14d,
      Value<double> stddev14d,
      Value<int> sampleCount,
      Value<String> lastComputedUtc,
      Value<int> rowid,
    });

class $$BaselineStatsTableFilterComposer
    extends Composer<_$AppDatabase, $BaselineStatsTable> {
  $$BaselineStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get metric => $composableBuilder(
    column: $table.metric,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get mean14d => $composableBuilder(
    column: $table.mean14d,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stddev14d => $composableBuilder(
    column: $table.stddev14d,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sampleCount => $composableBuilder(
    column: $table.sampleCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastComputedUtc => $composableBuilder(
    column: $table.lastComputedUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BaselineStatsTableOrderingComposer
    extends Composer<_$AppDatabase, $BaselineStatsTable> {
  $$BaselineStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get metric => $composableBuilder(
    column: $table.metric,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get mean14d => $composableBuilder(
    column: $table.mean14d,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stddev14d => $composableBuilder(
    column: $table.stddev14d,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sampleCount => $composableBuilder(
    column: $table.sampleCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastComputedUtc => $composableBuilder(
    column: $table.lastComputedUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BaselineStatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BaselineStatsTable> {
  $$BaselineStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get metric =>
      $composableBuilder(column: $table.metric, builder: (column) => column);

  GeneratedColumn<double> get mean14d =>
      $composableBuilder(column: $table.mean14d, builder: (column) => column);

  GeneratedColumn<double> get stddev14d =>
      $composableBuilder(column: $table.stddev14d, builder: (column) => column);

  GeneratedColumn<int> get sampleCount => $composableBuilder(
    column: $table.sampleCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastComputedUtc => $composableBuilder(
    column: $table.lastComputedUtc,
    builder: (column) => column,
  );
}

class $$BaselineStatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BaselineStatsTable,
          BaselineStat,
          $$BaselineStatsTableFilterComposer,
          $$BaselineStatsTableOrderingComposer,
          $$BaselineStatsTableAnnotationComposer,
          $$BaselineStatsTableCreateCompanionBuilder,
          $$BaselineStatsTableUpdateCompanionBuilder,
          (
            BaselineStat,
            BaseReferences<_$AppDatabase, $BaselineStatsTable, BaselineStat>,
          ),
          BaselineStat,
          PrefetchHooks Function()
        > {
  $$BaselineStatsTableTableManager(_$AppDatabase db, $BaselineStatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BaselineStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BaselineStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BaselineStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> metric = const Value.absent(),
                Value<double> mean14d = const Value.absent(),
                Value<double> stddev14d = const Value.absent(),
                Value<int> sampleCount = const Value.absent(),
                Value<String> lastComputedUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BaselineStatsCompanion(
                metric: metric,
                mean14d: mean14d,
                stddev14d: stddev14d,
                sampleCount: sampleCount,
                lastComputedUtc: lastComputedUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String metric,
                required double mean14d,
                required double stddev14d,
                required int sampleCount,
                required String lastComputedUtc,
                Value<int> rowid = const Value.absent(),
              }) => BaselineStatsCompanion.insert(
                metric: metric,
                mean14d: mean14d,
                stddev14d: stddev14d,
                sampleCount: sampleCount,
                lastComputedUtc: lastComputedUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BaselineStatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BaselineStatsTable,
      BaselineStat,
      $$BaselineStatsTableFilterComposer,
      $$BaselineStatsTableOrderingComposer,
      $$BaselineStatsTableAnnotationComposer,
      $$BaselineStatsTableCreateCompanionBuilder,
      $$BaselineStatsTableUpdateCompanionBuilder,
      (
        BaselineStat,
        BaseReferences<_$AppDatabase, $BaselineStatsTable, BaselineStat>,
      ),
      BaselineStat,
      PrefetchHooks Function()
    >;
typedef $$AuditLogTableCreateCompanionBuilder =
    AuditLogCompanion Function({
      Value<int> id,
      required String eventType,
      required String utcTimestamp,
      Value<String?> sessionId,
      Value<String?> payloadHash,
    });
typedef $$AuditLogTableUpdateCompanionBuilder =
    AuditLogCompanion Function({
      Value<int> id,
      Value<String> eventType,
      Value<String> utcTimestamp,
      Value<String?> sessionId,
      Value<String?> payloadHash,
    });

class $$AuditLogTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get utcTimestamp => $composableBuilder(
    column: $table.utcTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadHash => $composableBuilder(
    column: $table.payloadHash,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuditLogTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get utcTimestamp => $composableBuilder(
    column: $table.utcTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadHash => $composableBuilder(
    column: $table.payloadHash,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuditLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get utcTimestamp => $composableBuilder(
    column: $table.utcTimestamp,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get payloadHash => $composableBuilder(
    column: $table.payloadHash,
    builder: (column) => column,
  );
}

class $$AuditLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditLogTable,
          AuditLogData,
          $$AuditLogTableFilterComposer,
          $$AuditLogTableOrderingComposer,
          $$AuditLogTableAnnotationComposer,
          $$AuditLogTableCreateCompanionBuilder,
          $$AuditLogTableUpdateCompanionBuilder,
          (
            AuditLogData,
            BaseReferences<_$AppDatabase, $AuditLogTable, AuditLogData>,
          ),
          AuditLogData,
          PrefetchHooks Function()
        > {
  $$AuditLogTableTableManager(_$AppDatabase db, $AuditLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<String> utcTimestamp = const Value.absent(),
                Value<String?> sessionId = const Value.absent(),
                Value<String?> payloadHash = const Value.absent(),
              }) => AuditLogCompanion(
                id: id,
                eventType: eventType,
                utcTimestamp: utcTimestamp,
                sessionId: sessionId,
                payloadHash: payloadHash,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String eventType,
                required String utcTimestamp,
                Value<String?> sessionId = const Value.absent(),
                Value<String?> payloadHash = const Value.absent(),
              }) => AuditLogCompanion.insert(
                id: id,
                eventType: eventType,
                utcTimestamp: utcTimestamp,
                sessionId: sessionId,
                payloadHash: payloadHash,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuditLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditLogTable,
      AuditLogData,
      $$AuditLogTableFilterComposer,
      $$AuditLogTableOrderingComposer,
      $$AuditLogTableAnnotationComposer,
      $$AuditLogTableCreateCompanionBuilder,
      $$AuditLogTableUpdateCompanionBuilder,
      (
        AuditLogData,
        BaseReferences<_$AppDatabase, $AuditLogTable, AuditLogData>,
      ),
      AuditLogData,
      PrefetchHooks Function()
    >;
typedef $$SlmContextCacheTableCreateCompanionBuilder =
    SlmContextCacheCompanion Function({
      required String date,
      required String contextSnapshot,
      Value<int> rowid,
    });
typedef $$SlmContextCacheTableUpdateCompanionBuilder =
    SlmContextCacheCompanion Function({
      Value<String> date,
      Value<String> contextSnapshot,
      Value<int> rowid,
    });

class $$SlmContextCacheTableFilterComposer
    extends Composer<_$AppDatabase, $SlmContextCacheTable> {
  $$SlmContextCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contextSnapshot => $composableBuilder(
    column: $table.contextSnapshot,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SlmContextCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $SlmContextCacheTable> {
  $$SlmContextCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contextSnapshot => $composableBuilder(
    column: $table.contextSnapshot,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SlmContextCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $SlmContextCacheTable> {
  $$SlmContextCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get contextSnapshot => $composableBuilder(
    column: $table.contextSnapshot,
    builder: (column) => column,
  );
}

class $$SlmContextCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SlmContextCacheTable,
          SlmContextCacheData,
          $$SlmContextCacheTableFilterComposer,
          $$SlmContextCacheTableOrderingComposer,
          $$SlmContextCacheTableAnnotationComposer,
          $$SlmContextCacheTableCreateCompanionBuilder,
          $$SlmContextCacheTableUpdateCompanionBuilder,
          (
            SlmContextCacheData,
            BaseReferences<
              _$AppDatabase,
              $SlmContextCacheTable,
              SlmContextCacheData
            >,
          ),
          SlmContextCacheData,
          PrefetchHooks Function()
        > {
  $$SlmContextCacheTableTableManager(
    _$AppDatabase db,
    $SlmContextCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SlmContextCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SlmContextCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SlmContextCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<String> contextSnapshot = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SlmContextCacheCompanion(
                date: date,
                contextSnapshot: contextSnapshot,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                required String contextSnapshot,
                Value<int> rowid = const Value.absent(),
              }) => SlmContextCacheCompanion.insert(
                date: date,
                contextSnapshot: contextSnapshot,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SlmContextCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SlmContextCacheTable,
      SlmContextCacheData,
      $$SlmContextCacheTableFilterComposer,
      $$SlmContextCacheTableOrderingComposer,
      $$SlmContextCacheTableAnnotationComposer,
      $$SlmContextCacheTableCreateCompanionBuilder,
      $$SlmContextCacheTableUpdateCompanionBuilder,
      (
        SlmContextCacheData,
        BaseReferences<
          _$AppDatabase,
          $SlmContextCacheTable,
          SlmContextCacheData
        >,
      ),
      SlmContextCacheData,
      PrefetchHooks Function()
    >;
typedef $$PetArchiveTableCreateCompanionBuilder =
    PetArchiveCompanion Function({
      required String id,
      required String name,
      required String species,
      required int lifespanDays,
      required int totalCheckins,
      Value<String?> topSymptom,
      required String diedAtUtc,
      Value<int> rowid,
    });
typedef $$PetArchiveTableUpdateCompanionBuilder =
    PetArchiveCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> species,
      Value<int> lifespanDays,
      Value<int> totalCheckins,
      Value<String?> topSymptom,
      Value<String> diedAtUtc,
      Value<int> rowid,
    });

class $$PetArchiveTableFilterComposer
    extends Composer<_$AppDatabase, $PetArchiveTable> {
  $$PetArchiveTableFilterComposer({
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

  ColumnFilters<String> get species => $composableBuilder(
    column: $table.species,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lifespanDays => $composableBuilder(
    column: $table.lifespanDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCheckins => $composableBuilder(
    column: $table.totalCheckins,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topSymptom => $composableBuilder(
    column: $table.topSymptom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diedAtUtc => $composableBuilder(
    column: $table.diedAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PetArchiveTableOrderingComposer
    extends Composer<_$AppDatabase, $PetArchiveTable> {
  $$PetArchiveTableOrderingComposer({
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

  ColumnOrderings<String> get species => $composableBuilder(
    column: $table.species,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lifespanDays => $composableBuilder(
    column: $table.lifespanDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCheckins => $composableBuilder(
    column: $table.totalCheckins,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topSymptom => $composableBuilder(
    column: $table.topSymptom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diedAtUtc => $composableBuilder(
    column: $table.diedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PetArchiveTableAnnotationComposer
    extends Composer<_$AppDatabase, $PetArchiveTable> {
  $$PetArchiveTableAnnotationComposer({
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

  GeneratedColumn<String> get species =>
      $composableBuilder(column: $table.species, builder: (column) => column);

  GeneratedColumn<int> get lifespanDays => $composableBuilder(
    column: $table.lifespanDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalCheckins => $composableBuilder(
    column: $table.totalCheckins,
    builder: (column) => column,
  );

  GeneratedColumn<String> get topSymptom => $composableBuilder(
    column: $table.topSymptom,
    builder: (column) => column,
  );

  GeneratedColumn<String> get diedAtUtc =>
      $composableBuilder(column: $table.diedAtUtc, builder: (column) => column);
}

class $$PetArchiveTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PetArchiveTable,
          PetArchiveData,
          $$PetArchiveTableFilterComposer,
          $$PetArchiveTableOrderingComposer,
          $$PetArchiveTableAnnotationComposer,
          $$PetArchiveTableCreateCompanionBuilder,
          $$PetArchiveTableUpdateCompanionBuilder,
          (
            PetArchiveData,
            BaseReferences<_$AppDatabase, $PetArchiveTable, PetArchiveData>,
          ),
          PetArchiveData,
          PrefetchHooks Function()
        > {
  $$PetArchiveTableTableManager(_$AppDatabase db, $PetArchiveTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PetArchiveTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PetArchiveTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PetArchiveTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> species = const Value.absent(),
                Value<int> lifespanDays = const Value.absent(),
                Value<int> totalCheckins = const Value.absent(),
                Value<String?> topSymptom = const Value.absent(),
                Value<String> diedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PetArchiveCompanion(
                id: id,
                name: name,
                species: species,
                lifespanDays: lifespanDays,
                totalCheckins: totalCheckins,
                topSymptom: topSymptom,
                diedAtUtc: diedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String species,
                required int lifespanDays,
                required int totalCheckins,
                Value<String?> topSymptom = const Value.absent(),
                required String diedAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => PetArchiveCompanion.insert(
                id: id,
                name: name,
                species: species,
                lifespanDays: lifespanDays,
                totalCheckins: totalCheckins,
                topSymptom: topSymptom,
                diedAtUtc: diedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PetArchiveTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PetArchiveTable,
      PetArchiveData,
      $$PetArchiveTableFilterComposer,
      $$PetArchiveTableOrderingComposer,
      $$PetArchiveTableAnnotationComposer,
      $$PetArchiveTableCreateCompanionBuilder,
      $$PetArchiveTableUpdateCompanionBuilder,
      (
        PetArchiveData,
        BaseReferences<_$AppDatabase, $PetArchiveTable, PetArchiveData>,
      ),
      PetArchiveData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CheckInsTableTableManager get checkIns =>
      $$CheckInsTableTableManager(_db, _db.checkIns);
  $$CheckInSymptomsTableTableManager get checkInSymptoms =>
      $$CheckInSymptomsTableTableManager(_db, _db.checkInSymptoms);
  $$SymptomFeverTableTableManager get symptomFever =>
      $$SymptomFeverTableTableManager(_db, _db.symptomFever);
  $$SymptomPainTableTableManager get symptomPain =>
      $$SymptomPainTableTableManager(_db, _db.symptomPain);
  $$SymptomFatigueTableTableManager get symptomFatigue =>
      $$SymptomFatigueTableTableManager(_db, _db.symptomFatigue);
  $$SymptomNauseaTableTableManager get symptomNausea =>
      $$SymptomNauseaTableTableManager(_db, _db.symptomNausea);
  $$SymptomOtherTableTableManager get symptomOther =>
      $$SymptomOtherTableTableManager(_db, _db.symptomOther);
  $$CheckInSubjectiveTableTableManager get checkInSubjective =>
      $$CheckInSubjectiveTableTableManager(_db, _db.checkInSubjective);
  $$PetStateTableTableTableManager get petStateTable =>
      $$PetStateTableTableTableManager(_db, _db.petStateTable);
  $$BaselineStatsTableTableManager get baselineStats =>
      $$BaselineStatsTableTableManager(_db, _db.baselineStats);
  $$AuditLogTableTableManager get auditLog =>
      $$AuditLogTableTableManager(_db, _db.auditLog);
  $$SlmContextCacheTableTableManager get slmContextCache =>
      $$SlmContextCacheTableTableManager(_db, _db.slmContextCache);
  $$PetArchiveTableTableManager get petArchive =>
      $$PetArchiveTableTableManager(_db, _db.petArchive);
}

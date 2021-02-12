// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Path extends DataClass implements Insertable<Path> {
  final String fullPath;
  final Uint8List thumbnails;
  Path({@required this.fullPath, this.thumbnails});
  factory Path.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final uint8ListType = db.typeSystem.forDartType<Uint8List>();
    return Path(
      fullPath: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}full_path']),
      thumbnails: uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}thumbnails']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || fullPath != null) {
      map['full_path'] = Variable<String>(fullPath);
    }
    if (!nullToAbsent || thumbnails != null) {
      map['thumbnails'] = Variable<Uint8List>(thumbnails);
    }
    return map;
  }

  PathsCompanion toCompanion(bool nullToAbsent) {
    return PathsCompanion(
      fullPath: fullPath == null && nullToAbsent
          ? const Value.absent()
          : Value(fullPath),
      thumbnails: thumbnails == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnails),
    );
  }

  factory Path.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Path(
      fullPath: serializer.fromJson<String>(json['fullPath']),
      thumbnails: serializer.fromJson<Uint8List>(json['thumbnails']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fullPath': serializer.toJson<String>(fullPath),
      'thumbnails': serializer.toJson<Uint8List>(thumbnails),
    };
  }

  Path copyWith({String fullPath, Uint8List thumbnails}) => Path(
        fullPath: fullPath ?? this.fullPath,
        thumbnails: thumbnails ?? this.thumbnails,
      );
  @override
  String toString() {
    return (StringBuffer('Path(')
          ..write('fullPath: $fullPath, ')
          ..write('thumbnails: $thumbnails')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(fullPath.hashCode, thumbnails.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Path &&
          other.fullPath == this.fullPath &&
          other.thumbnails == this.thumbnails);
}

class PathsCompanion extends UpdateCompanion<Path> {
  final Value<String> fullPath;
  final Value<Uint8List> thumbnails;
  const PathsCompanion({
    this.fullPath = const Value.absent(),
    this.thumbnails = const Value.absent(),
  });
  PathsCompanion.insert({
    @required String fullPath,
    this.thumbnails = const Value.absent(),
  }) : fullPath = Value(fullPath);
  static Insertable<Path> custom({
    Expression<String> fullPath,
    Expression<Uint8List> thumbnails,
  }) {
    return RawValuesInsertable({
      if (fullPath != null) 'full_path': fullPath,
      if (thumbnails != null) 'thumbnails': thumbnails,
    });
  }

  PathsCompanion copyWith(
      {Value<String> fullPath, Value<Uint8List> thumbnails}) {
    return PathsCompanion(
      fullPath: fullPath ?? this.fullPath,
      thumbnails: thumbnails ?? this.thumbnails,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fullPath.present) {
      map['full_path'] = Variable<String>(fullPath.value);
    }
    if (thumbnails.present) {
      map['thumbnails'] = Variable<Uint8List>(thumbnails.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PathsCompanion(')
          ..write('fullPath: $fullPath, ')
          ..write('thumbnails: $thumbnails')
          ..write(')'))
        .toString();
  }
}

class $PathsTable extends Paths with TableInfo<$PathsTable, Path> {
  final GeneratedDatabase _db;
  final String _alias;
  $PathsTable(this._db, [this._alias]);
  final VerificationMeta _fullPathMeta = const VerificationMeta('fullPath');
  GeneratedTextColumn _fullPath;
  @override
  GeneratedTextColumn get fullPath => _fullPath ??= _constructFullPath();
  GeneratedTextColumn _constructFullPath() {
    return GeneratedTextColumn(
      'full_path',
      $tableName,
      false,
    );
  }

  final VerificationMeta _thumbnailsMeta = const VerificationMeta('thumbnails');
  GeneratedBlobColumn _thumbnails;
  @override
  GeneratedBlobColumn get thumbnails => _thumbnails ??= _constructThumbnails();
  GeneratedBlobColumn _constructThumbnails() {
    return GeneratedBlobColumn(
      'thumbnails',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [fullPath, thumbnails];
  @override
  $PathsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'paths';
  @override
  final String actualTableName = 'paths';
  @override
  VerificationContext validateIntegrity(Insertable<Path> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('full_path')) {
      context.handle(_fullPathMeta,
          fullPath.isAcceptableOrUnknown(data['full_path'], _fullPathMeta));
    } else if (isInserting) {
      context.missing(_fullPathMeta);
    }
    if (data.containsKey('thumbnails')) {
      context.handle(
          _thumbnailsMeta,
          thumbnails.isAcceptableOrUnknown(
              data['thumbnails'], _thumbnailsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {fullPath};
  @override
  Path map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Path.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $PathsTable createAlias(String alias) {
    return $PathsTable(_db, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $PathsTable _paths;
  $PathsTable get paths => _paths ??= $PathsTable(this);
  PathDao _pathDao;
  PathDao get pathDao => _pathDao ??= PathDao(this as Database);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [paths];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$PathDaoMixin on DatabaseAccessor<Database> {
  $PathsTable get paths => attachedDatabase.paths;
}

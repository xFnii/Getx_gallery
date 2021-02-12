// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Path extends DataClass implements Insertable<Path> {
  final String fullPath;
  final String folder;
  Path({@required this.fullPath, @required this.folder});
  factory Path.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return Path(
      fullPath: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}full_path']),
      folder:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}folder']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || fullPath != null) {
      map['full_path'] = Variable<String>(fullPath);
    }
    if (!nullToAbsent || folder != null) {
      map['folder'] = Variable<String>(folder);
    }
    return map;
  }

  PathsCompanion toCompanion(bool nullToAbsent) {
    return PathsCompanion(
      fullPath: fullPath == null && nullToAbsent
          ? const Value.absent()
          : Value(fullPath),
      folder:
          folder == null && nullToAbsent ? const Value.absent() : Value(folder),
    );
  }

  factory Path.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Path(
      fullPath: serializer.fromJson<String>(json['fullPath']),
      folder: serializer.fromJson<String>(json['folder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fullPath': serializer.toJson<String>(fullPath),
      'folder': serializer.toJson<String>(folder),
    };
  }

  Path copyWith({String fullPath, String folder}) => Path(
        fullPath: fullPath ?? this.fullPath,
        folder: folder ?? this.folder,
      );
  @override
  String toString() {
    return (StringBuffer('Path(')
          ..write('fullPath: $fullPath, ')
          ..write('folder: $folder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(fullPath.hashCode, folder.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Path &&
          other.fullPath == this.fullPath &&
          other.folder == this.folder);
}

class PathsCompanion extends UpdateCompanion<Path> {
  final Value<String> fullPath;
  final Value<String> folder;
  const PathsCompanion({
    this.fullPath = const Value.absent(),
    this.folder = const Value.absent(),
  });
  PathsCompanion.insert({
    @required String fullPath,
    @required String folder,
  })  : fullPath = Value(fullPath),
        folder = Value(folder);
  static Insertable<Path> custom({
    Expression<String> fullPath,
    Expression<String> folder,
  }) {
    return RawValuesInsertable({
      if (fullPath != null) 'full_path': fullPath,
      if (folder != null) 'folder': folder,
    });
  }

  PathsCompanion copyWith({Value<String> fullPath, Value<String> folder}) {
    return PathsCompanion(
      fullPath: fullPath ?? this.fullPath,
      folder: folder ?? this.folder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fullPath.present) {
      map['full_path'] = Variable<String>(fullPath.value);
    }
    if (folder.present) {
      map['folder'] = Variable<String>(folder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PathsCompanion(')
          ..write('fullPath: $fullPath, ')
          ..write('folder: $folder')
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

  final VerificationMeta _folderMeta = const VerificationMeta('folder');
  GeneratedTextColumn _folder;
  @override
  GeneratedTextColumn get folder => _folder ??= _constructFolder();
  GeneratedTextColumn _constructFolder() {
    return GeneratedTextColumn(
      'folder',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [fullPath, folder];
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
    if (data.containsKey('folder')) {
      context.handle(_folderMeta,
          folder.isAcceptableOrUnknown(data['folder'], _folderMeta));
    } else if (isInserting) {
      context.missing(_folderMeta);
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

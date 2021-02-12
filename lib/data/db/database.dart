
import 'dart:io';
import 'package:moor/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:moor/moor.dart';

import 'path.dart';

part 'database.g.dart';


LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [Paths], daos: [PathDao])
class Database extends _$Database {
  // we tell the database where to store the data with this constructor
  Database(): super(_openConnection());

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;
}



@UseDao(tables: [Paths])
class PathDao extends DatabaseAccessor<Database> with _$PathDaoMixin {

  PathDao(Database attachedDatabase) : super(attachedDatabase);

  Future addItem(String item) async {
    final folder = item.substring(0, item.lastIndexOf('/'));
    into(paths).insertOnConflictUpdate(Path(fullPath: item));
  }

  Future addItems(List<String> items) async {
    await batch((batch){
      batch.insertAll(paths, [
        for(final i in items)
          PathsCompanion(fullPath: Value(i))
      ]);
    });
  }


  Future<List<Path>> getAll() async {
    return select(paths).get();
  }

  Stream<Path> watch()  {
    return select(paths).watchSingle();
  }

}

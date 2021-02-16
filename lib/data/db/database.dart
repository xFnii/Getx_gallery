
import 'dart:io';
import 'package:getx_gallery/data/db/folders.dart';
import 'package:getx_gallery/resources/converter.dart';
import 'package:getx_gallery/resources/enums/sort_types.dart';
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

@UseMoor(tables: [Paths, Folders], daos: [PathDao, FolderDao])
class Database extends _$Database {
  // we tell the database where to store the data with this constructor
  Database(): super(_openConnection());

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;
}



@UseDao(tables: [Paths, Folders])
class PathDao extends DatabaseAccessor<Database> with _$PathDaoMixin {

  PathDao(Database attachedDatabase) : super(attachedDatabase);

  Future addItem(String item) async {
    into(paths).insertOnConflictUpdate(Path(fullPath: item));
  }

  Future addItems(List<String> items) async {
    await batch((batch){
      batch.insertAll(paths, [
        for(final i in items)
          PathsCompanion(fullPath: Value(i))
      ]);
      batch.insertAllOnConflictUpdate(folders, [
        for(final i in items)
          FoldersCompanion(path: C.fullPathToFolder(i), sortType: SortTypes.name)
      ]);
    });
  }


  Future<List<Paths>> getAll() async {
    return select(paths).get();
  }

  Stream<Path> watch()  {
    return select(paths).watchSingle();
  }
}

@UseDao(tables: [Folders])
class FolderDao extends DatabaseAccessor<Database> with _$PathDaoMixin {

  FolderDao(Database attachedDatabase) : super(attachedDatabase);

  Future addHiddenPath(String item) async {
    into(folders).insertOnConflictUpdate(Folder(path: C.fullPathToFolder(item), hidden: true));
  }


  Future<List<Folder>> getAll() async {
    return select(folders).get();
  }

}

import 'package:moor/moor.dart';

class Paths extends Table {
  TextColumn get fullPath => text()();
  Set<Column> get primaryKey => {fullPath};
}
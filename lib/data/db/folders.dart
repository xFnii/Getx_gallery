import 'package:getx_gallery/resources/enums/sort_types.dart';
import 'package:moor/moor.dart';

class Folders extends Table {
  TextColumn get path => text()();
  BoolColumn get hide => boolean().withDefault(Constant(false))();
  IntColumn get sortType => intEnum<SortTypes>().withDefault(Constant(0))();
  Set<Column> get primaryKey => {path};
}
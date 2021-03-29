import 'package:getx_gallery/data/databases/hive_db/models/path.dart' as hive;

class Path{
  final String fullPath;

  Path({this.fullPath});

  Path.fromHive(hive.Path path)
      :
        fullPath = path.fullPath;
}
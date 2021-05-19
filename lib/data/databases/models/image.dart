import 'dart:typed_data';

import 'package:getx_gallery/data/databases/hive_db/models/models.dart' as hive;
import 'package:getx_gallery/data/entities/entities.dart' as entities;

class Image {
  final String path;
  final String? thumbnailPath;

  Image({required this.path, this.thumbnailPath});

  Image.fromHive(hive.Image image)
      :
        path = image.path,
        thumbnailPath = image.thumbnailPath;

  Image.fromEntity(entities.Image image)
      :
        thumbnailPath = image.thumbnailPath,
        path = image.path;

  hive.Image toHive({String? path, Uint8List? thumbnail, String? thumbnailPath}) => hive.Image(
    path: path ?? this.path,
    thumbnailPath: thumbnailPath ?? this.thumbnailPath
  );

  entities.Image toEntities() => entities.Image(
      path: path,
      thumbnailPath: thumbnailPath ?? ''
  );
}
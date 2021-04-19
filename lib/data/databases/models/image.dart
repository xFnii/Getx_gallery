import 'dart:typed_data';

import 'package:getx_gallery/data/databases/hive_db/models/models.dart' as hive;
import 'package:getx_gallery/data/entities/entities.dart' as entities;

class Image {
  final String path;
  final Uint8List? thumbnail;

  Image({required this.path, this.thumbnail});

  Image.fromHive(hive.Image image)
      :
        path = image.path,
        thumbnail = image.thumbnail;

  Image.fromEntity(entities.Image image)
      :

        path = image.path,
        thumbnail = image.thumbnail;

  hive.Image toHive({String? path, Uint8List? thumbnail}) => hive.Image(
    path: path ?? this.path,
    thumbnail: thumbnail ?? this.thumbnail,
  );

  entities.Image toEntities() => entities.Image(
      path: path,
      thumbnail: thumbnail ?? Uint8List(0),
  );
}
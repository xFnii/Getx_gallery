import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'image.g.dart';

@HiveType(typeId: 2)
class Image{
  @HiveField(0)
  final String path;
  @HiveField(1)
  final String? thumbnailPath;

  Image ({this.path ='', this.thumbnailPath = ''});

  Image copyWith({String? path, String? thumbnailPath})=>Image(
      path: path ?? this.path,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
  );
}
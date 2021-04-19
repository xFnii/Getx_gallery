import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'image.g.dart';

@HiveType(typeId: 2)
class Image{
  @HiveField(0)
  final String path;
  @HiveField(1)
  final Uint8List? thumbnail;

  Image ({this.path ='', this.thumbnail});

  Image copyWith({String? path, Uint8List? thumbnail})=>Image(
      path: path ?? this.path,
      thumbnail: thumbnail ?? this.thumbnail,
  );
}
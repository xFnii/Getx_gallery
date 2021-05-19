import 'dart:typed_data';

class Image {
  final String path;
  final String thumbnailPath;

  Image({required this.path, required this.thumbnailPath});

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    path: json['path'],
    thumbnailPath: json['thumbnailPath']
  );
  Map<String, dynamic> toJson() => {
    'path': path,
    'thumbnailPath': thumbnailPath,
  };

  Image copyWith({
    String? path,
    Uint8List? thumbnail,
    String? thumbnailPath
  })=>Image(
    thumbnailPath: thumbnailPath ?? this.thumbnailPath,
    path: path ?? this.path
  );
}

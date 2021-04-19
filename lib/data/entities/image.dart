import 'dart:typed_data';

class Image {
  final String path;
  final Uint8List thumbnail;

  Image({required this.path, required this.thumbnail});

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    path: json['path'],
    thumbnail: Uint8List.fromList(List<int>.from(json['thumbnail'] ?? []))
  );
  Map<String, dynamic> toJson() => {
    'path': path,
    'thumbnail': thumbnail
  };

  Image copyWith({
    String? path,
    Uint8List? thumbnail})=>Image(
    path: path ?? this.path,
    thumbnail: thumbnail ?? this.thumbnail
  );
}

import 'package:getx_gallery/resources/enums/sort_types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'folder.g.dart';

@JsonSerializable()
class Folder {
  final String name;
  final List<String> paths;
  final bool hidden;
  final SortTypes sortType;

  Folder({ required this.name, required this.paths , required this.hidden, this.sortType = SortTypes.name});

  Folder copyWith({String ?name, List<String> ?paths, bool ?hidden, SortTypes ?sortType})=>
      Folder(
        name: name ?? this.name,
        sortType: sortType ?? this.sortType,
        paths: paths ?? this.paths,
        hidden: hidden ?? this.hidden,
      );

  void addAll(List<String> list) => paths.addAll(list);
  void add(String list) => paths.add(list);

  factory Folder.fromJson(Map<String, dynamic> json) => _$FolderFromJson(json);
  Map<String, dynamic> toJson() => _$FolderToJson(this);
}
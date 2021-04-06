import 'package:flutter/foundation.dart';
import 'package:getx_gallery/data/isolates/sorting_isolate_vanila.dart';
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

  Folder.dummy({this.name = '', this.paths = const [], this.hidden = true, this.sortType = SortTypes.random});

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

  Future<Folder> switchStatus(SortTypes sortType) async {
    switch(sortType){
      case SortTypes.name:
        if(this.sortType==SortTypes.name) {
          return copyWith(sortType: SortTypes.reverseName, paths: await compute(sortIsolate, {'files': paths.toList(), 'type': SortTypes.reverseName.index}) as List<String>);
        } else {
          return copyWith(sortType: SortTypes.name, paths: await compute(sortIsolate, {'files': paths.toList(), 'type': SortTypes.name.index}) as List<String>);
        }
      case SortTypes.date:
        if(this.sortType==SortTypes.date) {
          return copyWith(sortType: SortTypes.reverseDate, paths: await compute(sortIsolate, {'files': paths.toList(), 'type': SortTypes.reverseDate.index}) as List<String>);
        } else {
          return copyWith(sortType: SortTypes.date, paths: await compute(sortIsolate, {'files': paths.toList(), 'type': SortTypes.date.index}) as List<String>);
        }
      case SortTypes.size:
        if(this.sortType==SortTypes.size) {
          return copyWith(sortType: SortTypes.reverseSize, paths: await compute(sortIsolate, {'files': paths.toList(), 'type': SortTypes.reverseSize.index}) as List<String>);
        } else {
          return copyWith(sortType: SortTypes.size, paths: await compute(sortIsolate, {'files': paths.toList(), 'type': SortTypes.size.index}) as List<String>);
        }
      case SortTypes.random:
        return copyWith(sortType: SortTypes.random, paths: await compute(sortIsolate, {'files': paths.toList(), 'type': SortTypes.random.index}) as List<String>);
      default:
        return this;
    }
  }
}
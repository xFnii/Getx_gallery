import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:getx_gallery/data/entities/image.dart';
import 'package:getx_gallery/data/isolates/sorting_isolate_vanila.dart';
import 'package:getx_gallery/resources/enums/sort_types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'folder.g.dart';

@JsonSerializable()
class Folder {
  final String path;
  final List<Image> images;
  final bool hidden;
  final SortTypes sortType;

  Folder({ required this.path, required this.images , required this.hidden, this.sortType = SortTypes.name});

  Folder.dummy({this.path = '', this.images = const [], this.hidden = true, this.sortType = SortTypes.random});

  Folder copyWith({String ?path, List<Image> ?images, bool ?hidden, SortTypes ?sortType})=>
      Folder(
        path: path ?? this.path,
        sortType: sortType ?? this.sortType,
        images: images ?? this.images,
        hidden: hidden ?? this.hidden,
      );

  // Folder addThumbnail(int index, Uint8List thumbnail)=>copyWith(
  //   images: List<Image>.from(images..replaceRange(index, index, images[index].copyWith(thumbnail: thumbnail)))
  // );

  void addThumbnail(int index, Uint8List thumbnail)=> images[index] = images[index].copyWith(thumbnail: thumbnail);


  void addAll(List<String> list) => images.addAll(list.map((e) => Image(path: e, thumbnail: Uint8List(0))).toList());
  void add(String item) => images.add(Image(path: item, thumbnail: Uint8List(0)));

  factory Folder.fromJson(Map<String, dynamic> json) => _$FolderFromJson(json);
  Map<String, dynamic> toJson() => _$FolderToJson(this);

  Future<Folder> switchStatus(SortTypes sortType) async {
    switch(sortType){
      case SortTypes.name:
        if(this.sortType==SortTypes.name) {
          return copyWith(sortType: SortTypes.reverseName, images: await compute(sortIsolate, {'images': images.toList(), 'type': SortTypes.reverseName.index}) as List<Image>);
        } else {
          return copyWith(sortType: SortTypes.name, images: await compute(sortIsolate, {'images': images.toList(), 'type': SortTypes.name.index}) as List<Image>);
        }
      case SortTypes.date:
        if(this.sortType==SortTypes.date) {
          return copyWith(sortType: SortTypes.reverseDate, images: await compute(sortIsolate, {'images': images.toList(), 'type': SortTypes.reverseDate.index}) as List<Image>);
        } else {
          return copyWith(sortType: SortTypes.date, images: await compute(sortIsolate, {'images': images.toList(), 'type': SortTypes.date.index}) as List<Image>);
        }
      case SortTypes.size:
        if(this.sortType==SortTypes.size) {
          return copyWith(sortType: SortTypes.reverseSize, images: await compute(sortIsolate, {'images': images.toList(), 'type': SortTypes.reverseSize.index}) as List<Image>);
        } else {
          return copyWith(sortType: SortTypes.size, images: await compute(sortIsolate, {'images': images.toList(), 'type': SortTypes.size.index}) as List<Image>);
        }
      case SortTypes.random:
        return copyWith(sortType: SortTypes.random, images: await compute(sortIsolate, {'images': images.toList(), 'type': SortTypes.random.index}) as List<Image>);
      default:
        return this;
    }
  }
}
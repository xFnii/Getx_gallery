import 'package:getx_gallery/data/entities/image.dart';
import 'package:getx_gallery/resources/enums/sort_types.dart';
import 'package:getx_gallery/resources/sort_images.dart';
import 'package:json_annotation/json_annotation.dart';

part 'folder.g.dart';

@JsonSerializable()
class Folder {
  final String path;
  final List<Image> images;
  final bool hidden;
  final SortTypes sortType;

  Folder({ required this.path, required this.images , required this.hidden, this.sortType = SortTypes.undefined});

  Folder.dummy({this.path = '', this.images = const [], this.hidden = true, this.sortType = SortTypes.random});

  Folder copyWith({String ?path, List<Image> ?images, bool ?hidden, SortTypes ?sortType})=>
      Folder(
        path: path ?? this.path,
        sortType: sortType ?? this.sortType,
        images: images ?? this.images,
        hidden: hidden ?? this.hidden,
      );

  void addThumbnail(int index, String thumbnailPath)=> images[index] = images[index].copyWith(thumbnailPath: thumbnailPath);


  void addAll(List<String> list) => images.addAll(list.map((e) => Image(path: e, thumbnailPath: '')).toList());
  void add(String item) => images.add(Image(path: item, thumbnailPath: ''));

  factory Folder.fromJson(Map<String, dynamic> json) => _$FolderFromJson(json);
  Map<String, dynamic> toJson() => _$FolderToJson(this);

  Future<Folder> switchStatus(SortTypes sortType) async {
    switch(sortType){
      case SortTypes.name:
        if(this.sortType==SortTypes.name) {
          return copyWith(sortType: SortTypes.reverseName, images: SortImages.sort(images: images.toList(), type: SortTypes.reverseName));
        } else {
          return copyWith(sortType: SortTypes.name, images: SortImages.sort(images: images.toList(), type: SortTypes.name));
        }
      case SortTypes.date:
        if(this.sortType==SortTypes.date) {
          return copyWith(sortType: SortTypes.reverseDate, images: SortImages.sort(images: images.toList(), type: SortTypes.reverseDate));
        } else {
          return copyWith(sortType: SortTypes.date, images: SortImages.sort(images: images.toList(), type: SortTypes.date));
        }
      case SortTypes.size:
        if(this.sortType==SortTypes.size) {
          return copyWith(sortType: SortTypes.reverseSize, images: SortImages.sort(images: images.toList(), type: SortTypes.reverseSize));
        } else {
          return copyWith(sortType: SortTypes.size, images: SortImages.sort(images: images.toList(), type: SortTypes.size));
        }
      case SortTypes.random:
        return copyWith(sortType: SortTypes.random, images: SortImages.sort(images: images.toList(), type: SortTypes.random));
      default:
        return this;
    }
  }
}
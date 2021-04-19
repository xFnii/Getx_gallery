import 'dart:io';

import 'package:getx_gallery/data/entities/image.dart';
import 'package:getx_gallery/resources/converter.dart';
import 'package:getx_gallery/resources/enums/sort_types.dart';

sortIsolate(data) async {
  final type = SortTypes.values[data['type'] as int];
  final images = List<Image>.from(data['images']);
  switch(type) {
    case SortTypes.date:
      final sortingList = images.map((e) => SortingAdapter(e, File(e.path).statSync())).toList();
      sortingList.sort((a,b)=> a.fileStat.changed.compareTo(b.fileStat.changed));
      return sortingList.map((e) => e.image).toList();
    case SortTypes.reverseDate:
      final sortingList = images.map((e) => SortingAdapter(e, File(e.path).statSync())).toList();
      sortingList.sort((b,a)=> a.fileStat.changed.compareTo(b.fileStat.changed));
      return sortingList.map((e) => e.image).toList();
    case SortTypes.name:
      images.sort((a,b)=> C.fullPathToFile(a.path).compareTo(C.fullPathToFile(b.path)));
      return images;
    case SortTypes.reverseName:
      images.sort((b,a)=> C.fullPathToFile(a.path).compareTo(C.fullPathToFile(b.path)));
      return images;
    case SortTypes.size:
      final sortingList = images.map((e) => SortingAdapter(e, File(e.path).statSync())).toList();
      sortingList.sort((a,b)=> a.fileStat.size.compareTo(b.fileStat.size));
      return sortingList.map((e) => e.image).toList();
    case SortTypes.reverseSize:
      final sortingList = images.map((e) => SortingAdapter(e, File(e.path).statSync())).toList();
      sortingList.sort((b,a)=> a.fileStat.size.compareTo(b.fileStat.size));
      return sortingList.map((e) => e.image).toList();
    case SortTypes.random:
      images.shuffle();
      return images;
  }
}

class SortingAdapter{
  final Image image;
  final FileStat fileStat;

  SortingAdapter(this.image, this.fileStat);
}